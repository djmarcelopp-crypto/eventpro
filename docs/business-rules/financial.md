# Regras de negócio — Financeiro

## Visão geral

O módulo **Financeiro** registra receitas e despesas da empresa de eventos, com categorias tipadas, status de pagamento, vínculo opcional a um orçamento existente e indicadores/relatórios calculados de forma determinística.

- Persistência local: Drift/SQLite (`schemaVersion` **4**).
- Valores monetários: sempre em **centavos** (`int`), alinhados a Orçamentos.
- Uma única entidade de lançamento (`FinancialEntry`) para receita e despesa, discriminada por `FinancialFlowKind`.
- Agregações (resumo global, por orçamento, relatório por período) vivem em **calculadoras/serviços testáveis** — a UI não recalcula indicadores.

Documento de task: `docs/tasks/TASK-027.md`.

---

## Modelagem

### `FinancialFlowKind`

| Valor | Label | Uso |
|-------|-------|-----|
| `income` | Receita | Entrada de caixa |
| `expense` | Despesa | Saída de caixa |

Compartilhado por `FinancialCategory` e `FinancialEntry`.

### `FinancialEntryStatus`

| Valor | Label | Regra com `paidAt` |
|-------|-------|--------------------|
| `pending` | Pendente | `paidAt` **deve** ser `null` |
| `paid` | Pago | `paidAt` **deve** ser não-nulo |

### `FinancialCategory`

| Campo | Regra |
|-------|--------|
| `name` | Obrigatório (validador) |
| `kind` | Fixo: receita **ou** despesa |
| `active` | Default `true`; categoria inativa não pode receber novos lançamentos |
| Exclusão | Bloqueada se existir qualquer lançamento com aquele `categoryId` |

### `FinancialEntry`

| Campo | Regra |
|-------|--------|
| `kind` | `income` ou `expense` |
| `description` | Obrigatório |
| `amountCents` | Inteiro **> 0**; o sinal econômico vem de `kind`, nunca do valor |
| `date` | Data civil de competência (sem hora) |
| `categoryId` | Obrigatório; categoria deve existir, estar ativa e ter o **mesmo** `kind` |
| `status` / `paidAt` | Ver seção Status × paidAt |
| `quoteId` | Opcional; referência a `Quote.id` (sem duplicar dados do evento) |
| `notes` | Opcional |

---

## Status × `paidAt`

Enforced em `FinancialEntryService` (não no repositório):

1. Ao marcar como **pago** sem informar `paidAt`, o serviço preenche com o **relógio injetável**.
2. Ao marcar como **pago** com `paidAt` explícito, o valor informado é **preservado**.
3. Ao voltar para **pendente**, `paidAt` é **limpo** (`null`), mesmo que o rascunho trouxesse um valor.
4. Não usar `DateTime.now()` diretamente nas regras — apenas via `clock` / `financialClockProvider`.

---

## Regras de categoria

1. Categoria **deve existir** no create/update do lançamento.
2. Categoria **deve estar ativa**.
3. `category.kind` **deve coincidir** com `entry.kind`.
4. Categoria **em uso** não pode ser excluída (resultado de domínio com contagem de bloqueio).
5. Nome continua validado pelo `FinancialCategoryValidator`.

No banco: FK `financial_entries.category_id` → `financial_categories` com `ON DELETE RESTRICT`.

---

## Integração com Orçamentos (`quoteId`)

- `quoteId` aponta para `Quotes.id` — **fonte da verdade** do evento permanece o orçamento.
- `null` = lançamento geral (overhead da empresa), sem evento.
- FK Drift: `ON DELETE SET NULL` — excluir o orçamento **não** apaga o lançamento; apenas desvincula.
- Sem cascade delete; sem cópia de cliente/evento/itens no Financeiro.
- Consulta: `FinancialEntryRepository.listByQuoteId`.
- Resumo por orçamento: `FinancialEventSummaryCalculator` / `FinancialEventSummaryService` (receita, despesa, **lucro** = receita − despesa).

> Distinção: o resumo financeiro **dentro do Orçamento** (totais da proposta comercial / PDF) é outro conceito (`Quote` line items). O resumo por evento do Financeiro agrega **lançamentos** vinculados via `quoteId`.

---

## Persistência Drift

| Tabela | Conteúdo |
|--------|----------|
| `financial_categories` | Categorias tipadas |
| `financial_entries` | Lançamentos (+ `quote_id` desde v4) |

Índices relevantes: kind (categorias e lançamentos), date, `quote_id`.

### Migrações até `schemaVersion` 4

| Transição | Task / CP | Ação |
|-----------|-----------|------|
| v1 → v2 | TASK-025 CP-A | Cria `agenda_blocks` |
| v2 → v3 (e salto v1→v3) | TASK-027 CP-B | Cria `financial_categories` e `financial_entries` |
| v3 → v4 | TASK-027 CP-D | Adiciona `quote_id` em `financial_entries` (`from == 3` estrito) |

Salto v1/v2 → v4: `createTable(financial_entries)` já inclui `quote_id`; o `addColumn` da v3→v4 **não** executa nesse salto (evita coluna duplicada).

---

## Resumo financeiro global

- Calculadora: `FinancialGlobalSummaryCalculator` sobre uma lista de lançamentos.
- Campos: `totalIncomeCents`, `totalExpenseCents`, `pendingCents` (soma dos valores ainda pendentes), `balanceCents` = receitas − despesas.
- Na UI da lista: `financialGlobalSummaryProvider` usa a lista **já filtrada** pelos filtros da tela.
- Widgets **não** recalculam — apenas apresentam o resultado.

---

## Filtros da lista

`FinancialEntryFilters` + `FinancialEntryFilter` (puro):

- Período civil (`periodStart` / `periodEnd`)
- Tipo (`kind`)
- Status (`status`)

Aplicados em `financialFilteredEntriesProvider`. Independentes do período do **relatório**.

---

## Relatórios por período

Presets (`FinancialReportPeriodKind`):

- **Mês atual**
- **Ano atual**
- **Personalizado** (início e fim escolhidos pelo usuário)

Resolução de janela: `FinancialReportPeriodResolver` + relógio injetável.

Indicadores do `FinancialPeriodReport` (via `FinancialPeriodReportCalculator`, reusando filtro + calculator global):

- Receitas, despesas, saldo
- Quantidade de lançamentos
- Quantidade de lançamentos pendentes
- Totais por categoria (ordenados por valor)
- **Evolução mensal** (`FinancialMonthlyEvolutionPoint`) — série pronta para gráficos futuros; nesta fase exibida em formato textual/tabelar

Fonte de dados do relatório: **lista completa** de lançamentos (não a lista filtrada da tela).

---

## Camadas e responsabilidades

| Camada | Responsabilidade |
|--------|------------------|
| Domain / utils | Modelos, validadores, filters, calculators, services |
| Data | Mappers + Drift repositories (CRUD / listagens) |
| Providers | Estado AsyncNotifier, filtros, queries de relatório, DI |
| UI | Telas e widgets; apresentação e navegação |

Rotas: `/financial`, `/financial/new`, `/financial/categories`, `/financial/:id`, `/financial/:id/edit`.

---

## Fora de escopo (evolução futura)

Registrado sem implementação nesta fase:

- Gráficos (charts)
- Exportações PDF / Excel / CSV
- Múltiplas moedas
- Centros de custo
- Conciliação bancária
- Integrações fiscais
- Dashboards financeiros avançados
- Hidratação no bootstrap do app
- UI do resumo por orçamento embutida na tela de Quotes
- Sincronização online / Firebase

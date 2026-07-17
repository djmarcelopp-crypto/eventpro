# TASK-027 — Módulo Financeiro

## Objetivo

Criar o módulo **Financeiro** do EventPro ERP: categorias e lançamentos de receita/despesa persistidos localmente (Drift/SQLite), regras de negócio testáveis, vínculo opcional com orçamentos existentes (`Quote.id` por referência), resumo global, filtros, resumo por evento/orçamento e relatórios por período — sem gráficos, sem exportações e sem alterar Agenda nem as regras de Orçamentos.

**Branch:** `cursor/task-027-financeiro`

**Origem:** necessidade do MVP de controlar receitas e despesas da empresa de eventos, reutilizando orçamentos já persistidos (TASK-024) como âncora opcional de evento, sem duplicar dados.

## Arquitetura do fluxo

```text
UI (FinancialScreen, formulários, categorias, painel de relatório)
      │
      ▼
Providers / Notifiers (Riverpod)
  financialEntriesProvider / financialCategoriesProvider
  financialEntryFiltersProvider → financialFilteredEntriesProvider
  financialGlobalSummaryProvider
  financialReportQueryProvider → financialPeriodReportProvider
      │
      ▼
Services (casos de uso — regras de negócio)
  FinancialEntryService / FinancialCategoryService
  FinancialEventSummaryService
  FinancialPeriodReportService
      │
      ├─► Calculators / filters puros (sem I/O)
      │     FinancialGlobalSummaryCalculator
      │     FinancialEventSummaryCalculator
      │     FinancialEntryFilter
      │     FinancialPeriodReportCalculator
      │     FinancialReportPeriodResolver
      │
      └─► Repositories (somente leitura/escrita)
            DriftFinancialEntryRepository
            DriftFinancialCategoryRepository
                  │
                  ▼
            DAOs → SQLite (schemaVersion 4)
```

- **Domínio puro (CP-A):** entidades, enums, validadores e contratos de repositório.
- **Persistência (CP-B / CP-D):** tabelas Drift, DAOs, mappers, migrações v2→v3 e v3→v4.
- **Serviços (CP-C / CP-D / CP-F):** regras fora de repositórios/DAOs; agregações em calculadoras testáveis.
- **Providers + UI (CP-E / CP-F):** orquestração e apresentação — **nenhum cálculo de dinheiro na UI**.
- **Carregamento:** sob demanda via `AsyncNotifier.build()` ao abrir o módulo — **não** hidratado no `appBootstrapProvider` nesta task.

## Checkpoints

| CP | Descrição | Commit | Status |
|----|-----------|--------|--------|
| A | Fundação do domínio (entidades, enums, validadores, contratos) | `da2867f` | ✅ Concluído |
| B | Persistência Drift — tabelas, DAOs, mappers, migração v2→v3 | `0ac8239` | ✅ Concluído |
| C | Casos de uso — categorias, lançamentos, status × paidAt | `839afae` | ✅ Concluído |
| D | Vínculo `quoteId` + resumo por orçamento (schema v3→v4) | `cb72215` | ✅ Concluído |
| E | UI, providers, resumo global e filtros | `0923014` | ✅ Concluído |
| F | Relatórios por período (reuso de filtros/calculadoras) | `936e952` | ✅ Concluído |
| G | Documentação final — este documento, `docs/business-rules/financial.md`, revisão de `ARCHITECTURE.md`/`PROJECT.md`/`TASKS.md`/`docs/roadmap.md` | *(pendente de aprovação/commit)* | ✅ Concluído |

**TASK-027 encerrada.** Histórico completo dos checkpoints abaixo.

### Checkpoint A — Fundação do domínio ✅

- Entidade única `FinancialEntry` com discriminador `FinancialFlowKind` (`income` / `expense`) — sem classes separadas de receita/despesa
- `FinancialCategory`, `FinancialEntryStatus` (`pending` / `paid`)
- Validadores de campos (`FinancialCategoryValidator`, `FinancialEntryValidator`)
- Contratos abstratos `FinancialCategoryRepository` e `FinancialEntryRepository` — sem Drift, providers ou UI

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com **1048** testes passando.

**Commit:** `da2867f` — `feat(financial): create financial domain foundation`

### Checkpoint B — Persistência Drift ✅

- Tabelas `financial_categories` e `financial_entries` (apenas duas)
- DAOs, mappers e `Drift*Repository` implementando os contratos do CP-A
- `schemaVersion` **2 → 3**; `onUpgrade` cria as tabelas financeiras; snapshots legados e testes de migração real (v2→v3 e salto v1→v3)

**Verificação:** `flutter analyze` sem apontamentos; `flutter test` com **1071** testes passando.

**Commit:** `0ac8239` — `feat(financial): persist financial categories and entries with Drift`

### Checkpoint C — Casos de uso e regras de negócio ✅

- `FinancialEntryService` / `FinancialCategoryService` (Dart puro, relógio injetável)
- Result objects para create/update/delete (sem exceção para fluxos esperados)
- Regras: categoria existe/ativa/`kind` compatível; exclusão bloqueada se em uso; `pending` ⇒ `paidAt == null`; `paid` ⇒ `paidAt` preenchido
- Schema, providers e UI **inalterados**

**Verificação:** `flutter analyze` sem erros/warnings (infos de estilo pré-existentes); `flutter test` com **1100** testes passando.

**Commit:** `839afae` — `feat(financial): implement financial entry and category use cases`

### Checkpoint D — Vínculo com orçamento e resumo por evento ✅

- Coluna opcional `quote_id` em `financial_entries` (`schemaVersion` **3 → 4**)
- FK para `Quotes.id` com `ON DELETE SET NULL` — referência sem cascade e sem duplicar dados do evento
- `listByQuoteId`; `FinancialEventSummaryCalculator` + `FinancialEventSummaryService` (receita, despesa, lucro)
- Snapshot legado v3 + teste de migração; Agenda e regras de Orçamentos intocadas

**Verificação:** `flutter analyze` sem erros/warnings; `flutter test` com **1123** testes passando.

**Commit:** `cb72215` — `feat(financial): link entries to quotes and compute event summaries`

### Checkpoint E — UI, providers, resumo global e filtros ✅

- Providers Riverpod (repos, services, clock, entries/categories, filtros, lista filtrada, resumo global)
- Telas: lista Financeiro, novo/editar lançamento, detalhe, categorias; módulo no Dashboard; rotas `/financial/*`
- `FinancialGlobalSummaryCalculator` + cards (receitas, despesas, saldo, pendentes em valor)
- Filtros de lista por período, tipo e status — agregação **fora** dos widgets
- Schema/migrações **inalterados** (permanece v4)

**Verificação:** `flutter analyze` sem erros/warnings; `flutter test` com **1146** testes passando.

**Commit:** `0923014` — `feat(financial): add financial module UI with summary and filters`

### Checkpoint F — Relatórios por período ✅

- Presets: mês atual, ano atual, período personalizado (`FinancialReportPeriodResolver` + clock)
- `FinancialPeriodReportCalculator` / `Service` reutilizam `FinancialEntryFilter` e `FinancialGlobalSummaryCalculator` — sem duplicar matemática de receita/despesa/saldo
- Indicadores do relatório: receitas, despesas, saldo, quantidade de lançamentos, quantidade de pendentes; totais por categoria ordenados por valor; evolução mensal tabular (`FinancialMonthlyEvolutionPoint`)
- `FinancialReportPanel` na `FinancialScreen` (texto/tabela); período do relatório **independente** dos filtros da lista
- Sem gráficos, sem PDF/Excel/CSV, sem alteração de schema

**Verificação:** `flutter analyze` sem erros/warnings; `flutter test` com **1163** testes passando.

**Commit:** `936e952` — `feat(financial): add period reports reusing existing summary calculators`

### Checkpoint G — Documentação final e encerramento ✅

**Escopo entregue:**

- Este documento (`docs/tasks/TASK-027.md`), consolidando os 7 checkpoints (A–G)
- `docs/business-rules/financial.md` — regras de negócio do módulo
- `ARCHITECTURE.md`, `PROJECT.md`, `TASKS.md` e `docs/roadmap.md` atualizados com o encerramento da TASK-027
- Nenhuma alteração em `lib/`, `test/`, schema, providers, repositories, DAOs ou UI — checkpoint exclusivamente documental

**Verificação:** `flutter analyze` e `flutter test` com **1163** testes (suíte inalterada neste checkpoint).

**Commit:** *(pendente de aprovação/commit)*

## Arquivos principais da task

```text
lib/features/financial/
  models/          # Entry, Category, enums, summaries, report models, result objects
  data/
    mappers/
    repositories/  # interfaces + Drift*
  utils/           # validators, services, filters, calculators, formatters
  providers/
  widgets/
  *_screen.dart

lib/core/database/
  tables.dart                    # FinancialCategories, FinancialEntries (+ quoteId)
  app_database.dart              # schemaVersion 4, onUpgrade v2→v3 e v3→v4
  daos/financial_*_dao.dart

test/features/financial/         # unitários, providers, widgets, fakes
test/core/database/
  financial_migration_test.dart
  legacy_schema/legacy_*_v2|v3*
```

## Testes e verificação

| Checkpoint | Testes totais |
|---|---|
| CP-A | 1048 |
| CP-B | 1071 |
| CP-C | 1100 |
| CP-D | 1123 |
| CP-E | 1146 |
| CP-F | 1163 |
| CP-G | 1163 (inalterado — checkpoint documental) |

Todos os checkpoints de código executaram `flutter analyze` e `flutter test` completos antes do commit, conforme `CLAUDE.md`. A suíte cresceu de **1016** (fim da TASK-026) para **1163** testes (+147 nos checkpoints A–F).

## Fora de escopo geral da TASK-027 (evolução futura)

- Gráficos (bibliotecas de charts) — apenas estrutura de evolução mensal tabular
- Exportações PDF, Excel ou CSV
- Múltiplas moedas
- Centros de custo
- Conciliação bancária
- Integrações fiscais / NF-e
- Dashboards financeiros avançados
- Hidratação do Financeiro no bootstrap do app (carregamento sob demanda nesta fase)
- Provider/UI dedicados ao resumo por orçamento na tela de Quotes (serviço/calculator existem; wiring de UI em Quotes ficou fora)
- Sincronização online / Firebase

## Lições Aprendidas

### Entidade única com discriminador antes de persistir

Modelar receita e despesa como um único `FinancialEntry` + `FinancialFlowKind` (em vez de duas hierarquias) simplificou schema (duas tabelas), UI, filtros e relatórios. A decisão no CP-A evitou refatoração cara nos checkpoints seguintes.

### Regras nos serviços; repositórios só persistem

Centralizar categoria/`kind`, status × `paidAt` e geração de IDs/timestamps em `FinancialEntryService` / `FinancialCategoryService` manteve DAOs e mappers burros e testáveis com fakes — o mesmo padrão da Agenda, agora sem Notifier no CP-C.

### Relógio injetável desde as regras de pagamento

Preencher `paidAt` e timestamps via `clock` injetável (depois exposto como `financialClockProvider`) tornou testes determinísticos e alinhou o Financeiro ao padrão da Agenda Inteligente.

### Agregar em calculadoras puras; UI só apresenta

`FinancialGlobalSummaryCalculator`, `FinancialEventSummaryCalculator` e `FinancialPeriodReportCalculator` concentraram a matemática. O CP-F reusou filtro + calculator global em vez de recalcular receita/despesa — regressões de UI (lista lazy abaixo do painel) foram resolvidas nos testes com `dragUntilVisible`, sem mover lógica para widgets.

### Migrações reais com salto de versão documentado

v2→v3 (criar tabelas) e v3→v4 (`addColumn` só com `from == 3`) + snapshots legados evitaram a armadilha de coluna duplicada no salto v1/v2→v4. A política da TASK-024/025 foi revalidada na prática.

### Referência a `Quote.id` sem duplicar o evento

`quoteId` opcional com `SET NULL` preserva o orçamento como fonte da verdade do evento e permite lançamentos gerais (`null`) sem inventar uma entidade “Evento financeiro”.

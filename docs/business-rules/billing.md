# Regras de negócio — Faturamento & Documentos Fiscais

## Visão geral

O módulo **Faturamento** gerencia faturas vinculadas a orçamentos, itens de linha, ciclo de vida interno de status (`draft → issued → paid`), cancelamento controlado, totais consistentes e um resumo financeiro **derivado** para o dashboard/orçamento.

- Persistência local: Drift/SQLite (`schemaVersion` **12**).
- PDF, NF-e/NFS-e, boleto, PIX, bancos e conciliação estão **fora do escopo** desta fase.
- Integração com Financeiro é **desacoplada**: não cria `FinancialEntry` automaticamente.

Documento de task: `docs/tasks/TASK-032.md`.

---

## Modelagem

### `InvoiceStatus`

| Valor | Label | Papel |
|-------|-------|--------|
| `draft` | Rascunho | Criado; ainda não emitido |
| `issued` | Emitida | Emitida; aguarda pagamento |
| `paid` | Paga | Estado terminal positivo |
| `cancelled` | Cancelada | Estado terminal negativo |

### `InvoiceType`

| Valor | Label |
|-------|-------|
| `service` | Serviço |
| `product` | Produto |
| `mixed` | Misto |

### `Invoice`

| Campo | Regra |
|-------|--------|
| `quoteId` | Orçamento deve existir; FK **RESTRICT** |
| `invoiceNumber` | Obrigatório; único (case-insensitive); gerado como `INV-YYYY-####` quando omitido/blank |
| `type` | Um de `InvoiceType` |
| `status` | Um de `InvoiceStatus` |
| `subtotalCents` / `taxCents` / `discountCents` / `totalCents` | Totais em centavos; **sempre** recalculados pelo serviço |
| `issueDate` / `dueDate` / `paidAt` | Timestamps opcionais conforme o fluxo |
| `notes` | Texto; default `''` |

### `InvoiceItem`

| Campo | Regra |
|-------|--------|
| `invoiceId` | FK **CASCADE** (itens somem com a fatura) |
| `description` | Obrigatório |
| `quantity` | > 0 |
| `unitPriceCents` | ≥ 0 |
| `totalPriceCents` | `quantity × unitPrice` (recomputado) |

### DTOs computados (não persistidos)

| DTO | Papel |
|-----|--------|
| `QuoteInvoiceSummary` | Faturas do orçamento, status mais recente, flags agregadas |
| `InvoiceListSummary` | Contagens e totais para listagem/dashboard |
| `InvoiceFinancialSummary` | Billed / paid / pending / cancelled por `quoteId` (visão Financeiro) |
| `InvoiceWorkflowSummary` | `canIssue` / `canMarkPaid` / `canCancel` / `isFinal` / `nextStatus` / `blockReason` |

---

## Numeração

- Omitido ou blank → gera `INV-YYYY-####` (ano do clock; sequência anual).
- Informado → usa valor trimado; deve ser único case-insensitive.
- Unicidade via `listAll()` — suficiente para SQLite local do MVP.

---

## Cálculo de totais

```text
lineTotal = round(quantity × unitPriceCents)
subtotal  = Σ lineTotals
total     = subtotal + taxCents − discountCents
```

- UI **nunca** calcula totais.
- `InvoiceService` valida itens antes de escrever; se insert de item falhar após insert da fatura, a fatura é removida (CASCADE limpa itens parciais).

---

## Fluxo de faturamento

### Happy path

```text
draft → issued → paid
```

### Cancelamento

Permitido a partir de: `draft`, `issued`.

Bloqueado a partir de: `paid`, `cancelled`.

### Bloqueios obrigatórios

| Situação | Resultado |
|----------|-----------|
| Pagar fatura cancelada | Bloqueado (`cannotPayCancelled`) |
| Cancelar fatura paga | Bloqueado (`cannotCancelPaid`) |
| Regressão (ex.: `issued` → `draft`) | Bloqueado (`invalidTransition`) |
| Transição repetida (ex.: emitir duas vezes) | Bloqueado (`invalidTransition`) |

**Fonte única da matriz:** `InvoiceStatusTransitions`
(`forwardTransitions`, `cancellableStatuses`, `canTransition`, `wouldRegress`).

`InvoiceWorkflowService` **consulta** essa matriz e produz `InvoiceWorkflowSummary`
para a UI. Persistência das transições autorizadas fica em `InvoiceService`
(`issue` / `markPaid` / `cancel`).

---

## Integração com Orçamentos

- `QuoteInvoiceService.generateForQuote` cria rascunho e **emite** imediatamente.
- Detalhe do orçamento: seção “Faturamento” → `QuoteInvoicesScreen`.
- Ações (emitir/pagar/cancelar) habilitadas via `invoiceWorkflowSummaryProvider`.

---

## Integração com Financeiro (desacoplada)

- `InvoiceFinancialSummaryService.forQuote(quoteId)` agrega totais/contagens.
- **Não** cria, atualiza nem remove `FinancialEntry`.
- Uso: cards no dashboard e resumo no orçamento.

---

## Integrações de UI

| Superfície | Comportamento |
|------------|----------------|
| Detalhe do orçamento | Seção “Faturamento” → gerenciar faturas |
| Dashboard | Atalho do módulo + cards (rascunhos/emitidos/pagos/cancelados + totais) |
| Router | `/invoices`, `/invoices/new`, `/invoices/:id`, `/quotes/:id/invoices` |

---

## Limitações atuais / dívidas técnicas

- Sem emissão fiscal real (NF-e/NFS-e).
- Sem PDF da fatura.
- Sem boleto, PIX, gateway ou banco.
- Sem conciliação automática, webhook ou envio externo.
- Sem hidratação no bootstrap.
- Sem lançamento financeiro automático a partir da fatura.
- Unicidade de número baseada em `listAll()` (ok para MVP local).

## Itens futuros

- PDF da fatura
- NF-e / NFS-e
- Boleto / PIX / bancos
- Conciliação e webhooks
- Escrita opcional no módulo Financeiro (com regras explícitas)

# Regras de negócio — Contratos & Assinaturas

## Visão geral

O módulo **Contratos & Assinaturas** gerencia modelos reutilizáveis, contratos vinculados a orçamentos e o **ciclo de vida interno de status** (rascunho → gerado → enviado → assinado), com cancelamento e expiração controlados.

- Persistência local: Drift/SQLite (`schemaVersion` **11**).
- PDF, assinatura digital e integrações externas estão **fora do escopo** desta fase.
- `ContractSignatureStatus` existe no domínio para evolução futura, mas **não** é persistido como coluna do contrato nesta task.

Documento de task: `docs/tasks/TASK-031.md`.

---

## Modelagem

### `ContractStatus`

| Valor | Label | Papel |
|-------|-------|--------|
| `draft` | Rascunho | Criado; ainda não “gerado” |
| `generated` | Gerado | Pronto para envio (sem PDF nesta fase) |
| `sent` | Enviado | Marcado como enviado ao cliente |
| `signed` | Assinado | Estado terminal positivo |
| `cancelled` | Cancelado | Estado terminal negativo |
| `expired` | Expirado | Estado terminal por prazo |

### `ContractTemplate`

| Campo | Regra |
|-------|--------|
| `name` | Obrigatório; único case-insensitive entre templates |
| `description` | Opcional |
| `active` | Default `true`; template inativo não pode ser usado em novos contratos |
| Exclusão | Bloqueada se existir qualquer contrato referenciando o template |

### `Contract`

| Campo | Regra |
|-------|--------|
| `quoteId` | Orçamento deve existir; FK **RESTRICT** |
| `templateId` | Opcional; se informado, template deve existir e estar **ativo**; FK **SET NULL** |
| `contractNumber` | Obrigatório; único; gerado como `CTR-YYYY-####` quando omitido |
| `status` | Um de `ContractStatus` |
| `generatedAt` / `sentAt` / `signedAt` / `expiresAt` | Timestamps opcionais conforme o fluxo |
| `filePath` | Reservado para PDF futuro (pode ficar nulo) |
| `notes` | Texto; default `''` |

### `QuoteContractSummary` (computado / DTO)

Agrega contratos de um orçamento: contagem, status mais recente, flags de assinatura e cancelabilidade. **Não** é tabela.

### `ContractWorkflowSummary` (computado / DTO)

Lista próximos status permitidos e flags (`canGenerate`, `canMarkSent`, `canSign`, `canCancel`, `canExpire`). **Não** é persistido.

---

## Fluxo contratual

### Happy path

```text
draft → generated → sent → signed
```

### Cancelamento

Permitido a partir de: `draft`, `generated`, `sent`.

Bloqueado a partir de: `signed`, `cancelled`, `expired`.

### Expiração

Permitida a partir de: `generated`, `sent`.

**Nunca** a partir de: `signed` (nem `draft` / terminais).

### Bloqueios obrigatórios

| Situação | Resultado |
|----------|-----------|
| Assinar após cancelamento | Bloqueado (`cannotSignCancelled`) |
| Cancelar após assinatura | Bloqueado (`cannotCancelSigned`) |
| Regressão no happy path (ex.: `sent` → `generated`) | Bloqueado (`invalidTransition`) |
| Expirar contrato assinado | Bloqueado (`invalidTransition`) |

**Fonte única da matriz:** `ContractWorkflowService` (`forwardTransitions`,
`cancellableStatuses`, `expirableStatuses`, `canTransition`, `wouldRegress`).

`ContractService` **não** revalida transições: apenas cria/atualiza notas,
aplica timestamps (`createdAt` preservado, `updatedAt` via clock) e persiste
via repository (`applyGenerated` / `applySent` / `applySigned` /
`applyCancelled` / `applyExpired`) após o workflow autorizar a mudança.

---

## Regras de serviço (resumo)

- Número de contrato único (case-insensitive) após normalização.
- Template inativo / inexistente bloqueia criação com `templateId`.
- Exclusão de template bloqueada se em uso.
- Orçamento inexistente bloqueia criação.
- UI **não** contém regras de transição — apenas apresenta Result Objects.

---

## Integrações

| Superfície | Comportamento |
|------------|----------------|
| Detalhe do orçamento | Seção “Contrato” → `QuoteContractsScreen` (gerar, status, cancelar, datas) |
| Dashboard | Atalho do módulo + cards (rascunho / enviados / assinados / expirados) |
| Router | `/contracts`, `/contracts/templates`, `/contracts/:id`, `/quotes/:id/contracts` |

---

## Limitações atuais

- Sem geração de PDF.
- Sem assinatura digital / provedores externos.
- Sem envio automático (e-mail/WhatsApp).
- Sem hidratação no bootstrap.
- `ContractSignatureStatus` ainda não persistido no contrato.

---

## Evolução futura

- PDF do contrato e armazenamento em `filePath`.
- Assinatura digital e persistência de `ContractSignatureStatus`.
- Auditoria de eventos de assinatura.
- Notificações de envio/expiração.
- Hidratação opcional no bootstrap, se necessário.

Arquitetura: `ARCHITECTURE.md` (feature `contracts/`, schema v11). Task: `docs/tasks/TASK-031.md`.

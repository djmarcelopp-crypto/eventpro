# Assistente EventPRO — Transaction Audit Trail (AI-015)

Auditoria determinística, append-only e **em memória** do ciclo Safe
Confirmation (AI-013) + Transaction Execution (AI-014).

## Arquitetura

```
Confirmation / Transaction Execution (resultados existentes)
  → Orchestrator (único emissor)
  → AuditEventFactory (sanitiza)
  → AuditGateway.append
  → InMemoryAuditRepository (sequence monotônico / sessão)
Consulta AUDIT_STATUS
  → AuditQueryService (limite default = 50)
  → AuditFormatter
  → AssistantResponse.auditResult / auditPresentation
```

Planners **não** emitem eventos. Write Pipeline / AI-004 / fingerprint
permanecem intactos.

## Eventos

| Tipo | Quando |
|------|--------|
| `confirmationCreated` | Preview criado |
| `confirmationStatusChecked` | Status / missing / invalid de lifecycle |
| `confirmationConfirmed` | Usuário confirmou |
| `confirmationCancelled` | Cancelamento |
| `confirmationExpired` | TTL esgotado |
| `executionRequested` | Antes da escrita (gate de auditoria) |
| `executionRejected` | Planner rejeitou execução |
| `executionCompleted` | Create Quote Draft ok |
| `executionWriteFailed` | Write falhou após consumo |

Cada evento: `eventId`, `eventType`, `timestamp`, `sessionId`,
`correlationId`, `actor`, `target`, `metadata`, `outcome`, `sequence`,
`warning?`.

## correlationId

Estável no ciclo: `corr-{sessionId}-{tokenFingerprint}`.

## Sequence

Monotônico **por sessionId**, atribuído no append do repositório.

## Política de falha

1. **Antes da escrita** (`executionRequested`): se o append falhar, a
   execução é **bloqueada**. Token ainda não foi consumido pelo planner.
2. **Após escrita** (`executionCompleted` / `executionWriteFailed`): se o
   append falhar, a escrita **não é desfeita**; warning
   `auditAppendFailedAfterWrite`.
3. Falha de auditoria **nunca** autoriza operação inválida.

## Privacidade e fingerprint de token

Não registra: raw token, mensagem completa, payload ERP, PII completa,
stack traces, segredos, chaves HMAC.

Registra: token **fingerprint** criptográfico, IDs, tipo de operação,
códigos de outcome/erro, metadata mínima.

### Algoritmo

- **HMAC-SHA-256** via `AssistantAuditTokenFingerprinter`
- Implementação local: `HmacSha256AssistantAuditTokenFingerprinter`
- Chave: **injetável** (≥ 32 bytes); domínio não contém chave
- Default de processo (somente trilha em memória): material efêmero local
  rotulado como não-produção — substituir por chave gerenciada fora do
  processo quando houver persistência futura
- Prefixo do valor: `hmac-sha256-` + digest hex
- Determinístico para o mesmo par (token, chave)
- `correlationId` permanece `corr-{sessionId}-{tokenFingerprint}`

### Não exposição

Eventos, warnings, logs estruturados e payloads de consulta nunca incluem
o token em plaintext. A factory usa apenas a abstração injetada.

### Armazenamento

Somente **em memória** nesta sprint (append-only). Sem banco, sync ou export.

## Consulta

Intent `AUDIT_STATUS` (frases: “histórico de auditoria”, “mostrar auditoria”, …).

Limite padrão: **50**. Resultados imutáveis, ordenação cronológica
(sequence/timestamp).

## Workflow (AI-016)

Audit é um step kind do Workflow Engine. Recipes podem encadear
confirmation → audit em um único turno. Ver [workflow.md](workflow.md).

## Persistência futura

Interface `AssistantAuditRepository` permite trocar o backend in-memory
por Drift/remoto sem alterar factory/orchestrator — fora desta sprint.

## Limitações

- Sem DB / sync / export / dashboard
- Sem edição ou exclusão de eventos
- Sem nova escrita de negócio
- Sem LLM / externos / migrations

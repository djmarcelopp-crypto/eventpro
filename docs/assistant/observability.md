# Observabilidade de escrita (AI-007)

## Objetivo

Métricas locais e tipadas do pipeline de escrita **sem** provedores externos, rede ou telemetria remota.

**AI-007 não adiciona novos casos de uso.** Apenas Create Quote Draft permanece habilitado.

## Audit vs Observability

| | Audit | Observability |
|--|-------|----------------|
| Tipo | `AssistantWriteAuditRecord` | `AssistantWriteObservation` / `AssistantWriteMetric` |
| Papel | Registro **autoritativo** e explicável da decisão/execução | Métricas **operacionais não autoritativas** |
| Pode alterar negócio? | Não | Não |
| Falha pode bloquear? | N/A (produzido pelo coordinator) | **Não** — `SafeAssistantWriteObserver` engole erros |

## Contratos

- `AssistantWriteObserver` — `NoOp`, `InMemory`, `Safe`
- `AssistantWriteObservation` — payload tipado da tentativa
- `AssistantWriteMetric` — visão agregável da observation
- `AssistantWriteTimer` — duração com relógio injetável (nunca negativa)
- `AssistantWriteOutcomeCategory` — success, blocked, dryRun, simulation, timeout, rollback, failed, uncertain, idempotentReplay

## Campos capturados

operation, target, execution mode, policy, adapter, idempotency status, start/end, duration, confirmation, authorization, outcome, executed, mutatedErp, timeout, rollbackAttempted/Succeeded, warning count, failure code.

## Regras

- Observer **não** controla a decisão.
- Falha do observer **não** quebra a operação.
- Nenhum dado sensível / chave bruta de idempotência no payload.
- Relógio injetável para testes determinísticos.
- dryRun e simulation também emitem observation **sem** mutação.

## Dados proibidos em logs/métricas

- valor bruto da idempotency key;
- atributos de payload (nomes de cliente, preços, notas);
- tokens secretos além do fingerprint/execution id já tipados.

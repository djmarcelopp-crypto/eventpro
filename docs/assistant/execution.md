# Assistente EventPRO — Transaction Execution Engine (AI-014)

Conecta o Safe Confirmation Engine (AI-013) ao Write Pipeline de forma
determinística. Nesta sprint, a única operação real é **Create Quote Draft**.

## Fluxo

```
Intent (executar operação confirmada)
  → TransactionExecutionIntentResolver
  → TransactionExecutionPlanner
       • valida sessionId
       • valida pending confirmed
       • valida token (uso único)
       • valida expiração / cancelamento / consumo
       • compara fingerprint do plano aprovado × proposto
       • consome confirmação atomicamente
  → TransactionExecutionRequest
  → TransactionExecutionGateway
       • Create Quote Draft only
       • Write Coordinator (confirmationSatisfied = true)
  → TransactionExecutionResult
  → TransactionExecutionFormatter
  → AssistantResponse
```

## Integração com Confirmation Engine

1. **Create** (`solicitar confirmação…`) — grava `approvedAttributes` +
   `approvedPlanFingerprint` no `PendingConfirmation`.
2. **Confirm** (`confirmar`) — marca `confirmed` / `resolved`. **Não escreve.**
3. **Execute** (`executar` / `executar operação confirmada`) — planner consome
   o token e o gateway chama o write pipeline.

AI-013 permanece lifecycle-only. AI-014 é o único caminho de escrita quando
`canExecuteTransactionExecution` está ligado (o write path antecipado do
orquestrador não executa Create Quote Draft nesse perfil).

## Validações

| Check | Outcome |
|-------|---------|
| sessionId ausente / mismatch | `invalidSession` |
| pending ausente / não confirmado / token inválido | `invalidConfirmation` |
| cancelled | `confirmationCancelled` |
| expired (TTL absoluto) | `confirmationExpired` |
| already consumed / token reuse | `confirmationConsumed` |
| operationKind ou attributes ≠ aprovado | `planDivergence` |
| operação ≠ createQuoteDraft | `unsupportedOperation` |
| write pipeline falhou | `writeFailed` |
| sucesso | `completed` |

## Consumo atômico

`AssistantConfirmationSession.tryConsume()` marca `consumed = true` em um
único passo, **antes** do gateway escrever. Em Dart single-threaded isso
garante que uma segunda execução no mesmo isolate vê `consumed` e é rejeitada.

Limitação: se o write falhar após o consumo, o token não é reutilizado —
é necessário criar uma nova confirmação.

## Idempotência

A chave é estável por sessão + token:

`asst-tx-{sessionId}-{token}-createQuote`

Reuso do mesmo request após consumo é rejeitado pelo planner; retries com a
mesma chave (se o write tivesse ocorrido) são cobertos pelo
`LocalAssistantIdempotencyService` do write pipeline.

## Garantias de segurança

- Token de uso único (`consumed`)
- Rejeição após cancelamento / expiração / divergência / session mismatch
- Nenhuma edição, exclusão ou multi-write nesta sprint
- Sem LLM, persistência ou serviços externos

## Auditoria (AI-015)

O orchestrator emite `executionRequested` **antes** do planner consumir o
token quando o pending está confirmed; falha nesse append **bloqueia** a
escrita. Após a escrita, `executionCompleted` / `executionWriteFailed`;
falha pós-escrita vira warning sem rollback. Ver [audit.md](audit.md).

## Workflow (AI-016)

TX permanece um step kind registrável. Recipes atuais não invocam TX
automaticamente — execução continua via intent dedicado. Ver
[workflow.md](workflow.md).

## Contratos

| Tipo | Pacote |
|------|--------|
| Request / Result / Metadata / Warning / Outcome | `domain/transaction_execution/` |
| Planner / Gateway / Formatter (ports) | `domain/transaction_execution/` |
| Intent / Presentation / Fingerprint | `models/` |
| Local implementations | `services/local_assistant_transaction_execution_*` |

## Limitações (fora de escopo)

- Edição / exclusão / múltiplas operações
- Persistência de sessões de confirmação
- Rollback distribuído
- LLM / APIs externas

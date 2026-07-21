# Assistente EventPRO — LLM Provider Abstraction (AI-025)

Camada de **abstração de provedores de modelo**.

> O Assistente depende apenas do domínio.
> Nunca de um fornecedor (OpenAI, Gemini, Claude, …).
> Sem HTTP, sem SDKs, sem chaves API, sem alteração de `schemaVersion`.

## Arquitetura

```
Business Reasoning (AI-023)
        ↓
Model Provider (AI-025)   ← opt-in
        ↓
Capability
        ↓
Execution Plan
```

## Contratos (CP-1)

`lib/features/assistant/domain/model_provider/`

| Contrato | Papel |
|----------|--------|
| `AssistantModelProvider` | Descriptor (id, nome, prioridade, capabilities, models) |
| `AssistantModel` | Modelo oferecido pelo provider |
| `AssistantModelRequest` / `AssistantModelResponse` | Request/response imutáveis |
| `AssistantModelMessage` / `AssistantModelRole` | Mensagens de conversa |
| `AssistantModelUsage` | Tokens / custo estimado (contrato) |
| `AssistantModelCapabilities` | Conjunto de capacidades |
| `AssistantModelMetadata` | Metadados |
| `AssistantModelError` | Erro estruturado |

## Port (CP-2)

`AssistantModelProviderPort`

- `complete` / `stream` / `countTokens`
- `supportsVision` / `supportsAudio` / `supportsTools` / `supportsJson`
- `health`

Sem implementação concreta no port.

## Registry (CP-3)

`AssistantProviderRegistry` / `LocalAssistantProviderRegistry`

- registrar / remover
- provider padrão
- buscar / listar

Nenhum provider vendor no registry default (exceto mock quando opt-in).

## Capabilities (CP-4)

`AssistantModelCapability`:

Text · Vision · Audio · Tools · Json · Streaming · FunctionCalling · Reasoning

## Selection (CP-5)

`LocalAssistantProviderSelector` — determinístico:

1. `providerId`
2. `name`
3. capability + prioridade
4. fallback (default)

## Mock (CP-6)

`LocalMockProvider` — sem IA / sem HTTP.

Resposta determinística (`mock:echo:<texto>`). Valida a arquitetura.

## Integração (CP-7)

Opt-in: `canUseModelProvider` / `localModelProvider()`.

Orchestrator (após Business Reasoning) seleciona provider, consulta `health`,
faz `complete` de probe e injeta hints — **não altera** a mensagem amigável
nem specialty paths quando a flag está off.

## Observabilidade (CP-8)

`AssistantModelProviderObservation` + `AssistantModelProviderObserver`

Campos: tempo, tokens, provider, modelo, latência, capabilities, custo estimado.
Sem implementação real de telemetria.

## Compatibilidade

- AI-014…AI-024 preservados
- `schemaVersion` 12
- Sem migrations / LLM vendors / HTTP

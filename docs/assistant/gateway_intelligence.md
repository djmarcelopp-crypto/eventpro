# Assistente EventPRO — Gateway Intelligence Engine (AI-022)

Camada de **descoberta inteligente** de entidades do ERP via composição dos
gateways existentes.

> A AI-022 **não** integra LLM, **não** usa HTTP, **não** altera `schemaVersion`
> e **não** conhece implementações concretas do ERP.

## Posição no pipeline

```
Business Commands
        ↓
Gateway Intelligence  (AI-022, opt-in)
        ↓
Business / Module Gateway
        ↓
Workflow
```

## Contratos

Local: `lib/features/assistant/domain/gateway_intelligence/`

- `GatewayQuery` / `GatewayQueryResult` / `GatewayQueryStatus`
- `GatewayEntityReference` / `GatewayEntityKind`
- `GatewayMatch` (confiança determinística)
- `GatewayQueryContext` / `GatewayQueryMetadata`
- Port: `AssistantGatewayIntelligence`

Kinds: client, event, quote, contract, supplier, product, resource.

## Port

```
search()
findBestMatch()
resolveReference()
listCandidates()
suggestEntities()
```

## Local implementation

`LocalAssistantGatewayIntelligence`:

- catálogo local determinístico (fixtures);
- composição opcional de `AssistantGateway` (client/quote/inventory/team);
- ranking por match exato / parcial / alias;
- ambiguidades → `status=ambiguous` + sugestões ordenadas.

Sem regras de negócio de módulo.

## Integração

Opt-in: `AssistantCapabilities.canUseGatewayIntelligence` /
`localGatewayIntelligence()`.

Orchestrator: após parse, se o turno parecer descoberta de entidade, gera
hints `giCandidate:…` em `effectiveRequest.context` — sem alterar specialty paths.

## Limitações

- Sem LLM / embeddings / HTTP / Drift
- `schemaVersion` = **12**
- Catálogo local é fixture, não ERP produtivo

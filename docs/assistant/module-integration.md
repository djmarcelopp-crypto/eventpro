# Integração de módulos (read-only)

## Objetivo (AI-003)

Conectar o assistente a consultas **somente leitura** via gateways, sem criar/alterar/excluir dados e sem acoplar ao SQLite.

## Origem dos resultados

Todo `AssistantModuleResponse` / `AssistantModuleResult` carrega `dataSource`:

| Valor | Uso |
|-------|-----|
| `inMemory` | Adapters locais da AI-003 (único permitido nos adapters atuais) |
| `demo` | Reservado |
| `test` | Doubles de teste |
| `erp` | Futuro adapter ERP aprovado |
| `remote` | Futuro adapter remoto |

Nenhum resultado in-memory pode ser classificado como ERP.

A `AssistantResponse` preserva essa informação em `moduleResults` (`moduleDataSources`, `hasOnlySimulatedModuleData`).

## Quando uma consulta ocorre

Todos devem ser verdadeiros:

1. Intenção / passo de leitura compatível;
2. `canPlan*` habilitado;
3. `canExecute*` de leitura habilitado;
4. Gateway correspondente registrado;
5. Adapter disponível;
6. Request válido (senão: `AssistantModuleError` `invalid_request` **sem** chamar o adapter).

Caso contrário → passo `unavailable` + `integrationWarnings`.

## Política de falhas

- Exceções do adapter → encapsuladas em `AssistantModuleError`.
- Nenhuma exceção escapa para a UI.
- Falha em um módulo não apaga sucessos de outros na mesma consulta.

## Tipagem

Campos primários tipados: `found`, `displayName`, `identifier`, `confidence`, `capability`, `dataSource`, `summary`.

`metadata` é opcional e imutável — não é contrato principal.

## Quote / Inventory / Team

Contratos e fixtures in-memory existem para testes, porém:

- `canPlanLookupQuote` / `canExecuteLookupQuote` (e equivalentes inventory/team) são **`false` por padrão**;
- o orquestrador público (`localReadIntegration`) **não** os apresenta como integrações disponíveis.

## Dados mock e plano

Consultas in-memory:

- enriquecem a Response;
- **não** alteram drafts;
- **não** ativam writes;
- **não** tornam passos de escrita `ready`;
- **não** são persistidas.

Enriquecer draft a partir de consulta é decisão futura, explícita e rastreável.

## Introdução futura de adapter ERP

1. Implementar o contrato (`ClientGateway`, etc.) apontando para o módulo real **fora** do assistente ou em adapter dedicado.
2. Registrar no composition root com `dataSource=erp`.
3. Expor `integrationMode=erp` somente após aprovação PO/CTO.
4. Manter writes desligados até sprint de execução segura.

Dependência: ERP → contratos do assistente (ou ports), nunca assistente → repository concreto.

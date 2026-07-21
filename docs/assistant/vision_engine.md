# Assistente EventPRO — Vision Engine (AI-026)

Infraestrutura de **visão** do Assistente.

> Produz **fatos estruturados**.
> **Não** toma decisões.
> **Não** executa workflows.
> **Não** interpreta regras de negócio.

Essa responsabilidade permanece no Business Reasoning (AI-023).
Workflow executa. Vision apenas observa.

## Separação de responsabilidades

| Camada | Papel |
|--------|--------|
| Vision Engine | Fatos (OCR stub, entidades, tipo documental, sinais) |
| Business Reasoning | Decide com base em fatos/regras ERP |
| Workflow | Executa pipelines quando autorizado |

## Fluxo

```
Multimodal (AI-020)
        ↓
Vision (AI-026)          ← opt-in
        ↓
Context (AI-021/024)
        ↓
Intent
        ↓
Gateway Intelligence (AI-022)
        ↓
Business Reasoning (AI-023)
```

Com `canUseVisionEngine = false`: nenhuma alteração no fluxo.

## Contratos

`lib/features/assistant/domain/vision/`

- Input / Request / Result / Metadata / Reference / Confidence / Capability / Error
- OCR: Request / Result / Page / Block / Line / Word / BoundingBox
- Visual: Entity / Attribute / Relation / Annotation / Issue / Suggestion
- Document: Analysis Request/Result, Type, Field, Table, Signature
- Security: Sensitivity / PrivacyMetadata / RetentionPolicy
- Observability: Observation / Observer (sem logger)

## Port

`AssistantVisionPort`

`analyze` · `extractText` · `analyzeDocument` · `detectEntities` ·
`detectIssues` · `supports` · `health`

## Router

`LocalAssistantVisionRouter` seleciona por tipo / MIME / capability / prioridade.
Sem conhecer vendors.

## LocalMockVisionEngine

Determinístico, sem IA/OCR/HTTP/SDKs.

| Referência contém | Resultado |
|-------------------|-----------|
| `contrato` | documentType `contract` + sinal |
| `orcamento` | `quote` |
| `comprovante` | `receipt` |
| `palco` | stage + speaker + truss |
| `energia` | powerDistributor |
| desconhecido | baixa confiança, sem inventar dados críticos |

## Sinais (CP-10)

Exemplos: documento parece contrato, assinatura detectada, equipamento
identificado, QR Code presente, possível comprovante.

Nunca: criar cliente/evento, executar workflow, alterar banco.

## Integração

Opt-in: `canUseVisionEngine` / `localVisionEngine()`.

Orchestrator injeta hints `visionEngine:*` / `visionSignal:*` sem mudar
specialty paths quando a flag está off.

## Compatibilidade

- AI-014…AI-025 preservados
- `schemaVersion` 12
- Sem migrations / HTTP / SDKs / vendors de Vision

## Voice Engine (AI-027)

Vision analisa imagens/documentos. Voice analisa áudio. Ambos produzem fatos;
Business Reasoning interpreta. Ver [voice_engine.md](voice_engine.md).
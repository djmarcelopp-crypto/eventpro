# Assistente EventPRO — Multimodal Input Engine (AI-020)

Camada arquitetural para receber e normalizar entradas do Assistente
provenientes de **texto**, **imagem**, **áudio** e **documento**.

> A AI-020 prepara a arquitetura para processamento multimodal, mas **não**
> implementa motores reais de OCR, transcrição, visão ou extração documental.

## Fluxo

```
Text / Image / Audio / Document
              ↓
       AssistantInput
              ↓
   Multimodal Input Pipeline
      (validate → processor? → normalize)
              ↓
      Normalized Content (texto ready)
              ↓
            Intent → Command → Capability → Workflow
```

Imagem/áudio/documento **sem** processor retornam `requiresProcessing` e
**não** avançam como texto vazio para o Planner.

## Contratos (CP-1)

Local: `lib/features/assistant/domain/input/`

- `AssistantInput`, `AssistantInputId`, `AssistantInputType`
- `AssistantInputSource`, `AssistantInputMetadata`
- `AssistantInputAttachment`, `AssistantInputContent`
- `AssistantInputStatus`
- `AssistantInputNormalizationResult` / `Status`

Tipos: `text` | `image` | `audio` | `document`.

Attachments guardam apenas **referência** (não bytes).

## Normalizer (CP-2)

`LocalAssistantInputNormalizer`:

| Tipo | Comportamento |
|------|----------------|
| text | valida + limpa whitespace → `ready` |
| image/audio/document | valida mime/ref → `requiresProcessing` |
| inválido | `invalid` / `unsupported` / `failed` |

Nunca inventa OCR/transcript.

## Processor Registry (CP-3)

`AssistantInputProcessor` + `LocalAssistantInputProcessorRegistry`.

- registro imutável;
- busca por id / type / mimeType;
- default: apenas `LocalAssistantTextInputProcessor` (pass-through de texto);
- ausência segura para mídia.

## Pipeline (CP-4)

`LocalAssistantInputPipeline`:

Raw → Processor Resolution → Optional Processing → Normalization → Result

Preserva `inputId` e `correlationId`.

## Integração (CP-5)

Opt-in via `AssistantCapabilities.canUseMultimodalInput` /
`localMultimodalInput()`.

Orchestrator: `AssistantRequest` → factory → pipeline → texto normalizado
(ou resposta bloqueada com issues tipadas). Aditivo; APIs existentes intactas.

## Limitações / futuro

- Sem OCR, STT, visão, PDF parsing, LLM, HTTP, Drift, UI, upload, câmera
- `schemaVersion` permanece **12**
- Processadores reais entram registrando `AssistantInputProcessor`

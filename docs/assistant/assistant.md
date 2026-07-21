# Assistente EventPRO — Visão geral

Documentação de índice do feature `lib/features/assistant/**`.

O Assistente é um pipeline determinístico de interpretação e execução
controlada sobre o ERP EventPRO. Produção write permanece **default deny**.

## Princípios

- Dependência de **domínio / ports**, nunca de vendors externos
- Opt-in progressivo via `AssistantCapabilities`
- Sem LLM/STT/TTS/OCR real nesta fase (abstrações + mocks locais)
- Tool Framework (AI-028) **não** executa lógica de negócio
- `schemaVersion` atual: **12** (sem migrations nestes sprints)

## Pipeline (resumo)

```
Request
  → [opt] Multimodal (AI-020)
  → [opt] Vision (AI-026)
  → [opt] Voice (AI-027)
  → [opt] Context Engine (AI-021) + Persistent Memory (AI-024)
  → Parser
  → [opt] Gateway Intelligence (AI-022)
  → Intent
  → [opt] Business Reasoning (AI-023)
  → [opt] Tool Framework (AI-028)
  → [opt] Model Provider (AI-025)
  → Drafts / Planner / Workflow / TX / Confirmation / Audit / …
  → AssistantResponse
```

## Documentos

| Doc | Tema |
|-----|------|
| [architecture.md](architecture.md) | Pipeline e camadas |
| [tool_framework.md](tool_framework.md) | Tool Calling Framework (AI-028) |
| [voice_engine.md](voice_engine.md) | Voice Engine (AI-027) |
| [vision_engine.md](vision_engine.md) | Vision Engine (AI-026) |
| [model_provider.md](model_provider.md) | Abstração de providers (AI-025) |
| [persistent_memory.md](persistent_memory.md) | Memória operacional (AI-024) |
| [business_reasoning.md](business_reasoning.md) | Regras ERP (AI-023) |
| [gateway_intelligence.md](gateway_intelligence.md) | Descoberta de entidades (AI-022) |
| [context_engine.md](context_engine.md) | Contexto conversacional (AI-021) |
| [workflow.md](workflow.md) | Workflow engine |
| [controlled-execution.md](controlled-execution.md) | Execução controlada |

## Capabilities opt-in (exemplos)

- `localContextEngine()` / `localPersistentMemory()`
- `localGatewayIntelligence()` / `localBusinessReasoning()`
- `localModelProvider()` — mock local apenas
- `localVisionEngine()` — fatos visuais estruturados (mock)
- `localVoiceEngine()` — fatos de áudio estruturados (mock)
- `localToolFramework()` — ferramentas mock (sem side effects)

# Assistente EventPRO — Business Reasoning Engine (AI-023)

Mecanismo de **raciocínio de negócio** determinístico.

> Não interpreta linguagem natural. Não usa LLM, NLP ou HTTP.
> Avalia **fatos estruturados** e **regras do ERP**.

## Fluxo

```
Intent
  → Business Command
  → Gateway Intelligence (AI-022)
  → Business Reasoning (AI-023)
  → Capability
  → Execution Plan
```

## Perguntas que responde

- existe informação suficiente?
- falta algum dado?
- existem ambiguidades?
- existe conflito?
- existe violação de regra?
- existe dependência entre operações?
- qual a próxima ação recomendada?

## Contratos

`lib/features/assistant/domain/business/reasoning/`

- `BusinessReasoningRequest` — fatos tipados
- `BusinessReasoningResult` / `BusinessReasoningDecision`
- `BusinessReasoningIssue` / `BusinessReasoningSuggestion`
- `BusinessReasoningMetadata` / `BusinessReasoningConfidence`
- Port: `AssistantBusinessReasoning`

## Port

`evaluate` · `validate` · `detectConflicts` · `detectMissingInformation` ·
`suggestNextAction` · `explainDecision`

## Regras locais (CP-4)

Cliente inexistente / duplicado (ambíguo) · Evento inexistente ·
Orçamento fechado · Contrato cancelado · Dependências pendentes ·
Dados obrigatórios ausentes · Fluxos inválidos · Conflitos entre comandos

## Sugestões (CP-5)

Orientam, **não executam** (ex.: "Selecione um cliente.",
"Confirme antes de cancelar.").

## Explainability (CP-7)

Cada decisão inclui: motivo, regras aplicadas, evidências, confiança.

## Integração

Opt-in: `canUseBusinessReasoning` / `localBusinessReasoning()`.

Orchestrator injeta hints `businessReasoning:*` / `brSuggestion:*` /
`brExplain:*` em `effectiveRequest` após Intent (+ GI quando ativo).

## Limitações

- Sem LLM / NLP / HTTP / Drift
- `schemaVersion` = **12**
- Fatos devem ser fornecidos estruturados (não extrai NLP sozinho)

## Persistent Memory (AI-024)

Decisões / capabilities / entidades recentes podem ser **lembradas** via
Persistent Memory Engine (opt-in), sem NLP. Ver
[persistent_memory.md](persistent_memory.md).
Business Reasoning continua avaliando fatos estruturados; a memória não
substitui o motor de regras.

## Model Provider (AI-025)

Após o raciocínio de negócio, o orchestrator pode consultar a abstração de
Model Provider (opt-in, mock local). Ver [model_provider.md](model_provider.md).
Não substitui Business Reasoning e não integra vendors.

## Vision Engine (AI-026)

Vision (antes do Context/Intent) gera **sinais/fatos** (ex.: parece contrato).
Business Reasoning consome fatos estruturados e decide. Vision **nunca**
executa. Ver [vision_engine.md](vision_engine.md).

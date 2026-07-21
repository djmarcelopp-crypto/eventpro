# Assistente EventPRO — Voice Engine (AI-027)

Infraestrutura de **voz/áudio** do Assistente.

> Produz **fatos estruturados**.
> **Não** interpreta negócio.
> **Não** decide.
> **Não** executa workflows.

**Voice produz fatos. Business Reasoning interpreta. Workflow executa.**

## Fluxo

```
Multimodal (AI-020)
        ↓
Vision (AI-026)          ← opt-in
        ↓
Voice (AI-027)           ← opt-in
        ↓
Context / Persistent Memory (AI-021/024)
        ↓
Intent → … → Business Reasoning (AI-023)
```

Com `canUseVoiceEngine = false`: nenhuma alteração.

## Contratos

`lib/features/assistant/domain/voice/`

- Audio: Input / Reference / Request / Result / Metadata / Capability / Confidence / Error
- Transcription: Request / Result / Segment / Word / Speaker / Language / Metadata
- Speech: Request / Result / VoiceProfile / Characteristics / Metadata (sem TTS real)
- Security: Sensitivity / PrivacyMetadata / RetentionPolicy
- Observability: Observation / Observer (sem logger)

## Port

`AssistantVoicePort`

`transcribe` · `synthesize` · `detectLanguage` · `detectSpeakers` ·
`analyzeAudio` · `supports` · `health`

## Router

`LocalAssistantVoiceRouter` — tipo / MIME / capability / prioridade. Sem vendors.

## LocalMockVoiceEngine

Determinístico, sem STT/TTS/HTTP/SDKs.

| Referência contém | Sinal |
|-------------------|--------|
| `cliente` | client_mentioned |
| `evento` | event_mentioned |
| `contrato` | contract_mentioned |
| `pagamento` | payment_mentioned |
| `palco` | equipment_mentioned |
| unknown | baixa confiança |

## Integração

Opt-in: `canUseVoiceEngine` / `localVoiceEngine()`.

Hints: `audioRef:` / `audioFileName:` / `audioMimeType:` (ou extensão `.mp3`/`.wav`/…).

## Compatibilidade

- AI-014…AI-026 preservados
- `schemaVersion` 12
- Sem migrations / HTTP / SDKs / Whisper / vendors de áudio

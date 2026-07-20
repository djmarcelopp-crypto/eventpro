import '../domain/input/assistant_input.dart';
import '../domain/input/assistant_input_content.dart';
import '../domain/input/assistant_input_normalization_result.dart';
import '../domain/input/assistant_input_normalization_status.dart';
import '../domain/input/assistant_input_normalizer.dart';
import '../domain/input/assistant_input_type.dart';

/// Local normalizer — validates and prepares text; flags media for processors.
class LocalAssistantInputNormalizer implements AssistantInputNormalizer {
  const LocalAssistantInputNormalizer();

  static const _imageMimes = {
    'image/jpeg',
    'image/png',
    'image/webp',
    'image/gif',
  };
  static const _audioMimes = {
    'audio/mpeg',
    'audio/mp4',
    'audio/wav',
    'audio/x-wav',
    'audio/ogg',
    'audio/webm',
  };
  static const _documentMimes = {
    'application/pdf',
    'text/plain',
    'application/msword',
    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  };

  @override
  AssistantInputNormalizationResult normalize(AssistantInput input) {
    switch (input.type) {
      case AssistantInputType.text:
        return _normalizeText(input);
      case AssistantInputType.image:
        return _normalizeMedia(
          input,
          allowedMimes: _imageMimes,
          processingMessage:
              'Imagem válida; processamento especializado (visão/OCR) necessário.',
        );
      case AssistantInputType.audio:
        return _normalizeMedia(
          input,
          allowedMimes: _audioMimes,
          processingMessage:
              'Áudio válido; transcrição especializada necessária.',
          requireDurationHint: false,
        );
      case AssistantInputType.document:
        return _normalizeMedia(
          input,
          allowedMimes: _documentMimes,
          processingMessage:
              'Documento válido; extração especializada necessária.',
        );
    }
  }

  AssistantInputNormalizationResult _normalizeText(AssistantInput input) {
    final raw = input.content.text ?? input.content.normalizedText;
    if (raw == null || raw.trim().isEmpty) {
      return AssistantInputNormalizationResult(
        inputId: input.id.value,
        correlationId: input.effectiveCorrelationId,
        status: AssistantInputNormalizationStatus.invalid,
        input: input,
        messages: const [
          AssistantInputMessage(
            code: AssistantInputMessage.missingText,
            message: 'Conteúdo textual ausente ou vazio.',
          ),
        ],
      );
    }

    final cleaned = _collapseExcessWhitespace(raw);
    return AssistantInputNormalizationResult(
      inputId: input.id.value,
      correlationId: input.effectiveCorrelationId,
      status: AssistantInputNormalizationStatus.ready,
      input: input,
      normalizedContent: AssistantInputContent(
        text: raw,
        normalizedText: cleaned,
        attachment: input.content.attachment,
      ),
    );
  }

  AssistantInputNormalizationResult _normalizeMedia(
    AssistantInput input, {
    required Set<String> allowedMimes,
    required String processingMessage,
    bool requireDurationHint = false,
  }) {
    final attachment = input.content.attachment;
    if (attachment == null || !attachment.hasReference) {
      return AssistantInputNormalizationResult(
        inputId: input.id.value,
        correlationId: input.effectiveCorrelationId,
        status: AssistantInputNormalizationStatus.invalid,
        input: input,
        messages: const [
          AssistantInputMessage(
            code: AssistantInputMessage.missingAttachment,
            message: 'Attachment ausente ou referência inválida.',
          ),
        ],
      );
    }

    final mime = attachment.mimeType?.trim().toLowerCase();
    if (mime == null || mime.isEmpty) {
      return AssistantInputNormalizationResult(
        inputId: input.id.value,
        correlationId: input.effectiveCorrelationId,
        status: AssistantInputNormalizationStatus.invalid,
        input: input,
        messages: const [
          AssistantInputMessage(
            code: AssistantInputMessage.invalidMime,
            message: 'mimeType ausente no attachment.',
          ),
        ],
      );
    }

    if (!allowedMimes.contains(mime) && !_wildcardMatch(mime, allowedMimes)) {
      return AssistantInputNormalizationResult(
        inputId: input.id.value,
        correlationId: input.effectiveCorrelationId,
        status: AssistantInputNormalizationStatus.unsupported,
        input: input,
        messages: [
          AssistantInputMessage(
            code: AssistantInputMessage.invalidMime,
            message: 'mimeType não suportado: $mime.',
          ),
        ],
      );
    }

    if (requireDurationHint &&
        (attachment.durationMs == null || attachment.durationMs! < 0)) {
      return AssistantInputNormalizationResult(
        inputId: input.id.value,
        correlationId: input.effectiveCorrelationId,
        status: AssistantInputNormalizationStatus.invalid,
        input: input,
        messages: const [
          AssistantInputMessage(
            code: AssistantInputMessage.invalidReference,
            message: 'Duração de áudio inválida ou ausente.',
          ),
        ],
      );
    }

    // Never invent OCR/transcript text.
    return AssistantInputNormalizationResult(
      inputId: input.id.value,
      correlationId: input.effectiveCorrelationId,
      status: AssistantInputNormalizationStatus.requiresProcessing,
      input: input,
      normalizedContent: AssistantInputContent(
        attachment: attachment,
      ),
      messages: [
        AssistantInputMessage(
          code: AssistantInputMessage.requiresSpecializedProcessing,
          message: processingMessage,
        ),
      ],
    );
  }

  static String _collapseExcessWhitespace(String raw) {
    final trimmed = raw.trim();
    return trimmed.replaceAll(RegExp(r'[ \t]+'), ' ').replaceAll(
          RegExp(r'\n{3,}'),
          '\n\n',
        );
  }

  static bool _wildcardMatch(String mime, Set<String> allowed) {
    final slash = mime.indexOf('/');
    if (slash <= 0) return false;
    final major = mime.substring(0, slash);
    return allowed.any((a) => a.startsWith('$major/'));
  }
}

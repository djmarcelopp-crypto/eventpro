import '../models/assistant_confirmation_operation_kind.dart';
import '../models/assistant_read_status_lexicon.dart';
import '../models/assistant_request.dart';
import '../models/assistant_safe_confirmation_intent.dart';
import 'assistant_capabilities.dart';

/// Deterministic resolver for safe-confirmation lifecycle intents.
class LocalAssistantSafeConfirmationIntentResolver {
  const LocalAssistantSafeConfirmationIntentResolver();

  AssistantSafeConfirmationIntent? resolve({
    required AssistantRequest request,
    required AssistantCapabilities capabilities,
  }) {
    if (!capabilities.canPlanSafeConfirmation &&
        !capabilities.canExecuteSafeConfirmation) {
      return null;
    }

    final folded = AssistantReadStatusLexicon.fold(request.rawText)
        .replaceAll(RegExp(r'[?!.]+$'), '')
        .trim();

    if (_isCreate(folded)) {
      return const CreateConfirmationIntent(
        operationKind: AssistantConfirmationOperationKind.createQuoteDraft,
      );
    }
    if (_isCancel(folded)) {
      return const CancelPendingIntent();
    }
    if (_isConfirm(folded)) {
      return const ConfirmPendingIntent();
    }
    if (_isStatus(folded)) {
      return const StatusPendingIntent();
    }
    return null;
  }

  static bool _isCreate(String folded) =>
      folded.contains('solicitar confirmacao') ||
      folded.contains('prepare confirmacao') ||
      folded.contains('preparar confirmacao') ||
      folded.contains('criar confirmacao') ||
      folded.contains('preciso confirmar criar') ||
      folded.contains('quero confirmar criar orcamento') ||
      folded.contains('confirmacao para criar orcamento') ||
      folded.contains('confirmacao de orcamento draft');

  static bool _isCancel(String folded) =>
      folded.contains('cancelar confirmacao') ||
      folded == 'cancelar' ||
      folded == 'nao confirmar' ||
      folded.contains('cancelar a confirmacao');

  static bool _isConfirm(String folded) =>
      folded == 'confirmar' ||
      folded == 'confirmo' ||
      folded == 'sim, confirmar' ||
      folded == 'sim confirmar' ||
      folded.contains('confirmar operacao') ||
      folded.contains('confirmar a operacao');

  static bool _isStatus(String folded) =>
      folded.contains('confirmacao pendente') ||
      folded.contains('qual confirmacao') ||
      folded.contains('status da confirmacao');
}

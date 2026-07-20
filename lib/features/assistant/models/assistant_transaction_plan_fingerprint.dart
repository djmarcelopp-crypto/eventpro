import 'assistant_confirmation_operation_kind.dart';

/// Deterministic plan fingerprint for confirmation ↔ execution divergence checks.
abstract final class AssistantTransactionPlanFingerprint {
  static const defaultQuoteDraftAttributes = <String, String>{
    'clientDisplayName': 'Cliente',
    'lineItemName': 'Item',
    'lineItemUnitPriceCents': '0',
  };

  static String compute({
    required AssistantConfirmationOperationKind operationKind,
    required Map<String, String> attributes,
  }) {
    final keys = attributes.keys.toList()..sort();
    final parts = <String>[operationKind.name];
    for (final key in keys) {
      parts.add('$key=${attributes[key] ?? ''}');
    }
    return parts.join('|');
  }
}

import 'assistant_write_entity_state.dart';
import 'assistant_write_operation.dart';
import 'assistant_write_target.dart';

/// Validated, module-agnostic payload for a write intent.
///
/// Contains only primitive fields — never ERP entities.
class AssistantWritePayload {
  const AssistantWritePayload({
    required this.operation,
    required this.target,
    required this.requestedState,
    this.clientDisplayName = '',
    this.clientType = 'individual',
    this.notes = '',
    this.lineItemName = '',
    this.lineItemUnit = 'un',
    this.lineItemQuantity = '1',
    this.lineItemUnitPriceCents = '0',
    this.attributes = const {},
  });

  final AssistantWriteOperation operation;
  final AssistantWriteTarget target;
  final AssistantWriteEntityState requestedState;
  final String clientDisplayName;
  final String clientType;
  final String notes;
  final String lineItemName;
  final String lineItemUnit;
  final String lineItemQuantity;
  final String lineItemUnitPriceCents;
  final Map<String, String> attributes;

  bool get isSupportedAi006QuoteDraft =>
      operation == AssistantWriteOperation.create &&
      target == AssistantWriteTarget.quote &&
      requestedState == AssistantWriteEntityState.draft;

  AssistantWritePayload copyWith({
    AssistantWriteOperation? operation,
    AssistantWriteTarget? target,
    AssistantWriteEntityState? requestedState,
    String? clientDisplayName,
    String? clientType,
    String? notes,
    String? lineItemName,
    String? lineItemUnit,
    String? lineItemQuantity,
    String? lineItemUnitPriceCents,
    Map<String, String>? attributes,
  }) {
    return AssistantWritePayload(
      operation: operation ?? this.operation,
      target: target ?? this.target,
      requestedState: requestedState ?? this.requestedState,
      clientDisplayName: clientDisplayName ?? this.clientDisplayName,
      clientType: clientType ?? this.clientType,
      notes: notes ?? this.notes,
      lineItemName: lineItemName ?? this.lineItemName,
      lineItemUnit: lineItemUnit ?? this.lineItemUnit,
      lineItemQuantity: lineItemQuantity ?? this.lineItemQuantity,
      lineItemUnitPriceCents:
          lineItemUnitPriceCents ?? this.lineItemUnitPriceCents,
      attributes: attributes ?? this.attributes,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AssistantWritePayload &&
            other.operation == operation &&
            other.target == target &&
            other.requestedState == requestedState &&
            other.clientDisplayName == clientDisplayName &&
            other.clientType == clientType &&
            other.notes == notes &&
            other.lineItemName == lineItemName &&
            other.lineItemUnit == lineItemUnit &&
            other.lineItemQuantity == lineItemQuantity &&
            other.lineItemUnitPriceCents == lineItemUnitPriceCents;
  }

  @override
  int get hashCode => Object.hash(
        operation,
        target,
        requestedState,
        clientDisplayName,
        clientType,
        notes,
        lineItemName,
        lineItemUnit,
        lineItemQuantity,
        lineItemUnitPriceCents,
      );
}

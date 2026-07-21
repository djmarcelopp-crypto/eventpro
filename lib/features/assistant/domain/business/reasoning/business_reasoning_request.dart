import 'business_reasoning_metadata.dart';

/// Known quote lifecycle states for rule evaluation (no ERP enum coupling).
enum BusinessReasoningQuoteStatus {
  unknown,
  draft,
  open,
  closed,
}

/// Known contract lifecycle states for rule evaluation.
enum BusinessReasoningContractStatus {
  unknown,
  active,
  cancelled,
}

/// Immutable facts bag for deterministic Business Reasoning (AI-023).
///
/// Callers supply structured facts — the engine does not parse NLP.
class BusinessReasoningRequest {
  const BusinessReasoningRequest({
    required this.requestId,
    this.intentLabel,
    this.commandIds = const [],
    this.capabilityIds = const [],
    this.clientId,
    this.clientLabel,
    this.clientCandidateCount = 0,
    this.clientFound = false,
    this.eventId,
    this.eventFound = false,
    this.quoteId,
    this.quoteStatus = BusinessReasoningQuoteStatus.unknown,
    this.contractId,
    this.contractStatus = BusinessReasoningContractStatus.unknown,
    this.missingRequiredFields = const [],
    this.pendingDependencies = const [],
    this.conflictingCommandIds = const [],
    this.requiresConfirmation = false,
    this.gatewayAmbiguous = false,
    this.metadata = const BusinessReasoningMetadata(),
  });

  final String requestId;
  final String? intentLabel;
  final List<String> commandIds;
  final List<String> capabilityIds;

  final String? clientId;
  final String? clientLabel;
  final int clientCandidateCount;
  final bool clientFound;

  final String? eventId;
  final bool eventFound;

  final String? quoteId;
  final BusinessReasoningQuoteStatus quoteStatus;

  final String? contractId;
  final BusinessReasoningContractStatus contractStatus;

  final List<String> missingRequiredFields;
  final List<String> pendingDependencies;
  final List<String> conflictingCommandIds;
  final bool requiresConfirmation;
  final bool gatewayAmbiguous;

  final BusinessReasoningMetadata metadata;

  Map<String, Object?> toDeterministicMap() => {
        'requestId': requestId,
        'intentLabel': intentLabel,
        'commandIds': commandIds,
        'capabilityIds': capabilityIds,
        'clientId': clientId,
        'clientLabel': clientLabel,
        'clientCandidateCount': clientCandidateCount,
        'clientFound': clientFound,
        'eventId': eventId,
        'eventFound': eventFound,
        'quoteId': quoteId,
        'quoteStatus': quoteStatus.name,
        'contractId': contractId,
        'contractStatus': contractStatus.name,
        'missingRequiredFields': missingRequiredFields,
        'pendingDependencies': pendingDependencies,
        'conflictingCommandIds': conflictingCommandIds,
        'requiresConfirmation': requiresConfirmation,
        'gatewayAmbiguous': gatewayAmbiguous,
        'metadata': metadata.toDeterministicMap(),
      };
}

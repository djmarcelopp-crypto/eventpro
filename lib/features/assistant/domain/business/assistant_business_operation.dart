/// Declared business operation (catalog entry — no ERP logic).
class AssistantBusinessOperation {
  const AssistantBusinessOperation({
    required this.code,
    this.label,
  });

  /// Stable operation code (e.g. FIND_CLIENT).
  final String code;
  final String? label;

  Map<String, Object?> toDeterministicMap() => {
        'code': code,
        'label': label,
      };
}

/// Built-in operation codes for AI-017 stubs.
abstract final class AssistantBusinessOperationCodes {
  static const findClient = 'FIND_CLIENT';
  static const createQuote = 'CREATE_QUOTE';
  static const openEvent = 'OPEN_EVENT';
  static const findEvent = 'FIND_EVENT';
  static const findQuote = 'FIND_QUOTE';
  static const findContract = 'FIND_CONTRACT';

  static const all = <String>{
    findClient,
    createQuote,
    openEvent,
    findEvent,
    findQuote,
    findContract,
  };
}

/// Non-executing guidance produced by Business Reasoning.
class BusinessReasoningSuggestion {
  const BusinessReasoningSuggestion({
    required this.code,
    required this.message,
    this.priority = 0,
    this.relatedIssueCodes = const [],
  });

  final String code;
  final String message;
  final int priority;
  final List<String> relatedIssueCodes;

  Map<String, Object?> toDeterministicMap() => {
        'code': code,
        'message': message,
        'priority': priority,
        'relatedIssueCodes': relatedIssueCodes,
      };
}

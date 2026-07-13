class QuoteNumberGenerator {
  final Map<int, int> _sequenceByYear = {};

  String nextNumber({DateTime? referenceDate}) {
    final date = referenceDate ?? DateTime.now();
    final year = date.year;
    final nextSequence = (_sequenceByYear[year] ?? 0) + 1;
    _sequenceByYear[year] = nextSequence;
    return 'ORC-$year-${nextSequence.toString().padLeft(4, '0')}';
  }
}

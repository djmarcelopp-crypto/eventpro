import 'financial_flow_kind.dart';

/// Aggregated total for one category within a report period.
class FinancialCategoryTotal {
  const FinancialCategoryTotal({
    required this.categoryId,
    required this.categoryName,
    required this.kind,
    required this.totalCents,
    required this.entryCount,
  });

  final String categoryId;
  final String categoryName;
  final FinancialFlowKind kind;
  final int totalCents;
  final int entryCount;
}

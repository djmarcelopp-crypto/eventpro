class QuotePdfFinancialSummary {
  const QuotePdfFinancialSummary({
    required this.subtotalLabel,
    this.discountLabel,
    this.freightLabel,
    required this.totalLabel,
  });

  final String subtotalLabel;
  final String? discountLabel;
  final String? freightLabel;
  final String totalLabel;
}

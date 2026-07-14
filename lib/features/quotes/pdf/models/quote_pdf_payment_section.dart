class QuotePdfPaymentSection {
  const QuotePdfPaymentSection({
    this.paymentTerms,
    this.pixKeyTypeLabel,
    this.pixKey,
    this.beneficiaryName,
  });

  final String? paymentTerms;
  final String? pixKeyTypeLabel;
  final String? pixKey;
  final String? beneficiaryName;

  bool get isEmpty {
    return paymentTerms == null &&
        pixKeyTypeLabel == null &&
        pixKey == null &&
        beneficiaryName == null;
  }
}

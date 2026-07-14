class QuotePdfSignatureBlock {
  QuotePdfSignatureBlock({
    required this.roleLabel,
    required List<String> identificationLines,
  }) : identificationLines = List.unmodifiable(identificationLines);

  final String roleLabel;
  final List<String> identificationLines;
}

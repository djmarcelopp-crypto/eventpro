import 'pix_key_type.dart';

class CompanyPaymentInfo {
  const CompanyPaymentInfo({
    this.pixKeyType,
    this.pixKey,
    this.beneficiaryName,
    this.paymentTerms,
  });

  final PixKeyType? pixKeyType;
  final String? pixKey;
  final String? beneficiaryName;
  final String? paymentTerms;

  bool get isEmpty {
    return pixKeyType == null &&
        pixKey == null &&
        beneficiaryName == null &&
        paymentTerms == null;
  }

  bool get isPixStarted {
    return pixKeyType != null || (pixKey?.trim().isNotEmpty ?? false);
  }

  CompanyPaymentInfo copyWith({
    PixKeyType? pixKeyType,
    String? pixKey,
    String? beneficiaryName,
    String? paymentTerms,
    bool clearPixKeyType = false,
    bool clearPixKey = false,
  }) {
    return CompanyPaymentInfo(
      pixKeyType: clearPixKeyType ? null : (pixKeyType ?? this.pixKeyType),
      pixKey: clearPixKey ? null : (pixKey ?? this.pixKey),
      beneficiaryName: beneficiaryName ?? this.beneficiaryName,
      paymentTerms: paymentTerms ?? this.paymentTerms,
    );
  }

  static CompanyPaymentInfo? fromForm({
    required PixKeyType? pixKeyType,
    required String? pixKey,
    required String? beneficiaryName,
    required String? paymentTerms,
  }) {
    final payment = CompanyPaymentInfo(
      pixKeyType: pixKeyType,
      pixKey: _optionalText(pixKey),
      beneficiaryName: _optionalText(beneficiaryName),
      paymentTerms: _optionalText(paymentTerms),
    );

    return payment.isEmpty ? null : payment;
  }

  static String? _optionalText(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }
}

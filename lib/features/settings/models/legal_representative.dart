class LegalRepresentative {
  const LegalRepresentative({
    this.fullName,
    this.cpfDigits,
    this.role,
  });

  final String? fullName;
  final String? cpfDigits;
  final String? role;

  bool get isEmpty {
    return fullName == null && cpfDigits == null && role == null;
  }

  bool get isStarted {
    return (fullName?.trim().isNotEmpty ?? false) ||
        (cpfDigits?.trim().isNotEmpty ?? false) ||
        (role?.trim().isNotEmpty ?? false);
  }

  LegalRepresentative copyWith({
    String? fullName,
    String? cpfDigits,
    String? role,
  }) {
    return LegalRepresentative(
      fullName: fullName ?? this.fullName,
      cpfDigits: cpfDigits ?? this.cpfDigits,
      role: role ?? this.role,
    );
  }

  static LegalRepresentative? fromForm({
    required String? fullName,
    required String? cpf,
    required String? role,
  }) {
    final representative = LegalRepresentative(
      fullName: _optionalText(fullName),
      cpfDigits: _optionalDigits(cpf),
      role: _optionalText(role),
    );

    return representative.isEmpty ? null : representative;
  }

  static String? _optionalText(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  static String? _optionalDigits(String? value) {
    final digits = value?.replaceAll(RegExp(r'\D'), '') ?? '';
    if (digits.isEmpty) {
      return null;
    }
    return digits;
  }
}

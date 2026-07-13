abstract class ClientFormValidators {
  static String extractDigits(String? value) {
    return (value ?? '').replaceAll(RegExp(r'\D'), '');
  }

  static String? validateName(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Informe o nome do cliente';
    }
    if (trimmed.length < 2) {
      return 'Nome deve ter pelo menos 2 caracteres';
    }
    return null;
  }

  static String? validateWhatsApp(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Informe o WhatsApp';
    }

    final digits = extractDigits(trimmed);
    if (digits.length != 13) {
      return 'WhatsApp inválido';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return null;
    }
    final emailPattern = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailPattern.hasMatch(trimmed)) {
      return 'E-mail inválido';
    }
    return null;
  }

  static String? validateCpf(String? value) {
    final digits = extractDigits(value);
    if (digits.isEmpty) {
      return null;
    }
    if (digits.length != 11) {
      return 'CPF inválido';
    }
    return null;
  }

  static String? validateCnpj(String? value) {
    final digits = extractDigits(value);
    if (digits.isEmpty) {
      return null;
    }
    if (digits.length != 14) {
      return 'CNPJ inválido';
    }
    return null;
  }

  static String? validateState(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return null;
    }
    if (trimmed.length != 2) {
      return 'UF inválida';
    }
    return null;
  }

  static String? validateBirthday(DateTime? value) {
    if (value == null) {
      return null;
    }
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final birthdayDate = DateTime(value.year, value.month, value.day);
    if (birthdayDate.isAfter(todayDate)) {
      return 'Data de aniversário não pode ser futura';
    }
    return null;
  }
}

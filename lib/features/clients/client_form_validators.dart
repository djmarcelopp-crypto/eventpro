import 'data/utils/brazilian_cnpj_validator.dart';
import 'data/utils/brazilian_cpf_validator.dart';
import 'utils/email_sanitizer.dart';

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

  static String? validatePhone(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return null;
    }

    final digits = extractDigits(trimmed);
    if (digits.length != 10 && digits.length != 11) {
      return 'Telefone inválido';
    }

    final ddd = int.tryParse(digits.substring(0, 2));
    if (ddd == null || ddd < 11 || ddd > 99) {
      return 'Telefone inválido';
    }

    return null;
  }

  static String? validateWhatsApp(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return null;
    }

    final digits = extractDigits(trimmed);
    if (digits.length != 13) {
      return 'WhatsApp inválido';
    }
    return null;
  }

  static String? validateAtLeastOneContact({
    required String? phone,
    required String? whatsApp,
    required String? email,
  }) {
    final hasPhone = extractDigits(phone).isNotEmpty;
    final hasWhatsApp = extractDigits(whatsApp).isNotEmpty;
    final hasEmail = email?.trim().isNotEmpty ?? false;

    if (!hasPhone && !hasWhatsApp && !hasEmail) {
      return 'Informe pelo menos um contato: telefone, WhatsApp ou e-mail.';
    }

    return null;
  }

  static String? validateEmail(String? value) {
    return EmailSanitizer.validateForForm(value);
  }

  static String? validatePostalCode(String? value) {
    final digits = extractDigits(value);
    if (digits.isEmpty) {
      return null;
    }
    if (digits.length != 8) {
      return 'CEP inválido';
    }
    return null;
  }

  static String? validateCpf(String? value) {
    final digits = extractDigits(value);
    if (digits.isEmpty) {
      return null;
    }
    if (!BrazilianCpfValidator.isValid(digits)) {
      return 'CPF inválido';
    }
    return null;
  }

  static String? validateCnpj(String? value) {
    final digits = extractDigits(value);
    if (digits.isEmpty) {
      return null;
    }
    if (!BrazilianCnpjValidator.isValid(digits)) {
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

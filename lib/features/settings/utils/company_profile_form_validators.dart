import 'package:eventpro/core/formatting/text_input_masks.dart';
import 'package:eventpro/core/validation/brazilian_cnpj_validator.dart';
import 'package:eventpro/core/validation/brazilian_cpf_validator.dart';
import 'package:eventpro/core/validation/email_sanitizer.dart';
import 'package:eventpro/core/validation/input_digits.dart';

import '../models/company_profile.dart';
import '../models/pix_key_type.dart';

abstract class CompanyProfileFormValidators {
  static String extractDigits(String? value) {
    return InputDigits.extract(value);
  }

  static String? validateTradeName(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Informe o nome comercial da empresa';
    }
    if (trimmed.length < 2) {
      return 'Nome comercial deve ter pelo menos 2 caracteres';
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

  static String? validateWebsite(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return null;
    }

    final normalized = trimmed.toLowerCase();
    final hasScheme = normalized.startsWith('http://') ||
        normalized.startsWith('https://');
    final candidate = hasScheme ? trimmed : 'https://$trimmed';
    final uri = Uri.tryParse(candidate);
    if (uri == null || uri.host.isEmpty) {
      return 'Site inválido';
    }
    return null;
  }

  static String? validateDefaultValidityDays(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Informe a validade padrão em dias';
    }

    final days = int.tryParse(trimmed);
    if (days == null || days <= 0) {
      return 'A validade padrão deve ser maior que zero';
    }
    return null;
  }

  static String? validateLegalRepresentative({
    required String? fullName,
    required String? cpf,
    required String? role,
  }) {
    final started = _isStarted(fullName) || _isStarted(cpf) || _isStarted(role);
    if (!started) {
      return null;
    }

    if (!_isStarted(fullName)) {
      return 'Informe o nome completo do responsável legal';
    }

    final cpfError = validateCpf(cpf);
    if (cpfError != null || extractDigits(cpf).isEmpty) {
      return 'Informe um CPF válido do responsável legal';
    }

    return null;
  }

  static String? validatePix({
    required PixKeyType? pixKeyType,
    required String? pixKey,
  }) {
    final typeSelected = pixKeyType != null;
    final keyStarted = _isStarted(pixKey);

    if (!typeSelected && !keyStarted) {
      return null;
    }

    if (!typeSelected || !keyStarted) {
      return 'Informe o tipo e a chave PIX';
    }

    return validatePixKey(pixKeyType, pixKey!);
  }

  static String? validatePixKey(PixKeyType type, String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return 'Informe a chave PIX';
    }

    return switch (type) {
      PixKeyType.cpf => validateCpf(trimmed) == null
          ? null
          : 'Chave PIX inválida para o tipo selecionado',
      PixKeyType.cnpj => validateCnpj(trimmed) == null
          ? null
          : 'Chave PIX inválida para o tipo selecionado',
      PixKeyType.email => validateEmail(trimmed) == null
          ? null
          : 'Chave PIX inválida para o tipo selecionado',
      PixKeyType.phone => () {
          final digits = extractDigits(trimmed);
          if (digits.length == 10 || digits.length == 11) {
            return validatePhone(trimmed);
          }
          if (digits.length == 13 && digits.startsWith('55')) {
            final ddd = int.tryParse(digits.substring(2, 4));
            if (ddd != null &&
                ddd >= 11 &&
                ddd <= 99 &&
                digits.length >= 5 &&
                digits[4] == '9') {
              return null;
            }
          }
          return 'Chave PIX inválida para o tipo selecionado';
        }(),
      PixKeyType.random =>
        _isValidRandomPixKey(trimmed)
            ? null
            : 'Chave PIX inválida para o tipo selecionado',
    };
  }

  static bool isMinimumValid(CompanyProfile profile) {
    return validateTradeName(profile.tradeName) == null &&
        validateAtLeastOneContact(
          phone: profile.phoneDigits,
          whatsApp: profile.whatsAppDigits,
          email: profile.email,
        ) ==
            null &&
        profile.quoteDefaults.defaultValidityDays > 0;
  }

  static bool _isValidRandomPixKey(String value) {
    final normalized = value.trim().toLowerCase();
    return RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$',
    ).hasMatch(normalized);
  }

  static bool _isStarted(String? value) {
    return value?.trim().isNotEmpty ?? false;
  }

  static String formatCnpjForDisplay(String? digits) {
    final value = digits ?? '';
    if (value.isEmpty) {
      return '';
    }
    return applyDigitMask(value, '##.###.###/####-##');
  }

  static String formatCpfForDisplay(String? digits) {
    final value = digits ?? '';
    if (value.isEmpty) {
      return '';
    }
    return applyDigitMask(value, '###.###.###-##');
  }
}

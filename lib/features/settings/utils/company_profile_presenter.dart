import 'package:eventpro/core/formatting/text_input_masks.dart';

import '../models/company_address.dart';
import '../models/company_profile.dart';

abstract class CompanyProfilePresenter {
  static String? formatPrimaryContact(CompanyProfile profile) {
    final whatsApp = profile.whatsAppDigits;
    if (whatsApp != null && whatsApp.isNotEmpty) {
      return _formatContactDigits(
        whatsApp,
        BrazilianWhatsAppInputFormatter.formatFromDigits,
      );
    }

    final phone = profile.phoneDigits;
    if (phone != null && phone.isNotEmpty) {
      return _formatContactDigits(
        phone,
        BrazilianPhoneInputFormatter.formatFromDigits,
      );
    }

    final email = profile.email?.trim();
    if (email != null && email.isNotEmpty) {
      return email;
    }

    return null;
  }

  static String displayName(CompanyProfile? profile) {
    if (profile == null) {
      return 'Dados da empresa não configurados';
    }
    return profile.tradeName;
  }

  static String? formatCnpj(String? digits) {
    if (digits == null || digits.isEmpty) {
      return null;
    }
    return applyDigitMask(digits, '##.###.###/####-##');
  }

  static String addressSummary(CompanyAddress address) {
    final parts = <String>[];

    void addPart(String? value) {
      final trimmed = value?.trim();
      if (trimmed != null && trimmed.isNotEmpty) {
        parts.add(trimmed);
      }
    }

    addPart(address.street);
    addPart(address.number);
    addPart(address.neighborhood);
    addPart(address.city);
    addPart(address.state);

    if (parts.isEmpty) {
      return '';
    }

    return parts.join(', ');
  }

  static String _formatContactDigits(
    String digits,
    String Function(String) formatter,
  ) {
    final formatted = formatter(digits);
    if (formatted.isEmpty) {
      return digits;
    }
    return formatted;
  }
}

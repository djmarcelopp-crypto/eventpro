import '../client_type.dart';
import '../models/client.dart';
import 'text_input_masks.dart';

abstract class ClientDisplayFormatter {
  static String formatPhone(String digits) {
    return BrazilianPhoneInputFormatter.formatFromDigits(digits);
  }

  static String formatWhatsApp(String digits) {
    return BrazilianWhatsAppInputFormatter.formatFromDigits(digits);
  }

  static String formatDocument(ClientType type, String digits) {
    if (digits.isEmpty) {
      return '';
    }

    return switch (type) {
      ClientType.individual => applyDigitMask(digits, '###.###.###-##'),
      ClientType.company => applyDigitMask(digits, '##.###.###/####-##'),
    };
  }

  static String documentLabel(ClientType type) {
    return switch (type) {
      ClientType.individual => 'CPF',
      ClientType.company => 'CNPJ',
    };
  }

  static String? formatPrimaryContact(Client client) {
    final whatsApp = client.whatsApp;
    if (whatsApp != null && whatsApp.isNotEmpty) {
      return formatWhatsApp(whatsApp);
    }

    final phone = client.phone;
    if (phone != null && phone.isNotEmpty) {
      return formatPhone(phone);
    }

    final email = client.email?.trim();
    if (email != null && email.isNotEmpty) {
      return email;
    }

    return null;
  }
}

extension ClientTypeLabel on ClientType {
  String get label => switch (this) {
        ClientType.individual => 'Pessoa Física',
        ClientType.company => 'Pessoa Jurídica',
      };
}

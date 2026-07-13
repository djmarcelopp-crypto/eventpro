import '../client_type.dart';
import 'text_input_masks.dart';

abstract class ClientDisplayFormatter {
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
}

extension ClientTypeLabel on ClientType {
  String get label => switch (this) {
        ClientType.individual => 'Pessoa Física',
        ClientType.company => 'Pessoa Jurídica',
      };
}

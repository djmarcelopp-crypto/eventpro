import '../data/models/cnpj_company_data.dart';
import 'form_fill_mode.dart';
import 'text_input_masks.dart';

class CnpjFormFieldValues {
  const CnpjFormFieldValues({
    this.name = '',
    this.tradeName = '',
    this.phone = '',
    this.whatsApp = '',
    this.email = '',
    this.postalCode = '',
    this.street = '',
    this.number = '',
    this.complement = '',
    this.neighborhood = '',
    this.city = '',
    this.state = '',
  });

  final String name;
  final String tradeName;
  final String phone;
  final String whatsApp;
  final String email;
  final String postalCode;
  final String street;
  final String number;
  final String complement;
  final String neighborhood;
  final String city;
  final String state;
}

class CnpjFormConflict {
  const CnpjFormConflict({
    required this.fieldLabel,
    required this.currentValue,
    required this.newValue,
  });

  final String fieldLabel;
  final String currentValue;
  final String newValue;
}

abstract class CnpjFormFiller {
  static List<CnpjFormConflict> findConflicts(
    CnpjFormFieldValues current,
    CnpjCompanyData data,
  ) {
    final conflicts = <CnpjFormConflict>[];

    void addConflict(String label, String current, String? incoming) {
      final nextValue = incoming?.trim();
      if (nextValue == null || nextValue.isEmpty) {
        return;
      }
      if (current.trim().isEmpty) {
        return;
      }
      if (current.trim() == nextValue) {
        return;
      }

      conflicts.add(
        CnpjFormConflict(
          fieldLabel: label,
          currentValue: current.trim(),
          newValue: nextValue,
        ),
      );
    }

    addConflict('Nome', current.name, data.legalName);
    addConflict('Nome fantasia', current.tradeName, data.tradeName);
    addConflict(
      'Telefone',
      current.phone,
      _formatPhone(data.phoneDigits),
    );
    addConflict(
      'WhatsApp',
      current.whatsApp,
      _formatWhatsApp(data.whatsAppDigits),
    );
    addConflict('E-mail', current.email, data.email);
    addConflict('CEP', current.postalCode, _formatPostalCode(data.postalCode));
    addConflict('Logradouro', current.street, data.street);
    addConflict('Número', current.number, data.number);
    addConflict('Complemento', current.complement, data.complement);
    addConflict('Bairro', current.neighborhood, data.neighborhood);
    addConflict('Cidade', current.city, data.city);
    addConflict('Estado (UF)', current.state, data.state);

    return conflicts;
  }

  static CnpjFormFieldValues apply(
    CnpjFormFieldValues current,
    CnpjCompanyData data, {
    required FormFillMode mode,
  }) {
    String resolve(String currentValue, String? incoming) {
      final nextValue = incoming?.trim();
      if (nextValue == null || nextValue.isEmpty) {
        return currentValue;
      }

      if (mode == FormFillMode.replaceAll) {
        return nextValue;
      }

      if (currentValue.trim().isEmpty) {
        return nextValue;
      }

      return currentValue;
    }

    return CnpjFormFieldValues(
      name: resolve(current.name, data.legalName),
      tradeName: resolve(current.tradeName, data.tradeName),
      phone: resolve(
        current.phone,
        _formatPhone(data.phoneDigits),
      ),
      whatsApp: resolve(
        current.whatsApp,
        _formatWhatsApp(data.whatsAppDigits),
      ),
      email: resolve(current.email, data.email),
      postalCode: resolve(
        current.postalCode,
        _formatPostalCode(data.postalCode),
      ),
      street: resolve(current.street, data.street),
      number: resolve(current.number, data.number),
      complement: resolve(current.complement, data.complement),
      neighborhood: resolve(current.neighborhood, data.neighborhood),
      city: resolve(current.city, data.city),
      state: resolve(current.state, data.state?.toUpperCase()),
    );
  }

  static String? _formatPhone(String? digits) {
    if (digits == null || digits.isEmpty) {
      return null;
    }
    return BrazilianPhoneInputFormatter.formatFromDigits(digits);
  }

  static String? _formatWhatsApp(String? digits) {
    if (digits == null || digits.isEmpty) {
      return null;
    }
    return BrazilianWhatsAppInputFormatter.formatFromDigits(digits);
  }

  static String? _formatPostalCode(String? digits) {
    if (digits == null || digits.isEmpty) {
      return null;
    }
    return CepInputFormatter.formatFromDigits(digits);
  }
}

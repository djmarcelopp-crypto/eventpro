import 'package:eventpro/core/formatting/text_input_masks.dart';
import 'package:eventpro/core/lookup/form_fill_mode.dart';
import 'package:eventpro/core/lookup/models/cnpj_company_data.dart';

import 'settings_form_conflict.dart';

class SettingsCnpjFormFieldValues {
  const SettingsCnpjFormFieldValues({
    this.tradeName = '',
    this.legalName = '',
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

  final String tradeName;
  final String legalName;
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

abstract class SettingsCnpjFormFiller {
  static List<SettingsFormConflict> findConflicts(
    SettingsCnpjFormFieldValues current,
    CnpjCompanyData data,
  ) {
    final conflicts = <SettingsFormConflict>[];

    void addConflict(String label, String currentValue, String? incoming) {
      final nextValue = incoming?.trim();
      if (nextValue == null || nextValue.isEmpty) {
        return;
      }
      if (currentValue.trim().isEmpty) {
        return;
      }
      if (currentValue.trim() == nextValue) {
        return;
      }

      conflicts.add(
        SettingsFormConflict(
          fieldLabel: label,
          currentValue: currentValue.trim(),
          newValue: nextValue,
        ),
      );
    }

    addConflict('Nome fantasia', current.tradeName, data.tradeName);
    addConflict('Razão social', current.legalName, data.legalName);
    addConflict('Telefone', current.phone, _formatPhone(data.phoneDigits));
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

  static SettingsCnpjFormFieldValues apply(
    SettingsCnpjFormFieldValues current,
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

    return SettingsCnpjFormFieldValues(
      tradeName: resolve(current.tradeName, data.tradeName),
      legalName: resolve(current.legalName, data.legalName),
      phone: resolve(current.phone, _formatPhone(data.phoneDigits)),
      whatsApp: resolve(current.whatsApp, _formatWhatsApp(data.whatsAppDigits)),
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

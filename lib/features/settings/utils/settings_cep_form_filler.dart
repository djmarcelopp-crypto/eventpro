import 'package:eventpro/core/formatting/text_input_masks.dart';
import 'package:eventpro/core/lookup/form_fill_mode.dart';
import 'package:eventpro/core/lookup/models/cep_address_data.dart';

import 'settings_form_conflict.dart';

class SettingsCepFormFieldValues {
  const SettingsCepFormFieldValues({
    this.postalCode = '',
    this.street = '',
    this.neighborhood = '',
    this.city = '',
    this.state = '',
  });

  final String postalCode;
  final String street;
  final String neighborhood;
  final String city;
  final String state;
}

abstract class SettingsCepFormFiller {
  static List<SettingsFormConflict> findConflicts(
    SettingsCepFormFieldValues current,
    CepAddressData data,
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

    addConflict('CEP', current.postalCode, _formatPostalCode(data.postalCode));
    addConflict('Logradouro', current.street, data.street);
    addConflict('Bairro', current.neighborhood, data.neighborhood);
    addConflict('Cidade', current.city, data.city);
    addConflict('Estado (UF)', current.state, data.state);

    return conflicts;
  }

  static SettingsCepFormFieldValues apply(
    SettingsCepFormFieldValues current,
    CepAddressData data, {
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

    return SettingsCepFormFieldValues(
      postalCode: resolve(
        current.postalCode,
        _formatPostalCode(data.postalCode),
      ),
      street: resolve(current.street, data.street),
      neighborhood: resolve(current.neighborhood, data.neighborhood),
      city: resolve(current.city, data.city),
      state: resolve(current.state, data.state?.toUpperCase()),
    );
  }

  static String? _formatPostalCode(String? digits) {
    if (digits == null || digits.isEmpty) {
      return null;
    }
    return CepInputFormatter.formatFromDigits(digits);
  }
}

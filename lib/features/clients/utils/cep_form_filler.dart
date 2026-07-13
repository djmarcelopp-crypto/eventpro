import '../data/models/cep_address_data.dart';
import 'cnpj_form_filler.dart';
import 'form_fill_mode.dart';
import 'text_input_masks.dart';

class CepFormFieldValues {
  const CepFormFieldValues({
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

abstract class CepFormFiller {
  static List<CnpjFormConflict> findConflicts(
    CepFormFieldValues current,
    CepAddressData data,
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

    addConflict('CEP', current.postalCode, _formatPostalCode(data.postalCode));
    addConflict('Logradouro', current.street, data.street);
    addConflict('Bairro', current.neighborhood, data.neighborhood);
    addConflict('Cidade', current.city, data.city);
    addConflict('Estado (UF)', current.state, data.state);

    return conflicts;
  }

  static CepFormFieldValues apply(
    CepFormFieldValues current,
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

    return CepFormFieldValues(
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

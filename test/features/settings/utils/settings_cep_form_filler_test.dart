import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/core/lookup/form_fill_mode.dart';
import 'package:eventpro/core/lookup/models/cep_address_data.dart';
import 'package:eventpro/features/settings/utils/settings_cep_form_filler.dart';

void main() {
  group('SettingsCepFormFiller', () {
    const cepData = CepAddressData(
      postalCode: '79002010',
      street: 'Rua Exemplo',
      neighborhood: 'Centro',
      city: 'Campo Grande',
      state: 'MS',
    );

    test('preenche endereço sem número ou complemento', () {
      const current = SettingsCepFormFieldValues();

      final result = SettingsCepFormFiller.apply(
        current,
        cepData,
        mode: FormFillMode.fillEmptyOnly,
      );

      expect(result.postalCode, '79002-010');
      expect(result.street, 'Rua Exemplo');
      expect(result.neighborhood, 'Centro');
      expect(result.city, 'Campo Grande');
      expect(result.state, 'MS');
    });

    test('não inclui número ou complemento no modelo', () {
      expect(const SettingsCepFormFieldValues().street, '');
      expect(const SettingsCepFormFieldValues().neighborhood, '');
    });
  });
}

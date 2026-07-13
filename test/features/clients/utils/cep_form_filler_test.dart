import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/clients/data/models/cep_address_data.dart';
import 'package:eventpro/features/clients/utils/cep_form_filler.dart';
import 'package:eventpro/features/clients/utils/form_fill_mode.dart';

void main() {
  group('CepFormFiller', () {
    const incoming = CepAddressData(
      postalCode: '79002050',
      street: 'Rua Exemplo',
      neighborhood: 'Centro',
      city: 'Campo Grande',
      state: 'MS',
    );

    test('preenche campos vazios sem alterar número e complemento', () {
      const current = CepFormFieldValues();

      final result = CepFormFiller.apply(
        current,
        incoming,
        mode: FormFillMode.fillEmptyOnly,
      );

      expect(result.postalCode, '79002-050');
      expect(result.street, 'Rua Exemplo');
      expect(result.neighborhood, 'Centro');
      expect(result.city, 'Campo Grande');
      expect(result.state, 'MS');
    });

    test('não sobrescreve campos preenchidos no modo fillEmptyOnly', () {
      const current = CepFormFieldValues(
        street: 'Rua Manual',
        city: 'Outra Cidade',
      );

      final result = CepFormFiller.apply(
        current,
        incoming,
        mode: FormFillMode.fillEmptyOnly,
      );

      expect(result.street, 'Rua Manual');
      expect(result.city, 'Outra Cidade');
      expect(result.neighborhood, 'Centro');
    });

    test('substitui campos no modo replaceAll', () {
      const current = CepFormFieldValues(
        street: 'Rua Manual',
        city: 'Outra Cidade',
      );

      final result = CepFormFiller.apply(
        current,
        incoming,
        mode: FormFillMode.replaceAll,
      );

      expect(result.street, 'Rua Exemplo');
      expect(result.city, 'Campo Grande');
    });

    test('detecta conflitos', () {
      const current = CepFormFieldValues(
        street: 'Rua Manual',
        state: 'SP',
      );

      final conflicts = CepFormFiller.findConflicts(current, incoming);

      expect(conflicts, hasLength(2));
      expect(conflicts[0].fieldLabel, 'Logradouro');
      expect(conflicts[1].fieldLabel, 'Estado (UF)');
    });
  });
}

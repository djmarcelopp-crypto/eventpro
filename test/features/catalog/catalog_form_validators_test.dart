import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/catalog/catalog_billing_unit.dart';
import 'package:eventpro/features/catalog/catalog_form_validators.dart';

void main() {
  group('CatalogFormValidators', () {
    test('validateName rejeita vazio e aceita nome válido', () {
      expect(CatalogFormValidators.validateName(null), 'Informe o nome do item');
      expect(CatalogFormValidators.validateName(' '), 'Informe o nome do item');
      expect(CatalogFormValidators.validateName('A'), isNotNull);
      expect(CatalogFormValidators.validateName('Caixa de som'), isNull);
    });

    test('validateCustomUnit exige texto quando unidade é Outro', () {
      expect(
        CatalogFormValidators.validateCustomUnit(
          unit: CatalogBillingUnit.unit,
          value: null,
        ),
        isNull,
      );
      expect(
        CatalogFormValidators.validateCustomUnit(
          unit: CatalogBillingUnit.other,
          value: null,
        ),
        'Informe a unidade personalizada',
      );
      expect(
        CatalogFormValidators.validateCustomUnit(
          unit: CatalogBillingUnit.other,
          value: 'Pacote',
        ),
        isNull,
      );
    });

    test('validatePrice rejeita vazio, inválido, zero e negativo', () {
      expect(CatalogFormValidators.validatePrice(null), 'Informe o preço');
      expect(CatalogFormValidators.validatePrice(''), 'Informe o preço');
      expect(CatalogFormValidators.validatePrice('abc'), 'Preço inválido');
      expect(
        CatalogFormValidators.validatePrice('0'),
        'Informe um preço maior que zero',
      );
      expect(
        CatalogFormValidators.validatePrice('0,00'),
        'Informe um preço maior que zero',
      );
      expect(CatalogFormValidators.validatePrice('1500'), isNull);
      expect(CatalogFormValidators.validatePrice('1.500,00'), isNull);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/catalog/catalog_billing_unit.dart';

void main() {
  group('CatalogBillingUnit', () {
    test('labels das unidades iniciais', () {
      expect(CatalogBillingUnit.unit.label, 'Unidade');
      expect(CatalogBillingUnit.daily.label, 'Diária');
      expect(CatalogBillingUnit.hour.label, 'Hora');
      expect(CatalogBillingUnit.meter.label, 'Metro');
      expect(CatalogBillingUnit.squareMeter.label, 'Metro quadrado');
      expect(CatalogBillingUnit.event.label, 'Evento');
      expect(CatalogBillingUnit.service.label, 'Serviço');
      expect(CatalogBillingUnit.other.label, 'Outro');
    });

    test('resolve retorna label predefinida', () {
      expect(
        CatalogBillingUnitResolver.resolve(
          unit: CatalogBillingUnit.daily,
        ),
        'Diária',
      );
    });

    test('resolve retorna unidade personalizada para Outro', () {
      expect(
        CatalogBillingUnitResolver.resolve(
          unit: CatalogBillingUnit.other,
          customUnit: ' Pacote especial ',
        ),
        'Pacote especial',
      );
    });

    test('fromStoredUnit retorna unidade predefinida', () {
      final values = CatalogBillingUnitResolver.fromStoredUnit('Diária');
      expect(values.unit, CatalogBillingUnit.daily);
      expect(values.customUnit, isNull);
    });

    test('fromStoredUnit retorna Outro para texto customizado', () {
      final values = CatalogBillingUnitResolver.fromStoredUnit('Pacote VIP');
      expect(values.unit, CatalogBillingUnit.other);
      expect(values.customUnit, 'Pacote VIP');
    });
  });
}

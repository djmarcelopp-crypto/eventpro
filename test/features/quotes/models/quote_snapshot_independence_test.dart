import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/clients/client_type.dart';
import 'package:eventpro/features/catalog/catalog_category.dart';
import 'package:eventpro/features/catalog/catalog_item_type.dart';
import 'package:eventpro/features/catalog/models/catalog_item.dart';
import 'package:eventpro/features/quotes/models/quote_client_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_line_item.dart';
import '../quotes_test_helpers.dart';

void main() {
  group('Snapshots independentes das fontes', () {
    test('alterar cliente não altera QuoteClientSnapshot', () {
      final client = sampleClient(name: 'Maria Silva');
      final snapshot = QuoteClientSnapshot.fromClient(client);

      final updatedClient = client.copyWith(name: 'Maria Atualizada');

      expect(snapshot.displayName, 'Maria Silva');
      expect(updatedClient.name, 'Maria Atualizada');
    });

    test('alterar item do catálogo não altera QuoteLineItem', () {
      final catalogItem = sampleCatalogItem(name: 'Caixa de som', price: 1500);
      final lineItem = QuoteLineItem.fromCatalogItem(
        catalogItem,
        quantity: 1,
      );

      final updatedItem = catalogItem.copyWith(
        name: 'Caixa premium',
        price: 3000,
      );

      expect(lineItem.name, 'Caixa de som');
      expect(lineItem.unitPriceCents, 150_000);
      expect(updatedItem.name, 'Caixa premium');
      expect(updatedItem.price, 3000);
    });

    test('desativar item do catálogo não afeta linha congelada', () {
      final activeItem = CatalogItem.fromForm(
        type: CatalogItemType.equipment,
        name: 'Painel LED',
        category: CatalogCategory.ledPanel,
        unit: 'Unidade',
        price: 3500,
        active: true,
        id: 'led-1',
      );

      final lineItem = QuoteLineItem.fromCatalogItem(activeItem, quantity: 2);
      final inactiveItem = activeItem.copyWith(active: false);

      expect(lineItem.name, 'Painel LED');
      expect(lineItem.lineTotalCents, 700_000);
      expect(inactiveItem.active, isFalse);
    });

    test('snapshot de cliente não contém internalNotes', () {
      final snapshot = QuoteClientSnapshot.fromClient(
        sampleClient(
          type: ClientType.company,
          internalNotes: 'Nota secreta',
        ),
      );

      expect(snapshot.displayName, isNot(contains('Nota secreta')));
    });
  });
}

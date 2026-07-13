import 'package:flutter_test/flutter_test.dart';

import 'package:eventpro/features/quotes/models/quote_line_draft.dart';
import 'package:eventpro/features/quotes/utils/quote_line_draft_saver.dart';
import '../quotes_test_helpers.dart';

void main() {
  group('QuoteLineDraftSaver', () {
    QuoteLineDraft existingDraft({
      String catalogItemId = 'item-1',
      String name = 'Nome congelado',
      String unit = 'Unidade',
    }) {
      return QuoteLineDraft(
        draftId: 'line_1',
        catalogItemId: catalogItemId,
        name: name,
        description: 'Descrição congelada',
        unit: unit,
        quantityText: '2',
        priceText: '1.500,00',
        isExistingLine: true,
      );
    }

    QuoteLineDraft newDraft({
      String catalogItemId = 'item-2',
      String name = 'Item novo',
    }) {
      return QuoteLineDraft(
        draftId: 'line_2',
        catalogItemId: catalogItemId,
        name: name,
        unit: 'Unidade',
        quantityText: '1',
        priceText: '100,00',
        isExistingLine: false,
      );
    }

    test('linha existente preserva snapshot mesmo com item renomeado', () {
      final draft = existingDraft(name: 'Nome congelado', unit: 'Pacote');
      final renamed = sampleCatalogItem(
        id: 'item-1',
        name: 'Nome atualizado no catálogo',
      ).copyWith(unit: 'Caixa');

      final result = QuoteLineDraftSaver.buildLineItems(
        drafts: [draft],
        findCatalogItem: (id) => id == 'item-1' ? renamed : null,
      );

      expect(result.isSuccess, isTrue);
      final item = result.items!.single;
      expect(item.name, 'Nome congelado');
      expect(item.unit, 'Pacote');
      expect(item.description, 'Descrição congelada');
    });

    test('linha existente salva com item inativo no catálogo', () {
      final draft = existingDraft();
      final inactive = sampleCatalogItem(active: false);

      final result = QuoteLineDraftSaver.buildLineItems(
        drafts: [draft],
        findCatalogItem: (_) => inactive,
      );

      expect(result.isSuccess, isTrue);
      expect(result.items!.single.name, 'Nome congelado');
    });

    test('linha existente salva com item ausente no catálogo', () {
      final draft = existingDraft();

      final result = QuoteLineDraftSaver.buildLineItems(
        drafts: [draft],
        findCatalogItem: (_) => null,
      );

      expect(result.isSuccess, isTrue);
      expect(result.items!.single.catalogItemId, 'item-1');
      expect(result.items!.single.name, 'Nome congelado');
    });

    test('linha nova bloqueia item inativo', () {
      final draft = newDraft();
      final inactive = sampleCatalogItem(id: 'item-2', active: false);

      final result = QuoteLineDraftSaver.buildLineItems(
        drafts: [draft],
        findCatalogItem: (_) => inactive,
      );

      expect(result.isSuccess, isFalse);
      expect(
        result.errorMessage,
        contains('inativo'),
      );
    });

    test('linha nova bloqueia item ausente', () {
      final draft = newDraft();

      final result = QuoteLineDraftSaver.buildLineItems(
        drafts: [draft],
        findCatalogItem: (_) => null,
      );

      expect(result.isSuccess, isFalse);
      expect(
        result.errorMessage,
        contains('não está mais disponível'),
      );
    });

    test('linha nova usa dados atuais do catálogo', () {
      final draft = newDraft(name: 'Rascunho temporário');
      final catalogItem = sampleCatalogItem(
        id: 'item-2',
        name: 'Nome do catálogo',
      ).copyWith(description: 'Descrição atual', unit: 'Kit');

      final result = QuoteLineDraftSaver.buildLineItems(
        drafts: [draft],
        findCatalogItem: (_) => catalogItem,
      );

      expect(result.isSuccess, isTrue);
      final item = result.items!.single;
      expect(item.name, 'Nome do catálogo');
      expect(item.description, 'Descrição atual');
      expect(item.unit, 'Kit');
    });
  });
}

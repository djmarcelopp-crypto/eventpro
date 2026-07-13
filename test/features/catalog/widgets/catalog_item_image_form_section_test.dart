import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/catalog/widgets/catalog_item_image_form_section.dart';

void main() {
  testWidgets('exibe selecionar foto quando não há preview', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: CatalogItemImageFormSection(
              previewReference: null,
              onSelectPhoto: () {},
              onReplacePhoto: () {},
              onRemovePhoto: () {},
            ),
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('catalog_select_photo_button')), findsOneWidget);
    expect(find.byKey(const Key('catalog_replace_photo_button')), findsNothing);
    expect(find.byKey(const Key('catalog_remove_photo_button')), findsNothing);
  });

  testWidgets('exibe trocar e remover quando há preview', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: CatalogItemImageFormSection(
              previewReference: 'catalog/images/item-1.jpg',
              onSelectPhoto: () {},
              onReplacePhoto: () {},
              onRemovePhoto: () {},
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.byKey(const Key('catalog_select_photo_button')), findsNothing);
    expect(find.byKey(const Key('catalog_replace_photo_button')), findsOneWidget);
    expect(find.byKey(const Key('catalog_remove_photo_button')), findsOneWidget);
  });
}

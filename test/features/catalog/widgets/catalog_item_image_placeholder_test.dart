import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/catalog/widgets/catalog_item_image_placeholder.dart';

void main() {
  testWidgets('CatalogItemImagePlaceholder usa estilo Premium Dark', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CatalogItemImagePlaceholder(),
        ),
      ),
    );

    expect(find.byKey(const Key('catalog_item_image_placeholder')), findsOneWidget);
    expect(find.byIcon(Icons.image_outlined), findsOneWidget);
  });
}

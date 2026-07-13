import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/catalog/providers/catalog_image_services_provider.dart';
import 'package:eventpro/features/catalog/widgets/catalog_item_image_view.dart';

import '../fakes/fake_catalog_image_picker_service.dart';
import '../fakes/fake_catalog_image_storage_service.dart';

void main() {
  testWidgets('exibe placeholder quando referência é nula', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: CatalogItemImageView(),
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('catalog_item_image_placeholder')), findsOneWidget);
  });

  testWidgets('exibe imagem quando referência existe', (tester) async {
    const reference = 'catalog/images/item-1_test.jpg';
    final storage = FakeCatalogImageStorageService();
    storage.seedCommitted(reference, kTestPngBytes);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          catalogImageStorageProvider.overrideWithValue(storage),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: CatalogItemImageView(imageReference: reference),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump();

    expect(find.byType(Image), findsOneWidget);
    expect(find.byKey(const Key('catalog_item_image_placeholder')), findsNothing);
  });

  testWidgets('usa placeholder quando imagem está indisponível', (tester) async {
    const reference = 'catalog/images/missing.jpg';
    final storage = FakeCatalogImageStorageService();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          catalogImageStorageProvider.overrideWithValue(storage),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: CatalogItemImageView(imageReference: reference),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump();

    expect(find.byKey(const Key('catalog_item_image_placeholder')), findsOneWidget);
  });
}

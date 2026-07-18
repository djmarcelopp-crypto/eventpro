import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:eventpro/core/widgets/app_text_field.dart';
import 'package:eventpro/features/catalog/catalog_billing_unit.dart';
import 'package:eventpro/features/catalog/catalog_category.dart';
import 'package:eventpro/features/catalog/catalog_item_type.dart';
import 'package:eventpro/features/catalog/models/catalog_item.dart';
import 'package:eventpro/features/catalog/data/exceptions/catalog_image_pick_exception.dart';
import 'package:eventpro/features/catalog/data/models/catalog_image_pick_result.dart';
import 'package:eventpro/features/catalog/new_catalog_item_screen.dart';
import 'package:eventpro/features/catalog/providers/catalog_image_services_provider.dart';
import 'package:eventpro/features/catalog/providers/catalog_provider.dart';

import 'fakes/catalog_repository_test_overrides.dart';
import 'fakes/fake_catalog_image_picker_service.dart';
import 'fakes/fake_catalog_image_storage_service.dart';

Future<TextEditingValue> _typeCharInField(
  WidgetTester tester,
  Finder field,
  String char,
) async {
  final editableFinder = find.descendant(
    of: field,
    matching: find.byType(EditableText),
  );
  final editable = tester.state<EditableTextState>(editableFinder);
  final current = editable.textEditingValue;
  final newText = '${current.text}$char';
  editable.updateEditingValue(
    TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    ),
  );
  await tester.pump();
  return editable.textEditingValue;
}

EditableTextState _editableForField(WidgetTester tester, Finder field) {
  return tester.state<EditableTextState>(
    find.descendant(
      of: field,
      matching: find.byType(EditableText),
    ),
  );
}

Future<void> _tapCatalogSave(WidgetTester tester) async {
  final saveButton = find.byKey(const Key('catalog_save_button'));
  final formScrollable = find.ancestor(
    of: saveButton,
    matching: find.byType(Scrollable),
  );
  await tester.scrollUntilVisible(
    saveButton,
    800,
    scrollable: formScrollable,
  );
  await tester.pumpAndSettle();
  await tester.ensureVisible(saveButton);
  await tester.pumpAndSettle();
  await tester.tap(saveButton);
  await tester.pumpAndSettle();
}

Future<void> _tapPhotoButton(WidgetTester tester, Key key) async {
  final button = find.byKey(key);
  final formScrollable = find.ancestor(
    of: button,
    matching: find.byType(Scrollable),
  );
  await tester.scrollUntilVisible(
    button,
    800,
    scrollable: formScrollable,
  );
  await tester.pumpAndSettle();
  await tester.ensureVisible(button);
  await tester.tap(button);
  for (var attempt = 0; attempt < 30; attempt++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
  await tester.pumpAndSettle();
}

void main() {
  Future<void> pumpForm(WidgetTester tester) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const NewCatalogItemScreen(),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: catalogRepositoryOverrides(),
        child: MaterialApp.router(
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('NewCatalogItemScreen', () {
    testWidgets('valida campos obrigatórios', (tester) async {
      await pumpForm(tester);

      await _tapCatalogSave(tester);

      expect(find.text('Informe o nome do item'), findsOneWidget);
      expect(find.text('Informe o preço'), findsOneWidget);
    });

    testWidgets('exibe e valida unidade personalizada apenas para Outro', (
      tester,
    ) async {
      await pumpForm(tester);

      expect(find.byKey(const Key('catalog_unit_custom_field')), findsNothing);

      await tester.tap(find.byKey(const Key('catalog_unit_field')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Outro').last);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('catalog_unit_custom_field')), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('catalog_name_field')),
        'Pacote especial',
      );
      await tester.enterText(
        find.byKey(const Key('catalog_price_field')),
        '1500',
      );
      await _tapCatalogSave(tester);

      expect(find.text('Informe a unidade personalizada'), findsOneWidget);
    });

    testWidgets('limpa unidade personalizada ao sair de Outro', (
      tester,
    ) async {
      await pumpForm(tester);

      await tester.tap(find.byKey(const Key('catalog_unit_field')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Outro').last);
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('catalog_unit_custom_field')),
        'Pacote VIP',
      );

      await tester.tap(find.byKey(const Key('catalog_unit_field')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Diária').last);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('catalog_unit_custom_field')), findsNothing);

      await tester.tap(find.byKey(const Key('catalog_unit_field')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Outro').last);
      await tester.pumpAndSettle();

      expect(
        find.byKey(const Key('catalog_unit_custom_field')),
        findsOneWidget,
      );
      expect(
        tester.widget<AppTextField>(
          find.byKey(const Key('catalog_unit_custom_field')),
        ).controller?.text,
        isEmpty,
      );
    });

    testWidgets('permite digitar 10,50 no campo de preço do formulário', (
      tester,
    ) async {
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const NewCatalogItemScreen(),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: catalogRepositoryOverrides(),
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      final priceField = find.byKey(const Key('catalog_price_field'));
      await tester.tap(priceField);
      await tester.pumpAndSettle();

      var editingValue = await _typeCharInField(tester, priceField, '1');
      expect(editingValue.text, '1');
      expect(editingValue.selection.baseOffset, 1);

      editingValue = await _typeCharInField(tester, priceField, '0');
      expect(editingValue.text, '10');
      expect(editingValue.selection.baseOffset, 2);

      editingValue = await _typeCharInField(tester, priceField, ',');
      expect(editingValue.text, '10,');
      expect(editingValue.selection.baseOffset, 3);

      editingValue = await _typeCharInField(tester, priceField, '5');
      expect(editingValue.text, '10,5');
      expect(editingValue.selection.baseOffset, 4);

      editingValue = await _typeCharInField(tester, priceField, '0');
      expect(editingValue.text, '10,50');
      expect(editingValue.selection.baseOffset, 5);

      expect(
        _editableForField(tester, priceField).textEditingValue.text,
        '10,50',
      );

      await tester.enterText(
        find.byKey(const Key('catalog_name_field')),
        'Serviço teste',
      );

      final container = ProviderScope.containerOf(
        tester.element(find.byType(NewCatalogItemScreen)),
      );

      await _tapCatalogSave(tester);
      tester.takeException();

      final items = container.read(catalogProvider);
      expect(items.single.price, 10.5);
    });

    testWidgets('salva item no provider com preço formatado', (
      tester,
    ) async {
      final router = GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const NewCatalogItemScreen(),
          ),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: catalogRepositoryOverrides(),
          child: MaterialApp.router(
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('catalog_name_field')),
        'Caixa de som',
      );
      await tester.enterText(
        find.byKey(const Key('catalog_price_field')),
        '1.500,00',
      );

      final container = ProviderScope.containerOf(
        tester.element(find.byType(NewCatalogItemScreen)),
      );

      await _tapCatalogSave(tester);
      tester.takeException();

      final items = container.read(catalogProvider);
      expect(items, hasLength(1));
      expect(items.single.name, 'Caixa de som');
      expect(items.single.price, 1500);
      expect(items.single.unit, CatalogBillingUnit.unit.label);
      expect(items.single.category, CatalogCategory.sound);
      expect(items.single.imageReference, isNull);
    });

    testWidgets('salva edição preservando id, createdAt e imageReference', (
      tester,
    ) async {
      final createdAt = DateTime(2024, 2, 10);
      final item = CatalogItem.fromForm(
        type: CatalogItemType.equipment,
        name: 'Mesa de som',
        category: CatalogCategory.sound,
        unit: 'Unidade',
        price: 1200,
        imageReference: 'catalog/items/mesa.jpg',
        id: 'item-edit-1',
        createdAt: createdAt,
      );

      late GoRouter router;

      late ProviderContainer container;
      final storage = FakeCatalogImageStorageService();
      storage.seedCommitted('catalog/items/mesa.jpg', kTestPngBytes);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container = ProviderContainer(
            overrides: [
              ...catalogRepositoryOverrides(),
              catalogImageStorageProvider.overrideWithValue(storage),
            ],
          ),
          child: MaterialApp.router(
            routerConfig: router = GoRouter(
              initialLocation: '/',
              routes: [
                GoRoute(
                  path: '/',
                  builder: (context, state) => const Scaffold(
                    body: Text('Lista do catálogo'),
                  ),
                ),
                GoRoute(
                  path: '/edit',
                  builder: (context, state) => NewCatalogItemScreen(
                    itemId: item.id,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await container.read(catalogProvider.notifier).addItem(item);
      router.go('/edit');
      await tester.pumpAndSettle();

      expect(find.text('Editar item'), findsOneWidget);
      expect(
        tester.widget<AppTextField>(find.byKey(const Key('catalog_name_field')))
            .controller
            ?.text,
        'Mesa de som',
      );

      await tester.enterText(
        find.byKey(const Key('catalog_name_field')),
        'Mesa atualizada',
      );
      await _tapCatalogSave(tester);

      final updated = container.read(catalogProvider).single;
      expect(updated.name, 'Mesa atualizada');
      expect(updated.id, 'item-edit-1');
      expect(updated.createdAt, createdAt);
      expect(updated.imageReference, 'catalog/items/mesa.jpg');
    });

    testWidgets('seleciona foto com sucesso no cadastro', (tester) async {
      final picker = FakeCatalogImagePickerService(
        pickResult: CatalogImagePickResult(
          bytes: kTestPngBytes,
          extension: 'png',
        ),
      );
      final storage = FakeCatalogImageStorageService();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            catalogImagePickerProvider.overrideWithValue(picker),
            catalogImageStorageProvider.overrideWithValue(storage),
          ],
          child: MaterialApp(
            home: const NewCatalogItemScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await _tapPhotoButton(tester, const Key('catalog_select_photo_button'));

      expect(picker.pickCount, 1);
      expect(storage.stageCallCount, 1);
      expect(find.byKey(const Key('catalog_replace_photo_button')), findsOneWidget);
      expect(picker.pickCount, 1);
    });

    testWidgets('cancelamento da seleção não exibe erro', (tester) async {
      final picker = FakeCatalogImagePickerService(pickResult: null);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            catalogImagePickerProvider.overrideWithValue(picker),
            catalogImageStorageProvider.overrideWithValue(
              FakeCatalogImageStorageService(),
            ),
          ],
          child: MaterialApp(
            home: const NewCatalogItemScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await _tapPhotoButton(tester, const Key('catalog_select_photo_button'));

      expect(find.byKey(const Key('catalog_select_photo_button')), findsOneWidget);
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('erro real do seletor exibe mensagem amigável', (tester) async {
      final picker = FakeCatalogImagePickerService(
        pickException: const CatalogImagePickException(
          'Não foi possível abrir o seletor de imagens. Tente novamente.',
        ),
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            catalogImagePickerProvider.overrideWithValue(picker),
            catalogImageStorageProvider.overrideWithValue(
              FakeCatalogImageStorageService(),
            ),
          ],
          child: MaterialApp(
            home: const NewCatalogItemScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await _tapPhotoButton(tester, const Key('catalog_select_photo_button'));

      expect(find.text('Não foi possível abrir o seletor de imagens. Tente novamente.'), findsOneWidget);
      expect(find.byKey(const Key('catalog_select_photo_button')), findsOneWidget);
    });

    testWidgets('remover foto volta ao placeholder', (tester) async {
      final picker = FakeCatalogImagePickerService(
        pickResult: CatalogImagePickResult(
          bytes: kTestPngBytes,
          extension: 'png',
        ),
      );
      final storage = FakeCatalogImageStorageService();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            catalogImagePickerProvider.overrideWithValue(picker),
            catalogImageStorageProvider.overrideWithValue(storage),
          ],
          child: MaterialApp(
            home: const NewCatalogItemScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      await _tapPhotoButton(tester, const Key('catalog_select_photo_button'));
      await _tapPhotoButton(tester, const Key('catalog_remove_photo_button'));

      expect(find.byKey(const Key('catalog_select_photo_button')), findsOneWidget);
    });
  });
}

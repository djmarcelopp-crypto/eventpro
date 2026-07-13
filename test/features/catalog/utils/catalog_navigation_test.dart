import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:eventpro/features/catalog/utils/catalog_navigation.dart';
import 'package:eventpro/main.dart';

void main() {
  group('CatalogNavigation', () {
    testWidgets('popToCatalogList retorna da edição para a lista', (
      tester,
    ) async {
      final router = GoRouter(
        initialLocation: '/catalog/item-1/edit',
        routes: [
          GoRoute(
            path: '/catalog',
            builder: (context, state) => const Scaffold(
              body: Text('Lista do catálogo'),
            ),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => const Scaffold(
                  body: Text('Detalhes'),
                ),
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) => Scaffold(
                      body: ElevatedButton(
                        onPressed: () =>
                            CatalogNavigation.popToCatalogList(context),
                        child: const Text('Salvar'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      expect(find.text('Salvar'), findsOneWidget);

      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();

      expect(find.text('Lista do catálogo'), findsOneWidget);
      expect(find.text('Detalhes'), findsNothing);
    });

    testWidgets('popToCatalogList exibe feedback de edição', (
      tester,
    ) async {
      final router = GoRouter(
        initialLocation: '/catalog/item-1/edit',
        routes: [
          GoRoute(
            path: '/catalog',
            builder: (context, state) => const Scaffold(
              body: Text('Lista do catálogo'),
            ),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => const Scaffold(
                  body: Text('Detalhes'),
                ),
                routes: [
                  GoRoute(
                    path: 'edit',
                    builder: (context, state) => Scaffold(
                      body: ElevatedButton(
                        onPressed: () => CatalogNavigation.popToCatalogList(
                          context,
                          showUpdatedFeedback: true,
                        ),
                        child: const Text('Salvar'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(
          scaffoldMessengerKey: EventProApp.scaffoldMessengerKey,
          routerConfig: router,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Salvar'));
      await tester.pumpAndSettle();

      expect(find.text('Lista do catálogo'), findsOneWidget);
      expect(find.text('Item atualizado com sucesso'), findsOneWidget);
      expect(find.text('Detalhes'), findsNothing);
    });

    testWidgets('leaveCatalog usa pop quando há pilha anterior', (
      tester,
    ) async {
      final router = GoRouter(
        initialLocation: '/dashboard',
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const Scaffold(
              body: Text('Dashboard'),
            ),
          ),
          GoRoute(
            path: '/catalog',
            builder: (context, state) => Scaffold(
              body: ElevatedButton(
                onPressed: () => CatalogNavigation.leaveCatalog(context),
                child: const Text('Voltar'),
              ),
            ),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      router.push('/catalog');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Voltar'));
      await tester.pumpAndSettle();

      expect(find.text('Dashboard'), findsOneWidget);
    });

    testWidgets('leaveCatalog usa fallback para Dashboard sem pilha', (
      tester,
    ) async {
      final router = GoRouter(
        initialLocation: '/catalog',
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const Scaffold(
              body: Text('Dashboard'),
            ),
          ),
          GoRoute(
            path: '/catalog',
            builder: (context, state) => Scaffold(
              body: ElevatedButton(
                onPressed: () => CatalogNavigation.leaveCatalog(context),
                child: const Text('Voltar'),
              ),
            ),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Voltar'));
      await tester.pumpAndSettle();

      expect(find.text('Dashboard'), findsOneWidget);
    });
  });
}

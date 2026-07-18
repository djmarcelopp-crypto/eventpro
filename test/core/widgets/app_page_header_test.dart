import 'package:eventpro/app/router/app_router.dart';
import 'package:eventpro/core/widgets/app_page_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  group('AppPageHeader', () {
    testWidgets('pops when stack has a previous route', (tester) async {
      final router = GoRouter(
        initialLocation: '/list',
        routes: [
          GoRoute(
            path: '/list',
            builder: (context, state) => const Scaffold(
              body: Text('LIST'),
            ),
            routes: [
              GoRoute(
                path: 'detail',
                builder: (context, state) => const Scaffold(
                  appBar: AppPageHeader(title: 'Detalhe'),
                  body: Text('DETAIL'),
                ),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (context, state) => const Scaffold(
              body: Text('DASHBOARD'),
            ),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      router.push('/list/detail');
      await tester.pumpAndSettle();

      expect(find.text('DETAIL'), findsOneWidget);
      await tester.tap(find.byTooltip('Voltar'));
      await tester.pumpAndSettle();

      expect(find.text('LIST'), findsOneWidget);
      expect(find.text('DASHBOARD'), findsNothing);
    });

    testWidgets('falls back to dashboard when there is no stack', (tester) async {
      final router = GoRouter(
        initialLocation: '/clients',
        routes: [
          GoRoute(
            path: '/clients',
            builder: (context, state) => const Scaffold(
              appBar: AppPageHeader(title: 'Clientes'),
              body: Text('CLIENTS'),
            ),
          ),
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (context, state) => const Scaffold(
              body: Text('DASHBOARD'),
            ),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Voltar'));
      await tester.pumpAndSettle();

      expect(find.text('DASHBOARD'), findsOneWidget);
      expect(find.text('CLIENTS'), findsNothing);
    });

    testWidgets('shows menu on operations root without stack', (tester) async {
      final router = GoRouter(
        initialLocation: AppRoutes.dashboard,
        routes: [
          GoRoute(
            path: AppRoutes.dashboard,
            builder: (context, state) => const Scaffold(
              appBar: AppPageHeader(title: 'Centro de Operações'),
              body: Text('DASHBOARD'),
            ),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      expect(find.byTooltip('Voltar'), findsNothing);
      expect(find.byKey(const Key('app_page_menu_button')), findsOneWidget);
    });
  });
}

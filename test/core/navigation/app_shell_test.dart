import 'package:eventpro/app/router/app_router.dart';
import 'package:eventpro/core/navigation/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  group('AppShell', () {
    Widget buildApp({required Size size}) {
      final router = GoRouter(
        initialLocation: AppRoutes.dashboard,
        routes: [
          ShellRoute(
            builder: (context, state, child) => AppShell(child: child),
            routes: [
              GoRoute(
                path: AppRoutes.dashboard,
                builder: (context, state) => const Scaffold(
                  body: Text('DASHBOARD_BODY'),
                ),
              ),
              GoRoute(
                path: AppRoutes.clients,
                builder: (context, state) => const Scaffold(
                  body: Text('CLIENTS_BODY'),
                ),
              ),
            ],
          ),
        ],
      );

      return MediaQuery(
        data: MediaQueryData(size: size),
        child: MaterialApp.router(routerConfig: router),
      );
    }

    testWidgets('uses NavigationRail at width >= 900', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1100, 800));
      addTearDown(() async {
        await tester.binding.setSurfaceSize(null);
      });

      await tester.pumpWidget(buildApp(size: const Size(1100, 800)));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('app_shell_rail')), findsOneWidget);
      expect(find.byKey(const Key('app_shell_drawer')), findsNothing);
    });

    testWidgets('uses Drawer scaffold at width < 900', (tester) async {
      await tester.binding.setSurfaceSize(const Size(390, 800));
      addTearDown(() async {
        await tester.binding.setSurfaceSize(null);
      });

      await tester.pumpWidget(buildApp(size: const Size(390, 800)));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('app_shell_scaffold')), findsOneWidget);
      expect(find.byKey(const Key('app_shell_rail')), findsNothing);
    });
  });
}

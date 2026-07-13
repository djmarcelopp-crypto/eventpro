import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:eventpro/features/settings/settings_feedback.dart';
import 'package:eventpro/features/settings/utils/settings_navigation.dart';
import 'package:eventpro/main.dart';

void main() {
  group('SettingsNavigation', () {
    testWidgets('leaveSettings retorna ao Dashboard com pop', (tester) async {
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
            path: '/settings',
            builder: (context, state) => Scaffold(
              body: ElevatedButton(
                onPressed: () => SettingsNavigation.leaveSettings(context),
                child: const Text('Voltar'),
              ),
            ),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      router.push('/settings');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Voltar'));
      await tester.pumpAndSettle();

      expect(find.text('Dashboard'), findsOneWidget);
    });

    testWidgets('leaveSettings usa fallback para Dashboard sem pilha', (
      tester,
    ) async {
      final router = GoRouter(
        initialLocation: '/settings',
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const Scaffold(
              body: Text('Dashboard'),
            ),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => Scaffold(
              body: ElevatedButton(
                onPressed: () => SettingsNavigation.leaveSettings(context),
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

    testWidgets('leaveCompanyProfile exibe feedback ao salvar', (tester) async {
      final router = GoRouter(
        initialLocation: '/settings/company',
        routes: [
          GoRoute(
            path: '/settings',
            builder: (context, state) => const Scaffold(
              body: Text('Configurações'),
            ),
            routes: [
              GoRoute(
                path: 'company',
                builder: (context, state) => Scaffold(
                  body: ElevatedButton(
                    onPressed: () => SettingsNavigation.leaveCompanyProfile(
                      context,
                      showSavedFeedback: true,
                    ),
                    child: const Text('Salvar'),
                  ),
                ),
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

      expect(find.text('Configurações'), findsOneWidget);
      expect(
        find.text(SettingsFeedbackPresenter.message(SettingsFeedback.saved)),
        findsOneWidget,
      );
    });
  });
}

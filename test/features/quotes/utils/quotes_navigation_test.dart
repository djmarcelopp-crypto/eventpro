import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:eventpro/features/quotes/utils/quotes_navigation.dart';

void main() {
  group('QuotesNavigation', () {
    testWidgets('leaveQuotes usa pop quando há pilha anterior', (tester) async {
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
            path: '/quotes',
            builder: (context, state) => Scaffold(
              body: ElevatedButton(
                onPressed: () => QuotesNavigation.leaveQuotes(context),
                child: const Text('Voltar'),
              ),
            ),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      router.push('/quotes');
      await tester.pumpAndSettle();

      await tester.tap(find.text('Voltar'));
      await tester.pumpAndSettle();

      expect(find.text('Dashboard'), findsOneWidget);
    });

    testWidgets('leaveQuotes usa fallback para Dashboard sem pilha', (
      tester,
    ) async {
      final router = GoRouter(
        initialLocation: '/quotes',
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const Scaffold(
              body: Text('Dashboard'),
            ),
          ),
          GoRoute(
            path: '/quotes',
            builder: (context, state) => Scaffold(
              body: ElevatedButton(
                onPressed: () => QuotesNavigation.leaveQuotes(context),
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

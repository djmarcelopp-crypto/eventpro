import 'package:eventpro/features/dashboard/dashboard_screen.dart';
import 'package:eventpro/features/dashboard/models/dashboard_operations_snapshot.dart';
import 'package:eventpro/features/dashboard/providers/dashboard_operations_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows operations KPIs and modules first', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1280, 900));
    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          dashboardOperationsProvider.overrideWith(
            (ref) => const AsyncValue.data(DashboardOperationsSnapshot.empty),
          ),
        ],
        child: const MaterialApp(home: DashboardScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Módulos'), findsOneWidget);
    expect(find.text('Centro de Operações'), findsOneWidget);
    expect(find.byKey(const Key('dashboard_kpi_grid')), findsOneWidget);
    expect(find.byKey(const Key('dashboard_kpi_events_today')), findsOneWidget);
    expect(find.byKey(const Key('dashboard_alerts_card')), findsOneWidget);
    expect(find.text('Clientes'), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/main.dart';

void main() {
  testWidgets('EventPro inicia corretamente', (WidgetTester tester) async {
    await tester.pumpWidget(const EventProApp());
    await tester.pumpAndSettle();

    expect(find.text('EVENTPRO'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });

  testWidgets('Navega para Clientes e volta ao Dashboard', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const EventProApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    expect(find.text('Bem-vindo ao EventPro'), findsOneWidget);

    await tester.tap(find.text('Clientes'));
    await tester.pumpAndSettle();

    expect(find.text('Nenhum cliente cadastrado'), findsOneWidget);
    expect(find.text('Novo cliente'), findsOneWidget);

    await tester.tap(find.byTooltip('Voltar'));
    await tester.pumpAndSettle();

    expect(find.text('Bem-vindo ao EventPro'), findsOneWidget);
    expect(find.text('Módulos'), findsOneWidget);
  });
}

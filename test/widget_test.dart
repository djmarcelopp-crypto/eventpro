import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/main.dart';

void main() {
  testWidgets('EventPro inicia corretamente', (WidgetTester tester) async {
    await tester.pumpWidget(const EventProApp());

    expect(find.text('EVENTPRO'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });
}

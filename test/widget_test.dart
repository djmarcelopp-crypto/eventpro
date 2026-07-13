import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/app/router/app_router.dart';
import 'package:eventpro/features/clients/utils/client_date_formatter.dart';
import 'package:eventpro/main.dart';

Widget _createTestApp() {
  return const ProviderScope(
    child: EventProApp(),
  );
}

Future<void> _pumpAppFromSplash(WidgetTester tester) async {
  await tester.pumpWidget(_createTestApp());
  await tester.pumpAndSettle();
  AppRouter.router.go(AppRoutes.splash);
  await tester.pumpAndSettle();
}

Future<void> _openClientsScreen(WidgetTester tester) async {
  await _pumpAppFromSplash(tester);

  await tester.tap(find.text('Entrar'));
  await tester.pumpAndSettle();

  await tester.tap(find.text('Clientes'));
  await tester.pumpAndSettle();
}

Future<void> _openNewClientForm(WidgetTester tester) async {
  await _openClientsScreen(tester);

  tester.view.physicalSize = const Size(800, 1200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.tap(find.text('Novo cliente'));
  await tester.pumpAndSettle();
}

Future<void> _tapSave(WidgetTester tester) async {
  final saveButton = find.text('Salvar');
  await tester.scrollUntilVisible(
    saveButton,
    500,
    scrollable: find.byType(Scrollable).first,
  );
  await tester.pumpAndSettle();
  await tester.tap(saveButton);
  await tester.pumpAndSettle();
}

Future<void> _fillRequiredFields(WidgetTester tester) async {
  await tester.enterText(
    find.byKey(const Key('client_name_field')),
    'Maria Silva',
  );
  await tester.enterText(
    find.byKey(const Key('client_whatsapp_field')),
    '67981495959',
  );
}

void main() {
  testWidgets('EventPro inicia corretamente', (WidgetTester tester) async {
    await tester.pumpWidget(_createTestApp());
    await tester.pumpAndSettle();

    expect(find.text('EVENTPRO'), findsOneWidget);
    expect(find.text('Entrar'), findsOneWidget);
  });

  testWidgets('Aplicativo usa locale pt-BR', (WidgetTester tester) async {
    await tester.pumpWidget(_createTestApp());
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
    final materialApp =
        tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.locale, EventProApp.locale);
    expect(materialApp.supportedLocales, contains(EventProApp.locale));
  });

  testWidgets('Navega para Clientes e volta ao Dashboard', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_createTestApp());
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

  testWidgets('Navega para o formulário Novo cliente', (
    WidgetTester tester,
  ) async {
    await _openNewClientForm(tester);

    expect(find.text('Pessoa Física'), findsOneWidget);
    expect(find.text('Pessoa Jurídica'), findsOneWidget);
    expect(find.byKey(const Key('client_name_field')), findsOneWidget);
    expect(find.byKey(const Key('client_whatsapp_field')), findsOneWidget);
    expect(find.text('Logradouro'), findsOneWidget);
    expect(find.text('Observações internas'), findsOneWidget);
    expect(find.text('Salvar'), findsOneWidget);
  });

  testWidgets('Valida campos obrigatórios do formulário', (
    WidgetTester tester,
  ) async {
    await _openNewClientForm(tester);

    await _tapSave(tester);

    expect(find.text('Informe o nome do cliente'), findsOneWidget);
    expect(find.text('Informe o WhatsApp'), findsOneWidget);
  });

  testWidgets('Valida e-mail somente quando preenchido', (
    WidgetTester tester,
  ) async {
    await _openNewClientForm(tester);

    await _fillRequiredFields(tester);
    await tester.enterText(
      find.byKey(const Key('client_email_field')),
      'email-invalido',
    );

    await _tapSave(tester);

    expect(find.text('E-mail inválido'), findsOneWidget);
  });

  testWidgets('Alterna documento entre CPF e CNPJ', (
    WidgetTester tester,
  ) async {
    await _openNewClientForm(tester);

    expect(find.text('CPF'), findsOneWidget);

    await tester.tap(find.text('Pessoa Jurídica'));
    await tester.pumpAndSettle();

    expect(find.text('CNPJ'), findsOneWidget);
    expect(find.text('CPF'), findsNothing);
  });

  testWidgets('Exibe aviso de observações internas', (
    WidgetTester tester,
  ) async {
    await _openNewClientForm(tester);

    expect(
      find.text('Esta informação não aparece no orçamento.'),
      findsOneWidget,
    );
  });

  testWidgets('Converte UF para maiúsculas', (WidgetTester tester) async {
    await _openNewClientForm(tester);

    await tester.enterText(
      find.byKey(const Key('client_state_field')),
      'sp',
    );
    await tester.pumpAndSettle();

    expect(find.text('SP'), findsOneWidget);
  });

  testWidgets('Cadastra cliente e retorna para a lista', (
    WidgetTester tester,
  ) async {
    await _openNewClientForm(tester);

    await _fillRequiredFields(tester);
    await tester.enterText(
      find.byKey(const Key('client_document_field')),
      '12345678901',
    );
    await _tapSave(tester);

    expect(find.text('Cliente cadastrado com sucesso'), findsOneWidget);
    expect(find.text('Maria Silva'), findsOneWidget);
    expect(find.text('Pessoa Física'), findsOneWidget);
    expect(find.text('+55 (67) 98149-5959'), findsOneWidget);
    expect(find.text('CPF: 123.456.789-01'), findsOneWidget);
    expect(find.text('Salvar'), findsNothing);
  });

  testWidgets('Não exibe observações internas no card da lista', (
    WidgetTester tester,
  ) async {
    await _openNewClientForm(tester);

    await _fillRequiredFields(tester);
    await tester.enterText(
      find.byKey(const Key('client_notes_field')),
      'Observação secreta da equipe',
    );
    await _tapSave(tester);

    expect(find.text('Maria Silva'), findsOneWidget);
    expect(find.text('Observação secreta da equipe'), findsNothing);
  });

  testWidgets('Data de aniversário inicia vazia', (WidgetTester tester) async {
    await _openNewClientForm(tester);

    final birthdayField = find.descendant(
      of: find.byKey(const Key('client_birthday_field')),
      matching: find.byType(TextFormField),
    );

    expect(
      tester.widget<TextFormField>(birthdayField).controller?.text ?? '',
      isEmpty,
    );
  });

  testWidgets('Formata data de aniversário em português', (
    WidgetTester tester,
  ) async {
    await _openNewClientForm(tester);

    await tester.tap(find.byKey(const Key('client_birthday_field')));
    await tester.pumpAndSettle();

    expect(find.byType(DatePickerDialog), findsOneWidget);

    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    final now = DateTime.now();
    final expectedDate = ClientDateFormatter.formatBirthday(
      DateTime(now.year, now.month, now.day),
    );

    expect(find.text(expectedDate), findsOneWidget);
  });
}

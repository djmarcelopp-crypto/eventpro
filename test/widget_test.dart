import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/app/router/app_router.dart';
import 'package:eventpro/features/clients/data/exceptions/cep_lookup_exception.dart';
import 'package:eventpro/features/clients/data/exceptions/cnpj_lookup_exception.dart';
import 'package:eventpro/features/clients/providers/cep_lookup_provider.dart';
import 'package:eventpro/features/clients/providers/cnpj_lookup_provider.dart';
import 'package:eventpro/features/clients/utils/client_date_formatter.dart';
import 'package:eventpro/main.dart';

import 'features/clients/fakes/fake_cep_lookup_service.dart';
import 'features/clients/fakes/fake_cnpj_lookup_service.dart';

Widget _createTestApp({List<Override> overrides = const []}) {
  return ProviderScope(
    overrides: overrides,
    child: const EventProApp(),
  );
}

Future<void> _pumpAppFromSplash(
  WidgetTester tester, {
  List<Override> overrides = const [],
}) async {
  await tester.pumpWidget(_createTestApp(overrides: overrides));
  await tester.pumpAndSettle();
  AppRouter.router.go(AppRoutes.splash);
  await tester.pumpAndSettle();
}

Future<void> _openClientsScreen(
  WidgetTester tester, {
  List<Override> overrides = const [],
}) async {
  await _pumpAppFromSplash(tester, overrides: overrides);

  await tester.tap(find.text('Entrar'));
  await tester.pumpAndSettle();

  await tester.tap(find.text('Clientes'));
  await tester.pumpAndSettle();
}

Future<void> _openNewClientForm(
  WidgetTester tester, {
  List<Override> overrides = const [],
}) async {
  await _openClientsScreen(tester, overrides: overrides);

  tester.view.physicalSize = const Size(800, 1200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.tap(find.text('Novo cliente'));
  await tester.pumpAndSettle();
}

Future<void> _selectCompanyAndEnterCnpj(WidgetTester tester) async {
  await tester.tap(find.text('Pessoa Jurídica'));
  await tester.pumpAndSettle();

  await tester.enterText(
    find.byKey(const Key('client_document_field')),
    '11222333000181',
  );
  await tester.pumpAndSettle();
}

  Future<void> _tapSave(WidgetTester tester) async {
    final saveButton = find.text('Salvar');
    await tester.scrollUntilVisible(
      saveButton,
      800,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(saveButton, warnIfMissed: false);
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
      '52998224725',
    );
    await _tapSave(tester);

    expect(find.text('Cliente cadastrado com sucesso'), findsOneWidget);
    expect(find.text('Maria Silva'), findsOneWidget);
    expect(find.text('Pessoa Física'), findsOneWidget);
    expect(find.text('+55 (67) 98149-5959'), findsOneWidget);
    expect(find.text('CPF: 529.982.247-25'), findsOneWidget);
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

  testWidgets('Não exibe botão de consulta CNPJ em Pessoa Física', (
    WidgetTester tester,
  ) async {
    await _openNewClientForm(tester);

    expect(find.byKey(const Key('cnpj_lookup_button')), findsNothing);
  });

  testWidgets('Exibe botão de consulta CNPJ em PJ com 14 dígitos', (
    WidgetTester tester,
  ) async {
    await _openNewClientForm(tester);
    await _selectCompanyAndEnterCnpj(tester);

    expect(find.byKey(const Key('cnpj_lookup_button')), findsOneWidget);
    expect(find.text('Buscar dados da empresa'), findsOneWidget);
  });

  testWidgets('Preenche formulário após consulta CNPJ bem-sucedida', (
    WidgetTester tester,
  ) async {
    await _openNewClientForm(
      tester,
      overrides: [
        cnpjLookupServiceProvider.overrideWithValue(
          FakeCnpjLookupService(),
        ),
      ],
    );
    await _selectCompanyAndEnterCnpj(tester);

    await tester.tap(find.byKey(const Key('cnpj_lookup_button')));
    await tester.pumpAndSettle();

    expect(
      find.text('Dados da empresa carregados. Revise antes de salvar.'),
      findsOneWidget,
    );

    final nameField = find.descendant(
      of: find.byKey(const Key('client_name_field')),
      matching: find.byType(TextFormField),
    );
    expect(
      tester.widget<TextFormField>(nameField).controller?.text,
      'Empresa Ficticia LTDA',
    );

    final tradeNameField = find.descendant(
      of: find.byKey(const Key('client_trade_name_field')),
      matching: find.byType(TextFormField),
    );
    expect(
      tester.widget<TextFormField>(tradeNameField).controller?.text,
      'Marca Ficticia',
    );
  });

  testWidgets('Exibe erro quando consulta CNPJ retorna 404', (
    WidgetTester tester,
  ) async {
    await _openNewClientForm(
      tester,
      overrides: [
        cnpjLookupServiceProvider.overrideWithValue(
          FakeCnpjLookupService(
            exception: const CnpjLookupException(
              CnpjLookupFailure.notFound,
            ),
          ),
        ),
      ],
    );
    await _selectCompanyAndEnterCnpj(tester);

    await tester.tap(find.byKey(const Key('cnpj_lookup_button')));
    await tester.pumpAndSettle();

    expect(
      find.text('Empresa não encontrada para este CNPJ'),
      findsOneWidget,
    );
  });

  testWidgets('Mostra loading durante consulta CNPJ', (
    WidgetTester tester,
  ) async {
    await _openNewClientForm(
      tester,
      overrides: [
        cnpjLookupServiceProvider.overrideWithValue(
          FakeCnpjLookupService(
            delay: const Duration(milliseconds: 500),
          ),
        ),
      ],
    );
    await _selectCompanyAndEnterCnpj(tester);

    await tester.tap(find.byKey(const Key('cnpj_lookup_button')));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
  });

  testWidgets('Lista PJ com nome fantasia como título principal', (
    WidgetTester tester,
  ) async {
    await _openNewClientForm(
      tester,
      overrides: [
        cnpjLookupServiceProvider.overrideWithValue(
          FakeCnpjLookupService(),
        ),
      ],
    );
    await _selectCompanyAndEnterCnpj(tester);

    await tester.tap(find.byKey(const Key('cnpj_lookup_button')));
    await tester.pumpAndSettle();

    await _tapSave(tester);

    expect(find.text('Marca Ficticia'), findsOneWidget);
    expect(find.text('Empresa Ficticia LTDA'), findsOneWidget);
    expect(find.text('Pessoa Jurídica'), findsOneWidget);
  });

  testWidgets('Exibe campo Telefone, checkbox e WhatsApp com ícones', (
    WidgetTester tester,
  ) async {
    await _openNewClientForm(tester);

    expect(find.byKey(const Key('client_phone_field')), findsOneWidget);
    expect(find.byKey(const Key('client_also_whatsapp_checkbox')), findsOneWidget);
    expect(find.text('Este número também é WhatsApp'), findsOneWidget);
    expect(find.byKey(const Key('client_whatsapp_field')), findsOneWidget);
    expect(find.byIcon(Icons.phone), findsOneWidget);
    expect(find.byIcon(Icons.chat), findsOneWidget);
  });

  testWidgets('Checkbox copia celular válido para WhatsApp', (
    WidgetTester tester,
  ) async {
    await _openNewClientForm(tester);

    await tester.enterText(
      find.byKey(const Key('client_phone_field')),
      '67981495959',
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('client_also_whatsapp_checkbox')));
    await tester.pumpAndSettle();

    final whatsAppField = find.descendant(
      of: find.byKey(const Key('client_whatsapp_field')),
      matching: find.byType(TextFormField),
    );
    expect(
      tester.widget<TextFormField>(whatsAppField).controller?.text,
      '+55 (67) 98149-5959',
    );
  });

  testWidgets('Checkbox com telefone fixo não copia WhatsApp', (
    WidgetTester tester,
  ) async {
    await _openNewClientForm(tester);

    await tester.enterText(
      find.byKey(const Key('client_phone_field')),
      '6732321234',
    );
    await tester.enterText(
      find.byKey(const Key('client_whatsapp_field')),
      '67999998888',
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('client_also_whatsapp_checkbox')));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Telefone fixo não pode ser usado como WhatsApp'),
      findsOneWidget,
    );

    final whatsAppField = find.descendant(
      of: find.byKey(const Key('client_whatsapp_field')),
      matching: find.byType(TextFormField),
    );
    expect(
      tester.widget<TextFormField>(whatsAppField).controller?.text,
      contains('99999'),
    );
  });

  testWidgets('Desmarcar checkbox não apaga WhatsApp digitado', (
    WidgetTester tester,
  ) async {
    await _openNewClientForm(tester);

    await tester.enterText(
      find.byKey(const Key('client_phone_field')),
      '67981495959',
    );
    await tester.enterText(
      find.byKey(const Key('client_whatsapp_field')),
      '67999998888',
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('client_also_whatsapp_checkbox')));
    await tester.pumpAndSettle();

    final checkbox = tester.widget<CheckboxListTile>(
      find.byKey(const Key('client_also_whatsapp_checkbox')),
    );
    expect(checkbox.value, isTrue);

    await tester.tap(find.byKey(const Key('client_also_whatsapp_checkbox')));
    await tester.pumpAndSettle();

    final whatsAppField = find.descendant(
      of: find.byKey(const Key('client_whatsapp_field')),
      matching: find.byType(TextFormField),
    );
    expect(
      tester.widget<TextFormField>(whatsAppField).controller?.text,
      '+55 (67) 98149-5959',
    );
  });

  testWidgets('Exibe botão de busca de CEP com 8 dígitos', (
    WidgetTester tester,
  ) async {
    await _openNewClientForm(tester);

    expect(find.byKey(const Key('cep_lookup_button')), findsNothing);

    await tester.enterText(
      find.byKey(const Key('client_postal_code_field')),
      '79002050',
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('cep_lookup_button')), findsOneWidget);
    expect(find.text('Buscar endereço'), findsOneWidget);
  });

  testWidgets('Preenche endereço após busca de CEP bem-sucedida', (
    WidgetTester tester,
  ) async {
    await _openNewClientForm(
      tester,
      overrides: [
        cepLookupServiceProvider.overrideWithValue(
          FakeCepLookupService(),
        ),
      ],
    );

    await tester.enterText(
      find.byKey(const Key('client_postal_code_field')),
      '79002050',
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('cep_lookup_button')));
    await tester.pumpAndSettle();

    expect(
      find.text('Endereço carregado. Revise antes de salvar.'),
      findsOneWidget,
    );

    final streetField = find.descendant(
      of: find.byKey(const Key('client_street_field')),
      matching: find.byType(TextFormField),
    );
    expect(
      tester.widget<TextFormField>(streetField).controller?.text,
      'Rua Exemplo',
    );
  });

  testWidgets('Exibe erro de CEP sem bloquear cadastro manual', (
    WidgetTester tester,
  ) async {
    await _openNewClientForm(
      tester,
      overrides: [
        cepLookupServiceProvider.overrideWithValue(
          FakeCepLookupService(
            exception: const CepLookupException(CepLookupFailure.notFound),
          ),
        ),
      ],
    );

    await _fillRequiredFields(tester);

    await tester.enterText(
      find.byKey(const Key('client_postal_code_field')),
      '79002050',
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('cep_lookup_button')));
    await tester.pumpAndSettle();

    expect(find.text('CEP não encontrado'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.byKey(const Key('client_street_field')),
      800,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.enterText(
      find.byKey(const Key('client_street_field')),
      'Rua Manual',
    );
    await tester.pumpAndSettle();

    final streetField = find.descendant(
      of: find.byKey(const Key('client_street_field')),
      matching: find.byType(TextFormField),
    );
    expect(
      tester.widget<TextFormField>(streetField).controller?.text,
      'Rua Manual',
    );
    expect(find.text('Salvar'), findsOneWidget);
  });
}

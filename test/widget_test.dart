import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:eventpro/app/router/app_router.dart';
import 'package:eventpro/core/theme/app_colors.dart';
import 'package:eventpro/features/clients/data/exceptions/cep_lookup_exception.dart';
import 'package:eventpro/features/clients/data/exceptions/cnpj_lookup_exception.dart';
import 'package:eventpro/features/clients/providers/cep_lookup_provider.dart';
import 'package:eventpro/features/clients/providers/cnpj_lookup_provider.dart';
import 'package:eventpro/features/clients/utils/client_date_formatter.dart';
import 'package:eventpro/features/clients/client_list_feedback.dart';
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

  tester.view.physicalSize = const Size(800, 2000);
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

  Future<void> _tapCatalogSave(WidgetTester tester) async {
    final saveButton = find.byKey(const Key('catalog_save_button'));
    final formScrollable = find.ancestor(
      of: saveButton,
      matching: find.byType(Scrollable),
    );
    await tester.scrollUntilVisible(
      saveButton,
      800,
      scrollable: formScrollable,
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(saveButton);
    await tester.pumpAndSettle();
    await tester.tap(saveButton);
    await tester.pumpAndSettle();
  }

  Future<void> _tapSave(WidgetTester tester) async {
    final saveButton = find.byKey(const Key('client_save_button'));
    final formScrollable = find.ancestor(
      of: saveButton,
      matching: find.byType(Scrollable),
    );
    await tester.scrollUntilVisible(
      saveButton,
      800,
      scrollable: formScrollable,
    );
    await tester.pumpAndSettle();
    await tester.ensureVisible(saveButton);
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

Future<void> _createClientAndOpenDetail(WidgetTester tester) async {
  await _openNewClientForm(tester);
  await _fillRequiredFields(tester);
  await tester.enterText(
    find.byKey(const Key('client_document_field')),
    '52998224725',
  );
  await _tapSave(tester);

  await tester.tap(find.text('Maria Silva'));
  await tester.pumpAndSettle();
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

  testWidgets('Navega para Catálogo e volta ao Dashboard', (
    WidgetTester tester,
  ) async {
    await _pumpAppFromSplash(tester);

    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    expect(find.text('Bem-vindo ao EventPro'), findsOneWidget);

    await tester.tap(find.text('Catálogo'));
    await tester.pumpAndSettle();

    expect(find.text('Nenhum item no catálogo'), findsOneWidget);
    expect(find.text('Novo item'), findsOneWidget);
    expect(find.byKey(const Key('catalog_item_image_placeholder')), findsOneWidget);

    await tester.tap(find.byTooltip('Voltar'));
    await tester.pumpAndSettle();

    expect(find.text('Bem-vindo ao EventPro'), findsOneWidget);
    expect(find.text('Módulos'), findsOneWidget);
  });

  testWidgets('Navega para formulário Novo item do Catálogo', (
    WidgetTester tester,
  ) async {
    await _pumpAppFromSplash(tester);

    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Catálogo'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('catalog_new_item_button')));
    await tester.pumpAndSettle();

    expect(find.text('Novo item'), findsOneWidget);
    expect(find.byKey(const Key('catalog_name_field')), findsOneWidget);
    expect(find.byKey(const Key('catalog_price_field')), findsOneWidget);
    expect(find.text('Preço (R\$)'), findsOneWidget);
    expect(find.text('Salvar'), findsOneWidget);
  });

  testWidgets('Cadastra item no Catálogo e exibe na listagem', (
    WidgetTester tester,
  ) async {
    await _pumpAppFromSplash(tester);

    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Catálogo'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('catalog_new_item_button')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('catalog_name_field')),
      'Mesa de som',
    );
    await tester.enterText(
      find.byKey(const Key('catalog_price_field')),
      '1500',
    );

    await _tapCatalogSave(tester);

    expect(find.text('Catálogo'), findsOneWidget);
    expect(find.text('Mesa de som'), findsOneWidget);
    expect(find.text('R\$ 1.500,00 / Unidade'), findsOneWidget);
    expect(find.text('Item cadastrado com sucesso'), findsOneWidget);
    expect(find.byKey(const Key('catalog_items_grid')), findsOneWidget);
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
    expect(find.byKey(const Key('client_contact_error')), findsNothing);

    await tester.enterText(
      find.byKey(const Key('client_name_field')),
      'Maria Silva',
    );
    await _tapSave(tester);

    expect(
      find.text(
        'Informe pelo menos um contato: telefone, WhatsApp ou e-mail.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('Salva com somente telefone preenchido', (
    WidgetTester tester,
  ) async {
    await _openNewClientForm(tester);

    await tester.enterText(
      find.byKey(const Key('client_name_field')),
      'Maria Silva',
    );
    await tester.enterText(
      find.byKey(const Key('client_phone_field')),
      '6732321234',
    );
    await _tapSave(tester);

    expect(find.text('Clientes'), findsOneWidget);
    expect(find.text('Maria Silva'), findsOneWidget);
    expect(
      find.text(
        'Informe pelo menos um contato: telefone, WhatsApp ou e-mail.',
      ),
      findsNothing,
    );
  });

  testWidgets('Salva com somente e-mail preenchido', (
    WidgetTester tester,
  ) async {
    await _openNewClientForm(tester);

    await tester.enterText(
      find.byKey(const Key('client_name_field')),
      'Maria Silva',
    );
    await tester.enterText(
      find.byKey(const Key('client_email_field')),
      'maria@email.com',
    );
    await _tapSave(tester);

    expect(find.text('Clientes'), findsOneWidget);
    expect(find.text('Maria Silva'), findsOneWidget);
  });

  testWidgets('Remove mensagem de contato ao preencher um campo', (
    WidgetTester tester,
  ) async {
    await _openNewClientForm(tester);

    await tester.enterText(
      find.byKey(const Key('client_name_field')),
      'Maria Silva',
    );
    await _tapSave(tester);

    expect(find.byKey(const Key('client_contact_error')), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('client_email_field')),
      'maria@email.com',
    );
    await tester.pump();

    expect(find.byKey(const Key('client_contact_error')), findsNothing);
  });

  testWidgets('Prioriza erro específico de e-mail inválido', (
    WidgetTester tester,
  ) async {
    await _openNewClientForm(tester);

    await tester.enterText(
      find.byKey(const Key('client_name_field')),
      'Maria Silva',
    );
    await tester.enterText(
      find.byKey(const Key('client_email_field')),
      'email-invalido',
    );
    await _tapSave(tester);

    expect(find.text('E-mail inválido'), findsOneWidget);
    expect(find.byKey(const Key('client_contact_error')), findsNothing);
  });

  testWidgets('Oculta aniversário em Pessoa Jurídica', (
    WidgetTester tester,
  ) async {
    await _openNewClientForm(tester);

    expect(find.byKey(const Key('client_birthday_field')), findsOneWidget);

    await tester.tap(find.text('Pessoa Jurídica'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('client_birthday_field')), findsNothing);
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
    expect(find.byKey(const Key('cnpj_lookup_hint')), findsNothing);
    expect(
      find.descendant(
        of: find.byKey(const Key('client_document_field')),
        matching: find.byIcon(Icons.search),
      ),
      findsNothing,
    );

    await tester.tap(find.text('Pessoa Jurídica'));
    await tester.pumpAndSettle();

    expect(find.text('CNPJ'), findsOneWidget);
    expect(find.text('CPF'), findsNothing);
    expect(
      find.text('Digite o CNPJ para buscar os dados da empresa'),
      findsOneWidget,
    );
    expect(
      find.text('A busca automática será liberada após um CNPJ válido.'),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const Key('client_document_field')),
        matching: find.byIcon(Icons.search),
      ),
      findsOneWidget,
    );
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
    expect(find.byKey(const Key('cnpj_lookup_hint')), findsNothing);
    expect(
      find.descendant(
        of: find.byKey(const Key('client_document_field')),
        matching: find.byIcon(Icons.search),
      ),
      findsNothing,
    );
  });

  testWidgets('Exibe orientação de busca CNPJ em PJ antes de CNPJ válido', (
    WidgetTester tester,
  ) async {
    await _openNewClientForm(tester);

    await tester.tap(find.text('Pessoa Jurídica'));
    await tester.pumpAndSettle();

    expect(
      find.text('Digite o CNPJ para buscar os dados da empresa'),
      findsOneWidget,
    );
    expect(
      find.text('A busca automática será liberada após um CNPJ válido.'),
      findsOneWidget,
    );
    expect(find.byIcon(Icons.info_outline), findsOneWidget);
    expect(find.byKey(const Key('cnpj_lookup_button')), findsNothing);
    expect(
      find.descendant(
        of: find.byKey(const Key('client_document_field')),
        matching: find.byIcon(Icons.check_circle_outline),
      ),
      findsNothing,
    );
  });

  testWidgets('Mantém orientação inicial com CNPJ inválido de 14 dígitos', (
    WidgetTester tester,
  ) async {
    await _openNewClientForm(tester);

    await tester.tap(find.text('Pessoa Jurídica'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('client_document_field')),
      '12345678000199',
    );
    await tester.pumpAndSettle();

    expect(
      find.text('A busca automática será liberada após um CNPJ válido.'),
      findsOneWidget,
    );
    expect(find.byKey(const Key('cnpj_lookup_button')), findsNothing);
    expect(
      find.descendant(
        of: find.byKey(const Key('client_document_field')),
        matching: find.byIcon(Icons.check_circle_outline),
      ),
      findsNothing,
    );
  });

  testWidgets('Exibe botão de consulta CNPJ em PJ com 14 dígitos', (
    WidgetTester tester,
  ) async {
    await _openNewClientForm(tester);
    await _selectCompanyAndEnterCnpj(tester);

    expect(find.byKey(const Key('cnpj_lookup_button')), findsOneWidget);
    expect(find.text('Buscar dados da empresa'), findsOneWidget);
    expect(
      find.text('CNPJ válido. Você já pode buscar os dados da empresa.'),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const Key('client_document_field')),
        matching: find.byIcon(Icons.search),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const Key('client_document_field')),
        matching: find.byIcon(Icons.check_circle_outline),
      ),
      findsWidgets,
    );
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
    expect(find.byIcon(Icons.chat), findsNothing);
    expect(
      find.descendant(
        of: find.byKey(const Key('client_whatsapp_field')),
        matching: find.byWidgetPredicate(
          (widget) {
            if (widget is! FaIcon || widget.color != AppColors.whatsapp) {
              return false;
            }
            return widget.icon?.codePoint ==
                FontAwesomeIcons.whatsapp.codePoint;
          },
        ),
      ),
      findsOneWidget,
    );
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

  testWidgets('Abre detalhes ao tocar cliente na lista', (
    WidgetTester tester,
  ) async {
    await _createClientAndOpenDetail(tester);

    expect(find.text('Identificação'), findsOneWidget);
    expect(find.text('Contato'), findsOneWidget);
    expect(find.byKey(const Key('client_edit_button')), findsOneWidget);
    expect(find.byKey(const Key('client_delete_button')), findsOneWidget);
    expect(find.text('529.982.247-25'), findsOneWidget);
  });

  testWidgets('Exibe observações internas somente nos detalhes', (
    WidgetTester tester,
  ) async {
    await _openNewClientForm(tester);
    await _fillRequiredFields(tester);
    await tester.enterText(
      find.byKey(const Key('client_notes_field')),
      'Observação secreta da equipe',
    );
    await _tapSave(tester);

    await tester.tap(find.text('Maria Silva'));
    await tester.pumpAndSettle();

    expect(find.text('Observações internas'), findsOneWidget);
    expect(find.text('Observação secreta da equipe'), findsOneWidget);
  });

  testWidgets('Exibe feedback global após atualização', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_createTestApp());
    await tester.pumpAndSettle();

    ClientListFeedbackPresenter.showSnackBar(ClientListFeedback.updated);
    await tester.pump();

    expect(find.text('Cliente atualizado com sucesso'), findsOneWidget);
  });

  testWidgets('Edita cliente e retorna à lista com feedback', (
    WidgetTester tester,
  ) async {
    await _createClientAndOpenDetail(tester);

    await tester.tap(find.byKey(const Key('client_edit_button')));
    await tester.pumpAndSettle();

    expect(find.text('Editar cliente'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('client_name_field')),
      'Maria Atualizada',
    );
    await tester.enterText(
      find.byKey(const Key('client_whatsapp_field')),
      '67981495959',
    );
    await _tapSave(tester);

    expect(find.text('Clientes'), findsOneWidget);
    expect(find.text('Maria Atualizada'), findsOneWidget);
  });

  testWidgets('Exclui cliente após confirmação com nome', (
    WidgetTester tester,
  ) async {
    await _createClientAndOpenDetail(tester);

    await tester.tap(find.byKey(const Key('client_delete_button')));
    await tester.pumpAndSettle();

    expect(find.text('Excluir cliente'), findsOneWidget);
    expect(
      find.textContaining('Deseja excluir "Maria Silva"?'),
      findsOneWidget,
    );

    await tester.tap(find.text('Excluir'));
    await tester.pumpAndSettle();
    await tester.pump();
    await tester.pump();

    expect(find.text('Nenhum cliente cadastrado'), findsOneWidget);
    expect(find.text('Maria Silva'), findsNothing);
  });
}

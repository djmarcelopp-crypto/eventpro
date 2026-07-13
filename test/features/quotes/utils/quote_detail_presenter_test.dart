import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/models/quote_client_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_client_type.dart';
import 'package:eventpro/features/quotes/models/quote_company_capture_status.dart';
import 'package:eventpro/features/quotes/models/quote_company_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_pix_key_type.dart';
import 'package:eventpro/features/quotes/utils/quote_detail_presenter.dart';

import '../quotes_test_helpers.dart';

void main() {
  group('QuoteDetailPresenter.formatPrimaryContact', () {
    test('formata WhatsApp com 13 dígitos e DDI 55', () {
      const client = QuoteClientSnapshot(
        type: QuoteClientType.individual,
        displayName: 'Cliente',
        whatsApp: '5567981495959',
      );

      expect(
        QuoteDetailPresenter.formatPrimaryContact(client),
        '+55 (67) 98149-5959',
      );
      expect(client.whatsApp, '5567981495959');
    });

    test('formata celular nacional com 11 dígitos', () {
      const client = QuoteClientSnapshot(
        type: QuoteClientType.individual,
        displayName: 'Cliente',
        phone: '67981495959',
      );

      expect(
        QuoteDetailPresenter.formatPrimaryContact(client),
        '(67) 98149-5959',
      );
      expect(client.phone, '67981495959');
    });

    test('formata telefone fixo com 10 dígitos', () {
      const client = QuoteClientSnapshot(
        type: QuoteClientType.individual,
        displayName: 'Cliente',
        phone: '6732321234',
      );

      expect(
        QuoteDetailPresenter.formatPrimaryContact(client),
        '(67) 3232-1234',
      );
    });

    test('formata valor desconhecido sem erro', () {
      const client = QuoteClientSnapshot(
        type: QuoteClientType.individual,
        displayName: 'Cliente',
        phone: '12345',
      );

      expect(
        () => QuoteDetailPresenter.formatPrimaryContact(client),
        returnsNormally,
      );
      expect(
        QuoteDetailPresenter.formatPrimaryContact(client),
        '(12) 345',
      );
    });

    test('retorna e-mail sem máscara', () {
      const client = QuoteClientSnapshot(
        type: QuoteClientType.individual,
        displayName: 'Cliente',
        email: 'contato@example.com',
      );

      expect(
        QuoteDetailPresenter.formatPrimaryContact(client),
        'contato@example.com',
      );
    });

    test('prioriza WhatsApp sobre telefone e e-mail', () {
      const client = QuoteClientSnapshot(
        type: QuoteClientType.individual,
        displayName: 'Cliente',
        whatsApp: '5567981495959',
        phone: '6732321234',
        email: 'contato@example.com',
      );

      expect(
        QuoteDetailPresenter.formatPrimaryContact(client),
        '+55 (67) 98149-5959',
      );
    });
  });

  group('QuoteDetailPresenter — empresa emissora', () {
    test('formata CNPJ', () {
      expect(
        QuoteDetailPresenter.formatCompanyCnpj('11222333000181'),
        '11.222.333/0001-81',
      );
    });

    test('formata WhatsApp da empresa', () {
      const contact = QuoteCompanyContact(whatsAppDigits: '5567981495959');

      expect(
        QuoteDetailPresenter.formatCompanyPrimaryContact(contact),
        '+55 (67) 98149-5959',
      );
    });

    test('formata celular da empresa', () {
      const contact = QuoteCompanyContact(phoneDigits: '67981495959');

      expect(
        QuoteDetailPresenter.formatCompanyPrimaryContact(contact),
        '(67) 98149-5959',
      );
    });

    test('formata telefone fixo da empresa', () {
      const contact = QuoteCompanyContact(phoneDigits: '6732321234');

      expect(
        QuoteDetailPresenter.formatCompanyPrimaryContact(contact),
        '(67) 3232-1234',
      );
    });

    test('monta endereço sem separadores sobrando', () {
      const address = QuoteCompanyAddress(
        street: 'Rua Example',
        number: '100',
        city: 'Campo Grande',
        state: 'MS',
      );

      expect(
        QuoteDetailPresenter.formatCompanyAddress(address),
        'Rua Example, 100 • Campo Grande - MS',
      );
    });

    test('endereço vazio retorna null', () {
      expect(QuoteDetailPresenter.formatCompanyAddress(const QuoteCompanyAddress()), isNull);
    });

    test('seção completa oculta campos vazios', () {
      final snapshot = sampleCompanySnapshot();

      final items = QuoteDetailPresenter.companyIssuerItems(snapshot);
      final labels = items.map((item) => item.label).toList();

      expect(labels, contains('Nome comercial'));
      expect(labels, contains('CNPJ'));
      expect(labels, contains('Contato'));
      expect(labels, contains('Endereço'));
      expect(labels, contains('Status dos dados'));
      expect(labels, isNot(contains('PIX')));
      expect(
        items.any((item) => item.value.contains('pix@')),
        isFalse,
      );
    });

    test('snapshot incompleto exibe status correto', () {
      final snapshot = QuoteCompanySnapshot(
        identification: const QuoteCompanyIdentification(
          tradeName: 'DJ Marcelo PP',
        ),
        contact: const QuoteCompanyContact(phoneDigits: '67999990000'),
        address: const QuoteCompanyAddress(),
        captureStatus: QuoteCompanyCaptureStatus.incomplete,
        capturedAt: DateTime(2026, 7, 13),
      );

      final items = QuoteDetailPresenter.companyIssuerItems(snapshot);
      final statusItem = items.last;

      expect(statusItem.label, 'Status dos dados');
      expect(
        statusItem.value,
        'Dados incompletos no momento da criação',
      );
    });

    test('não expõe PIX nem representante legal', () {
      final snapshot = QuoteCompanySnapshot(
        identification: const QuoteCompanyIdentification(tradeName: 'DJ Marcelo PP'),
        contact: const QuoteCompanyContact(email: 'contato@djmarcelo.com'),
        address: const QuoteCompanyAddress(),
        legalRepresentative: const QuoteCompanyLegalRepresentative(
          fullName: 'Marcelo PP',
          cpfDigits: '52998224725',
        ),
        payment: const QuoteCompanyPayment(
          pixKeyType: QuotePixKeyType.email,
          pixKey: 'pix@empresa.com',
          beneficiaryName: 'Empresa LTDA',
        ),
        captureStatus: QuoteCompanyCaptureStatus.incomplete,
        capturedAt: DateTime(2026, 7, 13),
      );

      final items = QuoteDetailPresenter.companyIssuerItems(snapshot);
      final labels = items.map((item) => item.label).toList();
      final values = items.map((item) => item.value).join(' ');

      expect(labels, isNot(contains('PIX')));
      expect(labels, isNot(contains('Representante legal')));
      expect(values.contains('pix@'), isFalse);
      expect(values.contains('52998224725'), isFalse);
    });
  });
}

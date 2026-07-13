import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/models/quote_client_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_client_type.dart';
import 'package:eventpro/features/quotes/utils/quote_detail_presenter.dart';

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
}

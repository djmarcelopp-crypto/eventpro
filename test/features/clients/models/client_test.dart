import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/clients/client_type.dart';
import 'package:eventpro/features/clients/models/client.dart';
import 'package:eventpro/features/clients/models/client_address.dart';

void main() {
  group('ClientAddress', () {
    test('retorna null quando todos os campos estão vazios', () {
      expect(
        ClientAddress.fromForm(
          street: '',
          number: ' ',
          complement: null,
          neighborhood: '',
          city: '',
          state: '',
        ),
        isNull,
      );
    });

    test('mantém campos preenchidos com trim', () {
      final address = ClientAddress.fromForm(
        street: ' Rua A ',
        number: '123',
        complement: null,
        neighborhood: null,
        city: null,
        state: null,
      );

      expect(address?.street, 'Rua A');
      expect(address?.number, '123');
    });
  });

  group('Client', () {
    test('armazena whatsApp e document somente com dígitos', () {
      final client = Client.fromForm(
        type: ClientType.individual,
        name: '  Maria Silva  ',
        whatsApp: '+55 (67) 98149-5959',
        document: '123.456.789-01',
      );

      expect(client.name, 'Maria Silva');
      expect(client.whatsApp, '5567981495959');
      expect(client.document, '12345678901');
    });

    test('campos opcionais vazios ficam null', () {
      final client = Client.fromForm(
        type: ClientType.individual,
        name: 'Maria Silva',
        whatsApp: '67981495959',
        email: '  ',
        document: '',
        instagram: '',
        internalNotes: '',
      );

      expect(client.email, isNull);
      expect(client.document, isNull);
      expect(client.address, isNull);
      expect(client.instagram, isNull);
      expect(client.internalNotes, isNull);
    });

    test('gera id com microssegundos', () {
      final client = Client.fromForm(
        type: ClientType.individual,
        name: 'Maria Silva',
        whatsApp: '67981495959',
      );

      expect(int.tryParse(client.id), isNotNull);
    });
  });
}

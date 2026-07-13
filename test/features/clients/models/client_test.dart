import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/clients/client_type.dart';
import 'package:eventpro/features/clients/models/client.dart';
import 'package:eventpro/features/clients/models/client_address.dart';

void main() {
  group('ClientAddress', () {
    test('retorna null quando todos os campos estão vazios', () {
      expect(
        ClientAddress.fromForm(
          postalCode: '',
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
        postalCode: null,
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
    test('armazena whatsApp, phone e document somente com dígitos', () {
      final client = Client.fromForm(
        type: ClientType.individual,
        name: '  Maria Silva  ',
        phone: '(67) 3232-1234',
        whatsApp: '+55 (67) 98149-5959',
        document: '529.982.247-25',
      );

      expect(client.name, 'Maria Silva');
      expect(client.phone, '6732321234');
      expect(client.whatsApp, '5567981495959');
      expect(client.document, '52998224725');
    });

    test('campos opcionais vazios ficam null', () {
      final client = Client.fromForm(
        type: ClientType.company,
        name: 'Empresa Ficticia LTDA',
        tradeName: '  ',
        whatsApp: '67981495959',
        email: '  ',
        document: '',
        instagram: '',
        internalNotes: '',
      );

      expect(client.tradeName, isNull);
      expect(client.phone, isNull);
      expect(client.email, isNull);
      expect(client.document, isNull);
      expect(client.address, isNull);
      expect(client.instagram, isNull);
      expect(client.internalNotes, isNull);
    });

    test('mantém nome fantasia quando informado', () {
      final client = Client.fromForm(
        type: ClientType.company,
        name: 'Empresa Ficticia LTDA',
        tradeName: ' Marca Ficticia ',
        whatsApp: '5511987654321',
      );

      expect(client.tradeName, 'Marca Ficticia');
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

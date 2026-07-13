import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/clients/client_type.dart';
import 'package:eventpro/features/clients/models/client.dart';
import 'package:eventpro/features/clients/models/client_address.dart';
import 'package:eventpro/features/clients/utils/client_form_initializer.dart';

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
      expect(client.createdAt, isNotNull);
    });

    test('preserva id e createdAt na edição', () {
      final createdAt = DateTime(2024, 3, 10);
      final client = Client.fromForm(
        type: ClientType.individual,
        name: 'Maria Atualizada',
        whatsApp: '5567981495959',
        id: 'client-1',
        createdAt: createdAt,
      );

      expect(client.id, 'client-1');
      expect(client.createdAt, createdAt);
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

  group('ClientFormInitializer', () {
    test('preenche valores formatados a partir do cliente', () {
      final client = Client(
        id: '1',
        createdAt: DateTime(2024, 1, 1),
        type: ClientType.company,
        name: 'Empresa Ficticia LTDA',
        tradeName: 'Marca Ficticia',
        phone: '1133334444',
        whatsApp: '5511987654321',
        email: 'contato@test.com',
        document: '11222333000181',
        address: const ClientAddress(
          postalCode: '12345678',
          street: 'Rua das Flores',
          number: '100',
          neighborhood: 'Centro',
          city: 'Cidade Exemplo',
          state: 'SP',
        ),
        birthday: DateTime(1990, 5, 10),
        internalNotes: 'Nota interna',
      );

      final values = ClientFormInitializer.fromClient(client);

      expect(values.clientType, ClientType.company);
      expect(values.tradeName, 'Marca Ficticia');
      expect(values.phone, '(11) 3333-4444');
      expect(values.whatsApp, '+55 (11) 98765-4321');
      expect(values.postalCode, '12345-678');
      expect(values.internalNotes, 'Nota interna');
      expect(values.alsoWhatsApp, isFalse);
    });

    test('detecta telefone também usado como WhatsApp', () {
      final client = Client(
        id: '1',
        createdAt: DateTime(2024, 1, 1),
        type: ClientType.individual,
        name: 'Maria Silva',
        phone: '67981495959',
        whatsApp: '5567981495959',
      );

      expect(ClientFormInitializer.isPhoneAlsoWhatsApp(client), isTrue);
    });
  });
}

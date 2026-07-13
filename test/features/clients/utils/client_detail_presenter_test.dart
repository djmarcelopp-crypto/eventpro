import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/clients/models/client_address.dart';
import 'package:eventpro/features/clients/client_type.dart';
import 'package:eventpro/features/clients/models/client.dart';
import 'package:eventpro/features/clients/utils/client_detail_presenter.dart';

void main() {
  group('ClientDetailPresenter', () {
    final client = Client(
      id: '1',
      createdAt: DateTime(2024, 1, 1),
      type: ClientType.company,
      name: 'Empresa Ficticia LTDA',
      tradeName: 'Marca Ficticia',
      phone: '1133334444',
      whatsApp: '5511987654321',
      email: 'contato@test.com',
      address: const ClientAddress(
        street: 'Rua das Flores',
        city: 'Cidade Exemplo',
        state: 'SP',
      ),
      internalNotes: 'Nota interna',
    );

    test('usa nome fantasia como título quando disponível', () {
      expect(ClientDetailPresenter.displayTitle(client), 'Marca Ficticia');
    });

    test('exibe data de cadastro na identificação', () {
      final items = ClientDetailPresenter.identification(client);
      final registrationDate = items.firstWhere(
        (item) => item.label == 'Data de cadastro',
      );

      expect(registrationDate.value, '01/janeiro/2024');
    });

    test('omite WhatsApp nos contatos quando ausente', () {
      final clientWithoutWhatsApp = Client(
        id: '3',
        createdAt: DateTime(2024, 1, 1),
        type: ClientType.individual,
        name: 'Maria Silva',
        phone: '6732321234',
        email: 'maria@email.com',
      );

      final items = ClientDetailPresenter.contact(clientWithoutWhatsApp);

      expect(items.any((item) => item.label == 'WhatsApp'), isFalse);
      expect(items.any((item) => item.label == 'Telefone'), isTrue);
      expect(items.any((item) => item.label == 'E-mail'), isTrue);
    });

    test('omite seções e campos vazios', () {
      expect(ClientDetailPresenter.additional(client), isEmpty);

      final sparseClient = Client(
        id: '2',
        createdAt: DateTime(2024, 1, 1),
        type: ClientType.individual,
        name: 'Maria Silva',
        whatsApp: '5567981495959',
      );

      expect(ClientDetailPresenter.address(sparseClient), isEmpty);
      expect(ClientDetailPresenter.internalNotes(sparseClient), isNull);
      expect(
        ClientDetailPresenter.identification(sparseClient)
            .any((item) => item.label == 'Nome fantasia'),
        isFalse,
      );
    });

    test('exibe observações internas somente quando preenchidas', () {
      expect(ClientDetailPresenter.internalNotes(client), 'Nota interna');
    });

    test('não exibe aniversário para Pessoa Jurídica', () {
      final companyWithBirthday = Client(
        id: '4',
        createdAt: DateTime(2024, 1, 1),
        type: ClientType.company,
        name: 'Empresa Ficticia LTDA',
        phone: '1133334444',
        birthday: DateTime(1990, 5, 10),
      );

      expect(ClientDetailPresenter.additional(companyWithBirthday), isEmpty);
    });
  });
}

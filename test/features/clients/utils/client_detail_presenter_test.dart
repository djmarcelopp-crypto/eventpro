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
  });
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/clients/client_type.dart';
import 'package:eventpro/features/clients/models/client.dart';
import 'package:eventpro/features/clients/providers/clients_provider.dart';

Client _sampleClient({
  required String id,
  required String name,
  DateTime? createdAt,
}) {
  return Client(
    id: id,
    createdAt: createdAt ?? DateTime(2024, 6, 15),
    type: ClientType.individual,
    name: name,
    whatsApp: '5567981495959',
  );
}

void main() {
  group('ClientsNotifier', () {
    test('inicia com lista vazia', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(container.read(clientsProvider), isEmpty);
    });

    test('addClient adiciona cliente à lista', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container
          .read(clientsProvider.notifier)
          .addClient(_sampleClient(id: '1', name: 'Maria Silva'));

      expect(container.read(clientsProvider), hasLength(1));
      expect(container.read(clientsProvider).first.name, 'Maria Silva');
    });

    test('addClient preserva ordem de cadastro', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(clientsProvider.notifier);

      notifier.addClient(_sampleClient(id: '1', name: 'Maria Silva'));
      notifier.addClient(_sampleClient(id: '2', name: 'João Souza'));

      expect(
        container.read(clientsProvider).map((client) => client.name).toList(),
        ['Maria Silva', 'João Souza'],
      );
    });

    test('findById retorna cliente existente ou null', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(clientsProvider.notifier);

      notifier.addClient(_sampleClient(id: '1', name: 'Maria Silva'));

      expect(notifier.findById('1')?.name, 'Maria Silva');
      expect(notifier.findById('missing'), isNull);
    });

    test('updateClient preserva id e createdAt mesmo com dados inconsistentes', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(clientsProvider.notifier);
      final createdAt = DateTime(2024, 1, 10, 8, 30);

      notifier.addClient(
        _sampleClient(
          id: '1',
          name: 'Maria Silva',
          createdAt: createdAt,
        ),
      );

      notifier.updateClient(
        Client(
          id: '1',
          createdAt: DateTime(2025, 1, 1),
          type: ClientType.individual,
          name: 'Maria Atualizada',
          whatsApp: '5567981495959',
        ),
      );

      final updated = container.read(clientsProvider).first;
      expect(updated.id, '1');
      expect(updated.createdAt, createdAt);
      expect(updated.name, 'Maria Atualizada');
    });

    test('deleteClient remove cliente da lista', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final notifier = container.read(clientsProvider.notifier);

      notifier.addClient(_sampleClient(id: '1', name: 'Maria Silva'));
      notifier.addClient(_sampleClient(id: '2', name: 'João Souza'));

      notifier.deleteClient('1');

      expect(container.read(clientsProvider), hasLength(1));
      expect(container.read(clientsProvider).first.id, '2');
    });
  });
}

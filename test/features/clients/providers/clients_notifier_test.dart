import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/clients/client_type.dart';
import 'package:eventpro/features/clients/data/repositories/client_repository.dart';
import 'package:eventpro/features/clients/models/client.dart';
import 'package:eventpro/features/clients/providers/client_repository_provider.dart';
import 'package:eventpro/features/clients/providers/clients_provider.dart';

import '../fakes/fake_client_repository.dart';

Client _sampleClient({required String name, DateTime? createdAt}) {
  return Client(
    id: 'draft-id',
    createdAt: createdAt ?? DateTime(2024, 6, 15),
    type: ClientType.individual,
    name: name,
    whatsApp: '5567981495959',
  );
}

ProviderContainer _createContainer({ClientRepository? repository}) {
  final container = ProviderContainer(
    overrides: [
      clientRepositoryProvider.overrideWithValue(
        repository ?? FakeClientRepository(),
      ),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  group('ClientsNotifier', () {
    test('inicia com lista vazia', () {
      final container = _createContainer();

      expect(container.read(clientsProvider), isEmpty);
    });

    test('addClient adiciona cliente à lista', () async {
      final container = _createContainer();

      final saved = await container
          .read(clientsProvider.notifier)
          .addClient(_sampleClient(name: 'Maria Silva'));

      expect(saved, isTrue);
      expect(container.read(clientsProvider), hasLength(1));
      expect(container.read(clientsProvider).first.name, 'Maria Silva');
    });

    test('addClient preserva ordem de cadastro', () async {
      final container = _createContainer();
      final notifier = container.read(clientsProvider.notifier);

      await notifier.addClient(_sampleClient(name: 'Maria Silva'));
      await notifier.addClient(_sampleClient(name: 'João Souza'));

      expect(
        container.read(clientsProvider).map((client) => client.name).toList(),
        ['Maria Silva', 'João Souza'],
      );
    });

    test('findById retorna cliente existente ou null', () async {
      final container = _createContainer();
      final notifier = container.read(clientsProvider.notifier);

      await notifier.addClient(_sampleClient(name: 'Maria Silva'));
      final persistedId = container.read(clientsProvider).single.id;

      expect(notifier.findById(persistedId)?.name, 'Maria Silva');
      expect(notifier.findById('missing'), isNull);
    });

    test(
      'updateClient preserva id e createdAt mesmo com dados inconsistentes',
      () async {
        final container = _createContainer();
        final notifier = container.read(clientsProvider.notifier);
        final createdAt = DateTime(2024, 1, 10, 8, 30);

        await notifier.addClient(
          _sampleClient(name: 'Maria Silva', createdAt: createdAt),
        );
        final persistedId = container.read(clientsProvider).single.id;

        final saved = await notifier.updateClient(
          Client(
            id: persistedId,
            createdAt: DateTime(2025, 1, 1),
            type: ClientType.individual,
            name: 'Maria Atualizada',
            whatsApp: '5567981495959',
          ),
        );

        expect(saved, isTrue);
        final updated = container.read(clientsProvider).first;
        expect(updated.id, persistedId);
        expect(updated.createdAt, createdAt);
        expect(updated.name, 'Maria Atualizada');
      },
    );

    test('deleteClient remove cliente da lista', () async {
      final container = _createContainer();
      final notifier = container.read(clientsProvider.notifier);

      await notifier.addClient(_sampleClient(name: 'Maria Silva'));
      final firstId = container.read(clientsProvider).first.id;
      await notifier.addClient(_sampleClient(name: 'João Souza'));
      final secondId = container.read(clientsProvider).last.id;

      final deleted = await notifier.deleteClient(firstId);

      expect(deleted, isTrue);
      expect(container.read(clientsProvider), hasLength(1));
      expect(container.read(clientsProvider).first.id, secondId);
    });

    test('falha de insert não altera state', () async {
      final repository = FakeClientRepository()
        ..shouldFailOnNextOperation = true;
      final container = _createContainer(repository: repository);

      final saved = await container
          .read(clientsProvider.notifier)
          .addClient(_sampleClient(name: 'Maria Silva'));

      expect(saved, isFalse);
      expect(container.read(clientsProvider), isEmpty);
    });

    test('falha de update não altera state', () async {
      final repository = FakeClientRepository();
      final container = _createContainer(repository: repository);
      final notifier = container.read(clientsProvider.notifier);

      await notifier.addClient(_sampleClient(name: 'Maria Silva'));
      final persistedId = container.read(clientsProvider).single.id;
      repository.shouldFailOnNextOperation = true;

      final saved = await notifier.updateClient(
        Client(
          id: persistedId,
          createdAt: DateTime(2024, 1, 1),
          type: ClientType.individual,
          name: 'Maria Atualizada',
          whatsApp: '5567981495959',
        ),
      );

      expect(saved, isFalse);
      expect(container.read(clientsProvider).single.name, 'Maria Silva');
    });

    test('falha de delete não altera state', () async {
      final repository = FakeClientRepository();
      final container = _createContainer(repository: repository);
      final notifier = container.read(clientsProvider.notifier);

      await notifier.addClient(_sampleClient(name: 'Maria Silva'));
      final persistedId = container.read(clientsProvider).single.id;
      repository.shouldFailOnNextOperation = true;

      final deleted = await notifier.deleteClient(persistedId);

      expect(deleted, isFalse);
      expect(container.read(clientsProvider), hasLength(1));
    });
  });
}

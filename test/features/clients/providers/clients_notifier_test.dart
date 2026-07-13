import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/clients/client_type.dart';
import 'package:eventpro/features/clients/models/client.dart';
import 'package:eventpro/features/clients/providers/clients_provider.dart';

Client _sampleClient({required String id, required String name}) {
  return Client(
    id: id,
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
  });
}

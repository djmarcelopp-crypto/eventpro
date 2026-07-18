import 'package:eventpro/features/clients/data/repositories/client_repository.dart';
import 'package:eventpro/features/clients/models/client.dart';

class FakeClientRepository implements ClientRepository {
  FakeClientRepository({List<Client>? initialClients})
    : _clients = List<Client>.from(initialClients ?? const []);

  final List<Client> _clients;
  var shouldFailOnNextOperation = false;

  @override
  Future<List<Client>> listAll() async {
    _failIfRequested();
    return List<Client>.unmodifiable(_clients);
  }

  @override
  Future<Client?> findById(String id) async {
    _failIfRequested();
    for (final client in _clients) {
      if (client.id == id) {
        return client;
      }
    }
    return null;
  }

  @override
  Future<void> insert(Client client) async {
    _failIfRequested();
    _clients.add(client);
  }

  @override
  Future<void> update(Client client) async {
    _failIfRequested();
    final index = _clients.indexWhere((item) => item.id == client.id);
    if (index == -1) {
      throw StateError('Client not found for update: ${client.id}');
    }
    _clients[index] = client;
  }

  @override
  Future<void> delete(String id) async {
    _failIfRequested();
    final lengthBefore = _clients.length;
    _clients.removeWhere((client) => client.id == id);
    if (_clients.length == lengthBefore) {
      throw StateError('Client not found for delete: $id');
    }
  }

  void _failIfRequested() {
    if (!shouldFailOnNextOperation) {
      return;
    }
    shouldFailOnNextOperation = false;
    throw StateError('Simulated repository failure');
  }
}

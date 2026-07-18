import 'package:eventpro/features/clients/models/client.dart';

abstract class ClientRepository {
  Future<List<Client>> listAll();

  Future<Client?> findById(String id);

  Future<void> insert(Client client);

  Future<void> update(Client client);

  Future<void> delete(String id);
}

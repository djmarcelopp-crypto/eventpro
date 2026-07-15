import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../data/repositories/client_repository.dart';
import '../models/client.dart';
import 'client_repository_provider.dart';

class ClientsNotifier extends Notifier<List<Client>> {
  static const _uuid = Uuid();

  ClientRepository get _repository => ref.read(clientRepositoryProvider);

  @override
  List<Client> build() => [];

  Client? findById(String id) {
    for (final client in state) {
      if (client.id == id) {
        return client;
      }
    }
    return null;
  }

  Future<bool> addClient(Client client) async {
    final clientToSave = client.copyWith(id: _uuid.v7());

    try {
      await _repository.insert(clientToSave);
      state = [...state, clientToSave];
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> updateClient(Client client) async {
    final existing = findById(client.id);
    if (existing == null) {
      return false;
    }

    final updated = client.copyWith(
      id: existing.id,
      createdAt: existing.createdAt,
    );

    try {
      await _repository.update(updated);
      state = [
        for (final item in state)
          if (item.id == updated.id) updated else item,
      ];
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> deleteClient(String id) async {
    try {
      await _repository.delete(id);
      state = [
        for (final client in state)
          if (client.id != id) client,
      ];
      return true;
    } catch (_) {
      return false;
    }
  }
}

final clientsProvider = NotifierProvider<ClientsNotifier, List<Client>>(
  ClientsNotifier.new,
);

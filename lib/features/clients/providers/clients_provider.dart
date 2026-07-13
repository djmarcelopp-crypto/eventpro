import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/client.dart';

class ClientsNotifier extends Notifier<List<Client>> {
  @override
  List<Client> build() => [];

  void addClient(Client client) {
    state = [...state, client];
  }

  Client? findById(String id) {
    for (final client in state) {
      if (client.id == id) {
        return client;
      }
    }
    return null;
  }

  void updateClient(Client client) {
    final existing = findById(client.id);
    if (existing == null) {
      return;
    }

    final updated = client.copyWith(
      id: existing.id,
      createdAt: existing.createdAt,
    );

    state = [
      for (final item in state)
        if (item.id == updated.id) updated else item,
    ];
  }

  void deleteClient(String id) {
    state = [
      for (final client in state)
        if (client.id != id) client,
    ];
  }
}

final clientsProvider =
    NotifierProvider<ClientsNotifier, List<Client>>(ClientsNotifier.new);

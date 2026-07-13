import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/client.dart';

class ClientsNotifier extends Notifier<List<Client>> {
  @override
  List<Client> build() => [];

  void addClient(Client client) {
    state = [...state, client];
  }
}

final clientsProvider =
    NotifierProvider<ClientsNotifier, List<Client>>(ClientsNotifier.new);

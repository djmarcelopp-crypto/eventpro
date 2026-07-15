import 'package:eventpro/features/clients/data/repositories/client_repository.dart';
import 'package:eventpro/features/clients/providers/client_repository_provider.dart';
import 'package:flutter_riverpod/misc.dart';

import '../fakes/fake_client_repository.dart';

List<Override> clientRepositoryOverrides({ClientRepository? repository}) {
  return [
    clientRepositoryProvider.overrideWithValue(
      repository ?? FakeClientRepository(),
    ),
  ];
}

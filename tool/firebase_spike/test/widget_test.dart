import 'package:flutter_test/flutter_test.dart';

import 'package:firebase_spike/spike_config.dart';

void main() {
  test(
    'não é prova Firebase — valida apenas pré-condições locais do spike',
    () {
      expect(SpikeConfig.storageBlocked, isTrue);
      expect(SpikeConfig.firestoreOnly, isTrue);

      if (SpikeConfig.isFirebaseOptionsConfigured) {
        expect(SpikeConfig.canRunLive, isFalse);
      } else {
        expect(SpikeConfig.isFirebaseOptionsConfigured, isFalse);
      }

      if (SpikeConfig.canRunLive) {
        fail(
          'Teste automatizado não substitui execução nativa com SPIKE_RUN_LIVE.',
        );
      }
    },
  );
}

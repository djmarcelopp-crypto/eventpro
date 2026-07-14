import 'firebase_options.dart';

/// Detecta se o spike está pronto para execução ao vivo.
abstract class SpikeConfig {
  static const liveFlag = bool.fromEnvironment('SPIKE_RUN_LIVE');
  static const useAnonymous = bool.fromEnvironment('SPIKE_USE_ANONYMOUS');
  static const testEmail = String.fromEnvironment('SPIKE_TEST_EMAIL');
  static const testPassword = String.fromEnvironment('SPIKE_TEST_PASSWORD');

  /// Checkpoint 0: Auth + Firestore apenas. Storage exige Blaze.
  static const firestoreOnly = bool.fromEnvironment(
    'SPIKE_FIRESTORE_ONLY',
    defaultValue: true,
  );

  /// Cloud Storage bloqueado até autorização explícita de faturamento.
  static const storageBlocked = true;

  static bool get isFirebaseOptionsConfigured {
    try {
      final projectId = DefaultFirebaseOptions.currentPlatform.projectId;
      return projectId.isNotEmpty && projectId != 'REPLACE_ME';
    } on Object {
      return false;
    }
  }

  static bool get canRunLive => liveFlag && isFirebaseOptionsConfigured;

  static String get skipReason {
    if (!liveFlag) {
      return 'SPIKE_RUN_LIVE não definido.';
    }
    if (!isFirebaseOptionsConfigured) {
      return 'firebase_options.dart ausente ou com placeholders — '
          'execute flutterfire configure no projeto dev.';
    }
    return '';
  }
}

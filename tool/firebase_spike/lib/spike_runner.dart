import 'dart:convert';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'firebase_options.dart';
import 'spike_config.dart';

class SpikeStepResult {
  const SpikeStepResult({
    required this.name,
    required this.success,
    this.detail,
    this.durationMs,
  });

  final String name;
  final bool success;
  final String? detail;
  final int? durationMs;

  Map<String, Object?> toJson() => {
        'name': name,
        'success': success,
        if (detail != null) 'detail': detail,
        if (durationMs != null) 'durationMs': durationMs,
      };
}

class SpikeReport {
  SpikeReport({
    required this.platform,
    required this.startedAt,
    required this.finishedAt,
    required this.steps,
    required this.firestoreOnly,
  });

  final String platform;
  final DateTime startedAt;
  final DateTime finishedAt;
  final List<SpikeStepResult> steps;
  final bool firestoreOnly;

  bool get success => steps.every((step) => step.success);

  int get totalDurationMs =>
      finishedAt.difference(startedAt).inMilliseconds;

  Map<String, Object?> toJson() => {
        'platform': platform,
        'startedAt': startedAt.toIso8601String(),
        'finishedAt': finishedAt.toIso8601String(),
        'totalDurationMs': totalDurationMs,
        'firestoreOnly': firestoreOnly,
        'storageBlocked': SpikeConfig.storageBlocked,
        'success': success,
        'steps': steps.map((s) => s.toJson()).toList(),
      };

  String toJsonString() => const JsonEncoder.withIndent('  ').convert(toJson());
}

Future<SpikeReport> runFirebaseSpike({required String platformLabel}) async {
  final startedAt = DateTime.now().toUtc();
  final steps = <SpikeStepResult>[];

  Future<void> step(String name, Future<void> Function() action) async {
    final watch = Stopwatch()..start();
    try {
      await action();
      steps.add(SpikeStepResult(
        name: name,
        success: true,
        durationMs: watch.elapsedMilliseconds,
      ));
    } on Object catch (error) {
      steps.add(SpikeStepResult(
        name: name,
        success: false,
        detail: error.toString(),
        durationMs: watch.elapsedMilliseconds,
      ));
      rethrow;
    }
  }

  await step('firebase_initialize', () async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  });

  await step('auth_sign_in', () async {
    final auth = FirebaseAuth.instance;
    if (SpikeConfig.useAnonymous) {
      await auth.signInAnonymously();
      return;
    }
    if (SpikeConfig.testEmail.isEmpty || SpikeConfig.testPassword.isEmpty) {
      throw StateError(
        'Defina SPIKE_TEST_EMAIL e SPIKE_TEST_PASSWORD ou SPIKE_USE_ANONYMOUS=true.',
      );
    }
    await auth.signInWithEmailAndPassword(
      email: SpikeConfig.testEmail,
      password: SpikeConfig.testPassword,
    );
  });

  final runId = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) {
    throw StateError('Usuário não autenticado após sign-in.');
  }

  final docPath = 'spike_checkpoint0/$uid/runs/$runId';

  await step('firestore_create', () async {
    await FirebaseFirestore.instance.doc(docPath).set({
      'message': 'checkpoint0-create',
      'runId': runId,
      'platform': platformLabel,
      'recordedAt': FieldValue.serverTimestamp(),
    });
  });

  await step('firestore_read', () async {
    final snap = await FirebaseFirestore.instance.doc(docPath).get();
    if (!snap.exists) {
      throw StateError('Documento não encontrado após create.');
    }
  });

  await step('firestore_update', () async {
    await FirebaseFirestore.instance.doc(docPath).update({
      'message': 'checkpoint0-update',
      'updatedAt': FieldValue.serverTimestamp(),
    });
  });

  await step('firestore_delete', () async {
    await FirebaseFirestore.instance.doc(docPath).delete();
    final snap = await FirebaseFirestore.instance.doc(docPath).get();
    if (snap.exists) {
      throw StateError('Documento ainda existe após delete.');
    }
  });

  if (!SpikeConfig.firestoreOnly && !SpikeConfig.storageBlocked) {
    final payload = utf8.encode('eventpro-spike-$runId');
    final storagePath = 'spike_checkpoint0/$uid/$runId.txt';

    await step('storage_upload', () async {
      await FirebaseStorage.instance.ref(storagePath).putData(
            Uint8List.fromList(payload),
            SettableMetadata(contentType: 'text/plain'),
          );
    });

    await step('storage_download', () async {
      final data = await FirebaseStorage.instance.ref(storagePath).getData();
      if (data == null || !listEquals(data, payload)) {
        throw StateError('Download não corresponde ao upload.');
      }
    });

    await step('storage_delete', () async {
      await FirebaseStorage.instance.ref(storagePath).delete();
    });
  } else {
    steps.add(const SpikeStepResult(
      name: 'storage_skipped',
      success: true,
      detail: 'Storage bloqueado até autorização Blaze — Checkpoint 0.',
    ));
  }

  await step('auth_sign_out', () async {
    await FirebaseAuth.instance.signOut();
  });

  return SpikeReport(
    platform: platformLabel,
    startedAt: startedAt,
    finishedAt: DateTime.now().toUtc(),
    steps: steps,
    firestoreOnly: SpikeConfig.firestoreOnly || SpikeConfig.storageBlocked,
  );
}

bool listEquals<T>(List<T> a, List<T> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) return false;
  }
  return true;
}

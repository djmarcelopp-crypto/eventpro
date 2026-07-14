import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'spike_config.dart';
import 'spike_runner.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final platform = kIsWeb ? 'web' : Platform.operatingSystem;

  if (!SpikeConfig.canRunLive) {
    stdout.writeln('SPIKE CHECKPOINT 0 — modo documentação');
    stdout.writeln('Plataforma detectada: $platform');
    stdout.writeln('Motivo: ${SpikeConfig.skipReason}');
    stdout.writeln('');
    stdout.writeln('Consulte docs/tasks/TASK-023-firebase-dev-setup.md');
    exit(0);
  }

  stdout.writeln('SPIKE CHECKPOINT 0 — execução ao vivo (Auth + Firestore)');
  stdout.writeln('Plataforma: $platform');
  if (SpikeConfig.storageBlocked) {
    stdout.writeln('Storage: BLOQUEADO até autorização Blaze');
  }

  try {
    final report = await runFirebaseSpike(platformLabel: platform);
    final json = report.toJsonString();
    stdout.writeln(json);

    final fileName = '${platform}_live_${report.startedAt.millisecondsSinceEpoch}.json';
    final outputFile = _resolveReportFile(platform: platform, fileName: fileName);
    if (outputFile.parent.existsSync() == false) {
      outputFile.parent.createSync(recursive: true);
    }
    await outputFile.writeAsString('$json\n');
    stdout.writeln('Relatório salvo em: ${outputFile.absolute.path}');

    exit(report.success ? 0 : 1);
  } on Object catch (error, stack) {
    stderr.writeln('SPIKE falhou: $error');
    stderr.writeln(stack);
    exit(1);
  }
}

File _resolveReportFile({
  required String platform,
  required String fileName,
}) {
  if (platform == 'macos' || platform == 'windows') {
    return File('reports/$fileName');
  }
  if (platform == 'ios' || platform == 'android') {
    return File('${Directory.systemTemp.path}/$fileName');
  }
  return File('reports/$fileName');
}

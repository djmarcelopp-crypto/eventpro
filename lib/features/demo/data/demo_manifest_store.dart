import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../models/demo_seed_manifest.dart';

/// Persists demo IDs outside SQLite so production schema stays untouched.
class DemoManifestStore {
  DemoManifestStore({Future<Directory> Function()? documentsDirectory})
      : _documentsDirectory = documentsDirectory;

  final Future<Directory> Function()? _documentsDirectory;

  static const fileName = 'eventpro_demo_manifest.json';

  static bool get _isFlutterTest =>
      !kIsWeb && Platform.environment.containsKey('FLUTTER_TEST');

  Future<Directory> _resolveDocumentsDirectory() async {
    if (_documentsDirectory != null) {
      return _documentsDirectory();
    }
    // Avoid path_provider platform-channel hangs under flutter test.
    if (_isFlutterTest) {
      return Directory.systemTemp;
    }
    try {
      return await getApplicationDocumentsDirectory();
    } catch (_) {
      return Directory.systemTemp;
    }
  }

  Future<File> _file() async {
    final directory = await _resolveDocumentsDirectory();
    return File(p.join(directory.path, fileName));
  }

  Future<DemoSeedManifest?> read() async {
    try {
      final file = await _file();
      if (!await file.exists()) return null;
      final raw = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      return DemoSeedManifest.fromJson(raw);
    } catch (_) {
      return null;
    }
  }

  Future<void> write(DemoSeedManifest manifest) async {
    final file = await _file();
    await file.writeAsString(jsonEncode(manifest.toJson()));
  }

  Future<void> clearFile() async {
    try {
      final file = await _file();
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {
      // Best-effort cleanup.
    }
  }
}

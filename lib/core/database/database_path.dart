import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

const databaseRelativeDirectory = 'eventpro/db';
const databaseFileName = 'eventpro.sqlite';

Future<Directory> resolveDatabaseDirectory() async {
  final supportDir = await getApplicationSupportDirectory();
  final dbDir = Directory(p.join(supportDir.path, databaseRelativeDirectory));
  if (!await dbDir.exists()) {
    await dbDir.create(recursive: true);
  }
  return dbDir;
}

Future<File> resolveDatabaseFile() async {
  final dbDir = await resolveDatabaseDirectory();
  return File(p.join(dbDir.path, databaseFileName));
}

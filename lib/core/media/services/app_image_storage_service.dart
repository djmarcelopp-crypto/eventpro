import 'dart:typed_data';

abstract class AppImageStorageService {
  Future<String> stageFromPick({
    required Uint8List bytes,
    required String extension,
  });

  Future<String> commitStaged({
    required String stagedReference,
    required String ownerId,
  });

  Future<void> discardStaged(String? stagedReference);

  Future<void> deleteCommitted(String? imageReference);

  Future<Uint8List?> readBytes(String imageReference);

  Future<bool> exists(String imageReference);
}

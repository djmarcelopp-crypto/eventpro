import 'dart:typed_data';

abstract class AppImageCopyService {
  Future<String> copyCommitted({
    required String sourceReference,
    required Set<String> allowedSourcePrefixes,
    required String targetReferencePrefix,
    required String targetDirectoryName,
    required String ownerId,
    required DateTime timestamp,
  });

  Future<Uint8List?> readBytes(String imageReference);

  Future<bool> exists(String imageReference);
}

import 'dart:typed_data';

class CatalogImagePickResult {
  const CatalogImagePickResult({
    required this.bytes,
    required this.extension,
  });

  final Uint8List bytes;
  final String extension;
}

import 'dart:typed_data';

class AppImagePickResult {
  const AppImagePickResult({
    required this.bytes,
    required this.extension,
  });

  final Uint8List bytes;
  final String extension;
}

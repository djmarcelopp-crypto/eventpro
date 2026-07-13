class InvalidImageReferenceException implements Exception {
  const InvalidImageReferenceException();

  @override
  String toString() => 'Referência de imagem inválida';
}

class ImageCopyFailedException implements Exception {
  const ImageCopyFailedException();

  @override
  String toString() => 'Não foi possível copiar a imagem';
}

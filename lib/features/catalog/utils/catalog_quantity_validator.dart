abstract class CatalogQuantityValidator {
  static const _scaleFactor = 1000;
  static const _tolerance = 1e-9;

  static bool isValid(double quantity) {
    if (quantity <= 0) {
      return false;
    }

    final scaled = quantity * _scaleFactor;
    final nearest = scaled.roundToDouble();
    return (scaled - nearest).abs() < _tolerance;
  }
}

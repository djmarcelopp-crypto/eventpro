abstract class QuoteQuantityValidator {
  static const _maxDecimalPlaces = 3;
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

  static int decimalPlaces(double quantity) {
    for (var places = 0; places <= _maxDecimalPlaces; places++) {
      final factor = _pow10(places);
      final scaled = quantity * factor;
      final nearest = scaled.roundToDouble();
      if ((scaled - nearest).abs() < _tolerance) {
        return places;
      }
    }

    return _maxDecimalPlaces + 1;
  }

  static int _pow10(int exponent) {
    var result = 1;
    for (var i = 0; i < exponent; i++) {
      result *= 10;
    }
    return result;
  }
}

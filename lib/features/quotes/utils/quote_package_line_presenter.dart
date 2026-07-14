import '../models/quote_package_component_snapshot.dart';

abstract class QuotePackageLinePresenter {
  static bool isPackageDraft(List<QuotePackageComponentSnapshot>? components) {
    return components != null;
  }

  static int componentCount(List<QuotePackageComponentSnapshot>? components) {
    return components?.length ?? 0;
  }

  static String includedItemsSummary(
    List<QuotePackageComponentSnapshot>? components,
  ) {
    final count = componentCount(components);
    if (count == 1) {
      return '1 item incluído';
    }
    return '$count itens incluídos';
  }

  static String formatEffectiveQuantity(double quantity) {
    if (quantity == quantity.roundToDouble()) {
      return quantity.toInt().toString();
    }

    for (var places = 1; places <= 3; places++) {
      final factor = _pow10(places);
      final scaled = quantity * factor;
      final nearest = scaled.roundToDouble();
      if ((scaled - nearest).abs() < 1e-9) {
        final text = quantity.toStringAsFixed(places);
        return text.replaceAll('.', ',');
      }
    }

    return quantity.toString().replaceAll('.', ',');
  }

  static int _pow10(int exponent) {
    var result = 1;
    for (var i = 0; i < exponent; i++) {
      result *= 10;
    }
    return result;
  }
}

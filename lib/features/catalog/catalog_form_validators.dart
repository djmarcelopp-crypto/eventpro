import 'catalog_billing_unit.dart';
import 'utils/catalog_price_formatter.dart';

abstract class CatalogFormValidators {
  static String? validateName(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Informe o nome do item';
    }
    if (trimmed.length < 2) {
      return 'Nome deve ter pelo menos 2 caracteres';
    }
    return null;
  }

  static String? validateCustomUnit({
    required CatalogBillingUnit unit,
    String? value,
  }) {
    if (!unit.isOther) {
      return null;
    }

    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Informe a unidade personalizada';
    }
    if (trimmed.length < 2) {
      return 'Unidade deve ter pelo menos 2 caracteres';
    }
    return null;
  }

  static String? validatePrice(String? value) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return 'Informe o preço';
    }

    final parsed = CatalogPriceFormatter.parse(trimmed);
    if (parsed == null) {
      return 'Preço inválido';
    }
    if (parsed <= 0) {
      return 'Informe um preço maior que zero';
    }

    return null;
  }
}

enum CatalogBillingUnit {
  unit,
  daily,
  hour,
  meter,
  squareMeter,
  event,
  service,
  other,
}

extension CatalogBillingUnitLabel on CatalogBillingUnit {
  String get label => switch (this) {
        CatalogBillingUnit.unit => 'Unidade',
        CatalogBillingUnit.daily => 'Diária',
        CatalogBillingUnit.hour => 'Hora',
        CatalogBillingUnit.meter => 'Metro',
        CatalogBillingUnit.squareMeter => 'Metro quadrado',
        CatalogBillingUnit.event => 'Evento',
        CatalogBillingUnit.service => 'Serviço',
        CatalogBillingUnit.other => 'Outro',
      };

  bool get isOther => this == CatalogBillingUnit.other;
}

class CatalogBillingUnitValues {
  const CatalogBillingUnitValues({
    required this.unit,
    this.customUnit,
  });

  final CatalogBillingUnit unit;
  final String? customUnit;
}

abstract class CatalogBillingUnitResolver {
  static String resolve({
    required CatalogBillingUnit unit,
    String? customUnit,
  }) {
    if (unit.isOther) {
      return customUnit!.trim();
    }
    return unit.label;
  }

  static CatalogBillingUnitValues fromStoredUnit(String storedUnit) {
    final trimmed = storedUnit.trim();
    for (final unit in CatalogBillingUnit.values) {
      if (!unit.isOther && unit.label == trimmed) {
        return CatalogBillingUnitValues(unit: unit);
      }
    }

    return CatalogBillingUnitValues(
      unit: CatalogBillingUnit.other,
      customUnit: trimmed,
    );
  }
}

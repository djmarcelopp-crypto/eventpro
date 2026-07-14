import '../../catalog/models/catalog_package_component.dart';
import '../models/quote_package_component_snapshot.dart';

abstract class QuotePackageComponentMapper {
  static QuotePackageComponentSnapshot fromCatalogComponent(
    CatalogPackageComponent component,
  ) {
    return QuotePackageComponentSnapshot(
      catalogItemId: component.catalogItemId,
      name: component.nameSnapshot,
      unit: component.unitSnapshot,
      typeLabel: component.typeSnapshot,
      categoryLabel: component.categorySnapshot,
      quantityPerPackage: component.quantityPerPackage,
    );
  }

  static List<QuotePackageComponentSnapshot> fromCatalogComponents(
    List<CatalogPackageComponent> components,
  ) {
    return List.unmodifiable(
      components.map(fromCatalogComponent),
    );
  }
}

import '../../../core/utils/registration_date_formatter.dart';
import '../catalog_category.dart';
import '../catalog_item_type.dart';
import '../models/catalog_item.dart';
import 'catalog_price_formatter.dart';

class CatalogDetailItem {
  const CatalogDetailItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}

abstract class CatalogDetailPresenter {
  static String displayTitle(CatalogItem item) => item.name;

  static String statusLabel(CatalogItem item) => item.active ? 'Ativo' : 'Inativo';

  static String formattedPrice(CatalogItem item) {
    return CatalogPriceFormatter.format(item.price);
  }

  static String formattedCreatedAt(CatalogItem item) {
    return RegistrationDateFormatter.format(item.createdAt);
  }

  static List<CatalogDetailItem> detailItems(CatalogItem item) {
    final items = <CatalogDetailItem>[
      CatalogDetailItem(label: 'Tipo', value: item.type.label),
      CatalogDetailItem(label: 'Categoria', value: item.category.label),
    ];

    final description = item.description?.trim();
    if (description != null && description.isNotEmpty) {
      items.add(CatalogDetailItem(label: 'Descrição', value: description));
    }

    items.addAll([
      CatalogDetailItem(label: 'Unidade', value: item.unit),
      CatalogDetailItem(label: 'Preço', value: formattedPrice(item)),
      CatalogDetailItem(label: 'Status', value: statusLabel(item)),
      CatalogDetailItem(
        label: 'Data de cadastro',
        value: formattedCreatedAt(item),
      ),
    ]);

    return items;
  }
}

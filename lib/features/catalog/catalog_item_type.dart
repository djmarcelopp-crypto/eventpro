enum CatalogItemType {
  equipment,
  service,
}

extension CatalogItemTypeLabel on CatalogItemType {
  String get label => switch (this) {
        CatalogItemType.equipment => 'Equipamento',
        CatalogItemType.service => 'Serviço',
      };
}

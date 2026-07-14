enum CatalogItemType {
  equipment,
  service,
  package,
}

extension CatalogItemTypeLabel on CatalogItemType {
  String get label => switch (this) {
        CatalogItemType.equipment => 'Equipamento',
        CatalogItemType.service => 'Serviço',
        CatalogItemType.package => 'Pacote',
      };

  bool get isPackage => this == CatalogItemType.package;

  bool get canBePackageComponent =>
      this == CatalogItemType.equipment || this == CatalogItemType.service;
}

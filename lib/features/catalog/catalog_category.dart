enum CatalogCategory {
  sound,
  lighting,
  ledPanel,
  structure,
  dj,
  team,
  transport,
  other,
}

extension CatalogCategoryLabel on CatalogCategory {
  String get label => switch (this) {
        CatalogCategory.sound => 'Som',
        CatalogCategory.lighting => 'Iluminação',
        CatalogCategory.ledPanel => 'Painel de LED',
        CatalogCategory.structure => 'Estrutura',
        CatalogCategory.dj => 'DJ',
        CatalogCategory.team => 'Equipe',
        CatalogCategory.transport => 'Transporte',
        CatalogCategory.other => 'Outros',
      };
}

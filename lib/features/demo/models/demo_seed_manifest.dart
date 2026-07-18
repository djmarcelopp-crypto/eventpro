/// Tracks IDs created by [DemoSeeder] so demo data can be cleared safely.
class DemoSeedManifest {
  const DemoSeedManifest({
    this.clientIds = const [],
    this.quoteIds = const [],
    this.contractIds = const [],
    this.invoiceIds = const [],
    this.teamRoleIds = const [],
    this.teamMemberIds = const [],
    this.equipmentCategoryIds = const [],
    this.equipmentIds = const [],
    this.vehicleTypeIds = const [],
    this.vehicleIds = const [],
    this.financialCategoryIds = const [],
    this.financialEntryIds = const [],
    this.agendaBlockIds = const [],
    this.seededAt,
  });

  final List<String> clientIds;
  final List<String> quoteIds;
  final List<String> contractIds;
  final List<String> invoiceIds;
  final List<String> teamRoleIds;
  final List<String> teamMemberIds;
  final List<String> equipmentCategoryIds;
  final List<String> equipmentIds;
  final List<String> vehicleTypeIds;
  final List<String> vehicleIds;
  final List<String> financialCategoryIds;
  final List<String> financialEntryIds;
  final List<String> agendaBlockIds;
  final DateTime? seededAt;

  bool get isEmpty =>
      clientIds.isEmpty &&
      quoteIds.isEmpty &&
      contractIds.isEmpty &&
      invoiceIds.isEmpty &&
      teamMemberIds.isEmpty &&
      equipmentIds.isEmpty &&
      vehicleIds.isEmpty &&
      financialEntryIds.isEmpty &&
      agendaBlockIds.isEmpty;

  Map<String, dynamic> toJson() => {
        'clientIds': clientIds,
        'quoteIds': quoteIds,
        'contractIds': contractIds,
        'invoiceIds': invoiceIds,
        'teamRoleIds': teamRoleIds,
        'teamMemberIds': teamMemberIds,
        'equipmentCategoryIds': equipmentCategoryIds,
        'equipmentIds': equipmentIds,
        'vehicleTypeIds': vehicleTypeIds,
        'vehicleIds': vehicleIds,
        'financialCategoryIds': financialCategoryIds,
        'financialEntryIds': financialEntryIds,
        'agendaBlockIds': agendaBlockIds,
        'seededAt': seededAt?.toIso8601String(),
      };

  /// Tolerates missing/partial keys and non-string entries.
  ///
  /// Empty or blank IDs are dropped so clear never issues unfiltered deletes.
  factory DemoSeedManifest.fromJson(Map<String, dynamic> json) {
    List<String> read(String key) {
      final raw = json[key];
      if (raw is! List) return const [];
      return raw
          .map((entry) => entry?.toString().trim() ?? '')
          .where((id) => id.isNotEmpty)
          .toList(growable: false);
    }

    DateTime? seededAt;
    final rawSeededAt = json['seededAt'];
    if (rawSeededAt is String) {
      seededAt = DateTime.tryParse(rawSeededAt);
    }

    return DemoSeedManifest(
      clientIds: read('clientIds'),
      quoteIds: read('quoteIds'),
      contractIds: read('contractIds'),
      invoiceIds: read('invoiceIds'),
      teamRoleIds: read('teamRoleIds'),
      teamMemberIds: read('teamMemberIds'),
      equipmentCategoryIds: read('equipmentCategoryIds'),
      equipmentIds: read('equipmentIds'),
      vehicleTypeIds: read('vehicleTypeIds'),
      vehicleIds: read('vehicleIds'),
      financialCategoryIds: read('financialCategoryIds'),
      financialEntryIds: read('financialEntryIds'),
      agendaBlockIds: read('agendaBlockIds'),
      seededAt: seededAt,
    );
  }
}

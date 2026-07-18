// Cópia congelada do schema real da TASK-028 CP-D (schemaVersion 6),
// exatamente como definido em lib/core/database/tables.dart antes da
// TASK-029 CP-B (antes de `team_roles` / `team_members` existirem).
//
// Usada exclusivamente para gerar um banco SQLite v6 genuíno em
// test/core/database/team_migration_test.dart, permitindo testar a
// migração real 6 -> 7 (TASK-029 CP-B) contra um schema legado de fato.
//
// NUNCA deve ser alterada para acompanhar tables.dart — é uma fotografia
// histórica intencionalmente congelada.
import 'package:drift/drift.dart';

@DataClassName('LegacyClientRow')
@TableIndex(name: 'idx_clients_created_at', columns: {#createdAt})
class LegacyClients extends Table {
  @override
  String get tableName => 'clients';

  TextColumn get id => text()();
  IntColumn get createdAt => integer()();
  TextColumn get type => text()();
  TextColumn get name => text()();
  TextColumn get tradeName => text().nullable()();
  TextColumn get phoneDigits => text().nullable()();
  TextColumn get whatsappDigits => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get documentDigits => text().nullable()();
  TextColumn get instagram => text().nullable()();
  TextColumn get birthday => text().nullable()();
  TextColumn get internalNotes => text().nullable()();
  TextColumn get postalCode => text().nullable()();
  TextColumn get street => text().nullable()();
  TextColumn get number => text().nullable()();
  TextColumn get complement => text().nullable()();
  TextColumn get neighborhood => text().nullable()();
  TextColumn get city => text().nullable()();
  TextColumn get state => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('LegacyCatalogItemRow')
@TableIndex(name: 'idx_catalog_items_active', columns: {#active})
@TableIndex(name: 'idx_catalog_items_type', columns: {#type})
class LegacyCatalogItems extends Table {
  @override
  String get tableName => 'catalog_items';

  TextColumn get id => text()();
  IntColumn get createdAt => integer()();
  TextColumn get type => text()();
  TextColumn get name => text()();
  TextColumn get category => text()();
  TextColumn get description => text().nullable()();
  TextColumn get unit => text()();
  IntColumn get priceCents => integer()();
  BoolColumn get active => boolean()();
  TextColumn get imageReference => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('LegacyCatalogPackageComponentRow')
@TableIndex(name: 'idx_pkg_components_component', columns: {#componentItemId})
class LegacyCatalogPackageComponents extends Table {
  @override
  String get tableName => 'catalog_package_components';

  @ReferenceName('package_components')
  TextColumn get packageId =>
      text().references(LegacyCatalogItems, #id, onDelete: KeyAction.cascade)();
  @ReferenceName('component_usages')
  TextColumn get componentItemId =>
      text().references(LegacyCatalogItems, #id, onDelete: KeyAction.restrict)();
  TextColumn get nameSnapshot => text()();
  TextColumn get unitSnapshot => text()();
  TextColumn get typeSnapshot => text()();
  TextColumn get categorySnapshot => text()();
  RealColumn get quantityPerPackage => real()();

  @override
  Set<Column<Object>> get primaryKey => {packageId, componentItemId};
}

@DataClassName('LegacyCompanyProfileRow')
class LegacyCompanyProfiles extends Table {
  @override
  String get tableName => 'company_profile';

  TextColumn get id => text()();
  TextColumn get tradeName => text()();
  TextColumn get legalName => text().nullable()();
  TextColumn get cnpjDigits => text().nullable()();
  TextColumn get stateRegistration => text().nullable()();
  TextColumn get logoReference => text().nullable()();
  TextColumn get phoneDigits => text().nullable()();
  TextColumn get whatsappDigits => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get instagram => text().nullable()();
  TextColumn get website => text().nullable()();
  TextColumn get postalCode => text().nullable()();
  TextColumn get street => text().nullable()();
  TextColumn get number => text().nullable()();
  TextColumn get complement => text().nullable()();
  TextColumn get neighborhood => text().nullable()();
  TextColumn get city => text().nullable()();
  TextColumn get state => text().nullable()();
  TextColumn get repFullName => text().nullable()();
  TextColumn get repCpfDigits => text().nullable()();
  TextColumn get repRole => text().nullable()();
  TextColumn get pixKeyType => text().nullable()();
  TextColumn get pixKey => text().nullable()();
  TextColumn get beneficiaryName => text().nullable()();
  TextColumn get paymentTerms => text().nullable()();
  IntColumn get defaultValidityDays => integer()();
  TextColumn get defaultPublicNotes => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('LegacyQuoteRow')
@TableIndex(name: 'idx_quotes_number', columns: {#number}, unique: true)
@TableIndex(name: 'idx_quotes_status', columns: {#status})
@TableIndex(name: 'idx_quotes_created_at', columns: {#createdAt})
@TableIndex(name: 'idx_quotes_updated_at', columns: {#updatedAt})
class LegacyQuotes extends Table {
  @override
  String get tableName => 'quotes';

  TextColumn get id => text()();
  TextColumn get number => text()();
  TextColumn get status => text()();
  IntColumn get subtotalCents => integer()();
  IntColumn get discountCents => integer()();
  IntColumn get freightCents => integer()();
  IntColumn get totalCents => integer()();
  TextColumn get validUntil => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get internalNotes => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn get approvedAt => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('LegacyQuoteClientSnapshotRow')
class LegacyQuoteClientSnapshots extends Table {
  @override
  String get tableName => 'quote_client_snapshots';

  TextColumn get quoteId =>
      text().references(LegacyQuotes, #id, onDelete: KeyAction.cascade)();
  TextColumn get sourceClientId => text().nullable()();
  TextColumn get type => text()();
  TextColumn get displayName => text()();
  TextColumn get legalName => text().nullable()();
  TextColumn get documentDigits => text().nullable()();
  TextColumn get phoneDigits => text().nullable()();
  TextColumn get whatsappDigits => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get addressSummary => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {quoteId};
}

@DataClassName('LegacyQuoteEventSnapshotRow')
class LegacyQuoteEventSnapshots extends Table {
  @override
  String get tableName => 'quote_event_snapshots';

  TextColumn get quoteId =>
      text().references(LegacyQuotes, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text().nullable()();
  TextColumn get type => text().nullable()();
  TextColumn get eventDate => text().nullable()();
  TextColumn get startTime => text().nullable()();
  TextColumn get endTime => text().nullable()();
  TextColumn get venueName => text().nullable()();
  TextColumn get addressSummary => text().nullable()();
  IntColumn get guestCount => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {quoteId};
}

@DataClassName('LegacyQuoteCompanySnapshotRow')
class LegacyQuoteCompanySnapshots extends Table {
  @override
  String get tableName => 'quote_company_snapshots';

  TextColumn get quoteId =>
      text().references(LegacyQuotes, #id, onDelete: KeyAction.cascade)();
  TextColumn get captureStatus => text()();
  IntColumn get capturedAt => integer()();
  TextColumn get logoReference => text().nullable()();
  TextColumn get identTradeName => text()();
  TextColumn get identLegalName => text().nullable()();
  TextColumn get identCnpjDigits => text().nullable()();
  TextColumn get identStateRegistration => text().nullable()();
  TextColumn get contactPhoneDigits => text().nullable()();
  TextColumn get contactWhatsappDigits => text().nullable()();
  TextColumn get contactEmail => text().nullable()();
  TextColumn get contactInstagram => text().nullable()();
  TextColumn get contactWebsite => text().nullable()();
  TextColumn get addrPostalCode => text().nullable()();
  TextColumn get addrStreet => text().nullable()();
  TextColumn get addrNumber => text().nullable()();
  TextColumn get addrComplement => text().nullable()();
  TextColumn get addrNeighborhood => text().nullable()();
  TextColumn get addrCity => text().nullable()();
  TextColumn get addrState => text().nullable()();
  TextColumn get repFullName => text().nullable()();
  TextColumn get repCpfDigits => text().nullable()();
  TextColumn get repRole => text().nullable()();
  TextColumn get payPixKeyType => text().nullable()();
  TextColumn get payPixKey => text().nullable()();
  TextColumn get payBeneficiaryName => text().nullable()();
  TextColumn get payPaymentTerms => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {quoteId};
}

@DataClassName('LegacyQuoteLineItemRow')
@TableIndex(
  name: 'idx_quote_lines_quote_order',
  columns: {#quoteId, #sortOrder},
)
class LegacyQuoteLineItems extends Table {
  @override
  String get tableName => 'quote_line_items';

  TextColumn get id => text()();
  TextColumn get quoteId =>
      text().references(LegacyQuotes, #id, onDelete: KeyAction.cascade)();
  IntColumn get sortOrder => integer()();
  TextColumn get catalogItemId => text().nullable()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  TextColumn get unit => text()();
  RealColumn get quantity => real()();
  IntColumn get unitPriceCents => integer()();
  IntColumn get lineTotalCents => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('LegacyQuoteLinePackageComponentRow')
@TableIndex(name: 'idx_quote_pkg_line', columns: {#lineItemId, #sortOrder})
class LegacyQuoteLinePackageComponents extends Table {
  @override
  String get tableName => 'quote_line_package_components';

  TextColumn get id => text()();
  TextColumn get lineItemId =>
      text().references(LegacyQuoteLineItems, #id, onDelete: KeyAction.cascade)();
  IntColumn get sortOrder => integer()();
  TextColumn get catalogItemId => text().nullable()();
  TextColumn get name => text()();
  TextColumn get unit => text()();
  TextColumn get typeLabel => text()();
  TextColumn get categoryLabel => text()();
  RealColumn get quantityPerPackage => real()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('LegacyQuoteStatusHistoryRow')
@TableIndex(
  name: 'idx_quote_history_quote_order',
  columns: {#quoteId, #sortOrder},
)
class LegacyQuoteStatusHistory extends Table {
  @override
  String get tableName => 'quote_status_history';

  TextColumn get id => text()();
  TextColumn get quoteId =>
      text().references(LegacyQuotes, #id, onDelete: KeyAction.cascade)();
  IntColumn get sortOrder => integer()();
  TextColumn get previousStatus => text().nullable()();
  TextColumn get newStatus => text()();
  IntColumn get changedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('LegacyQuoteNumberSequenceRow')
class LegacyQuoteNumberSequences extends Table {
  @override
  String get tableName => 'quote_number_sequences';

  IntColumn get year => integer()();
  IntColumn get lastSequence => integer()();

  @override
  Set<Column<Object>> get primaryKey => {year};
}

@DataClassName('LegacyAgendaBlockRow')
@TableIndex(name: 'idx_agenda_blocks_start', columns: {#start})
@TableIndex(name: 'idx_agenda_blocks_end', columns: {#end})
class LegacyAgendaBlocks extends Table {
  @override
  String get tableName => 'agenda_blocks';

  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get notes => text().nullable()();
  IntColumn get start => integer()();
  IntColumn get end => integer()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('LegacyFinancialCategoryRow')
@TableIndex(name: 'idx_financial_categories_kind', columns: {#kind})
class LegacyFinancialCategories extends Table {
  @override
  String get tableName => 'financial_categories';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get kind => text()();
  BoolColumn get active => boolean()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('LegacyFinancialEntryRow')
@TableIndex(name: 'idx_financial_entries_date', columns: {#date})
@TableIndex(name: 'idx_financial_entries_kind', columns: {#kind})
@TableIndex(name: 'idx_financial_entries_quote_id', columns: {#quoteId})
class LegacyFinancialEntries extends Table {
  @override
  String get tableName => 'financial_entries';

  TextColumn get id => text()();
  TextColumn get kind => text()();
  TextColumn get description => text()();
  IntColumn get amountCents => integer()();

  /// Civil date (competência), stored as an ISO `YYYY-MM-DD` string via
  /// `CivilDateConverter` — this field has no time-of-day meaning.
  TextColumn get date => text()();
  TextColumn get categoryId => text()
      .references(LegacyFinancialCategories, #id, onDelete: KeyAction.restrict)();
  TextColumn get status => text()();
  IntColumn get paidAt => integer().nullable()();
  TextColumn get notes => text().nullable()();

  /// Optional link to the event/quote this entry belongs to (TASK-027
  /// CP-D). Nullable — most entries (general company overhead, etc.) have
  /// no associated event. Uses `LegacyQuotes.id` as the single source of truth
  /// for events; no event data is duplicated here.
  TextColumn get quoteId =>
      text().nullable().references(LegacyQuotes, #id, onDelete: KeyAction.setNull)();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Inventory categories for [LegacyEquipments] (TASK-028 CP-B).
@DataClassName('LegacyEquipmentCategoryRow')
@TableIndex(name: 'idx_equipment_categories_name', columns: {#name})
class LegacyEquipmentCategories extends Table {
  @override
  String get tableName => 'equipment_categories';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  BoolColumn get active => boolean()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Inventory equipment / stock items (TASK-028 CP-B).
@DataClassName('LegacyEquipmentRow')
@TableIndex(name: 'idx_equipment_category_id', columns: {#categoryId})
@TableIndex(name: 'idx_equipment_status', columns: {#status})
class LegacyEquipments extends Table {
  @override
  String get tableName => 'equipment';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get categoryId => text().references(
        LegacyEquipmentCategories,
        #id,
        onDelete: KeyAction.restrict,
      )();
  TextColumn get serialNumber => text().nullable()();
  IntColumn get totalQuantity => integer()();

  /// Serialized [EquipmentStatus] name (`available`, `reserved`, …).
  TextColumn get status => text()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Planned equipment quantities attached to a quote (TASK-028 CP-D).
@DataClassName('LegacyQuoteEquipmentRow')
@TableIndex(name: 'idx_quote_equipment_quote_id', columns: {#quoteId})
@TableIndex(name: 'idx_quote_equipment_equipment_id', columns: {#equipmentId})
class LegacyQuoteEquipmentItems extends Table {
  @override
  String get tableName => 'quote_equipment';

  TextColumn get id => text()();
  TextColumn get quoteId =>
      text().references(LegacyQuotes, #id, onDelete: KeyAction.cascade)();
  TextColumn get equipmentId =>
      text().references(LegacyEquipments, #id, onDelete: KeyAction.restrict)();
  IntColumn get quantity => integer()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

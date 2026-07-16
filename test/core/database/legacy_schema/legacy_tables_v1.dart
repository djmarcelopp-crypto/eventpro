// Cópia congelada do schema real da TASK-024 (schemaVersion 1), exatamente
// como definido em lib/core/database/tables.dart antes da TASK-025 CP-A.
//
// Usada exclusivamente para gerar um banco SQLite v1 genuíno em
// test/core/database/agenda_migration_test.dart, permitindo testar a
// migração real 1 -> 2 contra um schema legado de fato (não simulado).
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
  TextColumn get componentItemId => text()
      .references(LegacyCatalogItems, #id, onDelete: KeyAction.restrict)();
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
  TextColumn get lineItemId => text()
      .references(LegacyQuoteLineItems, #id, onDelete: KeyAction.cascade)();
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

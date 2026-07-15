import 'package:drift/drift.dart';

@DataClassName('ClientRow')
@TableIndex(name: 'idx_clients_created_at', columns: {#createdAt})
class Clients extends Table {
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

@DataClassName('CatalogItemRow')
@TableIndex(name: 'idx_catalog_items_active', columns: {#active})
@TableIndex(name: 'idx_catalog_items_type', columns: {#type})
class CatalogItems extends Table {
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

@DataClassName('CatalogPackageComponentRow')
@TableIndex(name: 'idx_pkg_components_component', columns: {#componentItemId})
class CatalogPackageComponents extends Table {
  @ReferenceName('package_components')
  TextColumn get packageId =>
      text().references(CatalogItems, #id, onDelete: KeyAction.cascade)();
  @ReferenceName('component_usages')
  TextColumn get componentItemId =>
      text().references(CatalogItems, #id, onDelete: KeyAction.restrict)();
  TextColumn get nameSnapshot => text()();
  TextColumn get unitSnapshot => text()();
  TextColumn get typeSnapshot => text()();
  TextColumn get categorySnapshot => text()();
  RealColumn get quantityPerPackage => real()();

  @override
  Set<Column<Object>> get primaryKey => {packageId, componentItemId};
}

@DataClassName('CompanyProfileRow')
class CompanyProfiles extends Table {
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

@DataClassName('QuoteRow')
@TableIndex(name: 'idx_quotes_number', columns: {#number}, unique: true)
@TableIndex(name: 'idx_quotes_status', columns: {#status})
@TableIndex(name: 'idx_quotes_created_at', columns: {#createdAt})
@TableIndex(name: 'idx_quotes_updated_at', columns: {#updatedAt})
class Quotes extends Table {
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

@DataClassName('QuoteClientSnapshotRow')
class QuoteClientSnapshots extends Table {
  TextColumn get quoteId =>
      text().references(Quotes, #id, onDelete: KeyAction.cascade)();
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

@DataClassName('QuoteEventSnapshotRow')
class QuoteEventSnapshots extends Table {
  TextColumn get quoteId =>
      text().references(Quotes, #id, onDelete: KeyAction.cascade)();
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

@DataClassName('QuoteCompanySnapshotRow')
class QuoteCompanySnapshots extends Table {
  TextColumn get quoteId =>
      text().references(Quotes, #id, onDelete: KeyAction.cascade)();
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

@DataClassName('QuoteLineItemRow')
@TableIndex(
  name: 'idx_quote_lines_quote_order',
  columns: {#quoteId, #sortOrder},
)
class QuoteLineItems extends Table {
  TextColumn get id => text()();
  TextColumn get quoteId =>
      text().references(Quotes, #id, onDelete: KeyAction.cascade)();
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

@DataClassName('QuoteLinePackageComponentRow')
@TableIndex(name: 'idx_quote_pkg_line', columns: {#lineItemId, #sortOrder})
class QuoteLinePackageComponents extends Table {
  TextColumn get id => text()();
  TextColumn get lineItemId =>
      text().references(QuoteLineItems, #id, onDelete: KeyAction.cascade)();
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

@DataClassName('QuoteStatusHistoryRow')
@TableIndex(
  name: 'idx_quote_history_quote_order',
  columns: {#quoteId, #sortOrder},
)
class QuoteStatusHistory extends Table {
  TextColumn get id => text()();
  TextColumn get quoteId =>
      text().references(Quotes, #id, onDelete: KeyAction.cascade)();
  IntColumn get sortOrder => integer()();
  TextColumn get previousStatus => text().nullable()();
  TextColumn get newStatus => text()();
  IntColumn get changedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('QuoteNumberSequenceRow')
class QuoteNumberSequences extends Table {
  IntColumn get year => integer()();
  IntColumn get lastSequence => integer()();

  @override
  Set<Column<Object>> get primaryKey => {year};
}

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

@DataClassName('AgendaBlockRow')
@TableIndex(name: 'idx_agenda_blocks_start', columns: {#start})
@TableIndex(name: 'idx_agenda_blocks_end', columns: {#end})
class AgendaBlocks extends Table {
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

@DataClassName('FinancialCategoryRow')
@TableIndex(name: 'idx_financial_categories_kind', columns: {#kind})
class FinancialCategories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get kind => text()();
  BoolColumn get active => boolean()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('FinancialEntryRow')
@TableIndex(name: 'idx_financial_entries_date', columns: {#date})
@TableIndex(name: 'idx_financial_entries_kind', columns: {#kind})
@TableIndex(name: 'idx_financial_entries_quote_id', columns: {#quoteId})
class FinancialEntries extends Table {
  TextColumn get id => text()();
  TextColumn get kind => text()();
  TextColumn get description => text()();
  IntColumn get amountCents => integer()();

  /// Civil date (competência), stored as an ISO `YYYY-MM-DD` string via
  /// `CivilDateConverter` — this field has no time-of-day meaning.
  TextColumn get date => text()();
  TextColumn get categoryId => text()
      .references(FinancialCategories, #id, onDelete: KeyAction.restrict)();
  TextColumn get status => text()();
  IntColumn get paidAt => integer().nullable()();
  TextColumn get notes => text().nullable()();

  /// Optional link to the event/quote this entry belongs to (TASK-027
  /// CP-D). Nullable — most entries (general company overhead, etc.) have
  /// no associated event. Uses `Quotes.id` as the single source of truth
  /// for events; no event data is duplicated here.
  TextColumn get quoteId =>
      text().nullable().references(Quotes, #id, onDelete: KeyAction.setNull)();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Inventory categories for [Equipments] (TASK-028 CP-B).
@DataClassName('EquipmentCategoryRow')
@TableIndex(name: 'idx_equipment_categories_name', columns: {#name})
class EquipmentCategories extends Table {
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
@DataClassName('EquipmentRow')
@TableIndex(name: 'idx_equipment_category_id', columns: {#categoryId})
@TableIndex(name: 'idx_equipment_status', columns: {#status})
class Equipments extends Table {
  @override
  String get tableName => 'equipment';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get categoryId => text().references(
        EquipmentCategories,
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
///
/// Does not reserve stock or mutate equipment status — reference only.
@DataClassName('QuoteEquipmentRow')
@TableIndex(name: 'idx_quote_equipment_quote_id', columns: {#quoteId})
@TableIndex(name: 'idx_quote_equipment_equipment_id', columns: {#equipmentId})
class QuoteEquipmentItems extends Table {
  @override
  String get tableName => 'quote_equipment';

  TextColumn get id => text()();
  TextColumn get quoteId =>
      text().references(Quotes, #id, onDelete: KeyAction.cascade)();
  TextColumn get equipmentId =>
      text().references(Equipments, #id, onDelete: KeyAction.restrict)();
  IntColumn get quantity => integer()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Roles for team members (TASK-029 CP-B).
@DataClassName('TeamRoleRow')
@TableIndex(name: 'idx_team_roles_name', columns: {#name})
class TeamRoles extends Table {
  @override
  String get tableName => 'team_roles';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  BoolColumn get active => boolean()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Roster members (TASK-029 CP-B).
@DataClassName('TeamMemberRow')
@TableIndex(name: 'idx_team_members_role_id', columns: {#roleId})
@TableIndex(name: 'idx_team_members_status', columns: {#status})
class TeamMembers extends Table {
  @override
  String get tableName => 'team_members';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get phone => text()();
  TextColumn get email => text().nullable()();
  TextColumn get roleId => text().references(
        TeamRoles,
        #id,
        onDelete: KeyAction.restrict,
        onUpdate: KeyAction.cascade,
      )();
  TextColumn get observations => text().nullable()();
  IntColumn get dailyRate => integer()();

  /// Serialized [TeamMemberStatus] name (`active`, `unavailable`, `inactive`).
  TextColumn get status => text()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Planned team roster lines attached to a quote (TASK-029 CP-D).
///
/// Snapshots [roleId] and [dailyRate] at association time. Does not create
/// schedules, check-ins, or payroll entries.
@DataClassName('QuoteTeamMemberRow')
@TableIndex(name: 'idx_quote_team_members_quote_id', columns: {#quoteId})
@TableIndex(
  name: 'idx_quote_team_members_team_member_id',
  columns: {#teamMemberId},
)
@TableIndex(name: 'idx_quote_team_members_role_id', columns: {#roleId})
class QuoteTeamMembers extends Table {
  @override
  String get tableName => 'quote_team_members';

  TextColumn get id => text()();
  TextColumn get quoteId =>
      text().references(Quotes, #id, onDelete: KeyAction.cascade)();
  TextColumn get teamMemberId =>
      text().references(TeamMembers, #id, onDelete: KeyAction.restrict)();
  TextColumn get roleId =>
      text().references(TeamRoles, #id, onDelete: KeyAction.restrict)();
  IntColumn get dailyRate => integer()();
  TextColumn get notes => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Vehicle types for the logistics fleet (TASK-030 CP-B).
@DataClassName('VehicleTypeRow')
@TableIndex(name: 'idx_vehicle_types_name', columns: {#name})
class VehicleTypes extends Table {
  @override
  String get tableName => 'vehicle_types';

  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  BoolColumn get active => boolean()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Fleet vehicles (TASK-030 CP-B).
@DataClassName('VehicleRow')
@TableIndex(name: 'idx_vehicles_type_id', columns: {#vehicleTypeId})
@TableIndex(name: 'idx_vehicles_status', columns: {#status})
@TableIndex(name: 'idx_vehicles_plate', columns: {#plate})
class Vehicles extends Table {
  @override
  String get tableName => 'vehicles';

  TextColumn get id => text()();
  TextColumn get plate => text()();
  TextColumn get description => text()();
  TextColumn get vehicleTypeId => text().references(
        VehicleTypes,
        #id,
        onDelete: KeyAction.restrict,
        onUpdate: KeyAction.cascade,
      )();
  RealColumn get payloadCapacityKg => real()();
  RealColumn get volumeCapacityM3 => real()();
  TextColumn get observations => text().nullable()();

  /// Serialized [VehicleStatus] name.
  TextColumn get status => text()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Planned vehicle assignments attached to a quote (TASK-030 CP-D).
@DataClassName('QuoteVehicleRow')
@TableIndex(name: 'idx_quote_vehicles_quote_id', columns: {#quoteId})
@TableIndex(name: 'idx_quote_vehicles_vehicle_id', columns: {#vehicleId})
@TableIndex(
  name: 'idx_quote_vehicles_driver_id',
  columns: {#driverTeamMemberId},
)
class QuoteVehicles extends Table {
  @override
  String get tableName => 'quote_vehicles';

  TextColumn get id => text()();
  TextColumn get quoteId =>
      text().references(Quotes, #id, onDelete: KeyAction.cascade)();
  TextColumn get vehicleId =>
      text().references(Vehicles, #id, onDelete: KeyAction.restrict)();
  TextColumn get driverTeamMemberId => text().nullable().references(
        TeamMembers,
        #id,
        onDelete: KeyAction.restrict,
      )();
  IntColumn get plannedDepartureAt => integer().nullable()();
  IntColumn get plannedReturnAt => integer().nullable()();
  IntColumn get freightCostCents => integer()();
  TextColumn get notes => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

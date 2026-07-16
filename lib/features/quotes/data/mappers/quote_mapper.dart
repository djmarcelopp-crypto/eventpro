import 'package:drift/drift.dart';
import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/core/database/converters/civil_date_converter.dart';
import 'package:eventpro/core/database/converters/timestamp_converter.dart';
import 'package:eventpro/features/quotes/models/quote.dart';
import 'package:eventpro/features/quotes/models/quote_client_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_client_type.dart';
import 'package:eventpro/features/quotes/models/quote_company_capture_status.dart';
import 'package:eventpro/features/quotes/models/quote_company_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_event_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_line_item.dart';
import 'package:eventpro/features/quotes/models/quote_package_component_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_pix_key_type.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/models/quote_status_history_entry.dart';
import 'package:uuid/uuid.dart';

abstract class QuoteMapper {
  static const Uuid _uuid = Uuid();

  static Quote toDomain({
    required QuoteRow quote,
    required QuoteClientSnapshotRow clientSnapshot,
    required QuoteEventSnapshotRow eventSnapshot,
    required QuoteCompanySnapshotRow? companySnapshot,
    required List<QuoteLineItemRow> lineItems,
    required Map<String, List<QuoteLinePackageComponentRow>>
    packageComponentsByLineItemId,
    required List<QuoteStatusHistoryRow> statusHistory,
  }) {
    return Quote(
      id: quote.id,
      number: quote.number,
      status: _parseStatus(quote.status),
      clientSnapshot: _clientSnapshotToDomain(clientSnapshot),
      eventSnapshot: _eventSnapshotToDomain(eventSnapshot),
      items: lineItems
          .map(
            (row) => _lineItemToDomain(
              row,
              packageComponentsByLineItemId[row.id] ?? const [],
            ),
          )
          .toList(),
      subtotalCents: quote.subtotalCents,
      discountCents: quote.discountCents,
      freightCents: quote.freightCents,
      totalCents: quote.totalCents,
      statusHistory: statusHistory.map(_statusHistoryToDomain).toList(),
      validUntil: CivilDateConverter.fromIsoDate(quote.validUntil),
      notes: quote.notes,
      internalNotes: quote.internalNotes,
      companySnapshot: companySnapshot == null
          ? null
          : _companySnapshotToDomain(companySnapshot),
      createdAt: TimestampConverter.fromUtcMillis(quote.createdAt),
      updatedAt: TimestampConverter.fromUtcMillis(quote.updatedAt),
      approvedAt: quote.approvedAt == null
          ? null
          : TimestampConverter.fromUtcMillis(quote.approvedAt!),
    );
  }

  static QuotesCompanion toQuoteCompanion(Quote quote) {
    return QuotesCompanion.insert(
      id: quote.id,
      number: quote.number,
      status: quote.status.name,
      subtotalCents: quote.subtotalCents,
      discountCents: quote.discountCents,
      freightCents: quote.freightCents,
      totalCents: quote.totalCents,
      validUntil: Value(CivilDateConverter.toIsoDate(quote.validUntil)),
      notes: Value(quote.notes),
      internalNotes: Value(quote.internalNotes),
      createdAt: TimestampConverter.toUtcMillis(quote.createdAt),
      updatedAt: TimestampConverter.toUtcMillis(quote.updatedAt),
      approvedAt: Value(
        quote.approvedAt == null
            ? null
            : TimestampConverter.toUtcMillis(quote.approvedAt!),
      ),
    );
  }

  static QuoteClientSnapshotsCompanion toClientSnapshotCompanion(
    Quote quote,
  ) {
    final snapshot = quote.clientSnapshot;
    return QuoteClientSnapshotsCompanion.insert(
      quoteId: quote.id,
      sourceClientId: Value(snapshot.sourceClientId),
      type: snapshot.type.name,
      displayName: snapshot.displayName,
      legalName: Value(snapshot.legalName),
      documentDigits: Value(snapshot.document),
      phoneDigits: Value(snapshot.phone),
      whatsappDigits: Value(snapshot.whatsApp),
      email: Value(snapshot.email),
      addressSummary: Value(snapshot.addressSummary),
    );
  }

  static QuoteEventSnapshotsCompanion toEventSnapshotCompanion(Quote quote) {
    final snapshot = quote.eventSnapshot;
    return QuoteEventSnapshotsCompanion.insert(
      quoteId: quote.id,
      name: Value(snapshot.name),
      type: Value(snapshot.type),
      eventDate: Value(CivilDateConverter.toIsoDate(snapshot.date)),
      startTime: Value(snapshot.startTime),
      endTime: Value(snapshot.endTime),
      venueName: Value(snapshot.venueName),
      addressSummary: Value(snapshot.addressSummary),
      guestCount: Value(snapshot.guestCount),
    );
  }

  static QuoteCompanySnapshotsCompanion? toCompanySnapshotCompanion(
    Quote quote,
  ) {
    final snapshot = quote.companySnapshot;
    if (snapshot == null) {
      return null;
    }

    return QuoteCompanySnapshotsCompanion.insert(
      quoteId: quote.id,
      captureStatus: snapshot.captureStatus.name,
      capturedAt: TimestampConverter.toUtcMillis(snapshot.capturedAt),
      logoReference: Value(snapshot.logoReference),
      identTradeName: snapshot.identification.tradeName,
      identLegalName: Value(snapshot.identification.legalName),
      identCnpjDigits: Value(snapshot.identification.cnpjDigits),
      identStateRegistration: Value(
        snapshot.identification.stateRegistration,
      ),
      contactPhoneDigits: Value(snapshot.contact.phoneDigits),
      contactWhatsappDigits: Value(snapshot.contact.whatsAppDigits),
      contactEmail: Value(snapshot.contact.email),
      contactInstagram: Value(snapshot.contact.instagram),
      contactWebsite: Value(snapshot.contact.website),
      addrPostalCode: Value(snapshot.address.postalCode),
      addrStreet: Value(snapshot.address.street),
      addrNumber: Value(snapshot.address.number),
      addrComplement: Value(snapshot.address.complement),
      addrNeighborhood: Value(snapshot.address.neighborhood),
      addrCity: Value(snapshot.address.city),
      addrState: Value(snapshot.address.state),
      repFullName: Value(snapshot.legalRepresentative?.fullName),
      repCpfDigits: Value(snapshot.legalRepresentative?.cpfDigits),
      repRole: Value(snapshot.legalRepresentative?.role),
      payPixKeyType: Value(snapshot.payment?.pixKeyType?.name),
      payPixKey: Value(snapshot.payment?.pixKey),
      payBeneficiaryName: Value(snapshot.payment?.beneficiaryName),
      payPaymentTerms: Value(snapshot.payment?.paymentTerms),
    );
  }

  /// Generates one ephemeral id per line item. The same list must be reused
  /// for [toLineItemCompanions] and [toPackageComponentCompanions] so that
  /// package components link to the correct persisted line item.
  static List<String> generateLineItemIds(int count) {
    return List.generate(count, (_) => _uuid.v7(), growable: false);
  }

  static List<QuoteLineItemsCompanion> toLineItemCompanions(
    Quote quote,
    List<String> lineItemIds,
  ) {
    final items = quote.items;
    return [
      for (var i = 0; i < items.length; i++)
        QuoteLineItemsCompanion.insert(
          id: lineItemIds[i],
          quoteId: quote.id,
          sortOrder: i,
          catalogItemId: Value(items[i].catalogItemId),
          name: items[i].name,
          description: Value(items[i].description),
          unit: items[i].unit,
          quantity: items[i].quantity,
          unitPriceCents: items[i].unitPriceCents,
          lineTotalCents: items[i].lineTotalCents,
        ),
    ];
  }

  static List<QuoteLinePackageComponentsCompanion> toPackageComponentCompanions(
    Quote quote,
    List<String> lineItemIds,
  ) {
    final companions = <QuoteLinePackageComponentsCompanion>[];
    final items = quote.items;
    for (var i = 0; i < items.length; i++) {
      final components = items[i].packageComponents;
      if (components == null) {
        continue;
      }
      for (var j = 0; j < components.length; j++) {
        companions.add(
          QuoteLinePackageComponentsCompanion.insert(
            id: _uuid.v7(),
            lineItemId: lineItemIds[i],
            sortOrder: j,
            catalogItemId: Value(components[j].catalogItemId),
            name: components[j].name,
            unit: components[j].unit,
            typeLabel: components[j].typeLabel,
            categoryLabel: components[j].categoryLabel,
            quantityPerPackage: components[j].quantityPerPackage,
          ),
        );
      }
    }
    return companions;
  }

  static List<QuoteStatusHistoryCompanion> toStatusHistoryCompanions(
    Quote quote,
  ) {
    final entries = quote.statusHistory;
    return [
      for (var i = 0; i < entries.length; i++)
        QuoteStatusHistoryCompanion.insert(
          id: _uuid.v7(),
          quoteId: quote.id,
          sortOrder: i,
          previousStatus: Value(entries[i].previousStatus?.name),
          newStatus: entries[i].newStatus.name,
          changedAt: TimestampConverter.toUtcMillis(entries[i].changedAt),
        ),
    ];
  }

  static QuoteLineItem _lineItemToDomain(
    QuoteLineItemRow row,
    List<QuoteLinePackageComponentRow> componentRows,
  ) {
    return QuoteLineItem(
      catalogItemId: row.catalogItemId,
      name: row.name,
      description: row.description,
      unit: row.unit,
      quantity: row.quantity,
      unitPriceCents: row.unitPriceCents,
      lineTotalCents: row.lineTotalCents,
      packageComponents: componentRows.isEmpty
          ? null
          : componentRows.map(_packageComponentToDomain).toList(),
    );
  }

  static QuotePackageComponentSnapshot _packageComponentToDomain(
    QuoteLinePackageComponentRow row,
  ) {
    return QuotePackageComponentSnapshot(
      catalogItemId: row.catalogItemId,
      name: row.name,
      unit: row.unit,
      typeLabel: row.typeLabel,
      categoryLabel: row.categoryLabel,
      quantityPerPackage: row.quantityPerPackage,
    );
  }

  static QuoteStatusHistoryEntry _statusHistoryToDomain(
    QuoteStatusHistoryRow row,
  ) {
    return QuoteStatusHistoryEntry(
      previousStatus: row.previousStatus == null
          ? null
          : _parseStatus(row.previousStatus!),
      newStatus: _parseStatus(row.newStatus),
      changedAt: TimestampConverter.fromUtcMillis(row.changedAt),
    );
  }

  static QuoteClientSnapshot _clientSnapshotToDomain(
    QuoteClientSnapshotRow row,
  ) {
    return QuoteClientSnapshot(
      sourceClientId: row.sourceClientId,
      type: _parseClientType(row.type),
      displayName: row.displayName,
      legalName: row.legalName,
      document: row.documentDigits,
      phone: row.phoneDigits,
      whatsApp: row.whatsappDigits,
      email: row.email,
      addressSummary: row.addressSummary,
    );
  }

  static QuoteEventSnapshot _eventSnapshotToDomain(
    QuoteEventSnapshotRow row,
  ) {
    return QuoteEventSnapshot(
      name: row.name,
      type: row.type,
      date: CivilDateConverter.fromIsoDate(row.eventDate),
      startTime: row.startTime,
      endTime: row.endTime,
      venueName: row.venueName,
      addressSummary: row.addressSummary,
      guestCount: row.guestCount,
    );
  }

  static QuoteCompanySnapshot _companySnapshotToDomain(
    QuoteCompanySnapshotRow row,
  ) {
    final hasLegalRepresentative =
        row.repFullName != null || row.repCpfDigits != null || row.repRole != null;
    final hasPayment = row.payPixKeyType != null ||
        row.payPixKey != null ||
        row.payBeneficiaryName != null ||
        row.payPaymentTerms != null;

    return QuoteCompanySnapshot(
      identification: QuoteCompanyIdentification(
        tradeName: row.identTradeName,
        legalName: row.identLegalName,
        cnpjDigits: row.identCnpjDigits,
        stateRegistration: row.identStateRegistration,
      ),
      contact: QuoteCompanyContact(
        phoneDigits: row.contactPhoneDigits,
        whatsAppDigits: row.contactWhatsappDigits,
        email: row.contactEmail,
        instagram: row.contactInstagram,
        website: row.contactWebsite,
      ),
      address: QuoteCompanyAddress(
        postalCode: row.addrPostalCode,
        street: row.addrStreet,
        number: row.addrNumber,
        complement: row.addrComplement,
        neighborhood: row.addrNeighborhood,
        city: row.addrCity,
        state: row.addrState,
      ),
      legalRepresentative: hasLegalRepresentative
          ? QuoteCompanyLegalRepresentative(
              fullName: row.repFullName,
              cpfDigits: row.repCpfDigits,
              role: row.repRole,
            )
          : null,
      payment: hasPayment
          ? QuoteCompanyPayment(
              pixKeyType: row.payPixKeyType == null
                  ? null
                  : _parsePixKeyType(row.payPixKeyType!),
              pixKey: row.payPixKey,
              beneficiaryName: row.payBeneficiaryName,
              paymentTerms: row.payPaymentTerms,
            )
          : null,
      logoReference: row.logoReference,
      captureStatus: _parseCaptureStatus(row.captureStatus),
      capturedAt: TimestampConverter.fromUtcMillis(row.capturedAt),
    );
  }

  static QuoteStatus _parseStatus(String value) {
    return QuoteStatus.values.firstWhere((status) => status.name == value);
  }

  static QuoteClientType _parseClientType(String value) {
    return QuoteClientType.values.firstWhere((type) => type.name == value);
  }

  static QuoteCompanyCaptureStatus _parseCaptureStatus(String value) {
    return QuoteCompanyCaptureStatus.values.firstWhere(
      (status) => status.name == value,
    );
  }

  static QuotePixKeyType _parsePixKeyType(String value) {
    return QuotePixKeyType.values.firstWhere((type) => type.name == value);
  }
}

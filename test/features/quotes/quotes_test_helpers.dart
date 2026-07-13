import 'package:eventpro/features/clients/client_type.dart';
import 'package:eventpro/features/clients/models/client.dart';
import 'package:eventpro/features/clients/models/client_address.dart';
import 'package:eventpro/features/catalog/catalog_category.dart';
import 'package:eventpro/features/catalog/catalog_item_type.dart';
import 'package:eventpro/features/catalog/models/catalog_item.dart';
import 'package:eventpro/features/quotes/models/quote.dart';
import 'package:eventpro/features/quotes/models/quote_client_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_event_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_line_item.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/models/quote_status_history_entry.dart';

Client sampleClient({
  String id = 'client-1',
  ClientType type = ClientType.individual,
  String name = 'Maria Silva',
  String? tradeName,
  String? document,
  String? internalNotes,
}) {
  return Client(
    id: id,
    createdAt: DateTime(2024, 3, 10),
    type: type,
    name: name,
    tradeName: tradeName,
    phone: '67999998888',
    whatsApp: '67999998888',
    email: 'maria@example.com',
    document: document ?? '52998224725',
    address: const ClientAddress(
      street: 'Rua das Flores',
      number: '100',
      city: 'Campo Grande',
      state: 'MS',
    ),
    internalNotes: internalNotes,
  );
}

CatalogItem sampleCatalogItem({
  String id = 'item-1',
  String name = 'Caixa de som',
  double price = 1500,
  bool active = true,
}) {
  return CatalogItem.fromForm(
    type: CatalogItemType.equipment,
    name: name,
    category: CatalogCategory.sound,
    unit: 'Unidade',
    price: price,
    id: id,
    createdAt: DateTime(2024, 5, 1),
    active: active,
  );
}

QuoteLineItem sampleLineItem({
  String catalogItemId = 'item-1',
  String name = 'Caixa de som',
  String? description,
  String unit = 'Unidade',
  double quantity = 1,
  int unitPriceCents = 150_000,
}) {
  return QuoteLineItem(
    catalogItemId: catalogItemId,
    name: name,
    description: description,
    unit: unit,
    quantity: quantity,
    unitPriceCents: unitPriceCents,
    lineTotalCents: (quantity * unitPriceCents).round(),
  );
}

Quote sampleQuoteDraft({
  String id = 'quote-1',
  List<QuoteLineItem>? items,
  List<QuoteStatusHistoryEntry>? statusHistory,
  QuoteStatus status = QuoteStatus.sent,
  DateTime? createdAt,
}) {
  final created = createdAt ?? DateTime(2020, 1, 1);
  return Quote(
    id: id,
    number: 'SHOULD-BE-IGNORED',
    status: status,
    clientSnapshot: QuoteClientSnapshot.fromClient(sampleClient()),
    eventSnapshot: QuoteEventSnapshot.empty,
    items: items ?? [sampleLineItem()],
    subtotalCents: 0,
    discountCents: 0,
    freightCents: 0,
    totalCents: 0,
    statusHistory: statusHistory ??
        [
          QuoteStatusHistoryEntry(
            previousStatus: null,
            newStatus: QuoteStatus.draft,
            changedAt: created,
          ),
        ],
    createdAt: created,
    updatedAt: created,
    approvedAt: DateTime(2020, 1, 1),
  );
}

Quote buildRichQuoteAddDraft({String id = 'quote-rich'}) {
  return Quote(
    id: id,
    number: 'IGNORED',
    status: QuoteStatus.draft,
    clientSnapshot: QuoteClientSnapshot.fromClient(sampleClient()),
    eventSnapshot: QuoteEventSnapshot(
      name: 'Casamento Ana',
      type: 'Social',
      date: DateTime(2026, 9, 15),
      guestCount: 150,
    ),
    items: [
      sampleLineItem(
        name: 'Caixa de som',
        description: 'Potência 500W',
        quantity: 2,
      ),
    ],
    subtotalCents: 0,
    discountCents: 10_000,
    freightCents: 5_000,
    totalCents: 0,
    statusHistory: const [],
    validUntil: DateTime(2026, 8, 1),
    notes: 'Observação pública do orçamento',
    internalNotes: 'Nota interna da equipe',
    createdAt: DateTime(2020, 1, 1),
    updatedAt: DateTime(2020, 1, 1),
  );
}

Quote buildMinimalQuoteAddDraft({String id = 'quote-minimal'}) {
  return Quote(
    id: id,
    number: 'IGNORED',
    status: QuoteStatus.draft,
    clientSnapshot: QuoteClientSnapshot.fromClient(sampleClient()),
    eventSnapshot: QuoteEventSnapshot.empty,
    items: [sampleLineItem()],
    subtotalCents: 0,
    discountCents: 0,
    freightCents: 0,
    totalCents: 0,
    statusHistory: const [],
    createdAt: DateTime(2020, 1, 1),
    updatedAt: DateTime(2020, 1, 1),
  );
}

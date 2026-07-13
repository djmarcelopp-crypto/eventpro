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

Client sampleClient({
  String id = 'client-1',
  ClientType type = ClientType.individual,
  String name = 'Maria Silva',
  String? tradeName,
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
    document: '52998224725',
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
}) {
  return CatalogItem.fromForm(
    type: CatalogItemType.equipment,
    name: name,
    category: CatalogCategory.sound,
    unit: 'Unidade',
    price: price,
    id: id,
    createdAt: DateTime(2024, 5, 1),
  );
}

QuoteLineItem sampleLineItem({
  double quantity = 1,
  int unitPriceCents = 150_000,
}) {
  return QuoteLineItem(
    catalogItemId: 'item-1',
    name: 'Caixa de som',
    unit: 'Unidade',
    quantity: quantity,
    unitPriceCents: unitPriceCents,
    lineTotalCents: (quantity * unitPriceCents).round(),
  );
}

Quote sampleQuoteDraft({
  String id = 'quote-1',
  List<QuoteLineItem>? items,
}) {
  return Quote(
    id: id,
    number: 'SHOULD-BE-IGNORED',
    status: QuoteStatus.sent,
    clientSnapshot: QuoteClientSnapshot.fromClient(sampleClient()),
    eventSnapshot: QuoteEventSnapshot.empty,
    items: items ?? [sampleLineItem()],
    subtotalCents: 0,
    discountCents: 0,
    freightCents: 0,
    totalCents: 0,
    createdAt: DateTime(2020, 1, 1),
    updatedAt: DateTime(2020, 1, 1),
    approvedAt: DateTime(2020, 1, 1),
  );
}

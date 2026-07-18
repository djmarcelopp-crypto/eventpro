import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/billing/models/invoice_item.dart';

abstract class InvoiceItemMapper {
  static InvoiceItem toDomain(InvoiceItemRow row) {
    return InvoiceItem(
      id: row.id,
      invoiceId: row.invoiceId,
      description: row.description,
      quantity: row.quantity,
      unitPriceCents: row.unitPriceCents,
      totalPriceCents: row.totalPriceCents,
    );
  }

  static InvoiceItemsCompanion toInsertCompanion(InvoiceItem item) {
    return _toCompanion(item);
  }

  static InvoiceItemsCompanion toUpdateCompanion(InvoiceItem item) {
    return _toCompanion(item);
  }

  static InvoiceItemsCompanion _toCompanion(InvoiceItem item) {
    return InvoiceItemsCompanion.insert(
      id: item.id,
      invoiceId: item.invoiceId,
      description: item.description,
      quantity: item.quantity,
      unitPriceCents: item.unitPriceCents,
      totalPriceCents: item.totalPriceCents,
    );
  }
}

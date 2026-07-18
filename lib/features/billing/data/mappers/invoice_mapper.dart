import 'package:drift/drift.dart';
import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/core/database/converters/timestamp_converter.dart';
import 'package:eventpro/features/billing/models/invoice.dart';
import 'package:eventpro/features/billing/models/invoice_status.dart';
import 'package:eventpro/features/billing/models/invoice_type.dart';

abstract class InvoiceMapper {
  static Invoice toDomain(InvoiceRow row) {
    return Invoice(
      id: row.id,
      quoteId: row.quoteId,
      invoiceNumber: row.invoiceNumber,
      type: InvoiceType.values.byName(row.type),
      status: InvoiceStatus.values.byName(row.status),
      issueDate: row.issueDate == null
          ? null
          : TimestampConverter.fromUtcMillis(row.issueDate!),
      dueDate: row.dueDate == null
          ? null
          : TimestampConverter.fromUtcMillis(row.dueDate!),
      paidAt: row.paidAt == null
          ? null
          : TimestampConverter.fromUtcMillis(row.paidAt!),
      subtotalCents: row.subtotalCents,
      taxCents: row.taxCents,
      discountCents: row.discountCents,
      totalCents: row.totalCents,
      notes: row.notes,
      createdAt: TimestampConverter.fromUtcMillis(row.createdAt),
      updatedAt: TimestampConverter.fromUtcMillis(row.updatedAt),
    );
  }

  static InvoicesCompanion toInsertCompanion(Invoice invoice) {
    return _toCompanion(invoice);
  }

  static InvoicesCompanion toUpdateCompanion(Invoice invoice) {
    return _toCompanion(invoice);
  }

  static InvoicesCompanion _toCompanion(Invoice invoice) {
    return InvoicesCompanion.insert(
      id: invoice.id,
      quoteId: invoice.quoteId,
      invoiceNumber: invoice.invoiceNumber,
      type: invoice.type.name,
      status: invoice.status.name,
      issueDate: Value(
        invoice.issueDate == null
            ? null
            : TimestampConverter.toUtcMillis(invoice.issueDate!),
      ),
      dueDate: Value(
        invoice.dueDate == null
            ? null
            : TimestampConverter.toUtcMillis(invoice.dueDate!),
      ),
      paidAt: Value(
        invoice.paidAt == null
            ? null
            : TimestampConverter.toUtcMillis(invoice.paidAt!),
      ),
      subtotalCents: invoice.subtotalCents,
      taxCents: invoice.taxCents,
      discountCents: invoice.discountCents,
      totalCents: invoice.totalCents,
      notes: invoice.notes,
      createdAt: TimestampConverter.toUtcMillis(invoice.createdAt),
      updatedAt: TimestampConverter.toUtcMillis(invoice.updatedAt),
    );
  }
}

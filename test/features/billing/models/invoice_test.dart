import 'package:eventpro/features/billing/models/invoice.dart';
import 'package:eventpro/features/billing/models/invoice_status.dart';
import 'package:eventpro/features/billing/models/invoice_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Invoice', () {
    final createdAt = DateTime(2026, 7, 17, 10);
    final updatedAt = DateTime(2026, 7, 17, 11);

    Invoice buildInvoice({
      String id = 'inv-1',
      InvoiceStatus status = InvoiceStatus.draft,
      InvoiceType type = InvoiceType.service,
      String notes = 'Obs',
    }) {
      return Invoice(
        id: id,
        quoteId: 'quote-1',
        invoiceNumber: 'INV-2026-0001',
        type: type,
        status: status,
        subtotalCents: 10_000,
        taxCents: 1_000,
        discountCents: 500,
        totalCents: 10_500,
        notes: notes,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
    }

    test('notes defaults to empty and optional dates to null', () {
      final invoice = Invoice(
        id: 'inv-1',
        quoteId: 'quote-1',
        invoiceNumber: 'INV-1',
        type: InvoiceType.service,
        status: InvoiceStatus.draft,
        subtotalCents: 0,
        taxCents: 0,
        discountCents: 0,
        totalCents: 0,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

      expect(invoice.notes, '');
      expect(invoice.issueDate, isNull);
      expect(invoice.dueDate, isNull);
      expect(invoice.paidAt, isNull);
      expect(invoice.isDraft, isTrue);
    });

    test('equality compares all fields', () {
      final a = buildInvoice();
      final b = buildInvoice();
      final different = buildInvoice(status: InvoiceStatus.paid);

      expect(a, equals(b));
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(equals(different)));
    });

    test('copyWith preserves and can clear nullable dates', () {
      final original = buildInvoice().copyWith(
        issueDate: DateTime(2026, 7, 18),
        paidAt: DateTime(2026, 7, 20),
      );
      final copy = original.copyWith(
        status: InvoiceStatus.issued,
        clearPaidAt: true,
      );

      expect(copy.status, InvoiceStatus.issued);
      expect(copy.issueDate, DateTime(2026, 7, 18));
      expect(copy.paidAt, isNull);
      expect(copy.createdAt, original.createdAt);
    });

    test('status helpers reflect InvoiceStatus', () {
      expect(buildInvoice(status: InvoiceStatus.issued).isIssued, isTrue);
      expect(buildInvoice(status: InvoiceStatus.paid).isPaid, isTrue);
      expect(buildInvoice(status: InvoiceStatus.cancelled).isCancelled, isTrue);
    });
  });
}

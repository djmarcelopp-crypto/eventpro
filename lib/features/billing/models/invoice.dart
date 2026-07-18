import 'invoice_status.dart';
import 'invoice_type.dart';

/// A billing document linked to a quote.
///
/// Immutable domain entity. Fiscal emission, PDF and bank integrations are out
/// of scope for the domain foundation checkpoint.
class Invoice {
  const Invoice({
    required this.id,
    required this.quoteId,
    required this.invoiceNumber,
    required this.type,
    required this.status,
    required this.subtotalCents,
    required this.taxCents,
    required this.discountCents,
    required this.totalCents,
    required this.createdAt,
    required this.updatedAt,
    this.issueDate,
    this.dueDate,
    this.paidAt,
    this.notes = '',
  });

  final String id;
  final String quoteId;
  final String invoiceNumber;
  final InvoiceType type;
  final InvoiceStatus status;
  final DateTime? issueDate;
  final DateTime? dueDate;
  final DateTime? paidAt;
  final int subtotalCents;
  final int taxCents;
  final int discountCents;
  final int totalCents;
  final String notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isDraft => status == InvoiceStatus.draft;
  bool get isIssued => status == InvoiceStatus.issued;
  bool get isPaid => status == InvoiceStatus.paid;
  bool get isCancelled => status == InvoiceStatus.cancelled;

  Invoice copyWith({
    String? id,
    String? quoteId,
    String? invoiceNumber,
    InvoiceType? type,
    InvoiceStatus? status,
    DateTime? issueDate,
    DateTime? dueDate,
    DateTime? paidAt,
    int? subtotalCents,
    int? taxCents,
    int? discountCents,
    int? totalCents,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearIssueDate = false,
    bool clearDueDate = false,
    bool clearPaidAt = false,
  }) {
    return Invoice(
      id: id ?? this.id,
      quoteId: quoteId ?? this.quoteId,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      type: type ?? this.type,
      status: status ?? this.status,
      issueDate: clearIssueDate ? null : (issueDate ?? this.issueDate),
      dueDate: clearDueDate ? null : (dueDate ?? this.dueDate),
      paidAt: clearPaidAt ? null : (paidAt ?? this.paidAt),
      subtotalCents: subtotalCents ?? this.subtotalCents,
      taxCents: taxCents ?? this.taxCents,
      discountCents: discountCents ?? this.discountCents,
      totalCents: totalCents ?? this.totalCents,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is Invoice &&
            other.id == id &&
            other.quoteId == quoteId &&
            other.invoiceNumber == invoiceNumber &&
            other.type == type &&
            other.status == status &&
            other.issueDate == issueDate &&
            other.dueDate == dueDate &&
            other.paidAt == paidAt &&
            other.subtotalCents == subtotalCents &&
            other.taxCents == taxCents &&
            other.discountCents == discountCents &&
            other.totalCents == totalCents &&
            other.notes == notes &&
            other.createdAt == createdAt &&
            other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
        id,
        quoteId,
        invoiceNumber,
        type,
        status,
        issueDate,
        dueDate,
        paidAt,
        subtotalCents,
        taxCents,
        discountCents,
        totalCents,
        notes,
        createdAt,
        updatedAt,
      );
}

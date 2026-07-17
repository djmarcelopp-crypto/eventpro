import 'financial_entry_status.dart';
import 'financial_flow_kind.dart';

/// A single financial movement: a revenue (receita) or an expense (despesa).
///
/// Both concepts are represented by this single entity, discriminated by
/// [kind], instead of two near-identical classes. This follows the same
/// discriminator pattern already used elsewhere in the project (e.g.
/// `QuoteStatus`, `AgendaOccupancyKind`) and avoids duplicating fields that
/// would otherwise be identical between a "Revenue" and an "Expense" class.
class FinancialEntry {
  const FinancialEntry({
    required this.id,
    required this.kind,
    required this.description,
    required this.amountCents,
    required this.date,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    this.status = FinancialEntryStatus.pending,
    this.paidAt,
    this.notes,
  });

  final String id;
  final FinancialFlowKind kind;
  final String description;

  /// Monetary amount in cents, always positive. The sign of the movement is
  /// determined by [kind], not by this value.
  final int amountCents;

  /// Civil date (competência) the entry refers to, e.g. when the revenue was
  /// earned or the expense was incurred.
  final DateTime date;
  final String categoryId;
  final FinancialEntryStatus status;

  /// When the entry was actually settled (received or paid). Only meaningful
  /// when [status] is [FinancialEntryStatus.paid].
  final DateTime? paidAt;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isIncome => kind == FinancialFlowKind.income;
  bool get isExpense => kind == FinancialFlowKind.expense;
  bool get isPaid => status == FinancialEntryStatus.paid;

  FinancialEntry copyWith({
    String? id,
    FinancialFlowKind? kind,
    String? description,
    int? amountCents,
    DateTime? date,
    String? categoryId,
    FinancialEntryStatus? status,
    DateTime? paidAt,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearPaidAt = false,
    bool clearNotes = false,
  }) {
    return FinancialEntry(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      description: description ?? this.description,
      amountCents: amountCents ?? this.amountCents,
      date: date ?? this.date,
      categoryId: categoryId ?? this.categoryId,
      status: status ?? this.status,
      paidAt: clearPaidAt ? null : (paidAt ?? this.paidAt),
      notes: clearNotes ? null : (notes ?? this.notes),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

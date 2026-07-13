import 'quote_client_snapshot.dart';
import 'quote_event_snapshot.dart';
import 'quote_line_item.dart';
import 'quote_status.dart';

class Quote {
  Quote({
    required this.id,
    required this.number,
    required this.status,
    required this.clientSnapshot,
    required this.eventSnapshot,
    required List<QuoteLineItem> items,
    required this.subtotalCents,
    required this.discountCents,
    required this.freightCents,
    required this.totalCents,
    this.validUntil,
    this.notes,
    this.internalNotes,
    required this.createdAt,
    required this.updatedAt,
    this.approvedAt,
  }) : items = List.unmodifiable(items);

  final String id;
  final String number;
  final QuoteStatus status;
  final QuoteClientSnapshot clientSnapshot;
  final QuoteEventSnapshot eventSnapshot;
  final List<QuoteLineItem> items;
  final int subtotalCents;
  final int discountCents;
  final int freightCents;
  final int totalCents;
  final DateTime? validUntil;
  final String? notes;
  final String? internalNotes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? approvedAt;

  bool get isApprovedForContract => status == QuoteStatus.approved;

  Quote copyWith({
    String? id,
    String? number,
    QuoteStatus? status,
    QuoteClientSnapshot? clientSnapshot,
    QuoteEventSnapshot? eventSnapshot,
    List<QuoteLineItem>? items,
    int? subtotalCents,
    int? discountCents,
    int? freightCents,
    int? totalCents,
    DateTime? validUntil,
    String? notes,
    String? internalNotes,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? approvedAt,
    bool clearValidUntil = false,
    bool clearNotes = false,
    bool clearInternalNotes = false,
    bool clearApprovedAt = false,
  }) {
    return Quote(
      id: id ?? this.id,
      number: number ?? this.number,
      status: status ?? this.status,
      clientSnapshot: clientSnapshot ?? this.clientSnapshot,
      eventSnapshot: eventSnapshot ?? this.eventSnapshot,
      items: items ?? this.items,
      subtotalCents: subtotalCents ?? this.subtotalCents,
      discountCents: discountCents ?? this.discountCents,
      freightCents: freightCents ?? this.freightCents,
      totalCents: totalCents ?? this.totalCents,
      validUntil: clearValidUntil ? null : (validUntil ?? this.validUntil),
      notes: clearNotes ? null : (notes ?? this.notes),
      internalNotes:
          clearInternalNotes ? null : (internalNotes ?? this.internalNotes),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      approvedAt: clearApprovedAt ? null : (approvedAt ?? this.approvedAt),
    );
  }
}

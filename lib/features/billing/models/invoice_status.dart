/// Lifecycle status of an [Invoice].
///
/// Pure Dart — no Flutter dependency. UI labels live in this extension.
enum InvoiceStatus {
  draft,
  issued,
  paid,
  cancelled,
}

extension InvoiceStatusLabels on InvoiceStatus {
  String get label => switch (this) {
        InvoiceStatus.draft => 'Rascunho',
        InvoiceStatus.issued => 'Emitida',
        InvoiceStatus.paid => 'Paga',
        InvoiceStatus.cancelled => 'Cancelada',
      };
}

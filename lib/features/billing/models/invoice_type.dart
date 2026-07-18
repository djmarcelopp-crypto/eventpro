/// Kind of goods/services covered by an [Invoice].
///
/// Pure Dart — no Flutter dependency. UI labels live in this extension.
enum InvoiceType {
  service,
  product,
  mixed,
}

extension InvoiceTypeLabels on InvoiceType {
  String get label => switch (this) {
        InvoiceType.service => 'Serviço',
        InvoiceType.product => 'Produto',
        InvoiceType.mixed => 'Misto',
      };
}

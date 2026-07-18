/// Lifecycle status of a [Contract].
///
/// Pure Dart — no Flutter dependency. UI labels live in this extension.
enum ContractStatus {
  draft,
  generated,
  sent,
  signed,
  cancelled,
  expired,
}

extension ContractStatusLabels on ContractStatus {
  String get label => switch (this) {
        ContractStatus.draft => 'Rascunho',
        ContractStatus.generated => 'Gerado',
        ContractStatus.sent => 'Enviado',
        ContractStatus.signed => 'Assinado',
        ContractStatus.cancelled => 'Cancelado',
        ContractStatus.expired => 'Expirado',
      };
}

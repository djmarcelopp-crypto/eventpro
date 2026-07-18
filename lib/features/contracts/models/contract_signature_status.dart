/// Signature workflow status for a contract.
///
/// Pure Dart — no Flutter dependency. Distinct from [ContractStatus];
/// used when tracking signature outcome independently of lifecycle.
enum ContractSignatureStatus {
  pending,
  signed,
  rejected,
}

extension ContractSignatureStatusLabels on ContractSignatureStatus {
  String get label => switch (this) {
        ContractSignatureStatus.pending => 'Pendente',
        ContractSignatureStatus.signed => 'Assinado',
        ContractSignatureStatus.rejected => 'Recusado',
      };
}

import '../models/contract.dart';
import '../models/contract_status.dart';

/// Aggregate counters for the contracts list / dashboard.
class ContractListSummary {
  const ContractListSummary({
    required this.total,
    required this.draft,
    required this.generated,
    required this.sent,
    required this.signed,
    required this.cancelled,
    required this.expired,
  });

  factory ContractListSummary.fromContracts(List<Contract> contracts) {
    var draft = 0;
    var generated = 0;
    var sent = 0;
    var signed = 0;
    var cancelled = 0;
    var expired = 0;
    for (final contract in contracts) {
      switch (contract.status) {
        case ContractStatus.draft:
          draft++;
        case ContractStatus.generated:
          generated++;
        case ContractStatus.sent:
          sent++;
        case ContractStatus.signed:
          signed++;
        case ContractStatus.cancelled:
          cancelled++;
        case ContractStatus.expired:
          expired++;
      }
    }
    return ContractListSummary(
      total: contracts.length,
      draft: draft,
      generated: generated,
      sent: sent,
      signed: signed,
      cancelled: cancelled,
      expired: expired,
    );
  }

  static const empty = ContractListSummary(
    total: 0,
    draft: 0,
    generated: 0,
    sent: 0,
    signed: 0,
    cancelled: 0,
    expired: 0,
  );

  final int total;
  final int draft;
  final int generated;
  final int sent;
  final int signed;
  final int cancelled;
  final int expired;
}

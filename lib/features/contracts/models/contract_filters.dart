import 'contract_status.dart';

class ContractFilters {
  const ContractFilters({
    this.status,
    this.numberQuery = '',
  });

  static const empty = ContractFilters();

  final ContractStatus? status;
  final String numberQuery;

  bool get hasActiveFilters =>
      status != null || numberQuery.trim().isNotEmpty;

  ContractFilters copyWith({
    ContractStatus? status,
    String? numberQuery,
    bool clearStatus = false,
  }) {
    return ContractFilters(
      status: clearStatus ? null : (status ?? this.status),
      numberQuery: numberQuery ?? this.numberQuery,
    );
  }
}

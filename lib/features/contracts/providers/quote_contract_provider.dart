import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/contract.dart';
import '../models/contract_operation_result.dart';
import '../models/quote_contract_summary.dart';
import '../utils/quote_contract_service.dart';
import 'contract_provider.dart';
import 'quote_contract_service_provider.dart';

class QuoteContractNotifier extends AsyncNotifier<List<Contract>> {
  QuoteContractNotifier(this.quoteId);

  final String quoteId;

  QuoteContractService get _service => ref.read(quoteContractServiceProvider);

  @override
  Future<List<Contract>> build() async {
    final summary = await _service.summaryForQuote(quoteId);
    return summary.contracts;
  }

  Future<ContractOperationResult> generate({
    String? templateId,
    String notes = '',
  }) async {
    final result = await _service.generateForQuote(
      quoteId: quoteId,
      templateId: templateId,
      notes: notes,
    );
    if (result.isSuccess && result.contract != null) {
      final current = state.value ?? const <Contract>[];
      state = AsyncValue.data(
        List.unmodifiable([result.contract!, ...current]),
      );
      ref.invalidate(contractProvider);
    }
    return result;
  }

  Future<ContractOperationResult> cancel(String contractId) async {
    final result = await _service.cancelContract(contractId);
    if (result.isSuccess && result.contract != null) {
      final current = state.value ?? const <Contract>[];
      state = AsyncValue.data(
        List.unmodifiable([
          for (final item in current)
            if (item.id == result.contract!.id) result.contract! else item,
        ]),
      );
      ref.invalidate(contractProvider);
    }
    return result;
  }
}

final quoteContractProvider = AsyncNotifierProvider.family<
  QuoteContractNotifier,
  List<Contract>,
  String
>(QuoteContractNotifier.new);

final quoteContractSummaryProvider =
    Provider.family<AsyncValue<QuoteContractSummary>, String>((ref, quoteId) {
      return ref.watch(quoteContractProvider(quoteId)).whenData(
            (contracts) => QuoteContractSummary(
              quoteId: quoteId,
              contracts: contracts,
            ),
          );
    });

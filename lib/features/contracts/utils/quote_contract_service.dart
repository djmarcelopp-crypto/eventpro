import '../models/contract_operation_result.dart';
import '../models/contract_status.dart';
import '../models/quote_contract_summary.dart';
import 'contract_service.dart';
import 'contract_workflow_service.dart';

/// Quote-scoped contract operations (generate / cancel / status).
///
/// No UI, no PDF, no digital signature — orchestration only.
/// Status transitions go through [ContractWorkflowService] (single matrix).
class QuoteContractService {
  QuoteContractService({
    required ContractService contractService,
    required ContractWorkflowService workflowService,
  })  : _contractService = contractService,
        _workflowService = workflowService;

  final ContractService _contractService;
  final ContractWorkflowService _workflowService;

  Future<QuoteContractSummary> summaryForQuote(String quoteId) async {
    final contracts = await _contractService.listByQuoteId(quoteId);
    // listByQuoteId is newest-first from DAO; keep that order for "latest".
    return QuoteContractSummary(quoteId: quoteId, contracts: contracts);
  }

  Future<ContractStatus?> statusForQuote(String quoteId) async {
    final summary = await summaryForQuote(quoteId);
    return summary.latestStatus;
  }

  /// Creates a draft for the quote (optional template) and marks it generated.
  Future<ContractOperationResult> generateForQuote({
    required String quoteId,
    String? templateId,
    String? contractNumber,
    String notes = '',
    DateTime? expiresAt,
  }) async {
    final created = await _contractService.create(
      quoteId: quoteId,
      templateId: templateId,
      contractNumber: contractNumber,
      notes: notes,
      expiresAt: expiresAt,
    );
    if (!created.isSuccess || created.contract == null) {
      return created;
    }
    return _workflowService.generate(created.contract!.id);
  }

  Future<ContractOperationResult> cancelContract(String contractId) {
    return _workflowService.cancel(contractId);
  }
}

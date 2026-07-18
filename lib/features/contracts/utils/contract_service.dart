import 'package:eventpro/features/quotes/data/repositories/quote_repository.dart';
import 'package:uuid/uuid.dart';

import '../data/repositories/contract_repository.dart';
import '../data/repositories/contract_template_repository.dart';
import '../models/contract.dart';
import '../models/contract_operation_result.dart';
import '../models/contract_status.dart';
import 'contract_validator.dart';

/// Contract write/read orchestration without workflow transition rules.
///
/// Status-transition eligibility lives exclusively in
/// [ContractWorkflowService]. Methods here validate existence/integrity,
/// preserve [Contract.createdAt], stamp [Contract.updatedAt] via the clock,
/// and persist through the repository.
class ContractService {
  ContractService({
    required this._contractRepository,
    required this._templateRepository,
    required this._quoteRepository,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  static const _uuid = Uuid();

  final ContractRepository _contractRepository;
  final ContractTemplateRepository _templateRepository;
  final QuoteRepository _quoteRepository;
  final DateTime Function() _clock;

  Future<ContractOperationResult> create({
    required String quoteId,
    String? templateId,
    String? contractNumber,
    String notes = '',
    DateTime? expiresAt,
  }) async {
    final quote = await _quoteRepository.findById(quoteId);
    if (quote == null) {
      return ContractOperationResult.quoteNotFound();
    }

    if (templateId != null) {
      final template = await _templateRepository.findById(templateId);
      if (template == null) {
        return ContractOperationResult.templateNotFound();
      }
      if (!template.active) {
        return ContractOperationResult.templateInactive();
      }
    }

    final number = (contractNumber ?? await _nextContractNumber()).trim();
    final fieldsResult = ContractValidator.validateFields(
      quoteId: quoteId,
      contractNumber: number,
      status: ContractStatus.draft,
    );
    if (!fieldsResult.isValid) {
      return ContractOperationResult.validationFailed(fieldsResult.errors);
    }

    if (await _hasDuplicateNumber(number)) {
      return ContractOperationResult.duplicateNumber();
    }

    final now = _clock();
    final contract = Contract(
      id: _uuid.v7(),
      quoteId: quoteId,
      templateId: templateId,
      contractNumber: number,
      status: ContractStatus.draft,
      expiresAt: expiresAt,
      notes: notes.trim(),
      createdAt: now,
      updatedAt: now,
    );

    try {
      await _contractRepository.insert(contract);
      return ContractOperationResult.success(contract);
    } catch (_) {
      return ContractOperationResult.failure();
    }
  }

  Future<ContractOperationResult> updateNotes({
    required String id,
    required String notes,
  }) async {
    final existing = await _contractRepository.findById(id);
    if (existing == null) {
      return ContractOperationResult.notFound();
    }

    final now = _clock();
    final updated = existing.copyWith(
      notes: notes.trim(),
      createdAt: existing.createdAt,
      updatedAt: now,
    );

    try {
      await _contractRepository.update(updated);
      return ContractOperationResult.success(updated);
    } catch (_) {
      return ContractOperationResult.failure();
    }
  }

  /// Persists `generated` status and [Contract.generatedAt].
  ///
  /// Caller must already validate the transition via [ContractWorkflowService].
  Future<ContractOperationResult> applyGenerated(String id) {
    return _persist(
      id: id,
      apply: (existing, now) => existing.copyWith(
        status: ContractStatus.generated,
        generatedAt: now,
        updatedAt: now,
        createdAt: existing.createdAt,
      ),
    );
  }

  /// Persists `sent` status and [Contract.sentAt].
  ///
  /// Caller must already validate the transition via [ContractWorkflowService].
  Future<ContractOperationResult> applySent(String id) {
    return _persist(
      id: id,
      apply: (existing, now) => existing.copyWith(
        status: ContractStatus.sent,
        sentAt: now,
        updatedAt: now,
        createdAt: existing.createdAt,
      ),
    );
  }

  /// Persists `signed` status and [Contract.signedAt].
  ///
  /// Caller must already validate the transition via [ContractWorkflowService].
  Future<ContractOperationResult> applySigned(String id) {
    return _persist(
      id: id,
      apply: (existing, now) => existing.copyWith(
        status: ContractStatus.signed,
        signedAt: now,
        updatedAt: now,
        createdAt: existing.createdAt,
      ),
    );
  }

  /// Persists `cancelled` status.
  ///
  /// Caller must already validate the transition via [ContractWorkflowService].
  Future<ContractOperationResult> applyCancelled(String id) {
    return _persist(
      id: id,
      apply: (existing, now) => existing.copyWith(
        status: ContractStatus.cancelled,
        updatedAt: now,
        createdAt: existing.createdAt,
      ),
    );
  }

  /// Persists `expired` status.
  ///
  /// Caller must already validate the transition via [ContractWorkflowService].
  Future<ContractOperationResult> applyExpired(String id) {
    return _persist(
      id: id,
      apply: (existing, now) => existing.copyWith(
        status: ContractStatus.expired,
        updatedAt: now,
        createdAt: existing.createdAt,
      ),
    );
  }

  Future<Contract?> findById(String id) => _contractRepository.findById(id);

  Future<List<Contract>> listByQuoteId(String quoteId) =>
      _contractRepository.listByQuoteId(quoteId);

  Future<ContractOperationResult> _persist({
    required String id,
    required Contract Function(Contract existing, DateTime now) apply,
  }) async {
    final existing = await _contractRepository.findById(id);
    if (existing == null) {
      return ContractOperationResult.notFound();
    }

    final now = _clock();
    final updated = apply(existing, now);

    try {
      await _contractRepository.update(updated);
      return ContractOperationResult.success(updated);
    } catch (_) {
      return ContractOperationResult.failure();
    }
  }

  Future<String> _nextContractNumber() async {
    final now = _clock();
    final year = now.year;
    final prefix = 'CTR-$year-';
    final all = await _contractRepository.listAll();
    var maxSequence = 0;
    for (final contract in all) {
      final number = contract.contractNumber;
      if (!number.startsWith(prefix)) continue;
      final suffix = number.substring(prefix.length);
      final sequence = int.tryParse(suffix);
      if (sequence != null && sequence > maxSequence) {
        maxSequence = sequence;
      }
    }
    final next = (maxSequence + 1).toString().padLeft(4, '0');
    return '$prefix$next';
  }

  Future<bool> _hasDuplicateNumber(String number, {String? excludingId}) async {
    final all = await _contractRepository.listAll();
    final needle = number.toLowerCase();
    return all.any(
      (contract) =>
          contract.id != excludingId &&
          contract.contractNumber.trim().toLowerCase() == needle,
    );
  }
}

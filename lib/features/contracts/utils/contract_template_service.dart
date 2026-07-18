import 'package:uuid/uuid.dart';

import '../data/repositories/contract_repository.dart';
import '../data/repositories/contract_template_repository.dart';
import '../models/contract_template.dart';
import '../models/contract_template_operation_result.dart';
import 'contract_template_validator.dart';

/// Coordinates validation and persistence for [ContractTemplate] writes.
class ContractTemplateService {
  ContractTemplateService({
    required this._templateRepository,
    required this._contractRepository,
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  static const _uuid = Uuid();

  final ContractTemplateRepository _templateRepository;
  final ContractRepository _contractRepository;
  final DateTime Function() _clock;

  Future<ContractTemplateOperationResult> create(ContractTemplate draft) async {
    final normalizedName = draft.name.trim();
    final fieldsResult =
        ContractTemplateValidator.validateFields(name: normalizedName);
    if (!fieldsResult.isValid) {
      return ContractTemplateOperationResult.validationFailed(
        fieldsResult.errors,
      );
    }

    if (await _hasDuplicateName(normalizedName)) {
      return ContractTemplateOperationResult.duplicateName();
    }

    final now = _clock();
    final template = draft.copyWith(
      id: _uuid.v7(),
      name: normalizedName,
      createdAt: now,
      updatedAt: now,
    );

    try {
      await _templateRepository.insert(template);
      return ContractTemplateOperationResult.success(template);
    } catch (_) {
      return ContractTemplateOperationResult.failure();
    }
  }

  Future<ContractTemplateOperationResult> update(
    ContractTemplate template,
  ) async {
    final existing = await _templateRepository.findById(template.id);
    if (existing == null) {
      return ContractTemplateOperationResult.notFound();
    }

    final normalizedName = template.name.trim();
    final fieldsResult =
        ContractTemplateValidator.validateFields(name: normalizedName);
    if (!fieldsResult.isValid) {
      return ContractTemplateOperationResult.validationFailed(
        fieldsResult.errors,
      );
    }

    if (await _hasDuplicateName(normalizedName, excludingId: existing.id)) {
      return ContractTemplateOperationResult.duplicateName();
    }

    final now = _clock();
    final updated = template.copyWith(
      id: existing.id,
      name: normalizedName,
      createdAt: existing.createdAt,
      updatedAt: now,
    );

    try {
      await _templateRepository.update(updated);
      return ContractTemplateOperationResult.success(updated);
    } catch (_) {
      return ContractTemplateOperationResult.failure();
    }
  }

  Future<ContractTemplateOperationResult> activate(String id) async {
    return _setActive(id, active: true);
  }

  Future<ContractTemplateOperationResult> deactivate(String id) async {
    return _setActive(id, active: false);
  }

  Future<ContractTemplateOperationResult> delete(String id) async {
    final existing = await _templateRepository.findById(id);
    if (existing == null) {
      return ContractTemplateOperationResult.notFound();
    }

    final contracts = await _contractRepository.listAll();
    final usageCount =
        contracts.where((contract) => contract.templateId == id).length;
    if (usageCount > 0) {
      return ContractTemplateOperationResult.blockedByUsage(
        blockingContractCount: usageCount,
      );
    }

    try {
      await _templateRepository.delete(id);
      return ContractTemplateOperationResult.deleted();
    } catch (_) {
      return ContractTemplateOperationResult.failure();
    }
  }

  Future<ContractTemplateOperationResult> _setActive(
    String id, {
    required bool active,
  }) async {
    final existing = await _templateRepository.findById(id);
    if (existing == null) {
      return ContractTemplateOperationResult.notFound();
    }

    final now = _clock();
    final updated = existing.copyWith(active: active, updatedAt: now);
    try {
      await _templateRepository.update(updated);
      return ContractTemplateOperationResult.success(updated);
    } catch (_) {
      return ContractTemplateOperationResult.failure();
    }
  }

  Future<bool> _hasDuplicateName(String name, {String? excludingId}) async {
    final all = await _templateRepository.listAll();
    final needle = name.toLowerCase();
    return all.any(
      (template) =>
          template.id != excludingId &&
          template.name.trim().toLowerCase() == needle,
    );
  }
}

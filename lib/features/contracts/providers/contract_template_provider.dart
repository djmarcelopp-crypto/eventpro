import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/contract_template_repository.dart';
import '../models/contract_template.dart';
import '../models/contract_template_operation_result.dart';
import '../utils/contract_template_service.dart';
import 'contract_template_repository_provider.dart';
import 'contract_template_service_provider.dart';

class ContractTemplateNotifier extends AsyncNotifier<List<ContractTemplate>> {
  ContractTemplateRepository get _repository =>
      ref.read(contractTemplateRepositoryProvider);
  ContractTemplateService get _service =>
      ref.read(contractTemplateServiceProvider);

  @override
  Future<List<ContractTemplate>> build() async => _repository.listAll();

  ContractTemplate? findById(String id) {
    final current = state.value;
    if (current == null) return null;
    for (final template in current) {
      if (template.id == id) return template;
    }
    return null;
  }

  Future<ContractTemplateOperationResult> addTemplate(
    ContractTemplate draft,
  ) async {
    final result = await _service.create(draft);
    if (result.isSuccess && result.template != null) {
      _replaceAll([
        ...?state.value,
        result.template!,
      ]);
    }
    return result;
  }

  Future<ContractTemplateOperationResult> updateTemplate(
    ContractTemplate template,
  ) async {
    final result = await _service.update(template);
    if (result.isSuccess && result.template != null) {
      _replaceAll([
        for (final item in state.value ?? const <ContractTemplate>[])
          if (item.id == result.template!.id) result.template! else item,
      ]);
    }
    return result;
  }

  Future<ContractTemplateOperationResult> deleteTemplate(String id) async {
    final result = await _service.delete(id);
    if (result.isDeleted) {
      _replaceAll([
        for (final template in state.value ?? const <ContractTemplate>[])
          if (template.id != id) template,
      ]);
    }
    return result;
  }

  Future<ContractTemplateOperationResult> setActive(
    String id, {
    required bool active,
  }) async {
    final result =
        active ? await _service.activate(id) : await _service.deactivate(id);
    if (result.isSuccess && result.template != null) {
      _replaceAll([
        for (final item in state.value ?? const <ContractTemplate>[])
          if (item.id == result.template!.id) result.template! else item,
      ]);
    }
    return result;
  }

  void _replaceAll(List<ContractTemplate> items) {
    final next = [...items]
      ..sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
    state = AsyncValue.data(List.unmodifiable(next));
  }
}

final contractTemplateProvider =
    AsyncNotifierProvider<ContractTemplateNotifier, List<ContractTemplate>>(
      ContractTemplateNotifier.new,
    );

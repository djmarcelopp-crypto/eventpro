import 'package:eventpro/features/contracts/data/repositories/contract_template_repository.dart';
import 'package:eventpro/features/contracts/models/contract_template.dart';

class FakeContractTemplateRepository implements ContractTemplateRepository {
  FakeContractTemplateRepository({List<ContractTemplate>? initialTemplates})
      : _templates = List<ContractTemplate>.from(initialTemplates ?? const []);

  final List<ContractTemplate> _templates;
  var shouldFailOnNextOperation = false;

  @override
  Future<List<ContractTemplate>> listAll() async {
    return List<ContractTemplate>.unmodifiable(_templates);
  }

  @override
  Future<ContractTemplate?> findById(String id) async {
    for (final template in _templates) {
      if (template.id == id) return template;
    }
    return null;
  }

  @override
  Future<void> insert(ContractTemplate template) async {
    _failIfRequested();
    _templates.add(template);
  }

  @override
  Future<void> update(ContractTemplate template) async {
    _failIfRequested();
    final index =
        _templates.indexWhere((current) => current.id == template.id);
    if (index == -1) {
      throw StateError('ContractTemplate not found for update: ${template.id}');
    }
    _templates[index] = template;
  }

  @override
  Future<void> delete(String id) async {
    _failIfRequested();
    final lengthBefore = _templates.length;
    _templates.removeWhere((template) => template.id == id);
    if (_templates.length == lengthBefore) {
      throw StateError('ContractTemplate not found for delete: $id');
    }
  }

  void _failIfRequested() {
    if (!shouldFailOnNextOperation) return;
    shouldFailOnNextOperation = false;
    throw StateError('Simulated repository failure');
  }
}

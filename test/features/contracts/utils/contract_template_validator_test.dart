import 'package:eventpro/features/contracts/models/contract_template.dart';
import 'package:eventpro/features/contracts/utils/contract_template_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ContractTemplateValidator', () {
    final now = DateTime(2026, 7, 17);

    test('rejects empty name', () {
      final result = ContractTemplateValidator.validateFields(name: '  ');
      expect(result.isValid, isFalse);
      expect(result.errors, [ContractTemplateValidator.nameRequiredError]);
    });

    test('accepts valid template', () {
      final result = ContractTemplateValidator.validate(
        ContractTemplate(
          id: 'tpl-1',
          name: 'Padrão',
          createdAt: now,
          updatedAt: now,
        ),
      );
      expect(result.isValid, isTrue);
    });
  });
}

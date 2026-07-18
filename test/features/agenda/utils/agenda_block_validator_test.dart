import 'package:eventpro/features/agenda/models/agenda_block.dart';
import 'package:eventpro/features/agenda/utils/agenda_block_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AgendaBlockValidator', () {
    final start = DateTime(2026, 8, 15, 8, 0);
    final end = DateTime(2026, 8, 15, 12, 0);

    AgendaBlock buildBlock({
      String title = 'Manutenção do galpão',
      DateTime? startValue,
      DateTime? endValue,
    }) {
      return AgendaBlock(
        id: 'block-1',
        title: title,
        start: startValue ?? start,
        end: endValue ?? end,
        createdAt: start,
        updatedAt: start,
      );
    }

    test('accepts a fully valid block', () {
      final result = AgendaBlockValidator.validate(buildBlock());

      expect(result.isValid, isTrue);
      expect(result.errors, isEmpty);
    });

    test('rejects empty title', () {
      final result = AgendaBlockValidator.validateFields(
        title: '',
        start: start,
        end: end,
      );

      expect(result.isValid, isFalse);
      expect(result.errors, contains(AgendaBlockValidator.titleRequiredError));
    });

    test('rejects blank (whitespace-only) title', () {
      final result = AgendaBlockValidator.validateFields(
        title: '   ',
        start: start,
        end: end,
      );

      expect(result.isValid, isFalse);
      expect(result.errors, contains(AgendaBlockValidator.titleRequiredError));
    });

    test('rejects null title', () {
      final result = AgendaBlockValidator.validateFields(
        title: null,
        start: start,
        end: end,
      );

      expect(result.errors, contains(AgendaBlockValidator.titleRequiredError));
    });

    test('rejects missing start', () {
      final result = AgendaBlockValidator.validateFields(
        title: 'Bloqueio',
        start: null,
        end: end,
      );

      expect(result.isValid, isFalse);
      expect(result.errors, contains(AgendaBlockValidator.startRequiredError));
    });

    test('rejects missing end', () {
      final result = AgendaBlockValidator.validateFields(
        title: 'Bloqueio',
        start: start,
        end: null,
      );

      expect(result.isValid, isFalse);
      expect(result.errors, contains(AgendaBlockValidator.endRequiredError));
    });

    test('rejects end equal to start', () {
      final result = AgendaBlockValidator.validateFields(
        title: 'Bloqueio',
        start: start,
        end: start,
      );

      expect(result.isValid, isFalse);
      expect(result.errors, contains(AgendaBlockValidator.endAfterStartError));
    });

    test('rejects end before start', () {
      final result = AgendaBlockValidator.validateFields(
        title: 'Bloqueio',
        start: end,
        end: start,
      );

      expect(result.isValid, isFalse);
      expect(result.errors, contains(AgendaBlockValidator.endAfterStartError));
    });

    test('accumulates multiple errors at once', () {
      final result = AgendaBlockValidator.validateFields(
        title: '',
        start: null,
        end: null,
      );

      expect(result.errors, hasLength(3));
    });
  });
}

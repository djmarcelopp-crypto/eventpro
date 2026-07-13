import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/utils/quote_draft_id_generator.dart';

void main() {
  test('gera draftIds únicos com contador monotônico', () {
    final generator = QuoteDraftIdGenerator();

    expect(generator.nextLineDraftId(), 'line_1');
    expect(generator.nextLineDraftId(), 'line_2');
    expect(generator.nextLineDraftId(), 'line_3');
  });
}

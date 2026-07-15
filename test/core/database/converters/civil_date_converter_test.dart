import 'package:eventpro/core/database/converters/civil_date_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CivilDateConverter', () {
    test('serializes birthday using local calendar components only', () {
      final birthday = DateTime(1990, 7, 15, 23, 45);

      expect(CivilDateConverter.toIsoDate(birthday), '1990-07-15');
    });

    test('deserializes birthday without timezone conversion', () {
      final restored = CivilDateConverter.fromIsoDate('1990-07-15');

      expect(restored, DateTime(1990, 7, 15));
      expect(restored?.day, 15);
      expect(restored?.month, 7);
      expect(restored?.year, 1990);
    });

    test('null round-trips as null', () {
      expect(CivilDateConverter.toIsoDate(null), isNull);
      expect(CivilDateConverter.fromIsoDate(null), isNull);
    });
  });
}

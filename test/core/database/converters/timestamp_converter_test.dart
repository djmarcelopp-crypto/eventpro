import 'package:eventpro/core/database/converters/timestamp_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TimestampConverter', () {
    test('round-trips local DateTime through UTC millis', () {
      final original = DateTime(2024, 6, 15, 14, 30, 45);

      final millis = TimestampConverter.toUtcMillis(original);
      final restored = TimestampConverter.fromUtcMillis(millis);

      expect(restored, original);
    });
  });
}

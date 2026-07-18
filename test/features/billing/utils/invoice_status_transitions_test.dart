import 'package:eventpro/features/billing/models/invoice_status.dart';
import 'package:eventpro/features/billing/utils/invoice_status_transitions.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InvoiceStatusTransitions', () {
    test('allows draft→issued→paid and cancel from draft/issued', () {
      expect(
        InvoiceStatusTransitions.canTransition(
          InvoiceStatus.draft,
          InvoiceStatus.issued,
        ),
        isTrue,
      );
      expect(
        InvoiceStatusTransitions.canTransition(
          InvoiceStatus.issued,
          InvoiceStatus.paid,
        ),
        isTrue,
      );
      expect(
        InvoiceStatusTransitions.canTransition(
          InvoiceStatus.draft,
          InvoiceStatus.cancelled,
        ),
        isTrue,
      );
      expect(
        InvoiceStatusTransitions.canTransition(
          InvoiceStatus.issued,
          InvoiceStatus.cancelled,
        ),
        isTrue,
      );
    });

    test('blocks pay draft, pay cancelled, cancel paid, regressions, repeats',
        () {
      expect(
        InvoiceStatusTransitions.canTransition(
          InvoiceStatus.draft,
          InvoiceStatus.paid,
        ),
        isFalse,
      );
      expect(
        InvoiceStatusTransitions.canTransition(
          InvoiceStatus.cancelled,
          InvoiceStatus.paid,
        ),
        isFalse,
      );
      expect(
        InvoiceStatusTransitions.canTransition(
          InvoiceStatus.paid,
          InvoiceStatus.cancelled,
        ),
        isFalse,
      );
      expect(
        InvoiceStatusTransitions.wouldRegress(
          InvoiceStatus.paid,
          InvoiceStatus.issued,
        ),
        isTrue,
      );
      expect(
        InvoiceStatusTransitions.canTransition(
          InvoiceStatus.issued,
          InvoiceStatus.issued,
        ),
        isFalse,
      );
      expect(
        InvoiceStatusTransitions.canTransition(
          InvoiceStatus.paid,
          InvoiceStatus.issued,
        ),
        isFalse,
      );
      expect(
        InvoiceStatusTransitions.canTransition(
          InvoiceStatus.cancelled,
          InvoiceStatus.issued,
        ),
        isFalse,
      );
    });
  });
}

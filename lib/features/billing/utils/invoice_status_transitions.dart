import '../models/invoice_status.dart';

/// Single source of truth for [InvoiceStatus] transitions.
///
/// Used by [InvoiceService] and consulted by [InvoiceWorkflowService].
/// Quote-scoped services and UI must not redefine this matrix.
abstract class InvoiceStatusTransitions {
  /// Happy-path forward edges (cancel is handled separately).
  static const Map<InvoiceStatus, Set<InvoiceStatus>> forwardTransitions = {
    InvoiceStatus.draft: {InvoiceStatus.issued},
    InvoiceStatus.issued: {InvoiceStatus.paid},
    InvoiceStatus.paid: {},
    InvoiceStatus.cancelled: {},
  };

  static const Set<InvoiceStatus> cancellableStatuses = {
    InvoiceStatus.draft,
    InvoiceStatus.issued,
  };

  static bool canTransition(InvoiceStatus from, InvoiceStatus to) {
    if (from == to) return false;
    if (to == InvoiceStatus.cancelled) {
      return cancellableStatuses.contains(from);
    }
    if (from == InvoiceStatus.cancelled || from == InvoiceStatus.paid) {
      return false;
    }
    return forwardTransitions[from]?.contains(to) ?? false;
  }

  static bool wouldRegress(InvoiceStatus from, InvoiceStatus to) {
    const order = <InvoiceStatus, int>{
      InvoiceStatus.draft: 0,
      InvoiceStatus.issued: 1,
      InvoiceStatus.paid: 2,
    };
    final fromOrder = order[from];
    final toOrder = order[to];
    if (fromOrder == null || toOrder == null) return false;
    return toOrder < fromOrder;
  }
}

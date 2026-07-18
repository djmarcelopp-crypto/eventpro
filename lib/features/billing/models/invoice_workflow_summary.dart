import 'invoice.dart';
import 'invoice_status.dart';

/// Read-only view of allowed billing transitions for an [Invoice].
///
/// Pure DTO — no I/O. Built by [InvoiceWorkflowService] from
/// [InvoiceStatusTransitions] (the sole matrix).
class InvoiceWorkflowSummary {
  const InvoiceWorkflowSummary({
    required this.invoice,
    required this.allowedNextStatuses,
    required this.canIssue,
    required this.canMarkPaid,
    required this.canCancel,
    required this.isFinal,
    this.nextStatus,
    this.blockReason,
  });

  final Invoice invoice;
  final Set<InvoiceStatus> allowedNextStatuses;
  final bool canIssue;
  final bool canMarkPaid;
  final bool canCancel;
  final bool isFinal;

  /// Preferred happy-path next status when exactly one forward step exists.
  final InvoiceStatus? nextStatus;

  /// Human-readable reason when primary happy-path actions are blocked.
  final String? blockReason;

  InvoiceStatus get currentStatus => invoice.status;

  bool allows(InvoiceStatus status) => allowedNextStatuses.contains(status);
}

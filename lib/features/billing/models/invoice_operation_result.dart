import 'invoice.dart';

enum InvoiceOperationStatus {
  success,
  validationFailed,
  quoteNotFound,
  duplicateNumber,
  notFound,
  invalidTransition,
  cannotPayCancelled,
  cannotCancelPaid,
  failure,
}

class InvoiceOperationResult {
  const InvoiceOperationResult._({
    required this.status,
    this.invoice,
    this.errors = const [],
  });

  factory InvoiceOperationResult.success(Invoice invoice) {
    return InvoiceOperationResult._(
      status: InvoiceOperationStatus.success,
      invoice: invoice,
    );
  }

  factory InvoiceOperationResult.validationFailed(List<String> errors) {
    return InvoiceOperationResult._(
      status: InvoiceOperationStatus.validationFailed,
      errors: errors,
    );
  }

  factory InvoiceOperationResult.quoteNotFound() {
    return const InvoiceOperationResult._(
      status: InvoiceOperationStatus.quoteNotFound,
    );
  }

  factory InvoiceOperationResult.duplicateNumber() {
    return const InvoiceOperationResult._(
      status: InvoiceOperationStatus.duplicateNumber,
    );
  }

  factory InvoiceOperationResult.notFound() {
    return const InvoiceOperationResult._(
      status: InvoiceOperationStatus.notFound,
    );
  }

  factory InvoiceOperationResult.invalidTransition() {
    return const InvoiceOperationResult._(
      status: InvoiceOperationStatus.invalidTransition,
    );
  }

  factory InvoiceOperationResult.cannotPayCancelled() {
    return const InvoiceOperationResult._(
      status: InvoiceOperationStatus.cannotPayCancelled,
    );
  }

  factory InvoiceOperationResult.cannotCancelPaid() {
    return const InvoiceOperationResult._(
      status: InvoiceOperationStatus.cannotCancelPaid,
    );
  }

  factory InvoiceOperationResult.failure() {
    return const InvoiceOperationResult._(
      status: InvoiceOperationStatus.failure,
    );
  }

  final InvoiceOperationStatus status;
  final Invoice? invoice;
  final List<String> errors;

  bool get isSuccess => status == InvoiceOperationStatus.success;
}

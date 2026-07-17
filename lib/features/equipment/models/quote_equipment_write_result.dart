import 'quote_equipment.dart';

enum QuoteEquipmentWriteStatus {
  success,
  validationFailed,
  quoteNotFound,
  equipmentNotFound,
  notFound,
  failure,
}

class QuoteEquipmentWriteResult {
  const QuoteEquipmentWriteResult._({
    required this.status,
    this.item,
    this.errors = const [],
  });

  factory QuoteEquipmentWriteResult.success(QuoteEquipment item) {
    return QuoteEquipmentWriteResult._(
      status: QuoteEquipmentWriteStatus.success,
      item: item,
    );
  }

  factory QuoteEquipmentWriteResult.validationFailed(List<String> errors) {
    return QuoteEquipmentWriteResult._(
      status: QuoteEquipmentWriteStatus.validationFailed,
      errors: errors,
    );
  }

  factory QuoteEquipmentWriteResult.quoteNotFound() {
    return const QuoteEquipmentWriteResult._(
      status: QuoteEquipmentWriteStatus.quoteNotFound,
    );
  }

  factory QuoteEquipmentWriteResult.equipmentNotFound() {
    return const QuoteEquipmentWriteResult._(
      status: QuoteEquipmentWriteStatus.equipmentNotFound,
    );
  }

  factory QuoteEquipmentWriteResult.notFound() {
    return const QuoteEquipmentWriteResult._(
      status: QuoteEquipmentWriteStatus.notFound,
    );
  }

  factory QuoteEquipmentWriteResult.failure() {
    return const QuoteEquipmentWriteResult._(
      status: QuoteEquipmentWriteStatus.failure,
    );
  }

  final QuoteEquipmentWriteStatus status;
  final QuoteEquipment? item;
  final List<String> errors;

  bool get isSuccess => status == QuoteEquipmentWriteStatus.success;
}

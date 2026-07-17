enum QuoteEquipmentDeleteStatus { deleted, notFound, failure }

class QuoteEquipmentDeleteResult {
  const QuoteEquipmentDeleteResult({required this.status});

  final QuoteEquipmentDeleteStatus status;

  bool get isDeleted => status == QuoteEquipmentDeleteStatus.deleted;
}

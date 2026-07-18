import '../models/invoice_item.dart';
import 'invoice_validation_result.dart';

abstract class InvoiceItemValidator {
  static const invoiceIdRequiredError = 'Informe a fatura do item';
  static const descriptionRequiredError = 'Informe a descrição do item';
  static const quantityInvalidError = 'A quantidade deve ser maior que zero';
  static const unitPriceNegativeError =
      'O preço unitário não pode ser negativo';
  static const totalPriceNegativeError = 'O total do item não pode ser negativo';

  static InvoiceValidationResult validateFields({
    String? invoiceId,
    String? description,
    double? quantity,
    int? unitPriceCents,
    int? totalPriceCents,
  }) {
    final errors = <String>[];

    // Placeholder used by InvoiceService before the invoice id exists.
    if (invoiceId != 'pending' &&
        (invoiceId == null || invoiceId.trim().isEmpty)) {
      errors.add(invoiceIdRequiredError);
    }
    if (description == null || description.trim().isEmpty) {
      errors.add(descriptionRequiredError);
    }
    if (quantity == null || quantity <= 0 || quantity.isNaN || quantity.isInfinite) {
      errors.add(quantityInvalidError);
    }
    if (unitPriceCents != null && unitPriceCents < 0) {
      errors.add(unitPriceNegativeError);
    }
    if (totalPriceCents != null && totalPriceCents < 0) {
      errors.add(totalPriceNegativeError);
    }

    return InvoiceValidationResult(errors: List.unmodifiable(errors));
  }

  static InvoiceValidationResult validate(InvoiceItem item) {
    return validateFields(
      invoiceId: item.invoiceId,
      description: item.description,
      quantity: item.quantity,
      unitPriceCents: item.unitPriceCents,
      totalPriceCents: item.totalPriceCents,
    );
  }
}

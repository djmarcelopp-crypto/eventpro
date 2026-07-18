import '../models/invoice.dart';
import '../models/invoice_status.dart';
import '../models/invoice_type.dart';
import 'invoice_validation_result.dart';

/// Field validation for a **resolved** [Invoice] entity.
///
/// Caller-facing numbering is optional at [InvoiceService.create]: omit/blank
/// triggers auto `INV-YYYY-####`. After resolution, [invoiceNumber] on the
/// persisted entity is always required (non-blank after trim).
abstract class InvoiceValidator {
  static const quoteIdRequiredError = 'Informe o orçamento da fatura';
  static const invoiceNumberRequiredError = 'Informe o número da fatura';
  static const typeRequiredError = 'Informe o tipo da fatura';
  static const statusRequiredError = 'Informe o status da fatura';
  static const subtotalNegativeError = 'O subtotal não pode ser negativo';
  static const taxNegativeError = 'Os impostos não podem ser negativos';
  static const discountNegativeError = 'O desconto não pode ser negativo';
  static const totalNegativeError = 'O total não pode ser negativo';

  static InvoiceValidationResult validateFields({
    String? quoteId,
    String? invoiceNumber,
    InvoiceType? type,
    InvoiceStatus? status,
    int? subtotalCents,
    int? taxCents,
    int? discountCents,
    int? totalCents,
  }) {
    final errors = <String>[];

    if (quoteId == null || quoteId.trim().isEmpty) {
      errors.add(quoteIdRequiredError);
    }
    // Resolved number only — never use this to require caller input.
    if (invoiceNumber == null || invoiceNumber.trim().isEmpty) {
      errors.add(invoiceNumberRequiredError);
    }
    if (type == null) {
      errors.add(typeRequiredError);
    }
    if (status == null) {
      errors.add(statusRequiredError);
    }
    if (subtotalCents != null && subtotalCents < 0) {
      errors.add(subtotalNegativeError);
    }
    if (taxCents != null && taxCents < 0) {
      errors.add(taxNegativeError);
    }
    if (discountCents != null && discountCents < 0) {
      errors.add(discountNegativeError);
    }
    if (totalCents != null && totalCents < 0) {
      errors.add(totalNegativeError);
    }

    return InvoiceValidationResult(errors: List.unmodifiable(errors));
  }

  static InvoiceValidationResult validate(Invoice invoice) {
    return validateFields(
      quoteId: invoice.quoteId,
      invoiceNumber: invoice.invoiceNumber,
      type: invoice.type,
      status: invoice.status,
      subtotalCents: invoice.subtotalCents,
      taxCents: invoice.taxCents,
      discountCents: invoice.discountCents,
      totalCents: invoice.totalCents,
    );
  }
}

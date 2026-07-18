import 'package:flutter/material.dart';

import '../../main.dart';
import 'models/invoice_operation_result.dart';

abstract class BillingFeedback {
  static const invoiceCreated = 'Faturamento criado';
  static const invoiceIssued = 'Faturamento emitido';
  static const invoicePaid = 'Pagamento registrado';
  static const invoiceCancelled = 'Faturamento cancelado';
}

abstract class BillingFeedbackPresenter {
  static void showSnackBar(String message) {
    EventProApp.scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static void showError(String message) {
    EventProApp.scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red.shade700,
      ),
    );
  }

  static String invoiceWriteError(InvoiceOperationResult result) {
    return switch (result.status) {
      InvoiceOperationStatus.validationFailed => result.errors.isEmpty
          ? 'Dados inválidos'
          : result.errors.first,
      InvoiceOperationStatus.quoteNotFound => 'Orçamento não encontrado',
      InvoiceOperationStatus.duplicateNumber => 'Número de fatura já existe',
      InvoiceOperationStatus.notFound => 'Faturamento não encontrado',
      InvoiceOperationStatus.invalidTransition =>
        'Transição de status inválida',
      InvoiceOperationStatus.cannotPayCancelled =>
        'Não é possível pagar faturamento cancelado',
      InvoiceOperationStatus.cannotCancelPaid =>
        'Não é possível cancelar faturamento pago',
      InvoiceOperationStatus.failure => 'Falha ao salvar faturamento',
      InvoiceOperationStatus.success => '',
    };
  }
}

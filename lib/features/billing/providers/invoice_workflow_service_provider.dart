import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/invoice_workflow_service.dart';
import 'invoice_repository_provider.dart';
import 'invoice_service_provider.dart';

final invoiceWorkflowServiceProvider = Provider<InvoiceWorkflowService>((ref) {
  return InvoiceWorkflowService(
    invoiceService: ref.watch(invoiceServiceProvider),
    invoiceRepository: ref.watch(invoiceRepositoryProvider),
  );
});

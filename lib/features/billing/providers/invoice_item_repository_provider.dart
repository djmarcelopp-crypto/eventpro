import 'package:eventpro/core/database/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/drift_invoice_item_repository.dart';
import '../data/repositories/invoice_item_repository.dart';

final invoiceItemRepositoryProvider = Provider<InvoiceItemRepository>((ref) {
  return DriftInvoiceItemRepository(ref.watch(appDatabaseProvider));
});

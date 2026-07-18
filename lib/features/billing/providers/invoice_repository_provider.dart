import 'package:eventpro/core/database/database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/drift_invoice_repository.dart';
import '../data/repositories/invoice_repository.dart';

final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  return DriftInvoiceRepository(ref.watch(appDatabaseProvider));
});

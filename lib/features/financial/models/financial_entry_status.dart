import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Payment state of a [FinancialEntry].
///
/// A [pending] entry has been launched but not yet settled; a [paid] entry
/// has already been received (for a revenue) or paid (for an expense).
enum FinancialEntryStatus {
  pending,
  paid,
}

extension FinancialEntryStatusLabels on FinancialEntryStatus {
  String get label => switch (this) {
        FinancialEntryStatus.pending => 'Pendente',
        FinancialEntryStatus.paid => 'Pago',
      };

  Color get color => switch (this) {
        FinancialEntryStatus.pending => AppColors.warning,
        FinancialEntryStatus.paid => AppColors.success,
      };
}

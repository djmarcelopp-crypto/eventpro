import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Classifies a financial movement (or category) as money coming in
/// ([income]) or money going out ([expense]).
///
/// Shared between [FinancialCategory] and [FinancialEntry] so both concepts
/// use a single source of truth for this classification, avoiding duplicated
/// enums with the same two states.
enum FinancialFlowKind {
  income,
  expense,
}

extension FinancialFlowKindLabels on FinancialFlowKind {
  String get label => switch (this) {
        FinancialFlowKind.income => 'Receita',
        FinancialFlowKind.expense => 'Despesa',
      };

  Color get color => switch (this) {
        FinancialFlowKind.income => AppColors.success,
        FinancialFlowKind.expense => AppColors.error,
      };
}

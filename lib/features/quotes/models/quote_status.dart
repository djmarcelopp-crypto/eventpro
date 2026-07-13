import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

enum QuoteStatus {
  draft,
  sent,
  approved,
  rejected,
  cancelled,
}

extension QuoteStatusLabels on QuoteStatus {
  String get label => switch (this) {
        QuoteStatus.draft => 'Rascunho',
        QuoteStatus.sent => 'Enviado',
        QuoteStatus.approved => 'Aprovado',
        QuoteStatus.rejected => 'Recusado',
        QuoteStatus.cancelled => 'Cancelado',
      };

  Color get color => switch (this) {
        QuoteStatus.draft => AppColors.secondaryText,
        QuoteStatus.sent => AppColors.primary,
        QuoteStatus.approved => AppColors.success,
        QuoteStatus.rejected => AppColors.error,
        QuoteStatus.cancelled => AppColors.warning,
      };
}

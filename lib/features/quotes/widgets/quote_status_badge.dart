import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../models/quote_status.dart';

class QuoteStatusBadge extends StatelessWidget {
  const QuoteStatusBadge({
    super.key,
    required this.status,
  });

  final QuoteStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: status.color.withValues(alpha: 0.4)),
      ),
      child: Text(
        status.label,
        style: AppTextStyles.caption.copyWith(
          color: status.color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

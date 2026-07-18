import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';

class QuoteInvoiceSection extends StatelessWidget {
  const QuoteInvoiceSection({super.key, required this.quoteId});

  final String quoteId;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      key: const Key('quote_invoice_section'),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Faturamento', style: AppTextStyles.titleMedium),
                const SizedBox(height: 4),
                Text(
                  'Gere, emita, registre pagamento e cancele faturamentos.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            key: const Key('quote_invoice_open_button'),
            onPressed: () => context.push(AppRoutes.quotesInvoices(quoteId)),
            child: const Text('Gerenciar'),
          ),
        ],
      ),
    );
  }
}

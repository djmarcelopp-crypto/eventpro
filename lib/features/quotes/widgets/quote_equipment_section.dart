import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';

/// Entry point from quote detail to associate inventory equipment.
/// Does not compute availability or reserve stock.
class QuoteEquipmentSection extends StatelessWidget {
  const QuoteEquipmentSection({super.key, required this.quoteId});

  final String quoteId;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      key: const Key('quote_equipment_section'),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Equipamentos do evento',
                  style: AppTextStyles.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Associe itens do inventário a este orçamento '
                  '(sem reserva automática).',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.white.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            key: const Key('quote_equipment_open_button'),
            onPressed: () =>
                context.push(AppRoutes.quotesEquipment(quoteId)),
            child: const Text('Gerenciar'),
          ),
        ],
      ),
    );
  }
}

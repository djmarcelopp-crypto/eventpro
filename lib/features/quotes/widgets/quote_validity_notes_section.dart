import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_field.dart';

class QuoteValidityNotesSection extends StatelessWidget {
  const QuoteValidityNotesSection({
    super.key,
    required this.validUntilController,
    required this.validUntilError,
    required this.notesController,
    required this.internalNotesController,
    required this.onPickValidUntil,
    required this.onClearValidUntil,
  });

  final TextEditingController validUntilController;
  final String? validUntilError;
  final TextEditingController notesController;
  final TextEditingController internalNotesController;
  final VoidCallback onPickValidUntil;
  final VoidCallback onClearValidUntil;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      key: const Key('quote_validity_notes_section'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Validade e observações',
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: 16),
          AppTextField(
            key: const Key('quote_valid_until_field'),
            label: 'Validade do orçamento',
            controller: validUntilController,
            readOnly: true,
            onTap: onPickValidUntil,
            suffixIcon: validUntilController.text.isEmpty
                ? const Icon(Icons.calendar_today_outlined, size: 20)
                : IconButton(
                    icon: const Icon(Icons.close, size: 18),
                    onPressed: onClearValidUntil,
                  ),
          ),
          if (validUntilError != null) ...[
            const SizedBox(height: 4),
            Text(
              validUntilError!,
              style: AppTextStyles.caption.copyWith(color: AppColors.error),
            ),
          ],
          const SizedBox(height: 16),
          AppTextField(
            key: const Key('quote_notes_field'),
            label: 'Observações para o cliente',
            controller: notesController,
            maxLines: 3,
            hint: 'Poderão aparecer no PDF futuro',
          ),
          const SizedBox(height: 16),
          AppTextField(
            key: const Key('quote_internal_notes_field'),
            label: 'Observações internas',
            controller: internalNotesController,
            maxLines: 3,
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.lock_outline,
                size: 16,
                color: AppColors.warning,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Esta informação não aparece no PDF, contrato ou materiais '
                  'compartilhados com o cliente.',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.warning,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

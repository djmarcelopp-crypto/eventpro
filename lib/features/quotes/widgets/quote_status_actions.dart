import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';
import '../models/quote.dart';
import '../models/quote_status.dart';

class QuoteStatusActions extends StatelessWidget {
  const QuoteStatusActions({
    super.key,
    required this.quote,
    required this.transitioning,
    this.onEdit,
    this.onMarkAsSent,
    this.onApprove,
    this.onReject,
    this.onCancel,
    this.onReopenForEditing,
  });

  final Quote quote;
  final bool transitioning;
  final VoidCallback? onEdit;
  final VoidCallback? onMarkAsSent;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;
  final VoidCallback? onCancel;
  final VoidCallback? onReopenForEditing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...switch (quote.status) {
          QuoteStatus.draft => [
              if (onEdit != null)
                PrimaryButton(
                  key: const Key('quote_detail_edit_button'),
                  label: 'Editar',
                  onPressed: transitioning ? null : onEdit,
                ),
              if (onEdit != null) const SizedBox(height: 12),
              if (onMarkAsSent != null)
                OutlinedButton(
                  key: const Key('quote_detail_mark_sent_button'),
                  onPressed: transitioning ? null : onMarkAsSent,
                  child: const Text('Marcar como enviado'),
                ),
              if (onMarkAsSent != null) const SizedBox(height: 12),
              if (onCancel != null)
                _CancelButton(
                  transitioning: transitioning,
                  onPressed: onCancel!,
                ),
            ],
          QuoteStatus.sent => [
              if (onApprove != null)
                PrimaryButton(
                  key: const Key('quote_detail_approve_button'),
                  label: 'Aprovar',
                  onPressed: transitioning ? null : onApprove,
                ),
              if (onApprove != null) const SizedBox(height: 12),
              if (onReject != null)
                OutlinedButton(
                  key: const Key('quote_detail_reject_button'),
                  onPressed: transitioning ? null : onReject,
                  child: const Text('Recusar'),
                ),
              if (onReject != null) const SizedBox(height: 12),
              if (onCancel != null)
                _CancelButton(
                  transitioning: transitioning,
                  onPressed: onCancel!,
                ),
            ],
          QuoteStatus.approved => [
              Text(
                'Pronto para gerar contrato',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: 12),
              PrimaryButton(
                key: const Key('quote_detail_generate_contract_button'),
                label: 'Gerar contrato (Em breve)',
                onPressed: null,
              ),
              const SizedBox(height: 12),
              if (onReopenForEditing != null)
                OutlinedButton(
                  key: const Key('quote_detail_reopen_button'),
                  onPressed: transitioning ? null : onReopenForEditing,
                  child: const Text('Reabrir para edição'),
                ),
              if (onReopenForEditing != null) const SizedBox(height: 12),
              if (onCancel != null)
                _CancelButton(
                  transitioning: transitioning,
                  onPressed: onCancel!,
                ),
            ],
          QuoteStatus.rejected => const [],
          QuoteStatus.cancelled => const [],
        },
      ],
    );
  }
}

class _CancelButton extends StatelessWidget {
  const _CancelButton({
    required this.transitioning,
    required this.onPressed,
  });

  final bool transitioning;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      key: const Key('quote_detail_cancel_button'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.warning,
      ),
      onPressed: transitioning ? null : onPressed,
      child: const Text('Cancelar orçamento'),
    );
  }
}

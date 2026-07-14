import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';
import '../models/quote.dart';
import '../pdf/models/quote_pdf_export_result.dart';
import '../pdf/providers/quote_pdf_detail_actions_controller.dart';
import '../pdf/services/quote_pdf_export_service.dart';
import '../pdf/utils/quote_pdf_eligibility.dart';
import '../pdf/utils/quote_pdf_feedback.dart';
import 'quote_detail_section.dart';

class QuotePdfActionsSection extends ConsumerWidget {
  const QuotePdfActionsSection({
    super.key,
    required this.quote,
  });

  final Quote quote;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final eligibility = QuotePdfEligibility.evaluate(quote);
    final blocked = eligibility is QuotePdfEligibilityBlocked;
    final actionsState =
        ref.watch(quotePdfDetailActionsControllerProvider(quote.id));
    final busy = actionsState.busy;
    final exportLabel =
        Platform.isAndroid || Platform.isIOS ? 'Compartilhar PDF' : 'Salvar PDF';

    return QuoteDetailSection(
      key: const Key('quote_detail_pdf_section'),
      title: 'Documento PDF',
      items: const [],
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          PrimaryButton(
            key: const Key('quote_detail_pdf_view_button'),
            label: 'Visualizar PDF',
            isLoading: false,
            onPressed: blocked || busy
                ? null
                : () => context.push(AppRoutes.quotesPdf(quote.id)),
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            key: const Key('quote_detail_pdf_export_button'),
            onPressed: blocked || busy ? null : () => _handleExport(context, ref),
            child: busy
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(exportLabel),
          ),
          if (blocked) ...[
            const SizedBox(height: 12),
            Text(
              QuotePdfEligibility.missingCompanySnapshotMessage,
              key: const Key('quote_detail_pdf_blocked_notice'),
              style: AppTextStyles.caption.copyWith(
                color: AppColors.secondaryText,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _handleExport(BuildContext context, WidgetRef ref) async {
    final result = await ref
        .read(quotePdfDetailActionsControllerProvider(quote.id).notifier)
        .exportDirect();

    if (!context.mounted) {
      return;
    }

    switch (result) {
      case QuotePdfExportSuccess():
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            key: const Key('quote_detail_pdf_export_success_snackbar'),
            content: Text(QuotePdfFeedback.exportSuccessMessage()),
          ),
        );
      case QuotePdfExportFailed():
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            key: const Key('quote_detail_pdf_export_error_snackbar'),
            content: Text(PlatformQuotePdfExportService.genericErrorMessage),
          ),
        );
      case QuotePdfExportCancelled():
        break;
    }
  }
}

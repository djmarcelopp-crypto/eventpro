import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:printing/printing.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';
import '../utils/quotes_navigation.dart';
import '../widgets/quote_not_found_state.dart';
import 'models/quote_pdf_export_result.dart';
import 'models/quote_pdf_preview_state.dart';
import 'providers/quote_pdf_preview_controller.dart';
import 'services/quote_pdf_export_service.dart';

class QuotePdfPreviewScreen extends ConsumerWidget {
  const QuotePdfPreviewScreen({
    super.key,
    required this.quoteId,
  });

  final String quoteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(quotePdfPreviewControllerProvider(quoteId));

    return Scaffold(
      key: const Key('quote_pdf_preview_screen'),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Voltar',
          onPressed: () => QuotesNavigation.leaveQuotePdf(context),
        ),
        title: Text(
          _appBarTitle(state),
          style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: _buildBody(context, ref, state),
      bottomNavigationBar: _buildExportBar(context, ref, state),
    );
  }

  String _appBarTitle(QuotePdfPreviewState state) {
    if (state is QuotePdfPreviewReady) {
      return state.quoteNumber;
    }

    return 'PDF do orçamento';
  }

  Widget? _buildExportBar(
    BuildContext context,
    WidgetRef ref,
    QuotePdfPreviewState state,
  ) {
    if (state is! QuotePdfPreviewReady) {
      return null;
    }

    final exportLabel =
        Platform.isAndroid || Platform.isIOS ? 'Compartilhar' : 'Salvar como';

    return Container(
      key: const Key('quote_pdf_export_bar'),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: PrimaryButton(
            key: const Key('quote_pdf_export_button'),
            label: exportLabel,
            isLoading: state.isExporting,
            onPressed:
                state.isExporting ? null : () => _handleExport(context, ref),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    QuotePdfPreviewState state,
  ) {
    return switch (state) {
      QuotePdfPreviewLoading() => const Center(
          key: Key('quote_pdf_preview_loading'),
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      QuotePdfPreviewNotFound() => QuoteNotFoundState(
          key: const Key('quote_pdf_preview_not_found'),
          onBack: () => QuotesNavigation.leaveQuotePdf(context),
        ),
      QuotePdfPreviewBlocked(:final message) => _BlockedState(
          key: const Key('quote_pdf_preview_blocked'),
          message: message,
          onBack: () => QuotesNavigation.leaveQuotePdf(context),
        ),
      QuotePdfPreviewError() => _ErrorState(
          key: const Key('quote_pdf_preview_error'),
          onBack: () => QuotesNavigation.leaveQuotePdf(context),
        ),
      QuotePdfPreviewReady(:final bytes, :final filename) => PdfPreview(
          key: const Key('quote_pdf_preview'),
          build: (_) async => bytes,
          pdfFileName: filename,
          allowPrinting: false,
          allowSharing: false,
          useActions: false,
          canChangePageFormat: false,
          canChangeOrientation: false,
          canDebug: false,
          scrollViewDecoration: const BoxDecoration(
            color: AppColors.background,
          ),
          pdfPreviewPageDecoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.45),
              width: 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x66000000),
                blurRadius: 14,
                offset: Offset(0, 6),
              ),
            ],
          ),
          previewPageMargin: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 20,
          ),
        ),
    };
  }

  Future<void> _handleExport(BuildContext context, WidgetRef ref) async {
    final result = await ref
        .read(quotePdfPreviewControllerProvider(quoteId).notifier)
        .exportPdf();

    if (!context.mounted) {
      return;
    }

    if (result is QuotePdfExportFailed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          key: Key('quote_pdf_export_error_snackbar'),
          content: Text(PlatformQuotePdfExportService.genericErrorMessage),
        ),
      );
    }
  }
}

class _BlockedState extends StatelessWidget {
  const _BlockedState({
    super.key,
    required this.message,
    required this.onBack,
  });

  final String message;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: AppTextStyles.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              key: const Key('quote_pdf_blocked_back_button'),
              label: 'Voltar',
              onPressed: onBack,
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    super.key,
    required this.onBack,
  });

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Não foi possível gerar o PDF deste orçamento.',
              style: AppTextStyles.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              key: const Key('quote_pdf_error_back_button'),
              label: 'Voltar',
              onPressed: onBack,
            ),
          ],
        ),
      ),
    );
  }
}

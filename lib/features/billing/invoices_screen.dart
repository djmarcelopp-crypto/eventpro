import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_page_header.dart';
import '../../core/widgets/feedback/app_empty_state.dart';
import '../../core/widgets/feedback/app_error_state.dart';
import '../../core/widgets/feedback/app_loading_state.dart';
import '../quotes/utils/quote_money_display.dart';
import 'models/invoice_list_summary.dart';
import 'models/invoice_status.dart';
import 'models/invoice_type.dart';
import 'providers/filtered_invoices_provider.dart';
import 'providers/invoice_filters_provider.dart';
import 'providers/invoice_list_summary_provider.dart';
import 'widgets/invoice_filters_bar.dart';
import 'widgets/invoice_summary_cards.dart';

class InvoicesScreen extends ConsumerWidget {
  const InvoicesScreen({super.key});

  static const _maxContentWidth = 960.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(filteredInvoicesProvider);
    final summaryAsync = ref.watch(invoiceListSummaryProvider);
    final filters = ref.watch(invoiceFiltersProvider);

    return Scaffold(
      appBar: AppPageHeader(
        title: 'Faturamento',
        actions: [
          IconButton(
            key: const Key('invoice_create_button'),
            icon: const Icon(Icons.add),
            tooltip: 'Novo faturamento',
            onPressed: () => context.push(AppRoutes.invoicesNew),
          ),
        ],
      ),
      body: itemsAsync.when(
        data: (items) {
          final summary = summaryAsync.value ?? InvoiceListSummary.empty;
          return CustomScrollView(
            key: const Key('invoices_scroll'),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                sliver: SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: _maxContentWidth,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          InvoiceSummaryCards(summary: summary),
                          const SizedBox(height: 16),
                          InvoiceFiltersBar(
                            filters: filters,
                            onStatusChanged: (status) => ref
                                .read(invoiceFiltersProvider.notifier)
                                .setStatus(status),
                            onTypeChanged: (type) => ref
                                .read(invoiceFiltersProvider.notifier)
                                .setType(type),
                            onNumberQueryChanged: (query) => ref
                                .read(invoiceFiltersProvider.notifier)
                                .setNumberQuery(query),
                            onClear: () => ref
                                .read(invoiceFiltersProvider.notifier)
                                .clear(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (items.isEmpty)
                SliverToBoxAdapter(
                  child: AppEmptyState(
                    icon: Icons.receipt_long_outlined,
                    title: 'Nenhum faturamento encontrado',
                    message:
                        'Crie um faturamento ou ajuste os filtros para visualizar resultados.',
                    primaryActionLabel: 'Novo faturamento',
                    onPrimaryAction: () => context.push(AppRoutes.invoicesNew),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                  sliver: SliverList.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final invoice = items[index];
                      return Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: _maxContentWidth,
                          ),
                          child: AppCard(
                            padding: const EdgeInsets.all(16),
                            child: InkWell(
                              key: Key('invoice_list_item_${invoice.id}'),
                              onTap: () => context.push(
                                AppRoutes.invoiceDetail(invoice.id),
                              ),
                              borderRadius: BorderRadius.circular(16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          invoice.invoiceNumber,
                                          style: AppTextStyles.titleMedium,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${invoice.status.label} · '
                                          '${invoice.type.label} · '
                                          'Orçamento ${invoice.quoteId}',
                                          style: AppTextStyles.caption.copyWith(
                                            color: AppColors.white
                                                .withValues(alpha: 0.7),
                                          ),
                                        ),
                                        Text(
                                          QuoteMoneyDisplay.format(
                                            invoice.totalCents,
                                          ),
                                          style: AppTextStyles.caption,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    color: AppColors.primary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          );
        },
        loading: () => const AppLoadingState(),
        error: (error, _) => AppErrorState(message: '$error'),
      ),
    );
  }
}

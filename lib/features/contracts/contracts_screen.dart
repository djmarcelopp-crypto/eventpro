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
import '../quotes/utils/quote_date_formatter.dart';
import 'models/contract_list_summary.dart';
import 'models/contract_status.dart';
import 'providers/contract_filters_provider.dart';
import 'providers/contract_list_summary_provider.dart';
import 'providers/filtered_contracts_provider.dart';
import 'widgets/contract_filters_bar.dart';
import 'widgets/contract_summary_cards.dart';

class ContractsScreen extends ConsumerWidget {
  const ContractsScreen({super.key});

  static const _maxContentWidth = 960.0;

  String _formatDate(DateTime? value) {
    if (value == null) return '—';
    return QuoteDateFormatter.format(value);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(filteredContractsProvider);
    final summaryAsync = ref.watch(contractListSummaryProvider);
    final filters = ref.watch(contractFiltersProvider);

    return Scaffold(
      appBar: AppPageHeader(
        title: 'Contratos & Assinaturas',
        actions: [
          IconButton(
            key: const Key('contract_templates_button'),
            icon: const Icon(Icons.description_outlined),
            tooltip: 'Modelos de contrato',
            onPressed: () => context.push(AppRoutes.contractTemplates),
          ),
        ],
      ),
      body: itemsAsync.when(
        data: (items) {
          final summary = summaryAsync.value ?? ContractListSummary.empty;
          return CustomScrollView(
            key: const Key('contracts_scroll'),
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
                          ContractSummaryCards(summary: summary),
                          const SizedBox(height: 16),
                          ContractFiltersBar(
                            filters: filters,
                            onStatusChanged: (status) => ref
                                .read(contractFiltersProvider.notifier)
                                .setStatus(status),
                            onNumberQueryChanged: (query) => ref
                                .read(contractFiltersProvider.notifier)
                                .setNumberQuery(query),
                            onClear: () => ref
                                .read(contractFiltersProvider.notifier)
                                .clear(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (items.isEmpty)
                const SliverToBoxAdapter(
                  child: AppEmptyState(
                    icon: Icons.description_outlined,
                    title: 'Nenhum contrato encontrado',
                    message:
                        'Gere contratos a partir de orçamentos aprovados para acompanhar o fluxo de assinatura.',
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                  sliver: SliverList.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final contract = items[index];
                      return Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: _maxContentWidth,
                          ),
                          child: AppCard(
                            padding: const EdgeInsets.all(16),
                            child: InkWell(
                              key: Key('contract_list_item_${contract.id}'),
                              onTap: () => context.push(
                                AppRoutes.contractDetail(contract.id),
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
                                          contract.contractNumber,
                                          style: AppTextStyles.titleMedium,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${contract.status.label} · '
                                          'Orçamento ${contract.quoteId}',
                                          style: AppTextStyles.caption.copyWith(
                                            color: AppColors.white
                                                .withValues(alpha: 0.7),
                                          ),
                                        ),
                                        Text(
                                          'Gerado: ${_formatDate(contract.generatedAt)} · '
                                          'Assinado: ${_formatDate(contract.signedAt)}',
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../quotes/providers/quotes_provider.dart';
import 'financial_feedback.dart';
import 'models/financial_global_summary.dart';
import 'providers/financial_categories_provider.dart';
import 'providers/financial_entries_provider.dart';
import 'providers/financial_entry_filters_provider.dart';
import 'providers/financial_filtered_entries_provider.dart';
import 'providers/financial_global_summary_provider.dart';
import 'widgets/financial_empty_state.dart';
import 'widgets/financial_entry_list_item.dart';
import 'widgets/financial_filters_bar.dart';
import 'widgets/financial_summary_cards.dart';

class FinancialScreen extends ConsumerWidget {
  const FinancialScreen({super.key});

  static const _maxContentWidth = 960.0;

  Future<void> _openNewEntry(BuildContext context) async {
    final created = await context.push<bool>(AppRoutes.financialNew);
    if (created == true && context.mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        FinancialFeedbackPresenter.showSnackBar(FinancialFeedback.entryCreated);
      });
    }
  }

  Future<void> _pickDate({
    required BuildContext context,
    required WidgetRef ref,
    required bool isStart,
  }) async {
    final filters = ref.read(financialEntryFiltersProvider);
    final initial = isStart
        ? (filters.periodStart ?? DateTime.now())
        : (filters.periodEnd ?? DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked == null) {
      return;
    }
    final notifier = ref.read(financialEntryFiltersProvider.notifier);
    if (isStart) {
      notifier.setPeriod(start: picked, end: filters.periodEnd);
    } else {
      notifier.setPeriod(start: filters.periodStart, end: picked);
    }
  }

  String? _categoryName(WidgetRef ref, String categoryId) {
    return ref.read(financialCategoriesProvider).value
        ?.where((category) => category.id == categoryId)
        .map((category) => category.name)
        .firstOrNull;
  }

  String? _quoteLabel(WidgetRef ref, String? quoteId) {
    if (quoteId == null) {
      return null;
    }
    final quote = ref.read(quotesProvider.notifier).findById(quoteId);
    if (quote == null) {
      return null;
    }
    final eventName = quote.eventSnapshot.name?.trim();
    if (eventName != null && eventName.isNotEmpty) {
      return '${quote.number} · $eventName';
    }
    return quote.number;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(financialFilteredEntriesProvider);
    final summaryAsync = ref.watch(financialGlobalSummaryProvider);
    final filters = ref.watch(financialEntryFiltersProvider);
    // Keep categories warm for list labels.
    ref.watch(financialCategoriesProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Voltar',
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Financeiro',
          style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            key: const Key('financial_categories_button'),
            icon: const Icon(Icons.category_outlined),
            tooltip: 'Categorias',
            onPressed: () => context.push(AppRoutes.financialCategories),
          ),
          IconButton(
            key: const Key('financial_new_entry_button'),
            icon: const Icon(Icons.add),
            tooltip: 'Novo lançamento',
            onPressed: () => _openNewEntry(context),
          ),
        ],
      ),
      body: entriesAsync.when(
        data: (entries) {
          final summary =
              summaryAsync.value ?? FinancialGlobalSummary.empty;
          return CustomScrollView(
            key: const Key('financial_scroll'),
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
                          FinancialSummaryCards(summary: summary),
                          const SizedBox(height: 16),
                          FinancialFiltersBar(
                            filters: filters,
                            onKindChanged: (kind) => ref
                                .read(financialEntryFiltersProvider.notifier)
                                .setKind(kind),
                            onStatusChanged: (status) => ref
                                .read(financialEntryFiltersProvider.notifier)
                                .setStatus(status),
                            onPeriodStartTap: () => _pickDate(
                              context: context,
                              ref: ref,
                              isStart: true,
                            ),
                            onPeriodEndTap: () => _pickDate(
                              context: context,
                              ref: ref,
                              isStart: false,
                            ),
                            onClear: () => ref
                                .read(financialEntryFiltersProvider.notifier)
                                .clear(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (entries.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: FinancialEmptyState(
                    onNewEntry: () => _openNewEntry(context),
                    hasActiveFilters: filters.hasActiveFilters,
                    onClearFilters: () => ref
                        .read(financialEntryFiltersProvider.notifier)
                        .clear(),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverList.separated(
                    key: const Key('financial_entry_list'),
                    itemCount: entries.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      return Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: _maxContentWidth,
                          ),
                          child: FinancialEntryListItem(
                            key: Key('financial_entry_item_${entry.id}'),
                            entry: entry,
                            categoryName: _categoryName(
                              ref,
                              entry.categoryId,
                            ),
                            quoteLabel: _quoteLabel(ref, entry.quoteId),
                            onTap: () => context.push(
                              AppRoutes.financialDetail(entry.id),
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
        loading: () => const Center(
          key: Key('financial_loading_indicator'),
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Não foi possível carregar o financeiro.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyLarge,
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  key: const Key('financial_retry_button'),
                  onPressed: () =>
                      ref.read(financialEntriesProvider.notifier).reload(),
                  child: const Text('Tentar novamente'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

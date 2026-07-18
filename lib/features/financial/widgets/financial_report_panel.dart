import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/financial_flow_kind.dart';
import '../models/financial_period_report.dart';
import '../models/financial_report_period.dart';
import '../providers/financial_period_report_provider.dart';
import '../providers/financial_report_query_provider.dart';
import '../utils/financial_display_formatter.dart';

class FinancialReportPanel extends ConsumerWidget {
  const FinancialReportPanel({super.key});

  static const _monthLabels = [
    'Jan',
    'Fev',
    'Mar',
    'Abr',
    'Mai',
    'Jun',
    'Jul',
    'Ago',
    'Set',
    'Out',
    'Nov',
    'Dez',
  ];

  Future<void> _pickCustomPeriod(BuildContext context, WidgetRef ref) async {
    final query = ref.read(financialReportQueryProvider);
    final now = DateTime.now();
    final start = await showDatePicker(
      context: context,
      initialDate: query.customStart ?? DateTime(now.year, now.month, 1),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Início do período',
    );
    if (start == null || !context.mounted) {
      return;
    }
    final end = await showDatePicker(
      context: context,
      initialDate: query.customEnd ?? start,
      firstDate: start,
      lastDate: DateTime(2100),
      helpText: 'Fim do período',
    );
    if (end == null) {
      return;
    }
    ref
        .read(financialReportQueryProvider.notifier)
        .setCustomPeriod(start: start, end: end);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(financialReportQueryProvider);
    final reportAsync = ref.watch(financialPeriodReportProvider);

    return AppCard(
      key: const Key('financial_report_panel'),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Relatórios', style: AppTextStyles.titleMedium),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ChoiceChip(
                key: const Key('financial_report_preset_month'),
                label: const Text('Mês atual'),
                selected: query.kind == FinancialReportPeriodKind.currentMonth,
                onSelected: (_) => ref
                    .read(financialReportQueryProvider.notifier)
                    .selectPreset(FinancialReportPeriodKind.currentMonth),
              ),
              ChoiceChip(
                key: const Key('financial_report_preset_year'),
                label: const Text('Ano atual'),
                selected: query.kind == FinancialReportPeriodKind.currentYear,
                onSelected: (_) => ref
                    .read(financialReportQueryProvider.notifier)
                    .selectPreset(FinancialReportPeriodKind.currentYear),
              ),
              ChoiceChip(
                key: const Key('financial_report_preset_custom'),
                label: Text(
                  query.kind == FinancialReportPeriodKind.custom &&
                          query.customStart != null &&
                          query.customEnd != null
                      ? '${FinancialDisplayFormatter.civilDate(query.customStart!)}'
                            ' – ${FinancialDisplayFormatter.civilDate(query.customEnd!)}'
                      : 'Personalizado',
                ),
                selected: query.kind == FinancialReportPeriodKind.custom,
                onSelected: (_) => _pickCustomPeriod(context, ref),
              ),
            ],
          ),
          const SizedBox(height: 16),
          reportAsync.when(
            data: (report) => _ReportBody(report: report, monthLabels: _monthLabels),
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                key: Key('financial_report_loading'),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (_, _) => Text(
              'Não foi possível montar o relatório.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportBody extends StatelessWidget {
  const _ReportBody({required this.report, required this.monthLabels});

  final FinancialPeriodReport report;
  final List<String> monthLabels;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          key: const Key('financial_report_period_label'),
          'Período: ${FinancialDisplayFormatter.civilDate(report.period.start)}'
          ' – ${FinancialDisplayFormatter.civilDate(report.period.end)}',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mutedWhite),
        ),
        const SizedBox(height: 12),
        _IndicatorRow(
          key: const Key('financial_report_income'),
          label: 'Receitas',
          value: FinancialDisplayFormatter.money(report.totalIncomeCents),
          color: AppColors.success,
        ),
        _IndicatorRow(
          key: const Key('financial_report_expense'),
          label: 'Despesas',
          value: FinancialDisplayFormatter.money(report.totalExpenseCents),
          color: AppColors.error,
        ),
        _IndicatorRow(
          key: const Key('financial_report_balance'),
          label: 'Saldo',
          value: FinancialDisplayFormatter.money(report.balanceCents),
          color: report.balanceCents >= 0 ? AppColors.success : AppColors.error,
        ),
        _IndicatorRow(
          key: const Key('financial_report_entry_count'),
          label: 'Lançamentos',
          value: '${report.entryCount}',
        ),
        _IndicatorRow(
          key: const Key('financial_report_pending_count'),
          label: 'Pendentes',
          value: '${report.pendingEntryCount}',
          color: AppColors.warning,
        ),
        const SizedBox(height: 16),
        Text('Por categoria', style: AppTextStyles.titleMedium.copyWith(fontSize: 16)),
        const SizedBox(height: 8),
        if (report.categoryTotals.isEmpty)
          Text(
            'Nenhuma categoria no período.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.mutedWhite,
            ),
          )
        else
          ...report.categoryTotals.map(
            (total) => Padding(
              key: Key('financial_report_category_${total.categoryId}'),
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${total.categoryName} (${total.kind.label})',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                  Text(
                    '${total.entryCount} · '
                    '${FinancialDisplayFormatter.money(total.totalCents)}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: total.kind.color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        const SizedBox(height: 16),
        Text(
          'Evolução mensal',
          style: AppTextStyles.titleMedium.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 8),
        if (report.monthlyEvolution.isEmpty)
          Text(
            'Sem meses no período.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.mutedWhite,
            ),
          )
        else
          SingleChildScrollView(
            key: const Key('financial_report_monthly_table'),
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowHeight: 36,
              dataRowMinHeight: 36,
              dataRowMaxHeight: 40,
              columns: const [
                DataColumn(label: Text('Mês')),
                DataColumn(label: Text('Receitas'), numeric: true),
                DataColumn(label: Text('Despesas'), numeric: true),
                DataColumn(label: Text('Saldo'), numeric: true),
              ],
              rows: [
                for (final point in report.monthlyEvolution)
                  DataRow(
                    cells: [
                      DataCell(
                        Text(
                          '${monthLabels[point.month - 1]}/${point.year}',
                        ),
                      ),
                      DataCell(
                        Text(
                          FinancialDisplayFormatter.money(point.incomeCents),
                        ),
                      ),
                      DataCell(
                        Text(
                          FinancialDisplayFormatter.money(point.expenseCents),
                        ),
                      ),
                      DataCell(
                        Text(
                          FinancialDisplayFormatter.money(point.balanceCents),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _IndicatorRow extends StatelessWidget {
  const _IndicatorRow({
    super.key,
    required this.label,
    required this.value,
    this.color,
  });

  final String label;
  final String value;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.mutedWhite,
              ),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyLarge.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}

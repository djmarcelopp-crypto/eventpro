import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/feedback/app_dialogs.dart';
import '../../../core/widgets/feedback/app_snackbar.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/secondary_button.dart';
import '../../demo/providers/demo_environment_provider.dart';

/// Settings section for seeding / clearing the isolated demo environment.
class DemoEnvironmentCard extends ConsumerWidget {
  const DemoEnvironmentCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(demoEnvironmentProvider);

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: asyncState.when(
          // Avoid indeterminate progress animations here so widget tests that
          // call pumpAndSettle remain stable while the status resolves.
          loading: () => Text(
            'Carregando status do ambiente demo…',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.mutedWhite,
            ),
          ),
          error: (error, _) => Text(
            'Não foi possível carregar o ambiente demo.\n$error',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
          ),
          data: (state) => _DemoEnvironmentBody(state: state),
        ),
      ),
    );
  }
}

class _DemoEnvironmentBody extends ConsumerWidget {
  const _DemoEnvironmentBody({required this.state});

  final DemoEnvironmentState state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateLabel = state.seededAt == null
        ? null
        : _formatSeededAt(state.seededAt!.toLocal());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Ambiente demonstrativo', style: AppTextStyles.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Carrega uma empresa operacional completa para demonstração comercial. '
          'Os IDs demo ficam isolados em arquivo próprio — sem alterar o schema.',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.mutedWhite),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          state.isSeeded
              ? 'Status: dados demo ativos'
              : 'Status: nenhum dado demo carregado',
          style: AppTextStyles.bodyLarge,
        ),
        if (dateLabel != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Última carga: $dateLabel',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.mutedWhite,
            ),
          ),
        ],
        if (state.lastError != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            state.lastError!,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
          ),
        ],
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(
          key: const Key('demo_seed_button'),
          label: state.isSeeded ? 'Recriar dados demo' : 'Carregar dados demo',
          isLoading: state.isBusy,
          onPressed: state.isBusy
              ? null
              : () async {
                  final confirmed = await AppDialogs.confirm(
                    context,
                    title: state.isSeeded
                        ? 'Recriar ambiente demo'
                        : 'Carregar ambiente demo',
                    message: state.isSeeded
                        ? 'Os dados demo atuais serão limpos e recriados. Continuar?'
                        : 'Serão criados clientes, orçamentos, contratos, '
                            'faturamentos e recursos operacionais de exemplo. Continuar?',
                    confirmLabel: 'Continuar',
                  );
                  if (!confirmed) return;
                  final ok = await ref
                      .read(demoEnvironmentProvider.notifier)
                      .seedDemoData();
                  if (ok) {
                    AppSnackbar.success('Ambiente demo carregado.');
                  } else {
                    AppSnackbar.error('Falha ao carregar o ambiente demo.');
                  }
                },
        ),
        const SizedBox(height: AppSpacing.sm),
        SecondaryButton(
          key: const Key('demo_clear_button'),
          label: 'Limpar dados demo',
          onPressed: (!state.isSeeded || state.isBusy)
              ? null
              : () async {
                  final confirmed = await AppDialogs.confirmDelete(
                    context,
                    entityLabel: 'dados demo',
                  );
                  if (!confirmed) return;
                  final ok = await ref
                      .read(demoEnvironmentProvider.notifier)
                      .clearDemoData();
                  if (ok) {
                    AppSnackbar.success('Dados demo removidos.');
                  } else {
                    AppSnackbar.error('Falha ao limpar os dados demo.');
                  }
                },
        ),
      ],
    );
  }

  static String _formatSeededAt(DateTime value) {
    final dd = value.day.toString().padLeft(2, '0');
    final mm = value.month.toString().padLeft(2, '0');
    final yyyy = value.year.toString();
    final hh = value.hour.toString().padLeft(2, '0');
    final min = value.minute.toString().padLeft(2, '0');
    return '$dd/$mm/$yyyy às $hh:$min';
  }
}

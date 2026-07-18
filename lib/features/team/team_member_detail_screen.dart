import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_card.dart';
import '../quotes/utils/quote_money_display.dart';
import 'models/team_member_status.dart';
import 'providers/team_member_provider.dart';
import 'providers/team_role_provider.dart';
import 'team_feedback.dart';

class TeamMemberDetailScreen extends ConsumerWidget {
  const TeamMemberDetailScreen({super.key, required this.memberId});

  final String memberId;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Excluir colaborador'),
          content: const Text(
            'Esta ação remove o colaborador da equipe. Continuar?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              key: const Key('team_member_delete_confirm_button'),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
    if (confirmed != true) {
      return;
    }

    final result =
        await ref.read(teamMemberProvider.notifier).deleteMember(memberId);
    if (!result.isDeleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        TeamFeedbackPresenter.showError(
          TeamFeedbackPresenter.memberDeleteError(result),
        );
      });
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) {
        return;
      }
      context.go(AppRoutes.team);
      TeamFeedbackPresenter.showSnackBar(TeamFeedback.memberDeleted);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(teamMemberProvider);
    final roles = ref.watch(teamRoleProvider).value ?? const [];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Detalhe do colaborador',
          style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            key: const Key('team_member_edit_button'),
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Editar',
            onPressed: () => context.push(AppRoutes.teamEdit(memberId)),
          ),
          IconButton(
            key: const Key('team_member_delete_button'),
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Excluir',
            onPressed: () => _delete(context, ref),
          ),
        ],
      ),
      body: membersAsync.when(
        data: (members) {
          final member =
              members.where((item) => item.id == memberId).firstOrNull;
          if (member == null) {
            return Center(
              child: Text(
                'Colaborador não encontrado.',
                style: AppTextStyles.bodyMedium,
              ),
            );
          }
          final roleName = roles
                  .where((role) => role.id == member.roleId)
                  .map((role) => role.name)
                  .firstOrNull ??
              '—';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(member.name, style: AppTextStyles.headlineMedium),
                      const SizedBox(height: 16),
                      _DetailRow(label: 'Função', value: roleName),
                      _DetailRow(label: 'Telefone', value: member.phone),
                      if (member.email != null && member.email!.isNotEmpty)
                        _DetailRow(label: 'E-mail', value: member.email!),
                      _DetailRow(
                        label: 'Diária',
                        value: QuoteMoneyDisplay.format(member.dailyRate),
                      ),
                      _DetailRow(
                        label: 'Status',
                        value: member.status.label,
                      ),
                      if (member.observations.trim().isNotEmpty)
                        _DetailRow(
                          label: 'Observações',
                          value: member.observations,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Não foi possível carregar o colaborador.',
            style: AppTextStyles.bodyMedium,
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }
}

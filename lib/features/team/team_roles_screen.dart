import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_card.dart';
import 'models/team_role.dart';
import 'providers/team_role_provider.dart';
import 'team_feedback.dart';
import 'widgets/team_role_form_dialog.dart';

class TeamRolesScreen extends ConsumerWidget {
  const TeamRolesScreen({super.key});

  Future<void> _create(BuildContext context, WidgetRef ref) async {
    final draft = await showTeamRoleFormDialog(context: context);
    if (draft == null) {
      return;
    }
    final result = await ref.read(teamRoleProvider.notifier).addRole(draft);
    if (!result.isSuccess) {
      TeamFeedbackPresenter.showError(
        TeamFeedbackPresenter.roleWriteError(result),
      );
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TeamFeedbackPresenter.showSnackBar(TeamFeedback.roleCreated);
    });
  }

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref,
    TeamRole role,
  ) async {
    final draft = await showTeamRoleFormDialog(context: context, existing: role);
    if (draft == null) {
      return;
    }
    final result = await ref.read(teamRoleProvider.notifier).updateRole(draft);
    if (!result.isSuccess) {
      TeamFeedbackPresenter.showError(
        TeamFeedbackPresenter.roleWriteError(result),
      );
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TeamFeedbackPresenter.showSnackBar(TeamFeedback.roleUpdated);
    });
  }

  Future<void> _toggleActive(WidgetRef ref, TeamRole role) async {
    final notifier = ref.read(teamRoleProvider.notifier);
    final result = role.active
        ? await notifier.deactivateRole(role.id)
        : await notifier.activateRole(role.id);
    if (!result.isSuccess) {
      TeamFeedbackPresenter.showError(
        TeamFeedbackPresenter.roleWriteError(result),
      );
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TeamFeedbackPresenter.showSnackBar(
        role.active ? TeamFeedback.roleDeactivated : TeamFeedback.roleActivated,
      );
    });
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    TeamRole role,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Excluir função'),
          content: Text('Excluir "${role.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              key: const Key('team_role_delete_confirm_button'),
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
        await ref.read(teamRoleProvider.notifier).deleteRole(role.id);
    if (!result.isDeleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        TeamFeedbackPresenter.showError(
          TeamFeedbackPresenter.roleDeleteError(result),
        );
      });
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TeamFeedbackPresenter.showSnackBar(TeamFeedback.roleDeleted);
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rolesAsync = ref.watch(teamRoleProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Funções da equipe',
          style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            key: const Key('team_role_new_button'),
            icon: const Icon(Icons.add),
            tooltip: 'Nova função',
            onPressed: () => _create(context, ref),
          ),
        ],
      ),
      body: rolesAsync.when(
        data: (roles) {
          if (roles.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Nenhuma função cadastrada.',
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView.separated(
            key: const Key('team_role_list'),
            padding: const EdgeInsets.all(24),
            itemCount: roles.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final role = roles[index];
              return AppCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(role.name, style: AppTextStyles.titleMedium),
                          if (role.description != null &&
                              role.description!.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              role.description!,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.white.withValues(alpha: 0.7),
                              ),
                            ),
                          ],
                          const SizedBox(height: 4),
                          Text(
                            role.active ? 'Ativa' : 'Inativa',
                            style: AppTextStyles.caption.copyWith(
                              color: role.active
                                  ? AppColors.success
                                  : AppColors.warning,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      key: Key('team_role_edit_${role.id}'),
                      tooltip: 'Editar',
                      onPressed: () => _edit(context, ref, role),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                    IconButton(
                      key: Key('team_role_toggle_${role.id}'),
                      tooltip: role.active ? 'Desativar' : 'Ativar',
                      onPressed: () => _toggleActive(ref, role),
                      icon: Icon(
                        role.active
                            ? Icons.toggle_on
                            : Icons.toggle_off_outlined,
                        color: role.active
                            ? AppColors.success
                            : AppColors.white.withValues(alpha: 0.5),
                      ),
                    ),
                    IconButton(
                      key: Key('team_role_delete_${role.id}'),
                      tooltip: 'Excluir',
                      onPressed: () => _delete(context, ref, role),
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Não foi possível carregar as funções.',
            style: AppTextStyles.bodyMedium,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'models/team_list_summary.dart';
import 'providers/filtered_team_members_provider.dart';
import 'providers/team_filters_provider.dart';
import 'providers/team_list_summary_provider.dart';
import 'providers/team_member_provider.dart';
import 'providers/team_role_provider.dart';
import 'team_feedback.dart';
import 'widgets/team_empty_state.dart';
import 'widgets/team_filters_bar.dart';
import 'widgets/team_member_list_item.dart';
import 'widgets/team_summary_cards.dart';

class TeamScreen extends ConsumerWidget {
  const TeamScreen({super.key});

  static const _maxContentWidth = 960.0;

  Future<void> _openNew(BuildContext context) async {
    final created = await context.push<bool>(AppRoutes.teamNew);
    if (created == true && context.mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        TeamFeedbackPresenter.showSnackBar(TeamFeedback.memberCreated);
      });
    }
  }

  String _roleName(WidgetRef ref, String roleId) {
    return ref.read(teamRoleProvider).value
            ?.where((role) => role.id == roleId)
            .map((role) => role.name)
            .firstOrNull ??
        'Função';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(filteredTeamMembersProvider);
    final summaryAsync = ref.watch(teamListSummaryProvider);
    final filters = ref.watch(teamFiltersProvider);
    final roles = ref.watch(teamRoleProvider).value ?? const [];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Voltar',
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Equipe & Escalas',
          style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            key: const Key('team_roles_button'),
            icon: const Icon(Icons.badge_outlined),
            tooltip: 'Funções',
            onPressed: () => context.push(AppRoutes.teamRoles),
          ),
          IconButton(
            key: const Key('team_new_button'),
            icon: const Icon(Icons.add),
            tooltip: 'Novo colaborador',
            onPressed: () => _openNew(context),
          ),
        ],
      ),
      body: itemsAsync.when(
        data: (items) {
          final summary = summaryAsync.value ?? TeamListSummary.empty;
          return CustomScrollView(
            key: const Key('team_scroll'),
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
                          TeamSummaryCards(summary: summary),
                          const SizedBox(height: 16),
                          TeamFiltersBar(
                            filters: filters,
                            roles: roles,
                            onRoleChanged: (roleId) => ref
                                .read(teamFiltersProvider.notifier)
                                .setRoleId(roleId),
                            onStatusChanged: (status) => ref
                                .read(teamFiltersProvider.notifier)
                                .setStatus(status),
                            onNameQueryChanged: (query) => ref
                                .read(teamFiltersProvider.notifier)
                                .setNameQuery(query),
                            onClear: () =>
                                ref.read(teamFiltersProvider.notifier).clear(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (items.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: _maxContentWidth,
                        ),
                        child: TeamEmptyState(
                          onNewMember: () => _openNew(context),
                          hasActiveFilters: filters.hasActiveFilters,
                          onClearFilters: () => ref
                              .read(teamFiltersProvider.notifier)
                              .clear(),
                        ),
                      ),
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverList.separated(
                    key: const Key('team_list'),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final member = items[index];
                      return Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: _maxContentWidth,
                          ),
                          child: TeamMemberListItem(
                            member: member,
                            roleName: _roleName(ref, member.roleId),
                            onTap: () => context.push(
                              AppRoutes.teamDetail(member.id),
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
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Não foi possível carregar a equipe.',
                  style: AppTextStyles.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () =>
                      ref.read(teamMemberProvider.notifier).reload(),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';
import 'models/quote_team_summary.dart';
import 'providers/quote_team_provider.dart';
import 'providers/team_member_provider.dart';
import 'providers/team_role_provider.dart';
import 'team_feedback.dart';
import 'widgets/quote_team_form_dialogs.dart';
import 'widgets/quote_team_list_item.dart';

class QuoteTeamScreen extends ConsumerWidget {
  const QuoteTeamScreen({super.key, required this.quoteId});

  final String quoteId;

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final members = ref.read(teamMemberProvider).value ?? const [];
    if (members.isEmpty) {
      TeamFeedbackPresenter.showError(
        'Cadastre colaboradores na equipe antes de associá-los.',
      );
      return;
    }

    final linkedIds = (ref.read(quoteTeamProvider(quoteId)).value ?? const [])
        .map((item) => item.teamMemberId)
        .toSet();

    final draft = await showQuoteTeamAddDialog(
      context: context,
      members: members,
      excludeMemberIds: linkedIds,
    );
    if (draft == null) {
      return;
    }

    final result = await ref.read(quoteTeamProvider(quoteId).notifier).add(
          teamMemberId: draft.teamMemberId,
          notes: draft.notes,
        );
    if (!result.isSuccess) {
      TeamFeedbackPresenter.showError(
        TeamFeedbackPresenter.quoteTeamWriteError(result),
      );
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TeamFeedbackPresenter.showSnackBar(TeamFeedback.quoteTeamAdded);
    });
  }

  Future<void> _remove(
    BuildContext context,
    WidgetRef ref, {
    required String id,
    required String memberName,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Remover colaborador'),
          content: Text('Remover "$memberName" deste orçamento?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              key: const Key('quote_team_remove_confirm_button'),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              child: const Text('Remover'),
            ),
          ],
        );
      },
    );
    if (confirmed != true) {
      return;
    }

    final result =
        await ref.read(quoteTeamProvider(quoteId).notifier).remove(id);
    if (!result.isDeleted) {
      TeamFeedbackPresenter.showError(
        TeamFeedbackPresenter.quoteTeamDeleteError(result),
      );
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TeamFeedbackPresenter.showSnackBar(TeamFeedback.quoteTeamRemoved);
    });
  }

  String _memberName(WidgetRef ref, String memberId) {
    return ref.read(teamMemberProvider).value
            ?.where((member) => member.id == memberId)
            .map((member) => member.name)
            .firstOrNull ??
        'Colaborador';
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
    final itemsAsync = ref.watch(quoteTeamProvider(quoteId));
    final summaryAsync = ref.watch(quoteTeamSummaryProvider(quoteId));
    ref.watch(teamMemberProvider);
    ref.watch(teamRoleProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Equipe do orçamento',
          style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            key: const Key('quote_team_add_button'),
            icon: const Icon(Icons.add),
            tooltip: 'Adicionar colaborador',
            onPressed: () => _add(context, ref),
          ),
        ],
      ),
      body: itemsAsync.when(
        data: (items) {
          final summary = summaryAsync.value ??
              QuoteTeamSummary(quoteId: quoteId, items: items);
          return CustomScrollView(
            key: const Key('quote_team_scroll'),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                sliver: SliverToBoxAdapter(
                  child: QuoteTeamSummaryCards(summary: summary),
                ),
              ),
              if (items.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          'Nenhum colaborador associado a este orçamento.',
                          style: AppTextStyles.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        PrimaryButton(
                          key: const Key('quote_team_empty_add_button'),
                          label: 'Adicionar colaborador',
                          onPressed: () => _add(context, ref),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.all(24),
                  sliver: SliverList.separated(
                    key: const Key('quote_team_list'),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final name = _memberName(ref, item.teamMemberId);
                      return QuoteTeamListItem(
                        item: item,
                        memberName: name,
                        roleName: _roleName(ref, item.roleId),
                        onRemove: () => _remove(
                          context,
                          ref,
                          id: item.id,
                          memberName: name,
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
          child: Text(
            'Não foi possível carregar a equipe do orçamento.',
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_card.dart';
import 'agenda_block_feedback.dart';
import 'models/agenda_block.dart';
import 'providers/agenda_blocks_provider.dart';
import 'utils/agenda_occupancy_presenter.dart';

class AgendaBlockDetailScreen extends ConsumerWidget {
  const AgendaBlockDetailScreen({super.key, required this.blockId});

  final String blockId;

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final block = ref.read(agendaBlocksProvider.notifier).findById(blockId);
    if (block == null || !context.mounted) {
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Excluir bloqueio'),
          content: Text(
            'Deseja excluir "${block.title}"? Esta ação não pode ser desfeita.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              key: const Key('agenda_block_delete_confirm_button'),
              style: TextButton.styleFrom(foregroundColor: AppColors.error),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    final deleted = await ref
        .read(agendaBlocksProvider.notifier)
        .deleteBlock(blockId);
    if (!context.mounted) {
      return;
    }
    if (!deleted) {
      AgendaBlockFeedbackPresenter.showErrorSnackBar(
        AgendaBlockErrorFeedback.delete,
      );
      return;
    }

    context.go(AppRoutes.agenda);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AgendaBlockFeedbackPresenter.showSnackBar(
          AgendaBlockFeedback.deleted,
        );
      });
    });
  }

  Widget _scaffold(
    BuildContext context, {
    required String title,
    required Widget body,
    List<Widget> actions = const [],
  }) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Voltar',
          onPressed: () => context.pop(),
        ),
        title: Text(
          title,
          style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
        elevation: 0,
        actions: actions,
      ),
      body: body,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blocksAsync = ref.watch(agendaBlocksProvider);

    return blocksAsync.when(
      data: (blocks) {
        AgendaBlock? block;
        for (final item in blocks) {
          if (item.id == blockId) {
            block = item;
            break;
          }
        }

        if (block == null) {
          return _scaffold(
            context,
            title: 'Bloqueio',
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Bloqueio não encontrado',
                  style: AppTextStyles.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        final resolvedBlock = block;

        return _scaffold(
          context,
          title: resolvedBlock.title,
          actions: [
            IconButton(
              key: const Key('agenda_block_edit_button'),
              icon: const Icon(Icons.edit_outlined),
              tooltip: 'Editar',
              onPressed: () =>
                  context.push(AppRoutes.agendaEdit(resolvedBlock.id)),
            ),
            IconButton(
              key: const Key('agenda_block_delete_button'),
              icon: const Icon(Icons.delete_outline),
              tooltip: 'Excluir',
              color: AppColors.error,
              onPressed: () => _confirmDelete(context, ref),
            ),
          ],
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: AppCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Início', style: AppTextStyles.caption),
                          const SizedBox(height: 4),
                          Text(
                            AgendaDateFormatter.formatDateTime(
                              resolvedBlock.start,
                            ),
                            style: AppTextStyles.bodyLarge,
                          ),
                          const SizedBox(height: 16),
                          Text('Fim', style: AppTextStyles.caption),
                          const SizedBox(height: 4),
                          Text(
                            AgendaDateFormatter.formatDateTime(
                              resolvedBlock.end,
                            ),
                            style: AppTextStyles.bodyLarge,
                          ),
                          if (resolvedBlock.notes != null &&
                              resolvedBlock.notes!.trim().isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Text('Observações', style: AppTextStyles.caption),
                            const SizedBox(height: 4),
                            Text(
                              resolvedBlock.notes!,
                              style: AppTextStyles.bodyLarge,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
      loading: () => _scaffold(
        context,
        title: 'Bloqueio',
        body: const Center(
          key: Key('agenda_block_detail_loading'),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stackTrace) => _scaffold(
        context,
        title: 'Bloqueio',
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Não foi possível carregar o bloqueio.',
              style: AppTextStyles.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}

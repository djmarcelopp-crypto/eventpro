import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'agenda_block_feedback.dart';
import 'models/agenda_occupancy.dart';
import 'providers/agenda_blocks_provider.dart';
import 'providers/agenda_occupancy_provider.dart';
import 'widgets/agenda_empty_state.dart';
import 'widgets/agenda_occupancy_list_item.dart';

class AgendaScreen extends ConsumerWidget {
  const AgendaScreen({super.key});

  static const _maxContentWidth = 720.0;

  Future<void> _openNewBlock(BuildContext context) async {
    final created = await context.push<bool>(AppRoutes.agendaNew);

    if (created == true && context.mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AgendaBlockFeedbackPresenter.showSnackBar(AgendaBlockFeedback.created);
      });
    }
  }

  void _openOccupancy(BuildContext context, AgendaOccupancy occupancy) {
    final quoteId = occupancy.sourceQuoteId;
    if (quoteId != null) {
      context.push(AppRoutes.quotesDetail(quoteId));
      return;
    }

    final blockId = occupancy.sourceBlockId;
    if (blockId != null) {
      context.push(AppRoutes.agendaDetail(blockId));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final occupancyAsync = ref.watch(agendaOccupancyProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Voltar',
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Agenda',
          style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            key: const Key('agenda_new_block_button'),
            icon: const Icon(Icons.add),
            tooltip: 'Novo Bloqueio',
            onPressed: () => _openNewBlock(context),
          ),
        ],
      ),
      body: occupancyAsync.when(
        data: (occupancies) {
          if (occupancies.isEmpty) {
            return AgendaEmptyState(
              onNewBlock: () => _openNewBlock(context),
            );
          }

          return ListView.separated(
            key: const Key('agenda_occupancy_list'),
            padding: const EdgeInsets.all(24),
            itemCount: occupancies.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final occupancy = occupancies[index];
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: _maxContentWidth,
                  ),
                  child: AgendaOccupancyListItem(
                    key: Key('agenda_occupancy_item_${occupancy.id}'),
                    occupancy: occupancy,
                    onTap: () => _openOccupancy(context, occupancy),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(
          key: Key('agenda_loading_indicator'),
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Não foi possível carregar a agenda.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyLarge,
                ),
                const SizedBox(height: 16),
                OutlinedButton(
                  key: const Key('agenda_retry_button'),
                  onPressed: () => ref.invalidate(agendaBlocksProvider),
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

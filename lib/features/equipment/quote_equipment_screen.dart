import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';
import 'equipment_feedback.dart';
import 'models/quote_equipment_summary.dart';
import 'providers/equipment_provider.dart';
import 'providers/quote_equipment_provider.dart';
import 'widgets/quote_equipment_form_dialogs.dart';
import 'widgets/quote_equipment_list_item.dart';

class QuoteEquipmentScreen extends ConsumerWidget {
  const QuoteEquipmentScreen({super.key, required this.quoteId});

  final String quoteId;

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final equipment = ref.read(equipmentProvider).value ?? const [];
    if (equipment.isEmpty) {
      EquipmentFeedbackPresenter.showError(
        'Cadastre equipamentos no inventário antes de associá-los.',
      );
      return;
    }

    final draft = await showQuoteEquipmentAddDialog(
      context: context,
      equipment: equipment,
    );
    if (draft == null) {
      return;
    }

    final result = await ref
        .read(quoteEquipmentProvider(quoteId).notifier)
        .add(equipmentId: draft.equipmentId, quantity: draft.quantity);
    if (!result.isSuccess) {
      EquipmentFeedbackPresenter.showError(
        EquipmentFeedbackPresenter.quoteEquipmentWriteError(result),
      );
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      EquipmentFeedbackPresenter.showSnackBar(
        EquipmentFeedback.quoteEquipmentAdded,
      );
    });
  }

  Future<void> _editQuantity(
    BuildContext context,
    WidgetRef ref, {
    required String id,
    required int currentQuantity,
  }) async {
    final quantity = await showQuoteEquipmentQuantityDialog(
      context: context,
      initialQuantity: currentQuantity,
    );
    if (quantity == null) {
      return;
    }

    final result = await ref
        .read(quoteEquipmentProvider(quoteId).notifier)
        .updateQuantity(id: id, quantity: quantity);
    if (!result.isSuccess) {
      EquipmentFeedbackPresenter.showError(
        EquipmentFeedbackPresenter.quoteEquipmentWriteError(result),
      );
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      EquipmentFeedbackPresenter.showSnackBar(
        EquipmentFeedback.quoteEquipmentUpdated,
      );
    });
  }

  Future<void> _remove(
    BuildContext context,
    WidgetRef ref, {
    required String id,
    required String equipmentName,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Remover equipamento'),
          content: Text('Remover "$equipmentName" deste orçamento?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              key: const Key('quote_equipment_remove_confirm_button'),
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

    final result = await ref
        .read(quoteEquipmentProvider(quoteId).notifier)
        .remove(id);
    if (!result.isDeleted) {
      EquipmentFeedbackPresenter.showError(
        EquipmentFeedbackPresenter.quoteEquipmentDeleteError(result),
      );
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      EquipmentFeedbackPresenter.showSnackBar(
        EquipmentFeedback.quoteEquipmentRemoved,
      );
    });
  }

  String _equipmentName(WidgetRef ref, String equipmentId) {
    return ref.read(equipmentProvider).value
            ?.where((item) => item.id == equipmentId)
            .map((item) => item.name)
            .firstOrNull ??
        'Equipamento';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(quoteEquipmentProvider(quoteId));
    final summaryAsync = ref.watch(quoteEquipmentSummaryProvider(quoteId));
    ref.watch(equipmentProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Equipamentos do orçamento',
          style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            key: const Key('quote_equipment_add_button'),
            icon: const Icon(Icons.add),
            tooltip: 'Adicionar equipamento',
            onPressed: () => _add(context, ref),
          ),
        ],
      ),
      body: itemsAsync.when(
        data: (items) {
          final summary =
              summaryAsync.value ??
              QuoteEquipmentSummary(quoteId: quoteId, items: items);
          return CustomScrollView(
            key: const Key('quote_equipment_scroll'),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                sliver: SliverToBoxAdapter(
                  child: QuoteEquipmentSummaryCards(summary: summary),
                ),
              ),
              if (items.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          'Nenhum equipamento associado a este orçamento.',
                          style: AppTextStyles.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        PrimaryButton(
                          key: const Key('quote_equipment_empty_add_button'),
                          label: 'Adicionar equipamento',
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
                    key: const Key('quote_equipment_list'),
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final name = _equipmentName(ref, item.equipmentId);
                      return QuoteEquipmentListItem(
                        item: item,
                        equipmentName: name,
                        onEditQuantity: () => _editQuantity(
                          context,
                          ref,
                          id: item.id,
                          currentQuantity: item.quantity,
                        ),
                        onRemove: () => _remove(
                          context,
                          ref,
                          id: item.id,
                          equipmentName: name,
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
            'Não foi possível carregar os equipamentos do orçamento.',
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

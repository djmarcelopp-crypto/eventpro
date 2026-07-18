import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_card.dart';
import 'equipment_feedback.dart';
import 'providers/equipment_category_provider.dart';
import 'providers/equipment_provider.dart';
import 'models/equipment_status.dart';

class EquipmentDetailScreen extends ConsumerWidget {
  const EquipmentDetailScreen({super.key, required this.equipmentId});

  final String equipmentId;

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Excluir equipamento'),
          content: const Text(
            'Esta ação remove o equipamento do inventário. Continuar?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              key: const Key('equipment_delete_confirm_button'),
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

    final result = await ref
        .read(equipmentProvider.notifier)
        .deleteEquipment(equipmentId);
    if (!result.isDeleted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        EquipmentFeedbackPresenter.showError(
          EquipmentFeedbackPresenter.equipmentDeleteError(result),
        );
      });
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) {
        return;
      }
      context.go(AppRoutes.equipment);
      EquipmentFeedbackPresenter.showSnackBar(
        EquipmentFeedback.equipmentDeleted,
      );
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final equipmentAsync = ref.watch(equipmentProvider);
    final categories =
        ref.watch(equipmentCategoryProvider).value ?? const [];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Detalhe do equipamento',
          style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            key: const Key('equipment_edit_button'),
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Editar',
            onPressed: () =>
                context.push(AppRoutes.equipmentEdit(equipmentId)),
          ),
          IconButton(
            key: const Key('equipment_delete_button'),
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Excluir',
            onPressed: () => _delete(context, ref),
          ),
        ],
      ),
      body: equipmentAsync.when(
        data: (items) {
          final equipment = items
              .where((item) => item.id == equipmentId)
              .firstOrNull;
          if (equipment == null) {
            return Center(
              child: Text(
                'Equipamento não encontrado.',
                style: AppTextStyles.bodyMedium,
              ),
            );
          }
          final categoryName = categories
                  .where((category) => category.id == equipment.categoryId)
                  .map((category) => category.name)
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
                      Text(equipment.name, style: AppTextStyles.headlineMedium),
                      const SizedBox(height: 16),
                      _DetailRow(label: 'Categoria', value: categoryName),
                      _DetailRow(
                        label: 'Status',
                        value: equipment.status.label,
                      ),
                      _DetailRow(
                        label: 'Quantidade total',
                        value: '${equipment.totalQuantity}',
                      ),
                      if (equipment.serialNumber != null &&
                          equipment.serialNumber!.isNotEmpty)
                        _DetailRow(
                          label: 'Número de série',
                          value: equipment.serialNumber!,
                        ),
                      if (equipment.description.trim().isNotEmpty)
                        _DetailRow(
                          label: 'Descrição',
                          value: equipment.description,
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
            'Não foi possível carregar o equipamento.',
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

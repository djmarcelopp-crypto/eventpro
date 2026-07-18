import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_text_field.dart';
import 'models/vehicle_type.dart';
import 'providers/vehicle_type_provider.dart';
import 'logistics_feedback.dart';

class VehicleTypesScreen extends ConsumerWidget {
  const VehicleTypesScreen({super.key});

  Future<void> _openForm(
    BuildContext context,
    WidgetRef ref, {
    VehicleType? existing,
  }) async {
    final nameController =
        TextEditingController(text: existing?.name ?? '');
    final descriptionController =
        TextEditingController(text: existing?.description ?? '');
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(existing == null ? 'Novo tipo' : 'Editar tipo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                key: const Key('vehicle_type_form_name'),
                label: 'Nome',
                controller: nameController,
              ),
              const SizedBox(height: 12),
              AppTextField(
                key: const Key('vehicle_type_form_description'),
                label: 'Descrição',
                controller: descriptionController,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              key: const Key('vehicle_type_form_save'),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );

    if (saved != true || !context.mounted) {
      nameController.dispose();
      descriptionController.dispose();
      return;
    }

    final now = DateTime(2026);
    final draft = VehicleType(
      id: existing?.id ?? '',
      name: nameController.text,
      description: descriptionController.text.trim().isEmpty
          ? null
          : descriptionController.text.trim(),
      active: existing?.active ?? true,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );
    nameController.dispose();
    descriptionController.dispose();

    final result = existing == null
        ? await ref.read(vehicleTypeProvider.notifier).addType(draft)
        : await ref.read(vehicleTypeProvider.notifier).updateType(draft);

    if (!context.mounted) return;
    if (result.isSuccess) {
      LogisticsFeedbackPresenter.showSnackBar(
        existing == null
            ? LogisticsFeedback.typeCreated
            : LogisticsFeedback.typeUpdated,
      );
    } else {
      LogisticsFeedbackPresenter.showError(
        LogisticsFeedbackPresenter.typeWriteError(result),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typesAsync = ref.watch(vehicleTypeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tipos de veículo'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
        actions: [
          IconButton(
            key: const Key('vehicle_type_add'),
            icon: const Icon(Icons.add),
            onPressed: () => _openForm(context, ref),
          ),
        ],
      ),
      body: typesAsync.when(
        data: (types) {
          if (types.isEmpty) {
            return const Center(child: Text('Nenhum tipo cadastrado'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(24),
            itemCount: types.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final type = types[index];
              return AppCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(type.name, style: AppTextStyles.titleMedium),
                          Text(
                            type.active ? 'Ativo' : 'Inativo',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () =>
                          _openForm(context, ref, existing: type),
                    ),
                    IconButton(
                      icon: Icon(
                        type.active
                            ? Icons.toggle_on
                            : Icons.toggle_off_outlined,
                      ),
                      onPressed: () async {
                        final result = await ref
                            .read(vehicleTypeProvider.notifier)
                            .setActive(type.id, active: !type.active);
                        if (result.isSuccess) {
                          LogisticsFeedbackPresenter.showSnackBar(
                            type.active
                                ? LogisticsFeedback.typeDeactivated
                                : LogisticsFeedback.typeActivated,
                          );
                        }
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () async {
                        final result = await ref
                            .read(vehicleTypeProvider.notifier)
                            .deleteType(type.id);
                        if (result.isDeleted) {
                          LogisticsFeedbackPresenter.showSnackBar(
                            LogisticsFeedback.typeDeleted,
                          );
                        } else {
                          LogisticsFeedbackPresenter.showError(
                            LogisticsFeedbackPresenter.typeDeleteError(
                              result,
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
      ),
    );
  }
}

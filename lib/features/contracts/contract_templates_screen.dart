import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_text_field.dart';
import 'contracts_feedback.dart';
import 'models/contract_template.dart';
import 'providers/contract_template_provider.dart';

class ContractTemplatesScreen extends ConsumerWidget {
  const ContractTemplatesScreen({super.key});

  Future<void> _openForm(
    BuildContext context,
    WidgetRef ref, {
    ContractTemplate? existing,
  }) async {
    final nameController = TextEditingController(text: existing?.name ?? '');
    final descriptionController =
        TextEditingController(text: existing?.description ?? '');
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(existing == null ? 'Novo modelo' : 'Editar modelo'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                key: const Key('contract_template_form_name'),
                label: 'Nome',
                controller: nameController,
              ),
              const SizedBox(height: 12),
              AppTextField(
                key: const Key('contract_template_form_description'),
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
              key: const Key('contract_template_form_save'),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Salvar'),
            ),
          ],
        );
      },
    );

    final name = nameController.text;
    final description = descriptionController.text.trim();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      nameController.dispose();
      descriptionController.dispose();
    });

    if (saved != true || !context.mounted) {
      return;
    }

    final now = DateTime(2026);
    final draft = ContractTemplate(
      id: existing?.id ?? '',
      name: name,
      description: description.isEmpty ? null : description,
      active: existing?.active ?? true,
      createdAt: existing?.createdAt ?? now,
      updatedAt: now,
    );

    final result = existing == null
        ? await ref.read(contractTemplateProvider.notifier).addTemplate(draft)
        : await ref
            .read(contractTemplateProvider.notifier)
            .updateTemplate(draft);

    if (!context.mounted) return;
    if (result.isSuccess) {
      ContractsFeedbackPresenter.showSnackBar(
        existing == null
            ? ContractsFeedback.templateCreated
            : ContractsFeedback.templateUpdated,
      );
    } else {
      ContractsFeedbackPresenter.showError(
        ContractsFeedbackPresenter.templateWriteError(result),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final typesAsync = ref.watch(contractTemplateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modelos de contrato'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
        actions: [
          IconButton(
            key: const Key('contract_template_add'),
            icon: const Icon(Icons.add),
            onPressed: () => _openForm(context, ref),
          ),
        ],
      ),
      body: typesAsync.when(
        data: (templates) {
          if (templates.isEmpty) {
            return const Center(child: Text('Nenhum modelo cadastrado'));
          }
          return ListView.separated(
            key: const Key('contract_templates_list'),
            padding: const EdgeInsets.all(24),
            itemCount: templates.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final template = templates[index];
              return AppCard(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(template.name, style: AppTextStyles.titleMedium),
                          Text(
                            template.active ? 'Ativo' : 'Inativo',
                            style: AppTextStyles.caption,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      key: Key('contract_template_edit_${template.id}'),
                      icon: const Icon(Icons.edit_outlined),
                      onPressed: () =>
                          _openForm(context, ref, existing: template),
                    ),
                    IconButton(
                      key: Key('contract_template_toggle_${template.id}'),
                      icon: Icon(
                        template.active
                            ? Icons.toggle_on
                            : Icons.toggle_off_outlined,
                      ),
                      onPressed: () async {
                        final result = await ref
                            .read(contractTemplateProvider.notifier)
                            .setActive(template.id, active: !template.active);
                        if (result.isSuccess) {
                          ContractsFeedbackPresenter.showSnackBar(
                            template.active
                                ? ContractsFeedback.templateDeactivated
                                : ContractsFeedback.templateActivated,
                          );
                        }
                      },
                    ),
                    IconButton(
                      key: Key('contract_template_delete_${template.id}'),
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () async {
                        final result = await ref
                            .read(contractTemplateProvider.notifier)
                            .deleteTemplate(template.id);
                        if (result.isDeleted) {
                          ContractsFeedbackPresenter.showSnackBar(
                            ContractsFeedback.templateDeleted,
                          );
                        } else {
                          ContractsFeedbackPresenter.showError(
                            ContractsFeedbackPresenter.templateDeleteError(
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

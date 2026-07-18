import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'client_list_feedback.dart';
import 'models/client.dart';
import 'providers/clients_provider.dart';
import 'utils/client_detail_presenter.dart';
import 'widgets/client_detail_section.dart';

class ClientDetailScreen extends ConsumerWidget {
  const ClientDetailScreen({super.key, required this.clientId});

  final String clientId;

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final client = ref.read(clientsProvider.notifier).findById(clientId);
    if (client == null || !context.mounted) {
      return;
    }

    final displayName = ClientDetailPresenter.displayTitle(client);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Excluir cliente'),
          content: Text(
            'Deseja excluir "$displayName"? Esta ação não pode ser desfeita.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
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
        .read(clientsProvider.notifier)
        .deleteClient(clientId);
    if (!context.mounted) {
      return;
    }
    if (!deleted) {
      ClientListFeedbackPresenter.showErrorSnackBar(
        ClientListErrorFeedback.delete,
      );
      return;
    }

    context.go(AppRoutes.clients);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ClientListFeedbackPresenter.showSnackBar(ClientListFeedback.deleted);
      });
    });
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clients = ref.watch(clientsProvider);
    Client? client;
    for (final item in clients) {
      if (item.id == clientId) {
        client = item;
        break;
      }
    }

    if (client == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Voltar',
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Cliente',
            style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
          ),
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.white,
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Cliente não encontrado',
              style: AppTextStyles.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    final resolvedClient = client;
    final internalNotes = ClientDetailPresenter.internalNotes(resolvedClient);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Voltar',
          onPressed: () => context.pop(),
        ),
        title: Text(
          ClientDetailPresenter.displayTitle(resolvedClient),
          style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
        elevation: 0,
        actions: [
          IconButton(
            key: const Key('client_edit_button'),
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Editar',
            onPressed: () => context.push(
              AppRoutes.clientsEdit(clientId),
              extra: resolvedClient,
            ),
          ),
          IconButton(
            key: const Key('client_delete_button'),
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Excluir',
            color: AppColors.error,
            onPressed: () => _confirmDelete(context, ref),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClientDetailSection(
                      title: 'Identificação',
                      items: ClientDetailPresenter.identification(
                        resolvedClient,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ClientDetailSection(
                      title: 'Contato',
                      items: ClientDetailPresenter.contact(resolvedClient),
                    ),
                    const SizedBox(height: 16),
                    ClientDetailSection(
                      title: 'Endereço',
                      items: ClientDetailPresenter.address(resolvedClient),
                    ),
                    const SizedBox(height: 16),
                    ClientDetailSection(
                      title: 'Informações adicionais',
                      items: ClientDetailPresenter.additional(resolvedClient),
                    ),
                    if (internalNotes != null) ...[
                      const SizedBox(height: 16),
                      ClientDetailSection(
                        title: 'Observações internas',
                        items: const [],
                        footer: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(internalNotes, style: AppTextStyles.bodyLarge),
                            const SizedBox(height: 8),
                            Text(
                              'Esta informação não aparece no orçamento.',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

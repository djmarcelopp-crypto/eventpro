import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'providers/clients_provider.dart';
import 'widgets/client_list_item.dart';
import 'widgets/clients_empty_state.dart';

class ClientsScreen extends ConsumerWidget {
  const ClientsScreen({super.key});

  static const _maxContentWidth = 720.0;

  Future<void> _openNewClient(BuildContext context) async {
    final created = await context.push<bool>(AppRoutes.clientsNew);

    if (created == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Cliente cadastrado com sucesso',
            style: TextStyle(color: AppColors.white),
          ),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clients = ref.watch(clientsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Voltar',
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Clientes',
          style: AppTextStyles.headlineMedium.copyWith(
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
        elevation: 0,
        actions: [
          if (clients.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Novo cliente',
              onPressed: () => _openNewClient(context),
            ),
        ],
      ),
      body: clients.isEmpty
          ? ClientsEmptyState(
              onNewClient: () => _openNewClient(context),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                return ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemCount: clients.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: _maxContentWidth,
                        ),
                        child: ClientListItem(client: clients[index]),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

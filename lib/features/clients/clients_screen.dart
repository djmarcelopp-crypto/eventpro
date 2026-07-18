import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/widgets/app_page_header.dart';
import 'client_list_feedback.dart';
import 'providers/clients_provider.dart';
import 'widgets/client_list_item.dart';
import 'widgets/clients_empty_state.dart';

class ClientsScreen extends ConsumerStatefulWidget {
  const ClientsScreen({super.key});

  @override
  ConsumerState<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends ConsumerState<ClientsScreen> {
  static const _maxContentWidth = 720.0;

  Future<void> _openNewClient() async {
    final created = await context.push<bool>(AppRoutes.clientsNew);

    if (created == true && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          ClientListFeedbackPresenter.showSnackBar(ClientListFeedback.created);
        }
      });
    }
  }

  void _openClientDetail(String clientId) {
    context.push(AppRoutes.clientsDetail(clientId));
  }

  @override
  Widget build(BuildContext context) {
    final clients = ref.watch(clientsProvider);

    return Scaffold(
      appBar: AppPageHeader(
        title: 'Clientes',
        actions: [
          if (clients.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: 'Novo cliente',
              onPressed: _openNewClient,
            ),
        ],
      ),
      body: clients.isEmpty
          ? ClientsEmptyState(
              onNewClient: _openNewClient,
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                return ListView.separated(
                  padding: const EdgeInsets.all(24),
                  itemCount: clients.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final client = clients[index];
                    return Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: _maxContentWidth,
                        ),
                        child: ClientListItem(
                          key: Key('client_list_item_${client.id}'),
                          client: client,
                          onTap: () => _openClientDetail(client.id),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../clients/models/client.dart';
import '../../clients/utils/client_display_formatter.dart';
import '../utils/quote_client_search.dart';

class QuoteClientSelectorSheet extends StatefulWidget {
  const QuoteClientSelectorSheet({
    super.key,
    required this.clients,
    required this.selectedClientId,
    required this.pageContext,
  });

  final List<Client> clients;
  final String? selectedClientId;
  final BuildContext pageContext;

  @override
  State<QuoteClientSelectorSheet> createState() =>
      _QuoteClientSelectorSheetState();
}

class _QuoteClientSelectorSheetState extends State<QuoteClientSelectorSheet> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Client> get _filteredClients {
    return QuoteClientSearch.filter(widget.clients, _query);
  }

  Future<void> _openNewClient() async {
    Navigator.of(context).pop();
    await widget.pageContext.push<bool>(AppRoutes.clientsNew);
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredClients;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.viewInsetsOf(context).bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Selecionar cliente',
              style: AppTextStyles.titleMedium,
            ),
            const SizedBox(height: 16),
            AppTextField(
              key: const Key('quote_client_search_field'),
              label: 'Buscar cliente',
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
            ),
            const SizedBox(height: 16),
            if (widget.clients.isEmpty) ...[
              Text(
                'Nenhum cliente cadastrado. Cadastre um cliente para '
                'continuar o orçamento.',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                key: const Key('quote_register_client_button'),
                label: 'Cadastrar cliente',
                onPressed: _openNewClient,
              ),
            ] else if (filtered.isEmpty) ...[
              Text(
                'Nenhum cliente encontrado para a busca.',
                style: AppTextStyles.bodyMedium,
              ),
            ] else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: filtered.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final client = filtered[index];
                    final isSelected = client.id == widget.selectedClientId;
                    final tradeName = client.tradeName?.trim();
                    final hasTradeName =
                        tradeName != null && tradeName.isNotEmpty;
                    final primaryName =
                        hasTradeName ? tradeName : client.name;

                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        key: Key('quote_client_option_${client.id}'),
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => Navigator.of(context).pop(client),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withValues(alpha: 0.1)
                                : AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.border,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      primaryName,
                                      style: AppTextStyles.titleSmall,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    client.type.label,
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ],
                              ),
                              if (hasTradeName) ...[
                                const SizedBox(height: 4),
                                Text(
                                  client.name,
                                  style: AppTextStyles.bodyMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                              if (ClientDisplayFormatter.formatPrimaryContact(
                                    client,
                                  ) !=
                                  null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  ClientDisplayFormatter.formatPrimaryContact(
                                    client,
                                  )!,
                                  style: AppTextStyles.bodyMedium,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Future<Client?> showQuoteClientSelector({
  required BuildContext context,
  required List<Client> clients,
  required String? selectedClientId,
}) {
  return showModalBottomSheet<Client>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) {
      return QuoteClientSelectorSheet(
        clients: clients,
        selectedClientId: selectedClientId,
        pageContext: context,
      );
    },
  );
}

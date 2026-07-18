import 'package:flutter/material.dart';

import '../../../core/widgets/feedback/app_empty_state.dart';

class QuotesEmptyState extends StatelessWidget {
  const QuotesEmptyState({
    super.key,
    required this.onNewQuote,
  });

  final VoidCallback onNewQuote;

  @override
  Widget build(BuildContext context) {
    return AppEmptyState(
      key: const Key('quotes_empty_state'),
      icon: Icons.request_quote_outlined,
      title: 'Nenhum orçamento cadastrado',
      message:
          'Crie orçamentos profissionais com clientes e itens do catálogo',
      primaryActionLabel: 'Novo orçamento',
      primaryActionKey: const Key('quotes_new_quote_button'),
      onPrimaryAction: onNewQuote,
    );
  }
}

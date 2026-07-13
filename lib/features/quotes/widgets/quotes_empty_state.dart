import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';

class QuotesEmptyState extends StatelessWidget {
  const QuotesEmptyState({
    super.key,
    required this.onNewQuote,
  });

  final VoidCallback onNewQuote;

  static const _maxContentWidth = 480.0;
  static const _maxButtonWidth = 320.0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: _maxContentWidth),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.request_quote_outlined,
                size: 64,
                color: AppColors.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Nenhum orçamento cadastrado',
                textAlign: TextAlign.center,
                style: AppTextStyles.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'Crie orçamentos profissionais com clientes e itens do catálogo',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(height: 32),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _maxButtonWidth),
                child: PrimaryButton(
                  key: const Key('quotes_new_quote_button'),
                  label: 'Novo orçamento',
                  onPressed: onNewQuote,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

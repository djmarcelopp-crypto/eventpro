import 'package:flutter/material.dart';

import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/primary_button.dart';

class QuoteNotFoundState extends StatelessWidget {
  const QuoteNotFoundState({
    super.key,
    required this.onBack,
    this.message = 'Orçamento não encontrado',
  });

  final VoidCallback onBack;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              style: AppTextStyles.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              key: const Key('quote_not_found_back_button'),
              label: 'Voltar',
              onPressed: onBack,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import 'providers/quotes_provider.dart';
import 'utils/quotes_navigation.dart';
import 'widgets/quotes_empty_state.dart';

class QuotesScreen extends ConsumerWidget {
  const QuotesScreen({super.key});

  static const _maxContentWidth = 960.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quotes = ref.watch(quotesProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Voltar',
          onPressed: () => QuotesNavigation.leaveQuotes(context),
        ),
        title: Text(
          'Orçamentos',
          style: AppTextStyles.headlineMedium.copyWith(
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: quotes.isEmpty
          ? QuotesEmptyState(
              onNewQuote: () {},
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: _maxContentWidth,
                    ),
                    child: const SizedBox.shrink(),
                  ),
                );
              },
            ),
    );
  }
}

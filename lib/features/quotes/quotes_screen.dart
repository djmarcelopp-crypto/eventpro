import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/widgets/app_page_header.dart';
import 'quote_list_feedback.dart';
import 'providers/quotes_provider.dart';
import 'utils/quotes_navigation.dart';
import 'widgets/quote_list_item.dart';
import 'widgets/quotes_empty_state.dart';

class QuotesScreen extends ConsumerStatefulWidget {
  const QuotesScreen({super.key});

  @override
  ConsumerState<QuotesScreen> createState() => _QuotesScreenState();
}

class _QuotesScreenState extends ConsumerState<QuotesScreen> {
  static const _maxContentWidth = 960.0;

  Future<void> _openNewQuote() async {
    final created = await context.push<bool>(AppRoutes.quotesNew);

    if (created == true && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          QuoteListFeedbackPresenter.showSnackBar(QuoteListFeedback.saved);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final quotes = ref.watch(quotesProvider);
    final sortedQuotes = List.of(quotes)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Scaffold(
      appBar: AppPageHeader(
        title: 'Orçamentos',
        onBack: () => QuotesNavigation.leaveQuotes(context),
        forceBack: true,
        actions: [
          if (quotes.isNotEmpty)
            IconButton(
              key: const Key('quotes_app_bar_new_button'),
              icon: const Icon(Icons.add),
              tooltip: 'Novo orçamento',
              onPressed: _openNewQuote,
            ),
        ],
      ),
      body: quotes.isEmpty
          ? QuotesEmptyState(
              onNewQuote: _openNewQuote,
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final crossAxisCount = width >= 1100
                    ? 3
                    : width >= 720
                        ? 2
                        : 1;

                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: _maxContentWidth,
                    ),
                    child: GridView.builder(
                      key: const Key('quotes_list_grid'),
                      padding: const EdgeInsets.all(24),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: crossAxisCount == 1 ? 2.4 : 1.15,
                      ),
                      itemCount: sortedQuotes.length,
                      itemBuilder: (context, index) {
                        return QuoteListItem(
                          quote: sortedQuotes[index],
                          onTap: () => context.push(
                            AppRoutes.quotesDetail(sortedQuotes[index].id),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}

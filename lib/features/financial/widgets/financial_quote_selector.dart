import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../quotes/models/quote.dart';

Future<Quote?> showFinancialQuoteSelector({
  required BuildContext context,
  required List<Quote> quotes,
  String? selectedQuoteId,
}) {
  return showModalBottomSheet<Quote>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return FinancialQuoteSelectorSheet(
        quotes: quotes,
        selectedQuoteId: selectedQuoteId,
      );
    },
  );
}

class FinancialQuoteSelectorSheet extends StatefulWidget {
  const FinancialQuoteSelectorSheet({
    super.key,
    required this.quotes,
    this.selectedQuoteId,
  });

  final List<Quote> quotes;
  final String? selectedQuoteId;

  @override
  State<FinancialQuoteSelectorSheet> createState() =>
      _FinancialQuoteSelectorSheetState();
}

class _FinancialQuoteSelectorSheetState
    extends State<FinancialQuoteSelectorSheet> {
  late final TextEditingController _searchController;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Quote> get _filtered {
    final query = _query.trim().toLowerCase();
    if (query.isEmpty) {
      return widget.quotes;
    }
    return widget.quotes.where((quote) {
      final eventName = quote.eventSnapshot.name?.toLowerCase() ?? '';
      final client = quote.clientSnapshot.displayName.toLowerCase();
      return quote.number.toLowerCase().contains(query) ||
          eventName.contains(query) ||
          client.contains(query);
    }).toList(growable: false);
  }

  String _subtitle(Quote quote) {
    final eventName = quote.eventSnapshot.name?.trim();
    final client = quote.clientSnapshot.displayName.trim();
    if (eventName != null && eventName.isNotEmpty) {
      return '$eventName · $client';
    }
    return client;
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final filtered = _filtered;

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Vincular orçamento', style: AppTextStyles.titleMedium),
            const SizedBox(height: 12),
            TextField(
              key: const Key('financial_quote_search'),
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Buscar por número, evento ou cliente',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: filtered.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'Nenhum orçamento encontrado.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.mutedWhite,
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final quote = filtered[index];
                        final selected = quote.id == widget.selectedQuoteId;
                        return ListTile(
                          key: Key('financial_quote_option_${quote.id}'),
                          selected: selected,
                          title: Text(quote.number),
                          subtitle: Text(_subtitle(quote)),
                          trailing: selected
                              ? const Icon(
                                  Icons.check,
                                  color: AppColors.primary,
                                )
                              : null,
                          onTap: () => Navigator.of(context).pop(quote),
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

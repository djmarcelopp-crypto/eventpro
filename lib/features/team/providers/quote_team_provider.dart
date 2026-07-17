import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/quote_team_delete_result.dart';
import '../models/quote_team_member.dart';
import '../models/quote_team_summary.dart';
import '../models/quote_team_write_result.dart';
import '../utils/quote_team_service.dart';
import 'quote_team_service_provider.dart';

/// QuoteTeamProvider — orchestrates [QuoteTeamService] per quote.
class QuoteTeamNotifier extends AsyncNotifier<List<QuoteTeamMember>> {
  QuoteTeamNotifier(this.quoteId);

  final String quoteId;

  QuoteTeamService get _service => ref.read(quoteTeamServiceProvider);

  @override
  Future<List<QuoteTeamMember>> build() async {
    return _service.listForQuote(quoteId);
  }

  void hydrate(List<QuoteTeamMember> items) {
    state = AsyncValue.data(List<QuoteTeamMember>.unmodifiable(items));
  }

  QuoteTeamSummary get summary {
    final items = state.value ?? const <QuoteTeamMember>[];
    return QuoteTeamSummary(quoteId: quoteId, items: items);
  }

  Future<QuoteTeamWriteResult> add({
    required String teamMemberId,
    String? notes,
  }) async {
    final result = await _service.add(
      quoteId: quoteId,
      teamMemberId: teamMemberId,
      notes: notes,
    );
    if (result.isSuccess && result.item != null) {
      final current = state.value ?? const <QuoteTeamMember>[];
      state = AsyncValue.data(
        List<QuoteTeamMember>.unmodifiable([...current, result.item!]),
      );
    }
    return result;
  }

  Future<QuoteTeamDeleteResult> remove(String id) async {
    final result = await _service.remove(id);
    if (result.isDeleted) {
      final current = state.value ?? const <QuoteTeamMember>[];
      state = AsyncValue.data(
        List<QuoteTeamMember>.unmodifiable([
          for (final item in current)
            if (item.id != id) item,
        ]),
      );
    }
    return result;
  }

  Future<void> reload() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _service.listForQuote(quoteId));
  }
}

final quoteTeamProvider = AsyncNotifierProvider.family<
  QuoteTeamNotifier,
  List<QuoteTeamMember>,
  String
>(QuoteTeamNotifier.new);

final quoteTeamSummaryProvider =
    Provider.family<AsyncValue<QuoteTeamSummary>, String>((ref, quoteId) {
      final itemsAsync = ref.watch(quoteTeamProvider(quoteId));
      return itemsAsync.whenData(
        (items) => QuoteTeamSummary(quoteId: quoteId, items: items),
      );
    });

import 'package:eventpro/features/team/data/repositories/quote_team_repository.dart';
import 'package:eventpro/features/team/models/quote_team_member.dart';

class FakeQuoteTeamRepository implements QuoteTeamRepository {
  FakeQuoteTeamRepository({List<QuoteTeamMember>? initialItems})
      : _items = List<QuoteTeamMember>.from(initialItems ?? const []);

  final List<QuoteTeamMember> _items;
  var shouldFailOnNextOperation = false;

  @override
  Future<List<QuoteTeamMember>> listAll() async {
    return List<QuoteTeamMember>.unmodifiable(_items);
  }

  @override
  Future<QuoteTeamMember?> findById(String id) async {
    for (final item in _items) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  @override
  Future<List<QuoteTeamMember>> listByQuoteId(String quoteId) async {
    final matches = _items.where((item) => item.quoteId == quoteId).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return List<QuoteTeamMember>.unmodifiable(matches);
  }

  @override
  Future<void> insert(QuoteTeamMember item) async {
    _failIfRequested();
    _items.add(item);
  }

  @override
  Future<void> update(QuoteTeamMember item) async {
    _failIfRequested();
    final index = _items.indexWhere((current) => current.id == item.id);
    if (index == -1) {
      throw StateError('QuoteTeamMember not found for update: ${item.id}');
    }
    _items[index] = item;
  }

  @override
  Future<void> delete(String id) async {
    _failIfRequested();
    final lengthBefore = _items.length;
    _items.removeWhere((item) => item.id == id);
    if (_items.length == lengthBefore) {
      throw StateError('QuoteTeamMember not found for delete: $id');
    }
  }

  void _failIfRequested() {
    if (!shouldFailOnNextOperation) {
      return;
    }
    shouldFailOnNextOperation = false;
    throw StateError('Simulated repository failure');
  }
}

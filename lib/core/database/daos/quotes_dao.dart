part of '../app_database.dart';

@DriftAccessor(
  tables: [
    Quotes,
    QuoteClientSnapshots,
    QuoteEventSnapshots,
    QuoteCompanySnapshots,
    QuoteLineItems,
    QuoteLinePackageComponents,
    QuoteStatusHistory,
    QuoteNumberSequences,
  ],
)
class QuotesDao extends DatabaseAccessor<AppDatabase> with _$QuotesDaoMixin {
  QuotesDao(super.db);

  Future<List<QuoteRow>> getAllQuotesOrdered() {
    return (select(quotes)..orderBy([
          (row) => OrderingTerm.asc(row.createdAt),
          (row) => OrderingTerm.asc(row.id),
        ]))
        .get();
  }

  Future<QuoteRow?> getQuoteById(String id) {
    return (select(quotes)..where((row) => row.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<QuoteClientSnapshotRow>> getAllClientSnapshots() {
    return select(quoteClientSnapshots).get();
  }

  Future<QuoteClientSnapshotRow?> getClientSnapshotByQuoteId(String quoteId) {
    return (select(
      quoteClientSnapshots,
    )..where((row) => row.quoteId.equals(quoteId))).getSingleOrNull();
  }

  Future<List<QuoteEventSnapshotRow>> getAllEventSnapshots() {
    return select(quoteEventSnapshots).get();
  }

  Future<QuoteEventSnapshotRow?> getEventSnapshotByQuoteId(String quoteId) {
    return (select(
      quoteEventSnapshots,
    )..where((row) => row.quoteId.equals(quoteId))).getSingleOrNull();
  }

  Future<List<QuoteCompanySnapshotRow>> getAllCompanySnapshots() {
    return select(quoteCompanySnapshots).get();
  }

  Future<QuoteCompanySnapshotRow?> getCompanySnapshotByQuoteId(
    String quoteId,
  ) {
    return (select(
      quoteCompanySnapshots,
    )..where((row) => row.quoteId.equals(quoteId))).getSingleOrNull();
  }

  Future<List<QuoteLineItemRow>> getAllLineItemsOrdered() {
    return (select(quoteLineItems)..orderBy([
          (row) => OrderingTerm.asc(row.quoteId),
          (row) => OrderingTerm.asc(row.sortOrder),
        ]))
        .get();
  }

  Future<List<QuoteLineItemRow>> getLineItemsByQuoteId(String quoteId) {
    return (select(quoteLineItems)
          ..where((row) => row.quoteId.equals(quoteId))
          ..orderBy([(row) => OrderingTerm.asc(row.sortOrder)]))
        .get();
  }

  Future<List<QuoteLinePackageComponentRow>>
  getAllPackageComponentsOrdered() {
    return (select(quoteLinePackageComponents)..orderBy([
          (row) => OrderingTerm.asc(row.lineItemId),
          (row) => OrderingTerm.asc(row.sortOrder),
        ]))
        .get();
  }

  Future<List<QuoteLinePackageComponentRow>> getPackageComponentsByLineItemIds(
    List<String> lineItemIds,
  ) {
    if (lineItemIds.isEmpty) {
      return Future.value(const []);
    }
    return (select(quoteLinePackageComponents)
          ..where((row) => row.lineItemId.isIn(lineItemIds))
          ..orderBy([(row) => OrderingTerm.asc(row.sortOrder)]))
        .get();
  }

  Future<List<QuoteStatusHistoryRow>> getAllStatusHistoryOrdered() {
    return (select(quoteStatusHistory)..orderBy([
          (row) => OrderingTerm.asc(row.quoteId),
          (row) => OrderingTerm.asc(row.sortOrder),
        ]))
        .get();
  }

  Future<List<QuoteStatusHistoryRow>> getStatusHistoryByQuoteId(
    String quoteId,
  ) {
    return (select(quoteStatusHistory)
          ..where((row) => row.quoteId.equals(quoteId))
          ..orderBy([(row) => OrderingTerm.asc(row.sortOrder)]))
        .get();
  }

  /// Reserves the next sequential number for [year] and inserts the full
  /// quote graph inside a single transaction. If any step fails, the whole
  /// transaction is rolled back, including the sequence reservation, so the
  /// sequence never advances on failure.
  Future<String> insertQuoteGraph({
    required int year,
    required QuotesCompanion quote,
    required QuoteClientSnapshotsCompanion clientSnapshot,
    required QuoteEventSnapshotsCompanion eventSnapshot,
    required QuoteCompanySnapshotsCompanion? companySnapshot,
    required List<QuoteLineItemsCompanion> lineItems,
    required List<QuoteLinePackageComponentsCompanion> packageComponents,
    required List<QuoteStatusHistoryCompanion> statusHistory,
  }) {
    return transaction(() async {
      final number = await _reserveNextNumber(year);

      await into(quotes).insert(quote.copyWith(number: Value(number)));
      await into(quoteClientSnapshots).insert(clientSnapshot);
      await into(quoteEventSnapshots).insert(eventSnapshot);
      if (companySnapshot != null) {
        await into(quoteCompanySnapshots).insert(companySnapshot);
      }
      for (final item in lineItems) {
        await into(quoteLineItems).insert(item);
      }
      for (final component in packageComponents) {
        await into(quoteLinePackageComponents).insert(component);
      }
      for (final entry in statusHistory) {
        await into(quoteStatusHistory).insert(entry);
      }

      return number;
    });
  }

  /// Replaces the full quote graph inside a single transaction, deleting and
  /// re-inserting the ephemeral child collections. Returns `false` (without
  /// writing anything) when the quote row does not exist.
  Future<bool> updateQuoteGraph({
    required String quoteId,
    required QuotesCompanion quote,
    required QuoteClientSnapshotsCompanion clientSnapshot,
    required QuoteEventSnapshotsCompanion eventSnapshot,
    required QuoteCompanySnapshotsCompanion? companySnapshot,
    required List<QuoteLineItemsCompanion> lineItems,
    required List<QuoteLinePackageComponentsCompanion> packageComponents,
    required List<QuoteStatusHistoryCompanion> statusHistory,
  }) {
    return transaction(() async {
      final updated = await update(quotes).replace(quote);
      if (!updated) {
        return false;
      }

      await into(
        quoteClientSnapshots,
      ).insertOnConflictUpdate(clientSnapshot);
      await into(quoteEventSnapshots).insertOnConflictUpdate(eventSnapshot);
      if (companySnapshot != null) {
        await into(
          quoteCompanySnapshots,
        ).insertOnConflictUpdate(companySnapshot);
      }

      await (delete(
        quoteLineItems,
      )..where((row) => row.quoteId.equals(quoteId))).go();
      for (final item in lineItems) {
        await into(quoteLineItems).insert(item);
      }
      for (final component in packageComponents) {
        await into(quoteLinePackageComponents).insert(component);
      }

      await (delete(
        quoteStatusHistory,
      )..where((row) => row.quoteId.equals(quoteId))).go();
      for (final entry in statusHistory) {
        await into(quoteStatusHistory).insert(entry);
      }

      return true;
    });
  }

  Future<String> _reserveNextNumber(int year) async {
    final existing = await (select(
      quoteNumberSequences,
    )..where((row) => row.year.equals(year))).getSingleOrNull();
    final nextSequence = (existing?.lastSequence ?? 0) + 1;

    await into(quoteNumberSequences).insertOnConflictUpdate(
      QuoteNumberSequencesCompanion.insert(
        year: Value(year),
        lastSequence: nextSequence,
      ),
    );

    return 'ORC-$year-${nextSequence.toString().padLeft(4, '0')}';
  }
}

import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/quotes/data/mappers/quote_mapper.dart';
import 'package:eventpro/features/quotes/data/repositories/quote_repository.dart';
import 'package:eventpro/features/quotes/models/quote.dart';

class DriftQuoteRepository implements QuoteRepository {
  DriftQuoteRepository(this._database);

  final AppDatabase _database;

  @override
  Future<List<Quote>> listAll() async {
    final quoteRows = await _database.quotesDao.getAllQuotesOrdered();
    final clientSnapshots = await _database.quotesDao.getAllClientSnapshots();
    final eventSnapshots = await _database.quotesDao.getAllEventSnapshots();
    final companySnapshots =
        await _database.quotesDao.getAllCompanySnapshots();
    final lineItems = await _database.quotesDao.getAllLineItemsOrdered();
    final packageComponents =
        await _database.quotesDao.getAllPackageComponentsOrdered();
    final statusHistory =
        await _database.quotesDao.getAllStatusHistoryOrdered();

    final clientByQuoteId = {
      for (final row in clientSnapshots) row.quoteId: row,
    };
    final eventByQuoteId = {
      for (final row in eventSnapshots) row.quoteId: row,
    };
    final companyByQuoteId = {
      for (final row in companySnapshots) row.quoteId: row,
    };

    final lineItemsByQuoteId = <String, List<QuoteLineItemRow>>{};
    for (final row in lineItems) {
      lineItemsByQuoteId.putIfAbsent(row.quoteId, () => []).add(row);
    }

    final componentsByLineItemId =
        <String, List<QuoteLinePackageComponentRow>>{};
    for (final row in packageComponents) {
      componentsByLineItemId.putIfAbsent(row.lineItemId, () => []).add(row);
    }

    final historyByQuoteId = <String, List<QuoteStatusHistoryRow>>{};
    for (final row in statusHistory) {
      historyByQuoteId.putIfAbsent(row.quoteId, () => []).add(row);
    }

    return quoteRows
        .map(
          (quoteRow) => QuoteMapper.toDomain(
            quote: quoteRow,
            clientSnapshot: clientByQuoteId[quoteRow.id]!,
            eventSnapshot: eventByQuoteId[quoteRow.id]!,
            companySnapshot: companyByQuoteId[quoteRow.id],
            lineItems: lineItemsByQuoteId[quoteRow.id] ?? const [],
            packageComponentsByLineItemId: componentsByLineItemId,
            statusHistory: historyByQuoteId[quoteRow.id] ?? const [],
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<Quote?> findById(String id) async {
    final quoteRow = await _database.quotesDao.getQuoteById(id);
    if (quoteRow == null) {
      return null;
    }

    final clientSnapshot = await _database.quotesDao
        .getClientSnapshotByQuoteId(id);
    final eventSnapshot = await _database.quotesDao.getEventSnapshotByQuoteId(
      id,
    );
    final companySnapshot = await _database.quotesDao
        .getCompanySnapshotByQuoteId(id);
    final lineItems = await _database.quotesDao.getLineItemsByQuoteId(id);
    final lineItemIds = lineItems.map((row) => row.id).toList();
    final packageComponents = await _database.quotesDao
        .getPackageComponentsByLineItemIds(lineItemIds);
    final statusHistory = await _database.quotesDao.getStatusHistoryByQuoteId(
      id,
    );

    final componentsByLineItemId =
        <String, List<QuoteLinePackageComponentRow>>{};
    for (final row in packageComponents) {
      componentsByLineItemId.putIfAbsent(row.lineItemId, () => []).add(row);
    }

    return QuoteMapper.toDomain(
      quote: quoteRow,
      clientSnapshot: clientSnapshot!,
      eventSnapshot: eventSnapshot!,
      companySnapshot: companySnapshot,
      lineItems: lineItems,
      packageComponentsByLineItemId: componentsByLineItemId,
      statusHistory: statusHistory,
    );
  }

  @override
  Future<Quote> insert(Quote quote) async {
    final lineItemIds = QuoteMapper.generateLineItemIds(quote.items.length);

    final number = await _database.quotesDao.insertQuoteGraph(
      year: quote.createdAt.year,
      quote: QuoteMapper.toQuoteCompanion(quote),
      clientSnapshot: QuoteMapper.toClientSnapshotCompanion(quote),
      eventSnapshot: QuoteMapper.toEventSnapshotCompanion(quote),
      companySnapshot: QuoteMapper.toCompanySnapshotCompanion(quote),
      lineItems: QuoteMapper.toLineItemCompanions(quote, lineItemIds),
      packageComponents: QuoteMapper.toPackageComponentCompanions(
        quote,
        lineItemIds,
      ),
      statusHistory: QuoteMapper.toStatusHistoryCompanions(quote),
    );

    return quote.copyWith(number: number);
  }

  @override
  Future<void> update(Quote quote) async {
    final lineItemIds = QuoteMapper.generateLineItemIds(quote.items.length);

    final updated = await _database.quotesDao.updateQuoteGraph(
      quoteId: quote.id,
      quote: QuoteMapper.toQuoteCompanion(quote),
      clientSnapshot: QuoteMapper.toClientSnapshotCompanion(quote),
      eventSnapshot: QuoteMapper.toEventSnapshotCompanion(quote),
      companySnapshot: QuoteMapper.toCompanySnapshotCompanion(quote),
      lineItems: QuoteMapper.toLineItemCompanions(quote, lineItemIds),
      packageComponents: QuoteMapper.toPackageComponentCompanions(
        quote,
        lineItemIds,
      ),
      statusHistory: QuoteMapper.toStatusHistoryCompanions(quote),
    );

    if (!updated) {
      throw StateError('Quote not found for update: ${quote.id}');
    }
  }
}

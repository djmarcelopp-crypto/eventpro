import 'dart:io';

import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/features/quotes/data/repositories/drift_quote_repository.dart';
import 'package:eventpro/features/quotes/models/quote.dart';
import 'package:eventpro/features/quotes/models/quote_client_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_client_type.dart';
import 'package:eventpro/features/quotes/models/quote_company_capture_status.dart';
import 'package:eventpro/features/quotes/models/quote_company_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_event_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_line_item.dart';
import 'package:eventpro/features/quotes/models/quote_package_component_snapshot.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/models/quote_status_history_entry.dart';
import 'package:flutter_test/flutter_test.dart';

Quote _buildQuote({
  required String id,
  DateTime? createdAt,
  List<QuoteLineItem>? items,
  QuoteCompanySnapshot? companySnapshot,
  QuoteStatus status = QuoteStatus.draft,
}) {
  final created = createdAt ?? DateTime(2026, 7, 13, 10, 0);
  return Quote(
    id: id,
    number: 'IGNORED',
    status: status,
    clientSnapshot: const QuoteClientSnapshot(
      sourceClientId: 'client-1',
      type: QuoteClientType.individual,
      displayName: 'Maria Silva',
      phone: '67999998888',
    ),
    eventSnapshot: const QuoteEventSnapshot(
      name: 'Casamento',
      guestCount: 100,
    ),
    items:
        items ??
        [
          QuoteLineItem(
            catalogItemId: 'item-1',
            name: 'Caixa de som',
            unit: 'Unidade',
            quantity: 2,
            unitPriceCents: 15000,
            lineTotalCents: 30000,
          ),
        ],
    subtotalCents: 30000,
    discountCents: 0,
    freightCents: 0,
    totalCents: 30000,
    statusHistory: [
      QuoteStatusHistoryEntry(
        previousStatus: null,
        newStatus: QuoteStatus.draft,
        changedAt: created,
      ),
    ],
    notes: 'Nota pública',
    internalNotes: 'Nota interna',
    companySnapshot: companySnapshot,
    createdAt: created,
    updatedAt: created,
  );
}

QuoteCompanySnapshot _companySnapshot() {
  return QuoteCompanySnapshot(
    identification: const QuoteCompanyIdentification(
      tradeName: 'DJ Marcelo PP',
      cnpjDigits: '11222333000181',
    ),
    contact: const QuoteCompanyContact(phoneDigits: '67999990000'),
    address: const QuoteCompanyAddress(city: 'Campo Grande', state: 'MS'),
    legalRepresentative: const QuoteCompanyLegalRepresentative(
      fullName: 'Marcelo PP',
      cpfDigits: '52998224725',
    ),
    payment: const QuoteCompanyPayment(beneficiaryName: 'DJ Marcelo PP'),
    captureStatus: QuoteCompanyCaptureStatus.configured,
    capturedAt: DateTime(2026, 7, 13, 9, 0),
  );
}

void main() {
  group('DriftQuoteRepository', () {
    late Directory tempDir;
    late File dbFile;
    late AppDatabase database;
    late DriftQuoteRepository repository;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('quote_repo_test_');
      dbFile = File('${tempDir.path}/eventpro.sqlite');
      database = AppDatabase.forTesting(dbFile);
      repository = DriftQuoteRepository(database);
    });

    tearDown(() async {
      await database.close();
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    });

    test('insert atribui número sequencial ORC-AAAA-NNNN e persiste o grafo', () async {
      final first = await repository.insert(_buildQuote(id: 'quote-1'));
      final second = await repository.insert(_buildQuote(id: 'quote-2'));

      expect(first.number, 'ORC-2026-0001');
      expect(second.number, 'ORC-2026-0002');

      final loaded = await repository.findById('quote-1');
      expect(loaded?.number, 'ORC-2026-0001');
      expect(loaded?.clientSnapshot.displayName, 'Maria Silva');
      expect(loaded?.eventSnapshot.name, 'Casamento');
      expect(loaded?.items.single.name, 'Caixa de som');
      expect(loaded?.statusHistory, hasLength(1));
    });

    test('sequência reinicia por ano', () async {
      final quote2025 = await repository.insert(
        _buildQuote(id: 'quote-2025', createdAt: DateTime(2025, 12, 31)),
      );
      final quote2026a = await repository.insert(
        _buildQuote(id: 'quote-2026-a', createdAt: DateTime(2026, 1, 1)),
      );
      final quote2026b = await repository.insert(
        _buildQuote(id: 'quote-2026-b', createdAt: DateTime(2026, 5, 1)),
      );

      expect(quote2025.number, 'ORC-2025-0001');
      expect(quote2026a.number, 'ORC-2026-0001');
      expect(quote2026b.number, 'ORC-2026-0002');
    });

    test('listAll retorna orçamentos ordenados com grafo completo', () async {
      await repository.insert(
        _buildQuote(id: 'quote-a', createdAt: DateTime(2026, 1, 1)),
      );
      await repository.insert(
        _buildQuote(id: 'quote-b', createdAt: DateTime(2026, 1, 2)),
      );

      final all = await repository.listAll();

      expect(all.map((quote) => quote.id).toList(), ['quote-a', 'quote-b']);
      expect(all.every((quote) => quote.items.isNotEmpty), isTrue);
    });

    test('insert e leitura de pacote persistem componentes atomicamente', () async {
      final quote = _buildQuote(
        id: 'quote-pkg',
        items: [
          QuoteLineItem(
            name: 'Pacote Festa',
            unit: 'pacote',
            quantity: 1,
            unitPriceCents: 90000,
            lineTotalCents: 90000,
            packageComponents: const [
              QuotePackageComponentSnapshot(
                catalogItemId: 'component-1',
                name: 'Caixa',
                unit: 'un',
                typeLabel: 'Equipamento',
                categoryLabel: 'Som',
                quantityPerPackage: 2,
              ),
              QuotePackageComponentSnapshot(
                catalogItemId: 'component-2',
                name: 'Mesa de som',
                unit: 'un',
                typeLabel: 'Equipamento',
                categoryLabel: 'Som',
                quantityPerPackage: 1,
              ),
            ],
          ),
        ],
      );

      await repository.insert(quote);

      final loaded = await repository.findById('quote-pkg');
      expect(loaded?.items.single.isPackageLine, isTrue);
      expect(loaded?.items.single.packageComponents, hasLength(2));
      expect(
        loaded?.items.single.packageComponents!.map((c) => c.catalogItemId),
        ['component-1', 'component-2'],
      );
    });

    test('insert persiste companySnapshot completo com representante e pagamento', () async {
      final quote = _buildQuote(
        id: 'quote-company',
        companySnapshot: _companySnapshot(),
      );

      await repository.insert(quote);

      final loaded = await repository.findById('quote-company');
      expect(loaded?.companySnapshot, isNotNull);
      expect(
        loaded?.companySnapshot!.legalRepresentative?.fullName,
        'Marcelo PP',
      );
      expect(loaded?.companySnapshot!.payment?.beneficiaryName, 'DJ Marcelo PP');
    });

    test('insert sem companySnapshot mantém null na leitura', () async {
      await repository.insert(_buildQuote(id: 'quote-no-company'));

      final loaded = await repository.findById('quote-no-company');
      expect(loaded?.companySnapshot, isNull);
    });

    test('update substitui linhas, histórico e snapshots preservando id/number/createdAt', () async {
      final inserted = await repository.insert(_buildQuote(id: 'quote-upd'));

      final updated = inserted.copyWith(
        clientSnapshot: const QuoteClientSnapshot(
          type: QuoteClientType.individual,
          displayName: 'Cliente Atualizado',
        ),
        items: [
          QuoteLineItem(
            name: 'Novo item',
            unit: 'un',
            quantity: 1,
            unitPriceCents: 1000,
            lineTotalCents: 1000,
          ),
          QuoteLineItem(
            name: 'Segundo item',
            unit: 'un',
            quantity: 2,
            unitPriceCents: 2000,
            lineTotalCents: 4000,
          ),
        ],
        statusHistory: [
          ...inserted.statusHistory,
          QuoteStatusHistoryEntry(
            previousStatus: QuoteStatus.draft,
            newStatus: QuoteStatus.sent,
            changedAt: DateTime(2026, 7, 14),
          ),
        ],
        notes: 'Atualizado',
      );

      await repository.update(updated);

      final loaded = await repository.findById('quote-upd');
      expect(loaded?.id, inserted.id);
      expect(loaded?.number, inserted.number);
      expect(loaded?.createdAt, inserted.createdAt);
      expect(loaded?.clientSnapshot.displayName, 'Cliente Atualizado');
      expect(loaded?.items, hasLength(2));
      expect(loaded?.items.map((i) => i.name).toList(), [
        'Novo item',
        'Segundo item',
      ]);
      expect(loaded?.statusHistory, hasLength(2));
      expect(loaded?.notes, 'Atualizado');
    });

    test('update de orçamento inexistente lança StateError sem persistir nada', () async {
      final ghost = _buildQuote(id: 'missing');

      await expectLater(
        repository.update(ghost),
        throwsA(isA<StateError>()),
      );

      expect(await repository.findById('missing'), isNull);
    });

    test(
      'falha na inserção não avança a sequência nem deixa linhas parciais',
      () async {
        final first = await repository.insert(_buildQuote(id: 'quote-dup'));
        expect(first.number, 'ORC-2026-0001');

        // A segunda tentativa reutiliza o mesmo id de orçamento (violação de
        // PK) para forçar falha após a reserva do número na transação.
        await expectLater(
          repository.insert(_buildQuote(id: 'quote-dup')),
          throwsA(anything),
        );

        final sequenceRow = await (database.select(
          database.quoteNumberSequences,
        )..where((row) => row.year.equals(2026))).getSingle();
        expect(sequenceRow.lastSequence, 1);

        final quotes = await database.select(database.quotes).get();
        expect(quotes, hasLength(1));
        expect(quotes.single.number, 'ORC-2026-0001');

        final nextInsert = await repository.insert(
          _buildQuote(id: 'quote-after-failure'),
        );
        expect(nextInsert.number, 'ORC-2026-0002');
      },
    );

    test('close and reopen database preserva orçamentos e sequência', () async {
      await repository.insert(_buildQuote(id: 'quote-persist'));
      await database.close();

      final reopenedDb = AppDatabase.forTesting(dbFile);
      addTearDown(reopenedDb.close);
      final reopenedRepository = DriftQuoteRepository(reopenedDb);

      final quotes = await reopenedRepository.listAll();
      expect(quotes, hasLength(1));
      expect(quotes.single.number, 'ORC-2026-0001');

      final next = await reopenedRepository.insert(
        _buildQuote(id: 'quote-after-reopen'),
      );
      expect(next.number, 'ORC-2026-0002');
    });
  });
}

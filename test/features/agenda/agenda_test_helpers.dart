import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:eventpro/features/agenda/agenda_block_detail_screen.dart';
import 'package:eventpro/features/agenda/agenda_screen.dart';
import 'package:eventpro/features/agenda/data/repositories/agenda_block_repository.dart';
import 'package:eventpro/features/agenda/models/agenda_block.dart';
import 'package:eventpro/features/agenda/new_agenda_block_screen.dart';
import 'package:eventpro/features/agenda/providers/agenda_blocks_provider.dart';
import 'package:eventpro/features/quotes/models/quote.dart';
import 'package:eventpro/features/quotes/providers/quotes_provider.dart';
import 'package:eventpro/main.dart';

import 'fakes/agenda_block_repository_test_overrides.dart';
import 'fakes/fake_agenda_block_repository.dart';

const _locale = Locale('pt', 'BR');

/// Builds a [ProviderContainer] with quotes and agenda blocks hydrated, and
/// pumps a minimal router covering `/agenda`, `/agenda/new`, `/agenda/:id`,
/// `/agenda/:id/edit` plus a placeholder `/quotes/:id` route (isolated from
/// the real [QuoteDetailScreen] dependencies, which are out of scope here).
Future<ProviderContainer> pumpAgendaApp(
  WidgetTester tester, {
  List<Quote> quotes = const [],
  List<AgendaBlock> blocks = const [],
  String initialLocation = '/agenda',
  AgendaBlockRepository? repository,
  List<Override> extraOverrides = const [],
  bool hydrateBlocks = true,
  bool settleAfterPump = true,
}) async {
  final container = ProviderContainer(
    overrides: [
      ...agendaBlockRepositoryOverrides(
        repository: repository ?? FakeAgendaBlockRepository(
          initialBlocks: blocks,
        ),
      ),
      ...extraOverrides,
    ],
  );
  addTearDown(container.dispose);

  container.read(quotesProvider.notifier).hydrate(quotes);
  if (hydrateBlocks) {
    await container.read(agendaBlocksProvider.future);
    container.read(agendaBlocksProvider.notifier).hydrate(blocks);
  }

  final router = GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(
        path: '/agenda',
        builder: (context, state) => const AgendaScreen(),
        routes: [
          GoRoute(
            path: 'new',
            builder: (context, state) => const NewAgendaBlockScreen(),
          ),
          GoRoute(
            path: ':id',
            builder: (context, state) => AgendaBlockDetailScreen(
              blockId: state.pathParameters['id']!,
            ),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) => NewAgendaBlockScreen(
                  blockId: state.pathParameters['id'],
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/quotes/:id',
        builder: (context, state) => Scaffold(
          body: Text('quote-detail-${state.pathParameters['id']}'),
        ),
      ),
    ],
  );

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        scaffoldMessengerKey: EventProApp.scaffoldMessengerKey,
        routerConfig: router,
        locale: _locale,
        supportedLocales: const [_locale],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
      ),
    ),
  );

  if (settleAfterPump) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
  return container;
}

/// Fills the title (and optional notes) fields, then drives the start/end
/// date and time pickers by accepting their pre-selected defaults (tapping
/// "OK" twice per field), mirroring the pattern already used for the
/// client's birthday picker.
Future<void> fillAgendaBlockForm(
  WidgetTester tester, {
  required String title,
  String? notes,
}) async {
  await tester.enterText(
    find.byKey(const Key('agenda_block_title_field')),
    title,
  );
  if (notes != null) {
    await tester.enterText(
      find.byKey(const Key('agenda_block_notes_field')),
      notes,
    );
  }
  await tester.pumpAndSettle();

  await _pickDefault(tester, const Key('agenda_block_start_field'));
  await _pickDefault(tester, const Key('agenda_block_end_field'));
}

Future<void> _pickDefault(WidgetTester tester, Key fieldKey) async {
  await tester.tap(find.byKey(fieldKey));
  await tester.pumpAndSettle();
  expect(find.byType(DatePickerDialog), findsOneWidget);
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
  expect(find.byType(TimePickerDialog), findsOneWidget);
  await tester.tap(find.text('OK'));
  await tester.pumpAndSettle();
}

Future<void> tapAgendaSaveButton(WidgetTester tester) async {
  final saveButton = find.byKey(const Key('agenda_block_save_button'));
  await tester.ensureVisible(saveButton);
  await tester.pumpAndSettle();
  await tester.tap(saveButton);
  await tester.pumpAndSettle();
}

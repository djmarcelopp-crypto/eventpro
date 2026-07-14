import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/app/router/app_router.dart';
import 'package:eventpro/features/catalog/providers/catalog_provider.dart';
import 'package:eventpro/features/clients/providers/clients_provider.dart';
import 'package:eventpro/features/quotes/models/quote.dart';
import 'package:eventpro/features/quotes/models/quote_status.dart';
import 'package:eventpro/features/quotes/providers/quote_clock_provider.dart';
import 'package:eventpro/features/quotes/providers/quotes_provider.dart';
import 'package:eventpro/main.dart';

import 'quotes_test_helpers.dart';

final quoteE2eFixedNow = DateTime(2026, 7, 13, 10, 30);

class QuoteE2eMutableClock {
  QuoteE2eMutableClock(this.now);

  DateTime now;
}

List<Override> quoteE2eOverrides({
  List<Override> extra = const [],
  QuoteE2eMutableClock? mutableClock,
}) {
  return [
    quoteClockProvider.overrideWithValue(
      () => mutableClock?.now ?? quoteE2eFixedNow,
    ),
    ...extra,
  ];
}

Future<void> pumpQuoteAppWithContainer(
  WidgetTester tester,
) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: quoteE2eOverrides(),
      child: const EventProApp(),
    ),
  );
  await tester.pumpAndSettle();
}

ProviderContainer quoteTestContainer(WidgetTester tester) {
  return ProviderScope.containerOf(
    tester.element(find.byType(EventProApp)),
  );
}

Future<ProviderContainer> pumpQuoteAppSeeded(
  WidgetTester tester,
  Quote draft, {
  String? location,
}) async {
  await pumpQuoteAppWithContainer(tester);
  final container = quoteTestContainer(tester);
  seedQuote(container, draft);
  if (location != null) {
    AppRouter.router.go(location);
    await tester.pumpAndSettle();
  }
  return container;
}

void seedQuoteDependencies(ProviderContainer container) {
  container.read(clientsProvider.notifier).addClient(sampleClient());
  container.read(catalogProvider.notifier).addItem(sampleCatalogItem());
}

Quote seedQuote(
  ProviderContainer container,
  Quote draft,
) {
  seedQuoteDependencies(container);
  container.read(quotesProvider.notifier).addQuote(draft);
  return container.read(quotesProvider.notifier).findById(draft.id)!;
}

void useTallViewport(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 2400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

Future<void> scrollQuoteDetailUntilVisible(
  WidgetTester tester,
  Finder finder,
) async {
  final scrollView = find.byKey(const Key('quote_detail_scroll'));
  for (var attempt = 0; attempt < 12; attempt++) {
    if (finder.evaluate().isNotEmpty) {
      try {
        await tester.ensureVisible(finder);
        await tester.pumpAndSettle();
        return;
      } on FlutterError {
        // Keep scrolling.
      }
    }
    await tester.drag(scrollView, const Offset(0, -250));
    await tester.pumpAndSettle();
  }

  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
}

Future<void> expandQuoteStatusHistory(WidgetTester tester) async {
  final toggle = find.byKey(const Key('quote_status_history_toggle'));
  await scrollQuoteDetailUntilVisible(tester, toggle);
  await tester.tap(toggle);
  await tester.pumpAndSettle();
}

Future<void> scrollQuoteFormUntilVisible(
  WidgetTester tester,
  Finder finder,
) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
}

Future<void> tapQuoteSave(WidgetTester tester) async {
  final saveButton = find.byKey(const Key('quote_save_button'));
  await scrollQuoteFormUntilVisible(tester, saveButton);
  await tester.tap(saveButton);
  await tester.pumpAndSettle();
}

Future<void> confirmQuoteStatusDialog(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('quote_status_dialog_confirm')));
  await tester.pump();
  await tester.pump();
  await tester.pumpAndSettle();
}

Future<void> cancelQuoteStatusDialog(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('quote_status_dialog_cancel')));
  await tester.pumpAndSettle();
}

Future<void> openQuoteDetailFromList(
  WidgetTester tester,
  String quoteId,
) async {
  await tester.tap(find.byKey(Key('quote_list_item_tap_$quoteId')));
  await tester.pumpAndSettle();
  expect(find.byKey(const Key('quote_detail_scroll')), findsOneWidget);
}

Future<void> openQuoteEditFromDetail(WidgetTester tester) async {
  await scrollQuoteDetailUntilVisible(
    tester,
    find.byKey(const Key('quote_detail_edit_button')),
  );
  await tester.tap(find.byKey(const Key('quote_detail_edit_button')));
  await tester.pumpAndSettle();
}

Quote transitionQuoteTo(
  ProviderContainer container,
  String quoteId,
  QuoteStatus target,
) {
  container.read(quotesProvider.notifier).transitionStatus(quoteId, target);
  return container.read(quotesProvider.notifier).findById(quoteId)!;
}

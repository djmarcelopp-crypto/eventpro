import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../quote_list_feedback.dart';

abstract class QuotesNavigation {
  static void leaveQuotes(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.go(AppRoutes.dashboard);
  }

  static void leaveQuoteDetail(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.go(AppRoutes.quotes);
  }

  static void leaveQuotePdf(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.go(AppRoutes.quotes);
  }

  static void popToQuoteDetail(
    BuildContext context,
    String quoteId, {
    bool showUpdatedFeedback = false,
  }) {
    final router = GoRouter.of(context);
    final target = AppRoutes.quotesDetail(quoteId);

    while (context.canPop()) {
      if (router.state.matchedLocation == target) {
        break;
      }
      context.pop();
    }

    if (showUpdatedFeedback) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        QuoteListFeedbackPresenter.showSnackBar(QuoteListFeedback.updated);
      });
    }
  }
}

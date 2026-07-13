import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../catalog_list_feedback.dart';

abstract class CatalogNavigation {
  static void popToCatalogList(
    BuildContext context, {
    bool showUpdatedFeedback = false,
  }) {
    final router = GoRouter.of(context);

    while (context.canPop()) {
      if (router.state.matchedLocation == AppRoutes.catalog) {
        break;
      }
      context.pop();
    }

    if (showUpdatedFeedback) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        CatalogListFeedbackPresenter.showSnackBar(CatalogListFeedback.updated);
      });
    }
  }

  static void leaveCatalog(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.go(AppRoutes.dashboard);
  }
}

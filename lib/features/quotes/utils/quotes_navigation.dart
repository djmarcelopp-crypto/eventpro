import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';

abstract class QuotesNavigation {
  static void leaveQuotes(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.go(AppRoutes.dashboard);
  }
}

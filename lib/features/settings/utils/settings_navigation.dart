import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_router.dart';
import '../settings_feedback.dart';

abstract class SettingsNavigation {
  static void leaveSettings(BuildContext context) {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.go(AppRoutes.dashboard);
  }

  static void leaveCompanyProfile(
    BuildContext context, {
    bool showSavedFeedback = false,
  }) {
    if (context.canPop()) {
      context.pop();
      if (showSavedFeedback) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          SettingsFeedbackPresenter.showSnackBar(SettingsFeedback.saved);
        });
      }
      return;
    }

    context.go(AppRoutes.settings);
    if (showSavedFeedback) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        SettingsFeedbackPresenter.showSnackBar(SettingsFeedback.saved);
      });
    }
  }
}

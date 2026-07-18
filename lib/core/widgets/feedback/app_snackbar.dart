import 'package:flutter/material.dart';

import '../../../main.dart';
import '../../theme/app_colors.dart';

enum AppSnackbarTone { success, warning, info, error }

/// Centralized snackbar feedback for the whole app.
abstract class AppSnackbar {
  static void show(
    String message, {
    AppSnackbarTone tone = AppSnackbarTone.info,
  }) {
    final messenger = EventProApp.scaffoldMessengerKey.currentState;
    if (messenger == null) return;

    final background = switch (tone) {
      AppSnackbarTone.success => AppColors.success,
      AppSnackbarTone.warning => AppColors.warning,
      AppSnackbarTone.info => null,
      AppSnackbarTone.error => AppColors.error,
    };

    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: background,
      ),
    );
  }

  static void success(String message) =>
      show(message, tone: AppSnackbarTone.success);

  static void warning(String message) =>
      show(message, tone: AppSnackbarTone.warning);

  static void error(String message) =>
      show(message, tone: AppSnackbarTone.error);
}

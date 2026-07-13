import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../main.dart';

enum CatalogListFeedback {
  created,
  updated,
}

abstract class CatalogListFeedbackPresenter {
  static String message(CatalogListFeedback feedback) {
    return switch (feedback) {
      CatalogListFeedback.created => 'Item cadastrado com sucesso',
      CatalogListFeedback.updated => 'Item atualizado com sucesso',
    };
  }

  static void showSnackBar(
    CatalogListFeedback feedback, {
    int retryCount = 0,
  }) {
    final messenger = EventProApp.scaffoldMessengerKey.currentState;
    if (messenger == null) {
      if (retryCount >= 5) {
        return;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        showSnackBar(feedback, retryCount: retryCount + 1);
      });
      return;
    }

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message(feedback),
            style: const TextStyle(color: AppColors.white),
          ),
          backgroundColor: AppColors.success,
        ),
      );
  }
}

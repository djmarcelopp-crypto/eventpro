import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../main.dart';

enum QuoteListFeedback {
  saved,
}

abstract class QuoteListFeedbackPresenter {
  static String message(QuoteListFeedback feedback) {
    return switch (feedback) {
      QuoteListFeedback.saved => 'Orçamento salvo como rascunho',
    };
  }

  static void showSnackBar(
    QuoteListFeedback feedback, {
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

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../main.dart';

enum CatalogListFeedback {
  created,
}

abstract class CatalogListFeedbackPresenter {
  static String message(CatalogListFeedback feedback) {
    return switch (feedback) {
      CatalogListFeedback.created => 'Item cadastrado com sucesso',
    };
  }

  static void showSnackBar(CatalogListFeedback feedback) {
    EventProApp.scaffoldMessengerKey.currentState?.showSnackBar(
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

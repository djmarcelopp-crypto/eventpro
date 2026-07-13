import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../main.dart';

enum SettingsFeedback {
  saved,
}

abstract class SettingsFeedbackPresenter {
  static String message(SettingsFeedback feedback) {
    return switch (feedback) {
      SettingsFeedback.saved => 'Dados da empresa salvos com sucesso',
    };
  }

  static void showSnackBar(SettingsFeedback feedback) {
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

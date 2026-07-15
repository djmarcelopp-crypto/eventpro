import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../main.dart';

enum SettingsFeedback { saved }

enum SettingsErrorFeedback { save }

abstract class SettingsFeedbackPresenter {
  static String message(SettingsFeedback feedback) {
    return switch (feedback) {
      SettingsFeedback.saved => 'Dados da empresa salvos com sucesso',
    };
  }

  static String errorMessage(SettingsErrorFeedback feedback) {
    return switch (feedback) {
      SettingsErrorFeedback.save =>
        'Não foi possível salvar os dados da empresa. Tente novamente.',
    };
  }

  static void showSnackBar(SettingsFeedback feedback) {
    _showMessage(
      message: message(feedback),
      backgroundColor: AppColors.success,
    );
  }

  static void showErrorSnackBar(SettingsErrorFeedback feedback) {
    _showMessage(
      message: errorMessage(feedback),
      backgroundColor: AppColors.error,
    );
  }

  static void _showMessage({
    required String message,
    required Color backgroundColor,
  }) {
    EventProApp.scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: AppColors.white)),
        backgroundColor: backgroundColor,
      ),
    );
  }
}

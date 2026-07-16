import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../main.dart';

enum AgendaBlockFeedback { created, updated, deleted }

enum AgendaBlockErrorFeedback { save, delete }

abstract class AgendaBlockFeedbackPresenter {
  static String message(AgendaBlockFeedback feedback) {
    return switch (feedback) {
      AgendaBlockFeedback.created => 'Bloqueio criado com sucesso',
      AgendaBlockFeedback.updated => 'Bloqueio atualizado com sucesso',
      AgendaBlockFeedback.deleted => 'Bloqueio excluído com sucesso',
    };
  }

  static String errorMessage(AgendaBlockErrorFeedback feedback) {
    return switch (feedback) {
      AgendaBlockErrorFeedback.save =>
        'Não foi possível salvar o bloqueio. Tente novamente.',
      AgendaBlockErrorFeedback.delete =>
        'Não foi possível excluir o bloqueio. Tente novamente.',
    };
  }

  static void showSnackBar(AgendaBlockFeedback feedback) {
    _showMessage(
      message: message(feedback),
      backgroundColor: AppColors.success,
    );
  }

  static void showErrorSnackBar(AgendaBlockErrorFeedback feedback) {
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

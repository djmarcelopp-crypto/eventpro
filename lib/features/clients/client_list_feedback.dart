import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../main.dart';

enum ClientListFeedback { created, updated, deleted }

enum ClientListErrorFeedback { save, delete }

abstract class ClientListFeedbackPresenter {
  static String message(ClientListFeedback feedback) {
    return switch (feedback) {
      ClientListFeedback.created => 'Cliente cadastrado com sucesso',
      ClientListFeedback.updated => 'Cliente atualizado com sucesso',
      ClientListFeedback.deleted => 'Cliente excluído com sucesso',
    };
  }

  static String errorMessage(ClientListErrorFeedback feedback) {
    return switch (feedback) {
      ClientListErrorFeedback.save =>
        'Não foi possível salvar o cliente. Tente novamente.',
      ClientListErrorFeedback.delete =>
        'Não foi possível excluir o cliente. Tente novamente.',
    };
  }

  static void showSnackBar(ClientListFeedback feedback) {
    _showMessage(
      message: message(feedback),
      backgroundColor: AppColors.success,
    );
  }

  static void showErrorSnackBar(ClientListErrorFeedback feedback) {
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

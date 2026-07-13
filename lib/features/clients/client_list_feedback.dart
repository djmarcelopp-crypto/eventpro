import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../main.dart';

enum ClientListFeedback {
  created,
  updated,
  deleted,
}

abstract class ClientListFeedbackPresenter {
  static String message(ClientListFeedback feedback) {
    return switch (feedback) {
      ClientListFeedback.created => 'Cliente cadastrado com sucesso',
      ClientListFeedback.updated => 'Cliente atualizado com sucesso',
      ClientListFeedback.deleted => 'Cliente excluído com sucesso',
    };
  }

  static void showSnackBar(ClientListFeedback feedback) {
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

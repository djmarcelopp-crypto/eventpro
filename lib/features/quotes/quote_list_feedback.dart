import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../main.dart';

enum QuoteListFeedback {
  saved,
  updated,
  markedAsSent,
  approved,
  rejected,
  cancelled,
  reopenedForEditing,
  statusChangeFailed,
}

abstract class QuoteListFeedbackPresenter {
  static String message(QuoteListFeedback feedback) {
    return switch (feedback) {
      QuoteListFeedback.saved => 'Orçamento salvo como rascunho',
      QuoteListFeedback.updated => 'Orçamento atualizado com sucesso',
      QuoteListFeedback.markedAsSent => 'Orçamento marcado como enviado',
      QuoteListFeedback.approved => 'Orçamento aprovado',
      QuoteListFeedback.rejected => 'Orçamento recusado',
      QuoteListFeedback.cancelled => 'Orçamento cancelado',
      QuoteListFeedback.reopenedForEditing =>
        'Orçamento reaberto para edição',
      QuoteListFeedback.statusChangeFailed =>
        'Esta alteração de status não é permitida',
    };
  }

  static Color backgroundColor(QuoteListFeedback feedback) {
    return switch (feedback) {
      QuoteListFeedback.statusChangeFailed => AppColors.error,
      _ => AppColors.success,
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
          backgroundColor: backgroundColor(feedback),
        ),
      );
  }
}

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../main.dart';
import 'models/financial_category_delete_result.dart';
import 'models/financial_category_write_result.dart';
import 'models/financial_entry_delete_result.dart';
import 'models/financial_entry_write_result.dart';

enum FinancialFeedback {
  entryCreated,
  entryUpdated,
  entryDeleted,
  categoryCreated,
  categoryUpdated,
  categoryDeleted,
}

abstract class FinancialFeedbackPresenter {
  static String message(FinancialFeedback feedback) {
    return switch (feedback) {
      FinancialFeedback.entryCreated => 'Lançamento criado com sucesso',
      FinancialFeedback.entryUpdated => 'Lançamento atualizado com sucesso',
      FinancialFeedback.entryDeleted => 'Lançamento excluído com sucesso',
      FinancialFeedback.categoryCreated => 'Categoria criada com sucesso',
      FinancialFeedback.categoryUpdated => 'Categoria atualizada com sucesso',
      FinancialFeedback.categoryDeleted => 'Categoria excluída com sucesso',
    };
  }

  static String entryWriteError(FinancialEntryWriteResult result) {
    return switch (result.status) {
      FinancialEntryWriteStatus.validationFailed => result.errors.isEmpty
          ? 'Verifique os campos do lançamento.'
          : result.errors.first,
      FinancialEntryWriteStatus.categoryNotFound =>
        'Categoria não encontrada. Escolha outra categoria.',
      FinancialEntryWriteStatus.categoryInactive =>
        'A categoria selecionada está inativa.',
      FinancialEntryWriteStatus.categoryKindMismatch =>
        'A categoria não é compatível com o tipo do lançamento.',
      FinancialEntryWriteStatus.notFound => 'Lançamento não encontrado.',
      FinancialEntryWriteStatus.failure =>
        'Não foi possível salvar o lançamento. Tente novamente.',
      FinancialEntryWriteStatus.success => '',
    };
  }

  static String entryDeleteError(FinancialEntryDeleteResult result) {
    return switch (result.status) {
      FinancialEntryDeleteStatus.notFound => 'Lançamento não encontrado.',
      FinancialEntryDeleteStatus.failure =>
        'Não foi possível excluir o lançamento. Tente novamente.',
      FinancialEntryDeleteStatus.deleted => '',
    };
  }

  static String categoryWriteError(FinancialCategoryWriteResult result) {
    return switch (result.status) {
      FinancialCategoryWriteStatus.validationFailed => result.errors.isEmpty
          ? 'Verifique o nome da categoria.'
          : result.errors.first,
      FinancialCategoryWriteStatus.notFound => 'Categoria não encontrada.',
      FinancialCategoryWriteStatus.failure =>
        'Não foi possível salvar a categoria. Tente novamente.',
      FinancialCategoryWriteStatus.success => '',
    };
  }

  static String categoryDeleteError(FinancialCategoryDeleteResult result) {
    return switch (result.status) {
      FinancialCategoryDeleteStatus.notFound => 'Categoria não encontrada.',
      FinancialCategoryDeleteStatus.blockedByUsage =>
        'Categoria em uso por ${result.blockingEntryCount} '
            '${result.blockingEntryCount == 1 ? 'lançamento' : 'lançamentos'}.',
      FinancialCategoryDeleteStatus.failure =>
        'Não foi possível excluir a categoria. Tente novamente.',
      FinancialCategoryDeleteStatus.deleted => '',
    };
  }

  static void showSnackBar(FinancialFeedback feedback) {
    _show(message: message(feedback), backgroundColor: AppColors.success);
  }

  static void showError(String message) {
    _show(message: message, backgroundColor: AppColors.error);
  }

  static void _show({
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

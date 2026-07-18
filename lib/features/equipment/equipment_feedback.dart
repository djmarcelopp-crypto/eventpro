import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../main.dart';
import 'models/equipment_category_delete_result.dart';
import 'models/equipment_category_write_result.dart';
import 'models/equipment_delete_result.dart';
import 'models/equipment_write_result.dart';
import 'models/quote_equipment_delete_result.dart';
import 'models/quote_equipment_write_result.dart';

enum EquipmentFeedback {
  equipmentCreated,
  equipmentUpdated,
  equipmentDeleted,
  categoryCreated,
  categoryUpdated,
  categoryDeleted,
  quoteEquipmentAdded,
  quoteEquipmentUpdated,
  quoteEquipmentRemoved,
}

abstract class EquipmentFeedbackPresenter {
  static String message(EquipmentFeedback feedback) {
    return switch (feedback) {
      EquipmentFeedback.equipmentCreated => 'Equipamento criado com sucesso',
      EquipmentFeedback.equipmentUpdated =>
        'Equipamento atualizado com sucesso',
      EquipmentFeedback.equipmentDeleted => 'Equipamento excluído com sucesso',
      EquipmentFeedback.categoryCreated => 'Categoria criada com sucesso',
      EquipmentFeedback.categoryUpdated => 'Categoria atualizada com sucesso',
      EquipmentFeedback.categoryDeleted => 'Categoria excluída com sucesso',
      EquipmentFeedback.quoteEquipmentAdded =>
        'Equipamento adicionado ao orçamento',
      EquipmentFeedback.quoteEquipmentUpdated =>
        'Quantidade atualizada com sucesso',
      EquipmentFeedback.quoteEquipmentRemoved =>
        'Equipamento removido do orçamento',
    };
  }

  static String equipmentWriteError(EquipmentWriteResult result) {
    return switch (result.status) {
      EquipmentWriteStatus.validationFailed => result.errors.isEmpty
          ? 'Verifique os campos do equipamento.'
          : result.errors.first,
      EquipmentWriteStatus.categoryNotFound =>
        'Categoria não encontrada. Escolha outra categoria.',
      EquipmentWriteStatus.categoryInactive =>
        'A categoria selecionada está inativa.',
      EquipmentWriteStatus.notFound => 'Equipamento não encontrado.',
      EquipmentWriteStatus.failure =>
        'Não foi possível salvar o equipamento. Tente novamente.',
      EquipmentWriteStatus.success => '',
    };
  }

  static String equipmentDeleteError(EquipmentDeleteResult result) {
    return switch (result.status) {
      EquipmentDeleteStatus.notFound => 'Equipamento não encontrado.',
      EquipmentDeleteStatus.failure =>
        'Não foi possível excluir o equipamento. Tente novamente.',
      EquipmentDeleteStatus.deleted => '',
    };
  }

  static String categoryWriteError(EquipmentCategoryWriteResult result) {
    return switch (result.status) {
      EquipmentCategoryWriteStatus.validationFailed => result.errors.isEmpty
          ? 'Verifique o nome da categoria.'
          : result.errors.first,
      EquipmentCategoryWriteStatus.notFound => 'Categoria não encontrada.',
      EquipmentCategoryWriteStatus.failure =>
        'Não foi possível salvar a categoria. Tente novamente.',
      EquipmentCategoryWriteStatus.success => '',
    };
  }

  static String categoryDeleteError(EquipmentCategoryDeleteResult result) {
    return switch (result.status) {
      EquipmentCategoryDeleteStatus.notFound => 'Categoria não encontrada.',
      EquipmentCategoryDeleteStatus.blockedByUsage =>
        'Categoria em uso por ${result.blockingEquipmentCount} '
            '${result.blockingEquipmentCount == 1 ? 'equipamento' : 'equipamentos'}.',
      EquipmentCategoryDeleteStatus.failure =>
        'Não foi possível excluir a categoria. Tente novamente.',
      EquipmentCategoryDeleteStatus.deleted => '',
    };
  }

  static String quoteEquipmentWriteError(QuoteEquipmentWriteResult result) {
    return switch (result.status) {
      QuoteEquipmentWriteStatus.validationFailed => result.errors.isEmpty
          ? 'Verifique a quantidade informada.'
          : result.errors.first,
      QuoteEquipmentWriteStatus.quoteNotFound => 'Orçamento não encontrado.',
      QuoteEquipmentWriteStatus.equipmentNotFound =>
        'Equipamento não encontrado.',
      QuoteEquipmentWriteStatus.notFound =>
        'Vínculo de equipamento não encontrado.',
      QuoteEquipmentWriteStatus.failure =>
        'Não foi possível salvar o vínculo. Tente novamente.',
      QuoteEquipmentWriteStatus.success => '',
    };
  }

  static String quoteEquipmentDeleteError(QuoteEquipmentDeleteResult result) {
    return switch (result.status) {
      QuoteEquipmentDeleteStatus.notFound =>
        'Vínculo de equipamento não encontrado.',
      QuoteEquipmentDeleteStatus.failure =>
        'Não foi possível remover o equipamento. Tente novamente.',
      QuoteEquipmentDeleteStatus.deleted => '',
    };
  }

  static void showSnackBar(EquipmentFeedback feedback) {
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

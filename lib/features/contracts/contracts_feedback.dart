import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../main.dart';
import 'models/contract_operation_result.dart';
import 'models/contract_template_operation_result.dart';

enum ContractsFeedback {
  templateCreated,
  templateUpdated,
  templateDeleted,
  templateActivated,
  templateDeactivated,
  contractGenerated,
  contractCancelled,
  contractSent,
}

abstract class ContractsFeedbackPresenter {
  static String message(ContractsFeedback feedback) {
    return switch (feedback) {
      ContractsFeedback.templateCreated => 'Modelo criado com sucesso',
      ContractsFeedback.templateUpdated => 'Modelo atualizado com sucesso',
      ContractsFeedback.templateDeleted => 'Modelo excluído com sucesso',
      ContractsFeedback.templateActivated => 'Modelo ativado',
      ContractsFeedback.templateDeactivated => 'Modelo desativado',
      ContractsFeedback.contractGenerated => 'Contrato gerado com sucesso',
      ContractsFeedback.contractCancelled => 'Contrato cancelado',
      ContractsFeedback.contractSent => 'Contrato marcado como enviado',
    };
  }

  static String templateWriteError(ContractTemplateOperationResult result) {
    return switch (result.status) {
      ContractTemplateOperationStatus.validationFailed => result.errors.isEmpty
          ? 'Verifique o nome do modelo.'
          : result.errors.first,
      ContractTemplateOperationStatus.duplicateName =>
        'Já existe um modelo com este nome.',
      ContractTemplateOperationStatus.notFound => 'Modelo não encontrado.',
      ContractTemplateOperationStatus.failure =>
        'Não foi possível salvar o modelo. Tente novamente.',
      ContractTemplateOperationStatus.blockedByUsage ||
      ContractTemplateOperationStatus.deleted ||
      ContractTemplateOperationStatus.success =>
        '',
    };
  }

  static String templateDeleteError(ContractTemplateOperationResult result) {
    return switch (result.status) {
      ContractTemplateOperationStatus.notFound => 'Modelo não encontrado.',
      ContractTemplateOperationStatus.blockedByUsage =>
        'Modelo em uso por ${result.blockingContractCount} '
            '${result.blockingContractCount == 1 ? 'contrato' : 'contratos'}.',
      ContractTemplateOperationStatus.failure =>
        'Não foi possível excluir o modelo. Tente novamente.',
      _ => '',
    };
  }

  static String contractWriteError(ContractOperationResult result) {
    return switch (result.status) {
      ContractOperationStatus.validationFailed => result.errors.isEmpty
          ? 'Verifique os dados do contrato.'
          : result.errors.first,
      ContractOperationStatus.quoteNotFound => 'Orçamento não encontrado.',
      ContractOperationStatus.templateNotFound => 'Modelo não encontrado.',
      ContractOperationStatus.templateInactive =>
        'O modelo selecionado está inativo.',
      ContractOperationStatus.duplicateNumber =>
        'Já existe um contrato com este número.',
      ContractOperationStatus.notFound => 'Contrato não encontrado.',
      ContractOperationStatus.invalidTransition =>
        'Transição de status inválida.',
      ContractOperationStatus.cannotSignCancelled =>
        'Não é possível assinar um contrato cancelado.',
      ContractOperationStatus.cannotCancelSigned =>
        'Não é possível cancelar um contrato assinado.',
      ContractOperationStatus.failure =>
        'Não foi possível concluir a operação. Tente novamente.',
      ContractOperationStatus.deleted || ContractOperationStatus.success => '',
    };
  }

  static void showSnackBar(ContractsFeedback feedback) {
    final messenger = EventProApp.scaffoldMessengerKey.currentState;
    messenger?.showSnackBar(
      SnackBar(
        content: Text(message(feedback)),
        backgroundColor: AppColors.surface,
      ),
    );
  }

  static void showError(String message) {
    if (message.isEmpty) return;
    final messenger = EventProApp.scaffoldMessengerKey.currentState;
    messenger?.showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }
}

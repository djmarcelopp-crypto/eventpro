import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../main.dart';
import 'models/quote_team_delete_result.dart';
import 'models/quote_team_write_result.dart';
import 'models/team_operation_result.dart';
import 'models/team_role_operation_result.dart';

enum TeamFeedback {
  memberCreated,
  memberUpdated,
  memberDeleted,
  roleCreated,
  roleUpdated,
  roleDeleted,
  roleActivated,
  roleDeactivated,
  quoteTeamAdded,
  quoteTeamRemoved,
}

abstract class TeamFeedbackPresenter {
  static String message(TeamFeedback feedback) {
    return switch (feedback) {
      TeamFeedback.memberCreated => 'Colaborador cadastrado com sucesso',
      TeamFeedback.memberUpdated => 'Colaborador atualizado com sucesso',
      TeamFeedback.memberDeleted => 'Colaborador excluído com sucesso',
      TeamFeedback.roleCreated => 'Função criada com sucesso',
      TeamFeedback.roleUpdated => 'Função atualizada com sucesso',
      TeamFeedback.roleDeleted => 'Função excluída com sucesso',
      TeamFeedback.roleActivated => 'Função ativada',
      TeamFeedback.roleDeactivated => 'Função desativada',
      TeamFeedback.quoteTeamAdded => 'Colaborador adicionado ao orçamento',
      TeamFeedback.quoteTeamRemoved => 'Colaborador removido do orçamento',
    };
  }

  static String memberWriteError(TeamOperationResult result) {
    return switch (result.status) {
      TeamOperationStatus.validationFailed => result.errors.isEmpty
          ? 'Verifique os campos do colaborador.'
          : result.errors.first,
      TeamOperationStatus.roleNotFound =>
        'Função não encontrada. Escolha outra função.',
      TeamOperationStatus.roleInactive =>
        'A função selecionada está inativa.',
      TeamOperationStatus.notFound => 'Colaborador não encontrado.',
      TeamOperationStatus.failure =>
        'Não foi possível salvar o colaborador. Tente novamente.',
      TeamOperationStatus.deleted => '',
      TeamOperationStatus.success => '',
    };
  }

  static String memberDeleteError(TeamOperationResult result) {
    return switch (result.status) {
      TeamOperationStatus.notFound => 'Colaborador não encontrado.',
      TeamOperationStatus.failure =>
        'Não foi possível excluir o colaborador. Tente novamente.',
      _ => '',
    };
  }

  static String roleWriteError(TeamRoleOperationResult result) {
    return switch (result.status) {
      TeamRoleOperationStatus.validationFailed => result.errors.isEmpty
          ? 'Verifique o nome da função.'
          : result.errors.first,
      TeamRoleOperationStatus.duplicateName =>
        'Já existe uma função com este nome.',
      TeamRoleOperationStatus.notFound => 'Função não encontrada.',
      TeamRoleOperationStatus.failure =>
        'Não foi possível salvar a função. Tente novamente.',
      TeamRoleOperationStatus.blockedByUsage ||
      TeamRoleOperationStatus.deleted ||
      TeamRoleOperationStatus.success =>
        '',
    };
  }

  static String roleDeleteError(TeamRoleOperationResult result) {
    return switch (result.status) {
      TeamRoleOperationStatus.notFound => 'Função não encontrada.',
      TeamRoleOperationStatus.blockedByUsage =>
        'Função em uso por ${result.blockingMemberCount} '
            '${result.blockingMemberCount == 1 ? 'colaborador' : 'colaboradores'}.',
      TeamRoleOperationStatus.failure =>
        'Não foi possível excluir a função. Tente novamente.',
      _ => '',
    };
  }

  static String quoteTeamWriteError(QuoteTeamWriteResult result) {
    return switch (result.status) {
      QuoteTeamWriteStatus.validationFailed => result.errors.isEmpty
          ? 'Não foi possível adicionar o colaborador.'
          : result.errors.first,
      QuoteTeamWriteStatus.quoteNotFound => 'Orçamento não encontrado.',
      QuoteTeamWriteStatus.memberNotFound => 'Colaborador não encontrado.',
      QuoteTeamWriteStatus.memberInactive =>
        'O colaborador precisa estar ativo.',
      QuoteTeamWriteStatus.roleNotFound => 'Função do colaborador não encontrada.',
      QuoteTeamWriteStatus.roleInactive =>
        'A função do colaborador está inativa.',
      QuoteTeamWriteStatus.duplicateMember =>
        'Este colaborador já está no orçamento.',
      QuoteTeamWriteStatus.notFound => 'Vínculo de equipe não encontrado.',
      QuoteTeamWriteStatus.failure =>
        'Não foi possível salvar o vínculo. Tente novamente.',
      QuoteTeamWriteStatus.success => '',
    };
  }

  static String quoteTeamDeleteError(QuoteTeamDeleteResult result) {
    return switch (result.status) {
      QuoteTeamDeleteStatus.notFound => 'Vínculo de equipe não encontrado.',
      QuoteTeamDeleteStatus.failure =>
        'Não foi possível remover o colaborador. Tente novamente.',
      QuoteTeamDeleteStatus.deleted => '',
    };
  }

  static void showSnackBar(TeamFeedback feedback) {
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

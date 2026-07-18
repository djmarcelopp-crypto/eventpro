import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../main.dart';
import 'models/quote_vehicle_write_result.dart';
import 'models/vehicle_operation_result.dart';
import 'models/vehicle_type_operation_result.dart';

enum LogisticsFeedback {
  vehicleCreated,
  vehicleUpdated,
  vehicleDeleted,
  typeCreated,
  typeUpdated,
  typeDeleted,
  typeActivated,
  typeDeactivated,
  quoteVehicleAdded,
  quoteVehicleRemoved,
}

abstract class LogisticsFeedbackPresenter {
  static String message(LogisticsFeedback feedback) {
    return switch (feedback) {
      LogisticsFeedback.vehicleCreated => 'Veículo cadastrado com sucesso',
      LogisticsFeedback.vehicleUpdated => 'Veículo atualizado com sucesso',
      LogisticsFeedback.vehicleDeleted => 'Veículo excluído com sucesso',
      LogisticsFeedback.typeCreated => 'Tipo de veículo criado com sucesso',
      LogisticsFeedback.typeUpdated => 'Tipo de veículo atualizado com sucesso',
      LogisticsFeedback.typeDeleted => 'Tipo de veículo excluído com sucesso',
      LogisticsFeedback.typeActivated => 'Tipo ativado',
      LogisticsFeedback.typeDeactivated => 'Tipo desativado',
      LogisticsFeedback.quoteVehicleAdded => 'Veículo adicionado ao orçamento',
      LogisticsFeedback.quoteVehicleRemoved => 'Veículo removido do orçamento',
    };
  }

  static String vehicleWriteError(VehicleOperationResult result) {
    return switch (result.status) {
      VehicleOperationStatus.validationFailed => result.errors.isEmpty
          ? 'Verifique os campos do veículo.'
          : result.errors.first,
      VehicleOperationStatus.duplicatePlate =>
        'Já existe um veículo com esta placa.',
      VehicleOperationStatus.typeNotFound => 'Tipo de veículo não encontrado.',
      VehicleOperationStatus.typeInactive =>
        'O tipo selecionado está inativo.',
      VehicleOperationStatus.notFound => 'Veículo não encontrado.',
      VehicleOperationStatus.failure =>
        'Não foi possível salvar o veículo. Tente novamente.',
      VehicleOperationStatus.deleted || VehicleOperationStatus.success => '',
    };
  }

  static String typeWriteError(VehicleTypeOperationResult result) {
    return switch (result.status) {
      VehicleTypeOperationStatus.validationFailed => result.errors.isEmpty
          ? 'Verifique o nome do tipo.'
          : result.errors.first,
      VehicleTypeOperationStatus.duplicateName =>
        'Já existe um tipo com este nome.',
      VehicleTypeOperationStatus.notFound => 'Tipo não encontrado.',
      VehicleTypeOperationStatus.failure =>
        'Não foi possível salvar o tipo. Tente novamente.',
      VehicleTypeOperationStatus.blockedByUsage ||
      VehicleTypeOperationStatus.deleted ||
      VehicleTypeOperationStatus.success =>
        '',
    };
  }

  static String typeDeleteError(VehicleTypeOperationResult result) {
    return switch (result.status) {
      VehicleTypeOperationStatus.notFound => 'Tipo não encontrado.',
      VehicleTypeOperationStatus.blockedByUsage =>
        'Tipo em uso por ${result.blockingVehicleCount} '
            '${result.blockingVehicleCount == 1 ? 'veículo' : 'veículos'}.',
      VehicleTypeOperationStatus.failure =>
        'Não foi possível excluir o tipo. Tente novamente.',
      _ => '',
    };
  }

  static String quoteVehicleWriteError(QuoteVehicleWriteResult result) {
    return switch (result.status) {
      QuoteVehicleWriteStatus.validationFailed => result.errors.isEmpty
          ? 'Não foi possível adicionar o veículo.'
          : result.errors.first,
      QuoteVehicleWriteStatus.quoteNotFound => 'Orçamento não encontrado.',
      QuoteVehicleWriteStatus.vehicleNotFound => 'Veículo não encontrado.',
      QuoteVehicleWriteStatus.vehicleUnavailable =>
        'O veículo precisa estar disponível operacionalmente.',
      QuoteVehicleWriteStatus.driverNotFound => 'Motorista não encontrado.',
      QuoteVehicleWriteStatus.driverInactive =>
        'O motorista precisa estar ativo.',
      QuoteVehicleWriteStatus.duplicateVehicle =>
        'Este veículo já está no orçamento.',
      QuoteVehicleWriteStatus.invalidSchedule =>
        'O retorno não pode ser anterior à saída.',
      QuoteVehicleWriteStatus.notFound => 'Vínculo logístico não encontrado.',
      QuoteVehicleWriteStatus.failure =>
        'Não foi possível salvar o vínculo. Tente novamente.',
      QuoteVehicleWriteStatus.success => '',
    };
  }

  static void showSnackBar(LogisticsFeedback feedback) {
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

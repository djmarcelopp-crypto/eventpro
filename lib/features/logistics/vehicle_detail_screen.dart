import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/primary_button.dart';
import 'providers/vehicle_provider.dart';
import 'providers/vehicle_type_provider.dart';
import 'models/vehicle_status.dart';
import 'logistics_feedback.dart';

class VehicleDetailScreen extends ConsumerWidget {
  const VehicleDetailScreen({super.key, required this.vehicleId});

  final String vehicleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vehicle = ref.watch(vehicleProvider).value
        ?.where((item) => item.id == vehicleId)
        .firstOrNull;
    final typeName = vehicle == null
        ? null
        : ref.watch(vehicleTypeProvider).value
            ?.where((type) => type.id == vehicle.vehicleTypeId)
            .map((type) => type.name)
            .firstOrNull;

    if (vehicle == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Veículo')),
        body: const Center(child: Text('Veículo não encontrado')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(vehicle.plate),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
        actions: [
          IconButton(
            key: const Key('vehicle_detail_edit'),
            icon: const Icon(Icons.edit_outlined),
            onPressed: () =>
                context.push(AppRoutes.vehicleEdit(vehicle.id)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          AppCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(vehicle.plate, style: AppTextStyles.headlineMedium),
                const SizedBox(height: 8),
                Text('Tipo: ${typeName ?? vehicle.vehicleTypeId}'),
                Text('Status: ${vehicle.status.label}'),
                Text('Carga: ${vehicle.payloadCapacityKg} kg'),
                Text('Volume: ${vehicle.volumeCapacityM3} m³'),
                if (vehicle.description.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(vehicle.description),
                ],
                if (vehicle.observations.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(vehicle.observations),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            key: const Key('vehicle_detail_delete'),
            label: 'Excluir veículo',
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Excluir veículo?'),
                  content: Text('A placa ${vehicle.plate} será removida.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Excluir'),
                    ),
                  ],
                ),
              );
              if (confirmed != true || !context.mounted) return;
              final result = await ref
                  .read(vehicleProvider.notifier)
                  .deleteVehicle(vehicle.id);
              if (!context.mounted) return;
              if (result.isDeleted) {
                context.go(AppRoutes.vehicles);
                LogisticsFeedbackPresenter.showSnackBar(
                  LogisticsFeedback.vehicleDeleted,
                );
              } else {
                LogisticsFeedbackPresenter.showError(
                  LogisticsFeedbackPresenter.vehicleWriteError(result),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

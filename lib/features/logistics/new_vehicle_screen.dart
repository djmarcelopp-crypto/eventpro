import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/primary_button.dart';
import 'models/vehicle.dart';
import 'models/vehicle_status.dart';
import 'models/vehicle_type.dart';
import 'providers/vehicle_provider.dart';
import 'providers/vehicle_type_provider.dart';
import 'logistics_feedback.dart';

class NewVehicleScreen extends ConsumerStatefulWidget {
  const NewVehicleScreen({super.key, this.vehicleId});

  final String? vehicleId;

  @override
  ConsumerState<NewVehicleScreen> createState() => _NewVehicleScreenState();
}

class _NewVehicleScreenState extends ConsumerState<NewVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _plateController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _payloadController = TextEditingController();
  final _volumeController = TextEditingController();
  final _observationsController = TextEditingController();

  String? _typeId;
  VehicleStatus _status = VehicleStatus.available;
  var _isSaving = false;
  var _initializedForEdit = false;

  bool get _isEditing => widget.vehicleId != null;

  @override
  void dispose() {
    _plateController.dispose();
    _descriptionController.dispose();
    _payloadController.dispose();
    _volumeController.dispose();
    _observationsController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tryInitializeForEdit();
  }

  void _tryInitializeForEdit() {
    if (!_isEditing || _initializedForEdit) return;
    final vehicle =
        ref.read(vehicleProvider.notifier).findById(widget.vehicleId!);
    if (vehicle == null) return;
    _initializedForEdit = true;
    _plateController.text = vehicle.plate;
    _descriptionController.text = vehicle.description;
    _payloadController.text = vehicle.payloadCapacityKg.toString();
    _volumeController.text = vehicle.volumeCapacityM3.toString();
    _observationsController.text = vehicle.observations;
    _typeId = vehicle.vehicleTypeId;
    _status = vehicle.status;
  }

  List<VehicleType> _typesForDropdown(List<VehicleType> all) {
    if (_isEditing && _typeId != null) {
      final current = all.where((type) => type.id == _typeId).firstOrNull;
      if (current != null && !current.active) {
        return [
          current,
          ...all.where((type) => type.active && type.id != _typeId),
        ];
      }
    }
    return all.where((type) => type.active).toList(growable: false);
  }

  Future<void> _onSave() async {
    if (_isSaving) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_typeId == null || _typeId!.isEmpty) {
      LogisticsFeedbackPresenter.showError('Selecione um tipo de veículo');
      return;
    }

    setState(() => _isSaving = true);
    final now = DateTime(2026);
    final draft = Vehicle(
      id: widget.vehicleId ?? '',
      plate: _plateController.text,
      description: _descriptionController.text.trim(),
      vehicleTypeId: _typeId!,
      payloadCapacityKg: double.tryParse(_payloadController.text.trim()) ?? -1,
      volumeCapacityM3: double.tryParse(_volumeController.text.trim()) ?? -1,
      observations: _observationsController.text.trim(),
      status: _status,
      createdAt: now,
      updatedAt: now,
    );

    final result = _isEditing
        ? await ref.read(vehicleProvider.notifier).updateVehicle(draft)
        : await ref.read(vehicleProvider.notifier).addVehicle(draft);

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (!result.isSuccess) {
      LogisticsFeedbackPresenter.showError(
        LogisticsFeedbackPresenter.vehicleWriteError(result),
      );
      return;
    }

    if (_isEditing) {
      context.go(AppRoutes.vehicles);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        LogisticsFeedbackPresenter.showSnackBar(
          LogisticsFeedback.vehicleUpdated,
        );
      });
    } else {
      context.pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final types =
        _typesForDropdown(ref.watch(vehicleTypeProvider).value ?? const []);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar veículo' : 'Novo veículo'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            AppTextField(
              key: const Key('vehicle_form_plate'),
              label: 'Placa',
              controller: _plateController,
              validator: (value) =>
                  value == null || value.trim().isEmpty ? 'Obrigatório' : null,
            ),
            const SizedBox(height: 16),
            AppTextField(
              key: const Key('vehicle_form_description'),
              label: 'Descrição',
              controller: _descriptionController,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              key: const Key('vehicle_form_type'),
              initialValue: _typeId,
              decoration: const InputDecoration(labelText: 'Tipo', filled: true),
              items: [
                for (final type in types)
                  DropdownMenuItem(value: type.id, child: Text(type.name)),
              ],
              onChanged: (value) => setState(() => _typeId = value),
            ),
            const SizedBox(height: 16),
            AppTextField(
              key: const Key('vehicle_form_payload'),
              label: 'Capacidade de carga (kg)',
              controller: _payloadController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                final parsed = double.tryParse(value?.trim() ?? '');
                if (parsed == null || parsed < 0) {
                  return 'Informe um valor >= 0';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              key: const Key('vehicle_form_volume'),
              label: 'Capacidade de volume (m³)',
              controller: _volumeController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                final parsed = double.tryParse(value?.trim() ?? '');
                if (parsed == null || parsed < 0) {
                  return 'Informe um valor >= 0';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<VehicleStatus>(
              key: const Key('vehicle_form_status'),
              initialValue: _status,
              decoration:
                  const InputDecoration(labelText: 'Status', filled: true),
              items: [
                for (final status in VehicleStatus.values)
                  DropdownMenuItem(
                    value: status,
                    child: Text(status.label),
                  ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _status = value);
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              key: const Key('vehicle_form_observations'),
              label: 'Observações',
              controller: _observationsController,
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              key: const Key('vehicle_form_save'),
              label: _isSaving ? 'Salvando...' : 'Salvar',
              onPressed: _isSaving ? null : _onSave,
            ),
            const SizedBox(height: 8),
            Text(
              'A unicidade da placa é validada no serviço.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.white.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

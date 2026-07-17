import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/primary_button.dart';
import 'equipment_feedback.dart';
import 'models/equipment.dart';
import 'models/equipment_category.dart';
import 'models/equipment_status.dart';
import 'providers/equipment_category_provider.dart';
import 'providers/equipment_provider.dart';

class NewEquipmentScreen extends ConsumerStatefulWidget {
  const NewEquipmentScreen({super.key, this.equipmentId});

  final String? equipmentId;

  @override
  ConsumerState<NewEquipmentScreen> createState() => _NewEquipmentScreenState();
}

class _NewEquipmentScreenState extends ConsumerState<NewEquipmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _serialController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');

  String? _categoryId;
  EquipmentStatus _status = EquipmentStatus.available;
  var _isSaving = false;
  var _initializedForEdit = false;

  bool get _isEditing => widget.equipmentId != null;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _serialController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _tryInitializeForEdit();
  }

  void _tryInitializeForEdit() {
    if (!_isEditing || _initializedForEdit) {
      return;
    }
    final equipment = ref
        .read(equipmentProvider.notifier)
        .findById(widget.equipmentId!);
    if (equipment == null) {
      return;
    }
    _initializedForEdit = true;
    _nameController.text = equipment.name;
    _descriptionController.text = equipment.description;
    _serialController.text = equipment.serialNumber ?? '';
    _quantityController.text = '${equipment.totalQuantity}';
    _categoryId = equipment.categoryId;
    _status = equipment.status;
  }

  List<EquipmentCategory> _activeCategories(List<EquipmentCategory> all) {
    return all.where((category) => category.active).toList(growable: false);
  }

  Future<void> _onSave() async {
    if (_isSaving) {
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    if (_categoryId == null) {
      EquipmentFeedbackPresenter.showError('Selecione uma categoria.');
      return;
    }

    final quantity = int.tryParse(_quantityController.text.trim());
    if (quantity == null) {
      EquipmentFeedbackPresenter.showError('Informe uma quantidade válida.');
      return;
    }

    setState(() => _isSaving = true);

    final now = DateTime.now();
    final serial = _serialController.text.trim();
    final draft = Equipment(
      id: widget.equipmentId ?? '',
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      categoryId: _categoryId!,
      serialNumber: serial.isEmpty ? null : serial,
      totalQuantity: quantity,
      status: _status,
      createdAt: now,
      updatedAt: now,
    );

    final notifier = ref.read(equipmentProvider.notifier);
    final result = _isEditing
        ? await notifier.updateEquipment(draft)
        : await notifier.addEquipment(draft);

    if (!mounted) {
      return;
    }

    setState(() => _isSaving = false);

    if (!result.isSuccess) {
      EquipmentFeedbackPresenter.showError(
        EquipmentFeedbackPresenter.equipmentWriteError(result),
      );
      return;
    }

    // Defer navigation so Riverpod can finish notifying listeners outside an
    // active overlay/build update (GoRouter + TickerMode), matching Financial.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      if (_isEditing) {
        context.go(AppRoutes.equipment);
        EquipmentFeedbackPresenter.showSnackBar(
          EquipmentFeedback.equipmentUpdated,
        );
      } else {
        Navigator.of(context).pop(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(equipmentCategoryProvider);
    final categories = _activeCategories(categoriesAsync.value ?? const []);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          _isEditing ? 'Editar equipamento' : 'Novo equipamento',
          style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: categoriesAsync.when(
        data: (_) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 720),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppTextField(
                        key: const Key('equipment_form_name'),
                        label: 'Nome',
                        controller: _nameController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Informe o nome.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        key: const Key('equipment_form_description'),
                        label: 'Descrição',
                        controller: _descriptionController,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        key: const Key('equipment_form_category'),
                        initialValue: _categoryId,
                        decoration: const InputDecoration(
                          labelText: 'Categoria',
                        ),
                        items: [
                          for (final category in categories)
                            DropdownMenuItem(
                              value: category.id,
                              child: Text(category.name),
                            ),
                        ],
                        onChanged: (value) =>
                            setState(() => _categoryId = value),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Selecione uma categoria.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        key: const Key('equipment_form_serial'),
                        label: 'Número de série (opcional)',
                        controller: _serialController,
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        key: const Key('equipment_form_quantity'),
                        label: 'Quantidade total',
                        controller: _quantityController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          final parsed = int.tryParse(value?.trim() ?? '');
                          if (parsed == null || parsed <= 0) {
                            return 'Informe uma quantidade maior que zero.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<EquipmentStatus>(
                        key: const Key('equipment_form_status'),
                        initialValue: _status,
                        decoration: const InputDecoration(labelText: 'Status'),
                        items: [
                          for (final status in EquipmentStatus.values)
                            DropdownMenuItem(
                              value: status,
                              child: Text(status.label),
                            ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _status = value);
                          }
                        },
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        key: const Key('equipment_form_save_button'),
                        label: _isEditing ? 'Salvar alterações' : 'Criar',
                        isLoading: _isSaving,
                        onPressed: _onSave,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            'Não foi possível carregar as categorias.',
            style: AppTextStyles.bodyMedium,
          ),
        ),
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/primary_button.dart';
import 'catalog_billing_unit.dart';
import 'catalog_category.dart';
import 'catalog_form_validators.dart';
import 'catalog_item_type.dart';
import 'catalog_package_constants.dart';
import 'models/catalog_package_component.dart';
import 'utils/catalog_package_validator.dart';
import 'utils/catalog_quantity_parser.dart';
import 'data/exceptions/catalog_image_pick_exception.dart';
import 'data/services/catalog_image_picker_service.dart';
import 'data/services/catalog_image_storage_service.dart';
import 'models/catalog_item.dart';
import 'data/utils/catalog_image_validator.dart';
import 'providers/catalog_image_services_provider.dart';
import 'providers/catalog_provider.dart';
import 'utils/brazilian_currency_input_formatter.dart';
import 'utils/catalog_form_initializer.dart';
import 'utils/catalog_navigation.dart';
import 'utils/catalog_price_formatter.dart';
import 'widgets/catalog_item_image_form_section.dart';
import 'widgets/catalog_item_type_selector.dart';
import 'widgets/catalog_package_components_section.dart';

class NewCatalogItemScreen extends ConsumerStatefulWidget {
  const NewCatalogItemScreen({
    super.key,
    this.itemId,
  });

  final String? itemId;

  @override
  ConsumerState<NewCatalogItemScreen> createState() =>
      _NewCatalogItemScreenState();
}

class _NewCatalogItemScreenState extends ConsumerState<NewCatalogItemScreen> {
  static const _maxContentWidth = 720.0;
  static const _fieldSpacing = 16.0;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _customUnitController = TextEditingController();
  final _priceController = TextEditingController();
  final _packageUnitController =
      TextEditingController(text: CatalogPackageConstants.unit);

  CatalogItemType _type = CatalogItemType.equipment;
  CatalogItemType? _originalType;
  CatalogCategory _category = CatalogCategory.sound;
  CatalogBillingUnit _billingUnit = CatalogBillingUnit.unit;
  bool _active = true;
  bool _initializedForEdit = false;
  final List<CatalogPackageComponentEntry> _packageComponents = [];

  String? _originalImageReference;
  String? _stagedImageReference;
  bool _removeImageRequested = false;
  bool _formSaved = false;
  bool _pickingImage = false;
  bool _saving = false;
  CatalogImageStorageService? _imageStorage;
  CatalogImagePickerService? _imagePicker;

  bool get _isEditing => widget.itemId != null;

  bool get _isPackage => _type.isPackage;

  Set<CatalogItemType> get _disabledTypes {
    if (!_isEditing || _originalType == null) {
      return const {};
    }

    if (_originalType!.isPackage) {
      return {
        CatalogItemType.equipment,
        CatalogItemType.service,
      };
    }

    return {CatalogItemType.package};
  }

  String? get _previewImageReference {
    if (_stagedImageReference != null) {
      return _stagedImageReference;
    }
    if (_removeImageRequested) {
      return null;
    }
    return _originalImageReference;
  }

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeForEditIfNeeded();
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _imageStorage ??= ref.read(catalogImageStorageProvider);
    _imagePicker ??= ref.read(catalogImagePickerProvider);
    _initializeForEditIfNeeded();
  }

  void _initializeForEditIfNeeded() {
    if (!_isEditing || _initializedForEdit) {
      return;
    }

    final item = ref.read(catalogProvider.notifier).findById(widget.itemId!);
    if (item == null) {
      return;
    }

    final values = CatalogFormInitializer.fromItem(item);
    CatalogFormInitializer.applyToControllers(
      values: values,
      nameController: _nameController,
      descriptionController: _descriptionController,
      customUnitController: _customUnitController,
      priceController: _priceController,
    );

    for (final entry in _packageComponents) {
      entry.dispose();
    }
    _packageComponents.clear();

    if (item.isPackage) {
      for (final component in item.components) {
        _packageComponents.add(
          CatalogPackageComponentEntry(
            component: component,
            quantityController: TextEditingController(
              text: CatalogQuantityParser.formatForInput(
                component.quantityPerPackage,
              ),
            ),
          ),
        );
      }
    }

    setState(() {
      _type = values.type;
      _originalType = values.type;
      _category = values.category;
      _billingUnit = values.billingUnit;
      _active = values.active;
      _originalImageReference = item.imageReference;
      _initializedForEdit = true;
    });
  }

  @override
  void dispose() {
    if (!_formSaved) {
      unawaited(_discardStagedOnly());
    }
    for (final entry in _packageComponents) {
      entry.dispose();
    }
    _nameController.dispose();
    _descriptionController.dispose();
    _customUnitController.dispose();
    _priceController.dispose();
    _packageUnitController.dispose();
    super.dispose();
  }

  Future<void> _discardStagedOnly() async {
    final stagedReference = _stagedImageReference;
    final storage = _imageStorage;
    if (stagedReference == null || storage == null) {
      return;
    }

    await storage.discardStaged(stagedReference);
    _stagedImageReference = null;
  }

  void _showFeedback(String message, {bool isError = true}) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: const TextStyle(color: AppColors.white),
          ),
          backgroundColor: isError ? AppColors.error : AppColors.success,
        ),
      );
  }

  void _showImageError(String message) {
    _showFeedback(message);
  }

  void _clearPackageComponents() {
    for (final entry in _packageComponents) {
      entry.dispose();
    }
    _packageComponents.clear();
  }

  Future<void> _handleTypeChanged(CatalogItemType nextType) async {
    if (nextType == _type || _disabledTypes.contains(nextType)) {
      return;
    }

    if (_type.isPackage && !nextType.isPackage && _packageComponents.isNotEmpty) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Alterar tipo'),
            content: const Text(
              'Ao sair do tipo Pacote, os itens selecionados serão descartados. '
              'Deseja continuar?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: const Text('Continuar'),
              ),
            ],
          );
        },
      );

      if (confirmed != true || !mounted) {
        return;
      }

      setState(() {
        _clearPackageComponents();
        _type = nextType;
      });
      return;
    }

    setState(() => _type = nextType);
  }

  void _addPackageComponent(CatalogItem item) {
    setState(() {
      _packageComponents.add(
        CatalogPackageComponentEntry(
          component: CatalogPackageComponent.fromCatalogItem(
            item: item,
            quantityPerPackage: 1,
          ),
          quantityController: TextEditingController(text: '1'),
        ),
      );
    });
  }

  void _removePackageComponent(String catalogItemId) {
    setState(() {
      final index = _packageComponents.indexWhere(
        (entry) => entry.component.catalogItemId == catalogItemId,
      );
      if (index < 0) {
        return;
      }
      _packageComponents.removeAt(index).dispose();
    });
  }

  List<CatalogPackageComponent>? _buildPackageComponents() {
    final components = <CatalogPackageComponent>[];

    for (final entry in _packageComponents) {
      final quantity = CatalogQuantityParser.tryParse(
        entry.quantityController.text,
      );
      if (quantity == null) {
        _showFeedback(
          'Quantidade inválida para ${entry.component.nameSnapshot}',
        );
        return null;
      }

      components.add(
        entry.component.copyWith(quantityPerPackage: quantity),
      );
    }

    return components;
  }

  Future<void> _handleSelectPhoto() async {
    if (_pickingImage || _saving) {
      return;
    }

    setState(() => _pickingImage = true);

    try {
      final picker = _imagePicker;
      if (picker == null) {
        _showImageError('Não foi possível abrir o seletor de imagens. Tente novamente.');
        return;
      }

      final pickResult = await picker.pickImage();
      if (pickResult == null || !mounted) {
        return;
      }

      final validation = await CatalogImageValidator.validate(pickResult.bytes);
      if (!validation.isValid) {
        _showImageError(validation.errorMessage!);
        return;
      }

      final storage = _imageStorage;
      if (storage == null) {
        _showImageError('Não foi possível salvar a foto. Tente novamente.');
        return;
      }

      if (_stagedImageReference != null) {
        await storage.discardStaged(_stagedImageReference);
      }

      final stagedReference = await storage.stageFromPick(
        bytes: pickResult.bytes,
        extension: pickResult.extension,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _stagedImageReference = stagedReference;
        _removeImageRequested = false;
      });
    } on CatalogImagePickException catch (error) {
      if (mounted) {
        _showImageError(error.message);
      }
    } catch (_) {
      if (mounted) {
        _showImageError('Não foi possível selecionar a foto. Tente novamente.');
      }
    } finally {
      if (mounted) {
        setState(() => _pickingImage = false);
      }
    }
  }

  Future<void> _handleRemovePhoto() async {
    if (_pickingImage || _saving) {
      return;
    }

    await _discardStagedOnly();
    if (!mounted) {
      return;
    }

    setState(() {
      _stagedImageReference = null;
      _removeImageRequested = true;
    });
  }

  Future<void> _save() async {
    if (_saving) {
      return;
    }

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    final price = CatalogPriceFormatter.parse(_priceController.text);
    if (price == null || price <= 0) {
      return;
    }

    final unit = _isPackage
        ? CatalogPackageConstants.unit
        : CatalogBillingUnitResolver.resolve(
            unit: _billingUnit,
            customUnit: _customUnitController.text,
          );

    List<CatalogPackageComponent>? packageComponents;
    if (_isPackage) {
      packageComponents = _buildPackageComponents();
      if (packageComponents == null) {
        return;
      }
    }

    final existingItem = _isEditing
        ? ref.read(catalogProvider.notifier).findById(widget.itemId!)
        : null;

    if (_isEditing && existingItem == null) {
      return;
    }

    final draftItem = CatalogItem.fromForm(
      type: _type,
      name: _nameController.text,
      category: _category,
      unit: unit,
      price: price,
      active: _active,
      description: _descriptionController.text,
      imageReference: _previewImageReference,
      id: existingItem?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      createdAt: existingItem?.createdAt,
      components: packageComponents,
    );

    final existingComponentIds = existingItem?.components
            .map((component) => component.catalogItemId)
            .toSet() ??
        const <String>{};

    final validation = CatalogPackageValidator.validate(
      item: draftItem,
      resolveItem: ref.read(catalogProvider.notifier).findById,
      existingComponentIds: existingComponentIds,
    );

    if (!validation.canSave) {
      final firstError = validation.issues
          .firstWhere((issue) => issue.isError)
          .message;
      _showFeedback(firstError);
      return;
    }

    setState(() => _saving = true);

    final storage = _imageStorage!;
    final originalToDelete = _originalImageReference;
    String? committedReference;
    String? rollbackReference;

    try {
      final itemId =
          existingItem?.id ?? DateTime.now().microsecondsSinceEpoch.toString();
      String? finalImageReference;
      var clearImageReference = false;

      if (_stagedImageReference != null) {
        committedReference = await storage.commitStaged(
          stagedReference: _stagedImageReference!,
          itemId: itemId,
        );
        rollbackReference = committedReference;
        finalImageReference = committedReference;
        _stagedImageReference = null;
      } else if (_removeImageRequested) {
        finalImageReference = null;
        clearImageReference = _isEditing;
      } else {
        finalImageReference = _originalImageReference;
      }

      final item = CatalogItem.fromForm(
        type: _type,
        name: _nameController.text,
        category: _category,
        unit: unit,
        price: price,
        active: _active,
        description: _descriptionController.text,
        imageReference: finalImageReference,
        id: itemId,
        createdAt: existingItem?.createdAt,
        components: packageComponents,
      );

      if (_isEditing) {
        ref.read(catalogProvider.notifier).updateItem(
              item,
              clearImageReference: clearImageReference,
            );
        _formSaved = true;

        if (_removeImageRequested && originalToDelete != null) {
          await storage.deleteCommitted(originalToDelete);
        } else if (committedReference != null &&
            originalToDelete != null &&
            originalToDelete != committedReference) {
          await storage.deleteCommitted(originalToDelete);
        }

        if (!mounted) {
          return;
        }

        CatalogNavigation.popToCatalogList(
          context,
          showUpdatedFeedback: true,
        );
        return;
      }

      ref.read(catalogProvider.notifier).addItem(item);
      _formSaved = true;

      if (!mounted) {
        return;
      }

      context.pop(true);
    } catch (_) {
      if (rollbackReference != null) {
        await storage.deleteCommitted(rollbackReference);
      }
      if (mounted) {
        _showImageError('Não foi possível salvar a foto. Tente novamente.');
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  InputDecoration _dropdownDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final catalogItems = ref.watch(catalogProvider);

    return PopScope(
      canPop: !_saving,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop && !_formSaved) {
          _discardStagedOnly();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Voltar',
            onPressed: _saving ? null : () => context.pop(),
          ),
          title: Text(
            _isEditing ? 'Editar item' : 'Novo item',
            style: AppTextStyles.headlineMedium.copyWith(
              fontSize: 20,
            ),
          ),
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.white,
          elevation: 0,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              key: const Key('catalog_form_scroll'),
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: _maxContentWidth,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CatalogItemTypeSelector(
                          selected: _type,
                          disabledTypes: _disabledTypes,
                          onChanged: _saving ? (_) {} : _handleTypeChanged,
                        ),
                        const SizedBox(height: _fieldSpacing),
                        AppTextField(
                          key: const Key('catalog_name_field'),
                          label: 'Nome',
                          controller: _nameController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                          validator: CatalogFormValidators.validateName,
                        ),
                        const SizedBox(height: _fieldSpacing),
                        KeyedSubtree(
                          key: ValueKey(
                            'catalog_category_dropdown_$_initializedForEdit$_category',
                          ),
                          child: DropdownButtonFormField<CatalogCategory>(
                            key: const Key('catalog_category_field'),
                            initialValue: _category,
                            decoration: _dropdownDecoration('Categoria'),
                            items: [
                              for (final category in CatalogCategory.values)
                                DropdownMenuItem(
                                  value: category,
                                  child: Text(category.label),
                                ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  _category = value;
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: _fieldSpacing),
                        AppTextField(
                          key: const Key('catalog_description_field'),
                          label: 'Descrição',
                          controller: _descriptionController,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          maxLines: 3,
                        ),
                        const SizedBox(height: _fieldSpacing),
                        if (_isPackage) ...[
                          AppTextField(
                            key: const Key('catalog_package_unit_field'),
                            label: 'Unidade de cobrança',
                            controller: _packageUnitController,
                            readOnly: true,
                          ),
                        ] else ...[
                          KeyedSubtree(
                            key: ValueKey(
                              'catalog_unit_dropdown_$_initializedForEdit$_billingUnit',
                            ),
                            child: DropdownButtonFormField<CatalogBillingUnit>(
                              key: const Key('catalog_unit_field'),
                              initialValue: _billingUnit,
                              decoration:
                                  _dropdownDecoration('Unidade de cobrança'),
                              items: [
                                for (final unit in CatalogBillingUnit.values)
                                  DropdownMenuItem(
                                    value: unit,
                                    child: Text(unit.label),
                                  ),
                              ],
                              onChanged: _onBillingUnitChanged,
                            ),
                          ),
                          if (_billingUnit.isOther) ...[
                            const SizedBox(height: _fieldSpacing),
                            AppTextField(
                              key: const Key('catalog_unit_custom_field'),
                              label: 'Unidade personalizada',
                              controller: _customUnitController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              validator: (value) =>
                                  CatalogFormValidators.validateCustomUnit(
                                unit: _billingUnit,
                                value: value,
                              ),
                            ),
                          ],
                        ],
                        const SizedBox(height: _fieldSpacing),
                        AppTextField(
                          key: const Key('catalog_price_field'),
                          label: 'Preço (R\$)',
                          hint: 'Ex.: 1.500,00',
                          controller: _priceController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          inputFormatters: [BrazilianCurrencyInputFormatter()],
                          validator: CatalogFormValidators.validatePrice,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Digite o valor em reais. Ex.: 1500, 1500,00 ou 1.500,00',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.secondaryText,
                          ),
                        ),
                        const SizedBox(height: _fieldSpacing),
                        if (_isPackage) ...[
                          CatalogPackageComponentsSection(
                            entries: _packageComponents,
                            catalogItems: catalogItems,
                            enabled: !_saving,
                            onAdd: _addPackageComponent,
                            onRemove: _removePackageComponent,
                          ),
                          const SizedBox(height: _fieldSpacing),
                        ],
                        CatalogItemImageFormSection(
                          previewReference: _previewImageReference,
                          onSelectPhoto: _handleSelectPhoto,
                          onReplacePhoto: _handleSelectPhoto,
                          onRemovePhoto: _handleRemovePhoto,
                          isBusy: _pickingImage || _saving,
                        ),
                        const SizedBox(height: _fieldSpacing),
                        SwitchListTile(
                          key: const Key('catalog_active_switch'),
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            'Item ativo',
                            style: AppTextStyles.bodyMedium,
                          ),
                          value: _active,
                          onChanged: _saving
                              ? null
                              : (value) {
                                  setState(() {
                                    _active = value;
                                  });
                                },
                        ),
                        const SizedBox(height: 24),
                        PrimaryButton(
                          key: const Key('catalog_save_button'),
                          label: 'Salvar',
                          onPressed: _saving ? null : _save,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _onBillingUnitChanged(CatalogBillingUnit? value) {
    if (value == null) {
      return;
    }

    setState(() {
      if (_billingUnit.isOther && !value.isOther) {
        _customUnitController.clear();
      }
      _billingUnit = value;
    });
  }
}

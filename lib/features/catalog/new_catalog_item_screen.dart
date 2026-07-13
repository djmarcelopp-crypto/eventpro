import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/primary_button.dart';
import 'catalog_billing_unit.dart';
import 'catalog_category.dart';
import 'catalog_form_validators.dart';
import 'catalog_item_type.dart';
import 'catalog_list_feedback.dart';
import 'models/catalog_item.dart';
import 'providers/catalog_provider.dart';
import 'utils/brazilian_currency_input_formatter.dart';
import 'utils/catalog_form_initializer.dart';
import 'utils/catalog_price_formatter.dart';
import 'widgets/catalog_item_image_placeholder.dart';

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

  CatalogItemType _type = CatalogItemType.equipment;
  CatalogCategory _category = CatalogCategory.sound;
  CatalogBillingUnit _billingUnit = CatalogBillingUnit.unit;
  bool _active = true;
  bool _initializedForEdit = false;

  bool get _isEditing => widget.itemId != null;

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

    setState(() {
      _type = values.type;
      _category = values.category;
      _billingUnit = values.billingUnit;
      _active = values.active;
      _initializedForEdit = true;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _customUnitController.dispose();
    _priceController.dispose();
    super.dispose();
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

  void _save() {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }

    final price = CatalogPriceFormatter.parse(_priceController.text);
    if (price == null || price <= 0) {
      return;
    }

    final unit = CatalogBillingUnitResolver.resolve(
      unit: _billingUnit,
      customUnit: _customUnitController.text,
    );

    final existingItem = _isEditing
        ? ref.read(catalogProvider.notifier).findById(widget.itemId!)
        : null;

    if (_isEditing && existingItem == null) {
      return;
    }

    final item = CatalogItem.fromForm(
      type: _type,
      name: _nameController.text,
      category: _category,
      unit: unit,
      price: price,
      active: _active,
      description: _descriptionController.text,
      imageReference: existingItem?.imageReference,
      id: existingItem?.id,
      createdAt: existingItem?.createdAt,
    );

    if (_isEditing) {
      ref.read(catalogProvider.notifier).updateItem(item);
      context.go(AppRoutes.catalog);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          CatalogListFeedbackPresenter.showSnackBar(CatalogListFeedback.updated);
        });
      });
      return;
    }

    ref.read(catalogProvider.notifier).addItem(item);
    context.pop(true);
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
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Voltar',
          onPressed: () => context.pop(),
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
                      SegmentedButton<CatalogItemType>(
                        segments: const [
                          ButtonSegment(
                            value: CatalogItemType.equipment,
                            label: Text('Equipamento'),
                          ),
                          ButtonSegment(
                            value: CatalogItemType.service,
                            label: Text('Serviço'),
                          ),
                        ],
                        selected: {_type},
                        onSelectionChanged: (selection) {
                          setState(() {
                            _type = selection.first;
                          });
                        },
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
                      KeyedSubtree(
                        key: ValueKey(
                          'catalog_unit_dropdown_$_initializedForEdit$_billingUnit',
                        ),
                        child: DropdownButtonFormField<CatalogBillingUnit>(
                          key: const Key('catalog_unit_field'),
                          initialValue: _billingUnit,
                          decoration: _dropdownDecoration('Unidade de cobrança'),
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
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: CatalogItemImagePlaceholder(
                          width: 160,
                          height: 120,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Foto em breve',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.secondaryText,
                        ),
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
                        onChanged: (value) {
                          setState(() {
                            _active = value;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        key: const Key('catalog_save_button'),
                        label: 'Salvar',
                        onPressed: _save,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

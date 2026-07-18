import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_text_field.dart';
import '../models/equipment.dart';

class QuoteEquipmentAddDraft {
  const QuoteEquipmentAddDraft({
    required this.equipmentId,
    required this.quantity,
  });

  final String equipmentId;
  final int quantity;
}

Future<QuoteEquipmentAddDraft?> showQuoteEquipmentAddDialog({
  required BuildContext context,
  required List<Equipment> equipment,
}) {
  return showDialog<QuoteEquipmentAddDraft>(
    context: context,
    builder: (context) => QuoteEquipmentAddDialog(equipment: equipment),
  );
}

Future<int?> showQuoteEquipmentQuantityDialog({
  required BuildContext context,
  required int initialQuantity,
}) {
  return showDialog<int>(
    context: context,
    builder: (context) =>
        QuoteEquipmentQuantityDialog(initialQuantity: initialQuantity),
  );
}

class QuoteEquipmentAddDialog extends StatefulWidget {
  const QuoteEquipmentAddDialog({super.key, required this.equipment});

  final List<Equipment> equipment;

  @override
  State<QuoteEquipmentAddDialog> createState() =>
      _QuoteEquipmentAddDialogState();
}

class _QuoteEquipmentAddDialogState extends State<QuoteEquipmentAddDialog> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController(text: '1');
  String? _equipmentId;

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    if (_equipmentId == null) {
      return;
    }
    final quantity = int.tryParse(_quantityController.text.trim());
    if (quantity == null) {
      return;
    }
    Navigator.of(context).pop(
      QuoteEquipmentAddDraft(equipmentId: _equipmentId!, quantity: quantity),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: const Text('Adicionar equipamento'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              key: const Key('quote_equipment_add_equipment'),
              initialValue: _equipmentId,
              decoration: const InputDecoration(labelText: 'Equipamento'),
              items: [
                for (final item in widget.equipment)
                  DropdownMenuItem(value: item.id, child: Text(item.name)),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Selecione um equipamento.';
                }
                return null;
              },
              onChanged: (value) => setState(() => _equipmentId = value),
            ),
            const SizedBox(height: 12),
            AppTextField(
              key: const Key('quote_equipment_add_quantity'),
              label: 'Quantidade',
              controller: _quantityController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                final parsed = int.tryParse(value?.trim() ?? '');
                if (parsed == null || parsed <= 0) {
                  return 'Informe uma quantidade maior que zero.';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(
          key: const Key('quote_equipment_add_save_button'),
          onPressed: _submit,
          child: const Text('Adicionar'),
        ),
      ],
    );
  }
}

class QuoteEquipmentQuantityDialog extends StatefulWidget {
  const QuoteEquipmentQuantityDialog({
    super.key,
    required this.initialQuantity,
  });

  final int initialQuantity;

  @override
  State<QuoteEquipmentQuantityDialog> createState() =>
      _QuoteEquipmentQuantityDialogState();
}

class _QuoteEquipmentQuantityDialogState
    extends State<QuoteEquipmentQuantityDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '${widget.initialQuantity}');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    Navigator.of(context).pop(int.parse(_controller.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: const Text('Alterar quantidade'),
      content: Form(
        key: _formKey,
        child: AppTextField(
          key: const Key('quote_equipment_quantity_field'),
          label: 'Quantidade',
          controller: _controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          validator: (value) {
            final parsed = int.tryParse(value?.trim() ?? '');
            if (parsed == null || parsed <= 0) {
              return 'Informe uma quantidade maior que zero.';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        TextButton(
          key: const Key('quote_equipment_quantity_save_button'),
          onPressed: _submit,
          child: const Text('Salvar'),
        ),
      ],
    );
  }
}

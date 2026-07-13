import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/primary_button.dart';
import 'client_form_validators.dart';
import 'client_type.dart';
import 'utils/client_date_formatter.dart';
import 'utils/text_input_masks.dart';

class NewClientScreen extends StatefulWidget {
  const NewClientScreen({super.key});

  @override
  State<NewClientScreen> createState() => _NewClientScreenState();
}

class _NewClientScreenState extends State<NewClientScreen> {
  static const _maxContentWidth = 720.0;
  static const _fieldSpacing = 16.0;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _whatsAppController = TextEditingController();
  final _emailController = TextEditingController();
  final _documentController = TextEditingController();
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _complementController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _instagramController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _notesController = TextEditingController();

  ClientType _clientType = ClientType.individual;
  DateTime? _birthday;
  String? _birthdayError;

  @override
  void dispose() {
    _nameController.dispose();
    _whatsAppController.dispose();
    _emailController.dispose();
    _documentController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _complementController.dispose();
    _neighborhoodController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _instagramController.dispose();
    _birthdayController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _onClientTypeChanged(Set<ClientType> selection) {
    if (selection.isEmpty) {
      return;
    }

    setState(() {
      _clientType = selection.first;
      _documentController.clear();
    });
  }

  Future<void> _pickBirthday() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      locale: const Locale('pt', 'BR'),
      initialDate: _birthday ?? DateTime(now.year - 30, now.month, now.day),
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (picked == null) {
      return;
    }

    setState(() {
      _birthday = picked;
      _birthdayError = ClientFormValidators.validateBirthday(picked);
      _birthdayController.text = ClientDateFormatter.formatBirthday(picked);
    });
  }

  void _clearBirthday() {
    setState(() {
      _birthday = null;
      _birthdayError = null;
      _birthdayController.clear();
    });
  }

  void _onSave() {
    final birthdayError = ClientFormValidators.validateBirthday(_birthday);

    setState(() {
      _birthdayError = birthdayError;
    });

    if (!(_formKey.currentState?.validate() ?? false) || birthdayError != null) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Dados validados com sucesso',
          style: TextStyle(color: AppColors.white),
        ),
        backgroundColor: AppColors.success,
      ),
    );
  }

  String? _validateDocument(String? value) {
    return _clientType == ClientType.individual
        ? ClientFormValidators.validateCpf(value)
        : ClientFormValidators.validateCnpj(value);
  }

  Widget _buildAddressSection(double maxWidth) {
    final useRowLayout = maxWidth >= 600;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Endereço', style: AppTextStyles.titleSmall),
        const SizedBox(height: _fieldSpacing),
        AppTextField(
          key: const Key('client_street_field'),
          label: 'Logradouro',
          hint: 'Rua, avenida, estrada etc.',
          controller: _streetController,
          keyboardType: TextInputType.streetAddress,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: _fieldSpacing),
        AppTextField(
          key: const Key('client_number_field'),
          label: 'Número',
          controller: _numberController,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: _fieldSpacing),
        AppTextField(
          key: const Key('client_complement_field'),
          label: 'Complemento',
          hint: 'Casa, apartamento, bloco etc.',
          controller: _complementController,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: _fieldSpacing),
        AppTextField(
          key: const Key('client_neighborhood_field'),
          label: 'Bairro',
          controller: _neighborhoodController,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: _fieldSpacing),
        if (useRowLayout)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 7,
                child: AppTextField(
                  key: const Key('client_city_field'),
                  label: 'Cidade',
                  controller: _cityController,
                  textInputAction: TextInputAction.next,
                ),
              ),
              const SizedBox(width: _fieldSpacing),
              Expanded(
                flex: 3,
                child: AppTextField(
                  key: const Key('client_state_field'),
                  label: 'Estado (UF)',
                  controller: _stateController,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [UpperCaseTextFormatter()],
                  maxLength: 2,
                  validator: ClientFormValidators.validateState,
                ),
              ),
            ],
          )
        else ...[
          AppTextField(
            key: const Key('client_city_field'),
            label: 'Cidade',
            controller: _cityController,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: _fieldSpacing),
          AppTextField(
            key: const Key('client_state_field'),
            label: 'Estado (UF)',
            controller: _stateController,
            textInputAction: TextInputAction.next,
            inputFormatters: [UpperCaseTextFormatter()],
            maxLength: 2,
            validator: ClientFormValidators.validateState,
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final documentLabel =
        _clientType == ClientType.individual ? 'CPF' : 'CNPJ';
    final documentHint = _clientType == ClientType.individual
        ? '000.000.000-00'
        : '00.000.000/0000-00';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Voltar',
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Novo cliente',
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
                      SegmentedButton<ClientType>(
                        segments: const [
                          ButtonSegment(
                            value: ClientType.individual,
                            label: Text('Pessoa Física'),
                          ),
                          ButtonSegment(
                            value: ClientType.company,
                            label: Text('Pessoa Jurídica'),
                          ),
                        ],
                        selected: {_clientType},
                        onSelectionChanged: _onClientTypeChanged,
                      ),
                      const SizedBox(height: _fieldSpacing),
                      AppTextField(
                        key: const Key('client_name_field'),
                        label: 'Nome',
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        validator: ClientFormValidators.validateName,
                      ),
                      const SizedBox(height: _fieldSpacing),
                      AppTextField(
                        key: const Key('client_whatsapp_field'),
                        label: 'WhatsApp',
                        hint: '+55 (00) 00000-0000',
                        controller: _whatsAppController,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [BrazilianWhatsAppInputFormatter()],
                        validator: ClientFormValidators.validateWhatsApp,
                      ),
                      const SizedBox(height: _fieldSpacing),
                      AppTextField(
                        key: const Key('client_email_field'),
                        label: 'E-mail',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: ClientFormValidators.validateEmail,
                      ),
                      const SizedBox(height: _fieldSpacing),
                      AppTextField(
                        key: ValueKey('client_document_$_clientType'),
                        label: documentLabel,
                        hint: documentHint,
                        controller: _documentController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        inputFormatters: [
                          _clientType == ClientType.individual
                              ? CpfInputFormatter()
                              : CnpjInputFormatter(),
                        ],
                        validator: _validateDocument,
                      ),
                      const SizedBox(height: _fieldSpacing),
                      _buildAddressSection(constraints.maxWidth),
                      const SizedBox(height: _fieldSpacing),
                      AppTextField(
                        key: const Key('client_instagram_field'),
                        label: 'Instagram',
                        controller: _instagramController,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: _fieldSpacing),
                      AppTextField(
                        key: const Key('client_birthday_field'),
                        label: 'Data de aniversário',
                        hint: 'Selecione a data',
                        controller: _birthdayController,
                        readOnly: true,
                        onTap: _pickBirthday,
                      ),
                      if (_birthday != null) ...[
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: _clearBirthday,
                            icon: const Icon(
                              Icons.clear,
                              size: 18,
                              color: AppColors.secondaryText,
                            ),
                            label: Text(
                              'Limpar data',
                              style: AppTextStyles.bodyMedium,
                            ),
                          ),
                        ),
                      ],
                      if (_birthdayError != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          _birthdayError!,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ],
                      const SizedBox(height: _fieldSpacing),
                      // Internal notes must never be included in budgets or PDFs.
                      // See docs/business-rules/clients.md
                      AppTextField(
                        key: const Key('client_notes_field'),
                        label: 'Observações internas',
                        controller: _notesController,
                        maxLines: 4,
                        textInputAction: TextInputAction.newline,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Esta informação não aparece no orçamento.',
                        style: AppTextStyles.caption,
                      ),
                      const SizedBox(height: 32),
                      PrimaryButton(
                        label: 'Salvar',
                        onPressed: _onSave,
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

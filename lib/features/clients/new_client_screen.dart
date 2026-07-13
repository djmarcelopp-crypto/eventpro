import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/primary_button.dart';
import 'client_form_validators.dart';
import 'client_list_feedback.dart';
import 'client_type.dart';
import 'data/exceptions/cep_lookup_exception.dart';
import 'data/exceptions/cnpj_lookup_exception.dart';
import 'data/models/cep_address_data.dart';
import 'data/utils/brazilian_mobile_phone.dart';
import 'data/utils/brazilian_phone.dart';
import 'data/models/cnpj_company_data.dart';
import 'models/client.dart';
import 'providers/clients_provider.dart';
import 'providers/cep_lookup_provider.dart';
import 'providers/cnpj_lookup_provider.dart';
import 'utils/cep_form_filler.dart';
import 'utils/client_date_formatter.dart';
import 'utils/client_form_initializer.dart';
import 'utils/cnpj_form_filler.dart';
import 'utils/form_fill_mode.dart';
import 'utils/text_input_masks.dart';

class NewClientScreen extends ConsumerStatefulWidget {
  const NewClientScreen({
    super.key,
    this.clientId,
  });

  final String? clientId;

  @override
  ConsumerState<NewClientScreen> createState() => _NewClientScreenState();
}

class _NewClientScreenState extends ConsumerState<NewClientScreen> {
  static const _maxContentWidth = 720.0;
  static const _fieldSpacing = 16.0;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _tradeNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _whatsAppController = TextEditingController();
  final _emailController = TextEditingController();
  final _documentController = TextEditingController();
  final _postalCodeController = TextEditingController();
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
  bool _isCnpjLookupLoading = false;
  bool _isCepLookupLoading = false;
  bool _alsoWhatsApp = false;
  bool _initializedForEdit = false;

  bool get _isEditing => widget.clientId != null;

  @override
  void initState() {
    super.initState();
    _documentController.addListener(_onDocumentChanged);
    _postalCodeController.addListener(_onPostalCodeChanged);
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

    final routeClient = GoRouterState.of(context).extra;
    final client = routeClient is Client
        ? routeClient
        : ref.read(clientsProvider.notifier).findById(widget.clientId!);
    if (client == null) {
      return;
    }

    final values = ClientFormInitializer.fromClient(client);
    ClientFormInitializer.applyToControllers(
      values: values,
      nameController: _nameController,
      tradeNameController: _tradeNameController,
      phoneController: _phoneController,
      whatsAppController: _whatsAppController,
      emailController: _emailController,
      documentController: _documentController,
      postalCodeController: _postalCodeController,
      streetController: _streetController,
      numberController: _numberController,
      complementController: _complementController,
      neighborhoodController: _neighborhoodController,
      cityController: _cityController,
      stateController: _stateController,
      instagramController: _instagramController,
      birthdayController: _birthdayController,
      notesController: _notesController,
    );

    setState(() {
      _clientType = values.clientType;
      _birthday = values.birthday;
      _alsoWhatsApp = values.alsoWhatsApp;
      _initializedForEdit = true;
    });
  }

  void _onPostalCodeChanged() {
    setState(() {});
  }

  void _onDocumentChanged() {
    if (_clientType == ClientType.company) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _documentController.removeListener(_onDocumentChanged);
    _postalCodeController.removeListener(_onPostalCodeChanged);
    _nameController.dispose();
    _tradeNameController.dispose();
    _phoneController.dispose();
    _whatsAppController.dispose();
    _emailController.dispose();
    _documentController.dispose();
    _postalCodeController.dispose();
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
      if (!_isEditing) {
        _documentController.clear();
        _tradeNameController.clear();
      }
    });
  }

  bool get _showCnpjLookupButton {
    if (_clientType != ClientType.company) {
      return false;
    }

    final digits = ClientFormValidators.extractDigits(_documentController.text);
    return digits.length == 14 &&
        ClientFormValidators.validateCnpj(_documentController.text) == null;
  }

  bool get _canLookupCnpj => _showCnpjLookupButton && !_isCnpjLookupLoading;

  bool get _showCepLookupButton {
    final digits = ClientFormValidators.extractDigits(_postalCodeController.text);
    return digits.length == 8 &&
        ClientFormValidators.validatePostalCode(_postalCodeController.text) ==
            null;
  }

  bool get _canLookupCep => _showCepLookupButton && !_isCepLookupLoading;

  bool get _isCompanyDocument => _clientType == ClientType.company;

  Widget _buildCnpjLookupOrientation() {
    final isValid = _showCnpjLookupButton;
    final text = isValid
        ? 'CNPJ válido. Você já pode buscar os dados da empresa.'
        : 'A busca automática será liberada após um CNPJ válido.';

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isValid ? Icons.check_circle_outline : Icons.info_outline,
            size: 16,
            color: isValid ? AppColors.success : AppColors.secondaryText,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              key: const Key('cnpj_lookup_hint'),
              style: AppTextStyles.caption.copyWith(
                color: isValid ? AppColors.success : AppColors.secondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  CnpjFormFieldValues get _currentFormValues {
    return CnpjFormFieldValues(
      name: _nameController.text,
      tradeName: _tradeNameController.text,
      phone: _phoneController.text,
      whatsApp: _whatsAppController.text,
      email: _emailController.text,
      postalCode: _postalCodeController.text,
      street: _streetController.text,
      number: _numberController.text,
      complement: _complementController.text,
      neighborhood: _neighborhoodController.text,
      city: _cityController.text,
      state: _stateController.text,
    );
  }

  void _applyFormValues(CnpjFormFieldValues values) {
    setState(() {
      _nameController.text = values.name;
      _tradeNameController.text = values.tradeName;
      _phoneController.text = values.phone;
      _whatsAppController.text = values.whatsApp;
      _emailController.text = values.email;
      _postalCodeController.text = values.postalCode;
      _streetController.text = values.street;
      _numberController.text = values.number;
      _complementController.text = values.complement;
      _neighborhoodController.text = values.neighborhood;
      _cityController.text = values.city;
      _stateController.text = values.state;
    });
  }

  CepFormFieldValues get _currentAddressValues {
    return CepFormFieldValues(
      postalCode: _postalCodeController.text,
      street: _streetController.text,
      neighborhood: _neighborhoodController.text,
      city: _cityController.text,
      state: _stateController.text,
    );
  }

  void _applyAddressValues(CepFormFieldValues values) {
    setState(() {
      _postalCodeController.text = values.postalCode;
      _streetController.text = values.street;
      _neighborhoodController.text = values.neighborhood;
      _cityController.text = values.city;
      _stateController.text = values.state;
    });
  }

  Future<FormFillMode?> _showConflictDialog(
    List<CnpjFormConflict> conflicts,
  ) async {
    return showDialog<FormFillMode>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Alguns campos já estão preenchidos'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final conflict in conflicts) ...[
                  Text(
                    conflict.fieldLabel,
                    style: AppTextStyles.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '"${conflict.currentValue}" → "${conflict.newValue}"',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(
                FormFillMode.fillEmptyOnly,
              ),
              child: const Text('Preencher só vazios'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(
                FormFillMode.replaceAll,
              ),
              child: const Text('Substituir'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _applyCompanyData(CnpjCompanyData data) async {
    final current = _currentFormValues;
    final conflicts = CnpjFormFiller.findConflicts(current, data);

    FormFillMode mode;
    if (conflicts.isEmpty) {
      mode = FormFillMode.fillEmptyOnly;
    } else {
      final selectedMode = await _showConflictDialog(conflicts);
      if (!mounted || selectedMode == null) {
        return;
      }
      mode = selectedMode;
    }

    _applyFormValues(
      CnpjFormFiller.apply(current, data, mode: mode),
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Dados da empresa carregados. Revise antes de salvar.',
        ),
      ),
    );
  }

  Future<void> _applyCepData(CepAddressData data) async {
    final current = _currentAddressValues;
    final conflicts = CepFormFiller.findConflicts(current, data);

    FormFillMode mode;
    if (conflicts.isEmpty) {
      mode = FormFillMode.fillEmptyOnly;
    } else {
      final selectedMode = await _showConflictDialog(conflicts);
      if (!mounted || selectedMode == null) {
        return;
      }
      mode = selectedMode;
    }

    _applyAddressValues(
      CepFormFiller.apply(current, data, mode: mode),
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Endereço carregado. Revise antes de salvar.',
        ),
      ),
    );
  }

  Future<void> _lookupAddressByCep() async {
    if (!_canLookupCep) {
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _isCepLookupLoading = true;
    });

    try {
      final service = ref.read(cepLookupServiceProvider);
      final data = await service.lookup(_postalCodeController.text);
      await _applyCepData(data);
    } on CepLookupException catch (error) {
      if (mounted) {
        _showLookupError(error.userMessage);
      }
    } catch (_) {
      if (mounted) {
        _showLookupError(
          const CepLookupException(CepLookupFailure.unknown).userMessage,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCepLookupLoading = false;
        });
      }
    }
  }

  void _showLookupError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }

  Future<void> _lookupCompanyData() async {
    if (!_canLookupCnpj) {
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _isCnpjLookupLoading = true;
    });

    try {
      final service = ref.read(cnpjLookupServiceProvider);
      final data = await service.lookup(_documentController.text);
      await _applyCompanyData(data);
    } on CnpjLookupException catch (error) {
      if (mounted) {
        _showLookupError(error.userMessage);
      }
    } catch (_) {
      if (mounted) {
        _showLookupError(
          const CnpjLookupException(CnpjLookupFailure.unknown).userMessage,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCnpjLookupLoading = false;
        });
      }
    }
  }

  Future<void> _pickBirthday() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      locale: const Locale('pt', 'BR'),
      initialDate: _birthday ?? today,
      firstDate: DateTime(1900),
      lastDate: today,
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

  void _onAlsoWhatsAppChanged(bool? value) {
    if (value != true) {
      setState(() {
        _alsoWhatsApp = false;
      });
      return;
    }

    final phoneDigits = BrazilianPhone.normalizeNationalDigits(
      _phoneController.text,
    );

    if (phoneDigits == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe um telefone válido antes de marcar esta opção.'),
        ),
      );
      return;
    }

    if (!BrazilianMobilePhone.isValidBrazilianMobile(phoneDigits)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Telefone fixo não pode ser usado como WhatsApp automático. '
            'Informe um celular válido no campo WhatsApp.',
          ),
        ),
      );
      return;
    }

    setState(() {
      _alsoWhatsApp = true;
      _whatsAppController.text =
          BrazilianWhatsAppInputFormatter.formatFromDigits('55$phoneDigits');
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

    final existingClient = _isEditing
        ? (GoRouterState.of(context).extra is Client
            ? GoRouterState.of(context).extra as Client
            : ref.read(clientsProvider.notifier).findById(widget.clientId!))
        : null;

    if (_isEditing && existingClient == null) {
      return;
    }

    final client = Client.fromForm(
      type: _clientType,
      name: _nameController.text,
      tradeName: _tradeNameController.text,
      phone: _phoneController.text,
      whatsApp: _whatsAppController.text,
      email: _emailController.text,
      document: _documentController.text,
      postalCode: _postalCodeController.text,
      street: _streetController.text,
      number: _numberController.text,
      complement: _complementController.text,
      neighborhood: _neighborhoodController.text,
      city: _cityController.text,
      state: _stateController.text,
      instagram: _instagramController.text,
      birthday: _birthday,
      internalNotes: _notesController.text,
      id: existingClient?.id,
      createdAt: existingClient?.createdAt,
    );

    if (_isEditing) {
      ref.read(clientsProvider.notifier).updateClient(client);
      context.go(AppRoutes.clients);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ClientListFeedbackPresenter.showSnackBar(ClientListFeedback.updated);
        });
      });
      return;
    }

    ref.read(clientsProvider.notifier).addClient(client);
    context.pop(true);
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
          key: const Key('client_postal_code_field'),
          label: 'CEP',
          hint: '00000-000',
          controller: _postalCodeController,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.next,
          inputFormatters: [CepInputFormatter()],
          validator: ClientFormValidators.validatePostalCode,
        ),
        if (_showCepLookupButton) ...[
          const SizedBox(height: 12),
          OutlinedButton(
            key: const Key('cep_lookup_button'),
            onPressed: _isCepLookupLoading ? null : _lookupAddressByCep,
            child: _isCepLookupLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : const Text('Buscar endereço'),
          ),
        ],
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
    final documentHint = _isCompanyDocument
        ? 'Digite o CNPJ para buscar os dados da empresa'
        : '000.000.000-00';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Voltar',
          onPressed: () => context.pop(),
        ),
        title: Text(
          _isEditing ? 'Editar cliente' : 'Novo cliente',
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
            key: const Key('client_form_scroll'),
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
                      if (_clientType == ClientType.company) ...[
                        const SizedBox(height: _fieldSpacing),
                        AppTextField(
                          key: const Key('client_trade_name_field'),
                          label: 'Nome fantasia',
                          controller: _tradeNameController,
                          keyboardType: TextInputType.name,
                          textInputAction: TextInputAction.next,
                        ),
                      ],
                      const SizedBox(height: _fieldSpacing),
                      AppTextField(
                        key: const Key('client_phone_field'),
                        label: 'Telefone',
                        hint: '(00) 00000-0000',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        prefixIcon: const Icon(Icons.phone),
                        inputFormatters: [BrazilianPhoneInputFormatter()],
                        validator: ClientFormValidators.validatePhone,
                      ),
                      CheckboxListTile(
                        key: const Key('client_also_whatsapp_checkbox'),
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(
                          'Este número também é WhatsApp',
                          style: AppTextStyles.bodyMedium,
                        ),
                        value: _alsoWhatsApp,
                        onChanged: _onAlsoWhatsAppChanged,
                      ),
                      const SizedBox(height: _fieldSpacing),
                      AppTextField(
                        key: const Key('client_whatsapp_field'),
                        label: 'WhatsApp',
                        hint: '+55 (00) 00000-0000',
                        controller: _whatsAppController,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        prefixIcon: const FaIcon(
                          FontAwesomeIcons.whatsapp,
                          color: AppColors.whatsapp,
                        ),
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
                        key: const Key('client_document_field'),
                        label: documentLabel,
                        hint: documentHint,
                        hintMaxLines: _isCompanyDocument ? 2 : 1,
                        controller: _documentController,
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        prefixIcon: _isCompanyDocument
                            ? const Icon(
                                Icons.search,
                                color: AppColors.primary,
                              )
                            : null,
                        suffixIcon: _isCompanyDocument && _showCnpjLookupButton
                            ? const Icon(
                                Icons.check_circle_outline,
                                color: AppColors.success,
                              )
                            : null,
                        inputFormatters: [
                          _clientType == ClientType.individual
                              ? CpfInputFormatter()
                              : CnpjInputFormatter(),
                        ],
                        validator: _validateDocument,
                      ),
                      if (_isCompanyDocument) _buildCnpjLookupOrientation(),
                      if (_showCnpjLookupButton) ...[
                        const SizedBox(height: 12),
                        OutlinedButton(
                          key: const Key('cnpj_lookup_button'),
                          onPressed:
                              _isCnpjLookupLoading ? null : _lookupCompanyData,
                          child: _isCnpjLookupLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Buscar dados da empresa'),
                        ),
                      ],
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
                        key: const Key('client_save_button'),
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

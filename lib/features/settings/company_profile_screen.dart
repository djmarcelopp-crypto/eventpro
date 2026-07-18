import 'dart:async';

import 'package:eventpro/core/lookup/exceptions/cep_lookup_exception.dart';
import 'package:eventpro/core/lookup/exceptions/cnpj_lookup_exception.dart';
import 'package:eventpro/core/lookup/form_fill_mode.dart';
import 'package:eventpro/core/lookup/models/cep_address_data.dart';
import 'package:eventpro/core/lookup/models/cnpj_company_data.dart';
import 'package:eventpro/core/lookup/providers/cep_lookup_provider.dart';
import 'package:eventpro/core/lookup/providers/cnpj_lookup_provider.dart';
import 'package:eventpro/core/media/exceptions/app_image_pick_exception.dart';
import 'package:eventpro/core/media/utils/app_image_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/primary_button.dart';
import 'package:eventpro/core/formatting/text_input_masks.dart';
import 'data/services/company_logo_picker_service.dart';
import 'data/services/company_logo_storage_service.dart';
import 'models/pix_key_type.dart';
import 'providers/company_logo_services_provider.dart';
import 'providers/company_profile_clock_provider.dart';
import 'providers/company_profile_provider.dart';
import 'utils/company_profile_form_initializer.dart';
import 'utils/company_profile_form_validators.dart';
import 'utils/settings_cep_form_filler.dart';
import 'utils/settings_cnpj_form_filler.dart';
import 'utils/settings_form_conflict.dart';
import 'utils/settings_navigation.dart';
import 'settings_feedback.dart';
import 'widgets/company_logo_form_section.dart';

class CompanyProfileScreen extends ConsumerStatefulWidget {
  const CompanyProfileScreen({super.key});

  @override
  ConsumerState<CompanyProfileScreen> createState() =>
      _CompanyProfileScreenState();
}

class _CompanyProfileScreenState extends ConsumerState<CompanyProfileScreen> {
  static const _maxContentWidth = 720.0;
  static const _fieldSpacing = 16.0;
  static const _logoOwnerId = 'company';

  final _formKey = GlobalKey<FormState>();
  final _tradeNameController = TextEditingController();
  final _legalNameController = TextEditingController();
  final _cnpjController = TextEditingController();
  final _stateRegistrationController = TextEditingController();
  final _phoneController = TextEditingController();
  final _whatsAppController = TextEditingController();
  final _emailController = TextEditingController();
  final _instagramController = TextEditingController();
  final _websiteController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _streetController = TextEditingController();
  final _numberController = TextEditingController();
  final _complementController = TextEditingController();
  final _neighborhoodController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _legalFullNameController = TextEditingController();
  final _legalCpfController = TextEditingController();
  final _legalRoleController = TextEditingController();
  final _pixKeyController = TextEditingController();
  final _beneficiaryNameController = TextEditingController();
  final _paymentTermsController = TextEditingController();
  final _defaultValidityDaysController = TextEditingController(text: '7');
  final _defaultPublicNotesController = TextEditingController();

  PixKeyType? _pixKeyType;
  String? _contactError;
  String? _legalRepresentativeError;
  String? _pixError;
  bool _initialized = false;
  bool _saving = false;
  bool _suppressDirty = true;
  bool _isDirty = false;
  bool _formSaved = false;
  bool _discardConfirmed = false;
  bool _isCnpjLookupLoading = false;
  bool _isCepLookupLoading = false;

  String? _originalLogoReference;
  String? _stagedLogoReference;
  bool _removeLogoRequested = false;
  bool _pickingLogo = false;
  CompanyLogoStorageService? _logoStorage;
  CompanyLogoPickerService? _logoPicker;

  bool get _canPopWithoutDialog =>
      !_saving && (!_isDirty || _formSaved || _discardConfirmed);

  String? get _previewLogoReference {
    if (_stagedLogoReference != null) {
      return _stagedLogoReference;
    }
    if (_removeLogoRequested) {
      return null;
    }
    return _originalLogoReference;
  }

  bool get _showCnpjLookupButton {
    final digits = CompanyProfileFormValidators.extractDigits(
      _cnpjController.text,
    );
    return digits.length == 14 &&
        CompanyProfileFormValidators.validateCnpj(_cnpjController.text) == null;
  }

  bool get _canLookupCnpj => _showCnpjLookupButton && !_isCnpjLookupLoading;

  bool get _showCepLookupButton {
    final digits = CompanyProfileFormValidators.extractDigits(
      _postalCodeController.text,
    );
    return digits.length == 8 &&
        CompanyProfileFormValidators.validatePostalCode(
              _postalCodeController.text,
            ) ==
            null;
  }

  bool get _canLookupCep => _showCepLookupButton && !_isCepLookupLoading;

  List<TextEditingController> get _allControllers => [
    _tradeNameController,
    _legalNameController,
    _cnpjController,
    _stateRegistrationController,
    _phoneController,
    _whatsAppController,
    _emailController,
    _instagramController,
    _websiteController,
    _postalCodeController,
    _streetController,
    _numberController,
    _complementController,
    _neighborhoodController,
    _cityController,
    _stateController,
    _legalFullNameController,
    _legalCpfController,
    _legalRoleController,
    _pixKeyController,
    _beneficiaryNameController,
    _paymentTermsController,
    _defaultValidityDaysController,
    _defaultPublicNotesController,
  ];

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_clearContactError);
    _whatsAppController.addListener(_clearContactError);
    _emailController.addListener(_clearContactError);
    for (final controller in _allControllers) {
      controller.addListener(_markDirty);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeFromProfile();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _logoStorage ??= ref.read(companyLogoStorageProvider);
    _logoPicker ??= ref.read(companyLogoPickerProvider);
  }

  @override
  void dispose() {
    if (!_formSaved) {
      unawaited(_discardStagedLogoOnly());
    }
    for (final controller in _allControllers) {
      controller.removeListener(_markDirty);
    }
    _tradeNameController.dispose();
    _legalNameController.dispose();
    _cnpjController.dispose();
    _stateRegistrationController.dispose();
    _phoneController.dispose();
    _whatsAppController.dispose();
    _emailController.dispose();
    _instagramController.dispose();
    _websiteController.dispose();
    _postalCodeController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    _complementController.dispose();
    _neighborhoodController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _legalFullNameController.dispose();
    _legalCpfController.dispose();
    _legalRoleController.dispose();
    _pixKeyController.dispose();
    _beneficiaryNameController.dispose();
    _paymentTermsController.dispose();
    _defaultValidityDaysController.dispose();
    _defaultPublicNotesController.dispose();
    super.dispose();
  }

  void _initializeFromProfile() {
    if (_initialized) {
      return;
    }

    final profile = ref.read(companyProfileProvider);
    if (profile != null) {
      final values = CompanyProfileFormInitializer.fromProfile(profile);
      CompanyProfileFormInitializer.applyToControllers(
        values: values,
        tradeNameController: _tradeNameController,
        legalNameController: _legalNameController,
        cnpjController: _cnpjController,
        stateRegistrationController: _stateRegistrationController,
        phoneController: _phoneController,
        whatsAppController: _whatsAppController,
        emailController: _emailController,
        instagramController: _instagramController,
        websiteController: _websiteController,
        postalCodeController: _postalCodeController,
        streetController: _streetController,
        numberController: _numberController,
        complementController: _complementController,
        neighborhoodController: _neighborhoodController,
        cityController: _cityController,
        stateController: _stateController,
        legalFullNameController: _legalFullNameController,
        legalCpfController: _legalCpfController,
        legalRoleController: _legalRoleController,
        pixKeyController: _pixKeyController,
        beneficiaryNameController: _beneficiaryNameController,
        paymentTermsController: _paymentTermsController,
        defaultValidityDaysController: _defaultValidityDaysController,
        defaultPublicNotesController: _defaultPublicNotesController,
        onPixKeyTypeChanged: (value) {
          setState(() {
            _pixKeyType = value;
          });
        },
      );
      _originalLogoReference = profile.logoReference;
    }

    _initialized = true;
    _suppressDirty = false;
  }

  void _markDirty() {
    if (_suppressDirty || _formSaved) {
      return;
    }
    if (!_isDirty) {
      setState(() => _isDirty = true);
    }
  }

  void _clearContactError() {
    if (_contactError != null) {
      setState(() {
        _contactError = null;
      });
    }
  }

  Future<void> _discardStagedLogoOnly() async {
    final stagedReference = _stagedLogoReference;
    final storage = _logoStorage;
    if (stagedReference == null || storage == null) {
      return;
    }

    await storage.discardStaged(stagedReference);
    _stagedLogoReference = null;
  }

  void _showLogoError(String message) {
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
          backgroundColor: AppColors.error,
        ),
      );
  }

  Future<void> _handleSelectLogo() async {
    if (_pickingLogo || _saving) {
      return;
    }

    setState(() => _pickingLogo = true);

    try {
      final picker = _logoPicker;
      if (picker == null) {
        _showLogoError(
          'Não foi possível abrir o seletor de imagens. Tente novamente.',
        );
        return;
      }

      final pickResult = await picker.pickImage();
      if (pickResult == null || !mounted) {
        return;
      }

      final validation = await AppImageValidator.validate(pickResult.bytes);
      if (!validation.isValid) {
        _showLogoError(validation.errorMessage!);
        return;
      }

      final storage = _logoStorage;
      if (storage == null) {
        _showLogoError('Não foi possível salvar o logotipo. Tente novamente.');
        return;
      }

      if (_stagedLogoReference != null) {
        await storage.discardStaged(_stagedLogoReference);
      }

      final stagedReference = await storage.stageFromPick(
        bytes: pickResult.bytes,
        extension: pickResult.extension,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _stagedLogoReference = stagedReference;
        _removeLogoRequested = false;
        _isDirty = true;
      });
    } on AppImagePickException catch (error) {
      if (mounted) {
        _showLogoError(error.message);
      }
    } catch (_) {
      if (mounted) {
        _showLogoError(
          'Não foi possível selecionar o logotipo. Tente novamente.',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _pickingLogo = false);
      }
    }
  }

  Future<void> _handleRemoveLogo() async {
    if (_pickingLogo || _saving) {
      return;
    }

    await _discardStagedLogoOnly();
    if (!mounted) {
      return;
    }

    setState(() {
      _stagedLogoReference = null;
      _removeLogoRequested = true;
      _isDirty = true;
    });
  }

  SettingsCnpjFormFieldValues get _currentCnpjFormValues {
    return SettingsCnpjFormFieldValues(
      tradeName: _tradeNameController.text,
      legalName: _legalNameController.text,
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

  void _applyCnpjFormValues(SettingsCnpjFormFieldValues values) {
    setState(() {
      _tradeNameController.text = values.tradeName;
      _legalNameController.text = values.legalName;
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
      _isDirty = true;
    });
  }

  SettingsCepFormFieldValues get _currentCepFormValues {
    return SettingsCepFormFieldValues(
      postalCode: _postalCodeController.text,
      street: _streetController.text,
      neighborhood: _neighborhoodController.text,
      city: _cityController.text,
      state: _stateController.text,
    );
  }

  void _applyCepFormValues(SettingsCepFormFieldValues values) {
    setState(() {
      _postalCodeController.text = values.postalCode;
      _streetController.text = values.street;
      _neighborhoodController.text = values.neighborhood;
      _cityController.text = values.city;
      _stateController.text = values.state;
      _isDirty = true;
    });
  }

  Future<FormFillMode?> _showConflictDialog(
    List<SettingsFormConflict> conflicts,
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
                  Text(conflict.fieldLabel, style: AppTextStyles.titleSmall),
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
              key: const Key('settings_conflict_cancel_button'),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              key: const Key('settings_conflict_fill_empty_button'),
              onPressed: () =>
                  Navigator.of(context).pop(FormFillMode.fillEmptyOnly),
              child: const Text('Preencher só vazios'),
            ),
            TextButton(
              key: const Key('settings_conflict_replace_button'),
              onPressed: () =>
                  Navigator.of(context).pop(FormFillMode.replaceAll),
              child: const Text('Substituir'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _applyCompanyData(CnpjCompanyData data) async {
    final current = _currentCnpjFormValues;
    final conflicts = SettingsCnpjFormFiller.findConflicts(current, data);

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

    _applyCnpjFormValues(
      SettingsCnpjFormFiller.apply(current, data, mode: mode),
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Dados da empresa carregados. Revise antes de salvar.'),
      ),
    );
  }

  Future<void> _applyCepData(CepAddressData data) async {
    final current = _currentCepFormValues;
    final conflicts = SettingsCepFormFiller.findConflicts(current, data);

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

    _applyCepFormValues(SettingsCepFormFiller.apply(current, data, mode: mode));

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Endereço carregado. Revise antes de salvar.'),
      ),
    );
  }

  void _showLookupError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  Future<void> _lookupCompanyData() async {
    if (!_canLookupCnpj) {
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isCnpjLookupLoading = true);

    try {
      final service = ref.read(cnpjLookupServiceProvider);
      final digits = CompanyProfileFormValidators.extractDigits(
        _cnpjController.text,
      );
      final data = await service.lookup(digits);
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
        setState(() => _isCnpjLookupLoading = false);
      }
    }
  }

  Future<void> _lookupAddressByCep() async {
    if (!_canLookupCep) {
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _isCepLookupLoading = true);

    try {
      final service = ref.read(cepLookupServiceProvider);
      final digits = CompanyProfileFormValidators.extractDigits(
        _postalCodeController.text,
      );
      final data = await service.lookup(digits);
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
        setState(() => _isCepLookupLoading = false);
      }
    }
  }

  Future<bool?> _showDiscardDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text('Descartar alterações?'),
          content: const Text('As alterações não salvas serão perdidas.'),
          actions: [
            TextButton(
              key: const Key('settings_discard_cancel_button'),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              key: const Key('settings_discard_confirm_button'),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Descartar',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleBack({bool afterSave = false}) async {
    if (_saving) {
      return;
    }

    if (afterSave || _canPopWithoutDialog) {
      SettingsNavigation.leaveCompanyProfile(
        context,
        showSavedFeedback: afterSave,
      );
      return;
    }

    final discard = await _showDiscardDialog();
    if (discard == true && mounted) {
      await _discardStagedLogoOnly();
      setState(() {
        _discardConfirmed = true;
        _isDirty = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          SettingsNavigation.leaveCompanyProfile(context);
        }
      });
    }
  }

  Future<void> _save() async {
    if (_saving) {
      return;
    }

    setState(() {
      _contactError = null;
      _legalRepresentativeError = null;
      _pixError = null;
    });

    final isValid = _formKey.currentState?.validate() ?? false;

    final contactError = CompanyProfileFormValidators.validateAtLeastOneContact(
      phone: _phoneController.text,
      whatsApp: _whatsAppController.text,
      email: _emailController.text,
    );

    final legalError = CompanyProfileFormValidators.validateLegalRepresentative(
      fullName: _legalFullNameController.text,
      cpf: _legalCpfController.text,
      role: _legalRoleController.text,
    );

    final pixError = CompanyProfileFormValidators.validatePix(
      pixKeyType: _pixKeyType,
      pixKey: _pixKeyController.text,
    );

    if (contactError != null || legalError != null || pixError != null) {
      setState(() {
        _contactError = contactError;
        _legalRepresentativeError = legalError;
        _pixError = pixError;
      });
    }

    if (!isValid ||
        contactError != null ||
        legalError != null ||
        pixError != null) {
      return;
    }

    setState(() => _saving = true);

    final storage = _logoStorage!;
    final originalLogoToDelete = _originalLogoReference;
    String? committedLogoReference;
    String? rollbackLogoReference;

    try {
      final existing = ref.read(companyProfileProvider);
      final now = ref.read(companyProfileClockProvider)();
      final validityDays = int.parse(
        _defaultValidityDaysController.text.trim(),
      );

      String? finalLogoReference;
      var clearLogoReference = false;

      if (_stagedLogoReference != null) {
        committedLogoReference = await storage.commitStaged(
          stagedReference: _stagedLogoReference!,
          ownerId: _logoOwnerId,
        );
        rollbackLogoReference = committedLogoReference;
        finalLogoReference = committedLogoReference;
        _stagedLogoReference = null;
      } else if (_removeLogoRequested) {
        finalLogoReference = null;
        clearLogoReference = existing?.logoReference != null;
      } else {
        finalLogoReference = _originalLogoReference;
      }

      final profile = CompanyProfileFormInitializer.buildProfile(
        existing: existing,
        tradeName: _tradeNameController.text,
        legalName: _legalNameController.text,
        cnpj: _cnpjController.text,
        stateRegistration: _stateRegistrationController.text,
        phone: _phoneController.text,
        whatsApp: _whatsAppController.text,
        email: _emailController.text,
        instagram: _instagramController.text,
        website: _websiteController.text,
        postalCode: _postalCodeController.text,
        street: _streetController.text,
        number: _numberController.text,
        complement: _complementController.text,
        neighborhood: _neighborhoodController.text,
        city: _cityController.text,
        state: _stateController.text,
        legalFullName: _legalFullNameController.text,
        legalCpf: _legalCpfController.text,
        legalRole: _legalRoleController.text,
        pixKeyType: _pixKeyType,
        pixKey: _pixKeyController.text,
        beneficiaryName: _beneficiaryNameController.text,
        paymentTerms: _paymentTermsController.text,
        defaultValidityDays: validityDays,
        defaultPublicNotes: _defaultPublicNotesController.text,
        now: now,
        logoReference: finalLogoReference,
        clearLogoReference: clearLogoReference,
      );

      final saved = await ref
          .read(companyProfileProvider.notifier)
          .save(profile);

      if (!saved) {
        if (rollbackLogoReference != null) {
          await storage.deleteCommitted(rollbackLogoReference);
        }
        if (mounted) {
          SettingsFeedbackPresenter.showErrorSnackBar(
            SettingsErrorFeedback.save,
          );
        }
        return;
      }

      if (_removeLogoRequested && originalLogoToDelete != null) {
        await storage.deleteCommitted(originalLogoToDelete);
      } else if (committedLogoReference != null &&
          originalLogoToDelete != null &&
          originalLogoToDelete != committedLogoReference) {
        await storage.deleteCommitted(originalLogoToDelete);
      }

      _formSaved = true;
      _isDirty = false;

      if (!mounted) {
        return;
      }

      SettingsNavigation.leaveCompanyProfile(context, showSavedFeedback: true);
    } catch (_) {
      if (rollbackLogoReference != null) {
        await storage.deleteCommitted(rollbackLogoReference);
      }
      if (mounted) {
        _showLogoError('Não foi possível salvar o logotipo. Tente novamente.');
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

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
              key: const Key('settings_cnpj_lookup_hint'),
              style: AppTextStyles.caption.copyWith(
                color: isValid ? AppColors.success : AppColors.secondaryText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection(double maxWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          key: const Key('company_postal_code_field'),
          label: 'CEP',
          controller: _postalCodeController,
          keyboardType: TextInputType.number,
          inputFormatters: [CepInputFormatter()],
          validator: CompanyProfileFormValidators.validatePostalCode,
          textInputAction: TextInputAction.next,
        ),
        if (_showCepLookupButton) ...[
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton(
              key: const Key('settings_cep_lookup_button'),
              onPressed: _isCepLookupLoading ? null : _lookupAddressByCep,
              child: _isCepLookupLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Buscar endereço pelo CEP'),
            ),
          ),
        ],
        const SizedBox(height: _fieldSpacing),
        AppTextField(
          key: const Key('company_street_field'),
          label: 'Logradouro',
          controller: _streetController,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: _fieldSpacing),
        AppTextField(
          key: const Key('company_number_field'),
          label: 'Número',
          controller: _numberController,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: _fieldSpacing),
        AppTextField(
          key: const Key('company_complement_field'),
          label: 'Complemento',
          controller: _complementController,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: _fieldSpacing),
        AppTextField(
          key: const Key('company_neighborhood_field'),
          label: 'Bairro',
          controller: _neighborhoodController,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: _fieldSpacing),
        AppTextField(
          key: const Key('company_city_field'),
          label: 'Cidade',
          controller: _cityController,
          textInputAction: TextInputAction.next,
        ),
        const SizedBox(height: _fieldSpacing),
        AppTextField(
          key: const Key('company_state_field'),
          label: 'Estado (UF)',
          controller: _stateController,
          inputFormatters: [UpperCaseTextFormatter()],
          validator: CompanyProfileFormValidators.validateState,
          textInputAction: TextInputAction.next,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canPopWithoutDialog,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        await _handleBack();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            tooltip: 'Voltar',
            onPressed: _saving ? null : () => _handleBack(),
          ),
          title: Text(
            'Dados da empresa',
            style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
          ),
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.white,
          elevation: 0,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              key: const Key('company_profile_scroll'),
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _sectionTitle('Logotipo'),
                        const SizedBox(height: _fieldSpacing),
                        CompanyLogoFormSection(
                          previewReference: _previewLogoReference,
                          onSelectLogo: _handleSelectLogo,
                          onReplaceLogo: _handleSelectLogo,
                          onRemoveLogo: _handleRemoveLogo,
                          isBusy: _pickingLogo || _saving,
                        ),
                        const SizedBox(height: 32),
                        _sectionTitle('Identificação'),
                        const SizedBox(height: _fieldSpacing),
                        AppTextField(
                          key: const Key('company_trade_name_field'),
                          label: 'Nome fantasia / comercial *',
                          controller: _tradeNameController,
                          validator:
                              CompanyProfileFormValidators.validateTradeName,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: _fieldSpacing),
                        AppTextField(
                          key: const Key('company_legal_name_field'),
                          label: 'Razão social',
                          controller: _legalNameController,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: _fieldSpacing),
                        AppTextField(
                          key: const Key('company_cnpj_field'),
                          label: 'CNPJ',
                          controller: _cnpjController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [CnpjInputFormatter()],
                          validator: CompanyProfileFormValidators.validateCnpj,
                          textInputAction: TextInputAction.next,
                          prefixIcon: const Icon(
                            Icons.search,
                            color: AppColors.primary,
                          ),
                          suffixIcon: _showCnpjLookupButton
                              ? const Icon(
                                  Icons.check_circle_outline,
                                  color: AppColors.success,
                                )
                              : null,
                        ),
                        _buildCnpjLookupOrientation(),
                        if (_showCnpjLookupButton) ...[
                          const SizedBox(height: 12),
                          OutlinedButton(
                            key: const Key('settings_cnpj_lookup_button'),
                            onPressed: _isCnpjLookupLoading
                                ? null
                                : _lookupCompanyData,
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
                        AppTextField(
                          key: const Key('company_state_registration_field'),
                          label: 'Inscrição estadual',
                          controller: _stateRegistrationController,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 32),
                        _sectionTitle('Contato'),
                        const SizedBox(height: _fieldSpacing),
                        AppTextField(
                          key: const Key('company_phone_field'),
                          label: 'Telefone',
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [BrazilianPhoneInputFormatter()],
                          validator: CompanyProfileFormValidators.validatePhone,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: _fieldSpacing),
                        AppTextField(
                          key: const Key('company_whatsapp_field'),
                          label: 'WhatsApp',
                          controller: _whatsAppController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [BrazilianWhatsAppInputFormatter()],
                          validator:
                              CompanyProfileFormValidators.validateWhatsApp,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: _fieldSpacing),
                        AppTextField(
                          key: const Key('company_email_field'),
                          label: 'E-mail',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: CompanyProfileFormValidators.validateEmail,
                          textInputAction: TextInputAction.next,
                        ),
                        if (_contactError != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            _contactError!,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ],
                        const SizedBox(height: _fieldSpacing),
                        AppTextField(
                          key: const Key('company_instagram_field'),
                          label: 'Instagram',
                          controller: _instagramController,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: _fieldSpacing),
                        AppTextField(
                          key: const Key('company_website_field'),
                          label: 'Site',
                          controller: _websiteController,
                          keyboardType: TextInputType.url,
                          validator:
                              CompanyProfileFormValidators.validateWebsite,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 32),
                        _sectionTitle('Endereço'),
                        const SizedBox(height: _fieldSpacing),
                        _buildAddressSection(constraints.maxWidth),
                        const SizedBox(height: 32),
                        _sectionTitle('Responsável legal'),
                        const SizedBox(height: _fieldSpacing),
                        AppTextField(
                          key: const Key('company_legal_full_name_field'),
                          label: 'Nome completo',
                          controller: _legalFullNameController,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: _fieldSpacing),
                        AppTextField(
                          key: const Key('company_legal_cpf_field'),
                          label: 'CPF',
                          controller: _legalCpfController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [CpfInputFormatter()],
                          validator: CompanyProfileFormValidators.validateCpf,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: _fieldSpacing),
                        AppTextField(
                          key: const Key('company_legal_role_field'),
                          label: 'Cargo/função',
                          controller: _legalRoleController,
                          textInputAction: TextInputAction.next,
                        ),
                        if (_legalRepresentativeError != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            _legalRepresentativeError!,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ],
                        const SizedBox(height: 32),
                        _sectionTitle('Pagamento'),
                        const SizedBox(height: _fieldSpacing),
                        KeyedSubtree(
                          key: ValueKey('company_pix_key_type_$_pixKeyType'),
                          child: DropdownButtonFormField<PixKeyType>(
                            key: const Key('company_pix_key_type_field'),
                            initialValue: _pixKeyType,
                            decoration: const InputDecoration(
                              labelText: 'Tipo da chave PIX',
                            ),
                            items: [
                              for (final type in PixKeyType.values)
                                DropdownMenuItem(
                                  value: type,
                                  child: Text(type.label),
                                ),
                            ],
                            onChanged: _saving
                                ? null
                                : (value) {
                                    setState(() {
                                      _pixKeyType = value;
                                      _pixError = null;
                                      _isDirty = true;
                                    });
                                  },
                          ),
                        ),
                        const SizedBox(height: _fieldSpacing),
                        AppTextField(
                          key: const Key('company_pix_key_field'),
                          label: 'Chave PIX',
                          controller: _pixKeyController,
                          textInputAction: TextInputAction.next,
                          onChanged: (_) {
                            if (_pixError != null) {
                              setState(() {
                                _pixError = null;
                              });
                            }
                          },
                        ),
                        if (_pixError != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            _pixError!,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ],
                        const SizedBox(height: _fieldSpacing),
                        AppTextField(
                          key: const Key('company_beneficiary_name_field'),
                          label: 'Nome do beneficiário',
                          controller: _beneficiaryNameController,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: _fieldSpacing),
                        AppTextField(
                          key: const Key('company_payment_terms_field'),
                          label: 'Condições padrão de pagamento',
                          controller: _paymentTermsController,
                          maxLines: 3,
                          textInputAction: TextInputAction.newline,
                        ),
                        const SizedBox(height: 32),
                        _sectionTitle('Padrões de orçamento'),
                        const SizedBox(height: _fieldSpacing),
                        AppTextField(
                          key: const Key('company_default_validity_days_field'),
                          label: 'Validade padrão (dias) *',
                          controller: _defaultValidityDaysController,
                          keyboardType: TextInputType.number,
                          validator: CompanyProfileFormValidators
                              .validateDefaultValidityDays,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: _fieldSpacing),
                        AppTextField(
                          key: const Key('company_default_public_notes_field'),
                          label: 'Observações públicas padrão',
                          controller: _defaultPublicNotesController,
                          maxLines: 3,
                          textInputAction: TextInputAction.newline,
                        ),
                        const SizedBox(height: 32),
                        PrimaryButton(
                          key: const Key('company_profile_save_button'),
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

  Widget _sectionTitle(String title) {
    return Text(title, style: AppTextStyles.titleMedium);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';

import '../catalog/models/catalog_item.dart';
import '../catalog/providers/catalog_provider.dart';
import '../catalog/utils/brazilian_currency_input_formatter.dart';
import '../clients/models/client.dart';
import '../clients/providers/clients_provider.dart';
import '../clients/utils/client_display_formatter.dart';
import 'models/quote.dart';
import 'models/quote_client_snapshot.dart';
import 'models/quote_company_snapshot.dart';
import 'models/quote_event_snapshot.dart';
import 'models/quote_line_draft.dart';
import 'models/quote_line_item.dart';
import 'models/quote_status.dart';
import 'providers/quote_clock_provider.dart';
import 'providers/quote_company_logo_storage_provider.dart';
import 'providers/quotes_provider.dart';
import '../settings/providers/company_profile_provider.dart';
import 'state/quote_form_state.dart';
import 'utils/quote_form_defaults.dart';
import 'utils/quote_new_draft_company_snapshot_coordinator.dart';
import 'utils/quote_form_initializer.dart';
import 'utils/quote_line_draft_saver.dart';
import 'utils/quote_date_formatter.dart';
import 'utils/quote_draft_id_generator.dart';
import 'utils/quote_form_validators.dart';
import 'utils/quote_money.dart';
import 'utils/quote_package_component_mapper.dart';
import 'utils/quote_money_display.dart';
import 'utils/quote_time_formatter.dart';
import 'widgets/quote_catalog_item_selector.dart';
import 'widgets/quote_client_selector.dart';
import 'widgets/quote_event_section.dart';
import 'widgets/quote_financial_summary.dart';
import 'widgets/quote_line_editor.dart';
import 'widgets/quote_company_profile_banner.dart';
import 'widgets/quote_validity_notes_section.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/primary_button.dart';

class NewQuoteScreen extends ConsumerStatefulWidget {
  const NewQuoteScreen({
    super.key,
    this.quoteId,
  });

  final String? quoteId;

  bool get isEditing => quoteId != null;

  @override
  ConsumerState<NewQuoteScreen> createState() => _NewQuoteScreenState();
}

class _NewQuoteScreenState extends ConsumerState<NewQuoteScreen> {
  static const _maxContentWidth = 720.0;
  static const _fieldSpacing = 16.0;

  final _formKey = GlobalKey<FormState>();
  final _draftIdGenerator = QuoteDraftIdGenerator();

  final _eventNameController = TextEditingController();
  final _eventTypeController = TextEditingController();
  final _eventDateController = TextEditingController();
  final _eventStartTimeController = TextEditingController();
  final _eventEndTimeController = TextEditingController();
  final _eventVenueController = TextEditingController();
  final _eventAddressController = TextEditingController();
  final _guestCountController = TextEditingController();
  final _discountController = TextEditingController();
  final _freightController = TextEditingController();
  final _validUntilController = TextEditingController();
  final _notesController = TextEditingController();
  final _internalNotesController = TextEditingController();

  final Map<String, TextEditingController> _quantityControllers = {};
  final Map<String, TextEditingController> _priceControllers = {};

  String? _selectedClientId;
  DateTime? _validUntil;
  DateTime? _eventDate;
  TimeOfDayValue? _startTime;
  TimeOfDayValue? _endTime;
  final List<QuoteLineDraft> _lines = [];

  bool _isDirty = false;
  bool _formSaved = false;
  bool _discardConfirmed = false;
  bool _saving = false;
  bool _initializedForEdit = false;
  bool _defaultsApplied = false;
  bool _applyingDefaults = false;
  String? _editingQuoteId;

  String? _clientError;
  String? _linesError;
  String? _guestCountError;
  String? _validUntilError;
  String? _saveError;

  bool get _isEditing => widget.quoteId != null;

  bool get _canPopWithoutDialog =>
      !_saving && (!_isDirty || _formSaved || _discardConfirmed);

  @override
  void initState() {
    super.initState();
    if (!_isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _applyNewQuoteDefaultsOnce();
      });
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeForEditIfNeeded();
      });
    }

    for (final controller in [
      _eventNameController,
      _eventTypeController,
      _eventVenueController,
      _eventAddressController,
      _guestCountController,
      _discountController,
      _freightController,
      _notesController,
      _internalNotesController,
    ]) {
      controller.addListener(_markDirty);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeForEditIfNeeded();
  }

  void _applyNewQuoteDefaultsOnce() {
    if (_defaultsApplied || _isEditing || !mounted) {
      return;
    }

    _defaultsApplied = true;
    final now = ref.read(quoteClockProvider)();
    final profile = ref.read(companyProfileProvider);
    final defaults = QuoteFormDefaults.fromCompanyProfile(
      profile,
      clock: now,
    );

    _applyingDefaults = true;
    try {
      setState(() {
        _validUntil = defaults.validUntil;
        _validUntilController.text =
            QuoteDateFormatter.format(defaults.validUntil);
        if (defaults.publicNotes.isNotEmpty) {
          _notesController.text = defaults.publicNotes;
        }
      });
    } finally {
      _applyingDefaults = false;
    }
  }

  void _initializeForEditIfNeeded() {
    if (!_isEditing || _initializedForEdit) {
      return;
    }

    final quote =
        ref.read(quotesProvider.notifier).findById(widget.quoteId!);
    if (quote == null) {
      return;
    }

    if (quote.status != QuoteStatus.draft) {
      _initializedForEdit = true;
      return;
    }

    _applyQuoteToForm(quote);
    _initializedForEdit = true;
    _editingQuoteId = quote.id;
  }

  void _applyQuoteToForm(Quote quote) {
    final values = QuoteFormInitializer.fromQuote(quote);

    _selectedClientId = values.selectedClientId;
    _validUntil = values.validUntil;
    _eventDate = values.eventDate;
    _startTime = _parseTime(values.eventStartTimeText);
    _endTime = _parseTime(values.eventEndTimeText);

    _eventNameController.text = values.eventName;
    _eventTypeController.text = values.eventType;
    _eventDateController.text = values.eventDateText;
    _eventStartTimeController.text = values.eventStartTimeText;
    _eventEndTimeController.text = values.eventEndTimeText;
    _eventVenueController.text = values.eventVenueName;
    _eventAddressController.text = values.eventAddress;
    _guestCountController.text = values.guestCountText;
    _discountController.text = values.discountText;
    _freightController.text = values.freightText;
    _validUntilController.text = values.validUntilText;
    _notesController.text = values.notes;
    _internalNotesController.text = values.internalNotes;

    for (final controller in _quantityControllers.values) {
      controller.dispose();
    }
    for (final controller in _priceControllers.values) {
      controller.dispose();
    }
    _quantityControllers.clear();
    _priceControllers.clear();
    _lines.clear();

    for (var i = 0; i < quote.items.length; i++) {
      final draftId = _draftIdGenerator.nextLineDraftId();
      final draft = QuoteFormInitializer.lineDraftFromItem(
        quote.items[i],
        draftId: draftId,
      );

      final quantityController =
          TextEditingController(text: draft.quantityText);
      final priceController = TextEditingController(text: draft.priceText);
      quantityController.addListener(_markDirty);
      priceController.addListener(_markDirty);

      _quantityControllers[draftId] = quantityController;
      _priceControllers[draftId] = priceController;
      _lines.add(draft);
    }

    setState(() {
      _isDirty = false;
      _clientError = null;
      _linesError = null;
      _guestCountError = null;
      _validUntilError = null;
      _saveError = null;
    });
  }

  TimeOfDayValue? _parseTime(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return null;
    }

    final parts = trimmed.split(':');
    if (parts.length != 2) {
      return null;
    }

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    if (hour == null || minute == null) {
      return null;
    }

    return TimeOfDayValue(hour: hour, minute: minute);
  }

  CatalogItem? _findCatalogItem(String id) {
    final items = ref.read(catalogProvider);
    for (final item in items) {
      if (item.id == id) {
        return item;
      }
    }
    return null;
  }

  String? _catalogWarningForLine(QuoteLineDraft draft) {
    if (!draft.isExistingLine) {
      return null;
    }

    final availability = QuoteLineCatalogStatus.resolve(
      isExistingLine: draft.isExistingLine,
      catalogItemId: draft.catalogItemId,
      catalogItem: _findCatalogItem(draft.catalogItemId),
    );

    return QuoteLineCatalogStatus.warningMessage(availability);
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventTypeController.dispose();
    _eventDateController.dispose();
    _eventStartTimeController.dispose();
    _eventEndTimeController.dispose();
    _eventVenueController.dispose();
    _eventAddressController.dispose();
    _guestCountController.dispose();
    _discountController.dispose();
    _freightController.dispose();
    _validUntilController.dispose();
    _notesController.dispose();
    _internalNotesController.dispose();
    for (final controller in _quantityControllers.values) {
      controller.dispose();
    }
    for (final controller in _priceControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _markDirty() {
    if (_applyingDefaults) {
      return;
    }
    setState(() {
      _isDirty = true;
    });
  }

  QuoteFinancialSummaryData get _summary {
    return QuoteFormState.calculateSummary(
      lines: _lines,
      discountText: _discountController.text,
      freightText: _freightController.text,
    );
  }

  Client? get _selectedClient {
    if (_selectedClientId == null) {
      return null;
    }
    return ref.read(clientsProvider.notifier).findById(_selectedClientId!);
  }

  Future<bool?> _showDiscardDialog() {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text('Descartar alterações?'),
          content: const Text(
            'As alterações não salvas serão perdidas.',
          ),
          actions: [
            TextButton(
              key: const Key('quote_discard_cancel_button'),
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              key: const Key('quote_discard_confirm_button'),
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

  Future<void> _handleBack() async {
    if (_saving) {
      return;
    }

    if (_canPopWithoutDialog) {
      if (context.canPop()) {
        context.pop();
      }
      return;
    }

    final discard = await _showDiscardDialog();
    if (discard == true && mounted) {
      setState(() {
        _discardConfirmed = true;
        _isDirty = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && context.canPop()) {
          context.pop();
        }
      });
    }
  }

  Future<void> _openClientSelector() async {
    final clients = ref.read(clientsProvider);
    final selected = await showQuoteClientSelector(
      context: context,
      clients: clients,
      selectedClientId: _selectedClientId,
    );

    if (selected == null || !mounted) {
      return;
    }

    setState(() {
      _selectedClientId = selected.id;
      _clientError = null;
    });
    _markDirty();
  }

  Future<void> _openCatalogSelector() async {
    final items = ref.read(catalogProvider);
    final existingIds = {
      for (final line in _lines) line.catalogItemId,
    };

    final selected = await showQuoteCatalogItemSelector(
      context: context,
      items: items,
      existingCatalogItemIds: existingIds,
    );

    if (selected == null || !mounted) {
      return;
    }

    if (existingIds.contains(selected.id)) {
      _showMessage('Este item já foi adicionado ao orçamento');
      return;
    }

    _addLineFromCatalog(selected);
  }

  void _addLineFromCatalog(CatalogItem item) {
    final draftId = _draftIdGenerator.nextLineDraftId();
    final quantityController = TextEditingController(text: '1');
    final priceController = TextEditingController(
      text: QuoteMoneyDisplay.formatForInput(
        QuoteMoney.reaisToCents(item.price),
      ),
    );

    quantityController.addListener(_markDirty);
    priceController.addListener(_markDirty);

    _quantityControllers[draftId] = quantityController;
    _priceControllers[draftId] = priceController;

    setState(() {
      _lines.add(
        QuoteLineDraft(
          draftId: draftId,
          catalogItemId: item.id,
          name: item.name,
          description: item.description,
          unit: item.unit,
          quantityText: '1',
          priceText: priceController.text,
          isExistingLine: false,
          packageComponents: item.isPackage
              ? QuotePackageComponentMapper.fromCatalogComponents(
                  item.components,
                )
              : null,
        ),
      );
      _linesError = null;
    });
    _markDirty();
  }

  void _removeLine(String draftId) {
    _quantityControllers.remove(draftId)?.dispose();
    _priceControllers.remove(draftId)?.dispose();

    setState(() {
      _lines.removeWhere((line) => line.draftId == draftId);
    });
    _markDirty();
  }

  void _syncLineText(String draftId, {String? quantityText, String? priceText}) {
    final index = _lines.indexWhere((line) => line.draftId == draftId);
    if (index < 0) {
      return;
    }

    setState(() {
      _lines[index] = _lines[index].copyWith(
        quantityText: quantityText ?? _lines[index].quantityText,
        priceText: priceText ?? _lines[index].priceText,
      );
    });
    _markDirty();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.warning,
        ),
      );
  }

  Future<void> _pickValidUntil() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      locale: const Locale('pt', 'BR'),
      initialDate: _validUntil ?? QuoteDateFormatter.addDays(now, 7),
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );

    if (picked == null || !mounted) {
      return;
    }

    setState(() {
      _validUntil = picked;
      _validUntilController.text = QuoteDateFormatter.format(picked);
      _validUntilError = QuoteFormValidators.validateValidUntil(picked, now);
      _markDirty();
    });
  }

  void _clearValidUntil() {
    setState(() {
      _validUntil = null;
      _validUntilController.clear();
      _validUntilError = null;
      _markDirty();
    });
  }

  Future<void> _pickEventDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      locale: const Locale('pt', 'BR'),
      initialDate: _eventDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );

    if (picked == null || !mounted) {
      return;
    }

    setState(() {
      _eventDate = picked;
      _eventDateController.text = QuoteDateFormatter.format(picked);
      _markDirty();
    });
  }

  void _clearEventDate() {
    setState(() {
      _eventDate = null;
      _eventDateController.clear();
      _markDirty();
    });
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime == null
          ? TimeOfDay.now()
          : TimeOfDay(hour: _startTime!.hour, minute: _startTime!.minute),
    );

    if (picked == null || !mounted) {
      return;
    }

    setState(() {
      _startTime = TimeOfDayValue(hour: picked.hour, minute: picked.minute);
      _eventStartTimeController.text = QuoteTimeFormatter.format(_startTime!);
      _markDirty();
    });
  }

  void _clearStartTime() {
    setState(() {
      _startTime = null;
      _eventStartTimeController.clear();
      _markDirty();
    });
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime == null
          ? TimeOfDay.now()
          : TimeOfDay(hour: _endTime!.hour, minute: _endTime!.minute),
    );

    if (picked == null || !mounted) {
      return;
    }

    setState(() {
      _endTime = TimeOfDayValue(hour: picked.hour, minute: picked.minute);
      _eventEndTimeController.text = QuoteTimeFormatter.format(_endTime!);
      _markDirty();
    });
  }

  void _clearEndTime() {
    setState(() {
      _endTime = null;
      _eventEndTimeController.clear();
      _markDirty();
    });
  }

  bool _validateBeforeSave() {
    var isValid = true;
    String? clientError;
    String? linesError;
    String? guestCountError;
    String? validUntilError;

    clientError = QuoteFormValidators.validateClientSelection(_selectedClientId);
    if (clientError != null) {
      isValid = false;
    }

    linesError = QuoteFormValidators.validateLinesNotEmpty(_lines);
    if (linesError != null) {
      isValid = false;
    }

    for (final line in _lines) {
      final calculation = QuoteFormState.calculateLine(line);
      if (!calculation.isValid) {
        isValid = false;
      }
    }

    guestCountError =
        QuoteFormValidators.validateGuestCount(_guestCountController.text);
    if (guestCountError != null) {
      isValid = false;
    }

    validUntilError = QuoteFormValidators.validateValidUntil(
      _validUntil,
      DateTime.now(),
    );
    if (validUntilError != null) {
      isValid = false;
    }

    final discountError = QuoteFormValidators.validateDiscount(
      _discountController.text,
      subtotalCents: _summary.subtotalCents,
    );
    if (discountError != null) {
      isValid = false;
    }

    final freightError = QuoteFormValidators.validateFreight(
      _freightController.text,
    );
    if (freightError != null) {
      isValid = false;
    }

    setState(() {
      _clientError = clientError;
      _linesError = linesError;
      _guestCountError = guestCountError;
      _validUntilError = validUntilError;
      _saveError = null;
    });

    return isValid;
  }

  List<QuoteLineItem>? _buildLineItemsForSave() {
    final result = QuoteLineDraftSaver.buildLineItems(
      drafts: _lines,
      findCatalogItem: _findCatalogItem,
    );

    if (!result.isSuccess) {
      setState(() {
        _saveError = result.errorMessage;
      });
      return null;
    }

    return result.items;
  }

  Future<void> _save() async {
    if (_saving) {
      return;
    }

    if (!_validateBeforeSave()) {
      return;
    }

    final client = _selectedClient;
    if (client == null) {
      setState(() {
        _saveError =
            'Cliente não encontrado. Selecione outro cliente.';
      });
      return;
    }

    final lineItems = _buildLineItemsForSave();
    if (lineItems == null) {
      return;
    }

    setState(() {
      _saving = true;
      _saveError = null;
    });

    final now = ref.read(quoteClockProvider)();
    final quoteId = _isEditing
        ? _editingQuoteId!
        : now.microsecondsSinceEpoch.toString();
    final logoCoordinator = QuoteNewDraftCompanySnapshotCoordinator(
      logoStorage: ref.read(quoteCompanyLogoStorageProvider),
    );

    String? copiedLogoReference;
    QuoteCompanySnapshot? companySnapshot;

    try {
      if (!_isEditing) {
        final profile = ref.read(companyProfileProvider);
        final snapshotResult = await logoCoordinator.build(
          profile: profile,
          quoteId: quoteId,
          timestamp: now,
        );
        companySnapshot = snapshotResult.snapshot;
        copiedLogoReference = snapshotResult.copiedLogoReference;
      }

      final draft = Quote(
        id: quoteId,
        number: 'IGNORED',
        status: QuoteStatus.draft,
        clientSnapshot: QuoteClientSnapshot.fromClient(client),
        eventSnapshot: _buildEventSnapshot(),
        items: lineItems,
        subtotalCents: 0,
        discountCents: _summary.discountCents,
        freightCents: _summary.freightCents,
        totalCents: 0,
        statusHistory: const [],
        validUntil: _validUntil,
        notes: _optionalText(_notesController.text),
        internalNotes: _optionalText(_internalNotesController.text),
        companySnapshot: companySnapshot,
        createdAt: now,
        updatedAt: now,
      );

      final success = _isEditing
          ? ref.read(quotesProvider.notifier).updateQuote(draft)
          : ref.read(quotesProvider.notifier).addQuote(draft);

      if (!success) {
        if (!_isEditing) {
          await logoCoordinator.rollbackCopiedLogo(copiedLogoReference);
        }

        if (!mounted) {
          return;
        }

        setState(() {
          _saving = false;
          _saveError = _isEditing
              ? 'Não foi possível atualizar o orçamento.'
              : 'Não foi possível salvar o orçamento.';
        });
        return;
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _formSaved = true;
        _isDirty = false;
        _saving = false;
      });

      context.pop(true);
    } catch (_) {
      if (!_isEditing) {
        await logoCoordinator.rollbackCopiedLogo(copiedLogoReference);
      }

      if (!mounted) {
        return;
      }

      setState(() {
        _saving = false;
        _saveError = _isEditing
            ? 'Não foi possível atualizar o orçamento.'
            : 'Não foi possível salvar o orçamento.';
      });
    }
  }

  QuoteEventSnapshot _buildEventSnapshot() {
    final guestCountText = _guestCountController.text.trim();
    final guestCount = guestCountText.isEmpty
        ? null
        : int.tryParse(guestCountText);

    return QuoteEventSnapshot(
      name: _optionalText(_eventNameController.text),
      type: _optionalText(_eventTypeController.text),
      date: _eventDate,
      startTime: QuoteTimeFormatter.formatOptional(_startTime),
      endTime: QuoteTimeFormatter.formatOptional(_endTime),
      venueName: _optionalText(_eventVenueController.text),
      addressSummary: _optionalText(_eventAddressController.text),
      guestCount: guestCount,
    );
  }

  String? _optionalText(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(clientsProvider);
    ref.watch(catalogProvider);

    if (_isEditing) {
      final quote =
          ref.read(quotesProvider.notifier).findById(widget.quoteId!);
      if (quote == null) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Voltar',
              onPressed: _saving ? null : _handleBack,
            ),
            title: Text(
              'Editar orçamento',
              style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
            ),
            backgroundColor: AppColors.background,
            foregroundColor: AppColors.white,
            elevation: 0,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Orçamento não encontrado',
                style: AppTextStyles.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }

      if (quote.status != QuoteStatus.draft) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              tooltip: 'Voltar',
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                }
              },
            ),
            title: Text(
              'Editar orçamento',
              style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
            ),
            backgroundColor: AppColors.background,
            foregroundColor: AppColors.white,
            elevation: 0,
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'Somente orçamentos em rascunho podem ser editados.',
                style: AppTextStyles.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      }
    }

    final selectedClient = _selectedClient;
    final summary = _summary;
    final pageTitle = _isEditing ? 'Editar orçamento' : 'Novo orçamento';

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
            onPressed: _saving ? null : _handleBack,
          ),
          title: Text(
            pageTitle,
            style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
          ),
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.white,
          elevation: 0,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              key: const Key('quote_form_scroll'),
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
                        if (!_isEditing) ...[
                          QuoteCompanyProfileBanner(
                            profile: ref.watch(companyProfileProvider),
                            onConfigureCompany: () {
                              context.push(AppRoutes.settingsCompany);
                            },
                          ),
                          const SizedBox(height: _fieldSpacing),
                        ],
                        _buildClientSection(selectedClient),
                        const SizedBox(height: _fieldSpacing),
                        QuoteEventSection(
                          nameController: _eventNameController,
                          typeController: _eventTypeController,
                          dateController: _eventDateController,
                          startTimeController: _eventStartTimeController,
                          endTimeController: _eventEndTimeController,
                          venueNameController: _eventVenueController,
                          addressController: _eventAddressController,
                          guestCountController: _guestCountController,
                          guestCountError: _guestCountError,
                          onPickDate: _pickEventDate,
                          onClearDate: _clearEventDate,
                          onPickStartTime: _pickStartTime,
                          onClearStartTime: _clearStartTime,
                          onPickEndTime: _pickEndTime,
                          onClearEndTime: _clearEndTime,
                          onGuestCountChanged: (_) {
                            setState(() {
                              _guestCountError = QuoteFormValidators
                                  .validateGuestCount(
                                _guestCountController.text,
                              );
                            });
                            _markDirty();
                          },
                        ),
                        const SizedBox(height: _fieldSpacing),
                        _buildItemsSection(),
                        const SizedBox(height: _fieldSpacing),
                        ..._lines.map((draft) {
                          final calculation =
                              QuoteFormState.calculateLine(draft);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: QuoteLineEditor(
                              draft: draft,
                              quantityController:
                                  _quantityControllers[draft.draftId]!,
                              priceController:
                                  _priceControllers[draft.draftId]!,
                              calculation: calculation,
                              onQuantityChanged: (value) {
                                _syncLineText(
                                  draft.draftId,
                                  quantityText: value,
                                );
                              },
                              onPriceChanged: (value) {
                                _syncLineText(
                                  draft.draftId,
                                  priceText: value,
                                );
                              },
                              onRemove: () => _removeLine(draft.draftId),
                              catalogWarning: _catalogWarningForLine(draft),
                            ),
                          );
                        }),
                        const SizedBox(height: _fieldSpacing),
                        AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Desconto e frete',
                                style: AppTextStyles.titleMedium,
                              ),
                              const SizedBox(height: 16),
                              AppTextField(
                                key: const Key('quote_discount_field'),
                                label: 'Desconto (R\$)',
                                controller: _discountController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                inputFormatters: [
                                  BrazilianCurrencyInputFormatter(),
                                ],
                                onChanged: (_) => _markDirty(),
                              ),
                              const SizedBox(height: 16),
                              AppTextField(
                                key: const Key('quote_freight_field'),
                                label: 'Frete (R\$)',
                                controller: _freightController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                inputFormatters: [
                                  BrazilianCurrencyInputFormatter(),
                                ],
                                onChanged: (_) => _markDirty(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: _fieldSpacing),
                        QuoteFinancialSummary(summary: summary),
                        const SizedBox(height: _fieldSpacing),
                        QuoteValidityNotesSection(
                          validUntilController: _validUntilController,
                          validUntilError: _validUntilError,
                          notesController: _notesController,
                          internalNotesController: _internalNotesController,
                          onPickValidUntil: _pickValidUntil,
                          onClearValidUntil: _clearValidUntil,
                        ),
                        if (_saveError != null) ...[
                          const SizedBox(height: _fieldSpacing),
                          Text(
                            _saveError!,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.error,
                            ),
                          ),
                        ],
                        const SizedBox(height: 32),
                        PrimaryButton(
                          key: const Key('quote_save_button'),
                          label: _isEditing
                              ? 'Salvar alterações'
                              : 'Salvar rascunho',
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

  Widget _buildClientSection(Client? selectedClient) {
    return AppCard(
      key: const Key('quote_client_section'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Cliente',
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: 16),
          if (selectedClient != null) ...[
            Text(
              selectedClient.tradeName?.trim().isNotEmpty == true
                  ? selectedClient.tradeName!.trim()
                  : selectedClient.name,
              style: AppTextStyles.titleSmall,
            ),
            if (selectedClient.tradeName?.trim().isNotEmpty == true) ...[
              const SizedBox(height: 4),
              Text(
                selectedClient.name,
                style: AppTextStyles.bodyMedium,
              ),
            ],
            const SizedBox(height: 4),
            Text(
              selectedClient.type.label,
              style: AppTextStyles.caption.copyWith(color: AppColors.primary),
            ),
            if (ClientDisplayFormatter.formatPrimaryContact(selectedClient) !=
                null) ...[
              const SizedBox(height: 4),
              Text(
                ClientDisplayFormatter.formatPrimaryContact(selectedClient)!,
                style: AppTextStyles.bodyMedium,
              ),
            ],
            const SizedBox(height: 16),
          ],
          OutlinedButton(
            key: const Key('quote_select_client_button'),
            onPressed: _openClientSelector,
            child: Text(
              selectedClient == null
                  ? 'Selecionar cliente'
                  : 'Alterar cliente',
            ),
          ),
          if (_clientError != null) ...[
            const SizedBox(height: 8),
            Text(
              _clientError!,
              style: AppTextStyles.caption.copyWith(color: AppColors.error),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildItemsSection() {
    return AppCard(
      key: const Key('quote_items_section'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Itens do catálogo',
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            key: const Key('quote_add_catalog_item_button'),
            onPressed: _openCatalogSelector,
            child: const Text('Adicionar item do catálogo'),
          ),
          if (_linesError != null) ...[
            const SizedBox(height: 8),
            Text(
              _linesError!,
              style: AppTextStyles.caption.copyWith(color: AppColors.error),
            ),
          ],
        ],
      ),
    );
  }
}

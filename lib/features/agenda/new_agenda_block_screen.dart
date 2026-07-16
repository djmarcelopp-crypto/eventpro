import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/primary_button.dart';
import 'agenda_block_feedback.dart';
import 'models/agenda_block.dart';
import 'providers/agenda_blocks_provider.dart';
import 'utils/agenda_block_validator.dart';
import 'utils/agenda_occupancy_presenter.dart';

class NewAgendaBlockScreen extends ConsumerStatefulWidget {
  const NewAgendaBlockScreen({super.key, this.blockId});

  final String? blockId;

  @override
  ConsumerState<NewAgendaBlockScreen> createState() =>
      _NewAgendaBlockScreenState();
}

class _NewAgendaBlockScreenState extends ConsumerState<NewAgendaBlockScreen> {
  static const _maxContentWidth = 720.0;
  static const _fieldSpacing = 16.0;

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  final _startController = TextEditingController();
  final _endController = TextEditingController();

  DateTime? _start;
  DateTime? _end;
  String? _endAfterStartError;
  bool _initializedForEdit = false;
  bool _isSaving = false;

  bool get _isEditing => widget.blockId != null;

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

    final block = ref
        .read(agendaBlocksProvider.notifier)
        .findById(widget.blockId!);
    if (block == null) {
      return;
    }

    setState(() {
      _titleController.text = block.title;
      _notesController.text = block.notes ?? '';
      _start = block.start;
      _end = block.end;
      _startController.text = AgendaDateFormatter.formatDateTime(block.start);
      _endController.text = AgendaDateFormatter.formatDateTime(block.end);
      _initializedForEdit = true;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  DateTime get _defaultBaseForStart => _start ?? DateTime.now();

  DateTime get _defaultBaseForEnd =>
      _end ??
      _start?.add(const Duration(hours: 2)) ??
      DateTime.now().add(const Duration(hours: 2));

  Future<void> _pickStart() => _pickDateTime(isStart: true);

  Future<void> _pickEnd() => _pickDateTime(isStart: false);

  Future<void> _pickDateTime({required bool isStart}) async {
    final base = isStart ? _defaultBaseForStart : _defaultBaseForEnd;

    final pickedDate = await showDatePicker(
      context: context,
      locale: const Locale('pt', 'BR'),
      initialDate: base,
      firstDate: DateTime(base.year - 5),
      lastDate: DateTime(base.year + 5),
    );
    if (pickedDate == null || !mounted) {
      return;
    }

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: base.hour, minute: base.minute),
    );
    if (pickedTime == null || !mounted) {
      return;
    }

    final combined = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    setState(() {
      if (isStart) {
        _start = combined;
        _startController.text = AgendaDateFormatter.formatDateTime(combined);
      } else {
        _end = combined;
        _endController.text = AgendaDateFormatter.formatDateTime(combined);
      }
      _endAfterStartError = null;
    });
  }

  Future<void> _onSave() async {
    if (_isSaving) {
      return;
    }

    final formValid = _formKey.currentState?.validate() ?? false;
    final endAfterStartError =
        (_start != null && _end != null && !_end!.isAfter(_start!))
        ? AgendaBlockValidator.endAfterStartError
        : null;

    setState(() {
      _endAfterStartError = endAfterStartError;
    });

    if (!formValid || endAfterStartError != null) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      final notes = _notesController.text.trim();
      final title = _titleController.text.trim();
      bool saved;

      if (_isEditing) {
        final existing = ref
            .read(agendaBlocksProvider.notifier)
            .findById(widget.blockId!);
        if (existing == null) {
          saved = false;
        } else {
          final updated = existing.copyWith(
            title: title,
            start: _start,
            end: _end,
            notes: notes.isEmpty ? null : notes,
            clearNotes: notes.isEmpty,
          );
          saved = await ref
              .read(agendaBlocksProvider.notifier)
              .updateBlock(updated);
        }
      } else {
        final now = DateTime.now();
        final draft = AgendaBlock(
          id: '',
          title: title,
          notes: notes.isEmpty ? null : notes,
          start: _start!,
          end: _end!,
          createdAt: now,
          updatedAt: now,
        );
        saved = await ref.read(agendaBlocksProvider.notifier).addBlock(draft);
      }

      if (!mounted) {
        return;
      }

      if (!saved) {
        AgendaBlockFeedbackPresenter.showErrorSnackBar(
          AgendaBlockErrorFeedback.save,
        );
        return;
      }

      if (_isEditing) {
        context.go(AppRoutes.agenda);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            AgendaBlockFeedbackPresenter.showSnackBar(
              AgendaBlockFeedback.updated,
            );
          });
        });
        return;
      }

      context.pop(true);
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
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
          _isEditing ? 'Editar bloqueio' : 'Novo bloqueio',
          style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            key: const Key('agenda_block_form_scroll'),
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: _maxContentWidth),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AppTextField(
                        key: const Key('agenda_block_title_field'),
                        label: 'Título',
                        hint: 'Ex.: Montagem, viagem, evento externo',
                        controller: _titleController,
                        textInputAction: TextInputAction.next,
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                            ? AgendaBlockValidator.titleRequiredError
                            : null,
                      ),
                      const SizedBox(height: _fieldSpacing),
                      AppTextField(
                        key: const Key('agenda_block_start_field'),
                        label: 'Início',
                        hint: 'Selecione data e hora',
                        controller: _startController,
                        readOnly: true,
                        onTap: _pickStart,
                        validator: (value) =>
                            (value == null || value.isEmpty)
                            ? AgendaBlockValidator.startRequiredError
                            : null,
                      ),
                      const SizedBox(height: _fieldSpacing),
                      AppTextField(
                        key: const Key('agenda_block_end_field'),
                        label: 'Fim',
                        hint: 'Selecione data e hora',
                        controller: _endController,
                        readOnly: true,
                        onTap: _pickEnd,
                        validator: (value) =>
                            (value == null || value.isEmpty)
                            ? AgendaBlockValidator.endRequiredError
                            : null,
                      ),
                      if (_endAfterStartError != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          _endAfterStartError!,
                          key: const Key('agenda_block_end_after_start_error'),
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ],
                      const SizedBox(height: _fieldSpacing),
                      AppTextField(
                        key: const Key('agenda_block_notes_field'),
                        label: 'Observações',
                        controller: _notesController,
                        maxLines: 4,
                        textInputAction: TextInputAction.newline,
                      ),
                      const SizedBox(height: 32),
                      PrimaryButton(
                        key: const Key('agenda_block_save_button'),
                        label: 'Salvar',
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
      ),
    );
  }
}

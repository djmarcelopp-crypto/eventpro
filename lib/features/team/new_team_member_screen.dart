import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/primary_button.dart';
import '../catalog/utils/brazilian_currency_input_formatter.dart';
import '../quotes/utils/quote_money_display.dart';
import 'models/team_member.dart';
import 'models/team_member_status.dart';
import 'models/team_role.dart';
import 'providers/team_member_provider.dart';
import 'providers/team_role_provider.dart';
import 'team_feedback.dart';

class NewTeamMemberScreen extends ConsumerStatefulWidget {
  const NewTeamMemberScreen({super.key, this.memberId});

  final String? memberId;

  @override
  ConsumerState<NewTeamMemberScreen> createState() =>
      _NewTeamMemberScreenState();
}

class _NewTeamMemberScreenState extends ConsumerState<NewTeamMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _dailyRateController = TextEditingController();
  final _observationsController = TextEditingController();

  String? _roleId;
  TeamMemberStatus _status = TeamMemberStatus.active;
  var _isSaving = false;
  var _initializedForEdit = false;

  bool get _isEditing => widget.memberId != null;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _dailyRateController.dispose();
    _observationsController.dispose();
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
    final member = ref
        .read(teamMemberProvider.notifier)
        .findById(widget.memberId!);
    if (member == null) {
      return;
    }
    _initializedForEdit = true;
    _nameController.text = member.name;
    _phoneController.text = member.phone;
    _emailController.text = member.email ?? '';
    _dailyRateController.text =
        QuoteMoneyDisplay.formatForInput(member.dailyRate);
    _observationsController.text = member.observations;
    _roleId = member.roleId;
    _status = member.status;
  }

  List<TeamRole> _rolesForDropdown(List<TeamRole> all) {
    if (_isEditing && _roleId != null) {
      final current = all.where((role) => role.id == _roleId).firstOrNull;
      if (current != null && !current.active) {
        return [
          current,
          ...all.where((role) => role.active && role.id != _roleId),
        ];
      }
    }
    return all.where((role) => role.active).toList(growable: false);
  }

  Future<void> _onSave() async {
    if (_isSaving) {
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    if (_roleId == null) {
      TeamFeedbackPresenter.showError('Selecione uma função.');
      return;
    }

    final dailyRate =
        QuoteMoneyDisplay.parseNonNegativeCents(_dailyRateController.text);
    if (dailyRate == null) {
      TeamFeedbackPresenter.showError('Informe uma diária válida.');
      return;
    }

    setState(() => _isSaving = true);

    final now = DateTime.now();
    final email = _emailController.text.trim();
    final draft = TeamMember(
      id: widget.memberId ?? '',
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: email.isEmpty ? null : email,
      roleId: _roleId!,
      dailyRate: dailyRate,
      status: _status,
      observations: _observationsController.text.trim(),
      createdAt: now,
      updatedAt: now,
    );

    final notifier = ref.read(teamMemberProvider.notifier);
    final result = _isEditing
        ? await notifier.updateMember(draft)
        : await notifier.addMember(draft);

    if (!mounted) {
      return;
    }

    setState(() => _isSaving = false);

    if (!result.isSuccess) {
      TeamFeedbackPresenter.showError(
        TeamFeedbackPresenter.memberWriteError(result),
      );
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      if (_isEditing) {
        context.go(AppRoutes.team);
        TeamFeedbackPresenter.showSnackBar(TeamFeedback.memberUpdated);
      } else {
        Navigator.of(context).pop(true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final rolesAsync = ref.watch(teamRoleProvider);
    final roles = _rolesForDropdown(rolesAsync.value ?? const []);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          _isEditing ? 'Editar colaborador' : 'Novo colaborador',
          style: AppTextStyles.headlineMedium.copyWith(fontSize: 20),
        ),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
        elevation: 0,
      ),
      body: rolesAsync.when(
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
                        key: const Key('team_form_name'),
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
                        key: const Key('team_form_phone'),
                        label: 'Telefone',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Informe o telefone.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        key: const Key('team_form_email'),
                        label: 'E-mail (opcional)',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        key: const Key('team_form_role'),
                        initialValue: _roleId,
                        decoration: const InputDecoration(labelText: 'Função'),
                        items: [
                          for (final role in roles)
                            DropdownMenuItem(
                              value: role.id,
                              child: Text(
                                role.active
                                    ? role.name
                                    : '${role.name} (inativa)',
                              ),
                            ),
                        ],
                        onChanged: (value) => setState(() => _roleId = value),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Selecione uma função.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      AppTextField(
                        key: const Key('team_form_daily_rate'),
                        label: 'Diária',
                        controller: _dailyRateController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [BrazilianCurrencyInputFormatter()],
                        validator: (value) {
                          if (QuoteMoneyDisplay.parseNonNegativeCents(value) ==
                              null) {
                            return 'Informe uma diária válida.';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<TeamMemberStatus>(
                        key: const Key('team_form_status'),
                        initialValue: _status,
                        decoration: const InputDecoration(labelText: 'Status'),
                        items: [
                          for (final status in TeamMemberStatus.values)
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
                      const SizedBox(height: 16),
                      AppTextField(
                        key: const Key('team_form_observations'),
                        label: 'Observações',
                        controller: _observationsController,
                        maxLines: 3,
                      ),
                      const SizedBox(height: 24),
                      PrimaryButton(
                        key: const Key('team_form_save'),
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
            'Não foi possível carregar as funções.',
            style: AppTextStyles.bodyMedium,
          ),
        ),
      ),
    );
  }
}

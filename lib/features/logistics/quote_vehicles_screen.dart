import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_text_field.dart';
import '../quotes/utils/quote_date_formatter.dart';
import '../quotes/utils/quote_money_display.dart';
import '../team/providers/team_member_provider.dart';
import 'models/vehicle_status.dart';
import 'providers/quote_vehicle_provider.dart';
import 'providers/vehicle_provider.dart';
import 'logistics_feedback.dart';

class QuoteVehiclesScreen extends ConsumerWidget {
  const QuoteVehiclesScreen({super.key, required this.quoteId});

  final String quoteId;

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final vehicles = (ref.read(vehicleProvider).value ?? const [])
        .where((vehicle) => vehicle.status == VehicleStatus.available)
        .toList();
    final members = (ref.read(teamMemberProvider).value ?? const [])
        .where((member) => member.isActive)
        .toList();

    if (vehicles.isEmpty) {
      LogisticsFeedbackPresenter.showError(
        'Não há veículos disponíveis para associar.',
      );
      return;
    }

    String? vehicleId = vehicles.first.id;
    String? driverId;
    DateTime? departureAt;
    DateTime? returnAt;
    final freightController = TextEditingController(text: '0');

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> pickDeparture() async {
              final picked = await showDatePicker(
                context: context,
                initialDate: departureAt ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                setState(() => departureAt = QuoteDateFormatter.dateOnly(picked));
              }
            }

            Future<void> pickReturn() async {
              final picked = await showDatePicker(
                context: context,
                initialDate: returnAt ?? departureAt ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                setState(() => returnAt = QuoteDateFormatter.dateOnly(picked));
              }
            }

            return AlertDialog(
              title: const Text('Adicionar veículo'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      key: const Key('quote_vehicle_form_vehicle'),
                      initialValue: vehicleId,
                      decoration: const InputDecoration(labelText: 'Veículo'),
                      items: [
                        for (final vehicle in vehicles)
                          DropdownMenuItem(
                            value: vehicle.id,
                            child: Text(vehicle.plate),
                          ),
                      ],
                      onChanged: (value) => setState(() => vehicleId = value),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String?>(
                      key: const Key('quote_vehicle_form_driver'),
                      initialValue: driverId,
                      decoration: const InputDecoration(
                        labelText: 'Motorista (opcional)',
                      ),
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('Nenhum'),
                        ),
                        for (final member in members)
                          DropdownMenuItem(
                            value: member.id,
                            child: Text(member.name),
                          ),
                      ],
                      onChanged: (value) => setState(() => driverId = value),
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      key: const Key('quote_vehicle_form_departure'),
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Saída planejada'),
                      subtitle: Text(
                        departureAt == null
                            ? 'Não informada'
                            : QuoteDateFormatter.format(departureAt!),
                      ),
                      trailing: const Icon(Icons.calendar_today_outlined),
                      onTap: pickDeparture,
                    ),
                    ListTile(
                      key: const Key('quote_vehicle_form_return'),
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Retorno planejado'),
                      subtitle: Text(
                        returnAt == null
                            ? 'Não informado'
                            : QuoteDateFormatter.format(returnAt!),
                      ),
                      trailing: const Icon(Icons.calendar_today_outlined),
                      onTap: pickReturn,
                    ),
                    const SizedBox(height: 12),
                    AppTextField(
                      key: const Key('quote_vehicle_form_freight'),
                      label: 'Custo de frete (R\$)',
                      controller: freightController,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  key: const Key('quote_vehicle_form_save'),
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Adicionar'),
                ),
              ],
            );
          },
        );
      },
    );

    final freightText = freightController.text;
    freightController.dispose();
    if (confirmed != true || vehicleId == null || !context.mounted) return;

    final cents = QuoteMoneyDisplay.parseToCents(freightText) ?? -1;
    final result = await ref.read(quoteVehicleProvider(quoteId).notifier).add(
          vehicleId: vehicleId!,
          driverTeamMemberId: driverId,
          plannedDepartureAt: departureAt,
          plannedReturnAt: returnAt,
          freightCostCents: cents,
        );

    if (!context.mounted) return;
    if (result.isSuccess) {
      LogisticsFeedbackPresenter.showSnackBar(
        LogisticsFeedback.quoteVehicleAdded,
      );
    } else {
      LogisticsFeedbackPresenter.showError(
        LogisticsFeedbackPresenter.quoteVehicleWriteError(result),
      );
    }
  }

  String _periodLabel({
    required DateTime? departure,
    required DateTime? returnAt,
  }) {
    if (departure == null && returnAt == null) {
      return 'Período não informado';
    }
    final start = departure == null
        ? '—'
        : QuoteDateFormatter.format(departure);
    final end = returnAt == null ? '—' : QuoteDateFormatter.format(returnAt);
    return 'Saída: $start · Retorno: $end';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(quoteVehicleProvider(quoteId));
    final summaryAsync = ref.watch(quoteVehicleSummaryProvider(quoteId));
    final vehicles = ref.watch(vehicleProvider).value ?? const [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Logística do orçamento'),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.white,
        actions: [
          IconButton(
            key: const Key('quote_vehicle_add'),
            icon: const Icon(Icons.add),
            onPressed: () => _add(context, ref),
          ),
        ],
      ),
      body: itemsAsync.when(
        data: (items) {
          final summary = summaryAsync.value;
          return ListView(
            key: const Key('quote_vehicle_list'),
            padding: const EdgeInsets.all(24),
            children: [
              AppCard(
                key: const Key('quote_vehicle_summary_total'),
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Custo total de frete: '
                  '${QuoteMoneyDisplay.format(summary?.totalFreightCostCents ?? 0)}',
                  style: AppTextStyles.titleMedium,
                ),
              ),
              const SizedBox(height: 16),
              if (items.isEmpty)
                const Text('Nenhum veículo associado a este orçamento.')
              else
                for (final item in items) ...[
                  AppCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                vehicles
                                        .where((v) => v.id == item.vehicleId)
                                        .map((v) => v.plate)
                                        .firstOrNull ??
                                    item.vehicleId,
                                style: AppTextStyles.titleMedium,
                              ),
                              Text(
                                'Frete: ${QuoteMoneyDisplay.format(item.freightCostCents)}',
                              ),
                              Text(
                                _periodLabel(
                                  departure: item.plannedDepartureAt,
                                  returnAt: item.plannedReturnAt,
                                ),
                                style: AppTextStyles.caption.copyWith(
                                  color: AppColors.white.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          key: Key('quote_vehicle_remove_${item.id}'),
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () async {
                            final result = await ref
                                .read(quoteVehicleProvider(quoteId).notifier)
                                .remove(item.id);
                            if (result.isDeleted) {
                              LogisticsFeedbackPresenter.showSnackBar(
                                LogisticsFeedback.quoteVehicleRemoved,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('$error')),
      ),
    );
  }
}

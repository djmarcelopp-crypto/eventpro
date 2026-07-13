import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_field.dart';

class QuoteEventSection extends StatelessWidget {
  const QuoteEventSection({
    super.key,
    required this.nameController,
    required this.typeController,
    required this.dateController,
    required this.startTimeController,
    required this.endTimeController,
    required this.venueNameController,
    required this.addressController,
    required this.guestCountController,
    required this.guestCountError,
    required this.onPickDate,
    required this.onClearDate,
    required this.onPickStartTime,
    required this.onClearStartTime,
    required this.onPickEndTime,
    required this.onClearEndTime,
    required this.onGuestCountChanged,
  });

  final TextEditingController nameController;
  final TextEditingController typeController;
  final TextEditingController dateController;
  final TextEditingController startTimeController;
  final TextEditingController endTimeController;
  final TextEditingController venueNameController;
  final TextEditingController addressController;
  final TextEditingController guestCountController;
  final String? guestCountError;
  final VoidCallback onPickDate;
  final VoidCallback onClearDate;
  final VoidCallback onPickStartTime;
  final VoidCallback onClearStartTime;
  final VoidCallback onPickEndTime;
  final VoidCallback onClearEndTime;
  final ValueChanged<String> onGuestCountChanged;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      key: const Key('quote_event_section'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Dados do evento',
            style: AppTextStyles.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            'Opcional',
            style: AppTextStyles.caption,
          ),
          const SizedBox(height: 16),
          AppTextField(
            key: const Key('quote_event_name_field'),
            label: 'Nome do evento',
            controller: nameController,
          ),
          const SizedBox(height: 16),
          AppTextField(
            key: const Key('quote_event_type_field'),
            label: 'Tipo do evento',
            controller: typeController,
          ),
          const SizedBox(height: 16),
          _PickerField(
            key: const Key('quote_event_date_field'),
            label: 'Data do evento',
            controller: dateController,
            onTap: onPickDate,
            onClear: dateController.text.isEmpty ? null : onClearDate,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _PickerField(
                  key: const Key('quote_event_start_time_field'),
                  label: 'Horário inicial',
                  controller: startTimeController,
                  onTap: onPickStartTime,
                  onClear:
                      startTimeController.text.isEmpty ? null : onClearStartTime,
                  icon: Icons.access_time,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _PickerField(
                  key: const Key('quote_event_end_time_field'),
                  label: 'Horário final',
                  controller: endTimeController,
                  onTap: onPickEndTime,
                  onClear:
                      endTimeController.text.isEmpty ? null : onClearEndTime,
                  icon: Icons.access_time,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          AppTextField(
            key: const Key('quote_event_venue_field'),
            label: 'Nome do local',
            controller: venueNameController,
          ),
          const SizedBox(height: 16),
          AppTextField(
            key: const Key('quote_event_address_field'),
            label: 'Endereço do evento',
            controller: addressController,
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          AppTextField(
            key: const Key('quote_event_guest_count_field'),
            label: 'Quantidade de convidados',
            controller: guestCountController,
            keyboardType: TextInputType.number,
            onChanged: onGuestCountChanged,
          ),
          if (guestCountError != null) ...[
            const SizedBox(height: 4),
            Text(
              guestCountError!,
              style: AppTextStyles.caption.copyWith(color: AppColors.error),
            ),
          ],
        ],
      ),
    );
  }
}

class _PickerField extends StatelessWidget {
  const _PickerField({
    super.key,
    required this.label,
    required this.controller,
    required this.onTap,
    this.onClear,
    this.icon = Icons.calendar_today_outlined,
  });

  final String label;
  final TextEditingController controller;
  final VoidCallback onTap;
  final VoidCallback? onClear;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: label,
      controller: controller,
      readOnly: true,
      onTap: onTap,
      suffixIcon: onClear == null
          ? Icon(icon, size: 20)
          : IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: onClear,
            ),
    );
  }
}

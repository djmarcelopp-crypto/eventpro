import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../models/agenda_availability_response.dart';
import '../models/agenda_occupancy.dart';
import '../providers/agenda_block_clock_provider.dart';
import '../utils/agenda_availability_assistant_service.dart';
import '../utils/agenda_availability_request_parser.dart';

/// "Agenda Inteligente" query area shown on [AgendaScreen] — lets the user
/// ask a simple Portuguese availability question and shows the
/// deterministic response from [AgendaAvailabilityAssistantService].
///
/// Holds no availability/parsing rule of its own: the phrase, the current
/// [occupancies] and the response are the only state kept here; the actual
/// interpretation and computation are entirely delegated to the CP-A/B/C/D
/// pipeline. Reuses the existing [agendaBlockClockProvider] (rather than a
/// new provider) so relative phrases ("hoje", "esta semana"...) stay
/// deterministic in tests.
class AgendaAvailabilityQueryCard extends ConsumerStatefulWidget {
  const AgendaAvailabilityQueryCard({super.key, required this.occupancies});

  final List<AgendaOccupancy> occupancies;

  @override
  ConsumerState<AgendaAvailabilityQueryCard> createState() =>
      _AgendaAvailabilityQueryCardState();
}

class _AgendaAvailabilityQueryCardState
    extends ConsumerState<AgendaAvailabilityQueryCard> {
  final _controller = TextEditingController();

  AgendaAvailabilityResponse? _response;
  bool _isQuerying = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String _) {
    if (_response != null) {
      setState(() => _response = null);
    }
  }

  Future<void> _onQuery() async {
    if (_isQuerying) {
      return;
    }

    final phrase = _controller.text.trim();
    if (phrase.isEmpty) {
      return;
    }

    setState(() => _isQuerying = true);
    try {
      // Yields to the event loop so a second, near-simultaneous tap is
      // guarded by `_isQuerying` instead of running a duplicate query —
      // `ask()` itself is synchronous and deterministic (no I/O, no AI).
      await Future<void>.delayed(Duration.zero);

      final assistant = AgendaAvailabilityAssistantService(
        parser: AgendaAvailabilityRequestParser(
          clock: ref.read(agendaBlockClockProvider),
        ),
      );
      final response = assistant.ask(
        phrase: phrase,
        occupancies: widget.occupancies,
      );

      if (!mounted) {
        return;
      }
      setState(() => _response = response);
    } finally {
      if (mounted) {
        setState(() => _isQuerying = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final response = _response;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Agenda Inteligente', style: AppTextStyles.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Pergunte sobre a disponibilidade da agenda em português.',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 16),
          AppTextField(
            key: const Key('agenda_query_field'),
            label: 'Pergunta',
            hint: 'Ex.: Tenho agenda livre hoje?',
            controller: _controller,
            onChanged: _onChanged,
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: 12),
          PrimaryButton(
            key: const Key('agenda_query_button'),
            label: 'Consultar',
            isLoading: _isQuerying,
            onPressed: _onQuery,
          ),
          if (response != null) ...[
            const SizedBox(height: 16),
            Text(
              response.message,
              key: const Key('agenda_query_response'),
              style: AppTextStyles.bodyMedium.copyWith(
                color: response.isError ? AppColors.error : null,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

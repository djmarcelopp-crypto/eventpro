import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_card.dart';
import '../models/client.dart';
import '../utils/client_display_formatter.dart';

class ClientListItem extends StatelessWidget {
  const ClientListItem({
    super.key,
    required this.client,
  });

  final Client client;

  @override
  Widget build(BuildContext context) {
    final documentDigits = client.document ?? '';

    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  client.name,
                  style: AppTextStyles.titleSmall,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                client.type.label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            ClientDisplayFormatter.formatWhatsApp(client.whatsApp),
            style: AppTextStyles.bodyMedium,
          ),
          if (documentDigits.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              '${ClientDisplayFormatter.documentLabel(client.type)}: '
              '${ClientDisplayFormatter.formatDocument(client.type, documentDigits)}',
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}

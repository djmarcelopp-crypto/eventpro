import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// Shared dialog helpers for confirm / delete / info flows.
abstract class AppDialogs {
  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Confirmar',
    String cancelLabel = 'Cancelar',
    bool isDestructive = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(cancelLabel),
            ),
            TextButton(
              key: const Key('app_dialog_confirm'),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: isDestructive
                  ? TextButton.styleFrom(foregroundColor: AppColors.error)
                  : null,
              child: Text(confirmLabel),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  static Future<bool> confirmDelete(
    BuildContext context, {
    required String entityLabel,
  }) {
    return confirm(
      context,
      title: 'Excluir $entityLabel',
      message: 'Esta ação não pode ser desfeita. Deseja continuar?',
      confirmLabel: 'Excluir',
      isDestructive: true,
    );
  }

  static Future<void> info(
    BuildContext context, {
    required String title,
    required String message,
    String closeLabel = 'Entendi',
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              key: const Key('app_dialog_info_close'),
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(closeLabel),
            ),
          ],
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/agenda_occupancy.dart';

extension AgendaOccupancyKindPresentation on AgendaOccupancyKind {
  String get label {
    switch (this) {
      case AgendaOccupancyKind.proposal:
        return 'Proposta';
      case AgendaOccupancyKind.confirmed:
        return 'Confirmado';
      case AgendaOccupancyKind.block:
        return 'Bloqueio';
    }
  }

  Color get color {
    switch (this) {
      case AgendaOccupancyKind.proposal:
        return AppColors.warning;
      case AgendaOccupancyKind.confirmed:
        return AppColors.success;
      case AgendaOccupancyKind.block:
        return AppColors.secondaryText;
    }
  }
}

abstract class AgendaDateFormatter {
  static String formatDateTime(DateTime value) {
    return '${_formatDate(value)} ${_formatTime(value)}';
  }

  static String formatRange(DateTime start, DateTime end) {
    final sameDay = start.year == end.year &&
        start.month == end.month &&
        start.day == end.day;

    if (sameDay) {
      return '${_formatDate(start)} · ${_formatTime(start)} - ${_formatTime(end)}';
    }

    return '${formatDateTime(start)} → ${formatDateTime(end)}';
  }

  static String _formatDate(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    return '$day/$month/${value.year}';
  }

  static String _formatTime(DateTime value) {
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}

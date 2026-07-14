import 'dart:io';

import 'package:flutter/services.dart';
import 'package:printing/printing.dart';

import '../models/quote_pdf_export_result.dart';
import 'quote_pdf_file_writer_service.dart';
import 'quote_pdf_save_dialog_service.dart';

abstract class QuotePdfExportService {
  Future<QuotePdfExportResult> export({
    required Uint8List bytes,
    required String filename,
  });
}

class PlatformQuotePdfExportService implements QuotePdfExportService {
  const PlatformQuotePdfExportService({
    QuotePdfSaveDialogService? saveDialog,
    QuotePdfFileWriterService? fileWriter,
  })  : _saveDialog = saveDialog ?? const FilePickerQuotePdfSaveDialogService(),
        _fileWriter = fileWriter ?? const LocalQuotePdfFileWriterService();

  final QuotePdfSaveDialogService _saveDialog;
  final QuotePdfFileWriterService _fileWriter;

  static const genericErrorMessage =
      'Não foi possível exportar o PDF. Tente novamente.';

  @override
  Future<QuotePdfExportResult> export({
    required Uint8List bytes,
    required String filename,
  }) async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        final shared = await Printing.sharePdf(
          bytes: bytes,
          filename: filename,
        );
        return shared
            ? const QuotePdfExportSuccess()
            : const QuotePdfExportFailed();
      }

      final savedPath = await _saveDialog.pickSavePath(filename: filename);
      if (savedPath == null) {
        return const QuotePdfExportCancelled();
      }

      final written = await _fileWriter.writeBytes(
        path: savedPath,
        bytes: bytes,
      );
      if (!written) {
        return const QuotePdfExportFailed();
      }

      return const QuotePdfExportSuccess();
    } on PlatformException {
      return const QuotePdfExportFailed();
    } on FileSystemException {
      return const QuotePdfExportFailed();
    } catch (_) {
      return const QuotePdfExportFailed();
    }
  }
}

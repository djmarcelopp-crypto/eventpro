import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:eventpro/features/quotes/pdf/models/quote_pdf_export_result.dart';
import 'package:eventpro/features/quotes/pdf/services/quote_pdf_export_service.dart';
import 'package:eventpro/features/quotes/pdf/services/quote_pdf_file_writer_service.dart';

import 'fakes/fake_quote_pdf_file_writer_service.dart';
import 'fakes/fake_quote_pdf_save_dialog_service.dart';

void main() {
  group('PlatformQuotePdfExportService — desktop', () {
    late FakeQuotePdfSaveDialogService fakeDialog;
    late FakeQuotePdfFileWriterService fakeWriter;
    late PlatformQuotePdfExportService service;
    late Uint8List bytes;

    setUp(() {
      fakeDialog = FakeQuotePdfSaveDialogService();
      fakeWriter = FakeQuotePdfFileWriterService();
      service = PlatformQuotePdfExportService(
        saveDialog: fakeDialog,
        fileWriter: fakeWriter,
      );
      bytes = Uint8List.fromList(const [0x25, 0x50, 0x44, 0x46, 0x2D]);
    });

    test('grava após destino escolhido', () async {
      fakeDialog.nextPath = '/tmp/orcamento_ORC-2026-0001.pdf';

      final result = await service.export(
        bytes: bytes,
        filename: 'orcamento_ORC-2026-0001.pdf',
      );

      expect(result, isA<QuotePdfExportSuccess>());
      expect(fakeDialog.pickCallCount, 1);
      expect(fakeDialog.lastFilename, 'orcamento_ORC-2026-0001.pdf');
      expect(fakeWriter.writeCallCount, 1);
      expect(fakeWriter.lastBytes, same(bytes));
      expect(fakeWriter.lastPath, '/tmp/orcamento_ORC-2026-0001.pdf');
    });

    test('desktop separa diálogo saveFile da gravação de bytes', () async {
      fakeDialog.nextPath = '/tmp/orcamento.pdf';

      await service.export(bytes: bytes, filename: 'orcamento.pdf');

      expect(fakeDialog.pickCallCount, 1);
      expect(fakeWriter.writeCallCount, 1);
      expect(fakeWriter.lastBytes, same(bytes));
    });

    test('cancelamento do diálogo é silencioso', () async {
      fakeDialog.nextPath = null;

      final result = await service.export(
        bytes: bytes,
        filename: 'orcamento.pdf',
      );

      expect(result, isA<QuotePdfExportCancelled>());
      expect(fakeWriter.writeCallCount, 0);
    });

    test('falha no diálogo retorna erro genérico', () async {
      fakeDialog.errorToThrow = PlatformException(code: 'dialog_error');

      final result = await service.export(
        bytes: bytes,
        filename: 'orcamento.pdf',
      );

      expect(result, isA<QuotePdfExportFailed>());
      expect(fakeWriter.writeCallCount, 0);
    });

    test('falha ao gravar retorna erro genérico', () async {
      fakeDialog.nextPath = '/tmp/orcamento.pdf';
      fakeWriter.nextWriteSuccess = false;

      final result = await service.export(
        bytes: bytes,
        filename: 'orcamento.pdf',
      );

      expect(result, isA<QuotePdfExportFailed>());
      expect(fakeWriter.writeCallCount, 1);
    });

    test('FileSystemException na gravação retorna erro genérico', () async {
      fakeDialog.nextPath = '/tmp/orcamento.pdf';
      fakeWriter.errorToThrow = const FileSystemException('write failed');

      final result = await service.export(
        bytes: bytes,
        filename: 'orcamento.pdf',
      );

      expect(result, isA<QuotePdfExportFailed>());
    });

    test('executa somente uma gravação por exportação', () async {
      fakeDialog.nextPath = '/tmp/orcamento.pdf';

      await service.export(bytes: bytes, filename: 'orcamento.pdf');

      expect(fakeDialog.pickCallCount, 1);
      expect(fakeWriter.writeCallCount, 1);
    });

    test('rejeita gravação quando verificação de tamanho falha', () async {
      fakeDialog.nextPath = '/tmp/orcamento.pdf';
      final stubWriter = _SizeMismatchQuotePdfFileWriterService();

      final result = await PlatformQuotePdfExportService(
        saveDialog: fakeDialog,
        fileWriter: stubWriter,
      ).export(bytes: bytes, filename: 'orcamento.pdf');

      expect(result, isA<QuotePdfExportFailed>());
      expect(stubWriter.writeCallCount, 1);
    });
  });

  group('LocalQuotePdfFileWriterService', () {
    const writer = LocalQuotePdfFileWriterService();

    test('confirma tamanho final correto', () async {
      final tempDir = await Directory.systemTemp.createTemp('quote_pdf_writer');
      addTearDown(() => tempDir.deleteSync(recursive: true));

      final path = '${tempDir.path}/sample.pdf';
      final bytes = Uint8List.fromList(const [0x25, 0x50, 0x44, 0x46, 0x2D]);

      final success = await writer.writeBytes(path: path, bytes: bytes);

      expect(success, isTrue);
      expect(File(path).existsSync(), isTrue);
      expect(File(path).lengthSync(), bytes.length);
    });

    test('grava com flush para compatibilidade desktop', () async {
      final tempDir = await Directory.systemTemp.createTemp('quote_pdf_writer');
      addTearDown(() => tempDir.deleteSync(recursive: true));

      final path = '${tempDir.path}/desktop.pdf';
      final bytes = Uint8List.fromList(const [0x25, 0x50, 0x44, 0x46, 0x2D, 0x31]);

      final success = await writer.writeBytes(path: path, bytes: bytes);

      expect(success, isTrue);
      expect(await File(path).readAsBytes(), bytes);
    });

    test('falha ao gravar em caminho inválido', () async {
      await expectLater(
        writer.writeBytes(
          path: '/caminho/inexistente/sample.pdf',
          bytes: Uint8List.fromList(const [1]),
        ),
        throwsA(isA<FileSystemException>()),
      );
    });
  });
}

class _SizeMismatchQuotePdfFileWriterService
    implements QuotePdfFileWriterService {
  var writeCallCount = 0;

  @override
  Future<bool> writeBytes({
    required String path,
    required Uint8List bytes,
  }) async {
    writeCallCount++;
    return false;
  }
}

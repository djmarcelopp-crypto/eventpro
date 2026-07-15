import 'package:file_picker/file_picker.dart';

abstract class QuotePdfSaveDialogService {
  Future<String?> pickSavePath({required String filename});
}

class FilePickerQuotePdfSaveDialogService implements QuotePdfSaveDialogService {
  const FilePickerQuotePdfSaveDialogService();

  @override
  Future<String?> pickSavePath({required String filename}) {
    return FilePicker.saveFile(
      dialogTitle: 'Salvar PDF',
      fileName: filename,
      type: FileType.custom,
      allowedExtensions: const ['pdf'],
    );
  }
}

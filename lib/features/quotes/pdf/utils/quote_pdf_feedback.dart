import 'dart:io';

abstract class QuotePdfFeedback {
  static String exportSuccessMessage() {
    if (Platform.isAndroid || Platform.isIOS) {
      return 'PDF compartilhado com sucesso';
    }

    return 'PDF salvo com sucesso';
  }
}

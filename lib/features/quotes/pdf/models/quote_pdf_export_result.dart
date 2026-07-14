sealed class QuotePdfExportResult {
  const QuotePdfExportResult();
}

class QuotePdfExportSuccess extends QuotePdfExportResult {
  const QuotePdfExportSuccess();
}

class QuotePdfExportCancelled extends QuotePdfExportResult {
  const QuotePdfExportCancelled();
}

class QuotePdfExportFailed extends QuotePdfExportResult {
  const QuotePdfExportFailed();
}

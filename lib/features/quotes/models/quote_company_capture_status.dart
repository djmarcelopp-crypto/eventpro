enum QuoteCompanyCaptureStatus {
  incomplete,
  configured,
}

extension QuoteCompanyCaptureStatusLabel on QuoteCompanyCaptureStatus {
  String get label => switch (this) {
        QuoteCompanyCaptureStatus.incomplete => 'Incompleto',
        QuoteCompanyCaptureStatus.configured => 'Completo',
      };
}

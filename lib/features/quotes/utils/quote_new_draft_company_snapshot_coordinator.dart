import 'package:eventpro/features/settings/models/company_profile.dart';

import '../data/services/quote_company_logo_storage_service.dart';
import 'quote_company_snapshot_builder.dart';
import '../models/quote_company_snapshot.dart';

class QuoteNewDraftCompanySnapshotResult {
  const QuoteNewDraftCompanySnapshotResult({
    this.snapshot,
    this.copiedLogoReference,
  });

  final QuoteCompanySnapshot? snapshot;
  final String? copiedLogoReference;
}

class QuoteNewDraftCompanySnapshotCoordinator {
  const QuoteNewDraftCompanySnapshotCoordinator({
    required this.logoStorage,
  });

  final QuoteCompanyLogoStorageService logoStorage;

  Future<QuoteNewDraftCompanySnapshotResult> build({
    required CompanyProfile? profile,
    required String quoteId,
    required DateTime timestamp,
  }) async {
    if (profile == null) {
      return const QuoteNewDraftCompanySnapshotResult();
    }

    String? copiedLogoReference;
    final logoReference = profile.logoReference;
    if (logoReference != null) {
      copiedLogoReference = await logoStorage.copyFromSettingsLogo(
        settingsLogoReference: logoReference,
        quoteId: quoteId,
        timestamp: timestamp,
      );
    }

    final snapshot = QuoteCompanySnapshotBuilder.fromProfile(
      profile: profile,
      capturedAt: timestamp,
      logoReference: copiedLogoReference,
    );

    return QuoteNewDraftCompanySnapshotResult(
      snapshot: snapshot,
      copiedLogoReference: copiedLogoReference,
    );
  }

  Future<void> rollbackCopiedLogo(String? copiedLogoReference) async {
    if (copiedLogoReference == null) {
      return;
    }

    await logoStorage.deleteCommitted(copiedLogoReference);
  }
}

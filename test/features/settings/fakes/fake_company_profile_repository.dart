import 'package:eventpro/features/settings/data/repositories/company_profile_repository.dart';
import 'package:eventpro/features/settings/models/company_profile.dart';

class FakeCompanyProfileRepository implements CompanyProfileRepository {
  FakeCompanyProfileRepository({CompanyProfile? initialProfile})
    : _profile = initialProfile;

  CompanyProfile? _profile;
  var shouldFailOnNextOperation = false;

  @override
  Future<CompanyProfile?> get() async {
    _failIfRequested();
    return _profile;
  }

  @override
  Future<void> upsert(CompanyProfile profile) async {
    _failIfRequested();
    _profile = profile;
  }

  void _failIfRequested() {
    if (!shouldFailOnNextOperation) {
      return;
    }
    shouldFailOnNextOperation = false;
    throw StateError('Simulated repository failure');
  }
}

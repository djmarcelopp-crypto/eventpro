import 'package:eventpro/core/lookup/exceptions/cnpj_lookup_exception.dart';
import 'package:eventpro/core/lookup/models/cnpj_company_data.dart';
import 'package:eventpro/core/lookup/services/cnpj_lookup_service.dart';

class FakeSettingsCnpjLookupService implements CnpjLookupService {
  FakeSettingsCnpjLookupService({
    this.response,
    this.exception,
    this.delay = Duration.zero,
  });

  final CnpjCompanyData? response;
  final CnpjLookupException? exception;
  final Duration delay;

  var lookupCount = 0;

  @override
  Future<CnpjCompanyData> lookup(String cnpjDigits) async {
    await Future<void>.delayed(delay);
    lookupCount++;

    if (exception != null) {
      throw exception!;
    }

    return response ??
        const CnpjCompanyData(
          legalName: 'Marcelo PP Festas LTDA',
          tradeName: 'DJ Marcelo PP',
          street: 'RUA EXEMPLO',
          number: '100',
          neighborhood: 'Centro',
          city: 'Campo Grande',
          state: 'MS',
          postalCode: '79002010',
          phoneDigits: '67999998888',
          whatsAppDigits: '5567999998888',
          email: 'contato@djmarcelo.test',
        );
  }
}

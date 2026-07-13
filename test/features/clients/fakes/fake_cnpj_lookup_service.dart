import 'package:eventpro/features/clients/data/exceptions/cnpj_lookup_exception.dart';
import 'package:eventpro/features/clients/data/models/cnpj_company_data.dart';
import 'package:eventpro/features/clients/data/services/cnpj_lookup_service.dart';

class FakeCnpjLookupService implements CnpjLookupService {
  FakeCnpjLookupService({
    this.response,
    this.exception,
    this.delay = Duration.zero,
  });

  final CnpjCompanyData? response;
  final CnpjLookupException? exception;
  final Duration delay;

  @override
  Future<CnpjCompanyData> lookup(String cnpjDigits) async {
    await Future<void>.delayed(delay);

    if (exception != null) {
      throw exception!;
    }

    return response ??
        const CnpjCompanyData(
          legalName: 'Empresa Ficticia LTDA',
          tradeName: 'Marca Ficticia',
          street: 'RUA DAS FLORES',
          number: '100',
          city: 'Cidade Exemplo',
          state: 'SP',
          phoneDigits: '1133334444',
          whatsAppDigits: '5511987654321',
          email: 'contato@empresaficticia.test',
        );
  }
}

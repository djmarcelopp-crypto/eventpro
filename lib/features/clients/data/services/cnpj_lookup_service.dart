import '../models/cnpj_company_data.dart';

abstract class CnpjLookupService {
  Future<CnpjCompanyData> lookup(String cnpjDigits);
}

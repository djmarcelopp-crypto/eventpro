import '../models/cep_address_data.dart';

abstract class CepLookupService {
  Future<CepAddressData> lookup(String postalCodeDigits);
}

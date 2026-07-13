import 'package:eventpro/core/lookup/exceptions/cep_lookup_exception.dart';
import 'package:eventpro/core/lookup/models/cep_address_data.dart';
import 'package:eventpro/core/lookup/services/cep_lookup_service.dart';

class FakeSettingsCepLookupService implements CepLookupService {
  FakeSettingsCepLookupService({
    this.response,
    this.exception,
    this.delay = Duration.zero,
  });

  final CepAddressData? response;
  final CepLookupException? exception;
  final Duration delay;

  var lookupCount = 0;

  @override
  Future<CepAddressData> lookup(String postalCodeDigits) async {
    await Future<void>.delayed(delay);
    lookupCount++;

    if (exception != null) {
      throw exception!;
    }

    return response ??
        const CepAddressData(
          postalCode: '79002010',
          street: 'Rua Exemplo',
          neighborhood: 'Centro',
          city: 'Campo Grande',
          state: 'MS',
        );
  }
}

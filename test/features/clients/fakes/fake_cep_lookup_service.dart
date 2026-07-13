import 'package:eventpro/features/clients/data/exceptions/cep_lookup_exception.dart';
import 'package:eventpro/features/clients/data/models/cep_address_data.dart';
import 'package:eventpro/features/clients/data/services/cep_lookup_service.dart';

class FakeCepLookupService implements CepLookupService {
  FakeCepLookupService({
    this.response,
    this.exception,
    this.delay = Duration.zero,
  });

  final CepAddressData? response;
  final CepLookupException? exception;
  final Duration delay;

  @override
  Future<CepAddressData> lookup(String postalCodeDigits) async {
    await Future<void>.delayed(delay);

    if (exception != null) {
      throw exception!;
    }

    return response ??
        const CepAddressData(
          postalCode: '79002050',
          street: 'Rua Exemplo',
          neighborhood: 'Centro',
          city: 'Campo Grande',
          state: 'MS',
        );
  }
}

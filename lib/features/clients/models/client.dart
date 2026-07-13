import '../client_form_validators.dart';
import '../client_type.dart';
import 'client_address.dart';

class Client {
  const Client({
    required this.id,
    required this.type,
    required this.name,
    required this.whatsApp,
    this.email,
    this.document,
    this.address,
    this.instagram,
    this.birthday,
    this.internalNotes,
  });

  final String id;
  final ClientType type;
  final String name;
  final String whatsApp;
  final String? email;
  final String? document;
  final ClientAddress? address;
  final String? instagram;
  final DateTime? birthday;

  /// Internal use only. Must never appear in list cards, budgets or PDFs.
  final String? internalNotes;

  factory Client.fromForm({
    required ClientType type,
    required String name,
    required String whatsApp,
    String? email,
    String? document,
    String? street,
    String? number,
    String? complement,
    String? neighborhood,
    String? city,
    String? state,
    String? instagram,
    DateTime? birthday,
    String? internalNotes,
  }) {
    return Client(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      type: type,
      name: name.trim(),
      whatsApp: ClientFormValidators.extractDigits(whatsApp),
      email: _optionalText(email),
      document: _optionalDigits(document),
      address: ClientAddress.fromForm(
        street: street,
        number: number,
        complement: complement,
        neighborhood: neighborhood,
        city: city,
        state: state,
      ),
      instagram: _optionalText(instagram),
      birthday: birthday,
      internalNotes: _optionalText(internalNotes),
    );
  }

  static String? _optionalText(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  static String? _optionalDigits(String? value) {
    final digits = ClientFormValidators.extractDigits(value);
    if (digits.isEmpty) {
      return null;
    }
    return digits;
  }
}

import '../client_form_validators.dart';
import '../client_type.dart';
import 'client_address.dart';

class Client {
  const Client({
    required this.id,
    required this.createdAt,
    required this.type,
    required this.name,
    this.whatsApp,
    this.tradeName,
    this.phone,
    this.email,
    this.document,
    this.address,
    this.instagram,
    this.birthday,
    this.internalNotes,
  });

  final String id;
  final DateTime createdAt;
  final ClientType type;
  final String name;
  final String? tradeName;
  final String? phone;
  final String? whatsApp;
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
    String? whatsApp,
    String? tradeName,
    String? phone,
    String? email,
    String? document,
    String? street,
    String? number,
    String? complement,
    String? neighborhood,
    String? city,
    String? state,
    String? postalCode,
    String? instagram,
    DateTime? birthday,
    String? internalNotes,
    String? id,
    DateTime? createdAt,
  }) {
    return Client(
      id: id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      createdAt: createdAt ?? DateTime.now(),
      type: type,
      name: name.trim(),
      tradeName: _optionalText(tradeName),
      phone: _optionalDigits(phone),
      whatsApp: _optionalDigits(whatsApp),
      email: _optionalText(email),
      document: _optionalDigits(document),
      address: ClientAddress.fromForm(
        postalCode: postalCode,
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

  Client copyWith({
    String? id,
    DateTime? createdAt,
    ClientType? type,
    String? name,
    String? tradeName,
    String? phone,
    String? whatsApp,
    String? email,
    String? document,
    ClientAddress? address,
    String? instagram,
    DateTime? birthday,
    String? internalNotes,
    bool clearTradeName = false,
    bool clearPhone = false,
    bool clearWhatsApp = false,
    bool clearEmail = false,
    bool clearDocument = false,
    bool clearAddress = false,
    bool clearInstagram = false,
    bool clearBirthday = false,
    bool clearInternalNotes = false,
  }) {
    return Client(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      name: name ?? this.name,
      tradeName: clearTradeName ? null : (tradeName ?? this.tradeName),
      phone: clearPhone ? null : (phone ?? this.phone),
      whatsApp: clearWhatsApp ? null : (whatsApp ?? this.whatsApp),
      email: clearEmail ? null : (email ?? this.email),
      document: clearDocument ? null : (document ?? this.document),
      address: clearAddress ? null : (address ?? this.address),
      instagram: clearInstagram ? null : (instagram ?? this.instagram),
      birthday: clearBirthday ? null : (birthday ?? this.birthday),
      internalNotes:
          clearInternalNotes ? null : (internalNotes ?? this.internalNotes),
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

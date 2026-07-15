import 'package:drift/drift.dart';
import 'package:eventpro/core/database/app_database.dart';
import 'package:eventpro/core/database/converters/civil_date_converter.dart';
import 'package:eventpro/core/database/converters/timestamp_converter.dart';
import 'package:eventpro/features/clients/client_type.dart';
import 'package:eventpro/features/clients/models/client.dart';
import 'package:eventpro/features/clients/models/client_address.dart';

abstract class ClientMapper {
  static Client toDomain(ClientRow row) {
    final address = _toAddress(row);
    return Client(
      id: row.id,
      createdAt: TimestampConverter.fromUtcMillis(row.createdAt),
      type: _parseType(row.type),
      name: row.name,
      tradeName: row.tradeName,
      phone: row.phoneDigits,
      whatsApp: row.whatsappDigits,
      email: row.email,
      document: row.documentDigits,
      address: address,
      instagram: row.instagram,
      birthday: CivilDateConverter.fromIsoDate(row.birthday),
      internalNotes: row.internalNotes,
    );
  }

  static ClientsCompanion toInsertCompanion(Client client) {
    return _toCompanion(client);
  }

  static ClientsCompanion toUpdateCompanion(Client client) {
    return _toCompanion(client);
  }

  static ClientsCompanion _toCompanion(Client client) {
    final address = client.address;
    return ClientsCompanion.insert(
      id: client.id,
      createdAt: TimestampConverter.toUtcMillis(client.createdAt),
      type: client.type.name,
      name: client.name,
      tradeName: Value(client.tradeName),
      phoneDigits: Value(client.phone),
      whatsappDigits: Value(client.whatsApp),
      email: Value(client.email),
      documentDigits: Value(client.document),
      instagram: Value(client.instagram),
      birthday: Value(CivilDateConverter.toIsoDate(client.birthday)),
      internalNotes: Value(client.internalNotes),
      postalCode: Value(address?.postalCode),
      street: Value(address?.street),
      number: Value(address?.number),
      complement: Value(address?.complement),
      neighborhood: Value(address?.neighborhood),
      city: Value(address?.city),
      state: Value(address?.state),
    );
  }

  static ClientAddress? _toAddress(ClientRow row) {
    final address = ClientAddress(
      postalCode: row.postalCode,
      street: row.street,
      number: row.number,
      complement: row.complement,
      neighborhood: row.neighborhood,
      city: row.city,
      state: row.state,
    );

    return address.isEmpty ? null : address;
  }

  static ClientType _parseType(String value) {
    return ClientType.values.firstWhere((type) => type.name == value);
  }
}

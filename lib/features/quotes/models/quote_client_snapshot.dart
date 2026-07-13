import '../../clients/client_type.dart';
import '../../clients/models/client.dart';
import '../../clients/models/client_address.dart';
import 'quote_client_type.dart';

class QuoteClientSnapshot {
  const QuoteClientSnapshot({
    this.sourceClientId,
    required this.type,
    required this.displayName,
    this.legalName,
    this.document,
    this.phone,
    this.whatsApp,
    this.email,
    this.addressSummary,
  });

  final String? sourceClientId;
  final QuoteClientType type;
  final String displayName;
  final String? legalName;
  final String? document;
  final String? phone;
  final String? whatsApp;
  final String? email;
  final String? addressSummary;

  factory QuoteClientSnapshot.fromClient(Client client) {
    final tradeName = client.tradeName?.trim();
    final hasTradeName = tradeName != null && tradeName.isNotEmpty;
    final isCompany = client.type == ClientType.company;

    return QuoteClientSnapshot(
      sourceClientId: client.id,
      type: _toQuoteClientType(client.type),
      displayName: isCompany && hasTradeName ? tradeName : client.name,
      legalName: isCompany ? client.name : null,
      document: _optionalDigits(client.document),
      phone: _optionalDigits(client.phone),
      whatsApp: _optionalDigits(client.whatsApp),
      email: _optionalText(client.email),
      addressSummary: _formatAddress(client.address),
    );
  }

  static QuoteClientType _toQuoteClientType(ClientType type) {
    return switch (type) {
      ClientType.individual => QuoteClientType.individual,
      ClientType.company => QuoteClientType.company,
    };
  }

  static String? _optionalText(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }
    return trimmed;
  }

  static String? _optionalDigits(String? value) {
    final digits = value?.replaceAll(RegExp(r'\D'), '') ?? '';
    if (digits.isEmpty) {
      return null;
    }
    return digits;
  }

  static String? _formatAddress(ClientAddress? address) {
    if (address == null || address.isEmpty) {
      return null;
    }

    final parts = <String>[];

    final street = address.street?.trim();
    final number = address.number?.trim();
    if (street != null && street.isNotEmpty) {
      if (number != null && number.isNotEmpty) {
        parts.add('$street, $number');
      } else {
        parts.add(street);
      }
    }

    final complement = address.complement?.trim();
    if (complement != null && complement.isNotEmpty) {
      parts.add(complement);
    }

    final neighborhood = address.neighborhood?.trim();
    if (neighborhood != null && neighborhood.isNotEmpty) {
      parts.add(neighborhood);
    }

    final city = address.city?.trim();
    final state = address.state?.trim();
    if (city != null && city.isNotEmpty) {
      if (state != null && state.isNotEmpty) {
        parts.add('$city - $state');
      } else {
        parts.add(city);
      }
    } else if (state != null && state.isNotEmpty) {
      parts.add(state);
    }

    if (parts.isEmpty) {
      return null;
    }

    return parts.join(' • ');
  }
}

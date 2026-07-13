import '../models/client.dart';
import 'client_date_formatter.dart';
import 'client_display_formatter.dart';
import 'text_input_masks.dart';

class ClientDetailItem {
  const ClientDetailItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;
}

abstract class ClientDetailPresenter {
  static String displayTitle(Client client) {
    final tradeName = client.tradeName?.trim();
    if (tradeName != null && tradeName.isNotEmpty) {
      return tradeName;
    }
    return client.name;
  }

  static List<ClientDetailItem> identification(Client client) {
    final items = <ClientDetailItem>[
      ClientDetailItem(label: 'Tipo', value: client.type.label),
      ClientDetailItem(label: 'Nome', value: client.name),
    ];

    final tradeName = client.tradeName?.trim();
    if (tradeName != null && tradeName.isNotEmpty) {
      items.add(ClientDetailItem(label: 'Nome fantasia', value: tradeName));
    }

    final document = client.document;
    if (document != null && document.isNotEmpty) {
      items.add(
        ClientDetailItem(
          label: ClientDisplayFormatter.documentLabel(client.type),
          value: ClientDisplayFormatter.formatDocument(client.type, document),
        ),
      );
    }

    return items;
  }

  static List<ClientDetailItem> contact(Client client) {
    final items = <ClientDetailItem>[];

    final phone = client.phone;
    if (phone != null && phone.isNotEmpty) {
      items.add(
        ClientDetailItem(
          label: 'Telefone',
          value: ClientDisplayFormatter.formatPhone(phone),
        ),
      );
    }

    items.add(
      ClientDetailItem(
        label: 'WhatsApp',
        value: ClientDisplayFormatter.formatWhatsApp(client.whatsApp),
      ),
    );

    final email = client.email?.trim();
    if (email != null && email.isNotEmpty) {
      items.add(ClientDetailItem(label: 'E-mail', value: email));
    }

    final instagram = client.instagram?.trim();
    if (instagram != null && instagram.isNotEmpty) {
      items.add(ClientDetailItem(label: 'Instagram', value: instagram));
    }

    return items;
  }

  static List<ClientDetailItem> address(Client client) {
    final address = client.address;
    if (address == null) {
      return const [];
    }

    final items = <ClientDetailItem>[];

    final postalCode = address.postalCode;
    if (postalCode != null && postalCode.isNotEmpty) {
      items.add(
        ClientDetailItem(
          label: 'CEP',
          value: CepInputFormatter.formatFromDigits(postalCode),
        ),
      );
    }

    final street = address.street?.trim();
    if (street != null && street.isNotEmpty) {
      items.add(ClientDetailItem(label: 'Logradouro', value: street));
    }

    final number = address.number?.trim();
    if (number != null && number.isNotEmpty) {
      items.add(ClientDetailItem(label: 'Número', value: number));
    }

    final complement = address.complement?.trim();
    if (complement != null && complement.isNotEmpty) {
      items.add(ClientDetailItem(label: 'Complemento', value: complement));
    }

    final neighborhood = address.neighborhood?.trim();
    if (neighborhood != null && neighborhood.isNotEmpty) {
      items.add(ClientDetailItem(label: 'Bairro', value: neighborhood));
    }

    final city = address.city?.trim();
    if (city != null && city.isNotEmpty) {
      items.add(ClientDetailItem(label: 'Cidade', value: city));
    }

    final state = address.state?.trim();
    if (state != null && state.isNotEmpty) {
      items.add(ClientDetailItem(label: 'Estado (UF)', value: state));
    }

    return items;
  }

  static List<ClientDetailItem> additional(Client client) {
    final birthday = client.birthday;
    if (birthday == null) {
      return const [];
    }

    return [
      ClientDetailItem(
        label: 'Data de aniversário',
        value: ClientDateFormatter.formatBirthday(birthday),
      ),
    ];
  }

  static String? internalNotes(Client client) {
    final notes = client.internalNotes?.trim();
    if (notes == null || notes.isEmpty) {
      return null;
    }
    return notes;
  }
}

import 'package:flutter/material.dart';

import '../client_type.dart';
import '../models/client.dart';
import 'client_date_formatter.dart';
import 'client_display_formatter.dart';
import 'text_input_masks.dart';

class ClientFormValues {
  const ClientFormValues({
    required this.clientType,
    required this.birthday,
    required this.alsoWhatsApp,
    required this.name,
    required this.tradeName,
    required this.phone,
    required this.whatsApp,
    required this.email,
    required this.document,
    required this.postalCode,
    required this.street,
    required this.number,
    required this.complement,
    required this.neighborhood,
    required this.city,
    required this.state,
    required this.instagram,
    required this.internalNotes,
    required this.birthdayText,
  });

  final ClientType clientType;
  final DateTime? birthday;
  final bool alsoWhatsApp;
  final String name;
  final String tradeName;
  final String phone;
  final String whatsApp;
  final String email;
  final String document;
  final String postalCode;
  final String street;
  final String number;
  final String complement;
  final String neighborhood;
  final String city;
  final String state;
  final String instagram;
  final String internalNotes;
  final String birthdayText;
}

abstract class ClientFormInitializer {
  static ClientFormValues fromClient(Client client) {
    final address = client.address;

    return ClientFormValues(
      clientType: client.type,
      birthday: client.birthday,
      alsoWhatsApp: isPhoneAlsoWhatsApp(client),
      name: client.name,
      tradeName: client.tradeName ?? '',
      phone: client.phone == null
          ? ''
          : ClientDisplayFormatter.formatPhone(client.phone!),
      whatsApp: ClientDisplayFormatter.formatWhatsApp(client.whatsApp),
      email: client.email ?? '',
      document: client.document == null
          ? ''
          : ClientDisplayFormatter.formatDocument(
              client.type,
              client.document!,
            ),
      postalCode: address?.postalCode == null
          ? ''
          : CepInputFormatter.formatFromDigits(address!.postalCode!),
      street: address?.street ?? '',
      number: address?.number ?? '',
      complement: address?.complement ?? '',
      neighborhood: address?.neighborhood ?? '',
      city: address?.city ?? '',
      state: address?.state ?? '',
      instagram: client.instagram ?? '',
      internalNotes: client.internalNotes ?? '',
      birthdayText: client.birthday == null
          ? ''
          : ClientDateFormatter.formatBirthday(client.birthday!),
    );
  }

  static void applyToControllers({
    required ClientFormValues values,
    required TextEditingController nameController,
    required TextEditingController tradeNameController,
    required TextEditingController phoneController,
    required TextEditingController whatsAppController,
    required TextEditingController emailController,
    required TextEditingController documentController,
    required TextEditingController postalCodeController,
    required TextEditingController streetController,
    required TextEditingController numberController,
    required TextEditingController complementController,
    required TextEditingController neighborhoodController,
    required TextEditingController cityController,
    required TextEditingController stateController,
    required TextEditingController instagramController,
    required TextEditingController birthdayController,
    required TextEditingController notesController,
  }) {
    nameController.text = values.name;
    tradeNameController.text = values.tradeName;
    phoneController.text = values.phone;
    whatsAppController.text = values.whatsApp;
    emailController.text = values.email;
    documentController.text = values.document;
    postalCodeController.text = values.postalCode;
    streetController.text = values.street;
    numberController.text = values.number;
    complementController.text = values.complement;
    neighborhoodController.text = values.neighborhood;
    cityController.text = values.city;
    stateController.text = values.state;
    instagramController.text = values.instagram;
    birthdayController.text = values.birthdayText;
    notesController.text = values.internalNotes;
  }

  static bool isPhoneAlsoWhatsApp(Client client) {
    final phone = client.phone;
    if (phone == null) {
      return false;
    }

    return client.whatsApp == '55$phone';
  }
}

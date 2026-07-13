import '../../clients/models/client.dart';

abstract class QuoteClientSearch {
  static List<Client> filter(List<Client> clients, String query) {
    if (query.trim().isEmpty) {
      return List<Client>.from(clients);
    }

    return [
      for (final client in clients)
        if (matches(client, query)) client,
    ];
  }

  static bool matches(Client client, String query) {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) {
      return true;
    }

    final queryDigits = normalizedQuery.replaceAll(RegExp(r'\D'), '');

    if (client.name.toLowerCase().contains(normalizedQuery)) {
      return true;
    }

    final tradeName = client.tradeName?.trim().toLowerCase() ?? '';
    if (tradeName.isNotEmpty && tradeName.contains(normalizedQuery)) {
      return true;
    }

    final email = client.email?.trim().toLowerCase() ?? '';
    if (email.isNotEmpty && email.contains(normalizedQuery)) {
      return true;
    }

    if (queryDigits.isNotEmpty) {
      final document = client.document ?? '';
      if (document.contains(queryDigits)) {
        return true;
      }

      final phone = client.phone ?? '';
      if (phone.contains(queryDigits)) {
        return true;
      }

      final whatsApp = client.whatsApp ?? '';
      if (whatsApp.contains(queryDigits)) {
        return true;
      }
    }

    return false;
  }
}

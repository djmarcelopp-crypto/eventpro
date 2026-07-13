abstract class LookupConnectivity {
  static bool isConnectivityIssue(String message) {
    final lower = message.toLowerCase();

    const patterns = [
      'failed host lookup',
      'no address associated with hostname',
      'network is unreachable',
      'internet connection appears to be offline',
      'name or service not known',
      'nodename nor servname provided',
      'temporary failure in name resolution',
      'network unreachable',
    ];

    return patterns.any(lower.contains);
  }
}

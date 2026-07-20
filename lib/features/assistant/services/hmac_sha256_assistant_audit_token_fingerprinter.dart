import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';

import '../domain/audit/assistant_audit_token_fingerprinter.dart';

/// HMAC-SHA-256 token fingerprinter with injectable key material.
///
/// Key material must be supplied by the caller (min 32 bytes). No trivial
/// hardcoded secrets live in the domain layer.
class HmacSha256AssistantAuditTokenFingerprinter
    implements AssistantAuditTokenFingerprinter {
  HmacSha256AssistantAuditTokenFingerprinter({
    required List<int> keyMaterial,
  }) : _key = Uint8List.fromList(keyMaterial) {
    if (_key.length < 32) {
      throw ArgumentError.value(
        _key.length,
        'keyMaterial.length',
        'HMAC key material must be at least 32 bytes',
      );
    }
  }

  final Uint8List _key;

  @override
  String fingerprint(String rawToken) {
    final hmac = Hmac(sha256, _key);
    final digest = hmac.convert(utf8.encode(rawToken));
    return 'hmac-sha256-${digest.toString()}';
  }
}

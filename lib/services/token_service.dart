import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:get/get.dart';
import '../core/errors/app_error.dart';
import '../data/models/token_model.dart';

class TokenService extends GetxService {
  static const String _secretKey = "omnipass_secure_key_2026";

  // Generate HMAC-SHA256 signature for a clean payload
  String generateSignature(Map<String, dynamic> payload) {
    final cleanPayload = Map<String, dynamic>.from(payload)..remove('signature');
    // Sort keys to guarantee a deterministic JSON payload serialization
    final sortedCleanPayload = _sortMap(cleanPayload);
    final jsonStr = jsonEncode(sortedCleanPayload);
    final keyBytes = utf8.encode(_secretKey);
    final dataBytes = utf8.encode(jsonStr);
    final hmac = Hmac(sha256, keyBytes);
    return hmac.convert(dataBytes).toString();
  }

  // Create a signed Base64URL-encoded token
  String createSignedToken({
    required String passId,
    required Duration validity,
    required String nonce,
    String scope = 'pass',
    int? issuedAt,
  }) {
    final now = issuedAt ?? (DateTime.now().millisecondsSinceEpoch ~/ 1000);
    final expires = now + validity.inSeconds;

    final payload = {
      'passId': passId,
      'issuedAt': now,
      'expiresAt': expires,
      'nonce': nonce,
      'scope': scope,
    };

    final sig = generateSignature(payload);
    payload['signature'] = sig;

    final jsonStr = jsonEncode(payload);
    return base64Url.encode(utf8.encode(jsonStr));
  }

  // Parses and validates the token structure locally. Throws AppErrorType on failure.
  TokenModel parseAndValidateLocally(String base64Token) {
    Map<String, dynamic> payload;
    try {
      final decodedBytes = base64Url.decode(base64Token);
      final jsonStr = utf8.decode(decodedBytes);
      payload = jsonDecode(jsonStr) as Map<String, dynamic>;
    } catch (_) {
      throw AppErrorType.malformedLink;
    }

    // Verify required fields
    final requiredFields = [
      'passId',
      'issuedAt',
      'expiresAt',
      'nonce',
      'scope',
      'signature'
    ];
    for (final field in requiredFields) {
      if (!payload.containsKey(field) || payload[field] == null) {
        throw AppErrorType.missingToken;
      }
    }

    // Verify signature integrity
    final providedSig = payload['signature'] as String;
    final expectedSig = generateSignature(payload);
    if (providedSig != expectedSig) {
      throw AppErrorType.invalidSignature;
    }

    // Verify timestamp logic
    final issuedAt = payload['issuedAt'] as int;
    final expiresAt = payload['expiresAt'] as int;
    if (expiresAt <= issuedAt) {
      throw AppErrorType.malformedLink;
    }

    // Verify temporal validity (expiry)
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    if (now > expiresAt) {
      throw AppErrorType.expiredToken;
    }

    return TokenModel.fromJson(payload);
  }

  Map<String, dynamic> _sortMap(Map<String, dynamic> unsorted) {
    final sortedKeys = unsorted.keys.toList()..sort();
    return {for (var k in sortedKeys) k: unsorted[k]};
  }
}

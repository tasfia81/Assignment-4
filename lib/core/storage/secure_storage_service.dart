import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class SecureStorageService extends GetxService {
  final _storage = const FlutterSecureStorage();

  Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      // Secure storage fallback or logging
    }
  }

  Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      return null;
    }
  }

  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      // Ignored
    }
  }

  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      // Ignored
    }
  }

  // Save a scoped pass session
  Future<void> saveSession(String passId, String sessionToken, String expiresAt) async {
    await write('session_token_pass_$passId', sessionToken);
    await write('session_expiry_pass_$passId', expiresAt);
  }

  // Get session token for a specific passId
  Future<String?> getSession(String passId) async {
    return await read('session_token_pass_$passId');
  }

  // Clear session for a specific passId
  Future<void> clearSession(String passId) async {
    await delete('session_token_pass_$passId');
    await delete('session_expiry_pass_$passId');
  }

  // Check if a valid session exists for a specific passId (checks presence and expiry)
  Future<bool> hasValidSession(String passId) async {
    final token = await getSession(passId);
    if (token == null || token.isEmpty) return false;

    final expiryStr = await read('session_expiry_pass_$passId');
    if (expiryStr == null || expiryStr.isEmpty) return false;

    try {
      final expiry = DateTime.parse(expiryStr);
      // Valid if current time is before expiry
      return DateTime.now().isBefore(expiry);
    } catch (_) {
      return false;
    }
  }

  // Mark a deep link nonce as redeemed (single-use cache)
  Future<void> markNonceAsRedeemed(String nonce) async {
    await write('redeemed_nonce_$nonce', 'true');
  }

  // Check if a deep link nonce has already been redeemed
  Future<bool> isNonceRedeemed(String nonce) async {
    final val = await read('redeemed_nonce_$nonce');
    return val == 'true';
  }
}

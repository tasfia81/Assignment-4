import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:assignment_4/core/errors/app_error.dart';
import 'package:assignment_4/core/storage/secure_storage_service.dart';
import 'package:assignment_4/data/repositories/pass_repository.dart';
import 'package:assignment_4/services/token_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late TokenService tokenService;
  late PassRepository passRepository;

  setUp(() {
    Get.reset();
    Get.put(SecureStorageService());
    passRepository = Get.put(PassRepository());
    tokenService = Get.put(TokenService());
  });

  group('Token Model & Service Cryptographic Verification Tests', () {
    test('TokenService creates and verifies a valid signed token payload successfully', () {
      final base64Token = tokenService.createSignedToken(
        passId: 'pass_concert_1',
        validity: const Duration(minutes: 10),
        nonce: 'test_nonce_123',
      );

      final tokenModel = tokenService.parseAndValidateLocally(base64Token);
      
      expect(tokenModel.passId, 'pass_concert_1');
      expect(tokenModel.nonce, 'test_nonce_123');
      expect(tokenModel.scope, 'pass');
      expect(tokenModel.signature, isNotEmpty);
    });

    test('TokenService rejects expired tokens with AppErrorType.expiredToken', () {
      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final base64Token = tokenService.createSignedToken(
        passId: 'pass_concert_1',
        validity: const Duration(minutes: 10),
        nonce: 'test_nonce_expired',
        issuedAt: now - 1200, // Issued 20 minutes ago, valid for 10 minutes (expired 10 minutes ago)
      );

      expect(
        () => tokenService.parseAndValidateLocally(base64Token),
        throwsA(equals(AppErrorType.expiredToken)),
      );
    });

    test('TokenService rejects tampered signatures with AppErrorType.invalidSignature', () {
      final base64Token = tokenService.createSignedToken(
        passId: 'pass_concert_1',
        validity: const Duration(minutes: 10),
        nonce: 'test_nonce_tamper',
      );

      // Decode, modify the signature field, and re-encode to preserve JSON validity but tamper with signature integrity
      final decodedBytes = base64Url.decode(base64Token);
      final jsonStr = utf8.decode(decodedBytes);
      final payload = jsonDecode(jsonStr) as Map<String, dynamic>;
      payload['signature'] = "invalid_tampered_signature_value";
      
      final tamperedToken = base64Url.encode(utf8.encode(jsonEncode(payload)));

      expect(
        () => tokenService.parseAndValidateLocally(tamperedToken),
        throwsA(equals(AppErrorType.invalidSignature)),
      );
    });

    test('TokenService rejects malformed base64URL data with AppErrorType.malformedLink', () {
      expect(
        () => tokenService.parseAndValidateLocally("this_is_clearly_not_base64_json"),
        throwsA(equals(AppErrorType.malformedLink)),
      );
    });
  });

  group('Backend Token Exchange & Session Scoping Tests', () {
    test('PassRepository exchanges a valid token for a session grant', () async {
      final base64Token = tokenService.createSignedToken(
        passId: 'pass_concert_1',
        validity: const Duration(minutes: 10),
        nonce: 'test_nonce_exchange',
      );

      final tokenModel = tokenService.parseAndValidateLocally(base64Token);
      final sessionGrant = await passRepository.exchangeDeepLinkToken(tokenModel);

      expect(sessionGrant['sessionToken'], startsWith('session_token_pass_concert_1'));
      expect(sessionGrant['passId'], 'pass_concert_1');
      expect(sessionGrant['scope'], 'pass');
      expect(sessionGrant['expiresAt'], isNotEmpty);
    });

    test('PassRepository simulated exchange maps nonce error flags correctly', () async {
      final base64Token = tokenService.createSignedToken(
        passId: 'pass_concert_1',
        validity: const Duration(minutes: 10),
        nonce: 'nonce_revoked',
      );

      final tokenModel = tokenService.parseAndValidateLocally(base64Token);

      expect(
        () => passRepository.exchangeDeepLinkToken(tokenModel),
        throwsA(equals(AppErrorType.revokedToken)),
      );
    });
  });
}

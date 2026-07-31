import 'package:get/get.dart';
import '../models/category_model.dart';
import '../models/pass_model.dart';
import '../models/token_model.dart';
import '../../core/errors/app_error.dart';

class PassRepository extends GetxService {
  final List<CategoryModel> categories = [
    CategoryModel(
      categoryId: 'events',
      name: 'Event Tickets',
      type: PassCategoryType.event,
      description: 'Concerts, sports matches, and show bookings',
    ),
    CategoryModel(
      categoryId: 'access',
      name: 'Access Passes',
      type: PassCategoryType.access,
      description: 'Lounge keys, entry permits, and smart-gate credentials',
    ),
    CategoryModel(
      categoryId: 'credentials',
      name: 'Digital IDs & Badges',
      type: PassCategoryType.credential,
      description: 'Corporate badges, membership cards, and IDs',
    ),
  ];

  final List<PassModel> passes = [];

  @override
  void onInit() {
    super.onInit();
    _generateMockPasses();
  }

  void _generateMockPasses() {
    // Event tickets
    passes.add(PassModel(
      passId: 'pass_concert_1',
      title: 'Neon Lights Festival 2026',
      category: PassCategoryType.event,
      categoryId: 'events',
      venue: 'Metropolis Stadium, NY',
      date: 'Aug 15, 2026',
      time: '18:00',
      seat: 'VIP Box 4, Seat 12',
      status: PassStatus.active,
      qrCodeValue: 'OMNIPASS_SECURE_TOKEN_STADIUM_NEON_LIGHTS',
      ownerName: 'Alex Rivera',
      price: '\$180.00',
      gate: 'Gate A',
    ));
    
    // Generate Event tickets for virtualization test
    for (int i = 2; i <= 15; i++) {
      passes.add(PassModel(
        passId: 'pass_event_$i',
        title: 'Cyberpunk Symphony Vol. $i',
        category: PassCategoryType.event,
        categoryId: 'events',
        venue: 'Aether Symphony Hall',
        date: 'Sept ${10 + i}, 2026',
        time: '20:00',
        seat: 'Row G, Seat $i',
        status: i % 5 == 0 ? PassStatus.expired : (i % 6 == 0 ? PassStatus.redeemed : PassStatus.active),
        qrCodeValue: 'OMNIPASS_SECURE_CYBER_SYMPHONY_$i',
        ownerName: 'Alex Rivera',
        price: '\$75.00',
        gate: 'Main Hall Gate',
      ));
    }

    // Access passes
    passes.add(PassModel(
      passId: 'pass_vip_1',
      title: 'Skyline Lounge VIP Access',
      category: PassCategoryType.access,
      categoryId: 'access',
      venue: 'Skyline Hotel Rooftop',
      date: 'Dec 31, 2026',
      time: '24/7 Access',
      status: PassStatus.active,
      qrCodeValue: 'OMNIPASS_SECURE_ROOFTOP_LOUNGE',
      ownerName: 'Alex Rivera',
      price: 'Subscription',
      gate: 'Elevator B',
    ));

    // Generate Access passes
    for (int i = 2; i <= 15; i++) {
      passes.add(PassModel(
        passId: 'pass_access_$i',
        title: 'Aether Co-working Space Key $i',
        category: PassCategoryType.access,
        categoryId: 'access',
        venue: 'Aether Offices Floor $i',
        date: 'Ongoing 2026',
        time: '08:00 - 22:00',
        status: i % 4 == 0 ? PassStatus.expired : PassStatus.active,
        qrCodeValue: 'OMNIPASS_SECURE_COWORKING_$i',
        ownerName: 'Alex Rivera',
        price: 'Corporate',
        gate: 'Turnstile ${i % 3 + 1}',
      ));
    }

    // Credentials / Badges
    passes.add(PassModel(
      passId: 'pass_credential_1',
      title: 'HQ Corporate Smart Badge',
      category: PassCategoryType.credential,
      categoryId: 'credentials',
      venue: 'OmniPass Technologies HQ',
      date: 'Permanent Badge',
      time: 'Security Gate Clearance',
      status: PassStatus.active,
      qrCodeValue: 'OMNIPASS_SECURE_CORPORATE_BADGE_HQ',
      ownerName: 'Alex Rivera (Dev Lead)',
      gate: 'Main Gate / Elevator Bank A',
    ));

    for (int i = 2; i <= 15; i++) {
      passes.add(PassModel(
        passId: 'pass_credential_$i',
        title: 'FitLife Gym Membership #0$i',
        category: PassCategoryType.credential,
        categoryId: 'credentials',
        venue: 'FitLife Center, West End',
        date: 'Expires Oct 2026',
        time: 'All Hours Access',
        status: i % 7 == 0 ? PassStatus.expired : PassStatus.active,
        qrCodeValue: 'OMNIPASS_SECURE_GYM_MEMBERSHIP_$i',
        ownerName: 'Alex Rivera',
        gate: 'Reception Smart Bar',
      ));
    }
  }

  // Get categories
  List<CategoryModel> getCategories() => categories;

  // Get passes by category ID
  List<PassModel> getPassesByCategoryId(String categoryId) {
    return passes.where((p) => p.categoryId == categoryId).toList();
  }

  // Get single pass by ID
  PassModel? getPassById(String passId) {
    try {
      return passes.firstWhere((p) => p.passId == passId);
    } catch (_) {
      return null;
    }
  }

  // Token-to-pass mapping for testing Phase 1
  PassModel? getPassByToken(String token) {
    // If the token matches a pass ID directly
    return getPassById(token);
  }

  // Simulated Backend Token Exchange Endpoint
  Future<Map<String, dynamic>> exchangeDeepLinkToken(TokenModel token) async {
    // 1. Simulate network latency
    await Future.delayed(const Duration(milliseconds: 800));

    // 2. Simulated server errors mapping based on nonces
    if (token.nonce == 'nonce_revoked') {
      throw AppErrorType.revokedToken;
    } else if (token.nonce == 'nonce_redeemed') {
      throw AppErrorType.redeemedToken;
    } else if (token.nonce == 'nonce_network_error') {
      throw AppErrorType.networkError;
    } else if (token.nonce == 'nonce_unknown_error') {
      throw AppErrorType.unknownError;
    }

    // 3. Assure target pass exists in database
    final pass = getPassById(token.passId);
    if (pass == null) {
      throw AppErrorType.invalidToken;
    }

    // 4. Return successful session grant payload
    final sessionToken = "session_token_${token.passId}_${token.nonce}";
    final expiresAt = DateTime.now().add(const Duration(hours: 1)).toIso8601String();

    return {
      "sessionToken": sessionToken,
      "passId": token.passId,
      "scope": "pass",
      "expiresAt": expiresAt,
    };
  }
}

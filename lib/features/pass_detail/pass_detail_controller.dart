import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../core/storage/secure_storage_service.dart';
import '../../data/models/pass_model.dart';
import '../../data/repositories/pass_repository.dart';
import '../../services/token_service.dart';

class PassDetailController extends GetxController {
  final String passId;
  final PassRepository _repository = Get.find<PassRepository>();

  final Rxn<PassModel> pass = Rxn<PassModel>();
  final RxBool isLoading = true.obs;
  final RxBool isExchanging = false.obs;

  PassDetailController({required this.passId});

  @override
  void onInit() {
    super.onInit();
    _loadPassDetails();
  }

  void _loadPassDetails() {
    isLoading.value = true;
    final data = _repository.getPassById(passId);
    if (data != null) {
      pass.value = data;
    }
    isLoading.value = false;
  }

  // Simulates requesting the signed token and exchanging it manually for the pass view
  Future<void> requestAndOpenSecurePass(String categoryId, String passId) async {
    isExchanging.value = true;
    
    // Simulate small latency for network fetch of the signed token
    await Future.delayed(const Duration(milliseconds: 600));
    
    final tokenService = Get.find<TokenService>();
    final nonce = "nonce_manual_${DateTime.now().millisecondsSinceEpoch}";
    
    // Generates a valid cryptographically signed token for this specific passId
    final base64Token = tokenService.createSignedToken(
      passId: passId, 
      validity: const Duration(minutes: 15), 
      nonce: nonce,
    );

    try {
      // 1. Local parsing & validation
      final tokenModel = tokenService.parseAndValidateLocally(base64Token);
      
      // 2. Simulated backend exchange
      final sessionGrant = await _repository.exchangeDeepLinkToken(tokenModel);
      
      // 3. Secure storage caching of the scoped session grant
      final storage = Get.find<SecureStorageService>();
      await storage.saveSession(
        passId, 
        sessionGrant['sessionToken'] as String, 
        sessionGrant['expiresAt'] as String,
      );
      
      isExchanging.value = false;
      
      // 4. Navigate to secure view
      final router = Get.find<GoRouter>();
      router.go('/wallet/category/$categoryId/pass/$passId/secure');
    } catch (_) {
      isExchanging.value = false;
      final router = Get.find<GoRouter>();
      router.go('/error?type=unknownError');
    }
  }
}

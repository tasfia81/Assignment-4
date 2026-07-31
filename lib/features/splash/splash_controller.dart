import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../services/deep_link_service.dart';

class SplashController extends GetxController {
  final DeepLinkService _deepLinkService = Get.find<DeepLinkService>();

  @override
  void onInit() {
    super.onInit();
    _startInitFlow();
  }

  Future<void> _startInitFlow() async {
    // 1. Initialize deep links listener streams
    await _deepLinkService.init();

    // 2. Capture cold start links
    final coldStartUri = await _deepLinkService.checkForColdStart();

    // Give a short delay for branding appreciation and setup checks
    await Future.delayed(const Duration(milliseconds: 1800));

    if (coldStartUri == null) {
      // If no deep link, head to main wallet dashboard
      final router = Get.find<GoRouter>();
      router.go('/wallet');
    }
  }
}

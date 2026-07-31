import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:assignment_4/main.dart';
import 'package:assignment_4/data/repositories/pass_repository.dart';
import 'package:assignment_4/core/storage/secure_storage_service.dart';
import 'package:assignment_4/core/network/dio_client.dart';
import 'package:assignment_4/services/deep_link_service.dart';
import 'package:assignment_4/services/token_service.dart';
import 'package:assignment_4/routing/app_router.dart';

void main() {
  testWidgets('OmniPass App boots to Splash screen', (WidgetTester tester) async {
    // Bind services in GetX DI for testing scope
    Get.put(PassRepository());
    Get.put(SecureStorageService());
    Get.put(DioClient());
    Get.put(TokenService());
    Get.put(DeepLinkService());
    Get.put<GoRouter>(appRouter);

    // Build our app and trigger a frame.
    await tester.pumpWidget(const OmniPassApp());

    // Verify that our Splash Screen text is displayed.
    expect(find.text('OMNIPASS'), findsOneWidget);
  });
}

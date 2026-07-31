import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'core/network/dio_client.dart';
import 'core/storage/secure_storage_service.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/pass_repository.dart';
import 'routing/app_router.dart';
import 'services/deep_link_service.dart';
import 'services/token_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Register Core Data Layers and Repositories in GetX dependency injection
  Get.put(PassRepository());
  Get.put(SecureStorageService());
  Get.put(DioClient());
  
  Get.put(TokenService());
  Get.put(DeepLinkService());
  
  // Register global GoRouter config
  Get.put<GoRouter>(appRouter);

  runApp(const OmniPassApp());
}

class OmniPassApp extends StatelessWidget {
  const OmniPassApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = Get.find<GoRouter>();

    return MaterialApp.router(
      title: 'OmniPass Secure Wallet',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}

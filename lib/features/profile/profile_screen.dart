import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../services/deep_link_service.dart';
import '../../services/token_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deepLinkService = Get.find<DeepLinkService>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile & Settings"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.go('/wallet'),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            children: [
              // User header
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        gradient: AppColors.purpleGradient,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.12),
                          width: 2,
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "AR",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Alex Rivera",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      "Beta Tester | VIP Passholder",
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // User stats
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.08),
                    width: 1,
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatColumn(title: "Passes", value: "45"),
                    _StatColumn(title: "Active Keys", value: "32"),
                    _StatColumn(title: "Security Tier", value: "Level 4"),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Settings Header
              Text(
                "PREFERENCES",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.5),
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              _buildSettingTile(Icons.nfc_rounded, "NFC Express Mode", true),
              _buildSettingTile(Icons.fingerprint_rounded, "Biometric Verification", true),
              _buildSettingTile(
                Icons.notifications_active_outlined,
                "Pass Push Alerts",
                false,
              ),
              const SizedBox(height: 28),

              // Simulation Console Header
              Text(
                "DEEP LINK SIMULATOR (PHASE 1 TESTING)",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.5),
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      "Simulate launching app from these URL tokens:",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSimulationButton(
                      context,
                      "Concert Pass (Valid Events URL)",
                      () {
                        final token = Get.find<TokenService>().createSignedToken(
                          passId: "pass_concert_1",
                          validity: const Duration(minutes: 15),
                          nonce: "nonce_concert_${DateTime.now().millisecondsSinceEpoch}",
                        );
                        deepLinkService.simulateDeepLink(token);
                      },
                      AppColors.primary,
                    ),
                    _buildSimulationButton(
                      context,
                      "VIP Access Key (Valid Lounge URL)",
                      () {
                        final token = Get.find<TokenService>().createSignedToken(
                          passId: "pass_vip_1",
                          validity: const Duration(minutes: 15),
                          nonce: "nonce_vip_${DateTime.now().millisecondsSinceEpoch}",
                        );
                        deepLinkService.simulateDeepLink(token);
                      },
                      AppColors.accentCyan,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(color: Colors.white10),
                    ),
                    _buildSimulationButton(
                      context,
                      "Expired Pass Link",
                      () {
                        final token = Get.find<TokenService>().createSignedToken(
                          passId: "pass_concert_1",
                          validity: const Duration(minutes: -5),
                          nonce: "nonce_expired_${DateTime.now().millisecondsSinceEpoch}",
                        );
                        deepLinkService.simulateDeepLink(token);
                      },
                      AppColors.error,
                    ),
                    _buildSimulationButton(
                      context,
                      "Invalid Pass Link",
                      () {
                        final token = Get.find<TokenService>().createSignedToken(
                          passId: "pass_not_found",
                          validity: const Duration(minutes: 15),
                          nonce: "nonce_invalid_${DateTime.now().millisecondsSinceEpoch}",
                        );
                        deepLinkService.simulateDeepLink(token);
                      },
                      AppColors.error,
                    ),
                    _buildSimulationButton(
                      context,
                      "Redeemed Pass Link",
                      () {
                        final token = Get.find<TokenService>().createSignedToken(
                          passId: "pass_concert_1",
                          validity: const Duration(minutes: 15),
                          nonce: "nonce_redeemed",
                        );
                        deepLinkService.simulateDeepLink(token);
                      },
                      AppColors.error,
                    ),
                    _buildSimulationButton(
                      context,
                      "Tampered / Invalid Signature",
                      () {
                        final tokenService = Get.find<TokenService>();
                        final validToken = tokenService.createSignedToken(
                          passId: "pass_concert_1",
                          validity: const Duration(minutes: 15),
                          nonce: "nonce_tampered_${DateTime.now().millisecondsSinceEpoch}",
                        );
                        // Corrupt the signature payload at the end of the base64url string
                        final tamperedToken = validToken.substring(0, validToken.length - 8) + "12345678";
                        deepLinkService.simulateDeepLink(tamperedToken);
                      },
                      AppColors.error,
                    ),
                    _buildSimulationButton(
                      context,
                      "Revoked Pass Link",
                      () {
                        final token = Get.find<TokenService>().createSignedToken(
                          passId: "pass_concert_1",
                          validity: const Duration(minutes: 15),
                          nonce: "nonce_revoked",
                        );
                        deepLinkService.simulateDeepLink(token);
                      },
                      AppColors.error,
                    ),
                    _buildSimulationButton(
                      context,
                      "Malformed URL Link",
                      () {
                        deepLinkService.simulateDeepLink("malformed_url_non_base64_payload!");
                      },
                      AppColors.error,
                    ),
                    _buildSimulationButton(
                      context,
                      "Server Connection Error",
                      () {
                        final token = Get.find<TokenService>().createSignedToken(
                          passId: "pass_concert_1",
                          validity: const Duration(minutes: 15),
                          nonce: "nonce_network_error",
                        );
                        deepLinkService.simulateDeepLink(token);
                      },
                      AppColors.error,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTile(IconData icon, String title, bool initialValue) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.04),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.textSecondary),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Switch(
            value: initialValue,
            onChanged: (val) {},
            activeColor: AppColors.accentCyan,
            activeTrackColor: AppColors.accentCyan.withOpacity(0.2),
            inactiveThumbColor: AppColors.textMuted,
            inactiveTrackColor: Colors.white10,
          ),
        ],
      ),
    );
  }

  Widget _buildSimulationButton(
    BuildContext context,
    String label,
    VoidCallback onTap,
    Color accentColor,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      height: 48,
      child: ElevatedButton(
        onPressed: () {
          // Go to root splash waiting state
          context.go('/');
          // Trigger the simulation callback
          onTap();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.cardBgLighter,
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: accentColor.withOpacity(0.2),
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            Icon(
              Icons.bolt_rounded,
              color: accentColor,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String title;
  final String value;

  const _StatColumn({
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../services/deep_link_service.dart';

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
                      "pass_concert_1",
                      deepLinkService,
                      AppColors.primary,
                    ),
                    _buildSimulationButton(
                      context,
                      "VIP Access Key (Valid Lounge URL)",
                      "pass_vip_1",
                      deepLinkService,
                      AppColors.accentCyan,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Divider(color: Colors.white10),
                    ),
                    _buildSimulationButton(
                      context,
                      "Expired Pass Link",
                      "error_expired",
                      deepLinkService,
                      AppColors.error,
                    ),
                    _buildSimulationButton(
                      context,
                      "Invalid Pass Link",
                      "error_invalid",
                      deepLinkService,
                      AppColors.error,
                    ),
                    _buildSimulationButton(
                      context,
                      "Redeemed Pass Link",
                      "error_redeemed",
                      deepLinkService,
                      AppColors.error,
                    ),
                    _buildSimulationButton(
                      context,
                      "Malformed URL Link",
                      "error_malformed",
                      deepLinkService,
                      AppColors.error,
                    ),
                    _buildSimulationButton(
                      context,
                      "Server Connection Error",
                      "error_network",
                      deepLinkService,
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
    String token,
    DeepLinkService service,
    Color accentColor,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      height: 48,
      child: ElevatedButton(
        onPressed: () {
          // Go to root splash waiting state
          context.go('/');
          // Trigger the simulation
          service.simulateDeepLink(token);
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

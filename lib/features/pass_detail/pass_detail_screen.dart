import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'pass_detail_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/components/mesh_background.dart';
import '../../core/components/ticket_painter.dart';
import '../../data/models/pass_model.dart';

class PassDetailScreen extends StatelessWidget {
  final String categoryId;
  final String passId;

  const PassDetailScreen({
    super.key,
    required this.categoryId,
    required this.passId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      PassDetailController(passId: passId),
      tag: passId,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("PASS DETAILS"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.go('/wallet/category/$categoryId'),
        ),
      ),
      body: MeshGradientBackground(
        child: SafeArea(
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              );
            }

            final pass = controller.pass.value;
            if (pass == null) {
              return Center(
                child: Text(
                  "Pass not found.",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              );
            }

            final isInactive = pass.status != PassStatus.active;

            LinearGradient ticketGradient;
            Color accentColor;
            IconData icon;
            bool enableHolo = false;

            switch (pass.category) {
              case PassCategoryType.event:
                ticketGradient = AppColors.purpleGradient;
                accentColor = AppColors.primaryLight;
                icon = Icons.local_activity_rounded;
                break;
              case PassCategoryType.access:
                ticketGradient = AppColors.cyanGradient;
                accentColor = AppColors.accentCyan;
                icon = Icons.key_rounded;
                break;
              case PassCategoryType.credential:
                ticketGradient = AppColors.goldGradient;
                accentColor = AppColors.accentGold;
                icon = Icons.verified_user_rounded;
                enableHolo = true;
                break;
            }

            if (isInactive) {
              ticketGradient = AppColors.darkGradient;
              accentColor = AppColors.textSecondary;
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          // Physical Ticket Container using Custom Painter
                          TicketContainer(
                            gradient: ticketGradient,
                            borderColor: accentColor.withOpacity(0.5),
                            punchPosition: 0.70,
                            punchRadius: 14.0,
                            isVoided: isInactive,
                            voidText: pass.status.toString().split('.').last,
                            enableHoloShimmer: enableHolo && !isInactive,
                            shadows: [
                              BoxShadow(
                                color: isInactive
                                    ? Colors.black.withOpacity(0.35)
                                    : accentColor.withOpacity(0.15),
                                blurRadius: 30,
                                offset: const Offset(0, 12),
                              ),
                            ],
                            child: SizedBox(
                              height: 480,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Logo and category header
                                  Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(icon, color: Colors.white70, size: 16),
                                            const SizedBox(width: 8),
                                            Text(
                                              "OMNIPASS",
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w900,
                                                color: Colors.white.withOpacity(0.85),
                                                letterSpacing: 2.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(0.12),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            pass.categoryId.toUpperCase(),
                                            style: const TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.w900,
                                              color: Colors.white,
                                              letterSpacing: 0.8,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Main Fields (Top Section above punch notches)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          pass.title,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                            height: 1.2,
                                            letterSpacing: -0.6,
                                          ),
                                        ),
                                        const SizedBox(height: 24),
                                        _buildTicketRow(
                                          "LOCATION",
                                          pass.venue,
                                          "GATE",
                                          pass.gate ?? "GENERAL",
                                        ),
                                        const SizedBox(height: 18),
                                        _buildTicketRow(
                                          "VALID DATE",
                                          pass.date,
                                          "START TIME",
                                          pass.time,
                                        ),
                                        const SizedBox(height: 18),
                                        _buildTicketRow(
                                          "OWNER/HOLDER",
                                          pass.ownerName,
                                          "ASSIGNED SEAT",
                                          pass.seat ?? "G.A. ENTRY",
                                        ),
                                      ],
                                    ),
                                  ),

                                  const Spacer(),
                                  // Empty area where punch notches and dashes reside (punchPosition = 0.70)
                                  const SizedBox(height: 28),
                                  const Spacer(),

                                  // Ticket Footing (Bottom Section below notches)
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "SECURITY STATUS",
                                              style: TextStyle(
                                                fontSize: 8,
                                                fontWeight: FontWeight.w900,
                                                color: Colors.white.withOpacity(0.55),
                                                letterSpacing: 0.8,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              pass.status.toString().split('.').last.toUpperCase(),
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w900,
                                                color: pass.status == PassStatus.active
                                                    ? AppColors.accentCyan
                                                    : (pass.status == PassStatus.expired
                                                        ? AppColors.error
                                                        : AppColors.textSecondary),
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              "PASS LEVEL",
                                              style: TextStyle(
                                                fontSize: 8,
                                                fontWeight: FontWeight.w900,
                                                color: Colors.white.withOpacity(0.55),
                                                letterSpacing: 0.8,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              pass.price ?? "COMPLIMENTARY",
                                              style: const TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w900,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 8),

                          // NFC wave visualizer if active
                          if (!isInactive)
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 16),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                              decoration: BoxDecoration(
                                color: AppColors.cardBg.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.06),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  _NfcWaveVisualizer(color: accentColor),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "EXPRESS TRANSMISSION DETECTED",
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w900,
                                            color: AppColors.accentCyan,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Hold top of phone near terminal scanner",
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white.withOpacity(0.6),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(Icons.contactless_rounded, color: accentColor, size: 24),
                                ],
                              ),
                            )
                          else
                            const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // CTA Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: (isInactive || controller.isExchanging.value)
                          ? null
                          : () => controller.requestAndOpenSecurePass(
                                categoryId,
                                passId,
                              ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: AppColors.disabled.withOpacity(0.3),
                        disabledForegroundColor: AppColors.textMuted,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: controller.isExchanging.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  isInactive
                                      ? Icons.lock_outline_rounded
                                      : Icons.qr_code_scanner_rounded,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  isInactive ? "PASS INACTIVE" : "GENERATE SECURE SCAN KEY",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildTicketRow(
    String titleLeft,
    String valueLeft,
    String titleRight,
    String valueRight,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                titleLeft,
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                  color: Colors.white.withOpacity(0.5),
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                valueLeft,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                titleRight,
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                  color: Colors.white.withOpacity(0.5),
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                valueRight,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Circular pulsing ripples representation of contactless NFC
class _NfcWaveVisualizer extends StatefulWidget {
  final Color color;
  const _NfcWaveVisualizer({required this.color});

  @override
  State<_NfcWaveVisualizer> createState() => _NfcWaveVisualizerState();
}

class _NfcWaveVisualizerState extends State<_NfcWaveVisualizer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: List.generate(3, (index) {
              final progress = (_controller.value + index / 3.0) % 1.0;
              return Container(
                width: 14 + progress * 30,
                height: 14 + progress * 30,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.color.withOpacity((1.0 - progress) * 0.5),
                    width: 1.5,
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

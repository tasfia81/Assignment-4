import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'secure_ticket_controller.dart';
import '../../core/theme/app_colors.dart';

class SecureTicketScreen extends StatelessWidget {
  final String categoryId;
  final String passId;

  const SecureTicketScreen({
    super.key,
    required this.categoryId,
    required this.passId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      SecureTicketController(passId: passId),
      tag: passId,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Secure Access Pass"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.go('/wallet/category/$categoryId/pass/$passId'),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
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

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                children: [
                  Text(
                    pass.title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pass.venue,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // High security banner
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.success.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _BlinkingDot(),
                        SizedBox(width: 8),
                        Text(
                          "DYNAMIC PASS ACTIVE",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: AppColors.success,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const Spacer(),

                  // QR code container
                  Center(
                    child: Container(
                      width: 260,
                      height: 260,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.2),
                            blurRadius: 32,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: const _ScanningQrCode(),
                    ),
                  ),
                  
                  const Spacer(),

                  // Token Display & Timer
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "DYNAMIC PASS TOKEN",
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white.withOpacity(0.5),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                controller.dynamicOtp.value,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'monospace',
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 48,
                              height: 48,
                              child: CircularProgressIndicator(
                                value: controller.secondsRemaining.value / 30,
                                strokeWidth: 4,
                                backgroundColor: Colors.white.withOpacity(0.05),
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.accentCyan,
                                ),
                              ),
                            ),
                            Text(
                              "${controller.secondsRemaining.value}",
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                  const Spacer(),

                  // Security disclaimer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.security_rounded,
                        size: 16,
                        color: Colors.white.withOpacity(0.4),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Pass rotates periodically. Screenshots are invalid.",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withOpacity(0.4),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _BlinkingDot extends StatefulWidget {
  const _BlinkingDot();

  @override
  State<_BlinkingDot> createState() => _BlinkingDotState();
}

class _BlinkingDotState extends State<_BlinkingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: Container(
        width: 8,
        height: 8,
        decoration: const BoxDecoration(
          color: AppColors.success,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _ScanningQrCode extends StatefulWidget {
  const _ScanningQrCode();

  @override
  State<_ScanningQrCode> createState() => _ScanningQrCodeState();
}

class _ScanningQrCodeState extends State<_ScanningQrCode>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Opacity(
            opacity: 0.95,
            child: _buildQrMatrix(),
          ),
        ),
        AnimatedBuilder(
          animation: _animationController,
          builder: (context, child) {
            final yOffset = _animationController.value * 224; // Limit height matching Qr block
            return Positioned(
              top: yOffset,
              left: 0,
              right: 0,
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.8),
                      blurRadius: 10,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildQrMatrix() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 21,
        crossAxisSpacing: 1.5,
        mainAxisSpacing: 1.5,
      ),
      itemCount: 21 * 21,
      itemBuilder: (context, index) {
        final row = index ~/ 21;
        final col = index % 21;

        final isFinderPattern = (row < 7 && col < 7) ||
            (row < 7 && col >= 14) ||
            (row >= 14 && col < 7);

        if (isFinderPattern) {
          final insideBorder = (row == 0 || row == 6 || col == 0 || col == 6) ||
              (row == 0 && col >= 14) ||
              (row == 6 && col >= 14) ||
              (col == 14 && row < 7) ||
              (col == 20 && row < 7) ||
              (row == 14 && col < 7) ||
              (row == 20 && col < 7) ||
              (col == 0 && row >= 14) ||
              (col == 6 && row >= 14) ||
              (row >= 2 && row <= 4 && col >= 2 && col <= 4) ||
              (row >= 2 && row <= 4 && col >= 16 && col <= 18) ||
              (row >= 16 && row <= 18 && col >= 2 && col <= 4);

          return Container(
            color: insideBorder ? Colors.black87 : Colors.transparent,
          );
        }

        final pixelState =
            (index * 7 + index * 13) % 5 == 0 || (index * 3) % 7 == 0;
        return Container(
          color: pixelState ? Colors.black87 : Colors.transparent,
        );
      },
    );
  }
}

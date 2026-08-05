import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'secure_ticket_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../core/components/mesh_background.dart';

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
        title: const Text("SECURE ACCESS KEY"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.go('/wallet/category/$categoryId/pass/$passId'),
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

            final isLowTime = controller.secondsRemaining.value < 8;
            final timerColor = isLowTime ? AppColors.error : AppColors.accentCyan;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                children: [
                  Text(
                    pass.title.toUpperCase(),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    pass.venue,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.55),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // High security banner
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.success.withOpacity(0.25),
                        width: 1.2,
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _BlinkingDot(),
                        SizedBox(width: 8),
                        Text(
                          "DYNAMIC LEDGER KEY ACTIVE",
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            color: AppColors.success,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const Spacer(),

                  // QR code container with Cyber Scanner Brackets
                  Center(
                    child: Container(
                      width: 276,
                      height: 276,
                      padding: const EdgeInsets.all(8), // Spacer to set brackets outside QR card
                      child: CustomPaint(
                        foregroundPainter: CyberScannerPainter(
                          color: timerColor,
                          bracketLength: 22.0,
                          strokeWidth: 3.5,
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: timerColor.withOpacity(0.18),
                                blurRadius: 32,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const _ScanningQrCode(),
                        ),
                      ),
                    ),
                  ),
                  
                  const Spacer(),

                  // Token Display & Timer
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.06),
                        width: 1.2,
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
                                  fontSize: 8,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white.withOpacity(0.55),
                                  letterSpacing: 0.8,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                controller.dynamicOtp.value,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: 'monospace',
                                  color: Colors.white,
                                  letterSpacing: 1.5,
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
                                backgroundColor: Colors.white.withOpacity(0.04),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  timerColor,
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
                        Icons.verified_user_rounded,
                        size: 15,
                        color: Colors.white.withOpacity(0.35),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Code auto-rotates. Screenshots are invalid.",
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white.withOpacity(0.35),
                          fontWeight: FontWeight.bold,
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

// Neon cyber-brackets custom painter for QR container
class CyberScannerPainter extends CustomPainter {
  final Color color;
  final double bracketLength;
  final double strokeWidth;

  CyberScannerPainter({
    required this.color,
    required this.bracketLength,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;
    final l = bracketLength;

    // Top-Left corner bracket
    canvas.drawLine(const Offset(0, 0), Offset(l, 0), paint);
    canvas.drawLine(const Offset(0, 0), Offset(0, l), paint);

    // Top-Right corner bracket
    canvas.drawLine(Offset(w, 0), Offset(w - l, 0), paint);
    canvas.drawLine(Offset(w, 0), Offset(w, l), paint);

    // Bottom-Left corner bracket
    canvas.drawLine(Offset(0, h), Offset(l, h), paint);
    canvas.drawLine(Offset(0, h), Offset(0, h - l), paint);

    // Bottom-Right corner bracket
    canvas.drawLine(Offset(w, h), Offset(w - l, h), paint);
    canvas.drawLine(Offset(w, h), Offset(w, h - l), paint);
  }

  @override
  bool shouldRepaint(covariant CyberScannerPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.bracketLength != bracketLength ||
        oldDelegate.strokeWidth != strokeWidth;
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
                height: 3,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Colors.transparent,
                      AppColors.accentCyan,
                      Colors.white,
                      AppColors.accentCyan,
                      Colors.transparent,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accentCyan.withOpacity(0.6),
                      blurRadius: 8,
                      spreadRadius: 1,
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
            color: Colors.black87,
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

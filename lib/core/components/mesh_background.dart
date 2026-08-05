import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class MeshGradientBackground extends StatefulWidget {
  final Widget child;

  const MeshGradientBackground({
    super.key,
    required this.child,
  });

  @override
  State<MeshGradientBackground> createState() => _MeshGradientBackgroundState();
}

class _MeshGradientBackgroundState extends State<MeshGradientBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Dark solid backdrop
        Container(
          color: AppColors.backgroundDb,
        ),

        // Glowing animated mesh blobs
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final t = _controller.value * 2 * math.pi;

            // Compute floating coordinates for Blob 1 (Purple)
            final blob1x = size.width * (0.3 + 0.2 * math.cos(t));
            final blob1y = size.height * (0.2 + 0.15 * math.sin(t));

            // Compute coordinates for Blob 2 (Cyan)
            final blob2x = size.width * (0.7 + 0.18 * math.sin(t));
            final blob2y = size.height * (0.65 + 0.12 * math.cos(t));

            // Compute coordinates for Blob 3 (Pink)
            final blob3x = size.width * (0.45 + 0.15 * math.sin(t + math.pi / 2));
            final blob3y = size.height * (0.45 + 0.15 * math.cos(t - math.pi / 4));

            return Stack(
              children: [
                // Purple Blob
                Positioned(
                  left: blob1x - 170,
                  top: blob1y - 170,
                  child: Container(
                    width: 340,
                    height: 340,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.meshBlob1,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // Cyan Blob
                Positioned(
                  left: blob2x - 190,
                  top: blob2y - 190,
                  child: Container(
                    width: 380,
                    height: 380,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.meshBlob2,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // Pink Blob
                Positioned(
                  left: blob3x - 150,
                  top: blob3y - 150,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.meshBlob3,
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),

        // Backdrop Filter to blend everything seamlessly
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),

        // Main app content
        Positioned.fill(child: widget.child),
      ],
    );
  }
}

import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class TicketPainter extends CustomPainter {
  final Gradient gradient;
  final Color borderColor;
  final double punchRadius;
  final double punchPosition;
  final double borderWidth;
  final double? holoShimmerProgress;

  TicketPainter({
    required this.gradient,
    required this.borderColor,
    this.punchRadius = 14.0,
    this.punchPosition = 0.70,
    this.borderWidth = 1.2,
    this.holoShimmerProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final punchY = h * punchPosition;
    final r = punchRadius;
    const cornerRadius = 24.0;

    // Create ticket path with rounded corners and side notches
    final path = Path();
    path.moveTo(cornerRadius, 0);
    path.lineTo(w - cornerRadius, 0);
    path.quadraticBezierTo(w, 0, w, cornerRadius);
    path.lineTo(w, punchY - r);
    
    // Right notch cutout (semi-circle curving inward)
    path.arcToPoint(
      Offset(w, punchY + r),
      radius: Radius.circular(r),
      clockwise: false,
    );
    
    path.lineTo(w, h - cornerRadius);
    path.quadraticBezierTo(w, h, w - cornerRadius, h);
    path.lineTo(cornerRadius, h);
    path.quadraticBezierTo(0, h, 0, h - cornerRadius);
    path.lineTo(0, punchY + r);
    
    // Left notch cutout (semi-circle curving inward)
    path.arcToPoint(
      Offset(0, punchY - r),
      radius: Radius.circular(r),
      clockwise: false,
    );
    
    path.lineTo(0, cornerRadius);
    path.quadraticBezierTo(0, 0, cornerRadius, 0);
    path.close();

    // 1. Draw solid background with linear gradient
    final paint = Paint()
      ..shader = gradient.createShader(Offset.zero & size)
      ..style = PaintingStyle.fill;
    canvas.drawPath(path, paint);

    // 2. Holographic foil overlay if enabled
    if (holoShimmerProgress != null && holoShimmerProgress! > 0) {
      final holoPaint = Paint()
        ..shader = LinearGradient(
          colors: AppColors.holoColors,
          begin: Alignment(-2.0 + holoShimmerProgress! * 4.0, -1.5),
          end: Alignment(-0.5 + holoShimmerProgress! * 4.0, 1.5),
          tileMode: TileMode.clamp,
        ).createShader(Offset.zero & size)
        ..style = PaintingStyle.fill
        ..blendMode = BlendMode.colorDodge;
      canvas.drawPath(path, holoPaint);
    }

    // 3. Draw gradient border (makes it feel premium)
    final borderPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          borderColor,
          borderColor.withOpacity(0.3),
          borderColor,
          borderColor.withOpacity(0.1),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Offset.zero & size)
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    canvas.drawPath(path, borderPaint);

    // 4. Draw perforation dashed separator line
    final dashPaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    double startX = r + 8.0;
    final endX = w - r - 8.0;
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    
    while (startX < endX) {
      canvas.drawLine(
        Offset(startX, punchY),
        Offset(startX + dashWidth, punchY),
        dashPaint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant TicketPainter oldDelegate) {
    return oldDelegate.gradient != gradient ||
        oldDelegate.borderColor != borderColor ||
        oldDelegate.punchRadius != punchRadius ||
        oldDelegate.punchPosition != punchPosition ||
        oldDelegate.holoShimmerProgress != holoShimmerProgress;
  }
}

class TicketContainer extends StatefulWidget {
  final Widget child;
  final Gradient gradient;
  final Color borderColor;
  final double punchRadius;
  final double punchPosition;
  final List<BoxShadow>? shadows;
  final bool isVoided;
  final String voidText;
  final bool enableHoloShimmer;

  const TicketContainer({
    super.key,
    required this.child,
    required this.gradient,
    required this.borderColor,
    this.punchRadius = 14.0,
    this.punchPosition = 0.70,
    this.shadows,
    this.isVoided = false,
    this.voidText = "EXPIRED",
    this.enableHoloShimmer = false,
  });

  @override
  State<TicketContainer> createState() => _TicketContainerState();
}

class _TicketContainerState extends State<TicketContainer>
    with SingleTickerProviderStateMixin {
  AnimationController? _holoController;

  @override
  void initState() {
    super.initState();
    if (widget.enableHoloShimmer) {
      _holoController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 4),
      )..repeat();
    }
  }

  @override
  void didUpdateWidget(covariant TicketContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enableHoloShimmer && _holoController == null) {
      _holoController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 4),
      )..repeat();
    } else if (!widget.enableHoloShimmer && _holoController != null) {
      _holoController!.dispose();
      _holoController = null;
    }
  }

  @override
  void dispose() {
    _holoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget ticketBody = CustomPaint(
      painter: TicketPainter(
        gradient: widget.gradient,
        borderColor: widget.borderColor,
        punchRadius: widget.punchRadius,
        punchPosition: widget.punchPosition,
        holoShimmerProgress: _holoController != null ? _holoController!.value : null,
      ),
      child: widget.child,
    );

    // Apply animation builder for holographic shimmering overlay if enabled
    if (_holoController != null) {
      ticketBody = AnimatedBuilder(
        animation: _holoController!,
        builder: (context, child) => CustomPaint(
          painter: TicketPainter(
            gradient: widget.gradient,
            borderColor: widget.borderColor,
            punchRadius: widget.punchRadius,
            punchPosition: widget.punchPosition,
            holoShimmerProgress: _holoController!.value,
          ),
          child: widget.child,
        ),
      );
    }

    // If card is voided/expired, overlay a high-fidelity tilted stamp on it
    if (widget.isVoided) {
      ticketBody = Stack(
        children: [
          ticketBody,
          // Transparent dark overlay
          Positioned.fill(
            child: ClipPath(
              clipper: _TicketOutlineClipper(
                punchRadius: widget.punchRadius,
                punchPosition: widget.punchPosition,
              ),
              child: Container(
                color: Colors.black.withOpacity(0.25),
              ),
            ),
          ),
          // Void stamp
          Positioned.fill(
            child: Center(
              child: Transform.rotate(
                angle: -0.22, // Tilted stamp
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.error.withOpacity(0.85),
                      width: 4,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.transparent,
                  ),
                  child: Text(
                    widget.voidText.toUpperCase(),
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      color: AppColors.error.withOpacity(0.85),
                      letterSpacing: 6.0,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.5),
                          offset: const Offset(0, 4),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Apply custom container wrapping with shadow and clip bounds matching the ticket
    return Container(
      decoration: BoxDecoration(
        boxShadow: widget.shadows,
        borderRadius: BorderRadius.circular(24),
      ),
      child: ClipPath(
        clipper: _TicketOutlineClipper(
          punchRadius: widget.punchRadius,
          punchPosition: widget.punchPosition,
        ),
        child: ticketBody,
      ),
    );
  }
}

// Clip path representing the exact boundary shape of the ticket
class _TicketOutlineClipper extends CustomClipper<Path> {
  final double punchRadius;
  final double punchPosition;

  _TicketOutlineClipper({
    required this.punchRadius,
    required this.punchPosition,
  });

  @override
  Path getClip(Size size) {
    final w = size.width;
    final h = size.height;
    final punchY = h * punchPosition;
    final r = punchRadius;
    const cornerRadius = 24.0;

    final path = Path();
    path.moveTo(cornerRadius, 0);
    path.lineTo(w - cornerRadius, 0);
    path.quadraticBezierTo(w, 0, w, cornerRadius);
    path.lineTo(w, punchY - r);
    path.arcToPoint(
      Offset(w, punchY + r),
      radius: Radius.circular(r),
      clockwise: false,
    );
    path.lineTo(w, h - cornerRadius);
    path.quadraticBezierTo(w, h, w - cornerRadius, h);
    path.lineTo(cornerRadius, h);
    path.quadraticBezierTo(0, h, 0, h - cornerRadius);
    path.lineTo(0, punchY + r);
    path.arcToPoint(
      Offset(0, punchY - r),
      radius: Radius.circular(r),
      clockwise: false,
    );
    path.lineTo(0, cornerRadius);
    path.quadraticBezierTo(0, 0, cornerRadius, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant _TicketOutlineClipper oldClipper) {
    return oldClipper.punchRadius != punchRadius || oldClipper.punchPosition != punchPosition;
  }
}

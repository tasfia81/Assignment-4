import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/components/ticket_painter.dart';
import '../../../../data/models/pass_model.dart';

class PassCard extends StatelessWidget {
  final PassModel pass;
  final VoidCallback onTap;

  const PassCard({
    super.key,
    required this.pass,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Select styling attributes based on category
    LinearGradient gradient;
    Color accentColor;
    IconData icon;
    bool enableHolo = false;

    switch (pass.category) {
      case PassCategoryType.event:
        gradient = AppColors.purpleGradient;
        accentColor = AppColors.primaryLight;
        icon = Icons.confirmation_number_outlined;
        break;
      case PassCategoryType.access:
        gradient = AppColors.cyanGradient;
        accentColor = AppColors.accentCyan;
        icon = Icons.vpn_key_outlined;
        break;
      case PassCategoryType.credential:
        gradient = AppColors.goldGradient;
        accentColor = AppColors.accentGold;
        icon = Icons.badge_outlined;
        enableHolo = true; // Gold credentials get premium holographic foil
        break;
    }

    final isExpired = pass.status == PassStatus.expired;
    final isRedeemed = pass.status == PassStatus.redeemed;
    final isInactive = isExpired || isRedeemed;

    if (isInactive) {
      gradient = AppColors.darkGradient;
      accentColor = AppColors.textSecondary;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: TicketContainer(
          gradient: gradient,
          borderColor: accentColor.withOpacity(0.5),
          isVoided: isInactive,
          voidText: isExpired ? 'EXPIRED' : 'REDEEMED',
          enableHoloShimmer: enableHolo && !isInactive,
          punchPosition: 0.68,
          punchRadius: 12.0,
          shadows: [
            BoxShadow(
              color: isInactive
                  ? Colors.black.withOpacity(0.35)
                  : accentColor.withOpacity(0.18),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top header: Badge and Status indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(icon, size: 13, color: Colors.white),
                          const SizedBox(width: 6),
                          Text(
                            pass.category.toString().split('.').last.toUpperCase(),
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isInactive)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.nfc_rounded,
                            color: Colors.white.withOpacity(0.8),
                            size: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "EXPRESS MODE",
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w900,
                              color: Colors.white.withOpacity(0.7),
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Title
                Text(
                  pass.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: -0.5,
                    height: 1.2,
                  ),
                ),
                
                // Flexible spacer to separate top content from perforated bottom info
                const SizedBox(height: 38),
                
                // Bottom stub section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "LOCATION",
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.w900,
                              color: Colors.white.withOpacity(0.5),
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            pass.venue,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "VALID DATE",
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.w900,
                            color: Colors.white.withOpacity(0.5),
                            letterSpacing: 0.8,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          pass.date,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

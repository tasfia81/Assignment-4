import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
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
    // Select gradient based on category
    LinearGradient gradient;
    IconData icon;
    switch (pass.category) {
      case PassCategoryType.event:
        gradient = AppColors.purpleGradient;
        icon = Icons.confirmation_number_outlined;
        break;
      case PassCategoryType.access:
        gradient = AppColors.cyanGradient;
        icon = Icons.vpn_key_outlined;
        break;
      case PassCategoryType.credential:
        gradient = AppColors.goldGradient;
        icon = Icons.badge_outlined;
        break;
    }

    final isExpired = pass.status == PassStatus.expired;
    final isRedeemed = pass.status == PassStatus.redeemed;
    final isInactive = isExpired || isRedeemed;

    if (isInactive) {
      gradient = AppColors.darkGradient;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withOpacity(0.08),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isInactive
                  ? Colors.black.withOpacity(0.4)
                  : (pass.category == PassCategoryType.event
                      ? AppColors.primary.withOpacity(0.25)
                      : (pass.category == PassCategoryType.access
                          ? AppColors.accentCyan.withOpacity(0.2)
                          : AppColors.accentGold.withOpacity(0.2))),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section: Tag and Status/NFC icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 14, color: Colors.white),
                      const SizedBox(width: 6),
                      Text(
                        pass.category.toString().split('.').last.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isInactive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isExpired
                          ? AppColors.error.withOpacity(0.15)
                          : Colors.white.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isExpired
                            ? AppColors.error.withOpacity(0.5)
                            : AppColors.textSecondary.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      isExpired ? 'EXPIRED' : 'REDEEMED',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isExpired ? AppColors.error : AppColors.textSecondary,
                        letterSpacing: 0.5,
                      ),
                    ),
                  )
                else
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.nfc_rounded,
                        color: Colors.white.withOpacity(0.9),
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "TAP",
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: Colors.white.withOpacity(0.7),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 28),
            // Title
            Text(
              pass.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.6,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 20),
            // Venue / Date Info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "VENUE",
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: Colors.white.withOpacity(0.6),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        pass.venue,
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "DATE & TIME",
                      style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: Colors.white.withOpacity(0.6),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${pass.date} | ${pass.time}",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
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
    );
  }
}

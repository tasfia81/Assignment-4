import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'pass_detail_controller.dart';
import '../../core/theme/app_colors.dart';
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
        title: const Text("Pass Details"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.go('/wallet/category/$categoryId'),
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

            final isInactive = pass.status != PassStatus.active;

            LinearGradient ticketGradient;
            switch (pass.category) {
              case PassCategoryType.event:
                ticketGradient = AppColors.purpleGradient;
                break;
              case PassCategoryType.access:
                ticketGradient = AppColors.cyanGradient;
                break;
              case PassCategoryType.credential:
                ticketGradient = AppColors.goldGradient;
                break;
            }

            if (isInactive) {
              ticketGradient = AppColors.darkGradient;
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Ticket shadow backdrop
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            height: 480,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: isInactive
                                      ? Colors.black.withOpacity(0.3)
                                      : (pass.category == PassCategoryType.event
                                          ? AppColors.primary.withOpacity(0.15)
                                          : (pass.category == PassCategoryType.access
                                              ? AppColors.accentCyan.withOpacity(0.1)
                                              : AppColors.accentGold.withOpacity(0.1))),
                                  blurRadius: 30,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                          ),

                          // Physical ticket skeleton
                          Container(
                            height: 480,
                            decoration: BoxDecoration(
                              gradient: ticketGradient,
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.08),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Logo and category header
                                Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "OMNIPASS",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white.withOpacity(0.85),
                                          letterSpacing: 2,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          pass.categoryId.toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Main Fields
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        pass.title,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                          height: 1.15,
                                          letterSpacing: -0.8,
                                        ),
                                      ),
                                      const SizedBox(height: 24),
                                      _buildTicketRow(
                                        "VENUE",
                                        pass.venue,
                                        "GATE",
                                        pass.gate ?? "N/A",
                                      ),
                                      const SizedBox(height: 20),
                                      _buildTicketRow(
                                        "DATE",
                                        pass.date,
                                        "TIME",
                                        pass.time,
                                      ),
                                      const SizedBox(height: 20),
                                      _buildTicketRow(
                                        "CARDHOLDER",
                                        pass.ownerName,
                                        "SEAT",
                                        pass.seat ?? "General Access",
                                      ),
                                    ],
                                  ),
                                ),

                                const Spacer(),

                                // Dotted middle separator with circle cutouts
                                SizedBox(
                                  height: 30,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Row(
                                        children: List.generate(
                                          40,
                                          (index) => Expanded(
                                            child: Container(
                                              color: index % 2 == 0
                                                  ? Colors.transparent
                                                  : Colors.white.withOpacity(0.25),
                                              height: 1.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: -15,
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: const BoxDecoration(
                                            color: AppColors.backgroundDb,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: -15,
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          decoration: const BoxDecoration(
                                            color: AppColors.backgroundDb,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const Spacer(),

                                // Ticket Footing
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "STATUS",
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white.withOpacity(0.6),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            pass.status
                                                .toString()
                                                .split('.')
                                                .last
                                                .toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w900,
                                              color: pass.status == PassStatus.active
                                                  ? AppColors.accentCyan
                                                  : (pass.status == PassStatus.expired
                                                      ? AppColors.error
                                                      : AppColors.textSecondary),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "PRICE / LEVEL",
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white.withOpacity(0.6),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            pass.price ?? "COMPLIMENTARY",
                                            style: const TextStyle(
                                              fontSize: 16,
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
                      onPressed: isInactive
                          ? null
                          : () => context.go(
                                '/wallet/category/$categoryId/pass/$passId/secure',
                              ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: AppColors.disabled.withOpacity(0.3),
                        disabledForegroundColor: AppColors.textMuted,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Row(
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
                            isInactive ? "PASS INACTIVE" : "VIEW SECURE ACCESS KEY",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
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
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.65),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                valueLeft,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
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
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.65),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                valueRight,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
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

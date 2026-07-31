import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'wallet_controller.dart';
import 'widgets/pass_card.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/pass_model.dart';

class WalletHomeScreen extends StatelessWidget {
  const WalletHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WalletController());

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: Obx(() {
            final activePasses = controller.activePasses;
            final allPasses = controller.allPasses;
            final categories = controller.categories;

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 1. App Bar Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "OMNIPASS",
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                letterSpacing: 2,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Digital Secure Wallet",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => context.push('/profile'),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.cardBg,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.08),
                                width: 1,
                              ),
                            ),
                            child: const Icon(
                              Icons.person_outline_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 2. Active Passes (Horizontal Carousel)
                if (activePasses.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Featured Passes (${controller.activeCount})",
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          const Icon(
                            Icons.keyboard_arrow_right,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 204,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemCount: activePasses.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (context, index) {
                          final pass = activePasses[index];
                          return SizedBox(
                            width: MediaQuery.of(context).size.width * 0.86,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              child: PassCard(
                                pass: pass,
                                onTap: () => context.go(
                                  '/wallet/category/${pass.categoryId}/pass/${pass.passId}',
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],

                // 3. Category Quick Links
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 28, 24, 12),
                    child: Text(
                      "Categories",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 112,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: categories.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        
                        IconData icon;
                        Color accentColor;
                        switch (cat.type) {
                          case PassCategoryType.event:
                            icon = Icons.confirmation_number_rounded;
                            accentColor = AppColors.primary;
                            break;
                          case PassCategoryType.access:
                            icon = Icons.vpn_key_rounded;
                            accentColor = AppColors.accentCyan;
                            break;
                          case PassCategoryType.credential:
                            icon = Icons.badge_rounded;
                            accentColor = AppColors.accentGold;
                            break;
                        }

                        return GestureDetector(
                          onTap: () => context.go('/wallet/category/${cat.categoryId}'),
                          child: Container(
                            width: 144,
                            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.cardBg,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.08),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(icon, color: accentColor, size: 28),
                                Text(
                                  cat.name,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // 4. All Passes (Virtualized list view)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 32, 24, 12),
                    child: Text(
                      "All Assets",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final pass = allPasses[index];
                        return PassCard(
                          pass: pass,
                          onTap: () => context.go(
                            '/wallet/category/${pass.categoryId}/pass/${pass.passId}',
                          ),
                        );
                      },
                      childCount: allPasses.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 32),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'category_controller.dart';
import '../wallet/widgets/pass_card.dart';
import '../../core/theme/app_colors.dart';
import '../../core/components/mesh_background.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryId;

  const CategoryScreen({
    super.key,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    // Put controller with tag for clean parametric scoping
    final controller = Get.put(
      CategoryController(categoryId: categoryId),
      tag: categoryId,
    );

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.categoryName.value.toUpperCase())),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.go('/wallet'),
        ),
      ),
      body: MeshGradientBackground(
        child: SafeArea(
          child: Obx(() {
            final passes = controller.categoryPasses;

            if (passes.isEmpty) {
              return Center(
                child: Text(
                  "No passes found in this category.",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              );
            }

            // ListView.builder guarantees viewport scroll virtualization
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: passes.length,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              itemBuilder: (context, index) {
                final pass = passes[index];
                return PassCard(
                  pass: pass,
                  onTap: () => context.go(
                    '/wallet/category/$categoryId/pass/${pass.passId}',
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}

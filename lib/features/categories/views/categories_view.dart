import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_theme.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../data/models/category_model.dart';
import '../../../navigation/main_navigation_controller.dart';
import '../../screenshots/controllers/screenshots_controller.dart';
import '../controllers/categories_controller.dart';

class CategoriesView extends GetView<CategoriesController> {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(title: AppStrings.categories),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (controller.errorMessage.value.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppStrings.somethingWentWrong,
                    style: AppTextTheme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextButton(
                    onPressed: controller.loadCategories,
                    child: Text(AppStrings.tryAgain),
                  ),
                ],
              ),
            );
          }

          if (controller.categories.isEmpty) {
            return Center(
              child: Text(
                AppStrings.noDataFound,
                style: AppTextTheme.textTheme.bodyMedium,
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: controller.categories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.md,
              mainAxisSpacing: AppSpacing.md,
              childAspectRatio: 1.15,
            ),
            itemBuilder: (context, index) {
              final category = controller.categories[index];

              return _CategoryCard(
                category: category,
                count: controller.getCount(category),
                onTap: () => _openCategory(category),
              );
            },
          );
        }),
      ),
    );
  }

  void _openCategory(CategoryModel category) {
    final categoryId = category.id;
    if (categoryId == null) return;

    Get.find<ScreenshotsController>().selectCategoryById(
      categoryId,
      category.name,
    );

    Get.back();

    Get.find<MainNavigationController>().changeTab(1);
  }
}

class _CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final int count;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.category,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: AppColors.border,
              width: AppSizes.borderWidth,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: AppSizes.dashboardIconContainerSize,
                width: AppSizes.dashboardIconContainerSize,
                decoration: BoxDecoration(
                  color: AppColors.surfaceSecondary,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                alignment: Alignment.center,
                child: _buildIcon(category.icon),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextTheme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text('$count', style: AppTextTheme.textTheme.bodyMedium),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(String iconName) {
    final icon = switch (iconName) {
      'link' => PhosphorIconsRegular.link,
      'envelope' => PhosphorIconsRegular.envelope,
      'user' => PhosphorIconsRegular.user,
      'calendar' => PhosphorIconsRegular.calendar,
      'text' => PhosphorIconsRegular.textT,
      'folder' => PhosphorIconsRegular.folder,
      _ => PhosphorIconsRegular.folder,
    };

    return PhosphorIcon(
      icon,
      size: AppSizes.iconLarge,
      color: AppColors.primary,
    );
  }
}

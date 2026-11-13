import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/screenshots_controller.dart';

class ScreenshotFilterBar extends StatelessWidget {
  const ScreenshotFilterBar({super.key, required this.controller});

  final ScreenshotsController controller;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: AppSizes.screenshotsFilterHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: ScreenshotsController.categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final category = ScreenshotsController.categories[index];

          return Obx(() {
            final isSelected = controller.selectedCategory.value == category;

            return ChoiceChip(
              key: controller.categoryKeys[index],
              label: Text(category),
              selected: isSelected,
              onSelected: (_) => controller.selectCategory(category),
              showCheckmark: false,
              labelStyle: textTheme.labelMedium?.copyWith(
                color: isSelected
                    ? AppColors.textOnPrimary
                    : AppColors.textSecondary,
              ),
              backgroundColor: AppColors.surface,
              selectedColor: AppColors.primary,
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.circular),
              ),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            );
          });
        },
      ),
    );
  }
}

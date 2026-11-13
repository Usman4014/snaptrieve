import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/screenshots_controller.dart';

class ScreenshotSortMenu extends StatelessWidget {
  const ScreenshotSortMenu({super.key, required this.controller});

  final ScreenshotsController controller;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Obx(
      () => PopupMenuButton<String>(
        onSelected: controller.changeSortOrder,
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: AppStrings.newestFirst,
            child: Text(AppStrings.newestFirst, style: textTheme.bodyMedium),
          ),
          PopupMenuItem(
            value: AppStrings.oldestFirst,
            child: Text(AppStrings.oldestFirst, style: textTheme.bodyMedium),
          ),
        ],
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const PhosphorIcon(
              PhosphorIconsRegular.arrowsDownUp,
              size: AppSizes.iconMedium,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(controller.sortOrder.value, style: textTheme.labelMedium),
            const SizedBox(width: AppSpacing.xs),
            const PhosphorIcon(
              PhosphorIconsRegular.caretDown,
              size: AppSizes.iconSmall,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

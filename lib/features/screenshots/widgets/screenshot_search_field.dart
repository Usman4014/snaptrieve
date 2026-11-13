import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/screenshots_controller.dart';

class ScreenshotSearchField extends StatelessWidget {
  const ScreenshotSearchField({super.key, required this.controller});

  final ScreenshotsController controller;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox(
      height: AppSizes.screenshotsSearchHeight,
      child: TextField(
        controller: controller.searchController,
        onChanged: controller.updateSearch,
        style: textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: AppStrings.search,
          prefixIcon: const PhosphorIcon(
            PhosphorIconsRegular.magnifyingGlass,
            color: AppColors.textSecondary,
            size: AppSizes.iconMedium,
          ),
          suffixIcon: Obx(
            () => controller.searchQuery.value.isNotEmpty
                ? IconButton(
                    onPressed: controller.clearFilters,
                    icon: const PhosphorIcon(
                      PhosphorIconsRegular.x,
                      size: AppSizes.iconMedium,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }
}

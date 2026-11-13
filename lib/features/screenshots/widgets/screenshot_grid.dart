import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_theme.dart';
import '../../../data/models/screenshot_model.dart';
import 'screenshot_grid_item.dart';

class ScreenshotGrid extends StatelessWidget {
  const ScreenshotGrid({
    super.key,
    required this.screenshots,
    required this.isLoading,
  });

  final List<ScreenshotModel> screenshots;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (screenshots.isEmpty) {
      return _buildEmptyState();
    }

    return GridView.builder(
      padding: const EdgeInsets.only(bottom: AppSizes.dashboardBottomSpacing),
      itemCount: screenshots.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: AppSizes.screenshotGridColumns,
        crossAxisSpacing: AppSizes.screenshotGridItemSpacing,
        mainAxisSpacing: AppSizes.screenshotGridItemSpacing,
        childAspectRatio: AppSizes.screenshotGridImageAspectRatio,
      ),
      itemBuilder: (context, index) {
        return ScreenshotGridItem(screenshot: screenshots[index]);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xxl,
          vertical: AppSpacing.xxxl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: AppSizes.dashboardIconContainerSize * 2,
              width: AppSizes.dashboardIconContainerSize * 2,
              decoration: const BoxDecoration(
                color: AppColors.surfaceSecondary,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Icon(
                PhosphorIconsRegular.images,
                size: AppSizes.screenshotsEmptyIconSize,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              AppStrings.noScreenshotsFound,
              style: AppTextTheme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              AppStrings.noScreenshotsFoundDescription,
              style: AppTextTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

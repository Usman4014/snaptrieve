import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:snaptrieve/features/screenshots/widgets/screenshot_preview_card.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/models/screenshot_model.dart';

class DashboardRecentEmptyState extends StatelessWidget {
  const DashboardRecentEmptyState({
    super.key,
    required this.onImportTap,
    required this.screenshots,
  });

  final VoidCallback onImportTap;
  final List<ScreenshotModel> screenshots;

  @override
  Widget build(BuildContext context) {
    if (screenshots.isNotEmpty) {
      return Column(
        children: [
          for (int index = 0; index < screenshots.length; index++) ...[
            ScreenshotPreviewCard(screenshot: screenshots[index]),
            if (index < screenshots.length - 1)
              const SizedBox(height: AppSizes.dashboardRecentItemSpacing),
          ],
        ],
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.dashboardCardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
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
              size: AppSizes.dashboardEmptyIconSize,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            AppStrings.noScreenshotsTitle,
            style: AppTextTheme.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            AppStrings.noScreenshotsDescription,
            style: AppTextTheme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(text: AppStrings.importScreenshots, onPressed: onImportTap),
        ],
      ),
    );
  }
}

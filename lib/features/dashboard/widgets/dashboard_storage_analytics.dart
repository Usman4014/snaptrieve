import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/dashboard_controller.dart';

class DashboardStorageAnalytics extends StatelessWidget {
  final DashboardController controller;

  const DashboardStorageAnalytics({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSizes.dashboardStorageCardPadding),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: AppColors.border,
            width: AppSizes.borderWidth,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressSection(context),

            const SizedBox(height: AppSizes.dashboardStorageSectionSpacing),

            _buildStorageSummary(context),

            const SizedBox(height: AppSizes.dashboardStorageSectionSpacing),

            _buildCategoryBreakdown(context),

            const SizedBox(height: AppSizes.dashboardStorageSectionSpacing),

            _buildLargestScreenshots(context),
          ],
        ),
      );
    });
  }

  Widget _buildProgressSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        SizedBox(
          width: AppSizes.dashboardStorageProgressSize,
          height: AppSizes.dashboardStorageProgressSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox.expand(
                child: CircularProgressIndicator(
                  value: 1,
                  strokeWidth: AppSizes.dashboardStorageProgressStroke,
                  color: AppColors.surfaceSecondary,
                ),
              ),
              SizedBox.expand(
                child: CircularProgressIndicator(
                  value: controller.processingProgress,
                  strokeWidth: AppSizes.dashboardStorageProgressStroke,
                  strokeCap: StrokeCap.round,
                  color: AppColors.primary,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    controller.processingPercentage,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    AppStrings.processed,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        Text(
          AppStrings.processingProgress,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: AppSpacing.xs),

        Text(
          '${controller.processedScreenshots.value} / '
          '${controller.totalScreenshots.value} '
          '${AppStrings.screenshotsUnit}',
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildStorageSummary(BuildContext context) {
    Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: _buildMetric(
            context,
            icon: PhosphorIconsRegular.hardDrive,
            title: AppStrings.storageUsed,
            value: controller.formattedTotalStorage,
          ),
        ),
        const SizedBox(width: AppSizes.dashboardStorageMetricSpacing),
        Expanded(
          child: _buildMetric(
            context,
            icon: PhosphorIconsRegular.images,
            title: AppStrings.totalScreenshots,
            value: controller.totalScreenshots.value.toString(),
          ),
        ),
      ],
    );
  }

  Widget _buildMetric(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: AppSizes.iconLarge, color: AppColors.textSecondary),
          const SizedBox(height: AppSpacing.sm),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdown(BuildContext context) {
    final theme = Theme.of(context);

    final categories = controller.categoryStorage;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.storageBreakdown,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        if (categories.isEmpty)
          Text(
            AppStrings.noStorageData,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          )
        else
          ...categories.map((category) {
            final percentage = controller.totalStorageBytes.value == 0
                ? 0.0
                : category.sizeBytes / controller.totalStorageBytes.value;

            return Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          category.categoryName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        controller.formatStorageSize(category.sizeBytes),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.circular),
                    child: LinearProgressIndicator(
                      value: percentage,
                      minHeight: AppSizes.dashboardStorageCategoryBarHeight,
                      backgroundColor: AppColors.surfaceSecondary,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget _buildLargestScreenshots(BuildContext context) {
    final theme = Theme.of(context);

    final screenshots = controller.largestScreenshots;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.largestScreenshots,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        if (screenshots.isEmpty)
          Text(
            AppStrings.noLargestScreenshots,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          )
        else
          ...screenshots.map((item) {
            return Padding(
              padding: const EdgeInsets.only(
                bottom: AppSizes.dashboardStorageLargestItemSpacing,
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    child: Image.file(
                      File(item.screenshot.imagePath),
                      width: AppSizes.dashboardStorageLargestImageSize,
                      height: AppSizes.dashboardStorageLargestImageSize,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) {
                        return Container(
                          width: AppSizes.dashboardStorageLargestImageSize,
                          height: AppSizes.dashboardStorageLargestImageSize,
                          color: AppColors.surfaceSecondary,
                          child: Icon(
                            PhosphorIconsRegular.image,
                            color: AppColors.textSecondary,
                            size: AppSizes.iconLarge,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.categoryName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          controller.formatStorageSize(item.sizeBytes),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }
}

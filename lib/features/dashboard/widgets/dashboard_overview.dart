import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/dashboard_controller.dart';

class DashboardOverview extends StatelessWidget {
  const DashboardOverview({super.key, required this.controller});

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Obx(
      () => ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.zero,
          topRight: Radius.zero,
          bottomLeft: Radius.circular(AppRadius.xl),
          bottomRight: Radius.circular(AppRadius.xl),
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.primary,

            borderRadius: BorderRadius.only(
              topLeft: Radius.zero,
              topRight: Radius.zero,
              bottomLeft: Radius.circular(AppRadius.xl),
              bottomRight: Radius.circular(AppRadius.xl),
            ),
          ),
          child: Stack(
            children: [
              //     _buildDecorations(),

              Padding(
                padding: const EdgeInsets.all(
                  AppSizes.dashboardStorageCardPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProgress(textTheme),
                    const SizedBox(
                      height: AppSizes.dashboardAnalyticsSectionSpacing,
                    ),

                    _buildMetrics(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetrics() {
    return Row(
      children: [
        Expanded(
          child: _AnalyticsMetric(
            icon: PhosphorIconsRegular.database,
            title: AppStrings.storageUsed,
            value: controller.formattedTotalStorage,
          ),
        ),

        const SizedBox(width: AppSizes.dashboardAnalyticsTileSpacing),

        Expanded(
          child: _AnalyticsMetric(
            icon: PhosphorIconsRegular.images,
            title: AppStrings.totalScreenshots,
            value: controller.totalScreenshots.value.toString(),
          ),
        ),
      ],
    );
  }

  Widget _buildProgress(TextTheme textTheme) {
    return Center(
      child: Column(
        children: [
          SizedBox(
            width: AppSizes.dashboardAnalyticsProgressSize,
            height: AppSizes.dashboardAnalyticsProgressSize,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox.expand(
                  child: CircularProgressIndicator(
                    value: 1,
                    strokeWidth: AppSizes.dashboardAnalyticsProgressStroke,
                    color: AppColors.analyticsProgressTrack,
                  ),
                ),

                SizedBox.expand(
                  child: CircularProgressIndicator(
                    value: controller.processingProgress,
                    strokeWidth: AppSizes.dashboardAnalyticsProgressStroke,
                    strokeCap: StrokeCap.round,
                    color: AppColors.textOnPrimary,
                  ),
                ),

                Container(
                  width: AppSizes.dashboardAnalyticsProgressCenterSize,
                  height: AppSizes.dashboardAnalyticsProgressCenterSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.analyticsCardStart,
                        AppColors.analyticsBackgroundStart,
                      ],
                    ),
                    border: Border.all(
                      color: AppColors.analyticsBorder,
                      width: AppSizes.borderWidth,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.analyticsGlow.withValues(alpha: 0.12),
                        blurRadius: AppSpacing.xxl,
                        spreadRadius: AppSpacing.xs,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        PhosphorIconsRegular.stack,
                        color: AppColors.textOnPrimary,
                        size: AppSizes.iconLarge,
                      ),

                      const SizedBox(height: AppSpacing.sm),

                      Text(
                        controller.processingPercentage,
                        style: textTheme.headlineLarge?.copyWith(
                          color: AppColors.textOnPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        AppStrings.processed,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.textOnPrimary.withValues(
                            alpha: 0.75,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          Text(
            AppStrings.processingProgress,
            style: textTheme.titleMedium?.copyWith(
              color: AppColors.textOnPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: AppSizes.dashboardAnalyticsStatusSpacing),

          Row(
            children: [
              Expanded(
                child: _ProcessingStatus(
                  value: controller.processedScreenshots.value,
                  label: AppStrings.processed,
                  iconColor: AppColors.success,
                  alignment: MainAxisAlignment.center,
                ),
              ),

              Container(
                height: AppSizes.dashboardAnalyticsStatusDividerHeight,
                width: AppSizes.borderWidth,
                color: AppColors.secondary,
              ),

              Expanded(
                child: _ProcessingStatus(
                  value: controller.pendingScreenshots,
                  label: AppStrings.pending,
                  iconColor: AppColors.textOnPrimary,
                  alignment: MainAxisAlignment.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AnalyticsMetric extends StatelessWidget {
  const _AnalyticsMetric({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSizes.dashboardAnalyticsTilePadding),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.analyticsCardStart, AppColors.analyticsCardEnd],
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: AppColors.analyticsBorder,
          width: AppSizes.borderWidth,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: AppSizes.dashboardAnalyticsMetricIconContainer,
            height: AppSizes.dashboardAnalyticsMetricIconContainer,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.analyticsGlow, AppColors.analyticsCardEnd],
              ),
              borderRadius: BorderRadius.circular(AppRadius.lg),
              border: Border.all(
                color: AppColors.analyticsBorder,
                width: AppSizes.borderWidth,
              ),
            ),
            child: Icon(
              icon,
              color: AppColors.textOnPrimary,
              size: AppSizes.dashboardAnalyticsMetricIconSize,
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.textOnPrimary.withValues(alpha: 0.75),
            ),
          ),

          const SizedBox(height: AppSpacing.xs),

          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleLarge?.copyWith(
              color: AppColors.textOnPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProcessingStatus extends StatelessWidget {
  const _ProcessingStatus({
    required this.value,
    required this.label,
    required this.iconColor,
    required this.alignment,
  });

  final int value;
  final String label;
  final Color iconColor;
  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      mainAxisAlignment: alignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value.toString(),
          style: textTheme.bodyMedium?.copyWith(
            color: AppColors.textOnPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(width: AppSpacing.xs),

        Flexible(
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.textOnPrimary.withValues(alpha: 0.85),
            ),
          ),
        ),
      ],
    );
  }
}

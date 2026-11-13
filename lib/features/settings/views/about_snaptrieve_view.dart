import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:snaptrieve/core/widgets/app_app_bar.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';

class AboutSnaptrieveView extends StatelessWidget {
  const AboutSnaptrieveView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(title: AppStrings.aboutSnaptrieveTitle),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.dashboardHorizontalPadding),
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xxl),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              child: Column(
                children: [
                  const Icon(
                    PhosphorIconsRegular.images,
                    size: AppSizes.dashboardEmptyIconSize,
                    color: AppColors.textOnPrimary,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    AppStrings.appName,
                    style: textTheme.headlineMedium?.copyWith(
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    AppStrings.aboutSnaptrieveSubtitle,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textOnPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              AppStrings.aboutSnaptrieveTitle,
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              AppStrings.aboutSnaptrieveDescription,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Text(
              AppStrings.aboutFeaturesTitle,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _AboutFeatureCard(
              icon: PhosphorIconsRegular.image,
              title: AppStrings.featureCaptureTitle,
              description: AppStrings.featureCaptureDescription,
            ),
            const SizedBox(height: AppSpacing.md),
            _AboutFeatureCard(
              icon: PhosphorIconsRegular.folderOpen,
              title: AppStrings.featureOrganizeTitle,
              description: AppStrings.featureOrganizeDescription,
            ),
            const SizedBox(height: AppSpacing.md),
            _AboutFeatureCard(
              icon: PhosphorIconsRegular.magnifyingGlass,
              title: AppStrings.featureSearchTitle,
              description: AppStrings.featureSearchDescription,
            ),
            const SizedBox(height: AppSpacing.xxl),
            _AboutFeatureCard(
              icon: PhosphorIconsRegular.wifiSlash,
              title: AppStrings.aboutOfflineTitle,
              description: AppStrings.aboutOfflineDescription,
            ),
            const SizedBox(height: AppSpacing.xxl),
            Container(
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  const Icon(
                    PhosphorIconsRegular.info,
                    size: AppSizes.iconLarge,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      AppStrings.appVersion,
                      style: textTheme.titleSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    AppConstants.appVersion,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Center(
              child: Text(
                AppStrings.settingsFooter,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutFeatureCard extends StatelessWidget {
  const _AboutFeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: AppSizes.iconLarge, color: AppColors.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

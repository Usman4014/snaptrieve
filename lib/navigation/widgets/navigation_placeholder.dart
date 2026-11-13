import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../core/constants/app_constants.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_colors.dart';

class NavigationPlaceholder extends StatelessWidget {
  const NavigationPlaceholder({
    super.key,
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
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
                child: PhosphorIcon(
                  icon,
                  size: AppSizes.dashboardEmptyIconSize,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(title, style: textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.sm),
              Text(AppStrings.comingSoon, style: textTheme.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(
                AppStrings.featureComingSoonDescription,
                style: textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

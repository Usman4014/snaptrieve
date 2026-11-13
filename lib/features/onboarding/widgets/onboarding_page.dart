import 'package:flutter/material.dart';

import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Column(
        children: [
          const Spacer(),

          Container(
            height: AppSizes.onboardingIllustrationSize,
            width: AppSizes.onboardingIllustrationSize,
            decoration: BoxDecoration(
              color: AppColors.surfaceSecondary,
              borderRadius: BorderRadius.circular(AppRadius.xxl),
            ),
            alignment: Alignment.center,
            child: Container(
              height: AppSizes.onboardingIconSize,
              width: AppSizes.onboardingIconSize,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              alignment: Alignment.center,
              child: PhosphorIcon(
                icon,
                size: AppSizes.iconLarge * 2,
                color: AppColors.textOnPrimary,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.xxxl),

          Text(
            title,
            textAlign: TextAlign.center,
            style: textTheme.headlineMedium,
          ),

          const SizedBox(height: AppSpacing.md),

          Text(
            description,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(height: 1.8),
          ),

          const Spacer(),
          const Spacer(),
        ],
      ),
    );
  }
}

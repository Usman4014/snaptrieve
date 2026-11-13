import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';

class OnboardingIndicator extends StatelessWidget {
  const OnboardingIndicator({
    super.key,
    required this.currentIndex,
    required this.itemCount,
  });

  final int currentIndex;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        final isActive = currentIndex == index;

        return AnimatedContainer(
          duration: AppDurations.splashAnimation,
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          height: AppSizes.onboardingIndicatorHeight,
          width: isActive
              ? AppSizes.onboardingIndicatorWidth
              : AppSizes.onboardingIndicatorHeight,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.border,
            borderRadius: BorderRadius.circular(AppRadius.circular),
          ),
        );
      }),
    );
  }
}

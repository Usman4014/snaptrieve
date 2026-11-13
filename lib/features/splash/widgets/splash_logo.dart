import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';

class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.85, end: 1),
      duration: AppDurations.splashAnimation,
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: Container(
        height: AppSizes.splashLogoSize,
        width: AppSizes.splashLogoSize,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(AppRadius.xxl),
        ),
        alignment: Alignment.center,
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          'assets/images/snaptrieve_logo.png',
          height: AppSizes.splashLogoSize,
          width: AppSizes.splashLogoSize,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

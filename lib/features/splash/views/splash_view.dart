import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/splash_logo.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SplashLogo(),

                  const SizedBox(height: AppSpacing.xl),

                  Text(AppStrings.appName, style: textTheme.displaySmall),

                  const SizedBox(height: AppSpacing.sm),

                  Text(AppStrings.tagline, style: textTheme.bodyMedium),
                ],
              ),
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.xxxl),
                child: SizedBox(
                  height: AppSizes.splashIndicatorSize,
                  width: AppSizes.splashIndicatorSize,
                  child: CircularProgressIndicator(
                    strokeWidth: AppSizes.splashIndicatorStroke,
                    color: colorScheme.primary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

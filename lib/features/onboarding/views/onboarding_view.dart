import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/onboarding_controller.dart';
import '../widgets/onboarding_indicator.dart';
import '../widgets/onboarding_page.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key, this.onCompleted});

  final VoidCallback? onCompleted;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OnboardingController>();

    final pages = [
      OnboardingPage(
        icon: PhosphorIconsRegular.cloudArrowDown,
        title: AppStrings.onboardingTitle1,
        description: AppStrings.onboardingDescription1,
      ),
      OnboardingPage(
        icon: PhosphorIconsRegular.textT,
        title: AppStrings.onboardingTitle2,
        description: AppStrings.onboardingDescription2,
      ),
      OnboardingPage(
        icon: PhosphorIconsRegular.magnifyingGlass,
        title: AppStrings.onboardingTitle3,
        description: AppStrings.onboardingDescription3,
      ),
    ];

    Future<void> finishOnboarding() async {
      await controller.completeOnboarding();
      onCompleted?.call();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xxl,
                vertical: AppSpacing.lg,
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: Obx(
                  () => TextButton(
                    onPressed:
                        controller.currentPage.value ==
                            OnboardingController.totalPages - 1
                        ? null
                        : finishOnboarding,
                    child: Text(AppStrings.skip),
                  ),
                ),
              ),
            ),

            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                children: pages,
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xxl,
                AppSpacing.lg,
                AppSpacing.xxl,
                AppSpacing.xxxl,
              ),
              child: Column(
                children: [
                  Obx(
                    () => OnboardingIndicator(
                      currentIndex: controller.currentPage.value,
                      itemCount: OnboardingController.totalPages,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xxxl),

                  Obx(() {
                    final isLastPage =
                        controller.currentPage.value ==
                        OnboardingController.totalPages - 1;

                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLastPage
                            ? finishOnboarding
                            : controller.nextPage,
                        child: Text(
                          isLastPage ? AppStrings.getStarted : AppStrings.next,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/dashboard_categories_section.dart';
import '../widgets/dashboard_overview.dart';
import '../widgets/dashboard_recent_empty_state.dart';
import '../widgets/dashboard_section_header.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        body: SafeArea(
          top: true,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Full-width Storage Analytics
                DashboardOverview(controller: controller),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.dashboardHorizontalPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSizes.dashboardSectionSpacing),

                      // Categories
                      DashboardSectionHeader(title: AppStrings.categories),

                      const SizedBox(height: AppSpacing.md),

                      DashboardCategoriesSection(controller: controller),

                      const SizedBox(height: AppSizes.dashboardSectionSpacing),

                      // Recent Screenshots
                      DashboardSectionHeader(
                        title: AppStrings.recentScreenshots,
                        onTap: controller.openAllScreenshots,
                      ),

                      const SizedBox(height: AppSpacing.md),

                      Obx(
                        () => DashboardRecentEmptyState(
                          onImportTap: controller.importScreenshots,
                          screenshots: controller.recentScreenshots.toList(),
                        ),
                      ),

                      const SizedBox(height: AppSizes.dashboardBottomSpacing),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

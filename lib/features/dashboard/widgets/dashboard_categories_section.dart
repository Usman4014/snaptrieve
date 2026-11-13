import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../controllers/dashboard_controller.dart';
import 'dashboard_category_card.dart';

class DashboardCategoriesSection extends StatelessWidget {
  const DashboardCategoriesSection({super.key, required this.controller});

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    final categories = [
      (title: AppStrings.links, icon: PhosphorIconsRegular.link),
      (title: AppStrings.emails, icon: PhosphorIconsRegular.envelopeSimple),
      (title: AppStrings.contacts, icon: PhosphorIconsRegular.phone),
      (title: AppStrings.datesEvents, icon: PhosphorIconsRegular.calendarBlank),
      (title: AppStrings.generalText, icon: PhosphorIconsRegular.textT),
      (
        title: AppStrings.uncategorized,
        icon: PhosphorIconsRegular.folderSimple,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: AppSizes.dashboardCategoryCardHeight,
        crossAxisSpacing: AppSizes.dashboardGridSpacing,
        mainAxisSpacing: AppSizes.dashboardGridSpacing,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];

        return Obx(
          () => DashboardCategoryCard(
            icon: category.icon,
            title: category.title,
            count: controller.getCategoryCount(category.title),
            onTap: () => controller.openCategory(category.title),
          ),
        );
      },
    );
  }
}

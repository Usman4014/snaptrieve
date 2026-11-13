import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:snaptrieve/app/routes/app_routes.dart';

import '../../../core/widgets/app_snackbar.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_confirmation_dialog.dart';
import '../controllers/screenshots_controller.dart';
import '../widgets/screenshot_filter_bar.dart';
import '../widgets/screenshot_grid.dart';
import '../widgets/screenshot_search_field.dart';
import '../widgets/screenshot_sort_menu.dart';

class ScreenshotsView extends GetView<ScreenshotsController> {
  const ScreenshotsView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: _buildSelectionActions(),
      floatingActionButton: Obx(() {
        if (controller.isSelectionMode.value) {
          return const SizedBox.shrink();
        }

        return FloatingActionButton(
          onPressed: _showAddOptions,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          elevation: 0,
          shape: const CircleBorder(),
          child: const Icon(
            PhosphorIconsRegular.plus,
            size: AppSizes.iconLarge,
          ),
        );
      }),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.dashboardHorizontalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSizes.dashboardHeaderTopPadding),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.allScreenshots,
                    style: textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    AppStrings.dashboardSubtitle,
                    style: textTheme.bodySmall,
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xl),

              ScreenshotSearchField(controller: controller),

              const SizedBox(height: AppSpacing.lg),

              ScreenshotFilterBar(controller: controller),

              const SizedBox(height: AppSpacing.lg),

              Obx(() {
                if (controller.isSelectionMode.value) {
                  return _buildSelectionHeader(context);
                }

                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        controller.selectedCategory.value,
                        style: textTheme.titleMedium,
                      ),
                    ),
                    ScreenshotSortMenu(controller: controller),
                  ],
                );
              }),

              const SizedBox(height: AppSpacing.md),

              Expanded(
                child: PageView.builder(
                  controller: controller.categoryPageController,
                  itemCount: ScreenshotsController.categories.length,
                  onPageChanged: controller.onCategoryPageChanged,
                  physics: const PageScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Obx(
                      () => ScreenshotGrid(
                        screenshots: controller.getScreenshotsForCategory(
                          index,
                        ),
                        isLoading: controller.isLoading.value,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddOptions() {
    Get.bottomSheet(
      SafeArea(
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.xl),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppStrings.addScreenshots,
                style: Theme.of(Get.context!).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.lg),
              ListTile(
                leading: const Icon(PhosphorIconsRegular.camera),
                title: const Text(AppStrings.takePhoto),
                onTap: () {
                  Get.back();
                  Get.toNamed(AppRoutes.importScreenshots, arguments: 'camera');
                },
              ),
              ListTile(
                leading: const Icon(PhosphorIconsRegular.images),
                title: const Text(AppStrings.chooseFromGallery),
                onTap: () {
                  Get.back();
                  Get.toNamed(AppRoutes.importScreenshots);
                },
              ),
            ],
          ),
        ),
      ),
      backgroundColor: AppColors.transparent,
    );
  }

  Widget _buildSelectionHeader(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Obx(
            () => Text(
              '${controller.selectedScreenshotIds.length} '
              '${AppStrings.selectedScreenshots}',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ),

        TextButton(
          onPressed: () {
            final visibleScreenshots = controller.getScreenshotsForCategory(
              controller.selectedCategoryIndex.value,
            );

            controller.selectAllScreenshots(visibleScreenshots);
          },
          child: Text(AppStrings.selectAll),
        ),

        TextButton(
          onPressed: controller.exitSelectionMode,
          child: Text(AppStrings.cancelSelection),
        ),
      ],
    );
  }

  Widget _buildSelectionActions() {
    return Obx(() {
      if (!controller.isSelectionMode.value) {
        return const SizedBox.shrink();
      }

      final selectedCount = controller.selectedScreenshotIds.length;

      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.dashboardHorizontalPadding),
          child: SizedBox(
            width: double.infinity,
            height: AppSizes.buttonHeight,
            child: ElevatedButton.icon(
              onPressed: selectedCount == 0 ? null : _confirmDeleteSelected,
              icon: const Icon(PhosphorIconsRegular.trash),
              label: Text('${AppStrings.deleteSelected} ($selectedCount)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: AppColors.textOnPrimary,
                disabledBackgroundColor: AppColors.surfaceSecondary,
                disabledForegroundColor: AppColors.textDisabled,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Future<void> _confirmDeleteSelected() async {
    final confirmed = await Get.dialog<bool>(
      const AppConfirmationDialog(
        title: AppStrings.deleteSelectedTitle,
        message: AppStrings.deleteSelectedConfirmation,
        confirmText: AppStrings.deleteSelected,
        cancelText: AppStrings.cancel,
      ),
    );

    if (confirmed != true) return;

    final success = await controller.deleteSelectedScreenshots();

    if (success) {
      AppSnackbar.success(
        AppStrings.screenshotsDeletedSuccess,
        title: AppStrings.appName,
      );
    } else {
      AppSnackbar.error(
        AppStrings.screenshotsDeletedError,
        title: AppStrings.appName,
      );
    }
  }
}

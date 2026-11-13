import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/screenshot_model.dart';
import '../controllers/screenshots_controller.dart';

class ScreenshotGridItem extends StatelessWidget {
  const ScreenshotGridItem({super.key, required this.screenshot});

  final ScreenshotModel screenshot;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ScreenshotsController>();
    final id = screenshot.id;

    return Obx(() {
      final isSelected =
          id != null &&
          controller.selectedScreenshotIds.contains(id.toString());

      return GestureDetector(
        onTap: () {
          if (controller.isSelectionMode.value) {
            controller.toggleScreenshotSelection(screenshot);
            return;
          }

          if (id == null) return;

          Get.toNamed(AppRoutes.screenshotDetails, arguments: id);
        },
        onLongPress: () {
          if (!controller.isSelectionMode.value) {
            controller.startSelection(screenshot);
          }
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
            AppSizes.screenshotGridItemRadius,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.file(
                File(screenshot.imagePath),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const ColoredBox(
                    color: AppColors.surfaceSecondary,
                    child: Center(
                      child: Icon(
                        PhosphorIconsRegular.imageBroken,
                        color: AppColors.secondary,
                        size: AppSizes.iconLarge,
                      ),
                    ),
                  );
                },
              ),

              if (controller.isSelectionMode.value)
                ColoredBox(
                  color: isSelected ? AppColors.overlay : AppColors.transparent,
                ),

              if (controller.isSelectionMode.value)
                Positioned(
                  top: AppSpacing.sm,
                  right: AppSpacing.sm,
                  child: Container(
                    width: AppSizes.iconLarge,
                    height: AppSizes.iconLarge,
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surface),
                    ),
                    child: isSelected
                        ? const Icon(
                            PhosphorIconsFill.check,
                            size: AppSizes.iconSmall,
                            color: AppColors.textOnPrimary,
                          )
                        : null,
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}

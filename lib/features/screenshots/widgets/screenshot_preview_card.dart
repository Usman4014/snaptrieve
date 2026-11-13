import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_theme.dart';
import '../../../data/models/screenshot_model.dart';

class ScreenshotPreviewCard extends StatelessWidget {
  const ScreenshotPreviewCard({super.key, required this.screenshot});

  final ScreenshotModel screenshot;

  @override
  Widget build(BuildContext context) {
    final previewText = screenshot.extractedText.trim().isEmpty
        ? AppStrings.noDataFound
        : screenshot.extractedText.trim();

    return InkWell(
      onTap: () {
        final id = screenshot.id;
        if (id == null) return;

        Get.toNamed(AppRoutes.screenshotDetails, arguments: id);
      },
      borderRadius: BorderRadius.circular(AppSizes.screenshotPreviewCardRadius),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.screenshotPreviewCardPadding),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(
            AppSizes.screenshotPreviewCardRadius,
          ),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: SizedBox(
                width: AppSizes.screenshotPreviewImageSize,
                height: AppSizes.screenshotPreviewImageSize,
                child: Image.file(
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
              ),
            ),
            const SizedBox(width: AppSizes.screenshotPreviewCardSpacing),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    previewText,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextTheme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    DateFormat.yMMMd().format(screenshot.createdAt),
                    style: AppTextTheme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Icon(
              screenshot.isProcessed
                  ? PhosphorIconsRegular.checkCircle
                  : PhosphorIconsRegular.clock,
              color: screenshot.isProcessed
                  ? AppColors.success
                  : AppColors.secondary,
              size: AppSizes.iconMedium,
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_theme.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_button.dart';
import '../controllers/import_screenshots_controller.dart';

class ImportScreenshotsView extends GetView<ImportScreenshotsController> {
  const ImportScreenshotsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(title: AppStrings.importScreenshots),
      body: SafeArea(
        child: Obx(() {
          final selectedCount = controller.selectedImagesCount;
          final isCameraPreview = controller.isCameraPreview.value;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(
                    AppSizes.importHorizontalPadding,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isCameraPreview)
                        _buildPickerSection()
                      else
                        _buildCameraPreviewHeader(),

                      const SizedBox(height: AppSizes.importSectionSpacing),

                      _buildSelectedImagesHeader(selectedCount),

                      if (controller.hasImportResult.value) ...[
                        const SizedBox(height: AppSpacing.lg),
                        _buildImportSummary(),
                      ],

                      const SizedBox(height: AppSpacing.md),

                      if (selectedCount > 0)
                        _buildImageGrid()
                      else if (!controller.hasImportResult.value)
                        _buildEmptyState(),

                      if (controller.errorMessage.value.isNotEmpty) ...[
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          controller.errorMessage.value,
                          style: AppTextTheme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              _buildBottomSection(selectedCount),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildCameraPreviewHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: AppSizes.importEmptyIconSize,
            height: AppSizes.importEmptyIconSize,
            decoration: const BoxDecoration(
              color: AppColors.surfaceSecondary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              PhosphorIconsRegular.camera,
              size: AppSizes.importPickerIconSize,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            AppStrings.cameraPreview,
            style: AppTextTheme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            AppStrings.selectImagesDescription,
            textAlign: TextAlign.center,
            style: AppTextTheme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildPickerSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Container(
            width: AppSizes.importEmptyIconSize,
            height: AppSizes.importEmptyIconSize,
            decoration: const BoxDecoration(
              color: AppColors.surfaceSecondary,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(
              PhosphorIconsRegular.images,
              size: AppSizes.importPickerIconSize,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            AppStrings.selectScreenshots,
            style: AppTextTheme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            AppStrings.selectImagesDescription,
            textAlign: TextAlign.center,
            style: AppTextTheme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          Obx(
            () => SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed:
                    controller.isPickingImages.value ||
                        controller.isImporting.value
                    ? null
                    : controller.pickImages,
                icon: controller.isPickingImages.value
                    ? const SizedBox(
                        width: AppSizes.iconMedium,
                        height: AppSizes.iconMedium,
                        child: CircularProgressIndicator(
                          strokeWidth: AppSizes.splashIndicatorStroke,
                          color: AppColors.primary,
                        ),
                      )
                    : const Icon(
                        PhosphorIconsRegular.plus,
                        size: AppSizes.iconMedium,
                      ),
                label: Text(
                  AppStrings.selectScreenshots,
                  style: AppTextTheme.textTheme.labelLarge,
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  minimumSize: const Size(
                    double.infinity,
                    AppSizes.buttonHeight,
                  ),
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedImagesHeader(int count) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '${AppStrings.selectedImages} ($count)',
            style: AppTextTheme.textTheme.titleMedium,
          ),
        ),
        if (count > 0)
          TextButton(
            onPressed: controller.isImporting.value
                ? null
                : controller.clearSelection,
            child: Text(
              AppStrings.clearSelection,
              style: AppTextTheme.textTheme.labelMedium?.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildImportSummary() {
    final hasFailures = controller.hasFailedImages;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.importResultCardPadding),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            hasFailures
                ? AppStrings.someImportsFailed
                : AppStrings.allImportsCompleted,
            style: AppTextTheme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _buildResultMetric(
                  icon: PhosphorIconsRegular.checkCircle,
                  count: controller.importedCount.value,
                  label: AppStrings.imported,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: AppSizes.importResultCardSpacing),
              Expanded(
                child: _buildResultMetric(
                  icon: PhosphorIconsRegular.copy,
                  count: controller.duplicateCount.value,
                  label: AppStrings.duplicatesSkipped,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(width: AppSizes.importResultCardSpacing),
              Expanded(
                child: _buildResultMetric(
                  icon: PhosphorIconsRegular.warningCircle,
                  count: controller.failedCount.value,
                  label: AppStrings.failed,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultMetric({
    required IconData icon,
    required int count,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          Icon(icon, size: AppSizes.importResultIconSize, color: color),
          const SizedBox(height: AppSpacing.sm),
          Text(
            count.toString(),
            style: AppTextTheme.textTheme.titleLarge?.copyWith(color: color),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextTheme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xxxl,
        horizontal: AppSpacing.xl,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const Icon(
            PhosphorIconsRegular.image,
            size: AppSizes.importEmptyIconSize,
            color: AppColors.secondary,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            AppStrings.noImagesSelected,
            style: AppTextTheme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            AppStrings.selectImagesDescription,
            textAlign: TextAlign.center,
            style: AppTextTheme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildImageGrid() {
    return Obx(() {
      final images = controller.selectedImages.toList();
      final isCameraPreview = controller.isCameraPreview.value;

      if (images.isEmpty) {
        return const SizedBox.shrink();
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: images.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: AppSizes.importPreviewSpacing,
          mainAxisSpacing: AppSizes.importPreviewSpacing,
          childAspectRatio: AppSizes.importImageAspectRatio,
        ),
        itemBuilder: (context, index) {
          final image = images[index];

          return Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.md),
                child: Image.file(
                  File(image.path),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const ColoredBox(
                      color: AppColors.surfaceSecondary,
                      child: Icon(
                        PhosphorIconsRegular.imageBroken,
                        color: AppColors.secondary,
                        size: AppSizes.iconLarge,
                      ),
                    );
                  },
                ),
              ),

              if (!isCameraPreview)
                Positioned(
                  top: AppSpacing.xs,
                  right: AppSpacing.xs,
                  child: Material(
                    color: AppColors.surface,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: controller.isImporting.value
                          ? null
                          : () => controller.removeImage(index),
                      customBorder: const CircleBorder(),
                      child: const SizedBox(
                        width: AppSizes.importImageRemoveButtonSize,
                        height: AppSizes.importImageRemoveButtonSize,
                        child: Icon(
                          PhosphorIconsRegular.x,
                          size: AppSizes.iconSmall,
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      );
    });
  }

  Widget _buildBottomSection(int count) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.defaultContentPadding),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (controller.isImporting.value) ...[
            LinearProgressIndicator(
              value: controller.importProgress,
              backgroundColor: AppColors.border,
              color: AppColors.primary,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${controller.processedCount.value} / '
              '${controller.currentBatchCount.value}',
              style: AppTextTheme.textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.md),
          ],

          if (controller.isCameraPreview.value &&
              !controller.isImporting.value) ...[
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    text: AppStrings.retakePhoto,
                    isOutlined: true,
                    isLoading: controller.isPickingImages.value,
                    onPressed: controller.isPickingImages.value
                        ? null
                        : controller.retakeCameraPhoto,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: AppButton(
                    text: AppStrings.usePhoto,
                    onPressed:
                        controller.isPickingImages.value ||
                            controller.selectedImages.isEmpty
                        ? null
                        : controller.confirmCameraPhoto,
                  ),
                ),
              ],
            ),
          ] else if (controller.hasImportResult.value &&
              !controller.isImporting.value) ...[
            if (controller.hasFailedImages) ...[
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      text: AppStrings.retryFailed,
                      isOutlined: true,
                      onPressed: controller.importSelectedScreenshots,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppButton(
                      text: AppStrings.done,
                      onPressed: controller.finishImport,
                    ),
                  ),
                ],
              ),
            ] else
              AppButton(
                text: AppStrings.done,
                onPressed: controller.finishImport,
              ),
          ] else if (!controller.isCameraPreview.value) ...[
            AppButton(
              text: AppStrings.startImport,
              isLoading: controller.isImporting.value,
              onPressed: count == 0 || controller.isImporting.value
                  ? null
                  : controller.importSelectedScreenshots,
            ),
          ],
        ],
      ),
    );
  }
}

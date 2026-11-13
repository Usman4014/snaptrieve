import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_theme.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../data/models/detected_information_model.dart';
import '../controllers/screenshot_details_controller.dart';

class ScreenshotDetailsView extends GetView<ScreenshotDetailsController> {
  const ScreenshotDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppAppBar(
        title: AppStrings.screenshotDetails,
        actions: [
          IconButton(
            onPressed: controller.shareScreenshot,
            tooltip: AppStrings.share,
            icon: const PhosphorIcon(
              PhosphorIconsRegular.shareNetwork,
              color: AppColors.textPrimary,
            ),
          ),
          IconButton(
            onPressed: _confirmDelete,
            tooltip: AppStrings.delete,
            icon: const PhosphorIcon(
              PhosphorIconsRegular.trash,
              color: AppColors.error,
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final screenshot = controller.screenshot.value;

        if (screenshot == null) {
          return Center(
            child: Text(
              AppStrings.noDataFound,
              style: AppTextTheme.textTheme.bodyMedium,
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImagePreview(screenshot.imagePath),

              const SizedBox(height: AppSizes.screenshotDetailsCardSpacing),

              _buildScreenshotInformation(
                createdAt: screenshot.createdAt,
                isProcessed: screenshot.isProcessed,
                category: controller.categoryName.value,
              ),

              const SizedBox(height: AppSpacing.xxl),

              _buildSectionHeader(
                AppStrings.extractedText,
                trailing: IconButton(
                  onPressed: controller.copyAllText,
                  tooltip: AppStrings.copy,
                  icon: const PhosphorIcon(
                    PhosphorIconsRegular.copy,
                    color: AppColors.textPrimary,
                    size: AppSizes.iconMedium,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.sm),

              _ExpandableTextCard(
                text: screenshot.extractedText.isEmpty
                    ? AppStrings.noDataFound
                    : screenshot.extractedText,
              ),

              const SizedBox(height: AppSpacing.xxl),

              _buildSectionHeader(AppStrings.detectedInformation),

              const SizedBox(height: AppSpacing.md),

              if (controller.detectedInformation.isEmpty)
                _buildEmptyInformation()
              else
                ...controller.detectedInformation.map(
                  _buildDetectedInformationCard,
                ),

              const SizedBox(height: AppSpacing.xxxl),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildImagePreview(String imagePath) {
    return GestureDetector(
      onTap: () => _openFullImage(imagePath),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        child: Container(
          width: double.infinity,
          height: AppSizes.screenshotDetailsImageHeight,
          color: AppColors.surfaceSecondary,
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              Positioned.fill(
                child: Image.file(
                  File(imagePath),
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: PhosphorIcon(
                        PhosphorIconsRegular.imageBroken,
                        color: AppColors.secondary,
                        size: AppSizes.iconLarge,
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.overlay,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const PhosphorIcon(
                    PhosphorIconsRegular.arrowsOut,
                    color: AppColors.textOnPrimary,
                    size: AppSizes.iconMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openFullImage(String imagePath) {
    Get.dialog(
      Dialog.fullscreen(
        backgroundColor: AppColors.primary,
        child: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: InteractiveViewer(
                  minScale: 1,
                  maxScale: 5,
                  child: Center(
                    child: Image.file(
                      File(imagePath),
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const PhosphorIcon(
                          PhosphorIconsRegular.imageBroken,
                          color: AppColors.textOnPrimary,
                          size: AppSizes.iconLarge,
                        );
                      },
                    ),
                  ),
                ),
              ),
              Positioned(
                top: AppSizes.screenshotDetailsFullImagePadding,
                right: AppSizes.screenshotDetailsFullImagePadding,
                child: IconButton(
                  onPressed: Get.back,
                  icon: const PhosphorIcon(
                    PhosphorIconsRegular.x,
                    color: AppColors.textOnPrimary,
                    size: AppSizes.iconLarge,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScreenshotInformation({
    required DateTime createdAt,
    required bool isProcessed,
    required String category,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.screenshotInformation,
            style: AppTextTheme.textTheme.titleMedium,
          ),

          const SizedBox(height: AppSpacing.md),

          _buildInformationRow(
            icon: PhosphorIconsRegular.calendarBlank,
            value:
                '${AppStrings.importedOn}: ${DateFormat.yMMMd().format(createdAt)}',
          ),

          const SizedBox(height: AppSpacing.md),

          _buildInformationRow(
            icon: PhosphorIconsRegular.folder,
            value:
                '${AppStrings.category}: ${category.isEmpty ? AppStrings.uncategorized : category}',
          ),

          const SizedBox(height: AppSpacing.md),

          _buildInformationRow(
            icon: isProcessed
                ? PhosphorIconsRegular.checkCircle
                : PhosphorIconsRegular.clock,
            value: isProcessed
                ? AppStrings.processingCompleted
                : AppStrings.processingPending,
            color: isProcessed ? AppColors.success : AppColors.warning,
          ),
        ],
      ),
    );
  }

  Widget _buildInformationRow({
    required IconData icon,
    required String value,
    Color color = AppColors.textSecondary,
  }) {
    return Row(
      children: [
        PhosphorIcon(
          icon,
          size: AppSizes.screenshotDetailsInfoIconSize,
          color: color,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            value,
            style: AppTextTheme.textTheme.bodyMedium?.copyWith(
              color: color == AppColors.textSecondary
                  ? AppColors.textPrimary
                  : color,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {Widget? trailing}) {
    return Row(
      children: [
        Expanded(child: Text(title, style: AppTextTheme.textTheme.titleLarge)),
        ?trailing,
      ],
    );
  }

  Widget _buildEmptyInformation() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          const PhosphorIcon(
            PhosphorIconsRegular.magnifyingGlass,
            color: AppColors.textSecondary,
            size: AppSizes.iconLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            AppStrings.noDetectedInformation,
            textAlign: TextAlign.center,
            style: AppTextTheme.textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetectedInformationCard(DetectedInformationModel information) {
    final isLink = information.type == DetectedInformationModel.link;

    final icon = switch (information.type) {
      DetectedInformationModel.link => PhosphorIconsRegular.link,
      DetectedInformationModel.email => PhosphorIconsRegular.envelopeSimple,
      DetectedInformationModel.phone => PhosphorIconsRegular.phone,
      DetectedInformationModel.date => PhosphorIconsRegular.calendarBlank,
      _ => PhosphorIconsRegular.info,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: AppSizes.dashboardIconContainerSize,
            height: AppSizes.dashboardIconContainerSize,
            decoration: BoxDecoration(
              color: AppColors.surfaceSecondary,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            alignment: Alignment.center,
            child: PhosphorIcon(
              icon,
              size: AppSizes.iconLarge,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  information.type,
                  style: AppTextTheme.textTheme.labelSmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                SelectableText(
                  information.value,
                  style: AppTextTheme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: isLink ? AppStrings.openLink : AppStrings.copy,
            onPressed: () {
              if (isLink) {
                controller.openLink(information.value);
              } else {
                controller.copyText(information.value);
              }
            },
            icon: PhosphorIcon(
              isLink
                  ? PhosphorIconsRegular.arrowSquareOut
                  : PhosphorIconsRegular.copy,
              size: AppSizes.iconMedium,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete() async {
    final shouldDelete = await Get.dialog<bool>(
      AlertDialog(
        title: Text(AppStrings.deleteScreenshot),
        content: Text(AppStrings.deleteScreenshotConfirmation),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text(
              AppStrings.delete,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await controller.deleteScreenshot();
    }
  }
}

class _ExpandableTextCard extends StatefulWidget {
  const _ExpandableTextCard({required this.text});

  final String text;

  @override
  State<_ExpandableTextCard> createState() => _ExpandableTextCardState();
}

class _ExpandableTextCardState extends State<_ExpandableTextCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isLongText = widget.text.length > 400;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedCrossFade(
            duration: AppDurations.splashAnimation,
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.text,
                maxLines: 8,
                overflow: TextOverflow.ellipsis,
                style: AppTextTheme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            secondChild: Align(
              alignment: Alignment.centerLeft,
              child: SelectableText(
                widget.text,
                style: AppTextTheme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          if (isLongText) ...[
            const SizedBox(height: AppSpacing.sm),
            TextButton(
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Text(
                _isExpanded ? AppStrings.showLess : AppStrings.showMore,
                style: AppTextTheme.textTheme.labelLarge?.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

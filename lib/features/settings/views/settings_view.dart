import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.loadStorageInfo,
          color: AppColors.primary,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.dashboardHorizontalPadding,
              AppSizes.dashboardHeaderTopPadding,
              AppSizes.dashboardHorizontalPadding,
              AppSizes.dashboardBottomSpacing,
            ),
            children: [
              _buildIntro(context),

              const SizedBox(height: AppSizes.dashboardSectionSpacing),

              _buildSectionTitle(AppStrings.storageSection),
              const SizedBox(height: AppSpacing.sm),
              _buildStorageCard(),

              const SizedBox(height: AppSpacing.xl),

              _buildSectionTitle(AppStrings.backupRestoreSection),
              const SizedBox(height: AppSpacing.sm),

              _buildSettingsCard(
                icon: PhosphorIconsRegular.archiveBox,
                title: AppStrings.createBackup,
                subtitle: AppStrings.createBackupSubtitle,
                showArrow: false,
                trailing: Obx(
                  () => controller.isCreatingBackup.value
                      ? const SizedBox(
                          width: AppSizes.iconMedium,
                          height: AppSizes.iconMedium,
                          child: CircularProgressIndicator(
                            strokeWidth: AppSizes.borderWidth,
                          ),
                        )
                      : const Icon(
                          PhosphorIconsRegular.caretRight,
                          size: AppSizes.iconMedium,
                          color: AppColors.textSecondary,
                        ),
                ),
                onTap: controller.createBackup,
              ),

              _buildDivider(),

              _buildSettingsCard(
                icon: PhosphorIconsRegular.arrowCounterClockwise,
                title: AppStrings.restoreBackup,
                subtitle: AppStrings.restoreBackupSubtitle,
                showArrow: false,
                trailing: Obx(
                  () => controller.isRestoringBackup.value
                      ? const SizedBox(
                          width: AppSizes.iconMedium,
                          height: AppSizes.iconMedium,
                          child: CircularProgressIndicator(
                            strokeWidth: AppSizes.borderWidth,
                          ),
                        )
                      : const Icon(
                          PhosphorIconsRegular.caretRight,
                          size: AppSizes.iconMedium,
                          color: AppColors.textSecondary,
                        ),
                ),
                onTap: controller.restoreBackup,
              ),

              const SizedBox(height: AppSpacing.xl),

              _buildSectionTitle(AppStrings.aboutSection),
              const SizedBox(height: AppSpacing.sm),

              _buildSettingsCard(
                icon: PhosphorIconsRegular.shieldCheck,
                title: AppStrings.privacyPolicy,
                subtitle: AppStrings.privacyPolicySubtitle,
                onTap: () => Get.toNamed(AppRoutes.privacyData),
              ),

              _buildDivider(),

              _buildSettingsCard(
                icon: PhosphorIconsRegular.info,
                title: AppStrings.aboutApp,
                subtitle: AppStrings.aboutAppSubtitle,
                onTap: () => Get.toNamed(AppRoutes.aboutSnaptrieve),
              ),

              const SizedBox(height: AppSpacing.xxxl),

              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntro(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.settingsTitle, style: textTheme.headlineMedium),
        const SizedBox(height: AppSpacing.xs),
        Text(AppStrings.settingsDescription, style: textTheme.bodySmall),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Get.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildStorageCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          _buildIconContainer(PhosphorIconsRegular.database),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.savedScreenshots,
                  style: Get.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  AppStrings.storageOfflineDescription,
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Obx(() {
            if (controller.isLoading.value) {
              return const SizedBox(
                width: AppSizes.iconMedium,
                height: AppSizes.iconMedium,
                child: CircularProgressIndicator(
                  strokeWidth: AppSizes.borderWidth,
                ),
              );
            }

            if (controller.errorMessage.isNotEmpty) {
              return IconButton(
                onPressed: controller.loadStorageInfo,
                icon: const Icon(PhosphorIconsRegular.arrowClockwise),
                color: AppColors.primary,
              );
            }

            return Text(
              controller.screenshotCount.value.toString(),
              style: Get.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSettingsCard({
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
    bool showArrow = true,
    Widget? trailing,
  }) {
    return Material(
      color: AppColors.surface,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              _buildIconContainer(icon),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Get.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      subtitle,
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null)
                trailing
              else if (showArrow)
                const Icon(
                  PhosphorIconsRegular.caretRight,
                  size: AppSizes.iconMedium,
                  color: AppColors.textSecondary,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer(IconData icon) {
    return Container(
      width: AppSizes.dashboardIconContainerSize,
      height: AppSizes.dashboardIconContainerSize,
      decoration: BoxDecoration(
        color: AppColors.surfaceSecondary,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Icon(icon, size: AppSizes.iconLarge, color: AppColors.primary),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: AppSizes.borderWidth,
      thickness: AppSizes.borderWidth,
      color: AppColors.divider,
      indent: AppSizes.dashboardCardPadding,
      endIndent: AppSizes.dashboardCardPadding,
    );
  }

  Widget _buildFooter() {
    final textTheme = Get.textTheme;

    return Column(
      children: [
        Text(
          AppStrings.appName,
          style: textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),

        Text(
          AppStrings.copyright,
          textAlign: TextAlign.center,
          style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          AppStrings.madeWithCare,
          textAlign: TextAlign.center,
          style: textTheme.bodySmall?.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}

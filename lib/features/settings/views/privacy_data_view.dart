import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:snaptrieve/core/widgets/app_app_bar.dart';

import '../../../core/widgets/app_snackbar.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_confirmation_dialog.dart';
import '../controllers/settings_controller.dart';

class PrivacyDataView extends GetView<SettingsController> {
  const PrivacyDataView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppAppBar(title: AppStrings.privacyDataTitle),

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSizes.dashboardHorizontalPadding),
          children: [
            Text(
              AppStrings.privacyDataSubtitle,
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            _PrivacyInfoCard(
              icon: PhosphorIconsRegular.database,
              title: AppStrings.localStorageTitle,
              description: AppStrings.localStorageDescription,
            ),
            const SizedBox(height: AppSpacing.md),

            _PrivacyInfoCard(
              icon: PhosphorIconsRegular.deviceMobile,
              title: AppStrings.onDeviceOcrTitle,
              description: AppStrings.onDeviceOcrDescription,
            ),
            const SizedBox(height: AppSpacing.md),

            _PrivacyInfoCard(
              icon: PhosphorIconsRegular.userCircle,
              title: AppStrings.noAccountTitle,
              description: AppStrings.noAccountDescription,
            ),
            const SizedBox(height: AppSpacing.md),

            _PrivacyInfoCard(
              icon: PhosphorIconsRegular.shieldCheck,
              title: AppStrings.dataControlTitle,
              description: AppStrings.dataControlDescription,
            ),

            const SizedBox(height: AppSpacing.xxl),

            Text(
              AppStrings.clearAllAppData,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              AppStrings.clearAllAppDataDescription,
              style: textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            Obx(() {
              return SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: controller.isClearingData.value
                      ? null
                      : _confirmClearData,
                  icon: controller.isClearingData.value
                      ? const SizedBox(
                          width: AppSizes.iconSmall,
                          height: AppSizes.iconSmall,
                          child: CircularProgressIndicator(
                            strokeWidth: AppSizes.borderWidth,
                          ),
                        )
                      : const Icon(PhosphorIconsRegular.trash),
                  label: Text(
                    controller.isClearingData.value
                        ? AppStrings.clearingData
                        : AppStrings.clearAllAppData,
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.error,
                    side: const BorderSide(color: AppColors.error),
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmClearData() async {
    final confirmed = await Get.dialog<bool>(
      const AppConfirmationDialog(
        title: AppStrings.clearDataConfirmationTitle,
        message: AppStrings.clearDataConfirmationMessage,
        confirmText: AppStrings.clearDataConfirm,
        cancelText: AppStrings.cancel,
      ),
    );

    if (confirmed != true) return;

    final success = await controller.clearAllAppData();

    if (success) {
      AppSnackbar.success(AppStrings.clearDataSuccess);
    } else {
      AppSnackbar.error(AppStrings.clearDataError);
    }
  }
}

class _PrivacyInfoCard extends StatelessWidget {
  const _PrivacyInfoCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: AppSizes.iconLarge, color: AppColors.primary),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

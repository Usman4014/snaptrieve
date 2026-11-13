import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/app_constants.dart';
import '../constants/app_strings.dart';
import '../theme/app_colors.dart';

class AppSnackbar {
  AppSnackbar._();

  static void success(String message, {String? title}) {
    _show(
      title: title ?? AppStrings.success,
      message: message,
      backgroundColor: AppColors.success,
    );
  }

  static void error(String message, {String? title}) {
    _show(
      title: title ?? AppStrings.error,
      message: message,
      backgroundColor: AppColors.error,
    );
  }

  static void warning(String message, {String? title}) {
    _show(
      title: title ?? AppStrings.warning,
      message: message,
      backgroundColor: AppColors.warning,
    );
  }

  static void info(String message, {String? title}) {
    _show(
      title: title ?? AppStrings.info,
      message: message,
      backgroundColor: AppColors.info,
    );
  }

  static void _show({
    required String title,
    required String message,
    required Color backgroundColor,
  }) {
    Get.closeCurrentSnackbar();

    Get.snackbar(
      title,
      message,
      backgroundColor: backgroundColor,
      colorText: AppColors.textOnPrimary,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(AppSpacing.lg),
      borderRadius: AppRadius.md,
      duration: const Duration(seconds: 3),
      isDismissible: true,
      titleText: Text(
        title,
        style: Get.textTheme.titleSmall?.copyWith(
          color: AppColors.textOnPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      messageText: Text(
        message,
        style: Get.textTheme.bodySmall?.copyWith(
          color: AppColors.textOnPrimary,
        ),
      ),
    );
  }
}

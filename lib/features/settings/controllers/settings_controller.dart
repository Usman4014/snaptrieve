import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/app_snackbar.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/services/backup_service.dart';
import '../../../core/utils/file_utils.dart';
import '../../../data/repositories/screenshot_repository.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../screenshots/controllers/screenshots_controller.dart';

class SettingsController extends GetxController {
  SettingsController(this._screenshotRepository, this._backupService);

  final ScreenshotRepository _screenshotRepository;
  final BackupService _backupService;

  final RxInt screenshotCount = 0.obs;
  final RxBool isLoading = false.obs;
  final RxBool isClearingData = false.obs;
  final RxBool isCreatingBackup = false.obs;
  final RxBool isRestoringBackup = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadStorageInfo();
  }

  Future<void> loadStorageInfo() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      screenshotCount.value = await _screenshotRepository.getTotalCount();
    } catch (_) {
      errorMessage.value = AppStrings.storageLoadError;
    } finally {
      isLoading.value = false;
    }
  }

  // Create and save backup ZIP file.
  Future<void> createBackup() async {
    if (isCreatingBackup.value || isRestoringBackup.value) {
      return;
    }

    try {
      isCreatingBackup.value = true;

      final Uint8List backupBytes = await _backupService.createBackup();

      final savedFile = await FilePicker.saveFile(
        dialogTitle: AppStrings.backupSaveDialogTitle,
        fileName: AppStrings.backupFileName,
        bytes: backupBytes,
      );

      if (savedFile == null) return;

      AppSnackbar.success(AppStrings.backupCreatedSuccess);
    } catch (_) {
      AppSnackbar.error(AppStrings.backupCreateError);
    } finally {
      isCreatingBackup.value = false;
    }
  }

  // Select and restore an existing backup ZIP file.
  Future<void> restoreBackup() async {
    if (isCreatingBackup.value || isRestoringBackup.value) {
      return;
    }

    try {
      isRestoringBackup.value = true;

      final PlatformFile? selectedFile = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['zip'],
      );

      if (selectedFile == null) return;

      final Uint8List backupBytes = await selectedFile.readAsBytes();

      if (backupBytes.isEmpty) {
        throw Exception(AppStrings.backupReadError);
      }

      final bool? confirmed = await Get.dialog<bool>(
        AlertDialog(
          title: const Text(AppStrings.restoreConfirmationTitle),
          content: const Text(AppStrings.restoreConfirmationMessage),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text(AppStrings.cancel),
            ),
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text(AppStrings.restoreBackup),
            ),
          ],
        ),
      );

      if (confirmed != true) return;

      await _backupService.restoreBackup(backupBytes);

      await loadStorageInfo();
      await _refreshOtherScreens();

      AppSnackbar.success(AppStrings.backupRestoredSuccess);
    } catch (_) {
      AppSnackbar.error(AppStrings.backupRestoreError);
    } finally {
      isRestoringBackup.value = false;
    }
  }

  // Clear all application data.
  Future<bool> clearAllAppData() async {
    if (isClearingData.value) return false;

    var databaseCleared = false;

    try {
      isClearingData.value = true;
      errorMessage.value = '';

      await _screenshotRepository.deleteAllScreenshots();

      databaseCleared = true;
      screenshotCount.value = 0;

      await FileUtils.clearScreenshotsDirectory();

      await _refreshOtherScreens();

      return true;
    } catch (_) {
      errorMessage.value = AppStrings.clearDataError;

      if (databaseCleared) {
        await _refreshOtherScreens();
      }

      await loadStorageInfo();

      return false;
    } finally {
      isClearingData.value = false;
    }
  }

  // Refresh dashboard and screenshots after restore or data deletion.
  Future<void> _refreshOtherScreens() async {
    if (Get.isRegistered<DashboardController>()) {
      await Get.find<DashboardController>().loadDashboardData();
    }

    if (Get.isRegistered<ScreenshotsController>()) {
      final screenshotsController = Get.find<ScreenshotsController>();

      screenshotsController.clearFilters();
      screenshotsController.selectedScreenshotIds.clear();
      screenshotsController.isSelectionMode.value = false;

      await screenshotsController.loadInitialData();
    }
  }
}

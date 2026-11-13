import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../dashboard/controllers/dashboard_controller.dart';
import '../controllers/screenshots_controller.dart';
import '../../../core/utils/file_utils.dart';
import '../../../data/models/detected_information_model.dart';
import '../../../data/models/screenshot_model.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../data/repositories/screenshot_repository.dart';

class ScreenshotDetailsController extends GetxController {
  final ScreenshotRepository _repository = Get.find<ScreenshotRepository>();

  final CategoryRepository _categoryRepository = Get.find<CategoryRepository>();

  final Rxn<ScreenshotModel> screenshot = Rxn<ScreenshotModel>();

  final RxList<DetectedInformationModel> detectedInformation =
      <DetectedInformationModel>[].obs;

  final RxString categoryName = ''.obs;

  final RxBool isLoading = false.obs;
  final RxBool isDeleting = false.obs;

  int? get screenshotId => Get.arguments as int?;

  @override
  void onInit() {
    super.onInit();
    loadScreenshot();
  }

  Future<void> loadScreenshot() async {
    final id = screenshotId;
    if (id == null) return;

    try {
      isLoading.value = true;

      final result = await _repository.getScreenshotById(id);

      screenshot.value = result;

      detectedInformation.assignAll(
        DetectedInformationModel.detect(result?.extractedText ?? ''),
      );

      categoryName.value = '';

      final categoryId = result?.categoryId;

      if (categoryId != null) {
        final category = await _categoryRepository.getCategoryById(categoryId);

        categoryName.value = category?.name ?? '';
      }
    } catch (error) {
      screenshot.value = null;
      categoryName.value = '';
      detectedInformation.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> copyText(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  Future<void> copyAllText() async {
    final text = screenshot.value?.extractedText ?? '';
    if (text.isEmpty) return;

    await copyText(text);
  }

  Future<void> openLink(String value) async {
    final url = value.startsWith('http') ? value : 'https://$value';

    final uri = Uri.tryParse(url);
    if (uri == null) return;

    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  Future<void> shareScreenshot() async {
    final currentScreenshot = screenshot.value;
    if (currentScreenshot == null) return;

    await SharePlus.instance.share(
      ShareParams(
        text: currentScreenshot.extractedText,
        files: [XFile(currentScreenshot.imagePath)],
      ),
    );
  }

  Future<void> deleteScreenshot() async {
    final currentScreenshot = screenshot.value;
    final id = currentScreenshot?.id;

    if (currentScreenshot == null || id == null) return;

    try {
      isDeleting.value = true;

      final deleted = await _repository.deleteScreenshot(id);

      if (!deleted) return;

      try {
        await FileUtils.deleteImage(currentScreenshot.imagePath);
      } on FileSystemException {
        // The database record is already deleted.
      }

      // Refresh Screenshots tab.
      if (Get.isRegistered<ScreenshotsController>()) {
        await Get.find<ScreenshotsController>().loadScreenshots();
      }

      // Refresh Dashboard counts and recent screenshots.
      if (Get.isRegistered<DashboardController>()) {
        await Get.find<DashboardController>().loadDashboardData();
      }

      Get.back();
    } finally {
      isDeleting.value = false;
    }
  }
}

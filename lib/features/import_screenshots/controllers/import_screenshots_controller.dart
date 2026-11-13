import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snaptrieve/features/screenshots/controllers/screenshots_controller.dart';

import '../../dashboard/controllers/dashboard_controller.dart';
import '../../../core/services/ocr_service.dart';
import '../../../core/utils/file_utils.dart';
import '../../../data/models/screenshot_model.dart';
import '../../../data/repositories/screenshot_repository.dart';
import '../../../core/services/category_detection_service.dart';

class ImportScreenshotsController extends GetxController {
  final CategoryDetectionService _categoryDetectionService =
      Get.find<CategoryDetectionService>();

  final ImagePicker _imagePicker = ImagePicker();

  final ScreenshotRepository _repository = Get.find<ScreenshotRepository>();

  final OcrService _ocrService = Get.find<OcrService>();

  final RxList<XFile> selectedImages = <XFile>[].obs;

  final RxBool isPickingImages = false.obs;
  final RxBool isImporting = false.obs;
  final RxBool hasImportResult = false.obs;
  final RxBool isCameraPreview = false.obs;

  final RxInt importedCount = 0.obs;
  final RxInt duplicateCount = 0.obs;
  final RxInt failedCount = 0.obs;
  final RxInt processedCount = 0.obs;
  final RxInt currentBatchCount = 0.obs;
  final RxInt ocrFailedCount = 0.obs;

  final RxString errorMessage = ''.obs;

  bool get hasSelectedImages => selectedImages.isNotEmpty;

  int get selectedImagesCount => selectedImages.length;

  bool get hasFailedImages => failedCount.value > 0;

  double get importProgress {
    if (currentBatchCount.value == 0) return 0;
    return processedCount.value / currentBatchCount.value;
  }

  @override
  void onReady() {
    super.onReady();

    // Automatically open camera when arriving through the camera option.
    if (Get.arguments == 'camera') {
      pickCameraImage();
    }
  }

  // Pick multiple images from gallery.
  Future<void> pickImages() async {
    if (isPickingImages.value || isImporting.value) return;

    try {
      isPickingImages.value = true;
      errorMessage.value = '';
      isCameraPreview.value = false;

      final images = await _imagePicker.pickMultiImage();

      if (images.isEmpty) return;

      final existingPaths = selectedImages.map((image) => image.path).toSet();

      final newImages = images
          .where((image) => existingPaths.add(image.path))
          .toList();

      if (newImages.isNotEmpty) {
        selectedImages.addAll(newImages);
        selectedImages.refresh();
        _resetImportResults();
      }
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isPickingImages.value = false;
    }
  }

  // Capture a photo using the device camera.
  Future<void> pickCameraImage() async {
    if (isPickingImages.value || isImporting.value) return;

    try {
      isPickingImages.value = true;
      errorMessage.value = '';

      final image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
      );

      if (image == null) return;

      selectedImages.assignAll([image]);
      isCameraPreview.value = true;

      _resetImportResults();
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isPickingImages.value = false;
    }
  }

  // Retake the captured photo.
  Future<void> retakeCameraPhoto() async {
    if (!isCameraPreview.value) return;

    await pickCameraImage();
  }

  // Confirm the captured photo and start the existing import process.
  Future<void> confirmCameraPhoto() async {
    if (selectedImages.isEmpty || isImporting.value) return;

    isCameraPreview.value = false;
    await importSelectedScreenshots();
  }

  void _resetImportResults() {
    hasImportResult.value = false;
    importedCount.value = 0;
    duplicateCount.value = 0;
    failedCount.value = 0;
    processedCount.value = 0;
    currentBatchCount.value = 0;
    ocrFailedCount.value = 0;
  }

  void removeImage(int index) {
    if (isImporting.value) return;
    if (index < 0 || index >= selectedImages.length) return;

    selectedImages.removeAt(index);
  }

  void clearSelection() {
    if (isImporting.value) return;

    selectedImages.clear();
    isCameraPreview.value = false;
    errorMessage.value = '';

    _resetImportResults();
  }

  Future<void> importSelectedScreenshots() async {
    if (selectedImages.isEmpty || isImporting.value) return;

    isImporting.value = true;
    errorMessage.value = '';

    final imagesToImport = List<XFile>.from(selectedImages);
    final failedImages = <XFile>[];

    currentBatchCount.value = imagesToImport.length;
    processedCount.value = 0;
    failedCount.value = 0;

    for (final image in imagesToImport) {
      String? copiedImagePath;

      try {
        final imageHash = await FileUtils.generateImageHash(image.path);

        final isDuplicate = await _repository.isDuplicate(imageHash);

        if (isDuplicate) {
          duplicateCount.value++;
          continue;
        }

        copiedImagePath = await FileUtils.copyImageToAppStorage(
          sourcePath: image.path,
          imageHash: imageHash,
        );

        String extractedText = '';
        bool isProcessed = false;

        try {
          extractedText = await _ocrService.extractText(copiedImagePath);
          isProcessed = true;
        } catch (_) {
          ocrFailedCount.value++;
        }

        final now = DateTime.now();
        int? categoryId;

        try {
          categoryId = await _categoryDetectionService.detectCategoryId(
            extractedText,
          );
        } catch (_) {
          // Continue import if category detection fails.
        }

        final screenshot = ScreenshotModel(
          imagePath: copiedImagePath,
          imageHash: imageHash,
          extractedText: extractedText,
          categoryId: categoryId,
          createdAt: now,
          updatedAt: now,
          isProcessed: isProcessed,
        );

        final insertedId = await _repository.addScreenshot(screenshot);

        if (insertedId == null) {
          await FileUtils.deleteImage(copiedImagePath);
          duplicateCount.value++;
          continue;
        }

        importedCount.value++;
      } catch (error) {
        failedCount.value++;
        failedImages.add(image);

        if (copiedImagePath != null) {
          try {
            await FileUtils.deleteImage(copiedImagePath);
          } catch (_) {
            // Preserve original import failure.
          }
        }
      } finally {
        processedCount.value++;
      }
    }

    selectedImages.assignAll(failedImages);

    hasImportResult.value = true;
    isImporting.value = false;
  }

  void finishImport() {
    if (Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().loadDashboardData();
    }

    if (Get.isRegistered<ScreenshotsController>()) {
      Get.find<ScreenshotsController>().loadScreenshots();
    }

    Get.back();
  }

  @override
  void onClose() {
    selectedImages.clear();
    super.onClose();
  }
}

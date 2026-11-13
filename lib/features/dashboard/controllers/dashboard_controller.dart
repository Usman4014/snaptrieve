import 'package:get/get.dart';
import 'package:snaptrieve/core/constants/app_strings.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/utils/file_utils.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/screenshot_model.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../data/repositories/screenshot_repository.dart';
import '../../../navigation/main_navigation_controller.dart';
import '../../screenshots/controllers/screenshots_controller.dart';

class DashboardController extends GetxController {
  final ScreenshotRepository _repository = Get.find<ScreenshotRepository>();

  final CategoryRepository _categoryRepository = Get.find<CategoryRepository>();

  final RxInt totalScreenshots = 0.obs;
  final RxInt processedScreenshots = 0.obs;

  final RxList<ScreenshotModel> recentScreenshots = <ScreenshotModel>[].obs;

  final RxMap<String, int> categoryCounts = <String, int>{}.obs;

  // Storage analytics.
  final RxInt totalStorageBytes = 0.obs;

  final RxList<DashboardCategoryStorage> categoryStorage =
      <DashboardCategoryStorage>[].obs;

  final RxList<DashboardScreenshotStorage> largestScreenshots =
      <DashboardScreenshotStorage>[].obs;

  final RxBool isLoading = false.obs;

  double get processingProgress {
    if (totalScreenshots.value == 0) return 0;

    return processedScreenshots.value / totalScreenshots.value;
  }

  int get pendingScreenshots {
    return totalScreenshots.value - processedScreenshots.value;
  }

  String get processingPercentage {
    return '${(processingProgress * 100).round()}%';
  }

  String get formattedTotalStorage {
    return formatStorageSize(totalStorageBytes.value);
  }

  String formatStorageSize(int bytes) {
    if (bytes <= 0) return '0 ${AppStrings.bytes}';

    final units = [
      AppStrings.bytes,
      AppStrings.kilobytes,
      AppStrings.megabytes,
      AppStrings.gigabytes,
      AppStrings.terabytes,
    ];

    double size = bytes.toDouble();
    int unitIndex = 0;

    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024;
      unitIndex++;
    }

    return '${size.toStringAsFixed(2)} ${units[unitIndex]}';
  }

  @override
void onInit() {
  super.onInit();
  loadDashboardData();
}

  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;

      await _categoryRepository.initializeDefaultCategories();

      final total = await _repository.getTotalCount();
      final processed = await _repository.getProcessedCount();
      final screenshots = await _repository.getAllScreenshots();
      final categories = await _categoryRepository.getAllCategories();

      totalScreenshots.value = total;
      processedScreenshots.value = processed;

      recentScreenshots.assignAll(screenshots.take(5).toList());

      final counts = <String, int>{};

      for (final CategoryModel category in categories) {
        final id = category.id;
        if (id == null) continue;

        counts[category.name] = await _repository.getCountByCategory(id);
      }

      categoryCounts.assignAll(counts);

      await _loadStorageAnalytics(screenshots, categories);
    } catch (error) {
      // Keep the dashboard available if loading fails.
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadStorageAnalytics(
    List<ScreenshotModel> screenshots,
    List<CategoryModel> categories,
  ) async {
    int totalBytes = 0;

    final categoryBytes = <int, int>{};
    final screenshotSizes = <DashboardScreenshotStorage>[];

    final categoryNames = <int, String>{
      for (final category in categories)
        if (category.id != null) category.id!: category.name,
    };

    for (final screenshot in screenshots) {
      try {
        final bytes = await FileUtils.getFileSize(screenshot.imagePath);

        // Ignore missing image files.
        if (bytes <= 0) continue;

        totalBytes += bytes;

        final categoryId = screenshot.categoryId;

        if (categoryId != null) {
          categoryBytes[categoryId] = (categoryBytes[categoryId] ?? 0) + bytes;
        }

        screenshotSizes.add(
          DashboardScreenshotStorage(
            screenshot: screenshot,
            sizeBytes: bytes,
            categoryName: categoryNames[categoryId] ?? AppStrings.uncategorized,
          ),
        );
      } catch (error) {
        // Skip inaccessible image files.
      }
    }

    totalStorageBytes.value = totalBytes;

    categoryStorage.assignAll(
      categoryBytes.entries.map((entry) {
        return DashboardCategoryStorage(
          categoryName: categoryNames[entry.key] ?? 'Uncategorized',
          sizeBytes: entry.value,
        );
      }).toList()..sort((a, b) => b.sizeBytes.compareTo(a.sizeBytes)),
    );

    screenshotSizes.sort((a, b) => b.sizeBytes.compareTo(a.sizeBytes));

    largestScreenshots.assignAll(screenshotSizes.take(3));
  }

  int getCategoryCount(String categoryName) {
    return categoryCounts[categoryName] ?? 0;
  }

  Future<void> openCategories() async {
    await Get.toNamed(AppRoutes.categories);
    await loadDashboardData();
  }

  Future<void> openCategory(String categoryName) async {
    try {
      final category = await _categoryRepository.getCategoryByName(
        categoryName,
      );

      if (category?.id == null) return;

      Get.find<ScreenshotsController>().selectCategoryById(
        category!.id!,
        category.name,
      );

      Get.find<MainNavigationController>().changeTab(1);
    } catch (error) {
      // Keep the dashboard available if navigation fails.
    }
  }

  void openAllScreenshots() {
    Get.find<ScreenshotsController>().clearFilters();
    Get.find<MainNavigationController>().changeTab(1);
  }

  Future<void> importScreenshots() async {
    await Get.toNamed(AppRoutes.importScreenshots);
    await loadDashboardData();
  }

  void openSettings() {
    // Settings navigation will be connected later.
  }
}

class DashboardCategoryStorage {
  final String categoryName;
  final int sizeBytes;

  DashboardCategoryStorage({
    required this.categoryName,
    required this.sizeBytes,
  });
}

class DashboardScreenshotStorage {
  final ScreenshotModel screenshot;
  final int sizeBytes;
  final String categoryName;

  DashboardScreenshotStorage({
    required this.screenshot,
    required this.sizeBytes,
    required this.categoryName,
  });
}

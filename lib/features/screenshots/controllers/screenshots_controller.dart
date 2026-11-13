import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snaptrieve/features/dashboard/controllers/dashboard_controller.dart';

import '../../../core/utils/file_utils.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/screenshot_model.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../data/repositories/screenshot_repository.dart';

class ScreenshotsController extends GetxController {
  final ScreenshotRepository _repository = Get.find<ScreenshotRepository>();

  final CategoryRepository _categoryRepository = Get.find<CategoryRepository>();

  final searchController = TextEditingController();

  final PageController categoryPageController = PageController();

  // Keys allow the selected category chip to scroll into view.
  final List<GlobalKey> categoryKeys = List.generate(
    categories.length,
    (_) => GlobalKey(),
  );

  final RxList<ScreenshotModel> screenshots = <ScreenshotModel>[].obs;

  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = AppStrings.all.obs;
  final RxString sortOrder = AppStrings.newestFirst.obs;

  final RxInt selectedCategoryId = 0.obs;
  final RxInt selectedCategoryIndex = 0.obs;

  final RxBool isLoading = false.obs;
  final RxBool isSelectionMode = false.obs;

  final RxSet<String> selectedScreenshotIds = <String>{}.obs;

  static const List<String> categories = [
    AppStrings.all,
    AppStrings.links,
    AppStrings.emails,
    AppStrings.contacts,
    AppStrings.datesEvents,
    AppStrings.generalText,
    AppStrings.uncategorized,
  ];

  final Map<String, int> _categoryIdsByName = {};

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    // Load screenshots first so category initialization
    // cannot prevent screenshots from appearing.
    await loadScreenshots();

    try {
      await _categoryRepository.initializeDefaultCategories();

      final loadedCategories = await _categoryRepository.getAllCategories();

      _categoryIdsByName.clear();

      for (final CategoryModel category in loadedCategories) {
        final id = category.id;

        if (id != null) {
          _categoryIdsByName[category.name] = id;
        }
      }

      if (selectedCategory.value != AppStrings.all) {
        selectedCategoryId.value =
            _categoryIdsByName[selectedCategory.value] ?? 0;
      }
    } catch (error, stackTrace) {
      debugPrint('Category initialization error: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> loadScreenshots() async {
    try {
      isLoading.value = true;

      debugPrint('========== SCREENSHOTS LOADING ==========');

      final result = await _repository.getAllScreenshots();

      debugPrint('DATABASE RESULT: ${result.length}');

      screenshots.assignAll(result);

      debugPrint('CONTROLLER LIST: ${screenshots.length}');

      debugPrint('ALL FILTER RESULT: ${getScreenshotsForCategory(0).length}');

      debugPrint('=========================================');
    } catch (error, stackTrace) {
      debugPrint('Load screenshots error: $error');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      isLoading.value = false;
    }
  }

  List<ScreenshotModel> get filteredScreenshots {
    return getScreenshotsForCategory(selectedCategoryIndex.value);
  }

  List<ScreenshotModel> getScreenshotsForCategory(int index) {
    var result = screenshots.toList();

    final query = searchQuery.value.trim().toLowerCase();

    if (query.isNotEmpty) {
      result = result.where((screenshot) {
        return screenshot.extractedText.toLowerCase().contains(query);
      }).toList();
    }

    if (index > 0 && index < categories.length) {
      final categoryName = categories[index];
      final categoryId = _categoryIdsByName[categoryName];

      if (categoryId == null) {
        return [];
      }

      result = result
          .where((screenshot) => screenshot.categoryId == categoryId)
          .toList();
    }

    if (sortOrder.value == AppStrings.oldestFirst) {
      result.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    } else {
      result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }

    return result;
  }

  void updateSearch(String value) {
    searchQuery.value = value;
  }

  void selectCategory(String category) {
    final index = categories.indexOf(category);
    if (index < 0) return;

    _updateSelectedCategory(index);

    if (categoryPageController.hasClients) {
      categoryPageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  void selectCategoryById(int categoryId, String categoryName) {
    final index = categories.indexOf(categoryName);
    if (index < 0) return;

    selectedCategoryId.value = categoryId;
    _updateSelectedCategory(index);

    if (categoryPageController.hasClients) {
      categoryPageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  void onCategoryPageChanged(int index) {
    _updateSelectedCategory(index);
  }

  void _updateSelectedCategory(int index) {
    if (index < 0 || index >= categories.length) return;

    selectedCategoryIndex.value = index;
    selectedCategory.value = categories[index];

    if (index == 0) {
      selectedCategoryId.value = 0;
    } else {
      selectedCategoryId.value = _categoryIdsByName[categories[index]] ?? 0;
    }

    _scrollToSelectedCategory(index);
  }

  void startSelection(ScreenshotModel screenshot) {
    isSelectionMode.value = true;
    toggleScreenshotSelection(screenshot);
  }

  void toggleScreenshotSelection(ScreenshotModel screenshot) {
    final id = screenshot.id;
    if (id == null) return;

    final selectionId = id.toString();

    if (selectedScreenshotIds.contains(selectionId)) {
      selectedScreenshotIds.remove(selectionId);
    } else {
      selectedScreenshotIds.add(selectionId);
    }

    if (selectedScreenshotIds.isEmpty) {
      isSelectionMode.value = false;
    }
  }

  void selectAllScreenshots(List<ScreenshotModel> items) {
    if (items.isEmpty) {
      exitSelectionMode();
      return;
    }

    selectedScreenshotIds.clear();

    for (final screenshot in items) {
      final id = screenshot.id;

      if (id != null) {
        selectedScreenshotIds.add(id.toString());
      }
    }

    isSelectionMode.value = selectedScreenshotIds.isNotEmpty;
  }

  void exitSelectionMode() {
    selectedScreenshotIds.clear();
    isSelectionMode.value = false;
  }

  Future<bool> deleteSelectedScreenshots() async {
    if (selectedScreenshotIds.isEmpty || isLoading.value) {
      return false;
    }

    try {
      isLoading.value = true;

      final ids = selectedScreenshotIds
          .map(int.tryParse)
          .whereType<int>()
          .toList();

      if (ids.isEmpty) return false;

      final screenshotsToDelete = screenshots
          .where(
            (screenshot) =>
                screenshot.id != null && ids.contains(screenshot.id),
          )
          .toList();

      final deletedCount = await _repository.deleteScreenshots(ids);

      if (deletedCount == 0) return false;

      // Remove deleted screenshots from the current reactive list.
      screenshots.removeWhere(
        (screenshot) => screenshot.id != null && ids.contains(screenshot.id),
      );

      exitSelectionMode();

      // Clean up image files.
      for (final screenshot in screenshotsToDelete) {
        try {
          await FileUtils.deleteImage(screenshot.imagePath);
        } catch (_) {
          // Continue if an individual image cannot be deleted.
        }
      }

      // Refresh dashboard.
      if (Get.isRegistered<DashboardController>()) {
        await Get.find<DashboardController>().loadDashboardData();
      }

      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Automatically scroll the selected filter chip into view.
  void _scrollToSelectedCategory(int index) {
    if (index < 0 || index >= categoryKeys.length) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final targetContext = categoryKeys[index].currentContext;

      if (targetContext == null) return;

      Scrollable.ensureVisible(
        targetContext,
        alignment: 0.5,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  void changeSortOrder(String order) {
    sortOrder.value = order;
  }

  void clearFilters() {
    searchController.clear();
    searchQuery.value = '';
    sortOrder.value = AppStrings.newestFirst;

    _updateSelectedCategory(0);

    if (categoryPageController.hasClients) {
      categoryPageController.jumpToPage(0);
    }
  }

  Future<void> importScreenshots() async {
    await Get.toNamed(AppRoutes.importScreenshots);
    await loadScreenshots();
  }

  @override
  void onClose() {
    searchController.dispose();
    categoryPageController.dispose();
    super.onClose();
  }
}

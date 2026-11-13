import 'package:get/get.dart';

import '../../../data/models/category_model.dart';
import '../../../data/repositories/category_repository.dart';
import '../../../data/repositories/screenshot_repository.dart';

class CategoriesController extends GetxController {
  final CategoryRepository _categoryRepository = Get.find<CategoryRepository>();

  final ScreenshotRepository _screenshotRepository =
      Get.find<ScreenshotRepository>();

  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxMap<int, int> categoryCounts = <int, int>{}.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadCategories();
  }

  Future<void> loadCategories() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      await _categoryRepository.initializeDefaultCategories();

      final loadedCategories = await _categoryRepository.getAllCategories();

      categories.assignAll(loadedCategories);

      final counts = <int, int>{};

      for (final category in loadedCategories) {
        final id = category.id;
        if (id == null) continue;

        counts[id] = await _screenshotRepository.getCountByCategory(id);
      }

      categoryCounts.assignAll(counts);
    } catch (error) {
      errorMessage.value = error.toString();
    } finally {
      isLoading.value = false;
    }
  }

  int getCount(CategoryModel category) {
    final id = category.id;
    if (id == null) return 0;

    return categoryCounts[id] ?? 0;
  }
}

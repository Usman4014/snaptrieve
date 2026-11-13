import 'package:get/get.dart';

import '../../core/services/ocr_service.dart';
import '../../data/database/app_database.dart';
import '../../data/datasources/local/category_local_datasource.dart';
import '../../data/datasources/local/screenshot_local_datasource.dart';
import '../../data/repositories/category_repository.dart';
import '../../data/repositories/screenshot_repository.dart';
import '../../core/services/category_detection_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Database
    Get.put<AppDatabase>(AppDatabase.instance, permanent: true);

    // Screenshot Data Source
    Get.lazyPut<ScreenshotLocalDatasource>(
      () => ScreenshotLocalDatasource(appDatabase: Get.find<AppDatabase>()),
      fenix: true,
    );

    // Screenshot Repository
    Get.lazyPut<ScreenshotRepository>(
      () => ScreenshotRepository(
        localDatasource: Get.find<ScreenshotLocalDatasource>(),
      ),
      fenix: true,
    );

    // Category Data Source
    Get.lazyPut<CategoryLocalDatasource>(
      () => CategoryLocalDatasource(appDatabase: Get.find<AppDatabase>()),
      fenix: true,
    );

    // Category Repository
    Get.lazyPut<CategoryRepository>(
      () => CategoryRepository(
        localDatasource: Get.find<CategoryLocalDatasource>(),
      ),
      fenix: true,
    );

    // Category Detection Service
    Get.lazyPut<CategoryDetectionService>(
      () => CategoryDetectionService(
        categoryRepository: Get.find<CategoryRepository>(),
      ),
      fenix: true,
    );

    // OCR Service
    Get.put<OcrService>(OcrService(), permanent: true);

    // Initialize Default Categories
    _initializeCategories();
  }

  Future<void> _initializeCategories() async {
    try {
      await Get.find<CategoryRepository>().initializeDefaultCategories();
    } catch (error) {
      // Category initialization can be retried later.
    }
  }
}

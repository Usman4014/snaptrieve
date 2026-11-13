import 'package:get/get.dart';

import '../controllers/import_screenshots_controller.dart';

class ImportScreenshotsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImportScreenshotsController>(
      () => ImportScreenshotsController(),
    );
  }
}

import 'package:get/get.dart';

import '../controllers/screenshots_controller.dart';

class ScreenshotsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScreenshotsController>(() => ScreenshotsController());
  }
}

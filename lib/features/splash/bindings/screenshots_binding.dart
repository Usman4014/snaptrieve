import 'package:get/get.dart';
import 'package:snaptrieve/features/screenshots/controllers/screenshots_controller.dart';

class ScreenshotsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScreenshotsController>(() => ScreenshotsController());
  }
}

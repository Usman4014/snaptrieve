import 'package:get/get.dart';

import '../controllers/screenshot_details_controller.dart';

class ScreenshotDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScreenshotDetailsController>(
      () => ScreenshotDetailsController(),
    );
  }
}

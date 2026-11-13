import 'package:get/get.dart';

import '../../features/screenshots/controllers/screenshots_controller.dart';
import '../../features/dashboard/controllers/dashboard_controller.dart';
import '../../features/settings/controllers/settings_controller.dart';

class MainNavigationController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  void changeTab(int index) {
    selectedIndex.value = index;

    if (index == 0 && Get.isRegistered<DashboardController>()) {
      Get.find<DashboardController>().loadDashboardData();
    }

    if (index == 1 && Get.isRegistered<ScreenshotsController>()) {
      Get.find<ScreenshotsController>().loadScreenshots();
    }

    if (index == 2 && Get.isRegistered<SettingsController>()) {
      Get.find<SettingsController>().loadStorageInfo();
    }
  }
}

import 'package:get/get.dart';

import '../features/dashboard/bindings/dashboard_binding.dart';
import '../features/screenshots/bindings/screenshots_binding.dart';
import '../features/settings/bindings/settings_binding.dart';
import 'main_navigation_controller.dart';

class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MainNavigationController>(MainNavigationController());

    DashboardBinding().dependencies();
    ScreenshotsBinding().dependencies();
    SettingsBinding().dependencies();
  }
}

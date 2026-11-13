import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../features/dashboard/views/dashboard_view.dart';
import '../features/screenshots/views/screenshots_view.dart';
import '../features/settings/views/settings_view.dart';
import 'main_navigation_controller.dart';
import 'widgets/bottom_navigation_bar.dart';

class MainNavigationView extends GetView<MainNavigationController> {
  const MainNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: const [DashboardView(), ScreenshotsView(), SettingsView()],
        ),
      ),
      bottomNavigationBar: Obx(
        () => AppBottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTab,
        ),
      ),
    );
  }
}

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../app/routes/app_routes.dart';
import '../../../core/constants/storage_keys.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    navigateToNextScreen();
  }

  Future<void> navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));

    final preferences = await SharedPreferences.getInstance();

    final hasCompletedOnboarding =
        preferences.getBool(StorageKeys.hasCompletedOnboarding) ?? false;

    Get.offAllNamed(
      hasCompletedOnboarding ? AppRoutes.dashboard : AppRoutes.onboarding,
    );
  }
}

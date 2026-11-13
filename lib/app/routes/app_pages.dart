import 'package:get/get.dart';

import '../../features/splash/views/splash_view.dart';
import '../../features/splash/bindings/splash_binding.dart';

import '../../features/onboarding/views/onboarding_view.dart';
import '../../features/onboarding/bindings/onboarding_binding.dart';

import '../../features/screenshots/bindings/screenshot_details_binding.dart';
import '../../features/screenshots/views/screenshot_details_view.dart';

import '../../features/categories/views/categories_view.dart';
import '../../features/categories/bindings/categories_binding.dart';

import '../../features/import_screenshots/bindings/import_screenshots_binding.dart';
import '../../features/import_screenshots/views/import_screenshots_view.dart';

import '../../features/settings/views/privacy_data_view.dart';
import '../../features/settings/views/about_snaptrieve_view.dart';

import '../../navigation/main_navigation_view.dart';
import '../../navigation/main_navigation_binding.dart';

import 'app_routes.dart';

class AppPages {
  AppPages._();

  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => OnboardingView(
        onCompleted: () {
          Get.offAllNamed(AppRoutes.dashboard);
        },
      ),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.screenshotDetails,
      page: () => const ScreenshotDetailsView(),
      binding: ScreenshotDetailsBinding(),
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const MainNavigationView(),
      binding: MainNavigationBinding(),
    ),
    GetPage(
      name: AppRoutes.categories,
      page: () => const CategoriesView(),
      binding: CategoriesBinding(),
    ),
    GetPage(
      name: AppRoutes.importScreenshots,
      page: () => const ImportScreenshotsView(),
      binding: ImportScreenshotsBinding(),
    ),
    GetPage(name: AppRoutes.privacyData, page: () => const PrivacyDataView()),
    GetPage(
      name: AppRoutes.aboutSnaptrieve,
      page: () => const AboutSnaptrieveView(),
    ),
  ];
}

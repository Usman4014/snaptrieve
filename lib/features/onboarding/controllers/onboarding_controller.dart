import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/storage_keys.dart';

class OnboardingController extends GetxController {
  final PageController pageController = PageController();

  final RxInt currentPage = 0.obs;

  static const int totalPages = 3;

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  Future<void> nextPage() async {
    if (currentPage.value < totalPages - 1) {
      await pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> completeOnboarding() async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setBool(StorageKeys.hasCompletedOnboarding, true);
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}

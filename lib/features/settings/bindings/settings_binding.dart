import 'package:get/get.dart';

import '../../../core/services/backup_service.dart';
import '../../../data/repositories/screenshot_repository.dart';
import '../controllers/settings_controller.dart';

class SettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(
      () => SettingsController(
        Get.find<ScreenshotRepository>(),
        BackupService.instance,
      ),
    );
  }
}

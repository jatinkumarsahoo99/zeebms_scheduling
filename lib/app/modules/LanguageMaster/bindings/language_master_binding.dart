import 'package:get/get.dart';

import '../controllers/language_master_controller.dart';

class LanguageMasterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LanguageMasterController>(
      () => LanguageMasterController(),
    );
  }
}

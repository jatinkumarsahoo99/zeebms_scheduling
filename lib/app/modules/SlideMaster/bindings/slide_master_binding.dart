import 'package:get/get.dart';

import '../controllers/slide_master_controller.dart';

class SlideMasterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SlideMasterController>(
      () => SlideMasterController(),
    );
  }
}

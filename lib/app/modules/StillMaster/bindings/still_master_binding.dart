import 'package:get/get.dart';

import '../controllers/still_master_controller.dart';

class StillMasterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StillMasterController>(
      () => StillMasterController(),
    );
  }
}

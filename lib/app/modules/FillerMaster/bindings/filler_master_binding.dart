import 'package:get/get.dart';

import '../controllers/filler_master_controller.dart';

class FillerMasterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FillerMasterController>(
      () => FillerMasterController(),
    );
  }
}

import 'package:get/get.dart';

import '../controllers/commercial_master_controller.dart';

class CommercialMasterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CommercialMasterController>(
      () => CommercialMasterController(),
    );
  }
}

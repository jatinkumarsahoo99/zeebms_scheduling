import 'package:get/get.dart';

import '../controllers/spot_position_type_master_controller.dart';

class SpotPositionTypeMasterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SpotPositionTypeMasterController>(
      () => SpotPositionTypeMasterController(),
    );
  }
}

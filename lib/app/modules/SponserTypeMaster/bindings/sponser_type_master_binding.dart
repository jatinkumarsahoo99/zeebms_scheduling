import 'package:get/get.dart';

import '../controllers/sponser_type_master_controller.dart';

class SponserTypeMasterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SponserTypeMasterController>(
      () => SponserTypeMasterController(),
    );
  }
}

import 'package:get/get.dart';

import '../controllers/secondary_event_master_controller.dart';

class SecondaryEventMasterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SecondaryEventMasterController>(
      () => SecondaryEventMasterController(),
    );
  }
}

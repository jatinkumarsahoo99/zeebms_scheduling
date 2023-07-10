import 'package:get/get.dart';

import '../controllers/commercial_time_update_controller.dart';

class CommercialTimeUpdateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CommercialTimeUpdateController>(
      () => CommercialTimeUpdateController(),
    );
  }
}

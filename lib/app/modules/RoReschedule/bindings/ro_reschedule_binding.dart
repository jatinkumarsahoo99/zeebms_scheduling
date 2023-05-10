import 'package:get/get.dart';

import '../controllers/ro_reschedule_controller.dart';

class RoRescheduleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RoRescheduleController>(
      () => RoRescheduleController(),
    );
  }
}

import 'package:get/get.dart';

import '../controllers/transmission_log_controller.dart';

class TransmissionLogBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TransmissionLogController>(
      () => TransmissionLogController(),
    );
  }
}

import 'package:get/get.dart';

import '../controllers/TransmissionLogController.dart';

class TransmissionLogBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TransmissionLogController>(
      TransmissionLogController(),
    );
  }
}

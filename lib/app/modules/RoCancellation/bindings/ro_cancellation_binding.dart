import 'package:get/get.dart';

import '../controllers/ro_cancellation_controller.dart';

class RoCancellationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RoCancellationController>(
      () => RoCancellationController(),
    );
  }
}

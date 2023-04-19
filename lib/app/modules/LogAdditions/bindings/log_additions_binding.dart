import 'package:get/get.dart';

import '../controllers/log_additions_controller.dart';

class LogAdditionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LogAdditionsController>(
      () => LogAdditionsController(),
    );
  }
}

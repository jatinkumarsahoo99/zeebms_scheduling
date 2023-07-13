import 'package:get/get.dart';

import '../controllers/log_convert_controller.dart';

class LogConvertBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LogConvertController>(
      () => LogConvertController(),
    );
  }
}

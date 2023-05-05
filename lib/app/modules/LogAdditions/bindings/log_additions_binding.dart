import 'package:get/get.dart';

import '../controllers/LogAdditionsController.dart';

class LogAdditionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LogAdditionsController>(
      () => LogAdditionsController(),
    );
  }
}

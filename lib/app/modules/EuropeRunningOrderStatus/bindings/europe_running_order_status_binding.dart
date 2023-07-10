import 'package:get/get.dart';

import '../controllers/EuropeRunningOrderStatusController.dart';

class EuropeRunningOrderStatusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EuropeRunningOrderStatusController>(
      () => EuropeRunningOrderStatusController(),
    );
  }
}

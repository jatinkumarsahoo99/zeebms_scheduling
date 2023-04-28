import 'package:get/get.dart';

import '../controllers/SpotPriorityController.dart';

class SpotPriorityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SpotPriorityController>(
      () => SpotPriorityController(),
    );
  }
}

import 'package:get/get.dart';

import '../controllers/commercial_controller.dart';

class CommercialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CommercialController>(
      () => CommercialController(),
    );
  }
}

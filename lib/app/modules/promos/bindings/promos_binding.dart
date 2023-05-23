import 'package:get/get.dart';

import '../controllers/promos_controller.dart';

class PromosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PromosController>(
      () => PromosController(),
    );
  }
}

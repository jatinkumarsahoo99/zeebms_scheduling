import 'package:get/get.dart';

import '../controllers/mam_work_orders_controller.dart';

class MamWorkOrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MamWorkOrdersController>(
      () => MamWorkOrdersController(),
    );
  }
}

import 'package:get/get.dart';

import '../controllers/inventory_status_report_controller.dart';

class InventoryStatusReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InventoryStatusReportController>(
      () => InventoryStatusReportController(),
    );
  }
}

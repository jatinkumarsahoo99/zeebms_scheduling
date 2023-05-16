import 'package:get/get.dart';

import '../controllers/sales_audit_new_controller.dart';

class SalesAuditNewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SalesAuditNewController>(
      () => SalesAuditNewController(),
    );
  }
}

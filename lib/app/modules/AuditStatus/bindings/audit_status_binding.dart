import 'package:get/get.dart';

import '../controllers/audit_status_controller.dart';

class AuditStatusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuditStatusController>(
      () => AuditStatusController(),
    );
  }
}

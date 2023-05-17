import 'package:get/get.dart';

import '../controllers/final_audit_report_after_telecast_controller.dart';

class FinalAuditReportAfterTelecastBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FinalAuditReportAfterTelecastController>(
      () => FinalAuditReportAfterTelecastController(),
    );
  }
}

import 'package:get/get.dart';

import '../controllers/final_audit_report_before_log_controller.dart';

class FinalAuditReportBeforeLogBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FinalAuditReportBeforeLogController>(
      () => FinalAuditReportBeforeLogController(),
    );
  }
}

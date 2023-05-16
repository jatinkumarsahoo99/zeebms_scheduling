import 'package:get/get.dart';

import '../controllers/sales_audit_extra_spots_report_controller.dart';

class SalesAuditExtraSpotsReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SalesAuditExtraSpotsReportController>(
      () => SalesAuditExtraSpotsReportController(),
    );
  }
}

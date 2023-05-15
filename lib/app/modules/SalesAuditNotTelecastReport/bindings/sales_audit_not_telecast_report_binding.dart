import 'package:get/get.dart';

import '../controllers/SalesAuditNotTelecastReportController.dart';

class SalesAuditNotTelecastReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SalesAuditNotTelecastReportController>(
      () => SalesAuditNotTelecastReportController(),
    );
  }
}

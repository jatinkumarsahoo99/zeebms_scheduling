import 'package:get/get.dart';

import '../controllers/date_wise_filler_report_controller.dart';

class DateWiseFillerReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DateWiseFillerReportController>(
      () => DateWiseFillerReportController(),
    );
  }
}

import 'package:get/get.dart';

import '../controllers/date_wise_error_spots_controller.dart';

class DateWiseErrorSpotsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DateWiseErrorSpotsController>(
      () => DateWiseErrorSpotsController(),
    );
  }
}

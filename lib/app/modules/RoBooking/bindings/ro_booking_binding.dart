import 'package:get/get.dart';

import '../controllers/ro_booking_controller.dart';

class RoBookingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RoBookingController>(
      () => RoBookingController(),
    );
  }
}

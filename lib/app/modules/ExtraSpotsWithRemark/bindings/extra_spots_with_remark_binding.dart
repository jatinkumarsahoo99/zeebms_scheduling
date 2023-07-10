import 'package:get/get.dart';

import '../controllers/extra_spots_with_remark_controller.dart';

class ExtraSpotsWithRemarkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ExtraSpotsWithRemarkController>(
      () => ExtraSpotsWithRemarkController(),
    );
  }
}

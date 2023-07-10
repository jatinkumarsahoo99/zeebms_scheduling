import 'package:get/get.dart';

import '../controllers/DSeriesSpecificationController.dart';

class DSeriesSpecificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DSeriesSpecificationController>(
      () => DSeriesSpecificationController(),
    );
  }
}

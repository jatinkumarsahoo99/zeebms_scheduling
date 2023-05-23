import 'package:get/get.dart';

import '../controllers/filler_controller.dart';

class FillerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FillerController>(
      () => FillerController(),
    );
  }
}

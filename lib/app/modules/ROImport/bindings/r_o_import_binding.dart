import 'package:get/get.dart';

import '../controllers/r_o_import_controller.dart';

class ROImportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ROImportController>(
      () => ROImportController(),
    );
  }
}

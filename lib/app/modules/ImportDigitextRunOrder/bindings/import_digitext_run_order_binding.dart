import 'package:get/get.dart';

import '../controllers/import_digitext_run_order_controller.dart';

class ImportDigitextRunOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImportDigitextRunOrderController>(
      () => ImportDigitextRunOrderController(),
    );
  }
}

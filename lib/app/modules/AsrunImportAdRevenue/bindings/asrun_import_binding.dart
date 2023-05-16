import 'package:get/get.dart';

import '../controllers/AsrunImportController.dart';

class AsrunImportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AsrunImportController>(
      () => AsrunImportController(),
    );
  }
}

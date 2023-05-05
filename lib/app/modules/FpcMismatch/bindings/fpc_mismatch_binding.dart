import 'package:get/get.dart';

import '../controllers/FpcMismatchController.dart';

class FpcMismatchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FpcMismatchController>(
      () => FpcMismatchController(),
    );
  }
}

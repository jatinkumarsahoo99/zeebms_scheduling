import 'package:get/get.dart';

import '../controllers/coming_up_menu_controller.dart';

class ComingUpMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ComingUpMenuController>(
      () => ComingUpMenuController(),
    );
  }
}

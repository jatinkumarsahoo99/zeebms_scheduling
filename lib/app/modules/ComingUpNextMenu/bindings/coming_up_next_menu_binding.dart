import 'package:get/get.dart';

import '../controllers/coming_up_next_menu_controller.dart';

class ComingUpNextMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ComingUpNextMenuController>(
      () => ComingUpNextMenuController(),
    );
  }
}

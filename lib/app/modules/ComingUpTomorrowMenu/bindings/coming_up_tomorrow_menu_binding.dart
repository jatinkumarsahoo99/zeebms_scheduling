import 'package:get/get.dart';

import '../controllers/coming_up_tomorrow_menu_controller.dart';

class ComingUpTomorrowMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ComingUpTomorrowMenuController>(
      () => ComingUpTomorrowMenuController(),
    );
  }
}

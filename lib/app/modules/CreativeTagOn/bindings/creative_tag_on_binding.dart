import 'package:get/get.dart';

import '../controllers/creative_tag_on_controller.dart';

class CreativeTagOnBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreativeTagOnController>(
      () => CreativeTagOnController(),
    );
  }
}

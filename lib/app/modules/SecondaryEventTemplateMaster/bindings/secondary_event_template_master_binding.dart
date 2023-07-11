import 'package:get/get.dart';

import '../controllers/secondary_event_template_master_controller.dart';

class SecondaryEventTemplateMasterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<SecondaryEventTemplateMasterController>(
      SecondaryEventTemplateMasterController(),
    );
  }
}

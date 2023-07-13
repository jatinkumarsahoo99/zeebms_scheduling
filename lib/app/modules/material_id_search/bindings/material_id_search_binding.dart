import 'package:get/get.dart';

import '../controllers/material_id_search_controller.dart';

class MaterialIdSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MaterialIdSearchController>(
      () => MaterialIdSearchController(),
    );
  }
}

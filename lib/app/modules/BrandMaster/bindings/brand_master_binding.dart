import 'package:get/get.dart';

import '../controllers/brand_master_controller.dart';

class BrandMasterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BrandMasterController>(
      () => BrandMasterController(),
    );
  }
}

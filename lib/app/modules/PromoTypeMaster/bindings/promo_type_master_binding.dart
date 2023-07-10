import 'package:get/get.dart';

import '../controllers/promo_type_master_controller.dart';

class PromoTypeMasterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PromoTypeMasterController>(
      () => PromoTypeMasterController(),
    );
  }
}

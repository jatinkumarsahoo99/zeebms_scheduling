import 'package:get/get.dart';

import '../controllers/promo_master_controller.dart';

class PromoMasterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PromoMasterController>(
      () => PromoMasterController(),
    );
  }
}

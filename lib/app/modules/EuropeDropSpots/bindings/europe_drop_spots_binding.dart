import 'package:get/get.dart';

import '../controllers/EuropeDropSpotsController.dart';

class EuropeDropSpotsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EuropeDropSpotsController>(
      () => EuropeDropSpotsController(),
    );
  }
}

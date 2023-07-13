import 'package:get/get.dart';

import '../controllers/EuropeCommercialImportStatusController.dart';

class EuropeCommercialImportStatusBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EuropeCommercialImportStatusController>(
      () => EuropeCommercialImportStatusController(),
    );
  }
}

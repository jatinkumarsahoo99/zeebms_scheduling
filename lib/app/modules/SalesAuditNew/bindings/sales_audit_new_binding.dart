import 'package:get/get.dart';

import '../controllers/SalesAuditNewController.dart';

class SalesAuditNewBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SalesAuditNewController>(
      () => SalesAuditNewController(),
    );
  }
}

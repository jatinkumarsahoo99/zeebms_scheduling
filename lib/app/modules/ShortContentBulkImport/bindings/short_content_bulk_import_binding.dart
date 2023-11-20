import 'package:get/get.dart';

import '../controllers/short_content_bulk_import_controller.dart';

class ShortContentBulkImportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShortContentBulkImportController>(
      () => ShortContentBulkImportController(),
    );
  }
}

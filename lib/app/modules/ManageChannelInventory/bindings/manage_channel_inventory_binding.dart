import 'package:get/get.dart';

import '../controllers/manage_channel_inventory_controller.dart';

class ManageChannelInventoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManageChannelInvemtoryController>(
      () => ManageChannelInvemtoryController(),
    );
  }
}

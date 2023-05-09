import 'package:get/get.dart';

import '../controllers/ros_distribution_controller.dart';

class RosDistributionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RosDistributionController>(
      () => RosDistributionController(),
    );
  }
}

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../controller/ConnectorControl.dart';
import '../controller/HomeController.dart';
import '../controller/MainController.dart';

class BinderData implements Bindings {
  @override
  void dependencies() {
    Get.put<MainController>(MainController(), permanent: true);
    Get.put<ConnectorControl>(ConnectorControl(), permanent: true);
    Get.put<HomeController>(HomeController(), permanent: true);
  }
}

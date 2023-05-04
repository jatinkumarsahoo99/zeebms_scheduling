import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/controller/MainController.dart';
import '../../widgets/LoadingScreen.dart';
import '../../widgets/NoDataFoundPage.dart';

class AuthGuard extends StatelessWidget {
  final Widget child;

  AuthGuard({required this.child}) {
    assert(this.child != null);
  }

  Widget? currentWidget;

  @override
  Widget build(BuildContext context) {
    return GetX<MainController>(
      // init: Get.find<MainController>(),
      init: MainController(),
      initState: (c) {
        // Get.find<MainController>().checkSession2();
        // Get.find<MainController>().checkSession();
      },
      builder: (controller) {
        print("Login value>>" + controller.loginVal.value.toString());
        if (controller.loginVal.value == null ||
            controller.loginVal.value == 0) {
          currentWidget = const LoadingScreen();
          return currentWidget!;
        } else if (controller.loginVal.value == 1) {
          currentWidget = child;
        } else if (controller.loginVal.value == 2) {
          currentWidget = const NoDataFoundPage();
        } else {
          currentWidget = const LoadingScreen();
        }
        return currentWidget!;
      },
    );
  }
}

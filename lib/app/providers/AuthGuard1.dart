import 'package:bms_scheduling/app/controller/MainController.dart';
import 'package:bms_scheduling/app/modules/FpcMismatch/views/FpcMismatchView.dart';
import 'package:bms_scheduling/app/modules/ImportDigitextRunOrder/views/import_digitext_run_order_view.dart';
import 'package:bms_scheduling/app/modules/LogAdditions/controllers/LogAdditionsController.dart';
import 'package:bms_scheduling/app/modules/RoCancellation/views/ro_cancellation_view.dart';
import 'package:bms_scheduling/app/modules/filler/views/filler_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/LoadingScreen.dart';
import '../../widgets/NoDataFoundPage.dart';
import '../modules/LogAdditions/views/LogAdditionsView.dart';
import '../modules/TransmissionLog/views/TransmissionLogView.dart';
import '../modules/home/views/home_view.dart';
import '../routes/app_pages.dart';

class AuthGuard1 extends StatelessWidget {
  final String childName;

  AuthGuard1({required this.childName}) {
    assert(this.childName != null);
  }

  Widget? currentWidget;

  @override
  Widget build(BuildContext context) {
    return GetX<MainController>(
      init: Get.find<MainController>(),
      // init: MainController(),
      initState: (c) {
        // Get.find<MainController>().checkSession2();
        Get.find<MainController>().checkSessionFromParams();
      },
      builder: (controller) {
        print("Login value>>" + controller.loginVal.value.toString());
        if (controller.loginVal.value == 1) {
          switch (childName) {
            case Routes.HOME:
              currentWidget = HomeView();
              break;
            case Routes.TRANSMISSION_LOG:
              currentWidget = TransmissionLogView();
              break;
            case Routes.RO_CANCELLATION:
              currentWidget = RoCancellationView();
              break;
            case Routes.LOG_ADDITIONS:
              currentWidget = LogAdditionsView();
              break;
            case Routes.FPC_MISMATCH:
              currentWidget = FpcMismatchView();
              break;
            case Routes.IMPORT_DIGITEXT_RUN_ORDER:
              currentWidget = ImportDigitextRunOrderView();
              break;
            case Routes.FILLER:
              currentWidget=FillerView();
              break;
            default:
              currentWidget = const NoDataFoundPage();
          }
          // currentWidget = child;
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

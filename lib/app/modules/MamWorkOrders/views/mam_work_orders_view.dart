import 'package:bms_scheduling/app/controller/HomeController.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/FormButton.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../data/PermissionModel.dart';
import '../../../providers/Utils.dart';
import '../controllers/mam_work_orders_controller.dart';
import 'cancel_wo_view.dart';
import 'release_wo_non_fpc_view.dart';
import 'wo_as_per_daily_fpc_view.dart';
import 'wo_history_view.dart';
import 'wo_repush_view.dart';

class MamWorkOrdersView extends GetView<MamWorkOrdersController> {
  const MamWorkOrdersView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          /// Tabs
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Obx(() {
              return CupertinoSlidingSegmentedControl(
                  thumbColor: CupertinoColors.white,
                  groupValue: controller.selectedTab.value,
                  children: Map.fromEntries(controller.mainTabs.map((e) => MapEntry(e, Text(e)))),
                  onValueChanged: (value) {
                    controller.pageController.jumpToPage(controller.mainTabs.indexWhere((element) {
                      if (element == value) {
                        controller.selectedTab.value = element;
                        return true;
                      } else {
                        return false;
                      }
                    }));
                  });
            }),
          ),

          /// tab views
          Expanded(
              child: Card(
            margin: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.zero, bottom: Radius.circular(8))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: PageView(
                controller: controller.pageController,
                children: [
                  ReleaseWoNonFpcView(controller),
                  WoAsPerDailyFpcView(controller),
                  WoRepushView(controller),
                  CancelWoView(controller),
                  WoHistoryView(controller),
                ],
              ),
            ),
          )),
          GetBuilder<HomeController>(
              id: "buttons",
              init: Get.find<HomeController>(),
              builder: (btncontroller) {
                /* PermissionModel formPermissions = Get.find<MainController>()
                      .permissionList!
                      .lastWhere((element) {
                    return element.appFormName == "frmSegmentsDetails";
                  });*/

                if (btncontroller.buttons != null) {
                  return Container(
                    height: 40,
                    child: ButtonBar(
                      // buttonHeight: 20,
                      alignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      // pa
                      children: [
                        for (var btn in btncontroller.buttons!)
                          btn["name"] == "Save"
                              ? Obx(() => FormButtonWrapper(
                                    btnText: btn["name"],

                                    // isEnabled: btn['isDisabled'],
                                    callback: () {},
                                  ))
                              : btn["name"] == "Clear"
                                  ? FormButtonWrapper(
                                      btnText: btn["name"],

                                      // isEnabled: btn['isDisabled'],
                                      callback: () {
                                        btncontroller.clearPage1();
                                      },
                                    )
                                  : FormButtonWrapper(
                                      btnText: btn["name"],

                                      // isEnabled: btn['isDisabled'],
                                      callback: null,
                                    ),
                      ],
                    ),
                  );
                }
                return Container();
              }),
        ],
      ),
    );
  }
}

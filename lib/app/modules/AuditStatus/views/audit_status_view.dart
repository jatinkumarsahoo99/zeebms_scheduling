import 'package:bms_scheduling/app/controller/HomeController.dart';
import 'package:bms_scheduling/app/modules/AuditStatus/views/audit_cancellatin_view.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/dummydata.dart';
import 'package:bms_scheduling/app/providers/ColorData.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../controller/MainController.dart';
import '../../../data/PermissionModel.dart';
import '../../../data/user_data_settings_model.dart';
import '../../../providers/Utils.dart';
import '../controllers/audit_status_controller.dart';

class AuditStatusView extends GetView<AuditStatusController> {
  AuditStatusController controller =
      Get.put<AuditStatusController>(AuditStatusController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Card(
            child: Container(
              padding: EdgeInsets.all(8),
              width: Get.width,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.end,
                spacing: 10,
                // buttonHeight: 20,
                alignment: WrapAlignment.start,
                children: [
                  Obx(
                    () => DropDownField.formDropDown1WidthMap(
                        controller.locations.value, (data) {
                      controller.selectLocation = data;
                      controller.getChannels(data.key);
                    }, "Location", 0.24, autoFocus: true),
                  ),
                  Obx(
                    () => DropDownField.formDropDown1WidthMap(
                        controller.channels.value, (data) {
                      controller.selectChannel = data;
                    }, "Channel", 0.24),
                  ),
                  DateWithThreeTextField(
                      title: "Date.",
                      widthRation: 0.12,
                      mainTextController: controller.dateController),
                  Obx(() => Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: controller.auditTypes
                            .map((e) => Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio(
                                        value: e,
                                        groupValue:
                                            controller.currentType.value,
                                        onChanged: (value) {
                                          controller.currentType.value = e;
                                        }),
                                    Text(e)
                                  ],
                                ))
                            .toList(),
                      )),
                  FormButtonWrapper(
                    btnText: "Show",
                    callback: () {
                      controller.showBtnData();
                    },
                  )
                ],
              ),
            ),
          ),
          Expanded(
              child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: GetBuilder<AuditStatusController>(
                id: "gridView",
                init: controller,
                builder: (gridcontroller) {
                  return gridcontroller.bookingData.isEmpty
                      ? Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)),
                        )
                      : DataGridShowOnlyKeys(
                          keysWidths: (controller.userDataSettings?.userSetting
                              ?.firstWhere(
                                  (element) =>
                                      element.controlName == "stateManager",
                                  orElse: () => UserSetting())
                              .userSettings),
                          mapData: gridcontroller.bookingData,
                          formatDate: false,
                          exportFileName: "Audit Status",
                          colorCallback: (colorEvent) {
                            return gridcontroller.getColor(
                                gridcontroller.bookingData[colorEvent.rowIdx],
                                colorEvent.rowIdx);
                          },
                          onload: (sm) {
                            controller.stateManager = sm.stateManager;
                          },
                          onRowDoubleTap: (event) {
                            if (controller.currentType.value == "Cancelation") {
                              controller.showECancel(event.rowIdx);
                            }
                            if (controller.currentType.value == "Addition") {
                              controller.showEbooking(event.rowIdx);
                            }
                            if (controller.currentType.value == "Reschedule") {
                              controller.showEReschdule(event.rowIdx);
                            }
                          },
                        );
                }),
          )),
          GetBuilder<HomeController>(
              id: "buttons",
              init: Get.find<HomeController>(),
              builder: (btncontroller) {
                PermissionModel formPermissions = Get.find<MainController>()
                    .permissionList!
                    .lastWhere((element) {
                  return element.appFormName == "frmNewBookingActivityReport";
                });
                if (btncontroller.buttons == null) {
                  return Container();
                }
                return Card(
                  margin: EdgeInsets.fromLTRB(4, 4, 4, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                  ),
                  child: Container(
                    width: Get.width,
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 10,
                      // buttonHeight: 20,
                      alignment: WrapAlignment.start,
                      // mainAxisSize: MainAxisSize.max,
                      // pa
                      children: [
                        for (var btn in btncontroller.buttons!)
                          FormButtonWrapper(
                            btnText: btn["name"],
                            // isEnabled: btn['isDisabled'],
                            callback: Utils.btnAccessHandler2(btn['name'],
                                        btncontroller, formPermissions) ==
                                    null
                                ? null
                                : () => btnHnadler(btn['name']),
                          ),
                      ],
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }

  btnHnadler(btnName) {
    switch (btnName) {
      case "Refresh":
        controller.showBtnData();
        break;
      case "Exit":
        Get.find<HomeController>().postUserGridSetting2(listStateManager: [
          {"stateManager": controller.stateManager},
        ]);
        break;
      case "Clear":
        Get.delete<AuditStatusController>();
        Get.find<HomeController>().clearPage1();
        break;
      default:
        break;
    }
  }
}

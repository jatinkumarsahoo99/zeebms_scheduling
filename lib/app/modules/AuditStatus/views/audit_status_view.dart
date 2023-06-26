import 'package:bms_scheduling/app/controller/HomeController.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/dummydata.dart';
import 'package:bms_scheduling/app/providers/ColorData.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/audit_status_controller.dart';

class AuditStatusView extends StatelessWidget {
  AuditStatusView({Key? key}) : super(key: key);
  AuditStatusController controller = Get.put(AuditStatusController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorData.scaffoldBg,
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
                    () => DropDownField.formDropDown1WidthMap(controller.locations.value, (data) {
                      controller.selectLocation = data;
                      controller.getChannels(data?.key);
                    }, "Location", 0.24),
                  ),
                  Obx(
                    () => DropDownField.formDropDown1WidthMap(controller.channels.value, (data) {
                      controller.selectChannel = data;
                    }, "Channel", 0.24),
                  ),
                  DateWithThreeTextField(title: "From Date.", widthRation: 0.12, mainTextController: controller.dateController),
                  Obx(() => Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: controller.auditTypes
                            .map((e) => Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio(
                                        value: e,
                                        groupValue: controller.currentType.value,
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
                      ? Container()
                      : DataGridShowOnlyKeys(
                          mapData: gridcontroller.bookingData,
                          formatDate: false,
                          colorCallback: (colorEvent) {
                            return gridcontroller.getColor(gridcontroller.bookingData[colorEvent.rowIdx]);
                          },
                          onRowDoubleTap: (event) {
                            controller.showEbooking(event.rowIdx);
                          },
                        );
                }),
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
                if (btncontroller.buttons == null) {
                  return Container();
                }
                return Card(
                  margin: EdgeInsets.fromLTRB(4, 4, 4, 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
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
                          btn["name"] == "Save"
                              ? FormButtonWrapper(
                                  btnText: btn["name"],

                                  // isEnabled: btn['isDisabled'],
                                  callback: () {},
                                )
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
                  ),
                );
              }),
        ],
      ),
    );
  }
}

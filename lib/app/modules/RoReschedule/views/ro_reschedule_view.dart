import 'package:bms_scheduling/app/controller/HomeController.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/dummydata.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/ro_reschedule_controller.dart';

class RoRescheduleView extends GetView<RoRescheduleController> {
  const RoRescheduleView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: GetBuilder<RoRescheduleController>(
            init: controller,
            id: "initData",
            builder: (controller) {
              if (controller.reschedulngInitData == null) {
                return Center(
                    child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Please Wait"),
                    SizedBox(
                      width: 20,
                    ),
                    CircularProgressIndicator()
                  ],
                ));
              } else {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      margin: EdgeInsets.all(Get.width * 0.005),
                      clipBehavior: Clip.hardEdge,
                      child: Container(
                        width: Get.width,
                        padding: EdgeInsets.all(Get.width * 0.005),
                        child: Wrap(
                          spacing: Get.width * 0.005,
                          runSpacing: 5,
                          children: [
                            DropDownField.formDropDown1WidthMap(
                                controller.reschedulngInitData!.lstlocationMaters!
                                    .map((e) => DropDownValue(key: e.locationCode, value: e.locationName))
                                    .toList(), (data) {
                              controller.selectedLocation = data;
                              controller.getChannel(data.key);
                            }, "Location", 0.24),
                            Obx(
                              // ignore: invalid_use_of_protected_member
                              () => DropDownField.formDropDown1WidthMap(
                                controller.channels.value,
                                (data) {
                                  controller.selectedChannel = data;
                                },
                                "Channel",
                                0.24,
                                selected: controller.selectedChannel,
                                isEnable: controller.enableFields.value,
                              ),
                            ),
                            Obx(
                              () => InputFields.formField1(
                                  focusNode: controller.toNumberFocus,
                                  isEnable: controller.enableFields.value,
                                  hintTxt: "T.O. No",
                                  controller: controller.tonumberCtrl,
                                  width: 0.24),
                            ),
                            Obx(
                              () => InputFields.formField1(
                                  hintTxt: "Client", isEnable: controller.enableFields.value, controller: controller.clientCtrl, width: 0.24),
                            ),
                            Obx(
                              () => InputFields.formField1(
                                  hintTxt: "Agency", isEnable: controller.enableFields.value, controller: controller.agencyCtrl, width: 0.24),
                            ),
                            Obx(
                              () => DateWithThreeTextField(
                                  title: "Eff Date.",
                                  isEnable: controller.enableFields.value,
                                  onFocusChange: (date) {
                                    controller.bookingMonthCtrl.text = date.split("-")[2] + date.split("-")[1];
                                  },
                                  widthRation: 0.24,
                                  mainTextController: controller.effDateCtrl),
                            ),
                            Obx(
                              () => InputFields.formField1(
                                  hintTxt: "Reference", isEnable: controller.enableFields.value, controller: controller.referenceCtrl, width: 0.24),
                            ),
                            Obx(
                              () => InputFields.formField1(
                                  hintTxt: "Brand", isEnable: controller.enableFields.value, controller: controller.branCtrl, width: 0.24),
                            ),
                            Obx(
                              () => DateWithThreeTextField(
                                  title: "Ref Date.",
                                  isEnable: controller.enableFields.value,
                                  widthRation: 0.24,
                                  mainTextController: controller.refDateCtrl),
                            ),
                            Obx(
                              () => InputFields.formField1(
                                  hintTxt: "Deal No", isEnable: controller.enableFields.value, controller: controller.delnoCtrl, width: 0.24),
                            ),
                            Obx(
                              () => InputFields.formField1(
                                  hintTxt: "Pay Route", isEnable: controller.enableFields.value, controller: controller.payrouteCtrl, width: 0.24),
                            ),
                            Obx(
                              () => DateWithThreeTextField(
                                  title: "B/K Date.",
                                  isEnable: controller.enableFields.value,
                                  widthRation: 0.24,
                                  mainTextController: controller.bkDateCtrl),
                            ),
                            Obx(
                              () => InputFields.formField1(
                                  hintTxt: "Zone", isEnable: controller.enableFields.value, controller: controller.zoneCtrl, width: 0.24),
                            ),
                            Obx(() => Container(
                                  width: Get.width * 0.24,
                                  child: Row(
                                    children: [
                                      InputFields.formField1(
                                          hintTxt: "Re-Sch No.",
                                          isEnable: controller.enableFields.value,
                                          controller: controller.bookingMonthCtrl,
                                          width: 0.06),
                                      InputFields.formField1(
                                          hintTxt: "", focusNode: controller.reScheduleFocus, controller: controller.reSchedNoCtrl, width: 0.18),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                        child: Container(
                      child: Row(children: [
                        Container(
                          width: Get.width * 0.50,
                          padding: EdgeInsets.only(
                            left: Get.width * 0.005,
                          ),
                          child: GetBuilder<RoRescheduleController>(
                              init: controller,
                              id: "dgvGrid",
                              builder: (gridController) {
                                return (gridController.rescheduleBookingNumberLeaveData == null ||
                                        gridController.rescheduleBookingNumberLeaveData!.infoLeaveBookingNumber == null ||
                                        gridController.rescheduleBookingNumberLeaveData!.infoLeaveBookingNumber!.lstDgvRO!.isEmpty)
                                    ? Container(
                                        child: Container(
                                          decoration: BoxDecoration(border: Border.all()),
                                        ),
                                      )
                                    : DataGridShowOnlyKeys(
                                        onRowDoubleTap: (tapEvent) {
                                          controller.dgvGridnRowDoubleTap(tapEvent.rowIdx);
                                        },
                                        mapData: gridController.rescheduleBookingNumberLeaveData!.infoLeaveBookingNumber!.lstDgvRO!,
                                        formatDate: false,
                                      );
                              }),
                        ),
                        Container(
                          width: Get.width * 0.50,
                          padding: EdgeInsets.only(
                            right: Get.width * 0.005,
                          ),
                          child: GetBuilder<RoRescheduleController>(
                              init: controller,
                              id: "updatedgvGrid",
                              builder: (gridController) {
                                return (gridController.rescheduleBookingNumberLeaveData == null ||
                                        gridController.rescheduleBookingNumberLeaveData!.infoLeaveBookingNumber == null ||
                                        gridController.rescheduleBookingNumberLeaveData!.infoLeaveBookingNumber!.lstdgvUpdated!.isEmpty)
                                    ? Container(
                                        child: Container(
                                          decoration: BoxDecoration(border: Border.all()),
                                        ),
                                      )
                                    : DataGridShowOnlyKeys(
                                        mapData: gridController.rescheduleBookingNumberLeaveData!.infoLeaveBookingNumber!.lstdgvUpdated!
                                            .map((e) => e.toJson())
                                            .toList(),
                                        formatDate: false,
                                      );
                              }),
                        ),
                      ]),
                    )),
                    Padding(
                      padding: EdgeInsets.zero,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  controller.changeTapeId.value = !controller.changeTapeId.value;
                                },
                                child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start, children: [
                                  Obx(() => Icon(controller.changeTapeId.value ? Icons.check_box_outlined : Icons.check_box_outline_blank_outlined)),
                                  Text("Change Tape ID")
                                ]),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Obx(() => controller.changeTapeId.value
                                  ? Wrap(
                                      spacing: 5,
                                      crossAxisAlignment: WrapCrossAlignment.end,
                                      children: [
                                        DropDownField.formDropDown1WidthMap(
                                            (controller.rescheduleBookingNumberLeaveData?.infoLeaveBookingNumber?.lstcmbTapeID ?? [])
                                                .map((e) => DropDownValue(key: e.exporttapecode, value: e.commercialCaption))
                                                .toList(), (data) {
                                          // controller.selectedLocation = data;
                                          // controller.getChannel(data.key);
                                        }, "Tape ID", 0.12),
                                        InputFields.formField1(
                                            hintTxt: "Seg", isEnable: controller.enableFields.value, controller: controller.zoneCtrl, width: 0.06),
                                        InputFields.formField1(
                                            hintTxt: "Dur", isEnable: controller.enableFields.value, controller: controller.zoneCtrl, width: 0.06),
                                        InputFields.formField1(
                                            hintTxt: "Caption",
                                            isEnable: controller.enableFields.value,
                                            controller: controller.zoneCtrl,
                                            width: 0.18),
                                        FormButtonWrapper(btnText: "Modify"),
                                        FormButtonWrapper(btnText: "Close ")
                                      ],
                                    )
                                  : Container())
                            ],
                          ),
                        ),
                      ),
                    ),
                    GetBuilder<HomeController>(
                        id: "buttons",
                        init: Get.find<HomeController>(),
                        builder: (btncontroller) {
                          /* PermissionModel formPermissions = Get.find<MainController>()
                      .permissionList!
                      .lastWhere((element) {
                    return element.appFormName == "frmSegmentsDetails";
                  });*/

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
                );
              }
            }));
  }
}

import 'package:bms_scheduling/app/controller/HomeController.dart';
import 'package:bms_scheduling/app/controller/MainController.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/data/PermissionModel.dart';
import 'package:bms_scheduling/app/modules/CommonDocs/controllers/common_docs_controller.dart';
import 'package:bms_scheduling/app/modules/CommonDocs/views/common_docs_view.dart';
import 'package:bms_scheduling/app/providers/Utils.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/ro_reschedule_controller.dart';

class RoRescheduleView extends StatelessWidget {
  RoRescheduleView({Key? key}) : super(key: key);
  var controller = Get.put<RoRescheduleController>(
    RoRescheduleController(),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[200],
      body: GetBuilder<RoRescheduleController>(
        init: controller,
        id: "initData",
        builder: (controller) {
          if (controller.reschedulngInitData == null) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// controlls
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
                        Obx(
                          () => DropDownField.formDropDown1WidthMap(
                            controller.reschedulngInitData!.lstlocationMaters!
                                .map((e) => DropDownValue(key: e.locationCode, value: e.locationName))
                                .toList(),
                            (data) {
                              controller.selectedLocation = data;
                              controller.getChannel(data.key);
                            },
                            "Location",
                            0.24,
                            selected: controller.selectedLocation,
                            isEnable: controller.enableFields.value,
                          ),
                        ),
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
                              hintTxt: "Client", isEnable: controller.enableFields.value, controller: controller.clientCtrl, width: 0.24),
                        ),
                        Obx(
                          () => InputFields.formField1(
                              hintTxt: "Agency", isEnable: controller.enableFields.value, controller: controller.agencyCtrl, width: 0.24),
                        ),
                        Obx(
                          () => InputFields.formField1(
                              hintTxt: "Reference",
                              maxLen: 100,
                              isEnable: controller.enableFields.value,
                              controller: controller.referenceCtrl,
                              width: 0.24),
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
                              hintTxt: "Brand", isEnable: controller.enableFields.value, controller: controller.branCtrl, width: 0.24),
                        ),
                        Obx(
                          () => InputFields.formField1(
                              hintTxt: "Deal No", isEnable: controller.enableFields.value, controller: controller.delnoCtrl, width: 0.24),
                        ),
                        Obx(
                          () => InputFields.formField1(
                              hintTxt: "Pay Route",
                              isEnable: controller.enableFields.value,
                              controller: controller.payrouteCtrl,
                              maxLen: 100,
                              width: 0.24),
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
                        Container(
                          width: Get.width * 0.24,
                          child: Row(
                            children: [
                              InputFields.formField1(hintTxt: "Re-Sch No.", isEnable: false, controller: controller.bookingMonthCtrl, width: 0.06),
                              SizedBox(
                                width: Get.width * 0.01,
                              ),
                              InputFields.formField1(
                                  hintTxt: "", focusNode: controller.reScheduleFocus, controller: controller.reSchedNoCtrl, width: 0.17),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),

                /// Data table
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        //1st table
                        Expanded(
                          child: GetBuilder(
                              init: controller,
                              id: "dgvGrid",
                              builder: (gridController) {
                                if ((gridController.roRescheduleOnLeaveData == null || gridController.roRescheduleOnLeaveData!.lstDgvRO!.isEmpty)) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                      color: Colors.white,
                                    ),
                                  );
                                } else {
                                  return DataGridShowOnlyKeys(
                                    mode: PlutoGridMode.selectWithOneTap,
                                    hideKeys: [],
                                    colorCallback: (p0) {
                                      if (controller.roRescheduleOnLeaveData!.lstDgvRO![p0.rowIdx].colorName!.isNotEmpty) {
                                        return controller.roRescheduleOnLeaveData!.lstDgvRO![p0.rowIdx].colorName!.toLowerCase() == "rosybrown"
                                            ? Colors.brown
                                            : Colors.white;
                                      }
                                      return Colors.white;
                                    },
                                    onSelected: (p0) {
                                      controller.closeModify();
                                    },
                                    onload: (load) {
                                      controller.plutoGridStateManager = load.stateManager;
                                    },
                                    onRowDoubleTap: (tapEvent) {
                                      controller.dgvGridnRowDoubleTap(tapEvent.rowIdx);
                                    },
                                    mapData: gridController.roRescheduleOnLeaveData!.lstDgvRO!.map((e) => e.toJson()).toList(),
                                    formatDate: true,
                                  );
                                }
                              }),
                        ),
                        // Container(
                        //   width: Get.width * 0.50,
                        //   padding: EdgeInsets.only(
                        //     left: Get.width * 0.005,
                        //   ),
                        //   child: GetBuilder<RoRescheduleController>(
                        //       init: controller,
                        //       id: "dgvGrid",
                        //       builder: (gridController) {
                        //         return (gridController.roRescheduleOnLeaveData == null || gridController.roRescheduleOnLeaveData!.lstDgvRO!.isEmpty)
                        //             ? Container(
                        //                 child: Container(
                        //                   decoration: BoxDecoration(border: Border.all(), color: Colors.grey),
                        //                 ),
                        //               )
                        //             : ;
                        //       }),
                        // ),
                        SizedBox(width: 10),
                        //2nd table
                        Expanded(
                          child: GetBuilder(
                              init: controller,
                              id: "updatedgvGrid",
                              builder: (gridController) {
                                if ((gridController.roRescheduleOnLeaveData == null ||
                                    gridController.roRescheduleOnLeaveData!.lstdgvUpdated!.isEmpty)) {
                                  return Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                      color: Colors.white,
                                    ),
                                  );
                                } else {
                                  return DataGridShowOnlyKeys(
                                    mapData: gridController.roRescheduleOnLeaveData!.lstdgvUpdated!.map((e) => e.toJson()).toList(),
                                    formatDate: false,
                                  );
                                }
                              }),
                        ),
                        // Container(
                        //   width: Get.width * 0.50,
                        //   padding: EdgeInsets.only(
                        //     right: Get.width * 0.005,
                        //   ),
                        //   child: GetBuilder<RoRescheduleController>(
                        //       init: controller,
                        //       id: "updatedgvGrid",
                        //       builder: (gridController) {
                        //         return (gridController.roRescheduleOnLeaveData == null ||
                        //                 gridController.roRescheduleOnLeaveData!.lstdgvUpdated!.isEmpty)
                        //             ? Container(
                        //                 child: Container(
                        //                   decoration: BoxDecoration(border: Border.all(), color: Colors.grey),
                        //                 ),
                        //               )
                        //             : DataGridShowOnlyKeys(
                        //                 mapData: gridController.roRescheduleOnLeaveData!.lstdgvUpdated!.map((e) => e.toJson()).toList(),
                        //                 formatDate: false,
                        //               );
                        //       }),
                        // ),
                      ],
                    ),
                  ),
                ),

                ///
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
                              if (controller.plutoGridStateManager!.currentCell != null) {
                                controller.onChangeTapeIDClick();
                              }
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
                                        (controller.roRescheduleOnLeaveData?.lstcmbTapeID ?? [])
                                            .map((e) => DropDownValue(key: e.exporttapecode, value: e.exporttapecode))
                                            .toList(), (data) {
                                      // controller.selectedLocation = data;
                                      // controller.getChannel(data.key);
                                    }, "Tape ID", 0.12, selected: controller.modifySelectedTapeCode),
                                    InputFields.formField1(hintTxt: "Seg", isEnable: false, controller: controller.changeTapeIdSeg, width: 0.06),
                                    InputFields.formField1(hintTxt: "Dur", isEnable: false, controller: controller.changeTapeIdDur, width: 0.06),
                                    InputFields.formField1(hintTxt: "Caption", isEnable: false, controller: controller.chnageTapeIdCap, width: 0.18),
                                    FormButtonWrapper(
                                      btnText: "Modify",
                                      callback: () {
                                        controller.modify();
                                      },
                                    ),
                                    FormButtonWrapper(
                                      btnText: "Close",
                                      callback: () {},
                                    )
                                  ],
                                )
                              : Container())
                        ],
                      ),
                    ),
                  ),
                ),

                /// Common buttons
                GetBuilder<HomeController>(
                    id: "buttons",
                    init: Get.find<HomeController>(),
                    builder: (btncontroller) {
                      /* PermissionModel formPermissions = Get.find<MainController>()
                      .permissionList!
                      .lastWhere((element) {
                    return element.appFormName == "frmSegmentsDetails";
                  });*/
                      PermissionModel formPermissions = Get.find<MainController>().permissionList!.lastWhere((element) {
                        return element.appFormName == "frmROBooking";
                      });

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
                                FormButtonWrapper(
                                  btnText: btn["name"],
                                  // isEnabled: btn['isDisabled'],
                                  callback: Utils.btnAccessHandler2(btn['name'], btncontroller, formPermissions) == null
                                      ? null
                                      : () => btnHandler(btn['name']),
                                ),
                            ],
                          ),
                        ),
                      );
                    }),
              ],
            );
          }
        },
      ),
    );
  }

  btnHandler(name) {
    switch (name) {
      case "Save":
        controller.save();
        break;
      case "Clear":
        Get.delete<RoRescheduleController>();
        Get.find<HomeController>().clearPage1();
        break;
      case "Docs":
        Get.defaultDialog(
          title: "Documents",
          content: CommonDocsView(
            documentKey:
                "ROReschedule ${controller.selectedLocation!.key}${controller.selectedChannel!.key}${controller.bookingMonthCtrl.text}${controller.reSchedNoCtrl.text}",
          ),
        ).then((value) {
          Get.delete<CommonDocsController>(tag: "commonDocs");
        });
        break;
      case "Refresh":
        controller.save();
        break;
      default:
    }
  }
}

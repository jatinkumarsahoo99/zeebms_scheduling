import 'package:bms_scheduling/app/modules/RoBooking/controllers/ro_booking_controller.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/dummydata.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/gridFromMap.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/DropDownValue.dart';
import '../../../data/user_data_settings_model.dart';

class ProgramView extends StatelessWidget {
  const ProgramView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RoBookingController>(
        init: Get.find<RoBookingController>(),
        id: "programView",
        builder: (controller) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FocusTraversalGroup(
                policy: ReadingOrderTraversalPolicy(),
                child: Container(
                  width: Get.width * 0.40,
                  child: SingleChildScrollView(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.end,
                      spacing: 05,
                      runSpacing: 05,
                      children: [
                        InputFields.formField1(
                            // showTitle: false,
                            hintTxt: "Tape ID",
                            focusNode: controller.tapeIdFocus,
                            controller: controller.tapeIDCtrl,
                            width: 0.06 + (5 / Get.width)),
                        Obx(
                          () => DropDownField.formDropDown1WidthMap(
                              controller.tapeIds.value
                                  .map((e) => DropDownValue(
                                      key: e["exporttapecode"],
                                      value: e["commercialcaption"]))
                                  .toList(),
                              (value) => {
                                    controller.selectedTapeID = value,
                                    controller.tapIdLeave(value.key),
                                  },
                              "",
                              0.18 - (5 / Get.width),
                              selected: controller.selectedTapeID,
                              inkWellFocusNode: controller.tapeIddropdownFocus,
                              dialogHeight: Get.height * .35,
                              dialogWidth: Get.width * 0.24),
                        ),
                        // DropDownField.formDropDownSearchAPI2(GlobalKey(), context,
                        //     width: Get.width * 0.12, title: "Tape Id", url: "url", onchanged: (value) {}),
                        DropDownField.formDropDown1WidthMap(
                          [
                            DropDownValue(
                                key: (1).toString(), value: (1).toString())
                          ],
                          (value) => {},
                          "Seg",
                          0.03,
                          selected: controller.selectedSeg,
                          dialogWidth: Get.width * 0.12,
                          dialogHeight: Get.height * .35,
                        ),
                        InputFields.formField1(
                            // showTitle: false,
                            hintTxt: "Duration",
                            isEnable: false,
                            controller: TextEditingController(
                                text: (controller
                                            .bookingTapeLeaveData?.duration ??
                                        "")
                                    .toString()),
                            width: 0.09 - (5 / Get.width)),
                        InputFields.formField1(
                            // showTitle: false,
                            hintTxt: "Caption",
                            isEnable: false,
                            controller: TextEditingController(
                                text:
                                    (controller.bookingTapeLeaveData?.caption ??
                                            "")
                                        .toString()),
                            width: 0.12),
                        InputFields.formField1(
                            // showTitle: false,
                            hintTxt: "Agency Id",
                            isEnable: false,
                            controller: TextEditingController(
                                text: (controller
                                            .bookingTapeLeaveData?.agencyId ??
                                        "")
                                    .toString()),
                            width: 0.12),
                        InputFields.formField1(
                            // showTitle: false,
                            hintTxt: "Lanaguge",
                            isEnable: false,
                            controller: TextEditingController(
                                text: (controller
                                            .bookingTapeLeaveData?.language ??
                                        "")
                                    .toString()),
                            width: 0.12),
                        InputFields.formField1(
                            // showTitle: false,
                            hintTxt: "Rev Type",
                            isEnable: false,
                            controller: TextEditingController(
                                text: (controller.bookingTapeLeaveData
                                            ?.tapeRevenue ??
                                        "")
                                    .toString()),
                            width: 0.12),
                        InputFields.formField1(
                            // showTitle: false,
                            hintTxt: "Sub Rev",
                            isEnable: false,
                            controller: TextEditingController(
                                text: (controller.bookingTapeLeaveData
                                            ?.tapeSubRevenue ??
                                        "")
                                    .toString()),
                            width: 0.12),
                        InputFields.formField1(
                            // showTitle: false,
                            hintTxt: "Camp Peroid",
                            isEnable: false,
                            controller: TextEditingController(
                                text: controller
                                    .bookingTapeLeaveData?.campStartDate
                                    ?.split(" ")[0]),
                            width: 0.12),
                        InputFields.formField1(
                            // showTitle: false,
                            hintTxt: "",
                            isEnable: false,
                            controller: TextEditingController(
                                text: controller
                                    .bookingTapeLeaveData?.campEndDate
                                    ?.split(" ")[0]),
                            width: 0.12),
                        DateWithThreeTextField(
                            isEnable: false,
                            widthRation: 0.12,
                            title: "Kill Date",
                            mainTextController: controller.pgkillDateCtrl),
                        DropDownField.formDropDown1WidthMap(
                            controller.roBookingInitData?.lstspotpositiontype
                                    ?.map((e) => DropDownValue(
                                        key: (e.spotPositionTypeCode ?? "")
                                            .toString(),
                                        value: e.spotPositionTypeName))
                                    .toList() ??
                                [],
                            (value) => {},
                            "Pre-Mid",
                            0.12,
                            selected: controller.selectedPremid,
                            isEnable: true),
                        DropDownField.formDropDown1WidthMap(
                            controller.roBookingInitData?.lstPosition
                                    ?.map((e) => DropDownValue(
                                        key: (e.positioncode ?? "").toString(),
                                        value: e.column1))
                                    .toList() ??
                                [],
                            (value) => {},
                            "Position",
                            0.12,
                            selected: controller.selectedPosition,
                            isEnable: true),
                        DropDownField.formDropDown1WidthMap(
                            List.generate(
                                10,
                                (index) => DropDownValue(
                                    key: (index + 1).toString(),
                                    value: (index + 1).toString())),
                            (value) => {},
                            "Break",
                            0.12,
                            selected: controller.selectedBreak,
                            isEnable: true),
                        FormButtonWrapper(
                          btnText: "Seg",
                          iconDataM: Icons.segment_rounded,
                          callback: () {
                            controller.getSegment(
                                controller.programViewGrid?.currentRowIdx);
                          },
                        ),
                        InputFields.formField1(
                            // showTitle: false,
                            hintTxt: "Rate",
                            isEnable: false,
                            controller: TextEditingController(
                                text: controller.dealDblClickData?.rate ?? ""),
                            width: 0.12),
                        InputFields.formField1(
                            // showTitle: false,
                            hintTxt: "Total",
                            isEnable: false,
                            controller: TextEditingController(
                                text: controller.bookingTapeLeaveData?.total ??
                                    controller.dealDblClickData?.total ??
                                    ""),
                            width: 0.12),
                        FormButtonWrapper(
                          btnText: "Add Spots",
                          iconDataM: Icons.addchart_rounded,
                          callback: () {
                            if (controller.selectedTapeID?.key == null ||
                                controller.selectedTapeID?.value == null) {
                              LoadingDialog.callInfoMessage(
                                  "Please select the tape id first and then add spot.");
                            } else {
                              controller.addSpot();
                            }
                          },
                        ),
                        FormButtonWrapper(
                          btnText: "Deal",
                          iconDataM: Icons.arrow_back_ios_new_rounded,
                          callback: () {
                            controller.pagecontroller.jumpToPage(0);
                            controller.currentTab.value = "Deal";
                          },
                        ),

                        // Row(
                        //   mainAxisSize: MainAxisSize.min,
                        //   crossAxisAlignment: CrossAxisAlignment.end,
                        //   children: [],
                        // )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: Get.width * 0.57,
                child: (controller.dealDblClickData?.lstProgram ?? []).isEmpty
                    ? Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 1.0, color: Colors.grey)),
                      )
                    : DataGridFromMap(
                        mapData: controller.dealDblClickData?.lstProgram
                                ?.map((e) => e.toJson())
                                .toList() ??
                            controller.bookingTapeLeaveData?.lstdgvProgram
                                ?.map((e) => e.toJson())
                                .toList() ??
                            [],
                        editKeys: ["bookedSpots"],
                        onEdit: (editChnage) {
                          // num val = num.tryParse(editChnage.value ?? '0') ?? 0;
                          // if (val > 2) {
                          //   controller.programViewGrid?.changeCellValue(
                          //     editChnage.row.cells["bookedSpots"]!,
                          //     '0',
                          //     callOnChangedEvent: false,
                          //     force: true,
                          //     notify: true,
                          //   );
                          //   if (controller
                          //               .bookingTapeLeaveData?.lstdgvProgram !=
                          //           null &&
                          //       (controller.bookingTapeLeaveData
                          //                   ?.lstdgvProgram ??
                          //               [])
                          //           .isNotEmpty) {
                          //     controller
                          //         .bookingTapeLeaveData
                          //         ?.lstdgvProgram?[editChnage.rowIdx]
                          //         .bookedSpots = 0;
                          //   } else {
                          //     controller
                          //         .dealDblClickData
                          //         ?.lstProgram?[editChnage.rowIdx]
                          //         .bookedSpots = 0;
                          //   }
                          //   LoadingDialog.callInfoMessage(
                          //     'You cannot book duration greater than slot duration.',
                          //   );
                          // } else
                          if (controller.bookingTapeLeaveData != null) {
                            controller
                                    .bookingTapeLeaveData
                                    ?.lstdgvProgram?[editChnage.rowIdx]
                                    .bookedSpots =
                                int.tryParse(editChnage.value) ?? 0;
                          } else if (controller.dealDblClickData?.lstProgram !=
                              null) {
                            controller
                                    .dealDblClickData
                                    ?.lstProgram?[editChnage.rowIdx]
                                    .bookedSpots =
                                int.tryParse(editChnage.value) ?? 0;
                          }
                        },
                        onRowDoubleTap: (dblclick) {
                          // bool canIncre = true;
                          controller.dealProgramCode = controller
                                  .bookingTapeLeaveData
                                  ?.lstdgvProgram?[dblclick.rowIdx]
                                  .programcode ??
                              controller.dealDblClickData
                                  ?.lstProgram?[dblclick.rowIdx].programcode;
                          controller.dealStartTime = controller
                                  .bookingTapeLeaveData
                                  ?.lstdgvProgram?[dblclick.rowIdx]
                                  .startTime ??
                              controller.dealDblClickData
                                  ?.lstProgram?[dblclick.rowIdx].startTime;
                          controller.dealTelecastDate = controller
                                  .bookingTapeLeaveData
                                  ?.lstdgvProgram?[dblclick.rowIdx]
                                  .telecastdate ??
                              controller.dealDblClickData
                                  ?.lstProgram?[dblclick.rowIdx].telecastdate;

                          // if (controller.bookingTapeLeaveData?.lstdgvProgram !=
                          //         null &&
                          //     (controller.bookingTapeLeaveData?.lstdgvProgram ??
                          //             [])
                          //         .isNotEmpty) {
                          //   if ((controller
                          //               .bookingTapeLeaveData
                          //               ?.lstdgvProgram?[dblclick.rowIdx]
                          //               .bookedSpots ??
                          //           0) >=
                          //       2) {
                          //     controller
                          //         .bookingTapeLeaveData
                          //         ?.lstdgvProgram?[dblclick.rowIdx]
                          //         .bookedSpots = 0;
                          //     canIncre = false;
                          //   } else {
                          //     canIncre = true;
                          //   }
                          // } else {
                          //   if ((controller
                          //               .dealDblClickData
                          //               ?.lstProgram?[dblclick.rowIdx]
                          //               .bookedSpots ??
                          //           0) >=
                          //       2) {
                          //     controller
                          //         .dealDblClickData
                          //         ?.lstProgram?[dblclick.rowIdx]
                          //         .bookedSpots = 0;
                          //     canIncre = false;
                          //   } else {
                          //     canIncre = true;
                          //   }
                          // }
                          if (controller.bookingTapeLeaveData?.lstdgvProgram !=
                                  null &&
                              (controller.bookingTapeLeaveData?.lstdgvProgram ??
                                      [])
                                  .isNotEmpty) {
                            controller
                                .bookingTapeLeaveData
                                ?.lstdgvProgram?[dblclick.rowIdx]
                                .bookedSpots = (controller
                                        .bookingTapeLeaveData
                                        ?.lstdgvProgram?[dblclick.rowIdx]
                                        .bookedSpots ??
                                    0) +
                                1;
                          } else {
                            controller
                                .dealDblClickData
                                ?.lstProgram?[dblclick.rowIdx]
                                .bookedSpots = (controller
                                        .dealDblClickData
                                        ?.lstProgram?[dblclick.rowIdx]
                                        .bookedSpots ??
                                    0) +
                                1;
                          }

                          controller.programViewGrid?.changeCellValue(
                            dblclick.row.cells["bookedSpots"]!,
                            dblclick.cell.value is int
                                ? dblclick.cell.value + 1
                                : "${(int.tryParse(dblclick.cell.value) ?? 0) + 1}",
                            callOnChangedEvent: false,
                            force: true,
                            notify: true,
                          );
                          // if (((controller
                          //                 .dealDblClickData
                          //                 ?.lstProgram?[dblclick.rowIdx]
                          //                 .bookedSpots ??
                          //             0) <
                          //         2) ||
                          //     ((controller
                          //                 .bookingTapeLeaveData
                          //                 ?.lstdgvProgram?[dblclick.rowIdx]
                          //                 .bookedSpots ??
                          //             0) <
                          //         2)) {

                          // } else {
                          //   LoadingDialog.callInfoMessage(
                          //       'You cannot book duration greater than slot duration.');
                          // }
                        },
                        witdthSpecificColumn: (controller
                            .userDataSettings?.userSetting
                            ?.firstWhere(
                                (element) =>
                                    element.controlName == "programViewGrid",
                                orElse: () => UserSetting())
                            .userSettings),
                        onload: (load) {
                          controller.programViewGrid = load.stateManager;
                        },
                      ),
              )
            ],
          );
        });
  }
}

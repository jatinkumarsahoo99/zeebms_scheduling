import 'package:bms_scheduling/app/modules/RoBooking/controllers/ro_booking_controller.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/dummydata.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/gridFromMap.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../data/DropDownValue.dart';

class ProgramView extends GetView<RoBookingController> {
  const ProgramView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RoBookingController>(
        init: controller,
        id: "programView",
        builder: (controller) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: Get.width * 0.40,
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  spacing: 05,
                  runSpacing: 05,
                  children: [
                    DropDownField.formDropDown1WidthMap(
                        controller.tapeIds
                            .map((e) => DropDownValue(
                                key: e["exporttapecode"],
                                value: e["commercialcaption"]))
                            .toList(),
                        (value) => {
                              controller.selectedTapeID = value,
                              controller.tapIdLeave(value.key),
                            },
                        "Tape ID",
                        0.12,
                        selected: controller.selectedTapeID,
                        dialogWidth: Get.width * 0.24),
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
                      dialogWidth: Get.width * 0.12,
                    ),
                    InputFields.formField1(
                        // showTitle: false,
                        hintTxt: "Duration",
                        isEnable: false,
                        controller: TextEditingController(
                            text: (controller.bookingTapeLeaveData?.duration ??
                                    "")
                                .toString()),
                        width: 0.09 - (5 / Get.width)),
                    InputFields.formField1(
                        // showTitle: false,
                        hintTxt: "Caption",
                        isEnable: false,
                        controller: TextEditingController(
                            text:
                                (controller.bookingTapeLeaveData?.caption ?? "")
                                    .toString()),
                        width: 0.12),
                    InputFields.formField1(
                        // showTitle: false,
                        hintTxt: "Agency Id",
                        isEnable: false,
                        controller: TextEditingController(
                            text: (controller.bookingTapeLeaveData?.agencyId ??
                                    "")
                                .toString()),
                        width: 0.12),
                    InputFields.formField1(
                        // showTitle: false,
                        hintTxt: "Lanaguge",
                        isEnable: false,
                        controller: TextEditingController(
                            text: (controller.bookingTapeLeaveData?.language ??
                                    "")
                                .toString()),
                        width: 0.12),
                    InputFields.formField1(
                        // showTitle: false,
                        hintTxt: "Rev Type",
                        isEnable: false,
                        controller: TextEditingController(
                            text:
                                (controller.bookingTapeLeaveData?.tapeRevenue ??
                                        "")
                                    .toString()),
                        width: 0.12),
                    InputFields.formField1(
                        // showTitle: false,
                        hintTxt: "Sub Rev",
                        isEnable: false,
                        controller: TextEditingController(
                            text: (controller
                                        .bookingTapeLeaveData?.tapeSubRevenue ??
                                    "")
                                .toString()),
                        width: 0.12),
                    InputFields.formField1(
                        // showTitle: false,
                        hintTxt: "Camp Peroid",
                        isEnable: false,
                        controller: TextEditingController(
                            text:
                                controller.bookingTapeLeaveData?.campStartDate),
                        width: 0.12),
                    InputFields.formField1(
                        // showTitle: false,
                        hintTxt: "",
                        isEnable: false,
                        controller: TextEditingController(
                            text: controller.bookingTapeLeaveData?.campEndDate),
                        width: 0.12),
                    DateWithThreeTextField(
                        isEnable: false,
                        widthRation: 0.12,
                        title: "Deal Start",
                        mainTextController: controller.fpcEffectiveDateCtrl),
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
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
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
                        SizedBox(
                          width: 5,
                        ),
                        ElevatedButton(onPressed: () {}, child: Text("Seg"))
                      ],
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
                            text: controller.dealDblClickData?.total ?? ""),
                        width: 0.12),
                    ElevatedButton(onPressed: () {}, child: Text("Add Spots")),
                    ElevatedButton(onPressed: () {}, child: Text("Deal")),
                    // Row(
                    //   mainAxisSize: MainAxisSize.min,
                    //   crossAxisAlignment: CrossAxisAlignment.end,
                    //   children: [],
                    // )
                  ],
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
                        mapData: controller.bookingTapeLeaveData?.lstdgvProgram
                                ?.map((e) => e.toJson())
                                .toList() ??
                            controller.dealDblClickData?.lstProgram
                                ?.map((e) => e.toJson())
                                .toList() ??
                            [],
                        onRowDoubleTap: (dblclick) {
                          controller.dealDblClickData
                              ?.lstProgram?[dblclick.rowIdx].bookedSpots = 1;
                          controller.programViewGrid?.changeCellValue(
                              dblclick.cell,
                              dblclick.cell.value is int ? 1 : "1",
                              force: true,
                              notify: true);
                        },
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

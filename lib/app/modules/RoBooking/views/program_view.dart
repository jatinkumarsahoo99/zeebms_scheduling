import 'package:bms_scheduling/app/modules/RoBooking/controllers/ro_booking_controller.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/dummydata.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/gridFromMap.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ProgramView extends GetView<RoBookingController> {
  const ProgramView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: Get.width * 0.40,
          child: Wrap(
            spacing: 05,
            runSpacing: 05,
            children: [
              DropDownField.formDropDownSearchAPI2(GlobalKey(), context,
                  width: Get.width * 0.12, title: "Tape Id", url: "url", onchanged: (value) {}),
              DropDownField.formDropDown1WidthMap([], (value) => {}, "Seg", 0.03, isEnable: false),
              InputFields.formField1(
                  // showTitle: false,
                  hintTxt: "Duration",
                  isEnable: false,
                  controller: controller.refNoCtrl,
                  width: 0.09 - (5 / Get.width)),
              InputFields.formField1(
                  // showTitle: false,
                  hintTxt: "Caption",
                  isEnable: false,
                  controller: controller.refNoCtrl,
                  width: 0.12),
              InputFields.formField1(
                  // showTitle: false,
                  hintTxt: "Agency Id",
                  isEnable: false,
                  controller: controller.refNoCtrl,
                  width: 0.12),
              InputFields.formField1(
                  // showTitle: false,
                  hintTxt: "Lanaguge",
                  isEnable: false,
                  controller: controller.refNoCtrl,
                  width: 0.12),
              InputFields.formField1(
                  // showTitle: false,
                  hintTxt: "Rev Type",
                  isEnable: false,
                  controller: controller.refNoCtrl,
                  width: 0.12),
              InputFields.formField1(
                  // showTitle: false,
                  hintTxt: "Sub Rev",
                  isEnable: false,
                  controller: controller.refNoCtrl,
                  width: 0.12),
              InputFields.formField1(
                  // showTitle: false,
                  hintTxt: "Camp Peroid",
                  isEnable: false,
                  controller: controller.refNoCtrl,
                  width: 0.12),
              InputFields.formField1(
                  // showTitle: false,
                  hintTxt: "",
                  isEnable: false,
                  controller: controller.refNoCtrl,
                  width: 0.12),
              DateWithThreeTextField(isEnable: false, widthRation: 0.12, title: "Deal Start", mainTextController: controller.fpcEffectiveDateCtrl),
              DropDownField.formDropDown1WidthMap([], (value) => {}, "Pre-Mid", 0.12, isEnable: true),
              DropDownField.formDropDown1WidthMap([], (value) => {}, "Position", 0.12, isEnable: true),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  DropDownField.formDropDown1WidthMap([], (value) => {}, "Position", 0.12, isEnable: true),
                  SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(onPressed: () {}, child: Text("Seg"))
                ],
              ),
              InputFields.formField1(
                  // showTitle: false,
                  hintTxt: "Rate",
                  controller: controller.refNoCtrl,
                  width: 0.12),
              InputFields.formField1(
                  // showTitle: false,
                  hintTxt: "Total",
                  controller: controller.refNoCtrl,
                  width: 0.12),
              Row(
                children: [
                  ElevatedButton(onPressed: () {}, child: Text("Add Spots")),
                  SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(onPressed: () {}, child: Text("Deal")),
                ],
              )
            ],
          ),
        ),
        Container(
          width: Get.width * 0.57,
          child: DataGridFromMap(mapData: dummyProgram),
        )
      ],
    );
  }
}

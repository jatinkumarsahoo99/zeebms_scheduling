import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/DateTime/TimeWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/gridFromMap.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../RoBooking/views/dummydata.dart';

class ReleaseWoNonFpcView extends GetView {
  const ReleaseWoNonFpcView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            DropDownField.formDropDown1WidthMap(
                [], (value) => {}, "Work Order Type", 0.24),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.check_box_outline_blank_outlined),
                Text("WO Release with TX Id")
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(
                  "Msg: Work order can can be release for range of episodes",
                  style: TextStyle(color: Colors.blue)),
            )
          ],
        ),
        Divider(
          height: 10,
        ),
        Wrap(
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          spacing: Get.width * 0.005,
          runSpacing: 5,
          children: [
            DropDownField.formDropDown1WidthMap(
                [], (value) => {}, "Location", 0.12),
            DropDownField.formDropDown1WidthMap(
                [], (value) => {}, "Channel", 0.24),
            DropDownField.formDropDown1WidthMap(
                [], (value) => {}, "BMS Program / BMS Caption", 0.30),
            DropDownField.formDropDown1WidthMap(
                [], (value) => {}, "RMS Program", 0.30),
            InputFields.formField1(
                hintTxt: "Tot Spots",
                controller: TextEditingController(),
                width: 0.0575),
            InputFields.formField1(
                hintTxt: "Tot Spots",
                controller: TextEditingController(),
                width: 0.0575),
            InputFields.formField1(
                hintTxt: "Tot Spots",
                controller: TextEditingController(),
                width: 0.0575),
            DropDownField.formDropDown1WidthMap(
                [], (value) => {}, "RMS Program", 0.1775),
            SizedBox(
              width: Get.width * 0.30,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.check_box_outline_blank_outlined),
                      Text("WO Release with TX Id")
                    ],
                  ),
                  InputFields.formField1(
                      hintTxt: "TX Id",
                      isEnable: false,
                      controller: TextEditingController(),
                      width: 0.14),
                ],
              ),
            ),
            DateWithThreeTextField(
                title: "Ref Date",
                widthRation: 0.12,
                mainTextController: TextEditingController()),
            TimeWithThreeTextField(
              mainTextController: TextEditingController(),
              title: "Tel Time",
            )
          ],
        ),
        Divider(
          height: 10,
        ),
        Expanded(
            child: Container(
          color: Colors.amber,
          child: DataGridFromMap(
            mapData: dummyProgram,
            formatDate: false,
          ),
        )),
        SizedBox(
          height: 5,
        ),
        FormButtonWrapper(btnText: "Save WO")
      ],
    );
  }
}

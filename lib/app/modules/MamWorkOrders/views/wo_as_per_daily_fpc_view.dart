import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/DateTime/TimeWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/gridFromMap.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../RoBooking/views/dummydata.dart';
import '../controllers/mam_work_orders_controller.dart';

class WoAsPerDailyFpcView extends GetView {
  const WoAsPerDailyFpcView(this.controller, {Key? key}) : super(key: key);
  @override
  final MamWorkOrdersController controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            DropDownField.formDropDown1WidthMap([], (value) => {}, "Work Order Type", 0.24),
          ],
        ),
        Divider(
          height: 10,
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          spacing: Get.width * 0.005,
          runSpacing: 5,
          children: [
            DropDownField.formDropDown1WidthMap([], (value) => {}, "Location", 0.12),
            DropDownField.formDropDown1WidthMap([], (value) => {}, "Channel", 0.24),
            DateWithThreeTextField(title: "Ref Date", widthRation: 0.12, mainTextController: TextEditingController()),
            Text("Double Click Quality Column to swap between HD to SD")
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

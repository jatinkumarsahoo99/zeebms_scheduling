import 'package:bms_scheduling/app/modules/RoBooking/views/dummydata.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/gridFromMap.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/mam_work_orders_controller.dart';

class WoHistoryView extends GetView {
  const WoHistoryView(this.controller, {Key? key}) : super(key: key);
  @override
  final MamWorkOrdersController controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          spacing: Get.width * 0.005,
          alignment: WrapAlignment.start,
          runSpacing: 5,
          children: [
            DropDownField.formDropDown1WidthMap([], (value) => {}, "Location", 0.09),
            DropDownField.formDropDown1WidthMap([], (value) => {}, "Channel", 0.12),
            DropDownField.formDropDown1WidthMap([], (value) => {}, "Program", 0.24),
            InputFields.formField1(hintTxt: "From Epi#", controller: TextEditingController(), width: 0.0375),
            InputFields.formField1(hintTxt: "To Epi#", controller: TextEditingController(), width: 0.0375),
            DropDownField.formDropDown1WidthMap([], (value) => {}, "Telecast Type", 0.12),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [Icon(Icons.check_box_outline_blank_outlined), Text("Tel Dt")],
            ),
            DateWithThreeTextField(title: "Tel Dt From", widthRation: 0.09, mainTextController: TextEditingController()),
            DateWithThreeTextField(title: "Tel Dt To", widthRation: 0.09, mainTextController: TextEditingController()),
            FormButtonWrapper(
              btnText: "Show",
              callback: () {},
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
      ],
    );
  }
}

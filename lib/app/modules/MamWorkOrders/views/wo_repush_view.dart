import 'package:bms_scheduling/app/modules/RoBooking/views/dummydata.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/gridFromMap.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/mam_work_orders_controller.dart';

class WoRepushView extends GetView {
  const WoRepushView(this.controller, {Key? key}) : super(key: key);
  @override
  final MamWorkOrdersController controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            flex: 4,
            child: Container(
              child: DataGridFromMap(
                mapData: dummyProgram,
                formatDate: false,
              ),
            )),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text("JSON"),
        ),
        Expanded(
            flex: 2,
            child: Container(
              child: DataGridFromMap(
                mapData: dummyProgram,
                formatDate: false,
              ),
            )),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Double Click View Column in Above Grid to get JSON",
              style: TextStyle(color: Colors.blue),
            ),
            Row(
              children: [
                FormButtonWrapper(btnText: "Load WOs To Repush"),
                FormButtonWrapper(btnText: "Re-push WO"),
              ],
            )
          ],
        )
      ],
    );
  }
}

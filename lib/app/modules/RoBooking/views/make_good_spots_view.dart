import 'package:bms_scheduling/app/modules/RoBooking/controllers/ro_booking_controller.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/dummydata.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class MakeGoodSpotsView extends GetView<RoBookingController> {
  const MakeGoodSpotsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(value: false, onChanged: (value) {}),
                Text("Select All")
              ],
            ),
            Spacer(),
            DateWithThreeTextField(
                title: "FPC Eff. Dt.",
                widthRation: 0.09,
                mainTextController: controller.fpcEffectiveDateCtrl),
            DateWithThreeTextField(
                title: "Booking Date",
                widthRation: 0.09,
                mainTextController: controller.bookDateCtrl),
            Spacer(),
          ],
        ),
        Expanded(
            child: Container(
          child: DataGridShowOnlyKeys(mapData: dummyProgram, formatDate: false),
        )),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FormButtonWrapper(
              btnText: "Display",
              callback: () {},
            ),
            SizedBox(width: 5),
            FormButtonWrapper(
              btnText: "Import & Mark",
              callback: () {},
            ),
          ],
        ),
      ],
    );
  }
}

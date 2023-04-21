import 'package:bms_scheduling/app/modules/RoBooking/controllers/ro_booking_controller.dart';
import 'package:bms_scheduling/widgets/gridFromMap.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import 'dummydata.dart';

class DealView extends GetView<RoBookingController> {
  const DealView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0, 8, 0),
              child: DateWithThreeTextField(
                  title: "Deal Start",
                  mainTextController: controller.fpcEffectiveDateCtrl),
            ),
            DateWithThreeTextField(
                title: "Deal End",
                mainTextController: controller.fpcEffectiveDateCtrl),
          ],
        ),
        SizedBox(
          height: 4,
        ),
        Container(
          height: Get.height / 2.5,
          child: DataGridFromMap(
            mapData: dummydata,
            formatDate: false,
          ),
        )
      ],
    );
  }
}

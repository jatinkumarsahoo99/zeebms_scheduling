import 'package:bms_scheduling/app/modules/RoBooking/controllers/ro_booking_controller.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/dummydata.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class VerifySpotsView extends GetView<RoBookingController> {
  const VerifySpotsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
            child: Container(
          child: DataGridShowOnlyKeys(
            mapData: dummyProgram,
            formatDate: false,
          ),
        )),
        FormButtonWrapper(
          btnText: "Set Verify",
          callback: () {},
        ),
      ],
    );
  }
}

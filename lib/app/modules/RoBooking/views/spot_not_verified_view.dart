import 'package:bms_scheduling/app/modules/RoBooking/controllers/ro_booking_controller.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'dummydata.dart';

class SpotNotVerifiedView extends GetView<RoBookingController> {
  const SpotNotVerifiedView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            DropDownField.formDropDown1WidthMap(
                [], (value) => {}, "Location", 0.24),
            DropDownField.formDropDown1WidthMap(
                [], (value) => {}, "Channel", 0.24),
            DateWithThreeTextField(
                title: "FPC Eff. Dt.",
                widthRation: 0.12,
                mainTextController: controller.fpcEffectiveDateCtrl),
            FormButtonWrapper(
              btnText: "Spot Not Verified",
              callback: () {},
            ),
          ],
        ),
        Expanded(
            child: Container(
          child: DataGridShowOnlyKeys(
            mapData: dummyProgram,
            formatDate: false,
          ),
        ))
      ],
    );
  }
}

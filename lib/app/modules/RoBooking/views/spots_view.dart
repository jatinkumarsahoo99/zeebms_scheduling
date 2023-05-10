// import 'package:bms_scheduling/widgets/cutom_dropdown.dart';
import 'package:bms_scheduling/app/modules/RoBooking/controllers/ro_booking_controller.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/dummydata.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/cutom_dropdown.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class SpotsView extends GetView<RoBookingController> {
  const SpotsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Container(
          child: DataGridShowOnlyKeys(
            mapData: dummydata,
          ),
        )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Wrap(
              spacing: 5,
              children: [
                DropDownField.formDropDown1WidthMap(
                    [], (value) => {}, "Location", 0.12),
                InputFields.formField1(
                    hintTxt: "Amt", controller: TextEditingController()),
                InputFields.formField1(
                    hintTxt: "Bank",
                    width: 0.24,
                    controller: controller.refNoCtrl),
                InputFields.formField1(
                    hintTxt: "Bal Amt", controller: TextEditingController()),
              ],
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.end,
              spacing: 5,
              children: [
                FormButtonWrapper(btnText: "Refresh PDC"),
                FormButtonWrapper(btnText: "Del Spot Row"),
                FormButtonWrapper(btnText: "PDC Cheques"),
              ],
            )
          ],
        )
      ],
    );
  }
}

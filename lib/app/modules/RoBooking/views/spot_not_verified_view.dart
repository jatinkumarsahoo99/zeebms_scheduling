import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/modules/RoBooking/controllers/ro_booking_controller.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'dummydata.dart';

class SpotNotVerifiedView extends GetView<RoBookingController> {
  SpotNotVerifiedView({Key? key}) : super(key: key);
  //Spot Not Verify is View Only Thats why variable define here instead of controller to aviod confusion with main location, channel and date
  DropDownValue? selectedLocation;
  DropDownValue? selectedChannel;
  TextEditingController effectdateController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            DropDownField.formDropDown1WidthMap(
                controller.roBookingInitData!.lstLocation!.map((e) => DropDownValue(key: e.locationCode, value: e.locationName)).toList(),
                (value) => {selectedLocation = value},
                "Location",
                0.24),
            DropDownField.formDropDown1WidthMap(controller.channels.value, (value) => {selectedChannel = value}, "Channel", 0.24),
            DateWithThreeTextField(title: "FPC Eff. Dt.", widthRation: 0.12, mainTextController: effectdateController),
            FormButtonWrapper(
              btnText: "Spot Not Verified",
              callback: () {
                controller.getSpotsNotVerified(
                    selectedLocation!.key, selectedChannel!.key, effectdateController.text.split("-")[2] + effectdateController.text.split("-")[1]);
              },
            ),
            SizedBox(width: 5)
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Expanded(
            child: Container(
          child: Obx(() => controller.spotsNotVerifiedData.value.isNotEmpty
              ? DataGridShowOnlyKeys(
                  mapData: controller.spotsNotVerifiedData.value,
                  formatDate: false,
                )
              : SizedBox()),
        ))
      ],
    );
  }
}

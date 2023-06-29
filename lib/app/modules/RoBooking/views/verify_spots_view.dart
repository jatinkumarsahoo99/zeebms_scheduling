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
          decoration: BoxDecoration(border: Border.all(width: 1.0, color: Colors.grey)),
          child: DataGridShowOnlyKeys(
            mapData: controller.spotsNotVerifiedClickData?.lstdgvVerifySpot ?? [],
            editKeys: const [
              "spotsEntered",
            ],
            onEdit: (editEvent) {
              controller.spotsNotVerifiedClickData?.lstdgvVerifySpot?[editEvent.rowIdx]["spotsEntered"] = editEvent.value;
            },
            formatDate: false,
          ),
        )),
        const SizedBox(
          height: 5,
        ),
        FormButtonWrapper(
          btnText: "Set Verify",
          iconDataM: Icons.domain_verification_rounded,
          callback: () {
            controller.setVerify();
          },
        ),
      ],
    );
  }
}

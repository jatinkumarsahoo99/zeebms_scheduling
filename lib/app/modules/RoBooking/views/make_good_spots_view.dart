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
    return GetBuilder(
        init: Get.find<RoBookingController>(),
        builder: (context) {
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [Checkbox(value: false, onChanged: (value) {}), Text("Select All")],
                  ),
                  Spacer(),
                  DateWithThreeTextField(title: "From Date", widthRation: 0.09, mainTextController: controller.mgfromDateCtrl),
                  SizedBox(
                    width: 5,
                  ),
                  DateWithThreeTextField(title: "to Date", widthRation: 0.09, mainTextController: controller.mgtoDateCtrl),
                  Spacer(),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Expanded(
                  child: Container(
                child: Obx(() => controller.bookingNoLeaveData != null || controller.makeGoodData.value.isNotEmpty
                    ? DataGridShowOnlyKeys(
                        mapData: controller.makeGoodData.value.isEmpty
                            ? controller.bookingNoLeaveData?.lstSpots?.map((e) => e.toJson()).toList() ?? controller.makeGoodData.value
                            : controller.makeGoodData.value,
                        formatDate: false)
                    : Container(
                        decoration: BoxDecoration(border: Border.all(width: 1.0, color: Colors.grey)),
                      )),
              )),
              SizedBox(
                height: 5,
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FormButtonWrapper(
                    btnText: "Display",
                    callback: () {
                      controller.getDisplay();
                    },
                  ),
                  SizedBox(width: 5),
                  FormButtonWrapper(
                    btnText: "Import & Mark",
                    callback: () {
                      controller.pickFile();
                    },
                  ),
                ],
              ),
            ],
          );
        });
  }
}

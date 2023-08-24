import 'package:bms_scheduling/app/modules/RoBooking/controllers/ro_booking_controller.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/dummydata.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class MakeGoodSpotsView extends StatelessWidget {
  const MakeGoodSpotsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: Get.find<RoBookingController>(),
        id: "makeGood",
        builder: (controller) {
          return Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(() => Checkbox(
                          value: controller.makeGoodSelectAll.value,
                          onChanged: (value) {
                            controller.makeGoodSelectAll.value = value ?? !controller.makeGoodSelectAll.value;

                            for (var i = 0; i < (controller.bookingNoLeaveData?.lstMakeGood ?? []).length; i++) {
                              controller.bookingNoLeaveData?.lstMakeGood![i].selectRow = value;
                            }
                            for (var i = 0; i < controller.makeGoodData.value.length; i++) {
                              controller.makeGoodData[i]["selectRow"] = value;
                            }

                            for (var row in controller.makeGoodGrid?.rows ?? []) {
                              controller.makeGoodGrid?.setRowChecked(row, value ?? false);
                            }
                          })),
                      Text("Select All")
                    ],
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
                        onload: (loadevent) {
                          controller.makeGoodGrid = loadevent.stateManager;
                        },
                        mapData: controller.makeGoodData.value.isEmpty
                            ? controller.bookingNoLeaveData?.lstMakeGood?.map((e) => e.toJson()).toList() ?? controller.makeGoodData.value
                            : controller.makeGoodData.value,
                        checkRow: true,
                        checkRowKey: "selectRow",
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

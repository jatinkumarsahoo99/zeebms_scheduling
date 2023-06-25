import 'package:bms_scheduling/app/modules/RoBooking/controllers/ro_booking_controller.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
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
              child: DateWithThreeTextField(title: "Deal Start", mainTextController: controller.fpcEffectiveDateCtrl),
            ),
            DateWithThreeTextField(title: "Deal End", mainTextController: controller.fpcEffectiveDateCtrl),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Expanded(
          child: Container(
            child: GetBuilder<RoBookingController>(
                id: "dealGrid",
                init: controller,
                builder: (gridcontroller) => gridcontroller.bookingNoLeaveData != null &&
                        gridcontroller.bookingNoLeaveData!.lstdgvDealDetails != null &&
                        gridcontroller.bookingNoLeaveData!.lstdgvDealDetails!.isNotEmpty
                    ? DataGridShowOnlyKeys(
                        mapData: gridcontroller.bookingNoLeaveData!.lstdgvDealDetails!.map((e) => e.toJson()).toList(),
                        onload: (load) {
                          gridcontroller.dealViewGrid = load.stateManager;
                        },
                        onRowDoubleTap: (value) {
                          gridcontroller.dealdoubleclick(
                              gridcontroller.dealViewGrid!.columns.indexWhere((element) => element.field == value.cell.column.field), value.rowIdx);
                        },
                      )
                    : (gridcontroller.dealNoLeaveData != null &&
                            gridcontroller.dealNoLeaveData!.lstdgvDealDetails != null &&
                            gridcontroller.dealNoLeaveData!.lstdgvDealDetails!.isNotEmpty
                        ? DataGridShowOnlyKeys(
                            mapData: gridcontroller.dealNoLeaveData!.lstdgvDealDetails!.map((e) => e.toJson()).toList(),
                            onload: (load) {
                              gridcontroller.dealViewGrid = load.stateManager;
                            },
                            onRowDoubleTap: (value) {
                              gridcontroller.dealdoubleclick(
                                  gridcontroller.dealViewGrid!.columns.indexWhere((element) => element.field == value.cell.column.field),
                                  value.rowIdx);
                            },
                          )
                        : Container(
                            decoration: BoxDecoration(border: Border.all(width: 1.0, color: Colors.grey)),
                          ))),
          ),
        )
      ],
    );
  }
}

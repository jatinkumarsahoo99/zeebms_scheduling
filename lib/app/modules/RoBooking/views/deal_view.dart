import 'package:bms_scheduling/app/modules/RoBooking/controllers/ro_booking_controller.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/src/helper/pluto_move_direction.dart';
import 'package:bms_scheduling/widgets/gridFromMap.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/PlutoGrid/src/pluto_grid.dart';
import '../../../data/user_data_settings_model.dart';
import 'dummydata.dart';

class DealView extends GetView<RoBookingController> {
  const DealView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RoBookingController>(
        id: "dealGrid",
        init: Get.find<RoBookingController>(),
        builder: (gridcontroller) => Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 0, 8, 0),
                      child: DateWithThreeTextField(
                        title: "Deal Start",
                        mainTextController: controller.dealFromCtrl,
                        isEnable: false,
                      ),
                    ),
                    DateWithThreeTextField(
                        isEnable: false,
                        title: "Deal End",
                        mainTextController: controller.dealToCtrl),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                GetBuilder<RoBookingController>(
                    id: "dealUpdate",
                    init: Get.find<RoBookingController>(),
                    builder: (context) {
                      return Expanded(
                        child: Container(
                            child: gridcontroller.bookingNoLeaveData != null &&
                                    gridcontroller.bookingNoLeaveData!
                                            .lstdgvDealDetails !=
                                        null &&
                                    gridcontroller.bookingNoLeaveData!
                                        .lstdgvDealDetails!.isNotEmpty
                                ? DataGridShowOnlyKeys(
                                    mapData: gridcontroller
                                        .bookingNoLeaveData!.lstdgvDealDetails!
                                        .map((e) => e.toJson())
                                        .toList(),
                                    keysWidths: (controller
                                        .userDataSettings?.userSetting
                                        ?.firstWhere(
                                            (element) =>
                                                element.controlName ==
                                                "dealViewGrid",
                                            orElse: () => UserSetting())
                                        .userSettings),
                                    onload: (load) {
                                      gridcontroller.dealViewGrid =
                                          load.stateManager;
                                      if (gridcontroller
                                              .bookingNoLeaveDealCurrentRow !=
                                          null) {
                                        load.stateManager.setCurrentCell(
                                            load
                                                .stateManager
                                                .rows[gridcontroller
                                                        .bookingNoLeaveDealCurrentRow ??
                                                    0]
                                                .cells["programName"],
                                            gridcontroller
                                                .bookingNoLeaveDealCurrentRow);
                                        load.stateManager.moveScrollByRow(
                                            PlutoMoveDirection.down,
                                            gridcontroller
                                                .bookingNoLeaveDealCurrentRow);
                                      }
                                    },
                                    hideCode: false,
                                    onRowDoubleTap: (value) {
                                      controller.dealViewGrid?.setCurrentCell(
                                          value.cell, value.rowIdx);
                                      gridcontroller
                                              .bookingNoLeaveDealCurrentColumn =
                                          value.cell.column.field;
                                      gridcontroller
                                              .bookingNoLeaveDealCurrentRow =
                                          value.rowIdx;

                                      gridcontroller.dealdoubleclick(
                                          gridcontroller.dealViewGrid!.columns
                                              .indexWhere((element) =>
                                                  element.field ==
                                                  value.cell.column.field),
                                          value.rowIdx);
                                    },
                                  )
                                : (gridcontroller.dealNoLeaveData != null &&
                                        gridcontroller.dealNoLeaveData!
                                                .lstdgvDealDetails !=
                                            null &&
                                        gridcontroller.dealNoLeaveData!
                                            .lstdgvDealDetails!.isNotEmpty
                                    ? DataGridShowOnlyKeys(
                                        colorCallback: (event) {
                                          if (event.row ==
                                              gridcontroller
                                                  .dealViewGrid?.currentRow) {
                                            return Colors.deepPurple.shade100;
                                          } else {
                                            return Colors.white;
                                          }
                                        },
                                        mapData: gridcontroller
                                            .dealNoLeaveData!.lstdgvDealDetails!
                                            .map((e) => e.toJson())
                                            .toList(),
                                        keysWidths: (controller
                                            .userDataSettings?.userSetting
                                            ?.firstWhere(
                                                (element) =>
                                                    element.controlName ==
                                                    "dealViewGrid",
                                                orElse: () => UserSetting())
                                            .userSettings),
                                        onload: (load) {
                                          gridcontroller.dealViewGrid =
                                              load.stateManager;
                                          gridcontroller.dealViewGrid
                                              ?.setFilter((element) =>
                                                  controller
                                                      .selectedDeal?.value ==
                                                  element.cells['dealNumber']
                                                      ?.value);
                                          if (gridcontroller
                                                  .dealNoLeaveCurrentRow !=
                                              null) {
                                            load.stateManager.setCurrentCell(
                                                load
                                                        .stateManager
                                                        .rows[gridcontroller
                                                                .dealNoLeaveCurrentRow ??
                                                            0]
                                                        .cells[
                                                    gridcontroller
                                                        .dealNoLeaveDealCurrentColumn],
                                                gridcontroller
                                                    .dealNoLeaveCurrentRow);
                                          }
                                        },
                                        onRowDoubleTap: (value) {
                                          controller.dealViewGrid
                                              ?.setCurrentCell(
                                                  value.cell, value.rowIdx);
                                          gridcontroller
                                                  .dealNoLeaveDealCurrentColumn =
                                              value.cell.column.field;
                                          gridcontroller.dealNoLeaveCurrentRow =
                                              value.rowIdx;
                                          gridcontroller.dealdoubleclick(
                                              gridcontroller
                                                  .dealViewGrid!.columns
                                                  .indexWhere((element) =>
                                                      element.field ==
                                                      value.cell.column.field),
                                              value.rowIdx);
                                        },
                                        hideCode: false,
                                        // mode: PlutoGridMode.selectWithOneTap,
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 1.0,
                                                color: Colors.grey)),
                                      ))),
                      );
                    })
              ],
            ));
  }
}

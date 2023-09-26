import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/gridFromMap.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';

import '../../../data/user_data_settings_model.dart';
import '../controllers/mam_work_orders_controller.dart';

class WoAsPerDailyFpcView extends GetView {
  const WoAsPerDailyFpcView(this.controller, {Key? key}) : super(key: key);
  @override
  final MamWorkOrdersController controller;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          return DropDownField.formDropDown1WidthMap(
            controller.onloadData.value.lstcboWOTypeFPC ?? [],
            (value) => controller.woAsPerDailyFPCSelectedWoType = value,
            "Work Order Type",
            0.24,
            selected: controller.woAsPerDailyFPCSelectedWoType,
            inkWellFocusNode: controller.woAsPerDailyFPCWOTFN,
          );
        }),
        Divider(height: 10),
        Obx(() {
          return Wrap(
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: Get.width * 0.005,
            runSpacing: 5,
            children: [
              DropDownField.formDropDown1WidthMap(
                controller.onloadData.value.lstcboLocationFPC ?? [],
                controller.handleOnAsPerDailyFpcLocationChanged,
                "Location",
                0.12,
                selected: controller.woAsPerDailyFPCSelectedLocation,
              ),
              Obx(() {
                return DropDownField.formDropDown1WidthMap(
                  controller.woAsPerDailyFPCChannelList.value,
                  (value) => controller.woAsPerDailyFPCSelectedChannel = value,
                  "Channel",
                  0.24,
                  selected: controller.woAsPerDailyFPCSelectedChannel,
                );
              }),
              DateWithThreeTextField(
                title: "Telecaste Date",
                widthRation: 0.12,
                mainTextController: controller.woAPDFPCTelecateDateTC,
                onFocusChange: controller.onLeaveTelecasteDateInWODFPC,
              ),
              Text("Double Click Quality Column to swap between HD to SD")
            ],
          );
        }),
        Divider(height: 10),

        /// data table
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Obx(
                  () {
                    return (controller.woASPDFPCModel.value.programResponse
                                ?.dailyFpc?.isEmpty ??
                            true)
                        ? Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey)),
                          )
                        : DataGridFromMap3(
                            mapData: controller.woASPDFPCModel.value
                                    .programResponse?.dailyFpc
                                    ?.map((e) => e.toJson())
                                    .toList() ??
                                [],
                            enableColumnDoubleTap: ['release', 'quality'],
                            checkBoxStrComparison: true.toString(),
                            uncheckCheckBoxStr: false.toString(),
                            checkBoxColumnKey: ['release'],
                            editKeys: ['quality'],
                            onEdit: controller.aPDFPCOnDataTableEdit,
                            onColumnHeaderDoubleTap:
                                controller.aPDFPCOnColumnDoubleTap,
                            mode: PlutoGridMode.normal,
                            onRowDoubleTap: (event) {
                              controller.woAsPerDailyFPCSMFirst
                                  ?.setCurrentCell(event.cell, event.rowIdx);
                              var newVal = (event.cell.value ?? "HD") == "HD"
                                  ? "SD"
                                  : "HD";
                              controller.woASPDFPCModel.value.programResponse
                                  ?.dailyFpc?[event.rowIdx].quality = newVal;
                              controller.woAsPerDailyFPCSMFirst
                                  ?.changeCellValue(event.cell, newVal);
                            },
                            witdthSpecificColumn: (controller
                                .userDataSettings?.userSetting
                                ?.firstWhere(
                                    (element) =>
                                        element.controlName ==
                                        "woAsPerDailyFPCSMFirst",
                                    orElse: () => UserSetting())
                                .userSettings),
                            onload: (manager) {
                              controller.woAsPerDailyFPCSMFirst =
                                  manager.stateManager;
                              manager.stateManager.setCurrentCell(
                                  manager.stateManager.firstCell, 0,
                                  notify: true);
                            },
                          );
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Obx(
                  () {
                    return (controller.woAsPerDailyFPCSaveList.isEmpty)
                        ? Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey)),
                          )
                        : DataGridFromMap(
                            witdthSpecificColumn: (controller
                                .userDataSettings?.userSetting
                                ?.firstWhere(
                                    (element) =>
                                        element.controlName ==
                                        "woAsPerDailyFPCSMSecond",
                                    orElse: () => UserSetting())
                                .userSettings),
                            onload: (sm) {
                              controller.woAsPerDailyFPCSMSecond =
                                  sm.stateManager;
                            },
                            mapData: controller.woAsPerDailyFPCSaveList
                                .map((e) => e)
                                .toList(),
                          );
                  },
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
        Align(
          alignment: Alignment.topRight,
          child: FormButtonWrapper(
            btnText: "Save WOs",
            callback: controller.saveWOAsPerDailyFPC,
          ),
        )
      ],
    );
  }
}

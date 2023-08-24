import 'dart:convert';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';
import '../../../../widgets/CheckBoxWidget.dart';
import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../../widgets/input_fields.dart';
import '../../../controller/HomeController.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/Utils.dart';
import '../../filler/controllers/filler_controller.dart';
import '../controllers/event_secondary_controller.dart';

class EventSecondaryView extends GetView<EventSecondaryController> {
  EventSecondaryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),
        child: SizedBox(
          height: double.maxFinite,
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// controllers and Data tables
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      /// left side controllers and Data tables
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: Wrap(
                                spacing: 10,
                                alignment: WrapAlignment.start,
                                runAlignment: WrapAlignment.end,
                                crossAxisAlignment: WrapCrossAlignment.end,
                                children: [
                                  Obx(
                                    () => DropDownField.formDropDown1WidthMap(
                                      controller.locations.value,
                                      (value) => controller.getChannel(value),
                                      "Location",
                                      0.15,
                                      selected: controller.selectLocation,
                                      isEnable:
                                          controller.controllsEnabled.value,
                                      autoFocus: true,
                                      inkWellFocusNode: controller.locationFN,
                                    ),
                                  ),
                                  // const SizedBox(width: 15),
                                  Obx(
                                    () => DropDownField.formDropDown1WidthMap(
                                      controller.channels.value,
                                      (value) =>
                                          controller.selectChannel = value,
                                      isEnable:
                                          controller.controllsEnabled.value,
                                      "Channel",
                                      0.15,
                                      dialogHeight: Get.height * .7,
                                      selected: controller.selectChannel,
                                    ),
                                  ),
                                  // const SizedBox(width: 15),
                                  Obx(
                                    () => DateWithThreeTextField(
                                      title: "From Date",
                                      widthRation: .10,
                                      isEnable:
                                          controller.controllsEnabled.value,
                                      mainTextController: controller.fromdateTC,
                                      // endDate: DateTime.now(),
                                       endDate:
                                      (ApiFactory.Enviroment.toLowerCase() ==
                                              "prod")
                                          ? DateTime.now()
                                          : null,
                                    ),
                                  ),
                                  FormButton(
                                    btnText: "Show Details",
                                    callback: controller.showDetails,
                                  ),

                                  FormButton(
                                    btnText: "Get Previous",
                                    callback: controller.handleGetPreviousTap,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Expanded(
                              child: Obx(() {
                                return Container(
                                  decoration: controller.left1stDT.value.isEmpty
                                      ? BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey))
                                      : null,
                                  child: controller.left1stDT.value.isEmpty
                                      ? null
                                      : DataGridFromMap(
                                        canShowFilter:false,
                                          mapData: controller.left1stDT.value
                                              .map((e) => e.toJson())
                                              .toList(),
                                          onRowDoubleTap: (row) => controller
                                              .handleDoubleTapInLeft1stTable(
                                                  row.rowIdx),
                                          onload: (event) {
                                            controller.left1stSM =
                                                event.stateManager;
                                            event.stateManager.setSelectingMode(
                                                PlutoGridSelectingMode.row);
                                            event.stateManager
                                                .setSelecting(true);
                                            event.stateManager.setCurrentCell(
                                                event.stateManager
                                                    .getRowByIdx(controller
                                                        .left1stGridSelectedIdx)
                                                    ?.cells['startTime'],
                                                controller
                                                    .left1stGridSelectedIdx);
                                          },
                                          colorCallback: (row) => ((row
                                                  .row.cells
                                                  .containsValue(controller
                                                      .left1stSM?.currentCell))
                                              ? Colors.deepPurple.shade200
                                              : Colors.white),
                                          mode: PlutoGridMode.selectWithOneTap,
                                          onSelected: (row) => controller
                                                  .left1stGridSelectedIdx =
                                              row.rowIdx ?? 0,
                                        ),
                                );
                              }),
                            ),
                            const SizedBox(height: 5),
                            Expanded(
                              child: Obx(
                                () {
                                  return Container(
                                    decoration: controller
                                            .left2ndDT.value.isEmpty
                                        ? BoxDecoration(
                                            border:
                                                Border.all(color: Colors.grey))
                                        : null,
                                    child: controller.left2ndDT.value.isEmpty
                                        ? null
                                        : RawKeyboardListener(
                                            focusNode: FocusNode(
                                              canRequestFocus: false,
                                              skipTraversal: true,
                                            ),
                                            autofocus: false,
                                            onKey: (value) {
                                              if (value.isKeyPressed(
                                                  LogicalKeyboardKey.delete)) {
                                                if (controller
                                                    .left2ndDT.isEmpty) {
                                                  LoadingDialog.showErrorDialog(
                                                      "First select the row to delete?");
                                                } else if (controller
                                                        .left2ndDT[controller
                                                            .left2ndGridSelectedIdx]
                                                        .eventCode ==
                                                    null||controller
                                                        .left2ndDT[controller
                                                            .left2ndGridSelectedIdx]
                                                        .eventCode ==
                                                    0) {
                                                  LoadingDialog.showErrorDialog(
                                                      "You cannot delete segment row. Select Promo Row.");
                                                } else {
                                                  controller.mainModel
                                                      ?.segementsResponse
                                                      ?.removeWhere((element) =>
                                                          controller
                                                              .left2ndDT[controller
                                                                  .left2ndGridSelectedIdx]
                                                              .rowNo ==
                                                          element.rowNo);
                                                  controller.left2ndDT.removeAt(
                                                      controller
                                                          .left2ndGridSelectedIdx);
                                                }
                                              }
                                            },
                                            child: DataGridFromMap(
                                              canShowFilter:false,
                                              mapData: controller
                                                  .left2ndDT.value
                                                  .map((e) => e.toJson())
                                                  .toList(),
                                              mode: PlutoGridMode
                                                  .selectWithOneTap,
                                              colorCallback: (row) => (row
                                                      .row.cells
                                                      .containsValue(controller
                                                          .left2ndSM
                                                          ?.currentCell))
                                                  ? Colors.deepPurple.shade200
                                                  : Colors.white,
                                              onload: (event) {
                                                controller.left2ndSM =
                                                    event.stateManager;
                                                event.stateManager
                                                    .setSelectingMode(
                                                        PlutoGridSelectingMode
                                                            .row);
                                                event.stateManager
                                                    .setSelecting(true);
                                                event.stateManager.setCurrentCell(
                                                    event.stateManager
                                                            .getRowByIdx(controller
                                                                .left2ndGridSelectedIdx)
                                                            ?.cells[
                                                        'promoPolicyName'],
                                                    controller
                                                        .left2ndGridSelectedIdx);
                                                // event.stateManager.moveCurrentCell(PlutoMoveDirection.down, force: true, notify: true);
                                                event.stateManager
                                                    .moveCurrentCellByRowIdx(
                                                        controller
                                                            .left2ndGridSelectedIdx,
                                                        PlutoMoveDirection.down,
                                                        notify: true);
                                              },
                                              onSelected: (row) => controller
                                                      .left2ndGridSelectedIdx =
                                                  row.rowIdx ?? 0,
                                            ),
                                          ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                              child: Obx(
                                () {
                                  return Row(
                                    children: [
                                      Text(
                                          "Time Band : ${controller.timeBand.value}"),
                                      const SizedBox(width: 15),
                                      Text(
                                          "Program : ${controller.programName.value}"),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 5),

                      /// right side controllers and Data tables
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: InputFields.formField1Width(
                                    widthRatio: .15,
                                    paddingLeft: 0,
                                    hintTxt: "Sec. Caption",
                                    controller: controller.secCaptionTC,
                                    maxLen: 10,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Obx(() {
                                    return InputFields.formFieldDisable(
                                      widthRatio: (Get.width * 0.2) / 2 + 7,
                                      hintTxt: "",
                                      value: controller.rightCount.value,
                                      leftPad: 0,
                                    );
                                  }),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Expanded(
                                  child: InputFields.formField1Width(
                                    widthRatio: (Get.width * 0.2) / 2 + 7,
                                    paddingLeft: 0,
                                    hintTxt: "Secondary Id",
                                    controller: controller.secondaryIDTC,
                                    maxLen: 10,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              width: double.infinity,
                              child: Wrap(
                                // alignment: WrapAlignment.spaceBetween,
                                spacing: 10,
                                children: [
                                  Obx(() {
                                    return CheckBoxWidget1(
                                      title: "My",
                                      value: controller.myEnabled.value,
                                      onChanged: (val) {
                                        controller.myEnabled.value =
                                            val ?? false;
                                      },
                                      horizontalPadding: 0,
                                    );
                                  }),
                                  FormButton(
                                    btnText: "Search",
                                    callback: controller.handleSearchTap,
                                  ),
                                  FormButton(
                                    btnText: "Add",
                                    callback: controller.handleAddTap,
                                  ),
                                  FormButton(
                                    btnText: "Add FPC",
                                    callback: () {
                                      // controller.handleAddFPCTap();
                                    },
                                  ),
                                  FormButton(
                                    btnText: "Delete ALL",
                                    callback: () {
                                      // controller.handleDeleteAllTap();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: Obx(() {
                                return Container(
                                  decoration: controller
                                          .right3rdDT.value.isEmpty
                                      ? BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey))
                                      : null,
                                  child: controller.right3rdDT.value.isEmpty
                                      ? null
                                      : DataGridFromMap(
                                        canShowFilter:false,
                                          mapData: controller.right3rdDT.value,
                                          onRowDoubleTap: (row) => controller
                                              .handleDoubleTapInRightTable(
                                                  row.rowIdx),
                                          onload: (event) {
                                            controller.rightSM =
                                                event.stateManager;
                                            event.stateManager.setSelectingMode(
                                                PlutoGridSelectingMode.row);
                                            event.stateManager
                                                .setSelecting(true);
                                            // event.stateManager.setCurrentCell(event.stateManager.firstCell, 0);
                                          },
                                          colorCallback: (row) => (row.row.cells
                                                  .containsValue(controller
                                                      .rightSM?.currentCell))
                                              ? Colors.deepPurple.shade200
                                              : Colors.white,
                                          mode: PlutoGridMode.selectWithOneTap,
                                          onSelected: (row) => controller
                                              .handleOnSelectRightTable(
                                                  row.rowIdx ?? -1),
                                        ),
                                );
                              }),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: Obx(() {
                                return Wrap(
                                  spacing: 10,
                                  alignment: WrapAlignment.start,
                                  children: [
                                    CheckBoxWidget1(
                                      title: "All",
                                      value: controller.all.value,
                                      onChanged: (val) =>
                                          controller.all.value = val ?? false,
                                    ),
                                    CheckBoxWidget1(
                                      title: "Odd",
                                      value: controller.odd.value,
                                      onChanged: (val) =>
                                          controller.odd.value = val ?? false,
                                    ),
                                    CheckBoxWidget1(
                                      title: "Even",
                                      value: controller.even.value,
                                      onChanged: (val) =>
                                          controller.even.value = val ?? false,
                                    ),
                                  ],
                                );
                              }),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// common buttons
              GetBuilder<HomeController>(
                id: "buttons",
                init: Get.find<HomeController>(),
                builder: (btcontroller) {
                  if (btcontroller.buttons != null) {
                    return ButtonBar(
                      alignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var btn in btcontroller.buttons!)
                          FormButtonWrapper(
                            btnText: btn["name"],
                            callback: ((Utils.btnAccessHandler(btn['name'],
                                        controller.formPermissions!) ==
                                    null))
                                ? null
                                : () => controller.formHandler(btn['name']),
                          )
                      ],
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

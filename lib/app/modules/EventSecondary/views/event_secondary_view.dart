import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';
import '../../../../widgets/CheckBoxWidget.dart';
import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../../widgets/input_fields.dart';
import '../../../controller/HomeController.dart';
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
              Expanded(
                child: Row(
                  children: [
                    /// Two Table
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                              child: SizedBox(
                                width: double.infinity,
                                child: Wrap(
                                  alignment: WrapAlignment.start,
                                  children: [
                                    Obx(
                                      () => DropDownField.formDropDown1WidthMap(
                                        controller.locations.value,
                                        (value) => controller.getChannel(value),
                                        "Location",
                                        0.15,
                                        selected: controller.selectLocation,
                                        isEnable: controller.controllsEnabled.value,
                                        autoFocus: true,
                                        inkWellFocusNode: controller.locationFN,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Obx(
                                      () => DropDownField.formDropDown1WidthMap(
                                        controller.channels.value,
                                        (value) => controller.selectChannel = value,
                                        isEnable: controller.controllsEnabled.value,
                                        "Channel",
                                        0.15,
                                        dialogHeight: Get.height * .7,
                                        selected: controller.selectChannel,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Obx(
                                      () => DateWithThreeTextField(
                                        title: "From Date",
                                        widthRation: .10,
                                        isEnable: controller.controllsEnabled.value,
                                        mainTextController: controller.fromdateTC,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10, top: 17.0),
                                      child: FormButton(
                                        btnText: "Show Details",
                                        callback: controller.showDetails,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    // Padding(
                                    //   padding: const EdgeInsets.only(top: 17.0),
                                    //   child: Obx(() {
                                    //     return FormButton(
                                    //       btnText: "Import",
                                    //       isEnabled: controller.left1stDT.value.isNotEmpty,
                                    //       callback: controller.handleImportTap,
                                    //     );
                                    //   }),
                                    // ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10, top: 17.0),
                                      child: FormButton(
                                        btnText: "Get Previous",
                                        callback: controller.handleGetPreviousTap,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Obx(() {
                                return Container(
                                  decoration: controller.left1stDT.value.isEmpty ? BoxDecoration(border: Border.all(color: Colors.grey)) : null,
                                  child: controller.left1stDT.value.isEmpty
                                      ? null
                                      : DataGridFromMap(
                                          mapData: controller.left1stDT.value.map((e) => e.toJson()).toList(),
                                          onRowDoubleTap: (row) => controller.handleDoubleTapInLeft1stTable(row.rowIdx),
                                          onload: (event) {
                                            controller.left1stSM = event.stateManager;
                                            event.stateManager.setSelectingMode(PlutoGridSelectingMode.row);
                                            event.stateManager.setSelecting(true);
                                            event.stateManager.setCurrentCell(
                                                event.stateManager.getRowByIdx(controller.left1stGridSelectedIdx)?.cells['startTime'],
                                                controller.left1stGridSelectedIdx);
                                          },
                                          colorCallback: (row) => ((row.row.cells.containsValue(controller.left1stSM?.currentCell))
                                              ? Colors.deepPurple.shade200
                                              : Colors.white),
                                          mode: PlutoGridMode.selectWithOneTap,
                                          onSelected: (row) => controller.left1stGridSelectedIdx = row.rowIdx ?? 0,
                                        ),
                                );
                              }),
                            ),
                            SizedBox(height: 5),
                            Expanded(
                              child: Obx(() {
                                return Container(
                                  decoration: controller.left2ndDT.value.isEmpty ? BoxDecoration(border: Border.all(color: Colors.grey)) : null,
                                  child: controller.left2ndDT.value.isEmpty
                                      ? null
                                      : DataGridFromMap(
                                          mapData: controller.left2ndDT.value.map((e) => e.toJson()).toList(),
                                          mode: PlutoGridMode.selectWithOneTap,
                                          colorCallback: (row) => (row.row.cells.containsValue(controller.left2ndSM?.currentCell))
                                              ? Colors.deepPurple.shade200
                                              : Colors.white,
                                          onload: (event) {
                                            controller.left2ndSM = event.stateManager;
                                            event.stateManager.setSelectingMode(PlutoGridSelectingMode.row);
                                            event.stateManager.setSelecting(true);
                                            event.stateManager.setCurrentCell(
                                                event.stateManager.getRowByIdx(controller.left2ndGridSelectedIdx)?.cells['promoPolicyName'],
                                                controller.left2ndGridSelectedIdx);
                                            // event.stateManager.moveCurrentCell(PlutoMoveDirection.down, force: true, notify: true);
                                            event.stateManager
                                                .moveCurrentCellByRowIdx(controller.left2ndGridSelectedIdx, PlutoMoveDirection.down, notify: true);
                                          },
                                          onSelected: (row) => controller.left2ndGridSelectedIdx = row.rowIdx ?? 0,
                                        ),
                                );
                              }),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Obx(
                                () {
                                  return Row(
                                    children: [
                                      Text("Time Band : ${controller.timeBand.value}"),
                                      SizedBox(width: 15),
                                      Text("Program : ${controller.programName.value}"),
                                    ],
                                  );
                                },
                              ),
                            ),
                            // Row(
                            //   crossAxisAlignment: CrossAxisAlignment.end,
                            //   children: [
                            //     const Spacer(),
                            //     Padding(
                            //       padding: const EdgeInsets.only(top: 5.0),
                            //       child: InputFields.formField1Width(
                            //         widthRatio: 0.09,
                            //         paddingLeft: 5,
                            //         hintTxt: "Available",
                            //         controller: controller.availableTC,
                            //         maxLen: 10,
                            //         isEnable: false,
                            //       ),
                            //     ),
                            //     Padding(
                            //       padding: const EdgeInsets.only(top: 5.0),
                            //       child: InputFields.formField1Width(
                            //         widthRatio: 0.09,
                            //         paddingLeft: 5,
                            //         hintTxt: "Scheduled",
                            //         controller: controller.scheduledTC,
                            //         maxLen: 10,
                            //         isEnable: false,
                            //       ),
                            //     ),
                            //     Padding(
                            //       padding: const EdgeInsets.only(top: 5.0),
                            //       child: InputFields.formField1Width(
                            //         widthRatio: 0.09,
                            //         paddingLeft: 5,
                            //         hintTxt: "Count",
                            //         controller: controller.countTC,
                            //         maxLen: 10,
                            //         isEnable: false,
                            //       ),
                            //     ),
                            //   ],
                            // ),
                          ],
                        ),
                      ),
                    ),

                    /// right ui part
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 15, 0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: InputFields.formField1Width(
                                      widthRatio: .15,
                                      paddingLeft: 5,
                                      hintTxt: "Sec. Caption",
                                      controller: controller.secCaptionTC,
                                      maxLen: 10,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Obx(() {
                                      return InputFields.formFieldDisable(
                                        widthRatio: (Get.width * 0.2) / 2 + 7,
                                        hintTxt: "",
                                        value: controller.rightCount.value,
                                      );
                                    }),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: InputFields.formField1Width(
                                      widthRatio: (Get.width * 0.2) / 2 + 7,
                                      paddingLeft: 5,
                                      hintTxt: "Secondary Id",
                                      controller: controller.secondaryIDTC,
                                      maxLen: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: SizedBox(
                                width: double.infinity,
                                child: Wrap(
                                  alignment: WrapAlignment.spaceBetween,
                                  spacing: 20,
                                  children: [
                                    Obx(() {
                                      return CheckBoxWidget1(
                                        title: "My",
                                        value: controller.myEnabled.value,
                                        onChanged: (val) {
                                          controller.myEnabled.value = val ?? false;
                                        },
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
                                      callback: controller.handleAddFPCTap,
                                    ),
                                    FormButton(
                                      btnText: "Delete ALL",
                                      callback: controller.handleDeleteAllTap,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Obx(() {
                                return Container(
                                  decoration: controller.right3rdDT.value.isEmpty ? BoxDecoration(border: Border.all(color: Colors.grey)) : null,
                                  child: controller.right3rdDT.value.isEmpty
                                      ? null
                                      : DataGridFromMap(
                                          mapData: controller.right3rdDT.value,
                                          onRowDoubleTap: (row) => controller.handleDoubleTapInRightTable(row.rowIdx),
                                          onload: (event) {
                                            controller.rightSM = event.stateManager;
                                            event.stateManager.setSelectingMode(PlutoGridSelectingMode.row);
                                            event.stateManager.setSelecting(true);
                                            // event.stateManager.setCurrentCell(event.stateManager.firstCell, 0);
                                          },
                                          colorCallback: (row) => (row.row.cells.containsValue(controller.rightSM?.currentCell))
                                              ? Colors.deepPurple.shade200
                                              : Colors.white,
                                          mode: PlutoGridMode.selectWithOneTap,
                                          onSelected: (row) => controller.handleOnSelectRightTable(row.rowIdx ?? -1),
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
                                      onChanged: (val) => controller.all.value = val ?? false,
                                    ),
                                    CheckBoxWidget1(
                                      title: "Odd",
                                      value: controller.odd.value,
                                      onChanged: (val) => controller.odd.value = val ?? false,
                                    ),
                                    CheckBoxWidget1(
                                      title: "Even",
                                      value: controller.even.value,
                                      onChanged: (val) => controller.even.value = val ?? false,
                                    ),
                                  ],
                                );
                              }),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              GetBuilder<HomeController>(
                  id: "buttons",
                  init: Get.find<HomeController>(),
                  builder: (btcontroller) {
                    if (btcontroller.buttons != null) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: ButtonBar(
                          alignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (var btn in btcontroller.buttons!)
                              //if (Utils.btnAccessHandler(btn['name'], controller.formPermissions!) != null)
                              FormButtonWrapper(
                                btnText: btn["name"],
                                callback: () => controller.formHandler(btn['name']),
                              )
                          ],
                        ),
                      );
                    }
                    return Container();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

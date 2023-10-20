import 'package:bms_scheduling/app/providers/DataGridMenu.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../../widgets/input_fields.dart';
import '../../../controller/HomeController.dart';
import '../../../data/user_data_settings_model.dart';
import '../../../providers/ApiFactory.dart';
import '../controllers/filler_controller.dart';

class FillerView extends GetView<FillerController> {
  const FillerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Obx(
                    () => DropDownField.formDropDown1WidthMap(
                      controller.locations.value,
                      (value) {
                        controller.selectedLocation = value;
                        controller.getChannel(value.key);
                      },
                      "Location",
                      0.15,
                      autoFocus: true,
                      inkWellFocusNode: controller.locationFN,
                      selected: controller.selectedLocation,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Obx(
                    () => DropDownField.formDropDown1WidthMap(
                      controller.channels.value,
                      (value) => controller.selectedChannel = value,
                      "Channel",
                      0.15,
                      dialogHeight: Get.height * .7,
                      selected: controller.selectedChannel,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Obx(
                    () => DateWithThreeTextField(
                      title: "From Date",
                      splitType: "-",
                      widthRation: controller.widthSize,
                      isEnable: controller.isEnable.value,
                      onFocusChange: (data) => controller.fetchFPCDetails(),
                      mainTextController: controller.date_,
                      //startDate: DateTime.now(),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Padding(
                    padding: const EdgeInsets.only(top: 17.0),
                    child: FormButton(
                      btnText: "Import Excel",
                      callback: () => controller.pickFile(),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Padding(
                    padding: const EdgeInsets.only(top: 17.0),
                    child: FormButton(
                      btnText: "Import Fillers",
                      callback: () {
                        Get.defaultDialog(
                          title: "Import Fillers",
                          content: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Obx(
                                      () => DropDownField.formDropDown1WidthMap(
                                        controller.locations.value,
                                        (value) {
                                          controller.selectedImportLocation =
                                              value;
                                          controller.getChannel(value.key);
                                        },
                                        "Location",
                                        0.15,
                                        autoFocus: true,
                                        height: 130,
                                        selected:
                                            controller.selectedImportLocation,
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Obx(
                                      () => DropDownField.formDropDown1WidthMap(
                                        controller.channels.value,
                                        (value) {
                                          controller.selectedImportChannel =
                                              value;
                                        },
                                        "Channel",
                                        0.15,
                                        // dialogHeight: Get.height * .7,
                                        height: 130,
                                        selected:
                                            controller.selectedImportChannel,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Obx(
                                      () => DateWithThreeTextField(
                                        title: "From Date",
                                        splitType: "-",
                                        widthRation: 0.15,
                                        isEnable: controller.isEnable.value,
                                        onFocusChange: (data) {
                                          // print('Selected Date $data');
                                          // controller.fetchFPCDetails();
                                        },
                                        mainTextController:
                                            controller.fillerFromDate_,
                                        endDate: DateTime.now(),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    Obx(
                                      () => DateWithThreeTextField(
                                        title: "To Date",
                                        splitType: "-",
                                        widthRation: 0.15,
                                        isEnable: controller.isEnable.value,
                                        startDate: DateTime.now(),
                                        onFocusChange: (data) {
                                          // print('Selected Date $data');
                                          // controller.fetchFPCDetails();
                                        },
                                        mainTextController:
                                            controller.fillerToDate_,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  InputFields.formFieldNumberMask(
                                      hintTxt: "From Time",
                                      controller: controller.fromTime_,
                                      widthRatio: 0.15,
                                      isEnable: true,
                                      onEditComplete: (val) {
                                        // control.getCaption();
                                      }
                                      // paddingLeft: 0,
                                      ),
                                  const SizedBox(width: 6),
                                  InputFields.formFieldNumberMask(
                                      hintTxt: "To Time",
                                      controller: controller.toTime_,
                                      widthRatio: 0.15,
                                      isEnable: true,
                                      onEditComplete: (val) {
                                        // control.getCaption();
                                      }
                                      // paddingLeft: 0,
                                      ),
                                ],
                              ),
                            ],
                          ),
                          textCancel: "Cancel",
                          onConfirm: () {
                            controller
                                .getFillerValuesByImportFillersWithTapeCode();
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Obx(() {
                  return Visibility(
                    visible: ((controller.fillerDailyFpcList.isNotEmpty)),
                    replacement: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    child: DataGridFromMap3(
                      showSrNo: true,
                      witdthSpecificColumn: (controller
                          .userDataSettings?.userSetting
                          ?.firstWhere(
                              (element) =>
                                  element.controlName == "gridStateManager",
                              orElse: () => UserSetting())
                          .userSettings),
                      formatDate: false,
                      showSecondaryDialog: false,
                      mapData: (controller.fillerDailyFpcList.value
                          .map((e) => e.toJson())
                          .toList()),
                      showonly: [
                        "fpcTime",
                        "endTime",
                        "programName",
                        "epsNo",
                        "tape id",
                        "episodeCaption"
                      ],
                      widthRatio: (Get.width * 0.2) / 2 + 7,
                      mode: PlutoGridMode.normal,
                      onload: (event) {
                        controller.gridStateManager = event.stateManager;
                        event.stateManager.setCurrentCell(
                            event.stateManager
                                .getRowByIdx(controller.topLastSelectedIdx)
                                ?.cells['fpcTime'],
                            controller.bottomLastSelectedIdx);
                      },
                      onRowDoubleTap: (plutoGrid) {
                        controller.topLastSelectedIdx = plutoGrid.rowIdx;
                        controller.gridStateManager?.setCurrentCell(
                            controller.gridStateManager
                                ?.getRowByIdx(controller.topLastSelectedIdx)
                                ?.cells['fpcTime'],
                            controller.bottomLastSelectedIdx);
                        controller.topLastSelectedIdx = plutoGrid.rowIdx;
                        // controller.totalFiller.clear();
                        controller.totalFillerDur.clear();
                        // controller.totalFillerDur.text = "00:00:00:00";
                        controller.fetchSegmentDetails(
                            controller.fillerDailyFpcList[plutoGrid.rowIdx]);
                      },
                      // onSelected: (plutoGrid) {},
                      colorCallback: (row) => (row.row.cells.containsValue(
                              controller.gridStateManager?.currentCell))
                          ? Colors.deepPurple.shade200
                          : Colors.white,
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text("Filler Schedule"),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Obx(
                              () => DropDownField.formDropDownSearchAPI2(
                                GlobalKey(),
                                context,
                                title: "Filler Caption",
                                url: ApiFactory.FILLER_CAPTION,
                                parseKeyForKey: "fillerCode",
                                parseKeyForValue: "fillerCaption",
                                onchanged: (data) => controller
                                    .getFillerValuesByFillerCode(data),
                                selectedValue: controller.selectCaption.value,
                                width: w * 0.45,
                                dialogHeight: 250,
                                inkwellFocus: controller.fillerCaptionFN,
                              ),
                            ),
                            const SizedBox(width: 5),

                            /// TAPE ID eg: PCHF24572
                            InputFields.formField1(
                              width: 0.12,
                              padLeft: 5,
                              hintTxt: "Tape ID",
                              controller: controller.tapeId_,
                              focusNode: controller.tapeIDFocusNode,
                              isEnable: true,
                              // onChange: (value) {
                              //   if (value.toString().isEmpty) {
                              //     controller.clearBottonControlls();
                              //   } else {
                              //     controller.getFillerValuesByTapeCode(
                              //         value.toString());
                              //   }
                              // },
                              maxLen: 10,
                            ),

                            /// SEG NO
                            InputFields.formField1Width(
                              widthRatio: 0.10,
                              paddingLeft: 5,
                              hintTxt: "Seg No",
                              controller: controller.segNo_,
                              disabledTextColor: Colors.black,
                              isEnable: false,
                              maxLen: 10,
                            ),

                            /// SEG DUR
                            InputFields.formField1Width(
                              widthRatio: 0.10,
                              paddingLeft: 5,
                              hintTxt: "Seg Dur",
                              controller: controller.segDur_,
                              disabledTextColor: Colors.black,
                              isEnable: false,
                              maxLen: 10,
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            /// TOTAL FILLER
                            InputFields.formField1Width(
                              widthRatio: 0.12,
                              hintTxt: "Total Filler",
                              controller: controller.totalFiller,
                              maxLen: 10,
                              paddingLeft: 0,
                              isEnable: false,
                              titleinBlack: true,
                            ),

                            /// TOTAL FILLER DUR
                            InputFields.formField1Width(
                              widthRatio: 0.12,
                              paddingLeft: 5,
                              hintTxt: "Total Filler Dur",
                              controller: controller.totalFillerDur,
                              isEnable: false,
                              maxLen: 10,
                              titleinBlack: true,
                            ),

                            /// INSERT AFTER
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Radio(
                                  value: 0,
                                  groupValue: controller.selectedAfter,
                                  onChanged: (int? value) {},
                                ),
                                Text('Insert After')
                              ],
                            ),
                            const SizedBox(width: 10),

                            /// ADD BUTTON
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: FormButton(
                                btnText: "Add",
                                callback: controller.handleAddTap,
                                focusNode: controller.addFN,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0),
                              child: FormButton(
                                btnText: "Delete",
                                focusNode: controller.deleteFN,
                                callback: () {
                                  if (controller.fillerSegmentList.isNotEmpty &&
                                      controller
                                              .fillerSegmentList[controller
                                                  .bottomLastSelectedIdx]
                                              .allowMove ==
                                          "1") {
                                    controller.fillerSegmentList.removeAt(
                                        controller.bottomLastSelectedIdx);
                                    controller.calculateFillerAndTotalFiller();
                                    Future.delayed(Duration(milliseconds: 200))
                                        .then((value) {
                                      controller.deleteFN.requestFocus();
                                    });
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Press right click on filler to remove",
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Expanded(
                          child: Obx(() {
                            return Visibility(
                              visible: ((controller
                                  .fillerSegmentList.value.isNotEmpty)),
                              replacement: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey))),
                              child: DataGridFromMap3(
                                witdthSpecificColumn: (controller
                                    .userDataSettings?.userSetting
                                    ?.firstWhere(
                                        (element) =>
                                            element.controlName == "bottomSM",
                                        orElse: () => UserSetting())
                                    .userSettings),
                                mapData: (controller.fillerSegmentList
                                    .map((e) => e.toJson())
                                    .toList()),
                                // widthRatio: (Get.width * 0.2) / 2 + 7,
                                formatDate: false,
                                secondaryExtraDialogList: [
                                  SecondaryShowDialogModel(
                                    "Delete",
                                    () {
                                      if (controller
                                              .fillerSegmentList[controller
                                                  .bottomLastSelectedIdx]
                                              .allowMove ==
                                          "1") {
                                        controller.fillerSegmentList.removeAt(
                                            controller.bottomLastSelectedIdx);
                                        controller
                                            .calculateFillerAndTotalFiller();
                                      }
                                      // controller.fillerSegmentList.removeAt(controller.bottomLastSelectedIdx);
                                    },
                                  )
                                ],
                                onload: (event) {
                                  controller.bottomSM = event.stateManager;
                                  event.stateManager.setCurrentCell(
                                      event.stateManager
                                          .getRowByIdx(
                                              controller.bottomLastSelectedIdx)
                                          ?.cells['segNo'],
                                      controller.bottomLastSelectedIdx);
                                },
                                colorCallback: (row) => (controller
                                                .fillerSegmentList[row.rowIdx]
                                                .allowMove ==
                                            "1" ||
                                        controller.fillerSegmentList[row.rowIdx]
                                                .ponumber ==
                                            1)
                                    ? Colors.red
                                    : (row.row.cells.containsValue(
                                            controller.bottomSM?.currentCell))
                                        ? Colors.deepPurple.shade200
                                        : Colors.white,
                                onSelected: (plutoGrid) {
                                  controller.bottomLastSelectedIdx =
                                      plutoGrid.rowIdx ?? 0;
                                  controller.selectedSegment = controller
                                      .fillerSegmentList[plutoGrid.rowIdx!];
                                },
                                mode: PlutoGridMode.selectWithOneTap,
                                showonly: [
                                  "segNo",
                                  "seq",
                                  "brkNo",
                                  "ponumber",
                                  "tape id",
                                  "segmentCaption",
                                  "som",
                                  "segDur"
                                ],
                              ),
                            );
                          }),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),

            /// common buttons
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GetBuilder<HomeController>(
                  id: "buttons",
                  init: Get.find<HomeController>(),
                  builder: (btcontroller) {
                    if (btcontroller.buttons != null) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Row(
                          // alignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (var btn in btcontroller.buttons!)
                              Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FormButtonWrapper(
                                  btnText: btn["name"],
                                  callback: btn["name"] == "Delete"
                                      ? null
                                      : () => controller.formHandler(
                                            btn['name'],
                                          ),
                                ),
                              )
                          ],
                        ),
                      );
                    }
                    return Container();
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

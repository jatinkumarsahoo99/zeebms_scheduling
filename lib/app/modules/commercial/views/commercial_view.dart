import 'dart:convert';

import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../widgets/CheckBoxWidget.dart';
import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/LoadingDialog.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../../widgets/gridFromMap1.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../data/user_data_settings_model.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/SizeDefine.dart';
import '../controllers/commercial_controller.dart';

class CommercialView extends StatelessWidget {
  CommercialView({Key? key}) : super(key: key);

  CommercialController controller = Get.put<CommercialController>(
    CommercialController(),
  );
  // var formName = 'Schedule Commercials';
  // void handleOnRowChecked(PlutoGridOnRowCheckedEvent event) {}

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommercialController>(
        init: controller,
        id: "initData",
        builder: (_) {
          return Scaffold(
            body: FocusTraversalGroup(
              policy: OrderedTraversalPolicy(),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GetBuilder<CommercialController>(
                        id: "initialData",
                        builder: (control) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 18.0, top: 10),
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
                                    0.12,
                                    isEnable: controller.isEnable.value,
                                    selected: controller.selectedLocation,
                                    autoFocus: true,
                                    // dialogWidth: 330,
                                    dialogHeight: Get.height * .7,
                                    inkWellFocusNode: controller.locationFN,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Obx(
                                  () => DropDownField.formDropDown1WidthMap(
                                    controller.channels.value,
                                    (value) {
                                      controller.selectedChannel = value;
                                    },
                                    "Channel",
                                    0.15,
                                    dialogHeight: Get.height * .7,
                                    selected: controller.selectedChannel,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Obx(() {
                                  return DateWithThreeTextField(
                                    title: "From Date",
                                    mainTextController: controller.date_,
                                    widthRation: controller.widthSize,
                                    startDate: (controller.formPermissions.value
                                                ?.backDated ??
                                            false)
                                        ? null
                                        : DateTime.now(),
                                  );
                                }),
                                const SizedBox(
                                  width: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 17.0),
                                  child: FormButton(
                                    btnText: "Show Details",
                                    callback: () {
                                      controller.selectedIndex.value = 0;

                                      controller.fetchSchedulingDetails();
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 17.0),
                                  child: FormButton(
                                    btnText: "Verify",
                                    callback: () {
                                      print(controller.userDataSettings
                                          ?.toJson());
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 16.0, left: 15),
                                  child: Row(
                                    children: [
                                      Obx(() {
                                        return CheckBoxWidget1(
                                          title: "Insert After",
                                          value: controller.insertAfter.value,
                                          onChanged: (a) => controller
                                              .insertAfter.value = a ?? false,
                                          fn: controller.insertAfterFN,
                                        );
                                      }),
                                      CheckBoxWidget1(
                                        title: "Auto Shuffle",
                                        value: controller.autoShuffle,
                                        fn: controller.autoShuffleFN,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Expanded(
                        child: Container(
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// input forms
                              Expanded(
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 15, 7, 0),
                                  child: programTable(context),
                                ),
                              ),

                              /// output forms
                              Expanded(
                                flex: 2,
                                child: Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 15, 7, 0),
                                  child: GetBuilder<CommercialController>(
                                      init: CommercialController(),
                                      id: "reports",
                                      builder: (controller) {
                                        return Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: tabView(context),
                                        );
                                      }),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                        child: GetBuilder<HomeController>(
                            id: "buttons",
                            init: Get.find<HomeController>(),
                            builder: (btcontroller) {
                              if (btcontroller.buttons != null) {
                                return ButtonBar(
                                  alignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    for (var btn in btcontroller.buttons!)
                                      //if (Utils.btnAccessHandler(btn['name'], controller.formPermissions!) != null)
                                      FormButtonWrapper(
                                        focusNode: btn["name"] == "Save"
                                            ? controller.saveFN
                                            : null,
                                        btnText: btn["name"],
                                        callback: btn["name"] == "Delete"
                                            ? null
                                            : () => formHandler(
                                                  btn['name'],
                                                ),
                                      )
                                  ],
                                );
                              }
                              return Container();
                            }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget tabView(BuildContext context) {
    return Obx(() => Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 10, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CupertinoSlidingSegmentedControl(
                    groupValue: controller.selectedIndex.value,
                    //backgroundColor: Colors.blue.shade200,
                    children: <int, Widget>{
                      0: Text(
                        'Schedulling',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: SizeDefine.fontSizeTab,
                        ),
                      ),
                      1: Text(
                        'FPC Mismatch',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: SizeDefine.fontSizeTab,
                        ),
                      ),
                      2: Text(
                        'Marked as Error ',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: SizeDefine.fontSizeTab,
                        ),
                      ),
                    },
                    onValueChanged: (int? value) async {
                      // controller.canshowFilterList = false;
                      controller.selectedIndex.value = value!;
                      await controller.showTabList();
                      //controller.fetchSchedulingShowOnTabDetails();
                    },
                  ),
                  const Spacer(),
                  if (controller.selectedIndex.value == 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(() => Text(
                            'Commercial Spots : ${controller.commercialSpots.value}')),
                        const SizedBox(
                          width: 20,
                        ),
                        Obx(() => Text(
                            'Commercial Duration : ${controller.commercialDuration.value}')),
                      ],
                    )
                  else if (controller.selectedIndex.value == 1)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      //mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FormButton(
                          btnText: "Change FPC",
                          callback: () {
                            controller.changeFPCOnClick();
                          },
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        FormButton(
                          btnText: "Mis-Match",
                          callback: () {
                            controller.misMatchOnClick();
                          },
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        FormButton(
                          btnText: "Mark-as-Error",
                          callback: () {
                            controller.markAsErrorOnClick();
                          },
                        ),
                      ],
                    )
                  else if (controller.selectedIndex.value == 2)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FormButton(
                          btnText: "Un-Mark-as-Error",
                          callback: () {
                            controller.unMarkAsErrorOnClick();
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  if (controller.selectedIndex.value == 0)
                    Expanded(child: schedulingView(context))

                  /// Filter B, calculate spot duration
                  else if (controller.selectedIndex.value == 1)
                    Expanded(child: fpcMismatchView(context))

                  /// Filter F, calculate spot duration
                  else if (controller.selectedIndex.value == 2)
                    Expanded(child: markedAsErrorView(context))

                  /// Filter E, calculate spot duration
                ],
              ),
            ),
          ],
        ));
  }

  /// Program List ( Left Side )
  Widget programTable(context) {
    return GetBuilder<CommercialController>(
        id: "programTable",
        builder: (controller) {
          if (controller.commercialProgramList != null &&
              (controller.commercialProgramList?.isNotEmpty)!) {
            return DataGridFromMap(
              mode: controller.selectedProgramPlutoGridMode,
              showonly: const [
                "fpcTime",
                "programname",
              ],
              colorCallback: (row) =>
                  (row.row.cells.containsValue(controller.sm?.currentCell))
                      ? Colors.deepPurple.shade200
                      : Colors.white,
              onload: (sm) {
                controller.sm = sm.stateManager;
                sm.stateManager.setCurrentCell(
                    sm.stateManager
                        .getRowByIdx(controller.lastProgramSelectedIdx)
                        ?.cells['fpcTime'],
                    controller.lastProgramSelectedIdx);
                sm.stateManager.moveCurrentCellByRowIdx(
                    controller.lastProgramSelectedIdx, PlutoMoveDirection.down);
                controller.lastProgramSelectedIdx =
                    controller.lastProgramSelectedIdx;
                controller.selectedProgram = controller
                    .commercialProgramList![controller.lastProgramSelectedIdx];
                controller.programFpcTimeSelected = controller
                    .commercialProgramList![controller.lastProgramSelectedIdx]
                    .fpcTime;
                controller.programCodeSelected = controller
                    .commercialProgramList![controller.lastProgramSelectedIdx]
                    .programcode;
              },
              mapData: (controller.commercialProgramList
                  ?.map((e) => e.toJson())
                  .toList())!,
              onSelected: (plutoGrid) {
                controller.lastProgramSelectedIdx = plutoGrid.rowIdx ?? 0;
                controller.selectedProgram =
                    controller.commercialProgramList![plutoGrid.rowIdx!];
                controller.programFpcTimeSelected = controller
                    .commercialProgramList![plutoGrid.rowIdx!].fpcTime;
                controller.programCodeSelected = controller
                    .commercialProgramList![plutoGrid.rowIdx!].programcode;
              },
              onRowDoubleTap: (plutoGrid) async {
                controller.canshowFilterList = true;
                controller.programCodeSelected = controller
                    .commercialProgramList![plutoGrid.rowIdx!].programcode;
                controller.lastProgramSelectedIdx = plutoGrid.rowIdx;
                controller.sm?.setCurrentCell(
                    controller.sm
                        ?.getRowByIdx(controller.lastProgramSelectedIdx)
                        ?.cells['fpcTime'],
                    controller.lastProgramSelectedIdx);
                controller.selectedProgram =
                    controller.commercialProgramList![plutoGrid.rowIdx];
                controller.programFpcTimeSelected =
                    controller.commercialProgramList![plutoGrid.rowIdx].fpcTime;
                controller.showSelectedProgramList();
                // controller.updateTab();
              },
              witdthSpecificColumn: (controller.userDataSettings?.userSetting
                  ?.firstWhere((element) => element.controlName == "sm",
                      orElse: () => UserSetting())
                  .userSettings),
            );
          } else {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1,
                  color: Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.circular(0),
              ),
              clipBehavior: Clip.hardEdge,
              //child: const PleaseWaitCard(),
            );
          }
        });
  }

  /// tab 0 ( B ) recommended date 22 March 2023
  Widget schedulingView(BuildContext context) {
    return Column(
      children: [
        GetBuilder<CommercialController>(
          id: "schedulingTable",
          builder: (controller) {
            if (controller.showCommercialDetailsList != null &&
                (controller.showCommercialDetailsList?.isNotEmpty)!) {
              return Expanded(
                child: DataGridFromMap1(
                  witdthSpecificColumn: (controller
                      .userDataSettings?.userSetting
                      ?.firstWhere(
                          (element) =>
                              element.controlName == "gridStateManager",
                          orElse: () => UserSetting())
                      .userSettings),
                  onload: (event) {
                    controller.gridStateManager = event.stateManager;
                    event.stateManager
                        .setSelectingMode(PlutoGridSelectingMode.row);
                    controller.gridStateManager?.setCurrentCell(
                        event.stateManager
                            .getRowByIdx(controller.selectedDDIndex)
                            ?.cells['eventType'],
                        controller.selectedDDIndex ?? 0);
                    controller.gridStateManager?.moveCurrentCellByRowIdx(
                        controller.selectedDDIndex ?? 0,
                        PlutoMoveDirection.down);
                  },
                  showSrNo: true,
                  hideKeys: ["fpcTime"],
                  showonly: const [
                    "fpcTime ",
                    "breakNumber",
                    "eventType",
                    "exportTapeCode",
                    "segmentCaption",
                    "client",
                    "brand",
                    "duration",
                    "product",
                    "bookingNumber",
                    "bookingDetailcode",
                    "rostimeBand",
                    "randid",
                    "programName",
                    "rownumber",
                    "bStatus",
                    "pDailyFPC",
                    "pProgramMaster"
                  ],
                  colorCallback: (PlutoRowColorContext plutoContext) {
                    try {
                      if ((plutoContext.row.cells.containsValue(
                          controller.gridStateManager?.currentCell))) {
                        return Colors.deepPurple.shade200;
                      } else {
                        return controller.colorSort(controller
                            .showCommercialDetailsList![plutoContext.rowIdx]
                            .eventType
                            .toString());
                      }
                    } catch (e) {
                      return Colors.white;
                    }
                  },
                  onRowDoubleTap: (event) {
                    controller.selectedDDIndex = event.rowIdx;
                    print("onRowDoubleTap");
                  },
                  onSelected: (PlutoGridOnSelectedEvent event) {
                    // E
                    // if (controller.lastSelectedIdxSchd != (controller.selectedDDIndex ?? 0)) {
                    //   controller.lastSelectedIdxSchd = controller.selectedDDIndex ?? 0;
                    // }
                    if (controller
                        .showCommercialDetailsList![
                            controller.lastSelectedIdxSchd]
                        .canChangeFpc) {
                      controller.gridStateManager!.changeCellValue(
                        controller.gridStateManager!
                            .getRowByIdx(controller.lastSelectedIdxSchd)!
                            .cells['fpcTime ']!,
                        "",
                        callOnChangedEvent: false,
                        force: true,
                        notify: true,
                      );
                    }
                    controller.selectedDDIndex = event.rowIdx;
                    controller.selectedShowOnTab =
                        controller.showCommercialDetailsList![event.rowIdx!];
                    if (event.rowIdx != null &&
                        (controller.showCommercialDetailsList![event.rowIdx!]
                            .canChangeFpc)) {
                      controller.lastSelectedIdxSchd = event.rowIdx ?? 0;
                      controller.gridStateManager!.changeCellValue(
                        controller.gridStateManager!
                            .getRowByIdx(event.rowIdx!)!
                            .cells['fpcTime ']!,
                        controller
                            .showCommercialDetailsList![event.rowIdx!].fpcTime,
                        callOnChangedEvent: false,
                        force: true,
                        notify: true,
                      );
                    }

                    //
                  },
                  onRowsMoved: (PlutoGridOnRowsMovedEvent onRowMoved) {
                    // controller.selectedDDIndex = onRowMoved.idx;

                    try {
                      if (controller.gridStateManager?.rows[onRowMoved.idx]
                              .cells['eventType']?.value
                              .toString()
                              .trim() ==
                          "S") {
                        // var newRow = controller.gridStateManager?.currentRow;
                        // controller.gridStateManager?.removeCurrentRow();
                        // controller.gridStateManager?.insertRows(
                        //     controller.selectedDDIndex!, [newRow!]);
                        // controller.gridStateManager?.notifyListeners(true,
                        //     controller.gridStateManager?.insertRows.hashCode);
                        LoadingDialog.showErrorDialog(
                            "You cannot move selected segment", callback: () {
                          // controller.gridStateManager?.setCurrentCell(
                          //     controller.gridStateManager
                          //         ?.getRowByIdx(controller.selectedDDIndex)
                          //         ?.cells['eventType'],
                          //     controller.selectedDDIndex ?? 0);
                        });
                      } else {
                        int? rownumber = int.tryParse(controller
                                .gridStateManager
                                ?.rows[onRowMoved.idx]
                                .cells['rownumber']
                                ?.value
                                .toString() ??
                            "0");
                        int? moveRowNumber = controller
                            .showCommercialDetailsList?[onRowMoved.idx]
                            .rownumber;

                        int? oldIdx, newIdx;
                        for (var i = 0;
                            i <
                                (controller.mainCommercialShowDetailsList
                                        ?.length ??
                                    0);
                            i++) {
                          if (controller.mainCommercialShowDetailsList?[i]
                                  .rownumber ==
                              rownumber) {
                            oldIdx = i;
                          }
                          if (controller.mainCommercialShowDetailsList?[i]
                                  .rownumber ==
                              moveRowNumber) {
                            newIdx = i;
                          }
                        }
                        if (oldIdx != null && newIdx != null) {
                          var removedObject = controller
                              .mainCommercialShowDetailsList
                              ?.removeAt(oldIdx);
                          if (removedObject != null) {
                            removedObject.breakNumber = controller
                                .mainCommercialShowDetailsList?[newIdx - 1]
                                .breakNumber;
                            removedObject.fpcTime2 = controller
                                .mainCommercialShowDetailsList?[newIdx - 1]
                                .fpcTime2;
                            removedObject.fpcTime = controller
                                .mainCommercialShowDetailsList?[newIdx - 1]
                                .fpcTime;
                            controller.mainCommercialShowDetailsList
                                ?.insert(newIdx, removedObject);
                          }
                        }

                        for (var i = 0;
                            i <
                                (controller.mainCommercialShowDetailsList
                                        ?.length ??
                                    0);
                            i++) {
                          controller
                              .mainCommercialShowDetailsList?[i].rownumber = i;
                        }

                        // var newRow = controller.gridStateManager?.currentRow;
                        // controller.gridStateManager?.removeCurrentRow();
                        // controller.gridStateManager?.insertRows(
                        //     onRowMoved.idx, [onRowMoved.rows[onRowMoved.idx]]);
                        // controller.gridStateManager?.notifyListeners(true,
                        //     controller.gridStateManager?.insertRows.hashCode);
                        // controller.selectedDDIndex = onRowMoved.idx;
                      }
                    } catch (e) {
                      LoadingDialog.showErrorDialog(e.toString());
                    }
                    controller.selectedDDIndex = onRowMoved.idx;
                    if (controller.canshowFilterList) {
                      controller.showSelectedProgramList();
                    } else {
                      controller.showTabList();
                    }
                  },
                  mode: PlutoGridMode.selectWithOneTap,
                  mapData: controller.showCommercialDetailsList!.value
                      .map((e) => e.toJson(fromSave: false))
                      .toList(),
                ),
              );
            } else {
              return Expanded(
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0), // if you need this
                    side: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  child: Container(
                    height: Get.height - (4 * kToolbarHeight),
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  /// tab 1 ( F )
  Widget fpcMismatchView(BuildContext context) {
    return Column(
      children: [
        GetBuilder<CommercialController>(
            id: "fpcMismatchTable",
            init: controller,
            builder: (controller) {
              if (controller.showCommercialDetailsList != null &&
                  (controller.showCommercialDetailsList?.isNotEmpty)!) {
                return Expanded(
                  child: DataGridFromMap(
                    witdthSpecificColumn: (controller
                        .userDataSettings?.userSetting
                        ?.firstWhere(
                            (element) => element.controlName == "fpcMisMatchSM",
                            orElse: () => UserSetting())
                        .userSettings),
                    // witdthSpecificColumn: controller.userGridSetting1
                    //     ?.firstWhereOrNull((element) =>
                    //         element['controlName'].toString() == "3_table"),
                    onload: (sm) {
                      controller.fpcMisMatchSM = sm.stateManager;
                      controller.fpcMisMatchSM
                          ?.setSelectingMode(PlutoGridSelectingMode.row);
                      controller.fpcMisMatchSM?.setSelecting(true);
                      controller.fpcMisMatchSM?.setCurrentCell(
                          controller.fpcMisMatchSM
                              ?.getRowByIdx(controller.mainSelectedIndex)
                              ?.cells['eventType'],
                          controller.mainSelectedIndex ?? 0);
                      controller.fpcMisMatchSM?.moveCurrentCellByRowIdx(
                          controller.mainSelectedIndex ?? 0,
                          PlutoMoveDirection.down);
                    },
                    mapData: (controller.showCommercialDetailsList
                        ?.map((e) => e.toJson())
                        .toList())!,
                    showonly: const [
                      "fpcTime",
                      "breakNumber",
                      "eventType",
                      "exportTapeCode",
                      "segmentCaption",
                      "client",
                      "brand",
                      "duration",
                      "product",
                      "bookingNumber",
                      "bookingDetailcode",
                      "rostimeBand",
                      "randid",
                      "programName",
                      "rownumber",
                      "bStatus",
                      "pDailyFPC",
                      "pProgramMaster"
                    ],
                    mode: PlutoGridMode.normal,
                    colorCallback: (row) => (row.row.cells.containsValue(
                            controller.fpcMisMatchSM?.currentCell))
                        ? Colors.deepPurple.shade200
                        : Colors.white,
                    onRowDoubleTap: (plutoGrid) {
                      controller.mainSelectedIndex = plutoGrid.rowIdx;
                      if (controller.changeFpcTaped) {
                        controller.changeFpcTaped = false;
                        controller.showCommercialDetailsList?.value = controller
                            .mainCommercialShowDetailsList!
                            .where((o) => o.bStatus.toString() == 'F')
                            .toList();
                        controller.update(['fpcMismatchTable']);
                      }
                      controller.fpcMisMatchSM?.setCurrentCell(
                          controller.fpcMisMatchSM
                              ?.getRowByIdx(controller.mainSelectedIndex)
                              ?.cells['eventType'],
                          controller.mainSelectedIndex ?? 0);
                      controller.selectedShowOnTab = controller
                          .showCommercialDetailsList![plutoGrid.rowIdx];

                      controller.exportTapeCodeSelected = controller
                          .showCommercialDetailsList![plutoGrid.rowIdx]
                          .exportTapeCode
                          .toString();

                      controller.pDailyFPCSelected = controller
                          .showCommercialDetailsList![plutoGrid.rowIdx]
                          .pDailyFPC
                          .toString();
                    },
                    onSelected: (plutoGrid) {
                      // print(plutoGrid.rowIdx!.toString());

                      controller.mainSelectedIndex = plutoGrid.rowIdx!;
                      controller.selectedShowOnTab = controller
                          .showCommercialDetailsList![plutoGrid.rowIdx!];

                      controller.exportTapeCodeSelected = controller
                          .showCommercialDetailsList![plutoGrid.rowIdx!]
                          .exportTapeCode
                          .toString();

                      controller.pDailyFPCSelected = controller
                          .showCommercialDetailsList![plutoGrid.rowIdx!]
                          .pDailyFPC
                          .toString();

                      // print(">>>>>> fpcMismatchTable Data >>>>>>${jsonEncode(controller.selectedShowOnTab?.toJson())}");
                    },
                  ),
                );
              } else {
                return Expanded(
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(0), // if you need this
                      side: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: Container(
                      height: Get.height - (4 * kToolbarHeight),
                    ),
                  ),
                );
              }
            }),
      ],
    );
  }

  /// tab 2 ( E )
  Widget markedAsErrorView(BuildContext context) {
    return Column(
      children: [
        GetBuilder<CommercialController>(
            id: "misMatchTable",
            builder: (controller) {
              if (controller.showCommercialDetailsList != null &&
                  (controller.showCommercialDetailsList?.isNotEmpty)!) {
                return Expanded(
                  child: DataGridFromMap(
                    // witdthSpecificColumn: controller.userGridSetting1
                    //     ?.firstWhereOrNull((element) =>
                    //         element['controlName'].toString() == "4_table"),
                    witdthSpecificColumn: (controller
                        .userDataSettings?.userSetting
                        ?.firstWhere(
                            (element) =>
                                element.controlName == "markedAsErrorSM",
                            orElse: () => UserSetting())
                        .userSettings),
                    colorCallback: (row) => (row.row.cells.containsValue(
                            controller.markedAsErrorSM?.currentCell))
                        ? Colors.deepPurple.shade200
                        : Colors.white,
                    mapData: (controller.showCommercialDetailsList
                        ?.map((e) => e.toJson())
                        .toList())!,
                    showonly: const [
                      "fpcTime",
                      "breakNumber",
                      "eventType",
                      "exportTapeCode",
                      "segmentCaption",
                      "client",
                      "brand",
                      "duration",
                      "product",
                      "bookingNumber",
                      "bookingDetailcode",
                      "rostimeBand",
                      "randid",
                      "programName",
                      "rownumber",
                      "bStatus",
                      "pDailyFPC",
                      "pProgramMaster"
                    ],
                    mode: PlutoGridMode.normal,
                    onload: (sm) {
                      controller.markedAsErrorSM = sm.stateManager;
                      controller.markedAsErrorSM?.setSelecting(true);
                      sm.stateManager
                          .setSelectingMode(PlutoGridSelectingMode.row);
                      controller.markedAsErrorSM?.setCurrentCell(
                          controller.markedAsErrorSM
                              ?.getRowByIdx(controller.mainSelectedIndex)
                              ?.cells['eventType'],
                          controller.mainSelectedIndex ?? 0);
                      controller.markedAsErrorSM?.moveCurrentCellByRowIdx(
                          controller.mainSelectedIndex ?? 0,
                          PlutoMoveDirection.down);
                    },
                    onSelected: (plutoGrid) {
                      controller.mainSelectedIndex = plutoGrid.rowIdx!;
                      controller.selectedShowOnTab = controller
                          .showCommercialDetailsList![plutoGrid.rowIdx!];
                    },
                  ),
                );
              } else {
                return Expanded(
                  child: Card(
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(0), // if you need this
                      side: BorderSide(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    child: Container(
                      height: Get.height - (4 * kToolbarHeight),
                    ),
                  ),
                );
              }
            }),
      ],
    );
  }

  formHandler(btnName) async {
    if (btnName == "Clear") {
      Get.delete<CommercialController>();
      Get.find<HomeController>().clearPage1();
    }

    if (btnName == "Save") {
      controller.saveSchedulingData();
    }

    if (btnName == "Exit") {
      Get.find<HomeController>().postUserGridSetting2(listStateManager: [
        {"sm": controller.sm},
        {"gridStateManager": controller.gridStateManager},
        {"fpcMisMatchSM": controller.fpcMisMatchSM},
        {"markedAsErrorSM": controller.markedAsErrorSM},
      ]);
    }
  }
}

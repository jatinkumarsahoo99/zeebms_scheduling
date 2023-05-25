import 'dart:convert';
import 'package:bms_scheduling/app/modules/commercial/CommercialShowOnTabModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/providers/extensions/string_extensions.dart';
import 'package:bms_scheduling/widgets/LoadingScreen.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../../widgets/gridFromMap1.dart';
import '../../../../widgets/input_fields.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../controller/HomeController.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/DataGridMenu.dart';
import '../../../providers/SizeDefine.dart';
import '../../../providers/Utils.dart';
import '../../../styles/theme.dart';
import '../controllers/commercial_controller.dart';

class CommercialView extends GetView<CommercialController> {
  CommercialView({Key? key}) : super(key: key);

  late PlutoGridStateManager stateManager;
  var formName = 'Schedule Commercials';

  void handleOnRowChecked(PlutoGridOnRowCheckedEvent event) {}
  CommercialController controllerX = Get.put(CommercialController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommercialController>(
        init: CommercialController(),
        id: "initData",
        builder: (controller) {
          FocusNode _channelsFocus = FocusNode();

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
                                    controllerX.locations.value,
                                    (value) {
                                      controller.selectedLocation = value;
                                      controllerX.getChannel(value.key);
                                    },
                                    "Location",
                                    0.12,
                                    isEnable: controllerX.isEnable.value,
                                    selected: controllerX.selectedLocation,
                                    autoFocus: true,
                                    dialogWidth: 330,
                                    dialogHeight: Get.height * .7,
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
                                  ),
                                ),
                                const SizedBox(width: 15),
                                DateWithThreeTextField(
                                  title: "From Date",
                                  mainTextController: controllerX.date_,
                                  widthRation: controllerX.widthSize,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 17.0),
                                  child: FormButton(
                                    btnText: "show details",
                                    callback: () {
                                      controllerX.selectedIndex.value = 0;
                                      controllerX.fetchProgramSchedulingDetails();
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 17.0),
                                  child: FormButton(
                                    btnText: "verify",
                                    callback: () {},
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0, left: 15),
                                  child: Row(
                                    children: [
                                      Radio(
                                        value: 0,
                                        groupValue: controllerX.selectedGroup,
                                        onChanged: (int? value) {},
                                      ),
                                      const Text('Insert After'),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Radio(
                                        value: 1,
                                        groupValue: controllerX.selectedGroup,
                                        onChanged: (int? value) {},
                                      ),
                                      const Text('Auto Shuffle'),
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
                                  padding: const EdgeInsets.fromLTRB(15, 15, 7, 0),
                                  child: programTable(context),
                                ),
                              ),

                              /// output forms
                              Expanded(
                                flex: 2,
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(15, 15, 7, 0),
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
                                        btnText: btn["name"],
                                        callback: () => controller.formHandler(
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
                    groupValue: controllerX.selectedIndex.value,
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
                    onValueChanged: (int? value) {
                      print("Index1 is>>" + value.toString());
                      controllerX.selectedIndex.value = value!;

                      //controllerX.fetchSchedulingShowOnTabDetails();
                      if (controllerX.selectedIndex.value == 1) {
                        ///Filter bStatus F, calculate spot duration then calling ColorGrid filter
                        controllerX.showCommercialDetailsList?.value =
                            controllerX.mainCommercialShowDetailsList!.where((o) => o.bStatus.toString() == 'F').toList();
                        controllerX.showCommercialDetailsList?.refresh();
                      } else if (controllerX.selectedIndex.value == 2) {
                        ///Filter bStatus E, calculate spot duration then calling ColorGrid filter
                        controllerX.showCommercialDetailsList?.value =
                            controllerX.mainCommercialShowDetailsList!.where((o) => o.bStatus.toString() == 'E').toList();
                        controllerX.showCommercialDetailsList?.refresh();
                      } else {
                        ///Filter bStatus B, calculate spot duration then calling ColorGrid filter
                        controllerX.showCommercialDetailsList?.value =
                            controllerX.mainCommercialShowDetailsList!.where((o) => o.bStatus.toString() == 'B').toList();
                        controllerX.showCommercialDetailsList?.refresh();
                      }
                    },
                  ),
                  const Spacer(),
                  if (controllerX.selectedIndex.value == 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(() => Text('Commercial Spots : ${controllerX.commercialSpots.value}')),
                        const SizedBox(
                          width: 20,
                        ),
                        Obx(() => Text('Commercial Duration : ${controllerX.commercialDuration.value}')),
                      ],
                    )
                  else if (controllerX.selectedIndex.value == 1)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      //mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FormButton(
                          btnText: "Change FPC",
                          callback: () {
                            /// FPCTime,
                          },
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        FormButton(
                          btnText: "Mis-Match",
                          callback: () {},
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        FormButton(
                          btnText: "Mark-as-Error",
                          callback: () {},
                        ),
                      ],
                    )
                  else if (controllerX.selectedIndex.value == 2)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        FormButton(
                          btnText: "Mark-as-Error",
                          callback: () {},
                        ),
                      ],
                    ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  if (controllerX.selectedIndex.value == 0)
                    Expanded(child: schedulingView(context))

                  /// Filter B, calculate spot duration
                  else if (controllerX.selectedIndex.value == 1)
                    Expanded(child: fpcMismatchView(context))

                  /// Filter F, calculate spot duration
                  else if (controllerX.selectedIndex.value == 2)
                    Expanded(child: markedAsErrorView(context))

                  /// Filter E, calculate spot duration
                ],
              ),
            ),
          ],
        ));
  }

  Widget programTable(context) {
    return GetBuilder<CommercialController>(
        id: "fillerFPCProgramTable",
        // init: CreateBreakPatternController(),
        builder: (controller) {
          if (controllerX.commercialProgramList != null && (controllerX.commercialProgramList?.isNotEmpty)!) {
            return DataGridFromMap(
              mapData: (controllerX.commercialProgramList?.map((e) => e.toJson()).toList())!,
              showonly: [
                "fpcTime",
                "programname",
              ],
              mode: PlutoGridMode.select,
              onSelected: (plutoGrid) {
                controllerX.selectedProgram = controllerX.commercialProgramList![plutoGrid.rowIdx!];
                controllerX.fpcTimeSelected = controllerX.commercialProgramList![plutoGrid.rowIdx!].fpcTime;
                print(jsonEncode(controllerX.selectedProgram?.toJson()));

                if (controllerX.selectedIndex.value == 1) {
                  ///Filter F, calculate spot duration then calling ColorGrid filter
                  controllerX.showCommercialDetailsList?.value = controllerX.mainCommercialShowDetailsList!
                      .where((o) => o.fpcTime.toString() == controllerX.fpcTimeSelected && o.bStatus.toString() == 'F')
                      .toList();
                  controllerX.showCommercialDetailsList?.refresh();
                } else if (controllerX.selectedIndex.value == 2) {
                  ///Filter E, calculate spot duration then calling ColorGrid filter
                  controllerX.showCommercialDetailsList?.value = controllerX.mainCommercialShowDetailsList!
                      .where((o) => o.fpcTime.toString() == controllerX.fpcTimeSelected && o.bStatus.toString() == 'E')
                      .toList();
                  controllerX.showCommercialDetailsList?.refresh();
                } else {
                  ///Filter B, calculate spot duration then calling ColorGrid filter
                  controllerX.showCommercialDetailsList?.value = controllerX.mainCommercialShowDetailsList!
                      .where((o) => o.fpcTime.toString() == controllerX.fpcTimeSelected && o.bStatus.toString() == 'B')
                      .toList();
                  controllerX.showCommercialDetailsList?.refresh();
                }

                //controllerX.fetchSchedulingShowOnTabDetails();
              },
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

  /// tab 0 ( A ) recommended date 22 March 2023
  Widget schedulingView(BuildContext context) {
    return Column(
      children: [
        GetBuilder<CommercialController>(
            id: "fillerShowOnTabTable",
            // init: CreateBreakPatternController(),
            builder: (controller) {
              if (controllerX.showCommercialDetailsList != null && (controllerX.showCommercialDetailsList?.isNotEmpty)!) {
                // final key = GlobalKey();
                return Expanded(
                    child: DataGridFromMap1(
                        onFocusChange: (value) {
                          controllerX.gridStateManager!.setGridMode(PlutoGridMode.selectWithOneTap);
                          controllerX.selectedPlutoGridMode = PlutoGridMode.selectWithOneTap;
                        },
                        onload: (loadevent) {
                          controllerX.gridStateManager = loadevent.stateManager;
                          if (controller.selectedDDIndex != null) {
                            loadevent.stateManager.moveScrollByRow(PlutoMoveDirection.down, controller.selectedDDIndex);
                            loadevent.stateManager.setCurrentCell(
                                loadevent.stateManager.rows[controller.selectedDDIndex!].cells.entries.first.value, controller.selectedDDIndex);
                          }
                        },
                        showSrNo: true,
                        showonly: [
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
                        colorCallback: (PlutoRowColorContext plutoContext) {
                          return Color(int.parse('0x${controllerX.showCommercialDetailsList![plutoContext.rowIdx].backColor}'));
                        },

                        /// From lstLoadColours List check If EventType 'S' or etc show colors accordingly
                        // colorCallback: (row) {
                        //   return row.row.cells.containsValue(
                        //           controller.stateManager?.currentCell)
                        //       ? Colors.blueAccent
                        //       : controller.redBreaks.contains(row.rowIdx -
                        //               1)
                        //           ? Colors.white
                        //           : Colors.orange.shade700;
                        // },
                        onSelected: (PlutoGridOnSelectedEvent event) {
                          controllerX.selectedShowOnTab = controllerX.showCommercialDetailsList![event.rowIdx!];
                          print(">>>>>>Commercial Data>>>>>>" + jsonEncode(controllerX.selectedShowOnTab?.toJson()));
                        },
                        onRowsMoved: (PlutoGridOnRowsMovedEvent onRowMoved) {
                          print("Index is>>" + onRowMoved.idx.toString());
                          Map map = onRowMoved.rows[0].cells;
                          print("On Print moved" + jsonEncode(onRowMoved.rows[0].cells.toString()));
                          controllerX.gridStateManager?.notifyListeners();
                        },
                        mode: controllerX.selectedPlutoGridMode,
                        mapData: controllerX.showCommercialDetailsList!.value.map((e) => e.toJson()).toList()));
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
            }),
      ],
    );
  }

  /// tab 1 ( B )
  Widget fpcMismatchView(BuildContext context) {
    return Column(
      children: [
        GetBuilder<CommercialController>(
            id: "fillerShowOnTabTable",
            // init: CreateBreakPatternController(),
            builder: (controller) {
              if (controllerX.showCommercialDetailsList != null && (controllerX.showCommercialDetailsList?.isNotEmpty)!) {
                // final key = GlobalKey();
                return Expanded(
                  // height: 400,
                  child: DataGridFromMap(
                    mapData: (controllerX.showCommercialDetailsList?.map((e) => e.toJson()).toList())!,
                    showonly: [
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
                    //widthRatio: (Get.width * 0.2) / 2 + 7,
                    //mode: PlutoGridMode.select,
                    onSelected: (plutoGrid) {
                      controllerX.selectedShowOnTab = controllerX.showCommercialDetailsList![plutoGrid.rowIdx!];
                      print(">>>>>>FPC Data>>>>>>" + jsonEncode(controllerX.selectedShowOnTab?.toJson()));
                    },
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
            }),
      ],
    );
  }

  /// tab 2 ( C )
  Widget markedAsErrorView(BuildContext context) {
    return Column(
      children: [
        GetBuilder<CommercialController>(
            id: "fillerShowOnTabTable",
            // init: CreateBreakPatternController(),
            builder: (controller) {
              if (controllerX.showCommercialDetailsList != null && (controllerX.showCommercialDetailsList?.isNotEmpty)!) {
                // final key = GlobalKey();
                return Expanded(
                  // height: 400,
                  child: DataGridFromMap(
                    mapData: (controllerX.showCommercialDetailsList?.map((e) => e.toJson()).toList())!,
                    showonly: [
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
                    //mode: PlutoGridMode.select,
                    onSelected: (plutoGrid) {
                      controllerX.selectedShowOnTab = controllerX.showCommercialDetailsList![plutoGrid.rowIdx!];
                      print(">>>>>>Error Data>>>>>>" + jsonEncode(controllerX.selectedShowOnTab?.toJson()));
                    },
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
            }),
      ],
    );
  }
}

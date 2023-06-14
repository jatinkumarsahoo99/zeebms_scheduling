import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';
import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/LoadingDialog.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../../widgets/gridFromMap1.dart';
import '../../../controller/HomeController.dart';
import '../../../providers/SizeDefine.dart';
import '../../../providers/Utils.dart';
import '../controllers/commercial_controller.dart';

class CommercialView extends GetView<CommercialController> {
  CommercialView({Key? key}) : super(key: key);

  var formName = 'Schedule Commercials';
  void handleOnRowChecked(PlutoGridOnRowCheckedEvent event) {}

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommercialController>(
        init: CommercialController(),
        id: "initData",
        builder: (controller) {
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
                                  mainTextController: controller.date_,
                                  widthRation: controller.widthSize,
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 17.0),
                                  child: FormButton(
                                    btnText: "show details",
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
                                        groupValue: controller.selectedGroup,
                                        onChanged: (int? value) {},
                                      ),
                                      const Text('Insert After'),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Radio(
                                        value: 1,
                                        groupValue: controller.selectedGroup,
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
                      print("Selected tab index is : $value");
                      controller.selectedIndex.value = value!;
                      await controller.showTabList();
                      if (controller.programFpcTimeSelected != null && controller.selectedProgram != null) {
                        await controller.showSelectedProgramList(context);
                        controller.updateAllTabs();
                      }
                      //controller.fetchSchedulingShowOnTabDetails();
                    },
                  ),
                  const Spacer(),
                  if (controller.selectedIndex.value == 0)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(() => Text('Commercial Spots : ${controller.commercialSpots.value}')),
                        const SizedBox(
                          width: 20,
                        ),
                        Obx(() => Text('Commercial Duration : ${controller.commercialDuration.value}')),
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
          if (controller.commercialProgramList != null && (controller.commercialProgramList?.isNotEmpty)!) {
            return DataGridFromMap(
              onload: (sm) {
                sm.stateManager
                    .setCurrentCell(sm.stateManager.getRowByIdx(controller.leftTableSelectedIdx)?.cells['fpcTime'], controller.leftTableSelectedIdx);
              },
              colorCallback: (colorRow) {
                if (colorRow.rowIdx == controller.leftTableSelectedIdx) {
                  return Colors.deepPurple[200]!;
                } else {
                  return Colors.white;
                }
              },
              mode: controller.selectedProgramPlutoGridMode,
              showonly: const [
                "fpcTime",
                "programname",
              ],
              mapData: (controller.commercialProgramList?.map((e) => e.toJson()).toList())!,
              onSelected: (plutoGrid) {
                controller.leftTableSelectedIdx = plutoGrid.rowIdx ?? 0;
                controller.selectedProgram = controller.commercialProgramList![plutoGrid.rowIdx!];
                controller.programFpcTimeSelected = controller.commercialProgramList![plutoGrid.rowIdx!].fpcTime;
                controller.programCodeSelected = controller.commercialProgramList![plutoGrid.rowIdx!].programcode;
                print(jsonEncode(controller.selectedProgram?.toJson()));
              },
              onRowDoubleTap: (plutoGrid) async {
                // try {
                //   var cList =
                //       controller.mainCommercialShowDetailsList!.where((o) => o.eventType.toString() == 'C' && o.bStatus.toString() == 'B').toList();
                //   controller.commercialSpots.value = cList.where((o) => o.eventType == "C").toList().length.toString();
                //   print(cList.where((o) => o.eventType == "C").toList().length.toString());
                //   print(controller.commercialSpots.value);
                //   double intTotalDuration = 0;

                //   for (int i = 0; i <= cList.length - 1; i++) {
                //     intTotalDuration = intTotalDuration + Utils.oldBMSConvertToSecondsValue(value: cList[i].duration!);
                //   }
                //   controller.commercialDuration.value = Utils.convertToTimeFromDouble(value: intTotalDuration);
                //   // controller.commercialSpots.refresh();
                //   // controller.commercialDuration.refresh();
                // } catch (e) {}
                controller.leftTableSelectedIdx = plutoGrid.rowIdx;
                controller.selectedProgram = controller.commercialProgramList![plutoGrid.rowIdx];
                controller.programFpcTimeSelected = controller.commercialProgramList![plutoGrid.rowIdx].fpcTime;
                await controller.showSelectedProgramList(context);
                controller.updateAllTabs();
                print('on Double tap ${jsonEncode(controller.selectedProgram?.toJson())}');
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

  /// tab 0 ( B ) recommended date 22 March 2023
  Widget schedulingView(BuildContext context) {
    return Column(
      children: [
        GetBuilder<CommercialController>(
          id: "schedulingTable",
          builder: (controller) {
            if (controller.showCommercialDetailsList != null && (controller.showCommercialDetailsList?.isNotEmpty)!) {
              return Expanded(
                  child: DataGridFromMap1(
                      onload: (event) {
                        controller.gridStateManager = event.stateManager;
                        if (controller.selectedDDIndex != null) {
                          event.stateManager.moveScrollByRow(PlutoMoveDirection.down, controller.selectedDDIndex);
                          event.stateManager.setCurrentCell(
                              event.stateManager.rows[controller.selectedDDIndex!].cells.entries.first.value, controller.selectedDDIndex);
                          controller.updateAllTabs();
                        }
                      },
                      showSrNo: true,
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
                      colorCallback: (PlutoRowColorContext plutoContext) {
                        try {
                          return controller.colorSort(controller.showCommercialDetailsList![plutoContext.rowIdx].eventType.toString());
                          // return Color(int.parse(
                          //     '0x${controller.showCommercialDetailsList![plutoContext.rowIdx].backColor}'));
                        } catch (e) {
                          print(" Color Call Back error from schedulingTable ${e.toString()}");
                          return Colors.white;
                        }
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
                        controller.selectedShowOnTab = controller.showCommercialDetailsList![event.rowIdx!];
                        print(">>>>>> Commercial Data >>>>>>${jsonEncode(controller.selectedShowOnTab?.toJson())}");
                      },
                      onRowsMoved: (PlutoGridOnRowsMovedEvent onRowMoved) {
                        if (controller.showCommercialDetailsList![onRowMoved.idx].eventType != "S ") {
                          print(" onRowMoved Index is>>${onRowMoved.idx}");
                          Map map = onRowMoved.rows[0].cells;
                          print(" On Print moved${jsonEncode(onRowMoved.rows[0].cells.toString())}");
                          controller.gridStateManager?.notifyListeners();
                        } else {
                          LoadingDialog.showErrorDialog("You cannot move selected segment");
                        }
                        controller.updateAllTabs();
                      },
                      mode: controller.selectedTabPlutoGridMode,
                      mapData: controller.showCommercialDetailsList!.value.map((e) => e.toJson()).toList()));
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
            builder: (controller) {
              if (controller.showCommercialDetailsList != null && (controller.showCommercialDetailsList?.isNotEmpty)!) {
                print(' fpcMisMatchTable : ${controller.showCommercialDetailsList?.length.toString()}');
                return Expanded(
                  child: DataGridFromMap(
                    mapData: (controller.showCommercialDetailsList?.map((e) => e.toJson()).toList())!,
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
                    mode: PlutoGridMode.selectWithOneTap,
                    onSelected: (plutoGrid) {
                      print(plutoGrid.rowIdx!.toString());

                      controller.mainSelectedIndex = plutoGrid.rowIdx!;
                      controller.selectedShowOnTab = controller.showCommercialDetailsList![plutoGrid.rowIdx!];

                      controller.exportTapeCodeSelected = controller.showCommercialDetailsList![plutoGrid.rowIdx!].exportTapeCode.toString();

                      controller.pDailyFPCSelected = controller.showCommercialDetailsList![plutoGrid.rowIdx!].pDailyFPC.toString();

                      print(">>>>>> fpcMismatchTable Data >>>>>>${jsonEncode(controller.selectedShowOnTab?.toJson())}");
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

  /// tab 2 ( E )
  Widget markedAsErrorView(BuildContext context) {
    return Column(
      children: [
        GetBuilder<CommercialController>(
            id: "misMatchTable",
            // init: CreateBreakPatternController(),
            builder: (controller) {
              if (controller.showCommercialDetailsList != null && (controller.showCommercialDetailsList?.isNotEmpty)!) {
                print(' misMatchTable : ${controller.showCommercialDetailsList?.length.toString()}');
                // final key = GlobalKey();
                return Expanded(
                  // height: 400,
                  child: DataGridFromMap(
                    mapData: (controller.showCommercialDetailsList?.map((e) => e.toJson()).toList())!,
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
                    mode: PlutoGridMode.selectWithOneTap,
                    onSelected: (plutoGrid) {
                      print(plutoGrid.rowIdx!.toString());
                      controller.mainSelectedIndex = plutoGrid.rowIdx!;
                      controller.selectedShowOnTab = controller.showCommercialDetailsList![plutoGrid.rowIdx!];
                      print(">>>>>>Error Data>>>>>>${jsonEncode(controller.selectedShowOnTab?.toJson())}");
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

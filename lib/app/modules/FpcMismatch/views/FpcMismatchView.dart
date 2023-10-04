import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/DateWidget.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../data/PermissionModel.dart';
import '../../../data/user_data_settings_model.dart';
import '../../../providers/Utils.dart';
import '../controllers/FpcMismatchController.dart';

class FpcMismatchView extends GetView<FpcMismatchController> {
  void formHandler(btnText) {
    switch (btnText) {
      case "Save":
        controllerX.saveFPCMistmatch();
        break;
      case "Clear":
        Get.delete<FpcMismatchController>();
        Get.find<HomeController>().clearPage1();
        // controllerX.clear();
        break;
      case "Exit":
        Get.find<HomeController>().postUserGridSetting2(listStateManager: [
          {"fpcMaster": controller.stateManager},
          {"programTable": controller.programTable},
        ]);
        // Get.delete<FpcMismatchController>();
        break;
      case "Refresh":
        // controllerX.fetchMismatchAll();
        break;
    }
  }

  FpcMismatchController controllerX = Get.put(FpcMismatchController());
  final GlobalKey rebuildKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: rebuildKey,
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(50),
      //   child: FormAppBar(title: 'DailyFPC', isBackBtnVisible: false),
      // ),
      // appBar: FormAppBar.appBar("FPC Mismatch", () {
      //   Get.back();
      // }, context, false),
      body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            GetBuilder<FpcMismatchController>(
              id: "initialData",
              builder: (control) {
                print("List data>>>" + controllerX.locationList.toString());
                return Padding(
                  padding: const EdgeInsets.only(left: 18.0, top: 10),
                  child: Row(
                    children: [
                      Obx(
                        () => DropDownField.formDropDown1WidthMap(
                          controllerX.locationList?.value ?? [],
                          (value) {
                            controllerX.selectedLocation = value;
                            controllerX.fetchChannel();
                          },
                          "Location",
                          controllerX.widthSize,
                          // isEnable: controllerX.isEnable.value,
                          selected: controllerX.selectedLocation,
                          // autoFocus: true,
                          dialogWidth: 300,
                          dialogHeight: Get.height * .7,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Obx(
                        () => DropDownField.formDropDown1WidthMap(
                          controllerX.channelList?.value ?? [],
                          (value) {
                            controllerX.selectedChannel = value;
                            print("Value is>>>" + value.toString());
                          },
                          "Channel",
                          controllerX.widthSize,
                          // isEnable: controllerX.isEnable.value,
                          selected: controllerX.selectedChannel,
                          // autoFocus: true,
                          dialogWidth: 300,
                          dialogHeight: Get.height * .7,
                        ),
                      ),
                      /*  DateWidget.dateStartDtEndDt3(context, "As On Date",
                          (data) {
                        log(">>>>" + data.toString());
                        // controllerX.inwardToDt = data;
                        controllerX.selectedDate = data;
                        controllerX.date_.text =
                            DateFormat("dd/MM/yyyy").format(data);
                      },
                          // startDt: DateTime.now(),
                          //Note: Data Availble on 1 OCT 2012
                          startDt: DateTime.now().subtract(Duration(days: 5000)),
                          endDt: DateTime.now().add(Duration(days: 1825)),
                          initialValue: controllerX.date_.text,
                          widthRatio: controllerX.widthSize),*/
                      SizedBox(
                        width: 5,
                      ),
                      DateWithThreeTextField(
                        title: "As On Date",
                        // startDate: DateTime.now(),
                        //Note: Data Availble on 1 OCT 2012
                        startDate: kDebugMode
                            ? DateTime.now().subtract(Duration(days: 5000))
                            : DateTime.now(),
                        endDate: DateTime.now().add(Duration(days: 1825)),
                        mainTextController: controllerX.date_,
                        widthRation: controllerX.widthSize,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 4,
                            ),
                            GetBuilder<FpcMismatchController>(
                              id: "button_data",
                              init: controllerX,
                              builder: (controller) {
                                print("Rebuild called for buttons>>>" +
                                    controllerX.selectButton.toString());
                                return Row(
                                  children: [
                                    FormButton(
                                      btnText: "  Display Mismatch  ",
                                      callback: () {
                                        controllerX.hideKeysAllowed.value =
                                            false;
                                        controllerX.fetchMismatch();
                                        controllerX.fetchProgram();
                                      },
                                      showIcon: controllerX.selectButton ==
                                              SelectButton.DisplayMismatch
                                          ? true
                                          : false,
                                      iconDataM:
                                          Icons.check_circle_outline_sharp,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    FormButton(
                                      btnText: "  Display Error  ",
                                      callback: () {
                                        controllerX.hideKeysAllowed.value =
                                            false;
                                        controllerX.fetchMismatchError();
                                        controllerX.fetchProgram();
                                      },
                                      showIcon: controllerX.selectButton ==
                                              SelectButton.DisplayError
                                          ? true
                                          : false,
                                      iconDataM:
                                          Icons.check_circle_outline_sharp,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    FormButton(
                                      btnText: "  Display All  ",
                                      callback: () {
                                        controllerX.hideKeysAllowed.value =
                                            true;
                                        controllerX.fetchMismatchAll();
                                        controllerX.fetchProgram();
                                      },
                                      showIcon: controllerX.selectButton ==
                                              SelectButton.DisplayAll
                                          ? true
                                          : false,
                                      iconDataM:
                                          Icons.check_circle_outline_sharp,
                                    ),
                                  ],
                                );
                              },
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Container(
                              width: 2,
                              height: 35,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            FormButton2(
                              btnText: "  Mark Error  ",
                              callback: () {
                                controllerX.saveMarkError();
                                // controllerX.fetchMismatch();
                                // controllerX.fetchProgram();
                              },
                              showIcon: false,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            FormButton2(
                              btnText: "  Undo Error  ",
                              callback: () {
                                controllerX.saveUndoMarkError();
                                // controllerX.fetchMismatchError();
                                // controllerX.fetchProgram();
                              },
                              showIcon: false,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            Divider(),
            Expanded(
              child: Row(
                children: [
                  /*Expanded(
                      flex: 8,
                      child: (controllerX.dataTable != null)
                          ? _dataTable2()
                          : Container()),*/
                  _dataTable1(context),
                  programTable(context)
                ],
              ),
            ),
            /*Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Row(
                children: [
                  FormButton(
                    btnText: "  Make Error  ",
                    callback: () {
                      controllerX.saveMarkError();
                      // controllerX.fetchMismatch();
                      // controllerX.fetchProgram();
                    },
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  FormButton(
                    btnText: "  Undo Error  ",
                    callback: () {
                      controllerX.saveUndoMarkError();
                      // controllerX.fetchMismatchError();
                      // controllerX.fetchProgram();
                    },
                  ),
                ],
              ),
            ),*/
            GetBuilder<HomeController>(
                id: "buttons",
                init: Get.find<HomeController>(),
                builder: (controller) {
                  PermissionModel formPermissions = Get.find<MainController>()
                      .permissionList!
                      .lastWhere(
                          (element) => element.appFormName == "frmFPCMismatch");
                  if (controller.buttons != null) {
                    return ButtonBar(
                      alignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var btn in controller.buttons!)
                          FormButtonWrapper(
                            btnText: btn["name"],
                            callback: Utils.btnAccessHandler2(btn['name'],
                                        controller, formPermissions) ==
                                    null
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
          ],
        ),
      ),
    );
  }

  Widget _dataTable1(context) {
    return GetBuilder<FpcMismatchController>(
        id: "fpcMaster",
        // init: CreateBreakPatternController(),
        builder: (controller) {
          // print("Data grid values>>>" + controllerX.dataList.toString());
          if (controllerX.dataList != null &&
              (controllerX.dataList?.isNotEmpty)!) {
            // final key = GlobalKey();
            return Expanded(
              // height: 400,
              flex: 5,
              child: DataGridFromMap(
                witdthSpecificColumn: (controller.userDataSettings?.userSetting
                    ?.firstWhere(
                        (element) => element.controlName == "fpcMaster",
                        orElse: () => UserSetting())
                    .userSettings),
                showSrNo: true,
                mapData:
                    (controllerX.dataList?.map((e) => e.toJson1()).toList())!,
                widthRatio: 90,
                checkRow: true,
                hideKeys: controllerX.hideKeysAllowed.value
                    ? ["fpcType", "fpcProgram", "fpcTime"]
                    : [],
                hideCode: false,
                checkRowKey: "select",
                onload: (load) {
                  controllerX.stateManager = load.stateManager;
                  // load.stateManager.
                },
                onRowCheck: (PlutoGridOnRowCheckedEvent onRowCheckedEvent) {
                  if (onRowCheckedEvent.isRow) {
                    controllerX.dataList![onRowCheckedEvent.rowIdx!]
                        .selectItem = onRowCheckedEvent.isChecked;
                  } else {
                    controllerX.dataList?.forEach((element) {
                      element.selectItem = onRowCheckedEvent.isChecked;
                    });
                  }
                },
                colorCallback: (PlutoRowColorContext plutoContext) {
                  switch (controllerX.selectButton) {
                    case SelectButton.DisplayError:
                      return Colors.red;
                    case SelectButton.DisplayAll:
                      if (plutoContext.row.cells["bookingstatus"]?.value !=
                              null &&
                          plutoContext.row.cells["bookingstatus"]?.value
                                  .toString()
                                  .toLowerCase() ==
                              "e") {
                        return Colors.red;
                      } /*else if (plutoContext
                                  .row.cells["bookingstatus"]?.value !=
                              null &&
                          plutoContext.row.cells["bookingstatus"]?.value
                                  .toString()
                                  .toLowerCase() ==
                              "b") {
                        return Colors.yellow;
                      }*/ else {
                        return Colors.white;
                      }
                    case SelectButton.DisplayMismatch:
                      return Colors.white;
                    default:
                      return Colors.white;
                  }
                  return (controllerX
                          .dataList![plutoContext.rowIdx].selectItem)!
                      ? Colors.grey
                      : Colors.white;
                },
                mode: PlutoGridMode.selectWithOneTap,
                formatDate: false,
                /*onSelected: (PlutoGridOnSelectedEvent plutoEvnt) {
                  controllerX.dataList![plutoEvnt.rowIdx!].selectItem =
                      ((controllerX.dataList![plutoEvnt.rowIdx!].selectItem)!)
                          ? false
                          : true;
                  controller.update(["fpcMaster"]);
                },*/
              ),
            );
          } else {
            return SizedBox(
              width: Get.width * 0.75,
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
        });
  }

  Widget programTable(context) {
    return GetBuilder<FpcMismatchController>(
        id: "programTable",
        // init: CreateBreakPatternController(),
        builder: (controller) {
          if (controllerX.programList != null &&
              (controllerX.programList?.isNotEmpty)!) {
            // final key = GlobalKey();
            return Expanded(
              // height: 400,
              flex: 2,
              child: DataGridFromMap(
                witdthSpecificColumn: (controller.userDataSettings?.userSetting
                    ?.firstWhere(
                        (element) => element.controlName == "programTable",
                        orElse: () => UserSetting())
                    .userSettings),
                showSrNo: true,
                onload: (sm) {
                  controllerX.programTable = sm.stateManager;
                },
                mapData: (controllerX.programList
                    ?.map((e) => e.toJson1())
                    .toList())!,
                widthRatio: (Get.width * 0.2) / 2 + 7,
                mode: PlutoGridMode.selectWithOneTap,
                onSelected: (plutoGrid) {
                  controllerX.selectedProgram =
                      controllerX.programList![plutoGrid.rowIdx!];
                  print(">>>>>>Program Data>>>>>>" +
                      jsonEncode(controllerX.selectedProgram?.toJson()));
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
        });
  }
}

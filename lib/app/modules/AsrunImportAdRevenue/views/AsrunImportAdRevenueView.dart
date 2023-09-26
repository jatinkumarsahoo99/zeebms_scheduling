import 'dart:convert';

import 'package:bms_scheduling/app/modules/AsrunImportAdRevenue/bindings/arun_data.dart';
import 'package:bms_scheduling/app/providers/DataGridMenu.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';
import 'package:bms_scheduling/widgets/floating_dialog.dart';
import 'package:bms_scheduling/widgets/gridFromMap.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
// import '../../../../widgets/cutom_dropdown.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/input_fields.dart';
import '../../../controller/HomeController.dart';
import '../../../data/DropDownValue.dart';
import '../../../data/user_data_settings_model.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/SizeDefine.dart';
import '../controllers/AsrunImportController.dart';

class AsrunImportAdRevenueView extends StatelessWidget {
  AsrunImportController controller = Get.put(AsrunImportController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Obx(() => controller.drgabbleDialog.value != null
          ? DraggableFab(
              child: controller.drgabbleDialog.value!,
            )
          : SizedBox()),
      backgroundColor: Colors.grey[50],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Container(
              width: Get.width,
              padding: EdgeInsets.all(4),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: 5,
                spacing: 5,
                children: [
                  Obx(
                    () => DropDownField.formDropDown1WidthMap(
                      controller.locations.value,
                      (value) {
                        controller.selectLocation = value;
                        controller
                            .getChannels(controller.selectLocation?.key ?? "");
                      },
                      "Location",
                      0.12,
                      isEnable: controller.isEnable.value,
                      selected: controller.selectLocation,
                      autoFocus: true,
                      dialogWidth: 330,
                      dialogHeight: Get.height * .7,
                    ),
                  ),

                  /// channel
                  Obx(
                    () => DropDownField.formDropDown1WidthMap(
                      controller.channels.value,
                      (value) {
                        controller.selectChannel = value;
                      },
                      "Channel",
                      0.12,
                      isEnable: controller.isEnable.value,
                      selected: controller.selectChannel,
                      autoFocus: true,
                      dialogWidth: 330,
                      dialogHeight: Get.height * .7,
                    ),
                  ),
                  Obx(
                    () => DateWithThreeTextField(
                      title: "Log Date",
                      splitType: "-",
                      widthRation: 0.09,
                      isEnable: controller.isEnable.value,
                      onFocusChange: (data) async {
                        LoadingDialog.call(barrierDismissible: false);
                        await controller.loadAsrunData();
                        await controller.loadviewFPCData();
                        Get.back();
                      },
                      mainTextController: controller.selectedDate,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: FormButtonWrapper(
                      btnText: "ProgMismatch",
                      callback: () {
                        controller.updateFPCMismatch();
                      },
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 14.0, left: 5, right: 5),
                  //   child: FormButtonWrapper(
                  //     btnText: "ProgMismatch",
                  //     callback: () {},
                  //     showIcon: false,
                  //   ),
                  // ),
                  for (var checkbox in controller.checkboxesMap.entries)
                    FittedBox(
                      child: Row(
                        children: [
                          Obx(() => Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Checkbox(
                                  value: controller
                                      .checkboxesMap.value[checkbox.key],
                                  onChanged: (val) {
                                    controller.checkboxesMap
                                        .value[checkbox.key] = val;
                                    print(controller
                                        .checkboxesMap.value[checkbox.key]);
                                    print(controller.checkboxesMap.keys);
                                    print(
                                        controller.checkboxesMap.value['GFK']);
                                    controller.checkboxesMap.refresh();
                                  },
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0, left: 3),
                            child: Text(
                              checkbox.key,
                              style: TextStyle(fontSize: SizeDefine.labelSize1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  InputFields.formField1(
                    isEnable: false,
                    hintTxt: "Start Time",
                    controller: controller.startTime_,
                    width: 0.09,
                  ),
                ],
              ),
            ),
          ),
          // Divider(),

          GetBuilder<AsrunImportController>(
            id: "fpcData",
            init: controller,
            builder: (controller) {
              return Expanded(
                  // width: Get.width,
                  // height: Get.height * .33,
                  child: Container(
                color: Colors.white,
                child: (controller.asrunData != null)
                    ? DataGridShowOnlyKeys(
                        keysWidths: (controller.userDataSettings?.userSetting
                            ?.firstWhere(
                                (element) =>
                                    element.controlName == "gridStateManager",
                                orElse: () => UserSetting())
                            .userSettings),
                        exportFileName: "Asrun Import",
                        // onFocusChange: (value) {
                        //   // controller.gridStateManager!.setGridMode(PlutoGridMode.selectWithOneTap);
                        //   // controller.selectedPlutoGridMode = PlutoGridMode.selectWithOneTap;
                        // },
                        onload: (loadevent) {
                          loadevent.stateManager.setSelecting(true);
                          loadevent.stateManager
                              .setSelectingMode(PlutoGridSelectingMode.row);

                          controller.gridStateManager = loadevent.stateManager;
                          loadevent.stateManager.setCurrentCell(
                              loadevent.stateManager
                                  .getRowByIdx(0)
                                  ?.cells['eventNumber'],
                              controller.selectedIndex);

                          // if (controller.selectedIndex != null) {
                          //   loadevent.stateManager.moveScrollByRow(PlutoMoveDirection.down, controller.selectedIndex);
                          //   loadevent.stateManager.setCurrentCell(
                          //       loadevent.stateManager.rows[controller.selectedIndex!].cells.entries.first.value, controller.selectedIndex);
                          // }
                        },
                        extraList: [
                          SecondaryShowDialogModel("Mark Error", () {
                            controller.gridStateManager?.changeCellValue(
                                controller.gridStateManager!.currentRow!
                                    .cells["isMismatch"]!,
                                "1",
                                force: true);
                            controller
                                .asrunData![controller
                                    .gridStateManager!.currentRow!.sortIdx]
                                .isMismatch = "1";
                            controller.gridStateManager?.setCurrentCell(
                                controller.gridStateManager!.currentRow!
                                    .cells["isMismatch"]!,
                                controller.gridStateManager!.currentRowIdx);
                            controller.gridStateManager!.moveScrollByColumn(
                                PlutoMoveDirection.right,
                                controller.gridStateManager?.columns.indexWhere(
                                    (element) =>
                                        element ==
                                        controller
                                            .gridStateManager!.currentColumn));
                          }),
                        ],
                        // hideKeys: ["color", "modifed"],
                        showSrNo: true,
                        colorCallback: (colorContext) {
                          try {
                            return Color(int.parse(
                                "0x${colorContext.row.cells["backColor"]!.value}"));
                          } catch (e) {
                            return Colors.white;
                          }
                        },
                        hideCode: false,
                        hideKeys: [
                          "backColor",
                          "foreColor",
                          "vtr",
                          "ch",
                          "programTime",
                          "scheduledate",
                          "programCode"
                        ],
                        // mode: PlutoGridMode.selectWithOneTap,
                        // colorCallback: (PlutoRowColorContext plutoContext) {
                        //   // return Color(controller.transmissionLogList![plutoContext.rowIdx].colorNo ?? Colors.white.value);
                        // },
                        onSelected: (PlutoGridOnSelectedEvent event) {
                          event.selectedRows?.forEach((element) {
                            print("On Print select" +
                                jsonEncode(element.toJson()));
                          });
                        },
                        // onRowsMoved: (PlutoGridOnRowsMovedEvent onRowMoved) {
                        //   print("Index is>>" + onRowMoved.idx.toString());
                        //   Map map = onRowMoved.rows[0].cells;
                        //   print("On Print moved" + jsonEncode(onRowMoved.rows[0].cells.toString()));
                        //   int? val = int.tryParse((onRowMoved.rows[0].cells["Episode Dur"]?.value.toString())!)!;
                        //   // print("After On select>>" + data.toString());
                        //   for (int i = (onRowMoved.idx) ?? 0; i >= 0; i--) {
                        //     print("On Print moved" + i.toString());
                        //     print("On select>>" + map["Episode Dur"].value.toString());

                        //     print("On Print moved cell>>>" +
                        //         jsonEncode(controller.gridStateManager?.rows[i].cells["Episode Dur"]?.value.toString()));

                        //     controller.gridStateManager?.rows[i].cells["Episode Dur"] = PlutoCell(value: val - (i - onRowMoved.idx));
                        //   }
                        //   controller.gridStateManager?.notifyListeners();
                        // },
                        // mode: controller.selectedPlutoGridMode,
                        mapData: controller.asrunData!
                            .map((e) => e.toJson())
                            .toList())
                    : Container(
                        // height: Get.height * .33,
                        // width: Get.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.grey.shade400,
                            width: 1,
                          ),
                        ),
                      ),
              ));
            },
          ),
          // Expanded(child: Container(),),
          GetBuilder<HomeController>(
              init: Get.find<HomeController>(),
              builder: (btncontroller) {
                /* PermissionModel formPermissions = Get.find<MainController>()
                    .permissionList!
                    .lastWhere((element) {
                  return element.appFormName == "frmSegmentsDetails";
                });*/
                if (btncontroller.asurunImportButtoons != null) {
                  return Card(
                      margin: EdgeInsets.fromLTRB(4, 4, 4, 0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                      ),
                      child: GetBuilder<AsrunImportController>(
                          init: controller,
                          id: "transButtons",
                          builder: (controller) {
                            return Container(
                              width: Get.width,
                              padding: const EdgeInsets.all(8.0),
                              child: Wrap(
                                // buttonHeight: 20,
                                spacing: 10,
                                // buttonHeight: 20,
                                alignment: WrapAlignment.start,
                                // pa
                                children: [
                                  for (var btn
                                      in btncontroller.asurunImportButtoons!)
                                    FormButtonWrapper(
                                      btnText: btn["name"],
                                      isEnabled: buttonVisibilty(btn["name"]),
                                      showIcon: false,
                                      // isEnabled: btn['isDisabled'],
                                      callback: /*btn["name"] != "Delete" &&
                                      Utils.btnAccessHandler2(btn['name'],
                                              controller, formPermissions) ==
                                          null
                                  ? null
                                  :*/
                                          () => formHandler(btn['name']),
                                    ),
                                  InkWell(
                                    child: const Icon(Icons.arrow_upward),
                                    onTap: () {
                                      if (controller.selectedFPCindex == 0) {
                                        controller.selectedFPCindex = controller
                                            .gridStateManager?.rows.length;
                                      } else {
                                        controller.selectedFPCindex =
                                            (controller.selectedFPCindex ?? 1) -
                                                1;
                                      }
                                      controller.filterMainGrid(controller
                                              .viewFPCData?[
                                                  controller.selectedFPCindex ??
                                                      0]
                                              .starttime ??
                                          "");
                                    },
                                  ),
                                  InkWell(
                                    child: const Icon(Icons.arrow_downward),
                                    onTap: () {
                                      if (controller
                                              .gridStateManager?.rows.length ==
                                          controller.selectedFPCindex) {
                                        controller.selectedFPCindex = 0;
                                      } else {
                                        controller.selectedFPCindex =
                                            (controller.selectedFPCindex ?? 0) +
                                                1;
                                      }

                                      controller.filterMainGrid(controller
                                              .viewFPCData?[
                                                  controller.selectedFPCindex ??
                                                      0]
                                              .starttime ??
                                          "");
                                    },
                                  ),
                                ],
                              ),
                            );
                          }));
                } else {
                  return Container();
                }
              }),
        ],
      ),
    );
  }

  buttonVisibilty(btn) {
    switch (btn) {
      case "Import":
        return (controller.asrunData ?? []).isEmpty ? true : false;

      case "Commercials":
      case "Error":
      case "SP Verify":
      case "Swap":
      case "Paste Up":
      case "Paste Down":
        return (controller.asrunData ?? []).isEmpty ? false : true;

      default:
        return null;
    }
  }

  formHandler(btn) {
    switch (btn) {
      case "Commercials":
        controller.saveTempDetails();
        break;
      case "Save":
        controller.checkProgramSequence();
        break;
      case "SP Verify":
        showVerifyDialog(controller
            .asrunData![controller.gridStateManager?.currentRow?.sortIdx ?? 0]);
        break;

      case "Swap":
        showSwap();
        break;
      case "View FPC":
        showFPCDialog();
        break;
      case "Paste Up":
        paste();
        break;
      case "Paste Down":
        paste(up: false);
        break;
      case "Import":
        controller.checkGFK();
        // controller.pickFile();
        break;
      case "Exit":
        Get.find<HomeController>().postUserGridSetting2(listStateManager: [
          {"stateManager": controller.gridStateManager},
          {"fpcGridStateManager": controller.fpcGridStateManager},
        ]);
        break;
      case "Error":
        controller.checkError();
        break;
      case "Clear":
        Get.delete<AsrunImportController>();
        Get.find<HomeController>().clearPage1();
        break;
    }
  }

  showSwap() {
    controller.drgabbleDialog.value = Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      margin: EdgeInsets.all(2),
      child: Container(
        height: Get.height * .35,
        width: Get.width * .40,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
                child: Container(
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            )),
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FormButtonWrapper(
                        btnText: "...",
                        showIcon: false,
                        callback: () {
                          // print(
                          //     controller.gridStateManager!.currentRow!.sortIdx);

                          if (controller.gridStateManager?.currentRow != null) {
                            if (controller
                                    .asrunData?[controller
                                        .gridStateManager!.currentRow!.sortIdx]
                                    .eventtype
                                    .toString()
                                    .toUpperCase() ==
                                "C ") {
                              controller.fromSwap.value = controller.asrunData?[
                                  controller
                                      .gridStateManager!.currentRow!.sortIdx];
                              controller.fromSwapIndex = controller
                                  .gridStateManager!.currentRow!.sortIdx;
                              controller.fromIdx =
                                  controller.gridStateManager?.currentRowIdx;
                            } else {
                              LoadingDialog.callInfoMessage(
                                  "Only Commericial Events Are Allowed for Swap");
                            }
                          }
                        }),
                    InputFields.formFieldNumberMask(
                        isEnable: false,
                        hintTxt: "",
                        controller: TextEditingController(
                            text: controller.fromSwap.value?.telecasttime),
                        widthRatio: 0.12,
                        isTime: true,
                        paddingLeft: 0),
                    InputFields.formField1(
                        isEnable: false,
                        width: 0.12,
                        hintTxt: "",
                        controller: TextEditingController(
                            text: controller.fromSwap.value?.tapeId)),
                    InputFields.formField1(
                        isEnable: false,
                        width: 0.09,
                        hintTxt: "",
                        controller: TextEditingController(
                            text: controller.fromSwap.value?.eventNumber
                                .toString()))
                  ],
                )),
            const SizedBox(
              height: 5,
            ),
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FormButtonWrapper(
                      btnText: "...",
                      showIcon: false,
                      callback: () {
                        if (controller.gridStateManager?.currentRow != null) {
                          if (controller
                                  .asrunData?[controller
                                      .gridStateManager!.currentRow!.sortIdx]
                                  .eventtype
                                  ?.toLowerCase() !=
                              "c ") {
                            LoadingDialog.callInfoMessage(
                                "Only Commericial Events Are Allowed for Swap");
                          } else if (controller
                                  .asrunData?[controller
                                      .gridStateManager!.currentRow!.sortIdx]
                                  .tapeId !=
                              controller.fromSwap.value?.tapeId) {
                            LoadingDialog.callInfoMessage(
                                "Only Matching Tapes are allowed for Swap");
                          } else {
                            controller.toSwap.value = controller.asrunData?[
                                controller
                                    .gridStateManager!.currentRow!.sortIdx];
                            controller.toSwapIndex = controller
                                .gridStateManager!.currentRow!.sortIdx;
                            controller.toIdx =
                                controller.gridStateManager?.currentRowIdx;
                          }
                        }
                      },
                    ),
                    InputFields.formFieldNumberMask(
                        isEnable: false,
                        hintTxt: "",
                        controller: TextEditingController(
                            text: controller.toSwap.value?.telecasttime ?? ""),
                        widthRatio: 0.12,
                        isTime: true,
                        paddingLeft: 0),
                    InputFields.formField1(
                        isEnable: false,
                        width: 0.12,
                        hintTxt: "",
                        controller: TextEditingController(
                            text: controller.toSwap.value?.tapeId ?? "")),
                    InputFields.formField1(
                        isEnable: false,
                        width: 0.09,
                        hintTxt: "",
                        controller: TextEditingController(
                            text: (controller.toSwap.value?.eventNumber ?? "")
                                .toString()))
                  ],
                )),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FormButtonWrapper(
                  btnText: "Swap",
                  callback: () {
                    var formEventNo = controller
                        .gridStateManager!
                        .refRows[controller.fromIdx!]
                        .cells['eventNumber']!
                        .value;
                    int? fromIndex =
                        controller.asrunData?.indexWhere((element) {
                      return formEventNo == element.eventNumber.toString();
                    });
                    var toEventNo = controller.gridStateManager!
                        .refRows[controller.toIdx!].cells['eventNumber']!.value;
                    int? toIndex = controller.asrunData?.indexWhere((element) =>
                        toEventNo == element.eventNumber.toString());
                    print(
                        "Real From Idx:$fromIndex Real To Idx:$toIndex\nFrom Idx:${controller.fromIdx} To Idx:${controller.toIdx}");

                    AsRunData replaceData(AsRunData from, AsRunData to) {
                      from.bookingnumber = to.bookingnumber;
                      from.scheduletime = to.scheduletime;
                      from.scheduledProgram = to.scheduledProgram;
                      from.rosBand = to.rosBand;
                      from.bookingdetailcode = to.bookingdetailcode;
                      from.isMismatch = to.isMismatch;
                      from.tapeDuration = to.tapeDuration;
                      return from;
                    }

                    var realFromModel = replaceData(
                      AsRunData.fromJson(
                          controller.asrunData![fromIndex!].toJson()),
                      AsRunData.fromJson(
                          controller.asrunData![toIndex!].toJson()),
                    );

                    var realToModel = replaceData(
                      AsRunData.fromJson(
                          controller.asrunData![toIndex!].toJson()),
                      AsRunData.fromJson(
                          controller.asrunData![fromIndex!].toJson()),
                    );

                    print(realFromModel.toJson());
                    print(realToModel.toJson());

                    controller.asrunData![fromIndex] = realToModel;
                    controller.asrunData![toIndex] = realFromModel;

                    //From Data
                    controller.asrunData?[fromIndex].bookingnumber =
                        controller.asrunData![fromIndex].bookingnumber;
                    controller.gridStateManager?.changeCellValue(
                        controller
                            .gridStateManager!
                            .refRows[controller.fromIdx!]
                            .cells["bookingnumber"]!,
                        controller.asrunData![fromIndex].bookingnumber,
                        force: true);
                    controller.asrunData?[fromIndex].scheduletime =
                        controller.asrunData![fromIndex].scheduletime;
                    controller.gridStateManager?.changeCellValue(
                        controller
                            .gridStateManager!
                            .refRows[controller.fromIdx!]
                            .cells["scheduletime"]!,
                        controller.asrunData![fromIndex].scheduletime,
                        force: true);
                    controller.asrunData?[fromIndex].scheduledProgram =
                        controller.asrunData![fromIndex].scheduledProgram;
                    controller.gridStateManager?.changeCellValue(
                        controller
                            .gridStateManager!
                            .refRows[controller.fromIdx!]
                            .cells["scheduledProgram"]!,
                        controller.asrunData![toIndex].scheduledProgram,
                        force: true);
                    controller.asrunData?[fromIndex].rosBand =
                        controller.asrunData![fromIndex].rosBand;
                    controller.gridStateManager?.changeCellValue(
                        controller.gridStateManager!
                            .refRows[controller.fromIdx!].cells["rosBand"]!,
                        controller.asrunData![fromIndex].rosBand,
                        force: true);
                    controller.asrunData?[fromIndex].bookingdetailcode =
                        controller.asrunData![fromIndex].bookingdetailcode;
                    controller.gridStateManager?.changeCellValue(
                        controller
                            .gridStateManager!
                            .refRows[controller.fromIdx!]
                            .cells["bookingdetailcode"]!,
                        controller.asrunData![fromIndex].bookingdetailcode,
                        force: true);
                    controller.asrunData?[fromIndex].isMismatch = controller
                                .asrunData![fromIndex].programName ==
                            controller.asrunData![fromIndex].scheduledProgram
                        ? ""
                        : "1";
                    controller.gridStateManager?.changeCellValue(
                        controller.gridStateManager!
                            .refRows[controller.fromIdx!].cells["isMismatch"]!,
                        controller.asrunData![fromIndex].programName ==
                                controller
                                    .asrunData![fromIndex].scheduledProgram
                            ? ""
                            : "1",
                        force: true);
                    controller.asrunData?[fromIndex!].tapeDuration =
                        controller.asrunData![fromIndex].tapeDuration;
                    controller.gridStateManager?.changeCellValue(
                        controller
                            .gridStateManager!
                            .refRows[controller.fromIdx!]
                            .cells["tapeDuration"]!,
                        controller.asrunData![fromIndex].tapeDuration,
                        force: true);

                    controller.asrunData?[fromIndex].fpc = controller
                                .asrunData![fromIndex].programName ==
                            controller.asrunData![fromIndex].scheduledProgram
                        ? ""
                        : "1";
                    controller.gridStateManager?.changeCellValue(
                        controller.gridStateManager!
                            .refRows[controller.fromIdx!].cells["fpc"]!,
                        controller.asrunData![fromIndex].programName ==
                                controller
                                    .asrunData![fromIndex].scheduledProgram
                            ? ""
                            : "1",
                        force: true);

                    controller.asrunData?[fromIndex].ros = controller
                                .asrunData![fromIndex].programName ==
                            controller.asrunData![fromIndex].scheduledProgram
                        ? ""
                        : "1";
                    controller.gridStateManager?.changeCellValue(
                        controller.gridStateManager!
                            .refRows[controller.fromIdx!].cells["ros"]!,
                        controller.asrunData![fromIndex].programName ==
                                controller
                                    .asrunData![fromIndex].scheduledProgram
                            ? ""
                            : "1",
                        force: true);

                    // //  TO DATA
                    controller.asrunData?[toIndex].bookingnumber =
                        controller.asrunData![toIndex].bookingnumber;
                    controller.gridStateManager?.changeCellValue(
                        controller.gridStateManager!.refRows[controller.toIdx!]
                            .cells["bookingnumber"]!,
                        controller.asrunData![toIndex].bookingnumber,
                        force: true);
                    controller.asrunData?[toIndex].scheduletime =
                        controller.asrunData![toIndex].scheduletime;
                    controller.gridStateManager?.changeCellValue(
                        controller.gridStateManager!.refRows[controller.toIdx!]
                            .cells["scheduletime"]!,
                        controller.asrunData![toIndex].scheduletime,
                        force: true);
                    controller.asrunData?[toIndex].scheduledProgram =
                        controller.asrunData![toIndex].scheduledProgram;
                    controller.gridStateManager?.changeCellValue(
                        controller.gridStateManager!.refRows[controller.toIdx!]
                            .cells["scheduledProgram"]!,
                        controller.asrunData![fromIndex].scheduledProgram,
                        force: true);
                    controller.asrunData?[toIndex].rosBand =
                        controller.asrunData![toIndex].rosBand;
                    controller.gridStateManager?.changeCellValue(
                        controller.gridStateManager!.refRows[controller.toIdx!]
                            .cells["rosBand"]!,
                        controller.asrunData![toIndex].rosBand,
                        force: true);
                    controller.asrunData?[toIndex].bookingdetailcode =
                        controller.asrunData![toIndex].bookingdetailcode;
                    controller.gridStateManager?.changeCellValue(
                        controller.gridStateManager!.refRows[controller.toIdx!]
                            .cells["bookingdetailcode"]!,
                        controller.asrunData![toIndex].bookingdetailcode,
                        force: true);
                    controller.asrunData?[toIndex].isMismatch =
                        controller.asrunData![toIndex].programName ==
                                controller.asrunData![toIndex].scheduledProgram
                            ? ""
                            : "1";
                    controller.gridStateManager?.changeCellValue(
                        controller.gridStateManager!.refRows[controller.toIdx!]
                            .cells["isMismatch"]!,
                        controller.asrunData![toIndex].programName ==
                                controller.asrunData![toIndex].scheduledProgram
                            ? ""
                            : "1",
                        force: true);
                    controller.asrunData?[toIndex].tapeDuration =
                        controller.asrunData![toIndex].tapeDuration;
                    controller.gridStateManager?.changeCellValue(
                        controller.gridStateManager!.refRows[controller.toIdx!]
                            .cells["tapeDuration"]!,
                        controller.asrunData![toIndex].tapeDuration,
                        force: true);

                    controller.asrunData?[toIndex].fpc =
                        controller.asrunData![toIndex].programName ==
                                controller.asrunData![toIndex].scheduledProgram
                            ? ""
                            : "1";
                    controller.gridStateManager?.changeCellValue(
                        controller.gridStateManager!.refRows[controller.toIdx!]
                            .cells["fpc"]!,
                        controller.asrunData![toIndex].programName ==
                                controller.asrunData![toIndex].scheduledProgram
                            ? ""
                            : "1",
                        force: true);

                    controller.asrunData?[toIndex].ros =
                        controller.asrunData![toIndex].programName ==
                                controller.asrunData![toIndex].scheduledProgram
                            ? ""
                            : "1";
                    controller.gridStateManager?.changeCellValue(
                        controller.gridStateManager!.refRows[controller.toIdx!]
                            .cells["ros"]!,
                        controller.asrunData![toIndex].programName ==
                                controller.asrunData![toIndex].scheduledProgram
                            ? ""
                            : "1",
                        force: true);
                  },
                  showIcon: false,
                ),
                FormButtonWrapper(
                  btnText: "Clear",
                  callback: () {
                    controller.fromSwap.value = null;
                    controller.toSwap.value = null;
                  },
                  showIcon: false,
                ),
                FormButtonWrapper(
                  btnText: "Close",
                  showIcon: false,
                  callback: () {
                    controller.drgabbleDialog.value = null;
                  },
                ),
              ],
            ),
            const SizedBox(height: 10)
          ],
        ),
      ),
    );
  }

  paste({bool up = true}) {
    if ((controller.gridStateManager?.currentSelectingRows ?? <PlutoRow>[])
        .isNotEmpty) {
      print(controller.gridStateManager?.currentSelectingRows.length);
      String fpcTime = (up
              ? controller.gridStateManager?.currentSelectingRows.last
              : controller.gridStateManager?.currentSelectingRows.first)
          ?.cells["fpctIme"]
          ?.value;
      String programCode = controller
              .asrunData?[(up
                      ? controller.gridStateManager?.currentSelectingRows.last
                      : controller
                          .gridStateManager?.currentSelectingRows.first)!
                  .sortIdx]
              .programCode ??
          "";

      String programName = (up
              ? controller.gridStateManager?.currentSelectingRows.last
              : controller.gridStateManager?.currentSelectingRows.first)
          ?.cells["programName"]
          ?.value;
      print(fpcTime);
      print(programCode);
      print(programName);
      for (var element in controller.gridStateManager?.currentSelectingRows ??
          <PlutoRow>[]) {
        controller.gridStateManager
            ?.changeCellValue(element.cells["fpctIme"]!, fpcTime, force: true);
        controller.asrunData?[element.sortIdx].fpctIme = fpcTime;
        controller.gridStateManager?.changeCellValue(
            element.cells["programName"]!, programName,
            force: true);
        controller.asrunData?[element.sortIdx].programName = programName;
        controller.asrunData?[element.sortIdx].programCode = programCode;
      }
    }
  }

  showVerifyDialog(AsRunData asrunData) {
    TextEditingController fpcTime =
        TextEditingController(text: asrunData.telecasttime);
    DropDownValue? selectedProgram =
        DropDownValue(key: asrunData.programCode, value: asrunData.programName);
    return Get.defaultDialog(
      title: "Verify",
      content: Container(
        height: 150,
        width: Get.width / 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DropDownField.formDropDownSearchAPI2(
              GlobalKey(), Get.context!,
              title: "Program",
              url: ApiFactory.AsrunImport_GetAsrunProgramList,
              parseKeyForKey: "programCode",
              parseKeyForValue: "programName",
              onchanged: (data) {
                selectedProgram = data;
              },
              selectedValue: selectedProgram,

              width: Get.width * 0.45,
              // padding: const EdgeInsets.only()
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: Get.width * 0.45,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InputFields.formFieldNumberMask(
                      isEnable: true,
                      hintTxt: "FPC Time",
                      controller: fpcTime,
                      widthRatio: 0.12,
                      isTime: true,
                      paddingLeft: 0),
                  InputFields.formFieldNumberMask(
                      isEnable: false,
                      hintTxt: "From",
                      controller:
                          TextEditingController(text: asrunData.telecasttime),
                      widthRatio: 0.12,
                      isTime: true,
                      paddingLeft: 0),
                  InputFields.formFieldNumberMask(
                      isEnable: false,
                      hintTxt: "To",
                      controller:
                          TextEditingController(text: asrunData.telecasttime),
                      widthRatio: 0.12,
                      isTime: true,
                      paddingLeft: 0),
                ],
              ),
            )
          ],
        ),
      ),
      cancel: FormButtonWrapper(
        btnText: "Cancel",
        showIcon: false,
        callback: () {
          Get.back();
        },
      ),
      onCancel: () {},
      confirm: FormButtonWrapper(
        btnText: "Verify",
        showIcon: false,
        callback: () {
          int index = controller.gridStateManager!.currentRow!.sortIdx;
          controller.asrunData?[index].fpctIme = fpcTime.text;
          controller.manualUpdateFPCTime(selectedProgram?.value,
              selectedProgram?.key, fpcTime.text, asrunData);
        },
      ),
    );
  }

  showFPCDialog() {
    controller.drgabbleDialog.value = Material(
      color: Colors.white,
      child: SizedBox(
        height: Get.height * 0.65,
        width: Get.width / 2,
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(10),
        //   color: Colors.white,
        // ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  controller.drgabbleDialog.value = null;
                },
                icon: const Icon(Icons.close),
              ),
            ),
            GetBuilder(
                init: controller,
                builder: (_) {
                  return Expanded(
                    // height: Get.height * 0.4,
                    child: DataGridFromMap(
                      witdthSpecificColumn: (controller
                          .userDataSettings?.userSetting
                          ?.firstWhere(
                              (element) =>
                                  element.controlName == "fpcGridStateManager",
                              orElse: () => UserSetting())
                          .userSettings),
                      mapData: controller.viewFPCData
                              ?.map((e) => e.toJson())
                              .toList() ??
                          [],
                      onload: (loadEvent) {
                        controller.fpcGridStateManager = loadEvent.stateManager;
                      },
                      onSelected: (selectEvent) {
                        controller.selectedFPCindex = selectEvent.rowIdx;
                      },
                      hideCode: false,
                      hideKeys: ["programcode"],
                      mode: PlutoGridMode.selectWithOneTap,
                      onRowDoubleTap: (rowEvent) {
                        controller.gridStateManager?.setFilter((element) =>
                            element.cells["fpctIme"]?.value.toString() ==
                            rowEvent.row.cells["starttime"]?.value.toString());
                      },
                    ),
                  );
                }),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FormButtonWrapper(
                  btnText: "Verify",
                  showIcon: false,
                  callback: () {
                    controller.updateFPCTime();
                  },
                ),
                SizedBox(width: 10),
                FormButtonWrapper(
                  btnText: "Filter",
                  showIcon: false,
                  callback: () {
                    controller.filterMainGrid(controller
                            .viewFPCData?[controller.selectedFPCindex!]
                            .starttime ??
                        "");
                  },
                )
              ],
            ),
            SizedBox(height: 10)
          ],
        ),
      ),
    );
    // Get.defaultDialog(
    //   barrierDismissible: true,
    //   title: "View FPC",
    //   titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    //   titlePadding: const EdgeInsets.only(top: 10),
    //   contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    //   radius: 10,
    //   content: Container(
    //     height: Get.height * 0.65,
    //     width: Get.width / 2,
    //     child: DataGridShowOnlyKeys(
    //       keysWidths: (controller.userDataSettings?.userSetting
    //           ?.firstWhere(
    //               (element) => element.controlName == "fpcGridStateManager",
    //               orElse: () => UserSetting())
    //           .userSettings),
    //       mapData:
    //           controller.viewFPCData?.map((e) => e.toJson()).toList() ?? [],
    //       onload: (loadEvent) {
    //         controller.fpcGridStateManager = loadEvent.stateManager;
    //       },
    //       onSelected: (selectEvent) {
    //         controller.selectedFPCindex = selectEvent.rowIdx;
    //       },
    //       hideCode: false,
    //       hideKeys: ["programcode"],
    //       mode: PlutoGridMode.selectWithOneTap,
    //       onRowDoubleTap: (rowEvent) {
    //         controller.gridStateManager?.setFilter((element) =>
    //             element.cells["fpctIme"]?.value.toString() ==
    //             rowEvent.row.cells["starttime"]?.value.toString());
    //       },
    //     ),
    //   ),
    //   confirm: FormButtonWrapper(
    //     btnText: "Verify",
    //     showIcon: false,
    //     callback: () {
    //       controller.updateFPCTime();
    //     },
    //   ),
    //   cancel: FormButtonWrapper(
    //     btnText: "Filter",
    //     showIcon: false,
    //     callback: () {
    //       controller.filterMainGrid(
    //           controller.viewFPCData?[controller.selectedFPCindex!].starttime ??
    //               "");
    //     },
    //   ),
    // );
  }
}

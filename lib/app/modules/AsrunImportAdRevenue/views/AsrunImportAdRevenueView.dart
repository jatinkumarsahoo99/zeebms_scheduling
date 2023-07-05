import 'dart:convert';

import 'package:bms_scheduling/app/modules/AsrunImportAdRevenue/bindings/arun_data.dart';
import 'package:bms_scheduling/app/providers/DataGridMenu.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/WarningBox.dart';
// import '../../../../widgets/cutom_dropdown.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../../widgets/gridFromMap1.dart';
import '../../../../widgets/input_fields.dart';
import '../../../../widgets/radio_row.dart';
import '../../../controller/HomeController.dart';
import '../../../data/DropDownValue.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/SizeDefine.dart';
import '../controllers/AsrunImportController.dart';

class AsrunImportAdRevenueView extends GetView<AsrunImportController> {
  AsrunImportController controllerX = Get.put(AsrunImportController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      controllerX.locations.value,
                      (value) {
                        controllerX.selectLocation = value;
                        controllerX
                            .getChannels(controllerX.selectLocation?.key ?? "");
                      },
                      "Location",
                      0.12,
                      isEnable: controllerX.isEnable.value,
                      selected: controllerX.selectLocation,
                      autoFocus: true,
                      dialogWidth: 330,
                      dialogHeight: Get.height * .7,
                    ),
                  ),

                  /// channel
                  Obx(
                    () => DropDownField.formDropDown1WidthMap(
                      controllerX.channels.value,
                      (value) {
                        controllerX.selectChannel = value;
                        controllerX.checkboxesMap["FPC"] = true;
                        controllerX.checkboxesMap["GFK"] = true;
                        controllerX.checkboxesMap.refresh();
                      },
                      "Channel",
                      0.12,
                      isEnable: controllerX.isEnable.value,
                      selected: controllerX.selectChannel,
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
                      isEnable: controllerX.isEnable.value,
                      onFocusChange: (data) {
                        LoadingDialog.call(barrierDismissible: false);
                        controllerX.loadAsrunData();
                        controllerX.loadviewFPCData();
                        Get.back();
                      },
                      mainTextController: controllerX.selectedDate,
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
                                  value: controllerX
                                      .checkboxesMap.value[checkbox.key],
                                  onChanged: (val) {
                                    controllerX.checkboxesMap
                                        .value[checkbox.key] = val;
                                    controllerX.checkboxesMap.refresh();
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
                  InputFields.formFieldNumberMask(
                      isEnable: false,
                      hintTxt: "Start Time",
                      controller: controllerX.startTime_,
                      widthRatio: 0.09,
                      isTime: true,
                      paddingLeft: 0),
                ],
              ),
            ),
          ),
          // Divider(),

          GetBuilder<AsrunImportController>(
            id: "fpcData",
            init: controllerX,
            builder: (controller) {
              return Expanded(
                  // width: Get.width,
                  // height: Get.height * .33,
                  child: Container(
                color: Colors.white,
                child: (controller.asrunData != null)
                    ? DataGridShowOnlyKeys(
                        // onFocusChange: (value) {
                        //   // controllerX.gridStateManager!.setGridMode(PlutoGridMode.selectWithOneTap);
                        //   // controllerX.selectedPlutoGridMode = PlutoGridMode.selectWithOneTap;
                        // },
                        onload: (loadevent) {
                          loadevent.stateManager.setSelecting(true);
                          loadevent.stateManager
                              .setSelectingMode(PlutoGridSelectingMode.row);

                          controller.gridStateManager = loadevent.stateManager;

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
                          })
                        ],
                        // hideKeys: ["color", "modifed"],
                        showSrNo: true,
                        colorCallback: (colorContext) {
                          if (controller.asrunData?[colorContext.rowIdx] !=
                              null) {
                            try {
                              return Color(int.parse(
                                  "0x${controller.asrunData?[colorContext.rowIdx].backColor}"));
                            } catch (e) {
                              return Colors.white;
                            }
                          } else {
                            return Colors.white;
                          }
                        },
                        // mode: PlutoGridMode.selectWithOneTap,
                        // colorCallback: (PlutoRowColorContext plutoContext) {
                        //   // return Color(controllerX.transmissionLogList![plutoContext.rowIdx].colorNo ?? Colors.white.value);
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
                        //         jsonEncode(controllerX.gridStateManager?.rows[i].cells["Episode Dur"]?.value.toString()));

                        //     controllerX.gridStateManager?.rows[i].cells["Episode Dur"] = PlutoCell(value: val - (i - onRowMoved.idx));
                        //   }
                        //   controllerX.gridStateManager?.notifyListeners();
                        // },
                        // mode: controllerX.selectedPlutoGridMode,
                        mapData: controllerX.asrunData!
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
              id: "transButtons",
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
                    child: Container(
                      width: Get.width,
                      padding: const EdgeInsets.all(8.0),
                      child: Wrap(
                        // buttonHeight: 20,
                        spacing: 10,
                        // buttonHeight: 20,
                        alignment: WrapAlignment.start,
                        // pa
                        children: [
                          for (var btn in btncontroller.asurunImportButtoons!)
                            FormButtonWrapper(
                              btnText: btn["name"],
                              isEnabled: btn["name"] == "Import"
                                  ? (controllerX.asrunData ?? []).isEmpty
                                      ? true
                                      : false
                                  : null,
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
                            child: Icon(Icons.arrow_upward),
                            onTap: () {
                              if (controller.selectedFPCindex == 0) {
                                controller.selectedFPCindex =
                                    controllerX.gridStateManager?.rows.length;
                              } else {
                                controller.selectedFPCindex =
                                    (controller.selectedFPCindex ?? 1) - 1;
                              }
                              controller.filterMainGrid(controller
                                      .viewFPCData?[
                                          controller.selectedFPCindex ?? 0]
                                      .starttime ??
                                  "");
                            },
                          ),
                          InkWell(
                            child: Icon(Icons.arrow_downward),
                            onTap: () {
                              if (controllerX.gridStateManager?.rows.length ==
                                  controller.selectedFPCindex) {
                                controller.selectedFPCindex = 0;
                              } else {
                                controller.selectedFPCindex =
                                    (controller.selectedFPCindex ?? 0) + 1;
                              }
                              controller.filterMainGrid(controller
                                      .viewFPCData?[
                                          controller.selectedFPCindex ?? 0]
                                      .starttime ??
                                  "");
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              }),
        ],
      ),
    );
  }

  formHandler(btn) {
    switch (btn) {
      case "Commercials":
        controller.updateFPCTime();
        break;
      case "Save":
        controller.checkMissingAsrun();
        break;
      case "SP Verify":
        showVerifyDialog(controller
            .asrunData![controller.gridStateManager?.currentRowIdx ?? 0]);
        break;

      case "View FPC":
        showFPCDialog(Get.context);
        break;
      case "Paste Up":
        paste();
        break;
      case "Paste Down":
        paste(up: false);
        break;
      case "Import":
        controller.pickFile();
        break;
      case "Error":
        controller.checkError();
        break;
    }
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
        TextEditingController(text: asrunData.fpctIme);
    DropDownValue? selectedProgram;
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
              SizedBox(
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
                        widthRatio: 0.09,
                        isTime: true,
                        paddingLeft: 0),
                    InputFields.formFieldNumberMask(
                        isEnable: false,
                        hintTxt: "From",
                        controller:
                            TextEditingController(text: asrunData.fpctIme),
                        widthRatio: 0.09,
                        isTime: true,
                        paddingLeft: 0),
                    InputFields.formFieldNumberMask(
                        isEnable: false,
                        hintTxt: "To",
                        controller:
                            TextEditingController(text: asrunData.fpctIme),
                        widthRatio: 0.09,
                        isTime: true,
                        paddingLeft: 0),
                  ],
                ),
              )
            ],
          ),
        ),
        textConfirm: "Verify",
        textCancel: "Cancel",
        onCancel: () {},
        onConfirm: () {
          controller.manualUpdateFPCTime(selectedProgram?.value,
              selectedProgram?.key, fpcTime.text, asrunData);
        });
  }

  showFPCDialog(context) {
    return Get.defaultDialog(
      barrierDismissible: true,
      title: "View FPC",
      titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      titlePadding: const EdgeInsets.only(top: 10),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      content: Container(
        height: Get.height * 0.80,
        width: Get.width / 2,
        child: DataGridShowOnlyKeys(
          mapData:
              controllerX.viewFPCData?.map((e) => e.toJson()).toList() ?? [],
          onload: (loadEvent) {
            controller.fpcGridStateManager = loadEvent.stateManager;
          },
          onSelected: (selectEvent) {
            controllerX.selectedFPCindex = selectEvent.rowIdx;
          },
          mode: PlutoGridMode.selectWithOneTap,
          onRowDoubleTap: (rowEvent) {
            controllerX.gridStateManager?.setFilter((element) =>
                element.cells["fpctIme"]?.value.toString() ==
                rowEvent.row.cells["starttime"]?.value.toString());
          },
        ),
      ),
      confirm: FormButtonWrapper(
        btnText: "Verify",
        showIcon: false,
        callback: () {
          controller.updateFPCTime();
        },
      ),
      cancel: FormButtonWrapper(
        btnText: "Filter",
        showIcon: false,
        callback: () {
          controller.filterMainGrid(
              controller.viewFPCData?[controller.selectedFPCindex!].starttime ??
                  "");
        },
      ),
      radius: 10,
    );
  }
}

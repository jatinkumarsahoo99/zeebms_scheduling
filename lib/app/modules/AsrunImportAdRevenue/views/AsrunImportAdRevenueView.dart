import 'dart:convert';

import 'package:bms_scheduling/app/providers/DataGridMenu.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/WarningBox.dart';
import '../../../../widgets/cutom_dropdown.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../../widgets/gridFromMap1.dart';
import '../../../../widgets/input_fields.dart';
import '../../../../widgets/radio_row.dart';
import '../../../controller/HomeController.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/SizeDefine.dart';
import '../controllers/AsrunImportController.dart';

class AsrunImportAdRevenueView extends GetView<AsrunImportController> {
  AsrunImportController controllerX = Get.put(AsrunImportController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
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
                      controllerX.getChannels(controllerX.selectLocation?.key ?? "");
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
                      controllerX.loadAsrunData();
                    },
                    mainTextController: controllerX.selectedDate,
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
                FittedBox(
                  child: Row(
                    children: [
                      Obx(() => Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Checkbox(
                              value: controllerX.isStandby.value,
                              onChanged: (val) {
                                controllerX.isStandby.value = val!;
                              },
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, left: 3),
                        child: Text(
                          "FPC",
                          style: TextStyle(fontSize: SizeDefine.labelSize1),
                        ),
                      ),
                    ],
                  ),
                ),
                FittedBox(
                  child: Row(
                    children: [
                      Obx(() => Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Checkbox(
                              value: controllerX.isStandby.value,
                              onChanged: (val) {
                                controllerX.isStandby.value = val!;
                              },
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, left: 3),
                        child: Text(
                          "Mark Slot",
                          style: TextStyle(fontSize: SizeDefine.labelSize1),
                        ),
                      ),
                    ],
                  ),
                ),

                FittedBox(
                  child: Row(
                    children: [
                      Obx(() => Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Checkbox(
                              value: controllerX.isStandby.value,
                              onChanged: (val) {
                                controllerX.isStandby.value = val!;
                              },
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, left: 3),
                        child: Text(
                          "Dont update exposure program",
                          style: TextStyle(fontSize: SizeDefine.labelSize1),
                        ),
                      ),
                    ],
                  ),
                ),
                FittedBox(
                  child: Row(
                    children: [
                      Obx(() => Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Checkbox(
                              value: controllerX.isStandby.value,
                              onChanged: (val) {
                                controllerX.isStandby.value = val!;
                              },
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, left: 3),
                        child: Text(
                          "GFK",
                          style: TextStyle(fontSize: SizeDefine.labelSize1),
                        ),
                      ),
                    ],
                  ),
                ),
                FittedBox(
                  child: Row(
                    children: [
                      Obx(() => Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Checkbox(
                              value: controllerX.isStandby.value,
                              onChanged: (val) {
                                controllerX.isStandby.value = val!;
                              },
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, left: 3),
                        child: Text(
                          "DailyFPC",
                          style: TextStyle(fontSize: SizeDefine.labelSize1),
                        ),
                      ),
                    ],
                  ),
                ),
                FittedBox(
                  child: Row(
                    children: [
                      Obx(() => Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Checkbox(
                              value: controllerX.isStandby.value,
                              onChanged: (val) {
                                controllerX.isStandby.value = val!;
                              },
                              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, left: 3),
                        child: Text(
                          "Amagi",
                          style: TextStyle(fontSize: SizeDefine.labelSize1),
                        ),
                      ),
                    ],
                  ),
                ),
                InputFields.formFieldNumberMask(
                    hintTxt: "Start Time", controller: controllerX.startTime_, widthRatio: 0.09, isTime: true, paddingLeft: 0),
              ],
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
                padding: EdgeInsets.all(4),
                child: (controller.asrunData != null)
                    ? DataGridShowOnlyKeys(
                        // onFocusChange: (value) {
                        //   // controllerX.gridStateManager!.setGridMode(PlutoGridMode.selectWithOneTap);
                        //   // controllerX.selectedPlutoGridMode = PlutoGridMode.selectWithOneTap;
                        // },
                        onload: (loadevent) {
                          controller.gridStateManager = loadevent.stateManager;
                          // if (controller.selectedIndex != null) {
                          //   loadevent.stateManager.moveScrollByRow(PlutoMoveDirection.down, controller.selectedIndex);
                          //   loadevent.stateManager.setCurrentCell(
                          //       loadevent.stateManager.rows[controller.selectedIndex!].cells.entries.first.value, controller.selectedIndex);
                          // }
                        },
                        extraList: [
                          SecondaryShowDialogModel("Mark Error", () {
                            controller.gridStateManager
                                ?.changeCellValue(controller.gridStateManager!.currentRow!.cells["isMismatch"]!, "1", force: true);
                          })
                        ],
                        // hideKeys: ["color", "modifed"],
                        showSrNo: true,
                        colorCallback: (colorContext) {
                          if (controller.asrunData?[colorContext.rowIdx] != null) {
                            try {
                              return Color(int.parse("0x${controller.asrunData?[colorContext.rowIdx]}"));
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
                            print("On Print select" + jsonEncode(element.toJson()));
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
                        mode: controllerX.selectedPlutoGridMode,
                        mapData: controllerX.asrunData!.map((e) => e.toJson()).toList())
                    : Container(
                        // height: Get.height * .33,
                        // width: Get.width,
                        decoration: BoxDecoration(
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
              builder: (controller) {
                /* PermissionModel formPermissions = Get.find<MainController>()
                    .permissionList!
                    .lastWhere((element) {
                  return element.appFormName == "frmSegmentsDetails";
                });*/
                if (controller.asurunImportButtoons != null) {
                  return Card(
                    margin: EdgeInsets.fromLTRB(4, 4, 4, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
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
                          for (var btn in controller.asurunImportButtoons!)
                            FormButtonWrapper(
                              btnText: btn["name"],
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
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.arrow_upward),
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.arrow_downward),
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return Container();
                }
              }),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  formHandler(btn) {
    switch (btn) {
      case "Commercials":
        showCommercialDialog(Get.context);
        break;
      case "Insert":
        showInsertDialog(Get.context);
        break;
      case "Segments":
        // showSegmentDialog(Get.context);
        break;
      case "Change":
        showChangeDialog(Get.context);
        break;
      case "TS":
        showTransmissionSummaryDialog(Get.context);
        break;
      case "Verify":
        showVerifyDialog(Get.context);
        break;
      case "Aa":
        showAaDialog(Get.context);
        break;
    }
  }

  showTransmissionSummaryDialog(context) {
    return Get.defaultDialog(
      barrierDismissible: false,
      title: "Transmission Summary",
      titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      titlePadding: const EdgeInsets.only(top: 10),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      content: SingleChildScrollView(
        child: SizedBox(
          height: Get.height * 0.5,
          child: SingleChildScrollView(
            child: SizedBox(
              width: Get.width * 0.8,
              // height: Get.he,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Obx(
                        () => DropDownField.formDropDown1WidthMap(
                          controllerX.locations.value,
                          (value) {
                            controllerX.selectLocation = value;
                            // controllerX.selectedLocationId.text = value.key!;
                            // controllerX.selectedLocationName.text = value.value!;
                            // controller.getChannelsBasedOnLocation(value.key!);
                          },
                          "Time",
                          0.12,
                          isEnable: controllerX.isEnable.value,
                          selected: controllerX.selectLocation,
                          autoFocus: true,
                          dialogWidth: 330,
                          dialogHeight: Get.height * .7,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, left: 10),
                        child: FormButtonWrapper(
                          btnText: "Filter",
                          showIcon: false,
                          callback: () {},
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GetBuilder<AsrunImportController>(
                      id: "commercialsList",
                      init: controllerX,
                      builder: (controller) {
                        return SizedBox(
                          // width: 500,
                          width: Get.width * 0.8,
                          height: 300,
                          child: (controllerX.transmissionLogList != null && (controllerX.transmissionLogList?.isNotEmpty)!)
                              ? DataGridFromMap(
                                  hideCode: false,
                                  formatDate: false,
                                  colorCallback: (renderC) => Colors.red[200]!,
                                  mapData: controllerX.transmissionLogList!.map((e) => e.toJson()).toList())
                              // _dataTable3()
                              : const WarningBox(text: 'Enter Location, Channel & Date to get the Break Definitions'),
                        );
                      })
                ],
              ),
            ),
          ),
        ),
      ),
      radius: 10,
      confirm: Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 10),
        child: FormButtonWrapper(
          btnText: "Close",
          showIcon: false,
          callback: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  showCommercialDialog(context) {
    return Get.defaultDialog(
      barrierDismissible: false,
      title: "Commercials",
      titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      titlePadding: const EdgeInsets.only(top: 10),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      content: SingleChildScrollView(
        child: SizedBox(
          height: Get.height * 0.5,
          child: SingleChildScrollView(
            child: SizedBox(
              width: Get.width * 0.8,
              // height: Get.he,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Obx(
                        () => DropDownField.formDropDown1WidthMap(
                          controllerX.locations.value,
                          (value) {
                            controllerX.selectLocation = value;
                            // controllerX.selectedLocationId.text = value.key!;
                            // controllerX.selectedLocationName.text = value.value!;
                            // controller.getChannelsBasedOnLocation(value.key!);
                          },
                          "Time",
                          0.12,
                          isEnable: controllerX.isEnable.value,
                          selected: controllerX.selectLocation,
                          autoFocus: true,
                          dialogWidth: 330,
                          dialogHeight: Get.height * .7,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, left: 10),
                        child: FormButtonWrapper(
                          btnText: "Filter",
                          showIcon: false,
                          callback: () {},
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GetBuilder<AsrunImportController>(
                      id: "commercialsList",
                      init: controllerX,
                      builder: (controller) {
                        return SizedBox(
                          // width: 500,
                          width: Get.width * 0.8,
                          height: 300,
                          child: (controllerX.transmissionLogList != null && (controllerX.transmissionLogList?.isNotEmpty)!)
                              ? DataGridFromMap(
                                  hideCode: false,
                                  formatDate: false,
                                  colorCallback: (renderC) => Colors.red[200]!,
                                  mapData: controllerX.transmissionLogList!.map((e) => e.toJson()).toList())
                              // _dataTable3()
                              : const WarningBox(text: 'Enter Location, Channel & Date to get the Break Definitions'),
                        );
                      })
                ],
              ),
            ),
          ),
        ),
      ),
      radius: 10,
      confirm: Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 10),
        child: FormButtonWrapper(
          btnText: "Close",
          showIcon: false,
          callback: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  showInsertDialog(context) {
    return Get.defaultDialog(
      barrierDismissible: false,
      title: "Insert",
      titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      titlePadding: const EdgeInsets.only(top: 10),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      content: SingleChildScrollView(
        child: SizedBox(
          height: Get.height * 0.7,
          child: SingleChildScrollView(
            child: SizedBox(
              width: Get.width * 0.8,
              // height: Get.he,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      Obx(
                        () => DropDownField.formDropDown1WidthMap(
                          controllerX.locations.value,
                          (value) {
                            controllerX.selectLocation = value;
                            // controllerX.selectedLocationId.text = value.key!;
                            // controllerX.selectedLocationName.text = value.value!;
                            // controller.getChannelsBasedOnLocation(value.key!);
                          },
                          "Event",
                          0.13,
                          isEnable: controllerX.isEnable.value,
                          selected: controllerX.selectLocation,
                          autoFocus: true,
                          dialogWidth: 330,
                          dialogHeight: Get.height * .7,
                        ),
                      ),
                      InputFields.formField1(
                          width: 0.13, onchanged: (value) {}, hintTxt: "TX Caption", margin: true, controller: controllerX.txCaption_),
                      InputFields.formField1(width: 0.13, onchanged: (value) {}, hintTxt: "TX Id", margin: true, controller: controllerX.txId_),
                      SizedBox(
                        width: Get.width * 0.05,
                        child: Row(
                          children: [
                            SizedBox(width: 5),
                            Obx(() => Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: Checkbox(
                                    value: controllerX.isMy.value,
                                    onChanged: (val) {
                                      controllerX.isMy.value = val!;
                                    },
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0, left: 5),
                              child: Text(
                                "My",
                                style: TextStyle(fontSize: SizeDefine.labelSize1),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, left: 10),
                        child: FormButtonWrapper(
                          btnText: "Search",
                          showIcon: false,
                          callback: () {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, left: 10),
                        child: FormButtonWrapper(
                          btnText: "Add",
                          showIcon: false,
                          callback: () {},
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.07,
                        child: Row(
                          children: [
                            SizedBox(width: 5),
                            Obx(() => Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: Checkbox(
                                    value: controllerX.isInsertAfter.value,
                                    onChanged: (val) {
                                      controllerX.isInsertAfter.value = val!;
                                    },
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0, left: 5),
                              child: Text(
                                "Insert After",
                                style: TextStyle(fontSize: SizeDefine.labelSize1),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      InputFields.formFieldNumberMask(
                          hintTxt: "",
                          controller: controllerX.insertDuration_..text = "00:00:00",
                          widthRatio: 0.13,
                          isTime: true,
                          isEnable: false,
                          paddingLeft: 0),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GetBuilder<AsrunImportController>(
                      id: "commercialsList",
                      init: controllerX,
                      builder: (controller) {
                        return SizedBox(
                          // width: 500,
                          width: Get.width * 0.8,
                          height: Get.height * 0.6,
                          child: (controllerX.transmissionLogList != null && (controllerX.transmissionLogList?.isNotEmpty)!)
                              ? DataGridFromMap(
                                  hideCode: false,
                                  formatDate: false,
                                  colorCallback: (renderC) => Colors.red[200]!,
                                  mapData: controllerX.transmissionLogList!.map((e) => e.toJson()).toList())
                              // _dataTable3()
                              : const WarningBox(text: 'Enter Location, Channel & Date to get the Break Definitions'),
                        );
                      })
                ],
              ),
            ),
          ),
        ),
      ),
      confirm: FormButtonWrapper(
        btnText: "Close",
        showIcon: false,
        callback: () {
          Navigator.pop(context);
        },
      ),
      radius: 10,
    );
  }

  showChangeDialog(context) {
    return Get.defaultDialog(
      barrierDismissible: false,
      title: "Change",
      titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      titlePadding: const EdgeInsets.only(top: 10),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      content: SingleChildScrollView(
        child: SizedBox(
          height: Get.height * 0.3,
          child: SingleChildScrollView(
            child: SizedBox(
              width: Get.width * 0.2,
              // height: Get.he,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  InputFields.formField1(
                      width: 0.12, onchanged: (value) {}, hintTxt: "TX Id", margin: true, padLeft: 0, controller: controllerX.txId_),
                  Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: InputFields.formFieldNumberMask(
                        hintTxt: "Duration",
                        controller: controllerX.segmentFpcTime_..text = "00:00:00",
                        widthRatio: 0.12,
                        isTime: true,
                        paddingLeft: 0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: InputFields.formFieldNumberMask(
                        hintTxt: "OffSet",
                        controller: controllerX.segmentFpcTime_..text = "00:00:00",
                        widthRatio: 0.12,
                        isTime: true,
                        isEnable: false,
                        paddingLeft: 0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: InputFields.formFieldNumberMask(
                        hintTxt: "FPC Time",
                        controller: controllerX.segmentFpcTime_..text = "00:00:00",
                        widthRatio: 0.12,
                        isTime: true,
                        isEnable: false,
                        paddingLeft: 0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: Get.width * 0.05,
                        child: Row(
                          children: [
                            SizedBox(width: 5),
                            Obx(() => Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: Checkbox(
                                    value: controllerX.isMy.value,
                                    onChanged: (val) {
                                      controllerX.isMy.value = val!;
                                    },
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.only(top: 15.0, left: 5),
                              child: Text(
                                "All",
                                style: TextStyle(fontSize: SizeDefine.labelSize1),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, left: 10),
                        child: FormButtonWrapper(
                          btnText: "Change",
                          showIcon: false,
                          callback: () {},
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      confirm: FormButtonWrapper(
        btnText: "Close",
        showIcon: false,
        callback: () {
          Navigator.pop(context);
        },
      ),
      radius: 10,
    );
  }

  showVerifyDialog(context) {
    return Get.defaultDialog(
      barrierDismissible: false,
      title: "Verify",
      titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      titlePadding: const EdgeInsets.only(top: 10),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      content: SingleChildScrollView(
        child: SizedBox(
          height: Get.height * 0.7,
          child: SingleChildScrollView(
            child: SizedBox(
              width: Get.width * 0.8,
              // height: Get.he,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, left: 10),
                        child: FormButtonWrapper(
                          btnText: "Details",
                          showIcon: false,
                          callback: () {},
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GetBuilder<AsrunImportController>(
                          id: "commercialsList",
                          init: controllerX,
                          builder: (controller) {
                            return SizedBox(
                              // width: 500,
                              width: Get.width * 0.49,
                              height: Get.height * 0.53,
                              child: (controllerX.transmissionLogList != null && (controllerX.transmissionLogList?.isNotEmpty)!)
                                  ? DataGridFromMap(
                                      hideCode: false,
                                      formatDate: false,
                                      colorCallback: (renderC) => Colors.red[200]!,
                                      mapData: controllerX.transmissionLogList!.map((e) => e.toJson()).toList())
                                  // _dataTable3()
                                  : const WarningBox(text: 'Enter Location, Channel & Date to get the Break Definitions'),
                            );
                          }),
                      GetBuilder<AsrunImportController>(
                          id: "commercialsList",
                          init: controllerX,
                          builder: (controller) {
                            return SizedBox(
                              // width: 500,
                              width: Get.width * 0.3,
                              height: Get.height * 0.53,
                              child: (controllerX.transmissionLogList != null && (controllerX.transmissionLogList?.isNotEmpty)!)
                                  ? DataGridFromMap(
                                      hideCode: false,
                                      formatDate: false,
                                      colorCallback: (renderC) => Colors.red[200]!,
                                      mapData: controllerX.transmissionLogList!.map((e) => e.toJson()).toList())
                                  // _dataTable3()
                                  : const WarningBox(text: 'Enter Location, Channel & Date to get the Break Definitions'),
                            );
                          }),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 3),
                        child: InputFields.formFieldNumberMask(
                            hintTxt: "Min Time Difference",
                            controller: controllerX.segmentFpcTime_..text = "00:00:00",
                            widthRatio: 0.12,
                            isTime: true,
                            paddingLeft: 0),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      confirm: FormButtonWrapper(
        btnText: "Close",
        showIcon: false,
        callback: () {
          Navigator.pop(context);
        },
      ),
      radius: 10,
    );
  }

  showAaDialog(context) {
    return Get.defaultDialog(
      barrierDismissible: false,
      title: "Verification",
      titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      titlePadding: const EdgeInsets.only(top: 10),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      content: SingleChildScrollView(
        child: SizedBox(
          height: Get.height * 0.6,
          child: SingleChildScrollView(
            child: SizedBox(
              width: Get.width * 0.8,
              // height: Get.he,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Obx(
                    () => RadioRow(
                      items: const ["Tape", "Product", "Brand"],
                      groupValue: controllerX.verifyType.value ?? "",
                      onchange: (val) {
                        print("Response>>>" + val);
                        controllerX.verifyType.value = val;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GetBuilder<AsrunImportController>(
                      id: "commercialsList",
                      init: controllerX,
                      builder: (controller) {
                        return SizedBox(
                          // width: 500,
                          width: Get.width * 0.8,
                          height: Get.height * 0.6,
                          child: (controllerX.transmissionLogList != null && (controllerX.transmissionLogList?.isNotEmpty)!)
                              ? DataGridFromMap(
                                  hideCode: false,
                                  formatDate: false,
                                  colorCallback: (renderC) => Colors.red[200]!,
                                  mapData: controllerX.transmissionLogList!.map((e) => e.toJson()).toList())
                              // _dataTable3()
                              : const WarningBox(text: 'Enter Location, Channel & Date to get the Break Definitions'),
                        );
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
      confirm: FormButtonWrapper(
        btnText: "Close",
        showIcon: false,
        callback: () {
          Navigator.pop(context);
        },
      ),
      radius: 10,
    );
  }
}

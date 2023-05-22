import 'dart:convert';

import 'package:bms_scheduling/widgets/radio_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/WarningBox.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../../widgets/gridFromMap1.dart';
import '../../../../widgets/input_fields.dart';
import '../../../controller/HomeController.dart';
import '../../../data/DropDownValue.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/SizeDefine.dart';
import '../controllers/TransmissionLogController.dart';

class TransmissionLogView extends GetView<TransmissionLogController> {
  TransmissionLogController controllerX = Get.put(TransmissionLogController());
  final GlobalKey rebuildKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetBuilder<TransmissionLogController>(
              init: controllerX,
              id: "updateView",
              builder: (control) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                  child: SizedBox(
                    width: double.maxFinite,
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
                              controllerX.getChannels(
                                  controllerX.selectLocation?.key ?? "");
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
                        SizedBox(
                          width: Get.width * 0.077,
                          child: Row(
                            children: [
                              SizedBox(width: 5),
                              Obx(() => Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Checkbox(
                                      value: controllerX.isStandby.value,
                                      onChanged: (val) {
                                        controllerX.isStandby.value = val!;
                                      },
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  )),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 15.0, left: 5),
                                child: Text(
                                  "Standby Log",
                                  style: TextStyle(
                                      fontSize: SizeDefine.labelSize1),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Obx(
                          () => DateWithThreeTextField(
                            title: "Schedule Date",
                            splitType: "-",
                            widthRation: 0.12,
                            isEnable: controllerX.isEnable.value,
                            onFocusChange: (data) {
                              // controllerX.selectedDate.text =
                              //     DateFormat('dd/MM/yyyy').format(
                              //         DateFormat("dd-MM-yyyy").parse(data));
                              // DateFormat("dd-MM-yyyy").parse(data);
                              print("Called when focus changed");
                              /*controller.getDailyFPCDetailsList(
                                controllerX.selectedLocationId.text,
                                controllerX.selectedChannelId.text,
                                controllerX.convertToAPIDateType(),
                              );*/

                              // controller.isTableDisplayed.value = true;
                            },
                            mainTextController: controllerX.selectedDate,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 14.0, left: 10, right: 10),
                          child: FormButtonWrapper(
                            btnText: "Retrieve",
                            callback: () {},
                            showIcon: false,
                          ),
                        ),
                        InputFields.formFieldNumberMask(
                            hintTxt: "Start Time",
                            controller: controllerX.startTime_,
                            widthRatio: 0.12,
                            isTime: true,
                            paddingLeft: 0),

                        /// duration
                        InputFields.formFieldNumberMask(
                            hintTxt: "Offset Time",
                            controller: controllerX.startTime_,
                            widthRatio: 0.12,
                            isTime: true,
                            paddingLeft: 0),
                        SizedBox(
                          width: Get.width * 0.1,
                          child: Row(
                            children: [
                              SizedBox(width: 5),
                              Obx(() => Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Checkbox(
                                      value: controllerX.isStandby.value,
                                      onChanged: (val) {
                                        controllerX.isStandby.value = val!;
                                      },
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  )),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 15.0, left: 5),
                                child: Text(
                                  "Tx Comm.",
                                  style: TextStyle(
                                      fontSize: SizeDefine.labelSize1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            // Divider(),

            GetBuilder<TransmissionLogController>(
              id: "transmissionList",
              init: controllerX,
              builder: (controller) {
                return Expanded(
                  // width: Get.width,
                  // height: Get.height * .33,
                  child: (controllerX.transmissionLogList != null &&
                          (controllerX.transmissionLogList?.isNotEmpty)!)
                      ? DataGridFromMap1(
                          onFocusChange: (value) {
                            controllerX.gridStateManager!
                                .setGridMode(PlutoGridMode.selectWithOneTap);
                            controllerX.selectedPlutoGridMode =
                                PlutoGridMode.selectWithOneTap;
                          },
                          onload: (loadevent) {
                            controllerX.gridStateManager =
                                loadevent.stateManager;
                            if (controller.selectedIndex != null) {
                              loadevent.stateManager.moveScrollByRow(
                                  PlutoMoveDirection.down,
                                  controller.selectedIndex);
                              loadevent.stateManager.setCurrentCell(
                                  loadevent
                                      .stateManager
                                      .rows[controller.selectedIndex!]
                                      .cells
                                      .entries
                                      .first
                                      .value,
                                  controller.selectedIndex);
                            }
                          },
                          hideKeys: ["color", "modifed"],
                          showSrNo: true,
                          // mode: PlutoGridMode.selectWithOneTap,
                          colorCallback: (PlutoRowColorContext plutoContext) {
                            return Color(controllerX
                                    .transmissionLogList![plutoContext.rowIdx]
                                    .colorNo ??
                                Colors.white.value);
                          },
                          onSelected: (PlutoGridOnSelectedEvent event) {
                            event.selectedRows?.forEach((element) {
                              print("On Print select" +
                                  jsonEncode(element.toJson()));
                            });
                          },
                          onRowsMoved: (PlutoGridOnRowsMovedEvent onRowMoved) {
                            print("Index is>>" + onRowMoved.idx.toString());
                            Map map = onRowMoved.rows[0].cells;
                            print("On Print moved" +
                                jsonEncode(
                                    onRowMoved.rows[0].cells.toString()));
                            int? val=int.tryParse((onRowMoved.rows[0].cells["Episode Dur"]?.value.toString())!)!;
                            // print("After On select>>" + data.toString());
                            for (int i = (onRowMoved.idx) ?? 0; i >= 0; i--) {
                              print("On Print moved" + i.toString());
                              print("On select>>" +
                                  map["Episode Dur"].value.toString());

                              print("On Print moved cell>>>" +
                                  jsonEncode(controllerX.gridStateManager
                                      ?.rows[i].cells["Episode Dur"]?.value
                                      .toString()));

                              controllerX.gridStateManager?.rows[i]
                                      .cells["Episode Dur"] =
                                  PlutoCell(value: val-(i-onRowMoved.idx));
                            }
                            controllerX.gridStateManager?.notifyListeners();
                          },
                          mode: controllerX.selectedPlutoGridMode,
                          widthRatio: (Get.width / 11.4),
                          mapData: controllerX.transmissionLogList!
                              .map((e) => e.toJson1())
                              .toList())
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
                );
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
                  if (controller.tranmissionButtons != null) {
                    return SizedBox(
                      height: 40,
                      child: ButtonBar(
                        // buttonHeight: 20,
                        alignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        // pa
                        children: [
                          for (var btn in controller.tranmissionButtons!)
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
                          FormButtonWrapper(
                            btnText: "Aa",
                            showIcon: false,
                            // isEnabled: btn['isDisabled'],
                            callback: /*btn["name"] != "Delete" &&
                                      Utils.btnAccessHandler2(btn['name'],
                                              controller, formPermissions) ==
                                          null
                                  ? null
                                  :*/
                                () => formHandler("Aa"),
                          ),
                          FormButtonWrapper(
                            btnText: "CL",
                            showIcon: false,
                            isEnabled: false,
                            callback: /*btn["name"] != "Delete" &&
                                      Utils.btnAccessHandler2(btn['name'],
                                              controller, formPermissions) ==
                                          null
                                  ? null
                                  :*/
                                () => formHandler("CL"),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
            const SizedBox(height: 5),
          ],
        ),
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
        showSegmentDialog(Get.context);
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
                  GetBuilder<TransmissionLogController>(
                      id: "commercialsList",
                      init: controllerX,
                      builder: (controller) {
                        return SizedBox(
                          // width: 500,
                          width: Get.width * 0.8,
                          height: 300,
                          child: (controllerX.transmissionLogList != null &&
                                  (controllerX
                                      .transmissionLogList?.isNotEmpty)!)
                              ? DataGridFromMap(
                                  hideCode: false,
                                  formatDate: false,
                                  colorCallback: (renderC) => Colors.red[200]!,
                                  mapData: controllerX.transmissionLogList!
                                      .map((e) => e.toJson())
                                      .toList())
                              // _dataTable3()
                              : const WarningBox(
                                  text:
                                      'Enter Location, Channel & Date to get the Break Definitions'),
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
                  GetBuilder<TransmissionLogController>(
                      id: "commercialsList",
                      init: controllerX,
                      builder: (controller) {
                        return SizedBox(
                          // width: 500,
                          width: Get.width * 0.8,
                          height: 300,
                          child: (controllerX.transmissionLogList != null &&
                                  (controllerX
                                      .transmissionLogList?.isNotEmpty)!)
                              ? DataGridFromMap(
                                  hideCode: false,
                                  formatDate: false,
                                  colorCallback: (renderC) => Colors.red[200]!,
                                  mapData: controllerX.transmissionLogList!
                                      .map((e) => e.toJson())
                                      .toList())
                              // _dataTable3()
                              : const WarningBox(
                                  text:
                                      'Enter Location, Channel & Date to get the Break Definitions'),
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
                          width: 0.13,
                          onchanged: (value) {},
                          hintTxt: "TX Caption",
                          margin: true,
                          controller: controllerX.txCaption_),
                      InputFields.formField1(
                          width: 0.13,
                          onchanged: (value) {},
                          hintTxt: "TX Id",
                          margin: true,
                          controller: controllerX.txId_),
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
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15.0, left: 5),
                              child: Text(
                                "My",
                                style:
                                    TextStyle(fontSize: SizeDefine.labelSize1),
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
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15.0, left: 5),
                              child: Text(
                                "Insert After",
                                style:
                                    TextStyle(fontSize: SizeDefine.labelSize1),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      InputFields.formFieldNumberMask(
                          hintTxt: "",
                          controller: controllerX.insertDuration_
                            ..text = "00:00:00",
                          widthRatio: 0.13,
                          isTime: true,
                          isEnable: false,
                          paddingLeft: 0),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GetBuilder<TransmissionLogController>(
                      id: "commercialsList",
                      init: controllerX,
                      builder: (controller) {
                        return SizedBox(
                          // width: 500,
                          width: Get.width * 0.8,
                          height: Get.height * 0.6,
                          child: (controllerX.transmissionLogList != null &&
                                  (controllerX
                                      .transmissionLogList?.isNotEmpty)!)
                              ? DataGridFromMap(
                                  hideCode: false,
                                  formatDate: false,
                                  colorCallback: (renderC) => Colors.red[200]!,
                                  mapData: controllerX.transmissionLogList!
                                      .map((e) => e.toJson())
                                      .toList())
                              // _dataTable3()
                              : const WarningBox(
                                  text:
                                      'Enter Location, Channel & Date to get the Break Definitions'),
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

  showSegmentDialog(context) {
    return Get.defaultDialog(
      barrierDismissible: false,
      title: "Segments",
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
                      GetBuilder<TransmissionLogController>(
                        id: "selectedProgram",
                        init: controllerX,
                        builder: (controller) =>
                            DropDownField.formDropDownSearchAPI2(
                          GlobalKey(),
                          context,
                          title: "Program",
                          onchanged: (DropDownValue? value) async {
                            // selectedProgramId.text = value?.key ?? "";
                            // selectedProgram.text = value?.value ?? "";
                            // selectProgram = value;
                            // await controllerX.getDataAfterProgLoad(controllerX.selectedLocationId.text, controllerX.selectedChannelId.text, value!.key);
                          },
                          url: ApiFactory.OPERATIONAL_FPC_PROGRAM_SEARCH,
                          width: MediaQuery.of(context).size.width * .2,
                          // selectedValue: selectProgram,
                          widthofDialog: 350,
                          dialogHeight: Get.height * .65,
                        ),
                      ),
                      InputFields.numbers(
                        hintTxt: "Episode No",
                        onchanged: (val) {
                          // episodeNo.value = int.parse(val);
                          // controllerX.getTapeID(selectProgram!.key!, int.parse(val));
                        },
                        controller: TextEditingController(
                            // text: episodeNo.value.toString(),
                            ),
                        isNegativeReq: false,
                        width: 0.12,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 3),
                        child: InputFields.formFieldNumberMask(
                            hintTxt: "FPC Time",
                            controller: controllerX.segmentFpcTime_
                              ..text = "00:00:00",
                            widthRatio: 0.12,
                            isTime: true,
                            paddingLeft: 0),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Obx(
                        () => DropDownField.formDropDown1WidthMap(
                          controllerX.locations.value,
                          (value) {
                            controllerX.selectLocation = value;
                            // controllerX.selectedLocationId.text = value.key!;
                            // controllerX.selectedLocationName.text = value.value!;
                            // controller.getChannelsBasedOnLocation(value.key!);
                          },
                          "Tape",
                          0.12,
                          isEnable: controllerX.isEnable.value,
                          selected: controllerX.selectLocation,
                          autoFocus: true,
                          dialogWidth: 330,
                          dialogHeight: Get.height * .7,
                        ),
                      ),
                      SizedBox(
                        width: 10,
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
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GetBuilder<TransmissionLogController>(
                      id: "commercialsList",
                      init: controllerX,
                      builder: (controller) {
                        return SizedBox(
                          // width: 500,
                          width: Get.width * 0.8,
                          height: Get.height * 0.6,
                          child: (controllerX.transmissionLogList != null &&
                                  (controllerX
                                      .transmissionLogList?.isNotEmpty)!)
                              ? DataGridFromMap(
                                  hideCode: false,
                                  formatDate: false,
                                  colorCallback: (renderC) => Colors.red[200]!,
                                  mapData: controllerX.transmissionLogList!
                                      .map((e) => e.toJson())
                                      .toList())
                              // _dataTable3()
                              : const WarningBox(
                                  text:
                                      'Enter Location, Channel & Date to get the Break Definitions'),
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
                      width: 0.12,
                      onchanged: (value) {},
                      hintTxt: "TX Id",
                      margin: true,
                      padLeft: 0,
                      controller: controllerX.txId_),
                  Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: InputFields.formFieldNumberMask(
                        hintTxt: "Duration",
                        controller: controllerX.segmentFpcTime_
                          ..text = "00:00:00",
                        widthRatio: 0.12,
                        isTime: true,
                        paddingLeft: 0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: InputFields.formFieldNumberMask(
                        hintTxt: "OffSet",
                        controller: controllerX.segmentFpcTime_
                          ..text = "00:00:00",
                        widthRatio: 0.12,
                        isTime: true,
                        isEnable: false,
                        paddingLeft: 0),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: InputFields.formFieldNumberMask(
                        hintTxt: "FPC Time",
                        controller: controllerX.segmentFpcTime_
                          ..text = "00:00:00",
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
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15.0, left: 5),
                              child: Text(
                                "All",
                                style:
                                    TextStyle(fontSize: SizeDefine.labelSize1),
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
                      GetBuilder<TransmissionLogController>(
                          id: "commercialsList",
                          init: controllerX,
                          builder: (controller) {
                            return SizedBox(
                              // width: 500,
                              width: Get.width * 0.49,
                              height: Get.height * 0.53,
                              child: (controllerX.transmissionLogList != null &&
                                      (controllerX
                                          .transmissionLogList?.isNotEmpty)!)
                                  ? DataGridFromMap(
                                      hideCode: false,
                                      formatDate: false,
                                      colorCallback: (renderC) =>
                                          Colors.red[200]!,
                                      mapData: controllerX.transmissionLogList!
                                          .map((e) => e.toJson())
                                          .toList())
                                  // _dataTable3()
                                  : const WarningBox(
                                      text:
                                          'Enter Location, Channel & Date to get the Break Definitions'),
                            );
                          }),
                      GetBuilder<TransmissionLogController>(
                          id: "commercialsList",
                          init: controllerX,
                          builder: (controller) {
                            return SizedBox(
                              // width: 500,
                              width: Get.width * 0.3,
                              height: Get.height * 0.53,
                              child: (controllerX.transmissionLogList != null &&
                                      (controllerX
                                          .transmissionLogList?.isNotEmpty)!)
                                  ? DataGridFromMap(
                                      hideCode: false,
                                      formatDate: false,
                                      colorCallback: (renderC) =>
                                          Colors.red[200]!,
                                      mapData: controllerX.transmissionLogList!
                                          .map((e) => e.toJson())
                                          .toList())
                                  // _dataTable3()
                                  : const WarningBox(
                                      text:
                                          'Enter Location, Channel & Date to get the Break Definitions'),
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
                            controller: controllerX.segmentFpcTime_
                              ..text = "00:00:00",
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
                  GetBuilder<TransmissionLogController>(
                      id: "commercialsList",
                      init: controllerX,
                      builder: (controller) {
                        return SizedBox(
                          // width: 500,
                          width: Get.width * 0.8,
                          height: Get.height * 0.6,
                          child: (controllerX.transmissionLogList != null &&
                                  (controllerX
                                      .transmissionLogList?.isNotEmpty)!)
                              ? DataGridFromMap(
                                  hideCode: false,
                                  formatDate: false,
                                  colorCallback: (renderC) => Colors.red[200]!,
                                  mapData: controllerX.transmissionLogList!
                                      .map((e) => e.toJson())
                                      .toList())
                              // _dataTable3()
                              : const WarningBox(
                                  text:
                                      'Enter Location, Channel & Date to get the Break Definitions'),
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

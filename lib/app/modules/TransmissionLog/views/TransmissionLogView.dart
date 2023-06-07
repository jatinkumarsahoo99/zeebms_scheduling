import 'dart:convert';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:bms_scheduling/widgets/radio_row.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';
import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/WarningBox.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../../widgets/gridFromMapTransmissionLog.dart';
import '../../../../widgets/input_fields.dart';
import '../../../controller/HomeController.dart';
import '../../../data/DropDownValue.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/DataGridMenu.dart';
import '../../../providers/SizeDefine.dart';
import '../ColorDataModel.dart';
import '../CommercialModel.dart';
import '../controllers/TransmissionLogController.dart';

class TransmissionLogView extends GetView<TransmissionLogController> {
  // TransmissionLogController controller = Get.put(TransmissionLogController());
  final GlobalKey rebuildKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RawKeyboardListener(
        focusNode: new FocusNode(),
        onKey: (RawKeyEvent raw) {
          print("RAw is.>>>" + raw.toString());
          switch (raw.logicalKey.keyLabel) {
            case "F3":
              if (controller.gridStateManager != null) {
                controller.cutCopy(
                    isCut: false, row: controller.gridStateManager?.currentRow);
              }
              break;
            case "F2":
              if (controller.gridStateManager != null) {
                controller.cutCopy(
                    isCut: true, row: controller.gridStateManager?.currentRow);
              }
              break;
            case "F4":
              controller
                  .paste(controller.gridStateManager?.currentRowIdx);
              break;
          }
        },
        child: SizedBox(
          height: double.maxFinite,
          width: double.maxFinite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GetBuilder<TransmissionLogController>(
                init: controller,
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
                              controller.locations.value,
                              (value) {
                                controller.selectLocation = value;
                                controller.getChannels(
                                    controller.selectLocation?.key ?? "");
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
                                controller.getChannelFocusOut();
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
                          SizedBox(
                            width: Get.width * 0.077,
                            child: Row(
                              children: [
                                SizedBox(width: 5),
                                Obx(() => Padding(
                                      padding: const EdgeInsets.only(top: 15.0),
                                      child: Checkbox(
                                        value: controller.isStandby.value,
                                        onChanged: controller.isEnable.value
                                            ? (val) {
                                                controller.isStandby.value =
                                                    val!;
                                              }
                                            : null,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                    )),
                                Obx(
                                  () => Padding(
                                      padding: const EdgeInsets.only(
                                          top: 15.0, left: 5),
                                      child: Text(
                                        "Standby Log",
                                        style: TextStyle(
                                            fontSize: SizeDefine.labelSize1,
                                            color: controller.isEnable.value
                                                ? Colors.black
                                                : Colors.grey),
                                      )),
                                ),
                              ],
                            ),
                          ),
                          Obx(
                            () => DateWithThreeTextField(
                              title: "Schedule Date",
                              splitType: "-",
                              widthRation: 0.12,
                              isEnable: controller.isEnable.value,
                              onFocusChange: (data) {
                                // controller.selectedDate.text =
                                //     DateFormat('dd/MM/yyyy').format(
                                //         DateFormat("dd-MM-yyyy").parse(data));
                                // DateFormat("dd-MM-yyyy").parse(data);
                                print("Called when focus changed");
                                /*controller.getDailyFPCDetailsList(
                                  controller.selectedLocationId.text,
                                  controller.selectedChannelId.text,
                                  controller.convertToAPIDateType(),
                                );*/

                                // controller.isTableDisplayed.value = true;
                              },
                              mainTextController: controller.selectedDate,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 14.0, left: 10, right: 10),
                            child: FormButtonWrapper(
                              btnText: "Retrieve",
                              callback: () {
                                // controller.callRetrieve();
                                controller.getColorList();
                              },
                              showIcon: false,
                            ),
                          ),
                          InputFields.formFieldNumberMask(
                              hintTxt: "Start Time",
                              controller: controller.startTime_,
                              widthRatio: 0.12,
                              isTime: true,
                              paddingLeft: 0),

                          /// duration
                          Obx(() => InputFields.formFieldNumberMask(
                              hintTxt: "Offset Time",
                              controller: controller.offsetTime_,
                              widthRatio: 0.12,
                              isTime: true,
                              isEnable: controller.isEnable.value,
                              paddingLeft: 0)),
                          SizedBox(
                            width: Get.width * 0.1,
                            child: Row(
                              children: [
                                SizedBox(width: 5),
                                Obx(() => Padding(
                                      padding: const EdgeInsets.only(top: 15.0),
                                      child: Checkbox(
                                        value: controller.chkTxCommercial.value,
                                        onChanged: (val) {
                                          controller.chkTxCommercial.value =
                                              val!;
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
                init: controller,
                builder: (controller) {
                  return Expanded(
                    // width: Get.width,
                    // height: Get.height * .33,
                    child: (controller.transmissionLog != null &&
                            controller.transmissionLog?.loadSavedLogOutput !=
                                null &&
                            controller.transmissionLog?.loadSavedLogOutput
                                    ?.lstTransmissionLog !=
                                null &&
                            (controller.transmissionLog?.loadSavedLogOutput
                                ?.lstTransmissionLog?.isNotEmpty)!)
                        ? DataGridFromMapTransmissionLog(
                            onFocusChange: (value) {
                              controller.gridStateManager!
                                  .setGridMode(PlutoGridMode.selectWithOneTap);
                              controller.selectedPlutoGridMode =
                                  PlutoGridMode.selectWithOneTap;
                            },
                            hideCode: false,
                            colorCallback: (PlutoRowColorContext colorData) {
                              PlutoRow currentRow =
                                  colorData.stateManager.rows[colorData.rowIdx];
                              ColorDataModel? data =
                                  Get.find<TransmissionLogController>()
                                      .getMatchWithKey(currentRow
                                              .cells["eventType"]?.value ??
                                          "");
                              Color color = Colors.white;
                              if (data != null) {
                                // print("Index is>> ${colorData.rowIdx.toString()} >>>> ${data.backColor}");
                                /*print(
                                    ">>>>>Color code is>>>>Index is>${colorData.rowIdx.toString()}" +
                                        ">>>>>>" +
                                        data.backColor.toString());*/
                                color = Color(int.parse('0x${data.backColor}'));
                              }
                              if (currentRow.cells["productName"]?.value !=
                                      null &&
                                  currentRow.cells["productName"]?.value !=
                                      "") {
                                String strPriority = ((currentRow
                                            .cells["bookingNumber"]?.value
                                            .toString()
                                            .trim() ??
                                        "") +
                                    (currentRow
                                            .cells["bookingdetailcode"]?.value
                                            .toString()
                                            .trim() ??
                                        ""));
                                if (strPriority != null && strPriority != "") {
                                  ColorDataModel? data1 =
                                      Get.find<TransmissionLogController>()
                                          .getMatchWithKey(strPriority);
                                  if (data1 != null) {
                                    /*print(
                                        ">>>>>Color code is>>>>Index is>${colorData.rowIdx.toString()}" +
                                            ">>>>>>" +
                                            data1.backColor.toString());*/
                                    color = Color(
                                        int.parse('0x${data1.backColor}'));
                                  }
                                }
                              }
                              return color;
                            },
                            onload: (loadevent) {
                              controller.gridStateManager =
                                  loadevent.stateManager;
                              if (controller.isFetch.value) {
                                controller.isFetch.value = false;
                                controller.colorGrid(false);
                              }
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
                            formatDate: false,
                            hideKeys: ["foreColor", "backColor", "modifed"],
                            showSrNo: true,
                            // mode: PlutoGridMode.selectWithOneTap,
                            /*   colorCallback: (PlutoRowColorContext plutoContext) {
                              return Color(controller
                                      .transmissionLog![plutoContext.rowIdx]
                                      .colorNo ??
                                  Colors.white.value);
                            },*/
                            onSelected: (PlutoGridOnSelectedEvent event) {
                              event.selectedRows?.forEach((element) {
                                print("On Print select" +
                                    jsonEncode(element.toJson()));
                              });
                            },
                            onChanged: (PlutoGridOnChangedEvent event) {
                              print("On changed called>>>>" + event.toString());
                            },
                            /*colorCallback: (PlutoRowColorContext plutoContext) {
                              return Color(int.parse(
                                  '0x${controller.transmissionLog?.loadSavedLogOutput?.lstTransmissionLog![plutoContext.rowIdx].backColor}'));
                            },*/
                            onContextMenuClick: (DataGridMenuItem itemType,
                                int index, renderContext) {
                              switch (itemType) {
                                case DataGridMenuItem.delete:
                                  controller.gridStateManager
                                      ?.removeCurrentRow();
                                  break;
                                case DataGridMenuItem.verifyTime:
                                  controller.checkVerifyTime();
                                  break;
                                case DataGridMenuItem.clearpaste:
                                  controller.copyRow = null;
                                  break;
                                case DataGridMenuItem.freezeColumn:
                                  renderContext.stateManager.toggleFrozenColumn(
                                      renderContext.column,
                                      PlutoColumnFrozen.start);
                                  // renderContext.column.frozen=PlutoColumnFrozen.start;
                                  break;
                                case DataGridMenuItem.unFreezeColumn:
                                  renderContext.stateManager.toggleFrozenColumn(
                                      renderContext.column,
                                      PlutoColumnFrozen.none);
                                  // renderContext.column.frozen=PlutoColumnFrozen.none;
                                  break;

                                case DataGridMenuItem.cut:
                                  controller.cutCopy(
                                      isCut: true, row: renderContext.row);
                                  /*controller.lastSelectOption = "cut";
                                  controller.copyRow = renderContext.row;
                                  print("On Print cut index is>>>" +
                                      index.toString());
                                  renderContext.row.cells.forEach((key, value) {
                                    print("On Print cut" +
                                        value.key.toString() +
                                        ">>>>" +
                                        value.value.toString());
                                  });*/
                                  break;
                                case DataGridMenuItem.copy:
                                  controller.cutCopy(
                                      isCut: false, row: renderContext.row);
                                  /*controller.lastSelectOption = "copy";
                                  controller.copyRow = renderContext.row;
                                  // print("On Print moved" + jsonEncode(renderContext.row.));
                                  print("On Print copy index is>>>" +
                                      index.toString());
                                  renderContext.row.cells.forEach((key, value) {
                                    print("On Print copy" +
                                        value.key.toString() +
                                        ">>>>" +
                                        value.value.toString());
                                  });*/
                                  break;
                                case DataGridMenuItem.fixedEvent:
                                  controller.fixedEvent(index);
                                  break;
                                case DataGridMenuItem.paste:
                                  controller.paste(index);
                                  /*if (controller.lastSelectOption != null &&
                                      controller.copyRow != null) {
                                    switch (controller.lastSelectOption) {
                                      case "cut":
                                        controller.gridStateManager
                                            ?.removeRows(
                                                [controller.copyRow!]);
                                        controller.gridStateManager
                                            ?.insertRows(
                                                index, [controller.copyRow!]);
                                        controller.copyRow = null;
                                        controller.gridStateManager
                                            ?.notifyListeners();
                                        break;
                                      case "copy":
                                        // controller.gridStateManager?.rows.insert(index, controller.copyRow!);
                                        controller.gridStateManager
                                            ?.insertRows(
                                                index, [controller.copyRow!]);
                                        controller.gridStateManager
                                            ?.notifyListeners();
                                        break;
                                    }
                                  } else {
                                    LoadingDialog.callInfoMessage(
                                        "Nothing is selected");
                                  }*/
                                  break;
                              }
                            },
                            onRowsMoved:
                                (PlutoGridOnRowsMovedEvent onRowMoved) {
                              controller.isRowFilter.value = true;
                              print("Index is>>" + onRowMoved.idx.toString());
                              print("On Print moved" +
                                  jsonEncode(
                                      onRowMoved.rows[0].cells.toString()));

                              // print("Index is>>" + onRowMoved.idx.toString());
                              // Map map = onRowMoved.rows[0].cells;
                              // print("On Print moved" +
                              //     jsonEncode(
                              //         onRowMoved.rows[0].cells.toString()));
                              // int? val = int.tryParse((onRowMoved
                              //     .rows[0].cells["Episode Dur"]?.value
                              //     .toString())!)!;
                              // // print("After On select>>" + data.toString());
                              // for (int i = (onRowMoved.idx) ?? 0; i >= 0; i--) {
                              //   print("On Print moved" + i.toString());
                              //   print("On select>>" +
                              //       map["Episode Dur"].value.toString());
                              //
                              //   print("On Print moved cell>>>" +
                              //       jsonEncode(controller.gridStateManager
                              //           ?.rows[i].cells["Episode Dur"]?.value
                              //           .toString()));
                              //
                              //   controller.gridStateManager?.rows[i]
                              //           .cells["Episode Dur"] =
                              //       PlutoCell(value: val - (i - onRowMoved.idx));
                              // }
                              // controller.gridStateManager?.notifyListeners();
                            },
                            mode: controller.selectedPlutoGridMode,
                            widthRatio: (Get.width / 11.4),
                            mapData: (controller.transmissionLog
                                ?.loadSavedLogOutput?.lstTransmissionLog!
                                .map((e) => e.toJson())
                                .toList())!)
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
                              onPressed: () {
                                this.controller.btnUp_Click();
                              },
                              icon: Icon(Icons.arrow_upward),
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                            ),
                            IconButton(
                              onPressed: () {
                                this.controller.btnDown_Click();
                              },
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
      ),
    );
  }

  formHandler(btn) {
    switch (btn) {
      case "Commercials":
        controller.getCommercialList(fun: (model) {
          showCommercialDialog(Get.context, model);
        });
        break;
      case "Updated":
        controller.getUpdateClick();
        break;
      case "Insert":
        controller.getEventListForInsert(function: () {
          showInsertDialog(Get.context);
        });
        break;
      case "Segments":
        showSegmentDialog(Get.context);
        break;
      case "Change":
        controller.setChangeTime(function: (){
          showChangeDialog(Get.context);
        });

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
      case "Export":
        // controller.colorGrid(false);
        break;
      case "Undo":
        controller.undoClick();
        break;
      case "Auto":
        LoadingDialog.recordExists(
            "Do you want to add promos?",
            () {
              controller.isAutoClick.value = true;
              controller.callAuto(true);
            },
            deleteTitle: "Yes",
            deleteCancel: "No",
            cancel: () {
              controller.isAutoClick.value = true;
              controller.callAuto(false);
            });

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
                          controller.locations.value,
                          (value) {
                            controller.selectLocation = value;
                            // controller.selectedLocationId.text = value.key!;
                            // controller.selectedLocationName.text = value.value!;
                            // controller.getChannelsBasedOnLocation(value.key!);
                          },
                          "Time",
                          0.12,
                          isEnable: controller.isEnable.value,
                          selected: controller.selectLocation,
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
                      init: controller,
                      builder: (controller) {
                        return SizedBox(
                          // width: 500,
                          width: Get.width * 0.8,
                          height: 300,
                          child: (controller.transmissionLog != null)
                              ? DataGridFromMap(
                                  hideCode: false,
                                  formatDate: false,
                                  colorCallback: (renderC) => Colors.red[200]!,
                                  mapData: (controller.transmissionLog
                                      ?.loadSavedLogOutput?.lstTransmissionLog!
                                      .map((e) => e.toJson())
                                      .toList())!)
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

  showCommercialDialog(context, CommercialModel? model) {
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
                      DropDownField.formDropDown1WidthMap(
                        model?.timelist?.toList(),
                        (value) {
                          controller.selectTimeForCommercial = value;
                          controller.dataGridRowFilter(
                            matchValue: value.value ?? "",
                            filterKey: 'fpCtime',
                          );
                          controller.dataGridRowFilterCommercial(
                            matchValue: value.value ?? "",
                            filterKey: 'scheduletime',
                          );
                          // controller.selectedLocationId.text = value.key!;
                          // controller.selectedLocationName.text = value.value!;
                          // controller.getChannelsBasedOnLocation(value.key!);
                        },
                        "Time",
                        0.12,
                        // isEnable: controller.isEnable.value,
                        selected: controller.selectTimeForCommercial,
                        autoFocus: true,
                        dialogWidth: 330,
                        dialogHeight: Get.height * .7,
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
                      init: controller,
                      builder: (controller) {
                        return SizedBox(
                          // width: 500,
                          width: Get.width * 0.8,
                          height: 300,
                          child: (model != null &&
                                  model.lstListLoggedCommercials != null &&
                                  model.lstListLoggedCommercials?.length != 0)
                              ? DataGridFromMap(
                                  hideCode: false,
                                  formatDate: false,
                                  onload: (PlutoGridOnLoadedEvent load) {
                                    controller.gridStateManagerCommercial =
                                        load.stateManager;
                                  },
                                  // colorCallback: (renderC) => Colors.red[200]!,
                                  mapData: (model.lstListLoggedCommercials
                                      ?.map((e) => e.toJson())
                                      .toList())!)
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
                          controller.listEventsinInsert.value,
                          (value) {
                            controller.selectEvent = value;
                            // controller.selectedLocationId.text = value.key!;
                            // controller.selectedLocationName.text = value.value!;
                            // controller.getChannelsBasedOnLocation(value.key!);
                          },
                          "Event",
                          0.13,
                          // isEnable: controller.isEnable.value,
                          // selected: controller.selectLocation,
                          autoFocus: true,
                          dialogWidth: 330,
                          dialogHeight: Get.height * .7,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      InputFields.formField1(
                          width: 0.13,
                          onchanged: (value) {},
                          hintTxt: "TX Caption",
                          margin: true,
                          controller: controller.txCaption_),
                      SizedBox(
                        width: 10,
                      ),
                      InputFields.formField1(
                          width: 0.13,
                          onchanged: (value) {},
                          hintTxt: "TX Id",
                          margin: true,
                          controller: controller.txId_),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: Get.width * 0.05,
                        child: Row(
                          children: [
                            SizedBox(width: 5),
                            Obx(
                              () => Padding(
                                padding: const EdgeInsets.only(top: 15.0),
                                child: Checkbox(
                                  value: controller.isMy.value,
                                  onChanged: (val) {
                                    controller.isMy.value = val!;
                                  },
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                            ),
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
                      FittedBox(
                        child: Row(
                          children: [
                            SizedBox(width: 5),
                            Obx(() => Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: Checkbox(
                                    value: controller.isInsertAfter.value,
                                    onChanged: (val) {
                                      controller.isInsertAfter.value = val!;
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
                      SizedBox(
                        width: 10,
                      ),
                      InputFields.formFieldNumberMask(
                          hintTxt: "",
                          controller: controller.insertDuration_
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
                      init: controller,
                      builder: (controller) {
                        return SizedBox(
                          // width: 500,
                          width: Get.width * 0.8,
                          height: Get.height * 0.5,
                          child: (controller.transmissionLog != null)
                              ? DataGridFromMap(
                                  hideCode: false,
                                  formatDate: false,
                                  colorCallback: (renderC) => Colors.red[200]!,
                                  mapData: (controller.transmissionLog
                                      ?.loadSavedLogOutput?.lstTransmissionLog!
                                      .map((e) => e.toJson())
                                      .toList())!)
                              // _dataTable3()
                              : const WarningBox(
                                  text:
                                      'Enter Location, Channel & Date to get the Break Definitions'),
                        );
                      }),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 5, right: 16, bottom: 4, top: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Replace",
                          style: TextStyle(fontSize: 13),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 16),
                            child: Divider(
                              height: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      InputFields.formField1(
                          width: 0.13,
                          onchanged: (value) {},
                          hintTxt: "TX Id",
                          margin: true,
                          controller: controller.txId_),
                      SizedBox(
                        width: 10,
                      ),
                      InputFields.formFieldNumberMask(
                          hintTxt: "Duration",
                          controller: controller.insertDuration_
                            ..text = "00:00:00",
                          widthRatio: 0.13,
                          isTime: true,
                          paddingLeft: 0),
                      SizedBox(width: 5),
                      FittedBox(
                        child: Row(
                          children: [
                            SizedBox(width: 5),
                            Obx(() => Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: Checkbox(
                                    value: controller.isAllDay.value,
                                    onChanged: (val) {
                                      controller.isAllDay.value = val!;
                                    },
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                )),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 15.0, left: 5),
                              child: Text(
                                "All day",
                                style:
                                    TextStyle(fontSize: SizeDefine.labelSize1),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 5),
                      InputFields.formFieldNumberMask(
                          hintTxt: "From",
                          controller: controller.fromInsert_..text = "00:00:00",
                          widthRatio: 0.13,
                          isTime: true,
                          isEnable: false,
                          paddingLeft: 0),
                      SizedBox(width: 10),
                      InputFields.formFieldNumberMask(
                          hintTxt: "To",
                          controller: controller.toInsert_..text = "00:00:00",
                          widthRatio: 0.13,
                          isTime: true,
                          isEnable: false,
                          paddingLeft: 0),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 15),
                        child: FormButtonWrapper(
                          btnText: "Get Event",
                          showIcon: false,
                          callback: () {},
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 15),
                        child: FormButtonWrapper(
                          btnText: "Replace",
                          showIcon: false,
                          callback: () {},
                        ),
                      ),
                    ],
                  )
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
                        init: controller,
                        builder: (controller) =>
                            DropDownField.formDropDownSearchAPI2(
                          GlobalKey(),
                          context,
                          title: "Program",
                          onchanged: (DropDownValue? value) async {
                            // selectedProgramId.text = value?.key ?? "";
                            // selectedProgram.text = value?.value ?? "";
                            // selectProgram = value;
                            // await controller.getDataAfterProgLoad(controller.selectedLocationId.text, controller.selectedChannelId.text, value!.key);
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
                          // controller.getTapeID(selectProgram!.key!, int.parse(val));
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
                            controller: controller.segmentFpcTime_
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
                          controller.locations.value,
                          (value) {
                            controller.selectLocation = value;
                            // controller.selectedLocationId.text = value.key!;
                            // controller.selectedLocationName.text = value.value!;
                            // controller.getChannelsBasedOnLocation(value.key!);
                          },
                          "Tape",
                          0.12,
                          isEnable: controller.isEnable.value,
                          selected: controller.selectLocation,
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
                      init: controller,
                      builder: (controller) {
                        return SizedBox(
                          // width: 500,
                          width: Get.width * 0.8,
                          height: Get.height * 0.6,
                          child: (controller.transmissionLog != null)
                              ? DataGridFromMap(
                                  hideCode: false,
                                  formatDate: false,
                                  colorCallback: (renderC) => Colors.red[200]!,
                                  mapData: (controller.transmissionLog
                                      ?.loadSavedLogOutput?.lstTransmissionLog!
                                      .map((e) => e.toJson())
                                      .toList())!)
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
                      isEnable:false,
                      controller: controller.txId_Change),
                  Obx(()=>Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: InputFields.formFieldNumberMask(
                        hintTxt: "Duration",
                        controller: controller.duration_change,
                        widthRatio: 0.12,
                        // isTime: true,
                        isEnable:controller.visibleChangeDuration.value,
                        paddingLeft: 0),
                  )),
                  Obx(()=>Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: InputFields.formFieldNumberMask(
                        hintTxt: "OffSet",
                        controller: controller.offset_change,
                        widthRatio: 0.12,
                        // isTime: true,
                        isEnable: controller.visibleChangeOffset.value,
                        paddingLeft: 0),
                  )),
                  Obx(()=>Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: InputFields.formFieldNumberMask(
                        hintTxt: "FPC Time",
                        controller: controller.fpctime_change,
                        widthRatio: 0.12,
                        // isTime: true,
                        isEnable: controller.visibleChangeFpc.value,
                        paddingLeft: 0),
                  )),
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
                                    value: controller.isAllByChange.value,
                                    onChanged: (val) {
                                      controller.isAllByChange.value = val!;
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
                          callback: () {
                            controller.btnChangeDone_Click();
                          },
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
                          init: controller,
                          builder: (controller) {
                            return SizedBox(
                              // width: 500,
                              width: Get.width * 0.49,
                              height: Get.height * 0.53,
                              child: (controller.transmissionLog != null)
                                  ? DataGridFromMap(
                                      hideCode: false,
                                      formatDate: false,
                                      colorCallback: (renderC) =>
                                          Colors.red[200]!,
                                      mapData: (controller
                                          .transmissionLog
                                          ?.loadSavedLogOutput
                                          ?.lstTransmissionLog!
                                          .map((e) => e.toJson())
                                          .toList())!)
                                  // _dataTable3()
                                  : const WarningBox(
                                      text:
                                          'Enter Location, Channel & Date to get the Break Definitions'),
                            );
                          }),
                      GetBuilder<TransmissionLogController>(
                          id: "commercialsList",
                          init: controller,
                          builder: (controller) {
                            return SizedBox(
                              // width: 500,
                              width: Get.width * 0.3,
                              height: Get.height * 0.53,
                              child: (controller.transmissionLog != null)
                                  ? DataGridFromMap(
                                      hideCode: false,
                                      formatDate: false,
                                      colorCallback: (renderC) =>
                                          Colors.red[200]!,
                                      mapData: (controller
                                          .transmissionLog
                                          ?.loadSavedLogOutput
                                          ?.lstTransmissionLog!
                                          .map((e) => e.toJson())
                                          .toList())!)
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
                            controller: controller.segmentFpcTime_
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
                      groupValue: controller.verifyType.value ?? "",
                      onchange: (val) {
                        print("Response>>>" + val);
                        controller.verifyType.value = val;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GetBuilder<TransmissionLogController>(
                      id: "commercialsList",
                      init: controller,
                      builder: (controller) {
                        return SizedBox(
                          // width: 500,
                          width: Get.width * 0.8,
                          height: Get.height * 0.6,
                          child: (controller.transmissionLog != null)
                              ? DataGridFromMap(
                                  hideCode: false,
                                  formatDate: false,
                                  colorCallback: (renderC) => Colors.red[200]!,
                                  mapData: (controller.transmissionLog
                                      ?.loadSavedLogOutput?.lstTransmissionLog!
                                      .map((e) => e.toJson())
                                      .toList())!)
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

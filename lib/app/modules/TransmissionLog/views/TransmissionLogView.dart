import 'dart:convert';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:bms_scheduling/widgets/radio_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';
import 'package:intl/intl.dart';
import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/WarningBox.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/floating_dialog.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../../widgets/gridFromMapTransmissionLog.dart';
import '../../../../widgets/input_fields.dart';
import '../../../../widgets/radio_column.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../data/DropDownValue.dart';
import '../../../data/PermissionModel.dart';
import '../../../data/user_data_settings_model.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/DataGridMenu.dart';
import '../../../providers/SizeDefine.dart';
import '../../../providers/Utils.dart';
import '../../../routes/app_pages.dart';
import '../ColorDataModel.dart';
import '../CommercialModel.dart';
import '../controllers/TransmissionLogController.dart';

class TransmissionLogView extends StatelessWidget {
  TransmissionLogController controller = Get.put(TransmissionLogController());
  var rebuildKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      Offset centerOffset =
          Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);

      return RawKeyboardListener(
        focusNode: new FocusNode(),
        onKey: (RawKeyEvent raw) {
          controller.keyBoardHander(raw);
          /*if (raw is RawKeyDownEvent &&
                  raw.isControlPressed &&
                  raw.character?.toLowerCase() == "c") {
                print("Copy Pressed Ctrl + c ");
                if (controller.gridStateManager != null &&
                    controller.gridStateManager?.currentCell != null) {
                  print("Copy Pressed in clipboard ");
                  */ /*Clipboard.setData(new ClipboardData(
                      text: controller.gridStateManager?.currentCell?.value));*/ /*
                  Utils.copyToClipboardHack(
                      controller.gridStateManager?.currentCell?.value);
                }
              }

              if (raw is RawKeyDownEvent &&
                  raw.isControlPressed &&
                  raw.character?.toLowerCase() == "c") {
                print("Copy Pressed Ctrl + c ");
                if (controller.gridStateManager != null &&
                    controller.gridStateManager?.currentCell != null) {
                  print("Copy Pressed in clipboard ");
                  */ /*Clipboard.setData(new ClipboardData(
                      text: controller.gridStateManager?.currentCell?.value));*/ /*
                  Utils.copyToClipboardHack(
                      controller.gridStateManager?.currentCell?.value);
                }
              }

              if (raw is RawKeyDownEvent && raw.character?.toLowerCase() == "y") {
                if (controller.completerDialog != null &&
                    controller.dialogWidget != null) {
                  controller.dialogWidget = null;
                  controller.canDialogShow.value = false;
                  controller.completerDialog?.complete(true);
                }
              }
              if (raw is RawKeyDownEvent && raw.character?.toLowerCase() == "n") {
                if (controller.completerDialog != null &&
                    controller.dialogWidget != null) {
                  controller.dialogWidget = null;
                  controller.canDialogShow.value = false;
                  controller.completerDialog?.complete(false);
                }
              }
              switch (raw.logicalKey.keyLabel) {
                case "F3":
                  if (controller.gridStateManager != null) {
                    controller.cutCopy(
                        isCut: false,
                        row: controller.gridStateManager?.currentRow);
                  }
                  break;
                case "F2":
                  if (controller.gridStateManager != null) {
                    controller.cutCopy(
                        isCut: true,
                        row: controller.gridStateManager?.currentRow);
                  }
                  break;
                case "F4":
                  controller.paste(controller.gridStateManager?.currentRowIdx);
                  break;
                case "F5":
                  controller.checkVerifyTime();
                  break;
              }*/
        },
        child: Scaffold(
          key: rebuildKey,
          floatingActionButton: Obx(() {
            return controller.canDialogShow.value
                ? DraggableFab(
                    initPosition: controller.getOffSetValue(constraints),
                    child: controller.dialogWidget!,
                  )
                : SizedBox();
          }),
          body: SizedBox(
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
                      padding: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 15),
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
                                // dialogWidth: 330,
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
                                // dialogWidth: 330,
                                dialogHeight: Get.height * .7,
                              ),
                            ),
                            SizedBox(
                              width: Get.width * 0.079,
                              child: Row(
                                children: [
                                  SizedBox(width: 5),
                                  Obx(() => Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
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
                                  /* DateTime date = DateFormat("dd-MM-yyyy").parse(data);
                                print("Focus date is>>>" + date.toString());
                                bool valDate = date.isBefore(DateTime.now());
                                bool isSameDate = DateUtils.isSameDay(date, DateTime.now());
                                print("Is back date>>>" + valDate.toString());
                                print("Is same date>>>" + isSameDate.toString());
                                if(isSameDate) {
                                  controller.isBackDated = false;
                                }else if(valDate) {
                                  controller.isBackDated = valDate;
                                }else{
                                  controller.isBackDated = false;
                                }
                                Get.find<HomeController>().update(["transButtons"]);
                                print("Called when focus changed");*/
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
                                isTime: false,
                                textFieldFN: controller.startTime_focus,
                                paddingLeft: 0),

                            /// duration
                            InputFields.formFieldNumberMask(
                                hintTxt: "Offset Time",
                                controller: controller.offsetTime_,
                                widthRatio: 0.12,
                                isTime: false,
                                isEnable: false,
                                paddingLeft: 0),
                            SizedBox(
                              width: Get.width * 0.073,
                              child: Row(
                                children: [
                                  SizedBox(width: 5),
                                  Obx(() => Padding(
                                        padding:
                                            const EdgeInsets.only(top: 15.0),
                                        child: Checkbox(
                                          value:
                                              controller.chkTxCommercial.value,
                                          onChanged: (val) {
                                            controller.chkTxCommercial.value =
                                                val!;
                                          },
                                          materialTapTargetSize:
                                              MaterialTapTargetSize.shrinkWrap,
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 15.0, left: 5),
                                    child: Text(
                                      "Tx Comm.",
                                      style: TextStyle(
                                          fontSize: SizeDefine.labelSize1),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Obx(
                              () => Padding(
                                padding: const EdgeInsets.only(
                                  top: 15.0,
                                ),
                                child: Text(
                                  (controller.lastSavedLoggedUser.value ?? "") +
                                      " \n" +
                                      " Transmission Time: " +
                                      (controller.totalTransTime.value ?? ""),
                                  style: TextStyle(
                                      fontSize: SizeDefine.labelSize1,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.start,
                                ),
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
                              witdthSpecificColumn: (controller
                                  .userDataSettings?.userSetting
                                  ?.firstWhere((element) => element.controlName == "gridStateManager",
                                      orElse: () => UserSetting())
                                  .userSettings),
                              hideCode: false,
                              draggableKeys: ["transmissionTime"],
                              cellColorCallback: (cell) {
                                if (cell.cell.column.field != "fpCtime") {
                                  return Colors.blue.shade700;
                                } else {
                                  PlutoRow currentRow =
                                      cell.stateManager.rows[cell.rowIdx];
                                  ColorDataModel? data =
                                      Get.find<TransmissionLogController>()
                                          .getMatchWithKey(currentRow
                                                  .cells["eventType"]?.value ??
                                              "");
                                  Color color = Colors.white;
                                  if (data != null) {
                                    color =
                                        Color(int.parse('0x${data.backColor}'));
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
                                        (currentRow.cells["bookingdetailcode"]
                                                ?.value
                                                .toString()
                                                .trim() ??
                                            ""));
                                    if (strPriority != null &&
                                        strPriority != "") {
                                      ColorDataModel? data1 =
                                          Get.find<TransmissionLogController>()
                                              .getMatchWithKey(strPriority);
                                      if (data1 != null) {
                                        color = Color(
                                            int.parse('0x${data1.backColor}'));
                                      }
                                    }
                                  }
                                  return color;
                                }
                              },
                              colorCallback: (PlutoRowColorContext colorData) {
                                PlutoRow currentRow = colorData
                                    .stateManager.rows[colorData.rowIdx];
                                ColorDataModel? data =
                                    Get.find<TransmissionLogController>()
                                        .getMatchWithKey(currentRow
                                                .cells["eventType"]?.value ??
                                            "");
                                Color color = Colors.white;
                                if (controller
                                        .gridStateManager?.currentRowIdx ==
                                    colorData.rowIdx) {
                                  return Color(0xFF2979FF);
                                  // return Colors.blue[900]!;
                                  // return Colors.blueAccent;
                                }

                                if (data != null) {
                                  color =
                                      Color(int.parse('0x${data.backColor}'));
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
                                  if (strPriority != null &&
                                      strPriority != "") {
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
                                loadevent.stateManager
                                    .setGridMode(PlutoGridMode.normal);
                                loadevent.stateManager.onSelectCellCallback =
                                    () {
                                  controller.calculateTotalTransmissionTime();
                                };
                                // loadevent.stateManager.setSelecting(true);
                                loadevent.stateManager.setSelectingMode(
                                    PlutoGridSelectingMode.row);
                                if (controller.isFetch.value) {
                                  controller.isFetch.value = false;
                                  controller.colorGrid(false);
                                  controller.logSaved = true;
                                  loadevent.stateManager.setCurrentCell(
                                      loadevent
                                          .stateManager.rows[0].cells["no"],
                                      0);
                                  controller.downloadForce();
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

                                /////////////19 Oct 23 : By Sanjaya ///////////
                                loadevent.stateManager.setSelecting(true);
                                loadevent.stateManager.gridFocusNode
                                    .addListener(() {
                                  if (!loadevent
                                      .stateManager.gridFocusNode.hasFocus) {
                                    if (loadevent.stateManager
                                            .currentSelectingRows.isEmpty &&
                                        loadevent.stateManager.currentCell !=
                                            null) {
                                      loadevent.stateManager.toggleSelectingRow(
                                          loadevent.stateManager.currentRowIdx);
                                    }
                                    loadevent.stateManager.clearCurrentCell();
                                  }
                                });
                              },
                              formatDate: false,
                              hideKeys: ["foreColor", "backColor", "modifed"],
                              showSrNo: true,
                              // mode: PlutoGridMode.selectWithOneTap,

                              onSelected: (PlutoGridOnSelectedEvent event) {
                                print("On Print select 1");
                                event.selectedRows?.forEach((element) {
                                  print("On Print select" +
                                      jsonEncode(element.toJson()));
                                });
                              },
                              onChanged: (PlutoGridOnChangedEvent event) {
                                print(
                                    "On changed called>>>>" + event.toString());
                              },
                              /*colorCallback: (PlutoRowColorContext plutoContext) {
                              return Color(int.parse(
                                  '0x${controller.transmissionLog?.loadSavedLogOutput?.lstTransmissionLog![plutoContext.rowIdx].backColor}'));
                            },*/
                              onContextMenuClick: (DataGridMenuItem itemType,
                                  int index, renderContext) {
                                switch (itemType) {
                                  case DataGridMenuItem.delete:
                                    controller.deleteMultiple();
                                    /*LoadingDialog.recordExists(
                                    "Want to delete selected record?\nEvent type: ${renderContext
                                        .row.cells["eventType"]?.value ??
                                        ""}\nDuration: ${renderContext.row
                                        .cells["tapeduration"]?.value ??
                                        ""}\nExportTapeCode: ${renderContext.row
                                        .cells["exportTapeCode"]?.value ??
                                        ""}\nExportTapeCaption: ${renderContext
                                        .row.cells["exportTapeCaption"]
                                        ?.value ?? ""}",
                                        () {
                                      controller.addEventToUndo();
                                      controller.gridStateManager
                                          ?.removeCurrentRow();
                                      controller.colorGrid(false);
                                    });*/

                                    break;
                                  case DataGridMenuItem.verifyTime:
                                    controller.checkVerifyTime();
                                    break;
                                  case DataGridMenuItem.clearpaste:
                                    controller.copyRow = null;
                                    break;
                                  case DataGridMenuItem.freezeColumn:
                                    renderContext.stateManager
                                        .toggleFrozenColumn(
                                            renderContext.column,
                                            PlutoColumnFrozen.start);
                                    // renderContext.column.frozen=PlutoColumnFrozen.start;
                                    break;
                                  case DataGridMenuItem.unFreezeColumn:
                                    renderContext.stateManager
                                        .toggleFrozenColumn(
                                            renderContext.column,
                                            PlutoColumnFrozen.none);
                                    // renderContext.column.frozen=PlutoColumnFrozen.none;
                                    break;

                                  case DataGridMenuItem.cut:
                                    // controller.cutCopy(
                                    //     isCut: true, row: renderContext.row);
                                    controller.cutCopy2(
                                      isCut: true,
                                    );
                                    break;
                                  case DataGridMenuItem.copy:
                                    // controller.cutCopy(
                                    //     isCut: false, row: renderContext.row);
                                    controller.cutCopy2(
                                      isCut: false,
                                    );
                                    break;
                                  case DataGridMenuItem.fixedEvent:
                                    controller.fixedEvent(index);
                                    break;
                                  case DataGridMenuItem.rescheduleSpots:
                                    showRescheduleDialog(Get.context);
                                    break;
                                  case DataGridMenuItem.removeMarkError:
                                    controller.btn_markError_Click(index);
                                    break;
                                  case DataGridMenuItem.paste:
                                    // controller.paste(index);
                                    controller.paste3(
                                        rowIndex: index,
                                        fun: () {
                                          controller.colorGrid(false);
                                        });
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
                                // controller.gridStateManager.setCurrentSelectingRowsByRange(from, to)
                                // controller.gridStateManager
                                //     ?.clearCurrentSelecting();
                                controller.isRowFilter.value = true;
                                // print("Index is>>" + onRowMoved.idx.toString());
                                // print("On Print moved" +
                                //     jsonEncode(
                                //         onRowMoved.rows[0].cells.toString()));

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
                      PermissionModel formPermissions =
                          Get.find<MainController>()
                              .permissionList!
                              .lastWhere((element) {
                        return element.appFormName ==
                            Routes.TRANSMISSION_LOG.replaceAll("/", "");
                      });
                      if (formPermissions == null) {
                        return Container();
                      } else {
                        print("Transmission Log...." +
                            jsonEncode(formPermissions.toJson()));
                      }
                      if (controller.tranmissionButtons != null) {
                        return SizedBox(
                          height: 40,
                          child: ButtonBar(
                            alignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            // pa
                            children: [
                              for (var btn in controller.tranmissionButtons!)
                                FormButtonWrapper1(
                                  btnText: btn["name"],
                                  showIcon: false,
                                  width: Get.width / 23,
                                  callback:
                                      (Get.find<TransmissionLogController>()
                                                  .isBackDated &&
                                              btn['name'] == "Save")
                                          ? null
                                          : Utils.btnAccessHandler2(
                                                      btn['name'],
                                                      controller,
                                                      formPermissions) ==
                                                  null
                                              ? null
                                              : () => formHandler(btn['name']),
                                ),
                              IconButton(
                                onPressed: () {
                                  this.controller.btnUp_Click1();
                                },
                                icon: Icon(Icons.arrow_upward),
                                padding: EdgeInsets.symmetric(horizontal: 3.0),
                              ),
                              IconButton(
                                onPressed: () {
                                  this.controller.btnDown_Click1();
                                },
                                icon: Icon(Icons.arrow_downward),
                                padding: EdgeInsets.symmetric(horizontal: 3.0),
                              ),
                              FormButtonWrapper1(
                                btnText: "Aa",
                                width: Get.width / 23,
                                // isEnabled: btn['isDisabled'],
                                callback: () => formHandler("Aa"),
                              ),
                              FormButtonWrapper1(
                                btnText: "CL",
                                showIcon: false,
                                width: Get.width / 23,
                                callback: () => formHandler("CL"),
                              ),
                              FormButtonWrapper1(
                                btnText: "Exit",
                                showIcon: false,
                                width: Get.width / 23,
                                callback: () => formHandler("Exit"),
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
    });
  }

  formHandler(btn) {
    switch (btn) {
      case "Commercials":
        if (!controller.logSaved) {
          LoadingDialog.callInfoMessage("Please save the log first!");
          return;
        }
        controller.getCommercialList(fun: (model) {
          showCommercialDialog(Get.context, model);
        });
        break;
      case "Next Time":
        controller.selectNextProgramClockHour();
        break;
      case "Exit":
        Get.find<HomeController>().postUserGridSetting2(listStateManager: [
          {"gridStateManager": controller.gridStateManager},
          {"gridStateManagerCommercial": controller.gridStateManagerCommercial},
          {"dgvCommercialsStateManager": controller.dgvCommercialsStateManager},
          {"dgvTimeStateManager": controller.dgvTimeStateManager},
          {"tblFastInsert": controller.tblFastInsert},
          {"tblSegement": controller.tblSegement},
        ], formName: "frmTransmissionlog");
        break;
      case "Save":
        controller.btnSave_Click();
        break;
      case "Load":
        controller.pickFile();
        break;
      case "Search":
        controller.search();
        break;
      case "Clear":
        controller.btnClear_Click();
        break;
      case "Updated":
        controller.getUpdateClick();
        break;
      case "Insert":
        controller.getEventListForInsert(function: () {
          // showInsertDialog(Get.context);
          showInsertDialog2();
        });
        break;
      case "Segments":
        // controller.getEventListForInsert(function: () {
        // showSegmentDialog(Get.context);
        showSegmentDialog2(Get.context);
        // });
        break;
      case "Change":
        controller.setChangeTime(function: () {
          showChangeDialog(Get.context);
        });

        break;
      case "TS":
        controller.getBtnClick_TS(fun: () {
          showTransmissionSummaryDialog(Get.context);
        });

        break;
      case "Verify":
        controller.getBtnVerifyClick(fun: () {
          showVerifyDialog(Get.context);
        });
        // showVerifyDialog(Get.context);
        break;
      case "Aa":
        showAaDialog(Get.context);
        break;
      case "Export":
        controller.btnSave_Click();
        controller.btnExportFetchFpc(fun: () {
          showExportDialog(Get.context);
        });

        break;
      case "Undo":
        controller.undoClick();
        break;
      case "CL":
        showCopyLogDialog(Get.context);
        break;
      case "Auto":
        if (controller.selectLocation == null) {
          LoadingDialog.callInfoMessage("Please select location");
        } else if (controller.selectChannel == null) {
          LoadingDialog.callInfoMessage("Please select channel");
        } else {
          LoadingDialog.recordExists(
            "Do you want to auto this log?",
            () {
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
            },
            deleteTitle: "Yes",
            deleteCancel: "No",
          );
        }

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
          height: Get.height * 0.7,
          child: SingleChildScrollView(
            child: SizedBox(
              width: Get.width * 0.8,
              // height: Get.he,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: Get.width * 0.8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        FormButtonWrapper(
                          btnText: "Get Last Saved Log",
                          showIcon: false,
                          callback: () {
                            // Navigator.pop(context);
                            controller.getBtnClick_LastSavedLog();
                          },
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        FormButtonWrapper(
                          btnText: "Show TS",
                          showIcon: false,
                          callback: () {
                            controller.getBtnClick_TS();
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GetBuilder<TransmissionLogController>(
                      id: "tsList",
                      init: controller,
                      builder: (controller) {
                        return SizedBox(
                          // width: 500,
                          width: Get.width * 0.85,
                          height: Get.height * 0.6,
                          child: (controller.tsListData != null &&
                                  (controller.tsListData?.length ?? 0) > 0)
                              ? DataGridFromMap(
                                  hideCode: false,
                                  formatDate: false,
                                  onload: (PlutoGridOnLoadedEvent load) {
                                    load.stateManager.setColumnSizeConfig(
                                        PlutoGridColumnSizeConfig(
                                      resizeMode: PlutoResizeMode.normal,
                                      autoSizeMode: PlutoAutoSizeMode.scale,
                                    ));
                                  },
                                  onRowDoubleTap:
                                      (PlutoGridOnRowDoubleTapEvent? tap) {
                                    // datechange
                                    // hour
                                    controller.dataGridRowFilter(
                                      matchValue: tap
                                              ?.row.cells["hourCode"]?.value
                                              .toString() ??
                                          "",
                                      filterKey: 'datechange',
                                    );
                                  },
                                  mapData: controller.tsListData!)
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
                          // controller.dataGridRowFilter(
                          //   matchValue: value.value ?? "",
                          //   filterKey: 'fpCtime',
                          // );

                          // controller.selectedLocationId.text = value.key!;
                          // controller.selectedLocationName.text = value.value!;
                          // controller.getChannelsBasedOnLocation(value.key!);
                        },
                        "Time",
                        0.12,
                        // isEnable: controller.isEnable.value,
                        selected: controller.selectTimeForCommercial,
                        autoFocus: true,
                        // dialogWidth: 330,
                        dialogHeight: Get.height * .7,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, left: 10),
                        child: FormButtonWrapper(
                          btnText: "Filter",
                          showIcon: false,
                          callback: () {
                            if (controller.selectTimeForCommercial == null) {
                              LoadingDialog.callInfoMessage(
                                  "Please select time");
                              return;
                            }
                            controller.dataGridRowFilterCommercial(
                              matchValue:
                                  controller.selectTimeForCommercial?.value ??
                                      "",
                              filterKey: 'scheduletime',
                            );
                          },
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
                                    controller.gridStateManager?.setCurrentCell(
                                        controller.gridStateManager?.rows[0]
                                            .cells["no"],
                                        0);
                                  },
                                  witdthSpecificColumn: (controller
                                      .userDataSettings?.userSetting
                                      ?.firstWhere(
                                          (element) =>
                                              element.controlName ==
                                              "gridStateManagerCommercial",
                                          orElse: () => UserSetting())
                                      .userSettings),
                                  onRowDoubleTap:
                                      (PlutoGridOnRowDoubleTapEvent? event) {
                                    controller.tblCommercials_CellDoubleClick(
                                        event?.rowIdx ?? 0);
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
    controller.inserSearchModel = null;
    controller.txReplaceTxId_.text = "";
    controller.txReplaceSegment_.text = "";
    controller.replaceDuration.text = "00:00:00:00";
    controller.txReplaceEvent_.text = "";
    controller.fromReplaceInsert_.text = "00:00:00:00";
    controller.toReplaceInsert_.text = "00:00:00:00";
    controller.isMy.value = false;

    return Get.defaultDialog(
      barrierDismissible: false,
      title: "Insert",
      titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      titlePadding: const EdgeInsets.only(top: 10),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      content: SingleChildScrollView(
        child: SizedBox(
          height: Get.height * 0.75,
          child: SingleChildScrollView(
            child: SizedBox(
              width: Get.width * 0.85,
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
                          // dialogWidth: 330,
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
                        child: FormButtonWrapper1(
                          btnText: "Search",
                          showIcon: false,
                          callback: () {
                            if (controller.selectEvent == null) {
                              LoadingDialog.showErrorDialog(
                                  "Please select event");
                            } else {
                              controller.getBtnInsertSearchClick(
                                  isMine: controller.isMy.value,
                                  eventType:
                                      controller.selectEvent?.value ?? "",
                                  txId: controller.txId_.text,
                                  txCaption: controller.txCaption_.text);
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, left: 10),
                        child: FormButtonWrapper1(
                          btnText: "Add",
                          showIcon: false,
                          callback: () {
                            // LoadingDialog.call();
                            // controller.btnFastInsert_Add_Click();
                            LoadingDialog.call();
                            Future.delayed(Duration(seconds: 1), () {
                              controller.btnFastInsert_Add_Click();
                            });
                          },
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
                            ..text = "00:00:00:00",
                          widthRatio: 0.13,
                          isTime: false,
                          isEnable: false,
                          paddingLeft: 0),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GetBuilder<TransmissionLogController>(
                      id: "insertList",
                      init: controller,
                      builder: (controller) {
                        return SizedBox(
                          // width: 500,
                          width: Get.width * 0.8,
                          height: Get.height * 0.47,
                          child: (controller.inserSearchModel != null &&
                                  controller.inserSearchModel
                                          ?.lstListMyEventData !=
                                      null &&
                                  controller
                                          .inserSearchModel
                                          ?.lstListMyEventData
                                          ?.lstListMyEventClips !=
                                      null &&
                                  (controller
                                              .inserSearchModel
                                              ?.lstListMyEventData
                                              ?.lstListMyEventClips
                                              ?.length ??
                                          0) >
                                      0)
                              ? DataGridFromMap(
                                  hideCode: false,
                                  formatDate: false,
                                  // checkRow: true,
                                  showSrNo: false,
                                  mode: PlutoGridMode.normal,
                                  // checkRowKey: "eventtype",
                                  onload: (PlutoGridOnLoadedEvent load) {
                                    controller.tblFastInsert =
                                        load.stateManager;
                                    load.stateManager
                                        .setGridMode(PlutoGridMode.normal);
                                    load.stateManager.setSelectingMode(
                                        PlutoGridSelectingMode.row);
                                    // load.stateManager.setSelecting(true);
                                    load.stateManager.toggleSelectingRow(0);
                                  },
                                  // colorCallback: (renderC) => Colors.red[200]!,
                                  onRowDoubleTap:
                                      (PlutoGridOnRowDoubleTapEvent tap) {
                                    // controller.tblFastInsert?.unCheckedRows;
                                    /* controller.tblFastInsert
                                        ?.setRowChecked(tap.row, true);*/
                                    // controller.tblFastInsert
                                    //     ?.setCurrentCell(tap.cell, tap.rowIdx);
                                    LoadingDialog.call();
                                    Future.delayed(Duration(seconds: 2), () {
                                      controller
                                          .btnFastInsert_Add_Click1(tap.rowIdx);
                                    });
                                  },
                                  colorCallback: (colorData) {
                                    if (controller
                                            .tblFastInsert?.currentRowIdx ==
                                        colorData.rowIdx) {
                                      return Color(0xFFD1C4E9);
                                    } else {
                                      return Colors.white;
                                    }
                                  },
                                  mapData: (controller.inserSearchModel
                                      ?.lstListMyEventData?.lstListMyEventClips!
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
                          width: 0.1,
                          onchanged: (value) {},
                          hintTxt: "TX Id",
                          margin: true,
                          controller: controller.txReplaceTxId_),
                      SizedBox(
                        width: 10,
                      ),
                      InputFields.formField1(
                          width: 0.05,
                          onchanged: (value) {},
                          hintTxt: "",
                          isEnable: false,
                          margin: true,
                          controller: controller.txReplaceSegment_),
                      SizedBox(
                        width: 10,
                      ),
                      InputFields.formFieldNumberMask(
                          hintTxt: "Duration",
                          controller: controller.replaceDuration,
                          widthRatio: 0.1,
                          isTime: true,
                          paddingLeft: 0),
                      SizedBox(
                        width: 10,
                      ),
                      InputFields.formField1(
                          width: 0.05,
                          onchanged: (value) {},
                          hintTxt: "",
                          isEnable: false,
                          margin: true,
                          controller: controller.txReplaceEvent_),
                      SizedBox(width: 5),
                      FittedBox(
                        child: Row(
                          children: [
                            SizedBox(width: 5),
                            Obx(() => Padding(
                                  padding: const EdgeInsets.only(top: 15.0),
                                  child: Checkbox(
                                    value: controller.isAllDayReplace.value,
                                    onChanged: (val) {
                                      controller.isAllDayReplace.value = val!;
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
                          controller: controller.fromReplaceInsert_,
                          widthRatio: 0.1,
                          isTime: true,
                          isEnable: false,
                          paddingLeft: 0),
                      SizedBox(width: 10),
                      /*FormButtonWrapper(
                        btnText: "",
                        showIcon: false,
                        callback: () {
                          controller.fromReplaceInsert_.text = controller.gridStateManager?.currentRow?.cells["transmissionTime"]?.value ?? "";
                          controller.fromReplaceIndexInsert_.text = controller.gridStateManager?.currentRowIdx.toString()??"";
                        },
                      ),*/
                      /*Padding(
                        padding: const EdgeInsets.only(top: 15.0, right: 5),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all(
                                Colors.deepPurple[900],
                              ),
                              alignment: Alignment.center),
                          onPressed: () {
                            controller.fromReplaceInsert_.text = controller
                                    .gridStateManager
                                    ?.currentRow
                                    ?.cells["transmissionTime"]
                                    ?.value ??
                                "";
                            controller.fromReplaceIndexInsert_.text = controller
                                    .gridStateManager?.currentRowIdx
                                    .toString() ??
                                "";
                          },
                          // icon: showIcon ? Icon(iconData, size: 16) : Container(),
                          child: Text("",
                              style: TextStyle(
                                fontSize: SizeDefine.fontSizeButton,
                              ),
                              textAlign: TextAlign.center),
                        ),
                      ),*/
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, right: 5),
                        child: FormButtonWrapper1(
                          btnText: "",
                          showIcon: false,
                          callback: () {
                            controller.fromReplaceInsert_.text = controller
                                    .gridStateManager
                                    ?.currentRow
                                    ?.cells["transmissionTime"]
                                    ?.value ??
                                "";
                            controller.fromReplaceIndexInsert_.text = controller
                                    .gridStateManager?.currentRowIdx
                                    .toString() ??
                                "";
                          },
                        ),
                      ),
                      InputFields.formFieldNumberMask(
                          hintTxt: "To",
                          controller: controller.toReplaceInsert_,
                          widthRatio: 0.1,
                          isTime: true,
                          isEnable: false,
                          paddingLeft: 0),
                      /* Padding(
                        padding:
                            const EdgeInsets.only(top: 15.0, right: 5, left: 5),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all(
                                Colors.deepPurple[900],
                              ),padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(horizontal: 5,vertical: 5)
                              ),
                              alignment: Alignment.center),
                          onPressed: () {
                            controller.toReplaceInsert_.text = controller
                                    .gridStateManager
                                    ?.currentRow
                                    ?.cells["transmissionTime"]
                                    ?.value ??
                                "";
                            controller.toReplaceIndexInsert_.text = controller
                                    .gridStateManager?.currentRowIdx
                                    .toString() ??
                                "";
                          },
                          // icon: showIcon ? Icon(iconData, size: 16) : Container(),
                          child: Text("",
                              style: TextStyle(
                                fontSize: SizeDefine.fontSizeButton,
                              ),
                              textAlign: TextAlign.center),
                        ),
                      ),*/
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 15.0, right: 5, left: 5),
                        child: FormButtonWrapper1(
                          btnText: "",
                          showIcon: false,
                          callback: () {
                            controller.toReplaceInsert_.text = controller
                                    .gridStateManager
                                    ?.currentRow
                                    ?.cells["transmissionTime"]
                                    ?.value ??
                                "";
                            controller.toReplaceIndexInsert_.text = controller
                                    .gridStateManager?.currentRowIdx
                                    .toString() ??
                                "";
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 15),
                        child: FormButtonWrapper1(
                          btnText: "Get Event",
                          showIcon: false,
                          callback: () {
                            controller.btnReplace_GetEvent_Click();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 10, top: 15),
                        child: FormButtonWrapper1(
                          btnText: "Replace",
                          showIcon: false,
                          callback: () {
                            controller.btnReplace_Click();
                          },
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

  showInsertDialog2() {
    controller.initialOffset.value = 2;
    controller.dialogWidget = Material(
      color: Colors.white,
      child: SizedBox(
        width: Get.width * 0.45,
        child: Column(
          children: [
            Container(
              height: 30,
              color: Colors.grey[200],
              child: Stack(
                fit: StackFit.expand,
                // alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Inserts',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      splashRadius: 20,
                      onPressed: () {
                        controller.dialogWidget = null;
                        controller.canDialogShow.value = false;
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: Get.height * 0.84,
              child: SingleChildScrollView(
                child: SizedBox(
                  width: Get.width * 0.45,
                  // height: Get.he,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        runSpacing: 1,
                        spacing: 1,
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
                              // dialogWidth: 330,
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
                                    style: TextStyle(
                                        fontSize: SizeDefine.labelSize1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0, left: 10),
                            child: FormButtonWrapper1(
                              btnText: "Search",
                              showIcon: false,
                              callback: () {
                                if (controller.selectEvent == null) {
                                  LoadingDialog.showErrorDialog(
                                      "Please select event");
                                } else {
                                  controller.getBtnInsertSearchClick(
                                      isMine: controller.isMy.value,
                                      eventType:
                                          controller.selectEvent?.value ?? "",
                                      txId: controller.txId_.text,
                                      txCaption: controller.txCaption_.text);
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0, left: 10),
                            child: FormButtonWrapper1(
                              btnText: "Add",
                              showIcon: false,
                              callback: () {
                                // LoadingDialog.call();
                                // controller.btnFastInsert_Add_Click();
                                LoadingDialog.call();
                                Future.delayed(Duration(seconds: 1), () {
                                  controller.btnFastInsert_Add_Click();
                                });
                              },
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
                                    style: TextStyle(
                                        fontSize: SizeDefine.labelSize1),
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
                                ..text = "00:00:00:00",
                              widthRatio: 0.13,
                              isTime: false,
                              isEnable: false,
                              paddingLeft: 0),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      GetBuilder<TransmissionLogController>(
                          id: "insertList",
                          init: controller,
                          builder: (controller) {
                            return SizedBox(
                              // width: 500,
                              width: Get.width * 0.45,
                              height: Get.height * 0.43,
                              child: (controller.inserSearchModel != null &&
                                      controller.inserSearchModel?.lstListMyEventData !=
                                          null &&
                                      controller
                                              .inserSearchModel
                                              ?.lstListMyEventData
                                              ?.lstListMyEventClips !=
                                          null &&
                                      (controller
                                                  .inserSearchModel
                                                  ?.lstListMyEventData
                                                  ?.lstListMyEventClips
                                                  ?.length ??
                                              0) >
                                          0)
                                  ? DataGridFromMap(
                                      hideCode: false,
                                      formatDate: false,
                                      // checkRow: true,
                                      showSrNo: false,
                                      mode: PlutoGridMode.normal,
                                      // checkRowKey: "eventtype",
                                      onload: (PlutoGridOnLoadedEvent load) {
                                        controller.tblFastInsert =
                                            load.stateManager;
                                        load.stateManager
                                            .setGridMode(PlutoGridMode.normal);
                                        load.stateManager.setSelectingMode(
                                            PlutoGridSelectingMode.row);
                                        // load.stateManager.setSelecting(true);
                                        load.stateManager.toggleSelectingRow(0);
                                      },
                                      witdthSpecificColumn: (controller
                                          .userDataSettings?.userSetting
                                          ?.firstWhere((element) => element.controlName == "tblFastInsert",
                                              orElse: () => UserSetting())
                                          .userSettings),
                                      // colorCallback: (renderC) => Colors.red[200]!,
                                      onRowDoubleTap:
                                          (PlutoGridOnRowDoubleTapEvent tap) {
                                        // controller.tblFastInsert?.unCheckedRows;
                                        /* controller.tblFastInsert
                                            ?.setRowChecked(tap.row, true);*/
                                        // controller.tblFastInsert
                                        //     ?.setCurrentCell(tap.cell, tap.rowIdx);
                                        LoadingDialog.call();
                                        Future.delayed(Duration(seconds: 2),
                                            () {
                                          controller.btnFastInsert_Add_Click1(
                                              tap.rowIdx);
                                        });
                                      },
                                      colorCallback: (colorData) {
                                        if (controller
                                                .tblFastInsert?.currentRowIdx ==
                                            colorData.rowIdx) {
                                          return Color(0xFFD1C4E9);
                                        } else {
                                          return Colors.white;
                                        }
                                      },
                                      mapData: (controller
                                          .inserSearchModel
                                          ?.lstListMyEventData
                                          ?.lstListMyEventClips!
                                          .map((e) => e.toJson())
                                          .toList())!)
                                  // _dataTable3()
                                  : const WarningBox(text: 'Enter Location, Channel & Date to get the Break Definitions'),
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
                      Wrap(
                        children: [
                          InputFields.formField1(
                              width: 0.1,
                              onchanged: (value) {},
                              hintTxt: "TX Id",
                              margin: true,
                              controller: controller.txReplaceTxId_),
                          SizedBox(
                            width: 10,
                          ),
                          InputFields.formField1(
                              width: 0.05,
                              onchanged: (value) {},
                              hintTxt: "",
                              isEnable: false,
                              margin: true,
                              controller: controller.txReplaceSegment_),
                          SizedBox(
                            width: 10,
                          ),
                          InputFields.formFieldNumberMask(
                              hintTxt: "Duration",
                              controller: controller.replaceDuration,
                              widthRatio: 0.1,
                              isTime: true,
                              paddingLeft: 0),
                          SizedBox(
                            width: 10,
                          ),
                          InputFields.formField1(
                              width: 0.05,
                              onchanged: (value) {},
                              hintTxt: "",
                              isEnable: false,
                              margin: true,
                              controller: controller.txReplaceEvent_),
                          SizedBox(width: 5),
                          FittedBox(
                            child: Row(
                              children: [
                                SizedBox(width: 5),
                                Obx(() => Padding(
                                      padding: const EdgeInsets.only(top: 15.0),
                                      child: Checkbox(
                                        value: controller.isAllDayReplace.value,
                                        onChanged: (val) {
                                          controller.isAllDayReplace.value =
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
                                    "All day",
                                    style: TextStyle(
                                        fontSize: SizeDefine.labelSize1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 5),
                          InputFields.formFieldNumberMask(
                              hintTxt: "From",
                              controller: controller.fromReplaceInsert_,
                              widthRatio: 0.1,
                              isTime: true,
                              isEnable: false,
                              paddingLeft: 0),
                          SizedBox(width: 10),
                          /*FormButtonWrapper(
                            btnText: "",
                            showIcon: false,
                            callback: () {
                              controller.fromReplaceInsert_.text = controller.gridStateManager?.currentRow?.cells["transmissionTime"]?.value ?? "";
                              controller.fromReplaceIndexInsert_.text = controller.gridStateManager?.currentRowIdx.toString()??"";
                            },
                          ),*/
                          /*Padding(
                            padding: const EdgeInsets.only(top: 15.0, right: 5),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  overlayColor: MaterialStateProperty.all(
                                    Colors.deepPurple[900],
                                  ),
                                  alignment: Alignment.center),
                              onPressed: () {
                                controller.fromReplaceInsert_.text = controller
                                        .gridStateManager
                                        ?.currentRow
                                        ?.cells["transmissionTime"]
                                        ?.value ??
                                    "";
                                controller.fromReplaceIndexInsert_.text = controller
                                        .gridStateManager?.currentRowIdx
                                        .toString() ??
                                    "";
                              },
                              // icon: showIcon ? Icon(iconData, size: 16) : Container(),
                              child: Text("",
                                  style: TextStyle(
                                    fontSize: SizeDefine.fontSizeButton,
                                  ),
                                  textAlign: TextAlign.center),
                            ),
                          ),*/
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0, right: 5),
                            child: FormButtonWrapper1(
                              btnText: "",
                              showIcon: false,
                              callback: () {
                                controller.fromReplaceInsert_.text = controller
                                        .gridStateManager
                                        ?.currentRow
                                        ?.cells["transmissionTime"]
                                        ?.value ??
                                    "";
                                controller.fromReplaceIndexInsert_.text =
                                    controller.gridStateManager?.currentRowIdx
                                            .toString() ??
                                        "";
                              },
                            ),
                          ),
                          InputFields.formFieldNumberMask(
                              hintTxt: "To",
                              controller: controller.toReplaceInsert_,
                              widthRatio: 0.1,
                              isTime: true,
                              isEnable: false,
                              paddingLeft: 0),
                          /* Padding(
                            padding:
                                const EdgeInsets.only(top: 15.0, right: 5, left: 5),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  overlayColor: MaterialStateProperty.all(
                                    Colors.deepPurple[900],
                                  ),padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(horizontal: 5,vertical: 5)
                                  ),
                                  alignment: Alignment.center),
                              onPressed: () {
                                controller.toReplaceInsert_.text = controller
                                        .gridStateManager
                                        ?.currentRow
                                        ?.cells["transmissionTime"]
                                        ?.value ??
                                    "";
                                controller.toReplaceIndexInsert_.text = controller
                                        .gridStateManager?.currentRowIdx
                                        .toString() ??
                                    "";
                              },
                              // icon: showIcon ? Icon(iconData, size: 16) : Container(),
                              child: Text("",
                                  style: TextStyle(
                                    fontSize: SizeDefine.fontSizeButton,
                                  ),
                                  textAlign: TextAlign.center),
                            ),
                          ),*/
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15.0, right: 5, left: 5),
                            child: FormButtonWrapper1(
                              btnText: "",
                              showIcon: false,
                              callback: () {
                                controller.toReplaceInsert_.text = controller
                                        .gridStateManager
                                        ?.currentRow
                                        ?.cells["transmissionTime"]
                                        ?.value ??
                                    "";
                                controller.toReplaceIndexInsert_.text =
                                    controller.gridStateManager?.currentRowIdx
                                            .toString() ??
                                        "";
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 15),
                            child: FormButtonWrapper1(
                              btnText: "Get Event",
                              showIcon: false,
                              callback: () {
                                controller.btnReplace_GetEvent_Click();
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 15),
                            child: FormButtonWrapper1(
                              btnText: "Replace",
                              showIcon: false,
                              callback: () {
                                controller.btnReplace_Click();
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    controller.canDialogShow.value = true;
  }

  showSegmentDialog(context) {
    controller.listTapeDetailsSegment?.value = [];
    controller.selectTapeSegmentDialog = null;
    controller.segmentList = null;
    controller.selectProgramSegment = null;
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
                            controller.selectProgramSegment = value;
                            // selectedProgramId.text = value?.key ?? "";
                            // selectedProgram.text = value?.value ?? "";
                            // selectProgram = value;
                            // await controller.getDataAfterProgLoad(controller.selectedLocationId.text, controller.selectedChannelId.text, value!.key);
                          },
                          url: ApiFactory
                              .TRANSMISSION_LOG_SEGMENT_PROGRAM_SEARCH(),
                          width: MediaQuery.of(context).size.width * .2,
                          // selectedValue: selectProgram,
                          widthofDialog: 350,
                          dialogHeight: Get.height * .65,
                          parseKeyForKey: "ProgramCode",
                          parseKeyForValue: "ProgramName",
                        ),
                      ),
                      Focus(
                        onFocusChange: (focus) {
                          if (!focus) {
                            controller.getEpisodeLeaveSegment();
                          }
                        },
                        canRequestFocus: false,
                        skipTraversal: true,
                        child: InputFields.numbers(
                          hintTxt: "Episode No",
                          onchanged: (val) {
// controller.getEpisodeLeaveSegment();
                          },
                          controller: controller.txtSegment_epNo..text = "0",
                          isNegativeReq: false,
                          width: 0.12,
                        ),
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
                          controller.listTapeDetailsSegment?.value,
                          (value) {
                            controller.selectTapeSegmentDialog = value;
                            // controller.selectedLocationId.text = value.key!;
                            // controller.selectedLocationName.text = value.value!;
                            // controller.getChannelsBasedOnLocation(value.key!);
                          },
                          "Tape",
                          0.12,
                          // isEnable: controller.isEnable.value,
                          selected: controller.selectTapeSegmentDialog,
                          autoFocus: true,
                          // dialogWidth: 330,
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
                          callback: () {
                            controller.btnSearchSegment();
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0, left: 10),
                        child: FormButtonWrapper(
                          btnText: "Add",
                          showIcon: false,
                          callback: () {
                            // Get.back();
                            controller.btnInsProg_Addsegments_Click();
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GetBuilder<TransmissionLogController>(
                      id: "segmentList",
                      init: controller,
                      builder: (controller) {
                        return SizedBox(
                          // width: 500,
                          width: Get.width * 0.8,
                          height: Get.height * 0.6,
                          child: (controller.segmentList != null)
                              ? DataGridFromMap(
                                  hideCode: false,
                                  formatDate: false,
                                  onload: (PlutoGridOnLoadedEvent load) {
                                    controller.tblSegement = load.stateManager;
                                  },
                                  witdthSpecificColumn: (controller
                                      .userDataSettings?.userSetting
                                      ?.firstWhere(
                                          (element) =>
                                              element.controlName ==
                                              "tblSegement",
                                          orElse: () => UserSetting())
                                      .userSettings),
                                  // colorCallback: (renderC) => Colors.red[200]!,
                                  mapData: (controller.segmentList!))
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

  showSegmentDialog2(context) {
    controller.listTapeDetailsSegment?.value = [];
    controller.selectTapeSegmentDialog = null;
    controller.segmentList = null;
    controller.selectProgramSegment = null;
    controller.initialOffset.value = 2;
    controller.dialogWidget = Material(
      color: Colors.white,
      child: SizedBox(
        width: Get.width * 0.85,
        child: Column(
          children: [
            Container(
              height: 30,
              color: Colors.grey[200],
              child: Stack(
                fit: StackFit.expand,
                // alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Segments',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      splashRadius: 20,
                      onPressed: () {
                        controller.dialogWidget = null;
                        controller.canDialogShow.value = false;
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              child: SizedBox(
                height: Get.height * 0.7,
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: Get.width * 0.8,
                    // height: Get.he,
                    child: FocusTraversalGroup(
                      policy: OrderedTraversalPolicy(),
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
                                    controller.selectProgramSegment = value;
                                    // selectedProgramId.text = value?.key ?? "";
                                    // selectedProgram.text = value?.value ?? "";
                                    // selectProgram = value;
                                    // await controller.getDataAfterProgLoad(controller.selectedLocationId.text, controller.selectedChannelId.text, value!.key);
                                  },
                                  url: ApiFactory
                                      .TRANSMISSION_LOG_SEGMENT_PROGRAM_SEARCH(),
                                  width: MediaQuery.of(context).size.width * .2,
                                  // selectedValue: selectProgram,
                                  widthofDialog: 350,
                                  dialogHeight: Get.height * .65,
                                  parseKeyForKey: "ProgramCode",
                                  parseKeyForValue: "ProgramName",
                                ),
                              ),
                              Focus(
                                onFocusChange: (focus) {
                                  if (!focus) {
                                    controller.getEpisodeLeaveSegment();
                                  }
                                },
                                canRequestFocus: false,
                                skipTraversal: true,
                                child: InputFields.numbers(
                                  hintTxt: "Episode No",
                                  onchanged: (val) {
// controller.getEpisodeLeaveSegment();
                                  },
                                  controller: controller.txtSegment_epNo
                                    ..text = "0",
                                  isNegativeReq: false,
                                  width: 0.12,
                                ),
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
                                  controller.listTapeDetailsSegment?.value,
                                  (value) {
                                    controller.selectTapeSegmentDialog = value;
                                    // controller.selectedLocationId.text = value.key!;
                                    // controller.selectedLocationName.text = value.value!;
                                    // controller.getChannelsBasedOnLocation(value.key!);
                                  },
                                  "Tape",
                                  0.12,
                                  // isEnable: controller.isEnable.value,
                                  selected: controller.selectTapeSegmentDialog,
                                  autoFocus: true,
                                  // dialogWidth: 330,
                                  dialogHeight: Get.height * .7,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 15.0, left: 10),
                                child: FormButtonWrapper(
                                  btnText: "Search",
                                  showIcon: false,
                                  callback: () {
                                    controller.btnSearchSegment();
                                  },
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 15.0, left: 10),
                                child: FormButtonWrapper(
                                  btnText: "Add",
                                  showIcon: false,
                                  callback: () {
                                    // Get.back();
                                    controller.btnInsProg_Addsegments_Click();
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          GetBuilder<TransmissionLogController>(
                              id: "segmentList",
                              init: controller,
                              builder: (controller) {
                                return SizedBox(
                                  // width: 500,
                                  width: Get.width * 0.8,
                                  height: Get.height * 0.6,
                                  child: (controller.segmentList != null)
                                      ? DataGridFromMap(
                                          hideCode: false,
                                          formatDate: false,
                                          onload:
                                              (PlutoGridOnLoadedEvent load) {
                                            controller.tblSegement =
                                                load.stateManager;
                                          },
                                          // colorCallback: (renderC) => Colors.red[200]!,
                                          mapData: (controller.segmentList!))
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
            )
          ],
        ),
      ),
    );
    controller.canDialogShow.value = true;
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
          height: Get.height * 0.37,
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
                      isEnable: false,
                      controller: controller.txId_Change),
                  Obx(() => Padding(
                        padding: EdgeInsets.only(top: 3),
                        child: InputFields.formFieldNumberMask(
                            hintTxt: "Duration",
                            controller: controller.duration_change,
                            widthRatio: 0.12,
                            // isTime: true,
                            isEnable: controller.visibleChangeDuration.value,
                            paddingLeft: 0),
                      )),
                  Obx(() => Padding(
                        padding: EdgeInsets.only(top: 3),
                        child: InputFields.formFieldNumberMask(
                            hintTxt: "OffSet",
                            controller: controller.offset_change,
                            widthRatio: 0.12,
                            isTime: false,
                            isEnable: controller.visibleChangeOffset.value,
                            paddingLeft: 0),
                      )),
                  Obx(() => Padding(
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

  showExportDialog(context) {
    return Get.defaultDialog(
      barrierDismissible: false,
      title: "Export",
      titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      titlePadding: const EdgeInsets.only(top: 10),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      content: SingleChildScrollView(
        child: SizedBox(
          height: Get.height * 0.5,
          child: SingleChildScrollView(
            child: SizedBox(
              width: Get.width * 0.22,
              // height: Get.he,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Obx(
                    () => Padding(
                      padding: EdgeInsets.only(top: 3),
                      child: InputFields.formFieldNumberMask(
                          hintTxt: "Duration",
                          controller: controller.duration_change,
                          widthRatio: 0.2,
                          // isTime: true,
                          isEnable: controller.visibleChangeDuration.value,
                          paddingLeft: 0),
                    ),
                  ),
                  SizedBox(
                    width: Get.width * 0.2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FittedBox(
                          child: Row(
                            children: [
                              SizedBox(width: 5),
                              Obx(() => Padding(
                                    padding: const EdgeInsets.only(top: 15.0),
                                    child: Checkbox(
                                      value: controller.isPartialLog.value,
                                      onChanged: (val) {
                                        controller.isPartialLog.value = val!;
                                      },
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                  )),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 15.0, left: 5),
                                child: Text(
                                  "Partial Log",
                                  style: TextStyle(
                                      fontSize: SizeDefine.labelSize1),
                                ),
                              ),
                            ],
                          ),
                        ),
                        InputFields.formFieldDisable(
                            hintTxt: "", widthRatio: 0.04, value: ''),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: Get.width * 0.2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        DropDownField.formDropDown1WidthMap(
                          controller
                                  .exportFPCTime?.resFPCTime?.lstFPCFromTime ??
                              [],
                          (value) {
                            controller.selectExportFpcFrom = value;
                          },
                          "FPC From",
                          0.095,
                          // isEnable: controller.isEnable.value,
                          selected: controller.selectExportFpcFrom,
                          autoFocus: true,
                          // dialogWidth: 330,
                          dialogHeight: Get.height * .4,
                        ),

                        /// channel
                        DropDownField.formDropDown1WidthMap(
                          controller.exportFPCTime?.resFPCTime?.lstFPCToTime ??
                              [],
                          (value) {
                            controller.selectExportFpcTo = value;
                            controller.getChannelFocusOut();
                          },
                          "FPC To",
                          0.095,
                          // isEnable: controller.isEnable.value,
                          selected: controller.selectExportFpcTo,
                          autoFocus: true,
                          // dialogWidth: 330,
                          dialogHeight: Get.height * .4,
                        ),
                      ],
                    ),
                  ),
                  Obx(
                    () => RadioColumn(
                      items: const [
                        "Excel",
                        "Excel - Old",
                        "Excel - NEWS",
                        "VizRT",
                        "D Series",
                        "ADC -lst",
                        "Grass Valley",
                        "ADC Noida",
                        "Commercial Replace",
                        "Videocon GV",
                        "Playbox",
                        "Eventz (Dubai)",
                        "ITX",
                      ],
                      groupValue: controller.selectExportType.value ?? "",
                      onchange: (val) {
                        print("Response>>>" + val);
                        controller.selectExportType.value = val;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      confirm: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FormButtonWrapper(
            btnText: "Export",
            showIcon: false,
            callback: () {
              controller.btnExportClick(controller.selectExportType.value);
            },
          ),
          SizedBox(
            width: 5,
          ),
          FormButtonWrapper(
            btnText: "Close",
            showIcon: false,
            callback: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
      radius: 10,
    );
  }

  showRescheduleDialog(context) {
    return Get.defaultDialog(
      barrierDismissible: false,
      title: "Reschedule Spots",
      titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      titlePadding: const EdgeInsets.only(top: 10),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      content: SingleChildScrollView(
        child: SizedBox(
          height: Get.height * 0.28,
          child: SingleChildScrollView(
            child: SizedBox(
              width: Get.width * 0.2,
              // height: Get.he,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  InputFields.formFieldDisable(
                      widthRatio: 0.12,
                      // onchanged: (value) {},
                      hintTxt: "Location",
                      margin: true,
                      // padLeft: 0,
                      // isEnable: false,
                      value: controller.selectLocation?.value ?? ""),
                  SizedBox(
                    height: 5,
                  ),
                  InputFields.formFieldDisable(
                      widthRatio: 0.12,
                      // onchanged: (value) {},
                      hintTxt: "Channel",
                      margin: true,
                      // padLeft: 0,
                      // isEnable: false,
                      value: controller.selectChannel?.value ?? ""),
                  SizedBox(
                    height: 5,
                  ),
                  InputFields.formFieldDisable(
                      widthRatio: 0.12,
                      // onchanged: (value) {},
                      hintTxt: "Telecast Date",
                      margin: true,
                      // padLeft: 0,
                      // isEnable: false,
                      value: controller.selectedDate.text),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: DateWithThreeTextField(
                      title: "Reschedule To",
                      splitType: "-",
                      widthRation: 0.12,
                      startDate: DateFormat("dd-MM-yyyy")
                          .parse(controller.selectedDate.text),
                      // isEnable: controller.isEnable.value,
                      mainTextController: controller.txtDate_Reschedule,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      confirm: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FormButtonWrapper(
            btnText: "Close",
            showIcon: false,
            callback: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(
            width: 10,
          ),
          FormButtonWrapper(
            btnText: "Reschedule Spots",
            showIcon: false,
            callback: () {
              controller.btnRescheduleSpots();
              // Navigator.pop(context);
            },
          ),
        ],
      ),
      radius: 10,
    );
  }

  showCopyLogDialog(context) {
    return Get.defaultDialog(
      barrierDismissible: false,
      title: "Copy Log",
      titleStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      titlePadding: const EdgeInsets.only(top: 10),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      content: SingleChildScrollView(
        child: SizedBox(
          height: Get.height * 0.15,
          child: SingleChildScrollView(
            child: SizedBox(
              width: Get.width * 0.18,
              // height: Get.he,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Obx(
                    () => DropDownField.formDropDown1WidthMap(
                      controller.locations.value,
                      (value) {
                        controller.selectLocationCopyLog = value;
                        controller.getChannels(
                            controller.selectLocationCopyLog?.key ?? "");
                      },
                      "Location",
                      0.12,
                      // isEnable: controller.isEnable.value,
                      selected: controller.selectLocationCopyLog,
                      autoFocus: true,
                      // dialogWidth: 330,
                      dialogHeight: Get.height * .4,
                    ),
                  ),

                  /// channel
                  Obx(
                    () => DropDownField.formDropDown1WidthMap(
                      controller.channels.value,
                      (value) {
                        controller.selectChannelCopyLog = value;
                        controller.getChannelFocusOut();
                      },
                      "Channel",
                      0.12,
                      // isEnable: controller.isEnable.value,
                      selected: controller.selectChannelCopyLog,
                      autoFocus: true,
                      // dialogWidth: 330,
                      dialogHeight: Get.height * .4,
                    ),
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
      confirm: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FormButtonWrapper(
            btnText: "Close",
            showIcon: false,
            callback: () {
              Navigator.pop(context);
            },
          ),
          SizedBox(
            width: 10,
          ),
          FormButtonWrapper(
            btnText: "Copy Log",
            showIcon: false,
            callback: () {
              if (controller.selectLocationCopyLog == null) {
                LoadingDialog.callInfoMessage("Please select location");
              } else if (controller.selectLocationCopyLog == null) {
                LoadingDialog.callInfoMessage("Please select channel");
              } else {
                controller.btnCopyLogClick();
              }
            },
          ),
        ],
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
                          callback: () {
                            controller.getBtnVerifyDetailsClick();
                          },
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
                          id: "verifyList",
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
                                      onload: (PlutoGridOnLoadedEvent ev) {
                                        controller.dgvCommercialsStateManager =
                                            ev.stateManager;
                                      },
                                      mode: PlutoGridMode.select,
                                      witdthSpecificColumn: (controller
                                          .userDataSettings?.userSetting
                                          ?.firstWhere(
                                              (element) =>
                                                  element.controlName ==
                                                  "dgvCommercialsStateManager",
                                              orElse: () => UserSetting())
                                          .userSettings),
                                      onSelected:
                                          (PlutoGridOnSelectedEvent onSelect) {
                                        controller
                                            .dgvCommercialsCellDoubleClick(
                                                onSelect.rowIdx!);
                                      },
                                      /*colorCallback: (renderC) =>
                                          Colors.red[200]!,*/
                                      mapData: (controller.verifyListModel
                                          ?.lstCheckTimeBetweenCommercials!
                                          .map((e) => e.toJson())
                                          .toList())!)
                                  // _dataTable3()
                                  : const WarningBox(
                                      text:
                                          'Enter Location, Channel & Date to get the Break Definitions'),
                            );
                          }),
                      GetBuilder<TransmissionLogController>(
                          id: "filterVerifyList",
                          init: controller,
                          builder: (controller) {
                            return SizedBox(
                              // width: 500,
                              width: Get.width * 0.3,
                              height: Get.height * 0.53,
                              child: (controller.listFilterVerify != null &&
                                      ((controller.listFilterVerify?.length ??
                                              0) >
                                          0))
                                  ? DataGridFromMap(
                                      hideCode: false,
                                      showonly: ["transmissionTime"],
                                      formatDate: false,
                                      witdthSpecificColumn: (controller
                                          .userDataSettings?.userSetting
                                          ?.firstWhere(
                                              (element) =>
                                                  element.controlName ==
                                                  "dgvTimeStateManager",
                                              orElse: () => UserSetting())
                                          .userSettings),
                                      onload: (PlutoGridOnLoadedEvent event) {
                                        controller.dgvTimeStateManager =
                                            event.stateManager;
                                      },
                                      showSrNo: false,
                                      mode: PlutoGridMode.select,
                                      onSelected:
                                          (PlutoGridOnSelectedEvent onSelect) {
                                        controller.dgvTimeCellDoubleClick(
                                            onSelect.rowIdx!);
                                      },
                                      mapData: (controller.listFilterVerify
                                          ?.map((e) => e.toJson())
                                          .toList())!)
                                  // _dataTable3()
                                  : Container(
                                      width: Get.width * 0.3,
                                      height: Get.height * 0.53,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey.shade400,
                                          width: 1,
                                        ),
                                      ),
                                    ),
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
                            controller: controller.verifyMinTime,
                            widthRatio: 0.12,
                            isEnable: false,
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
              width: Get.width * 0.7,
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
                        switch (val) {
                          case "Tape":
                            controller.selectAa = "lstTypeTape";
                            break;
                          case "Product":
                            controller.selectAa = "lstTypeProduct";
                            break;
                          case "Brand":
                            controller.selectAa = "lstTypeBrand";
                            break;
                        }
                        // controller.filterAaList();
                        controller.postPivotLog();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GetBuilder<TransmissionLogController>(
                      id: "aAList",
                      init: controller,
                      builder: (controller) {
                        return SizedBox(
                          // width: 500,
                          width: Get.width * 0.7,
                          height: Get.height * 0.5,
                          child: (controller.listVerification != null &&
                                  (controller.listVerification?.length ?? 0) >
                                      0)
                              ? DataGridFromMap(
                                  hideCode: false,
                                  formatDate: false,
                                  // showonly: [
                                  //   controller.selectAa ?? "",
                                  //   "bookingNumber"
                                  // ],
                                  // colorCallback: (renderC) => Colors.red[200]!,
                                  mapData: (controller.listVerification!))
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

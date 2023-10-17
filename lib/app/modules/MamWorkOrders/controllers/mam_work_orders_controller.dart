import 'dart:math';

import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/controller/MainController.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/modules/MamWorkOrders/models/mamworkonloadorder_model.dart';
import 'package:bms_scheduling/app/modules/MamWorkOrders/models/re_push_model.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/DateTime/DateWithThreeTextField1.dart';
import '../../../../widgets/DateTime/TimeWithThreeTextField.dart';
import '../../../../widgets/DateTime/TimeWithThreeTextField1.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../controller/HomeController.dart';
import '../../../data/user_data_settings_model.dart';
import '../../../providers/SizeDefine.dart';
import '../../../providers/Utils.dart';
import '../models/cancel_wo_model.dart';
import '../models/non_fpc_wo_dt.dart';
import '../models/wo_aspdfpc_model.dart';
import '../models/wo_history_model.dart';

class MamWorkOrdersController extends GetxController {
  /// Common Varaibles START
  List<String> mainTabs = [
    "Release WO Non FPC",
    "WO As Per Daily FPC",
    "WO Re-push",
    "Cancel WO",
    "WO History"
  ];
  var selectedTab = "Release WO Non FPC".obs;
  PageController pageController = PageController();
  var onloadData = MAMWORKORDERONLOADMODEL().obs;
  UserDataSettings? userDataSettings;

  // Common Varaibles START
  ///
  ///
  ///
  ///
  ///
  /// Release WO NON FPC Varaibles START
  var nonFPCWOTypeFN = FocusNode();
  bool? bMET;
  PlutoGridStateManager? woNonFPCSM;
  bool nonFPCEnableAll = false;
  var nonFPCChannelList = <DropDownValue>[].obs;
  var nonFPCSelectedRMSProgram = DropDownValue().obs;
  DropDownValue? nonFPCSelectedWorkOrderType,
      nonFPCSelectedLoc,
      nonFPCSelectedChannel,
      nonFPCSelectedBMSProgram,
      nonFPCSelectedTelecasteType;
  bool nonFPCQualityHD = true,
      // nonFPCAutoTC = false,
      nonFPCWOReleaseTXID = false;
  var nonFPCFromEpi = TextEditingController(),
      nonFPCToEpi = TextEditingController(),
      nonFPCEpiSegments = TextEditingController(),
      nonFPCTxID = TextEditingController(),
      nonFPCTelDate = TextEditingController(),
      nonFPCTelTime = TextEditingController(text: "00:00:00");
  var nonFPCDataTableList = <NonFPCWOModel>[].obs;
  var segmentsList = <LstEpisodeDetails>[].obs;

  // Release WO NON FPC Varaibles END
  ///
  ///
  ///
  ///
  ///
  /// WO AS PER DAILY DAILY FPC VARAIBLES START
  PlutoGridStateManager? woAsPerDailyFPCSMFirst, woAsPerDailyFPCSMSecond;
  DropDownValue? woAsPerDailyFPCSelectedWoType,
      woAsPerDailyFPCSelectedLocation,
      woAsPerDailyFPCSelectedChannel;
  var woAsPerDailyFPCChannelList = <DropDownValue>[].obs;
  var woAsPerDailyFPCSaveList = [].obs;
  var woAPDFPCTelecateDateTC = TextEditingController();
  var woAsPerDailyFPCWOTFN = FocusNode();
  var woASPDFPCModel = WOAPDFPCModel().obs;
  var telecasteTypeFN = FocusNode();
  bool canRetriveData = true;
  bool woAsPerDFPCEnableAll = false, woAsPerDFPCSwapToHDSD = true;

  // WO AS PER DAILY DAILY FPC VARAIBLES END
  ///
  ///
  ///
  ///
  ///
  /// WO RE-PUSH varaibles start
  var rePushJsonTC = "".obs;
  var rePushModel = REPushModel().obs;
  bool canEnableRePush = false;
  PlutoGridStateManager? woRepushSM;

  // WO RE-PUSH varaibles end
  ///
  ///
  ///
  ///
  ///
  /// Cancel WO varaibles end

  PlutoGridStateManager? cwoSM;
  DropDownValue? cwoSelectedWOT,
      cWOSelectedWOTLocation,
      cWOSelectedWOTChannel,
      cWOSelectedWOTTelecasteType,
      cWOSelectedWOProgram;
  var cWOChannelList = <DropDownValue>[].obs;
  var cwoDataTableList = <CancelWOModel>[].obs;
  var cWOfromEpiTC = TextEditingController(),
      cWOToEpiTC = TextEditingController(),
      cwoTelDTFrom = TextEditingController(),
      cwoTelDTTo = TextEditingController();
  var cWOtelDate = true.obs;
  bool cwoisEnableAll = false;

  // Cancel WO varaibles end
  ///
  ///
  ///
  ///
  /// WO HISTORY VARAIBLES START
  PlutoGridStateManager? woHistorySM;
  DropDownValue? woHSelectedLocation,
      woHSelectedChannel,
      woHSelectedProgram,
      woHSelectedTelecastType;
  var wHDTList = <WOHistoryModel>[].obs;
  var woHChannelList = <DropDownValue>[].obs;
  var woHFromEpi = TextEditingController(),
      woHToEpi = TextEditingController(),
      woHTelDTFrom = TextEditingController(),
      woHTelDTTo = TextEditingController();
  var woHtelDate = true.obs;

  /// WO HISTORY VARAIBLES END

  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  //////////////////////////////////////// WO HISTORY FUNCTIONALITY START//////////////////////////////////////
  clearWOHistoryPage() async {
    woHistorySM = null;
    woHSelectedLocation = null;
    woHSelectedChannel = null;
    woHSelectedProgram = null;
    woHSelectedTelecastType = null;
    woHFromEpi.clear();
    woHToEpi.clear();
    wHDTList.clear();
    woHtelDate = false.obs;
    woHTelDTFrom.text = getCurrentDateTime;
    woHTelDTTo.text = getCurrentDateTime;
  }

  showDataInWOHistory() {
    if (woHSelectedLocation == null || woHSelectedChannel == null) {
      LoadingDialog.showErrorDialog(
          "Selecting location and channel for history is mandatory");
    } else {
      LoadingDialog.call();
      Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.MAM_WORK_ORDER_WO_HISTORY_SHOW_DATA,
        fun: (resp) {
          closeDialogIfOpen();
          if (resp != null &&
              resp is Map<String, dynamic> &&
              resp['dtShowWorkOrderHistory'] != null &&
              resp['dtShowWorkOrderHistory']['lstShowHistory'] != null) {
            wHDTList.value = (resp['dtShowWorkOrderHistory']['lstShowHistory']
                    as List<dynamic>)
                .map((e) => WOHistoryModel.fromJson(e))
                .toList();
            if (wHDTList.isEmpty) {
              LoadingDialog.showErrorDialog("No data found.");
            }
          } else {
            LoadingDialog.showErrorDialog(resp.toString());
          }
        },
        json: {
          "locationCode": woHSelectedLocation?.key,
          "channelCode": woHSelectedChannel?.key,
          "programCode": woHSelectedProgram?.key,
          "fromEpisodeNo": num.tryParse(woHFromEpi.text),
          "toEpisodeNo": num.tryParse(woHToEpi.text),
          "originalRepeatCode": woHSelectedTelecastType?.key,
          "chkTelDtWOHistory": woHtelDate.value,
          "telecastFromDate": DateFormat("yyyy-MM-dd")
              .format(DateFormat("dd-MM-yyyy").parse(woHTelDTFrom.text)),
          "telecastToDate": DateFormat("yyyy-MM-dd")
              .format(DateFormat("dd-MM-yyyy").parse(woHTelDTTo.text)),
        },
      );
    }
  }

  handleLocationChangedInWOH(DropDownValue? val) {
    woHSelectedLocation = val;
    if (val != null) {
      LoadingDialog.call();
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.MAM_WORK_ORDER_WO_HISTORY_GET_CHANNEL(
              val.key ?? "", Get.find<MainController>().user?.logincode ?? ""),
          fun: (resp) {
            closeDialogIfOpen();
            if (resp != null &&
                resp is Map<String, dynamic> &&
                resp.containsKey("dtLocationWoHistory") &&
                resp['dtLocationWoHistory'] != null) {
              List<dynamic> resp2 =
                  resp['dtLocationWoHistory'] as List<dynamic>;
              woHSelectedChannel = null;
              woHChannelList.clear();
              woHChannelList.addAll(resp2
                  .map((e) => DropDownValue(
                      key: e['channelCode'], value: e['channelName']))
                  .toList());
            } else {
              LoadingDialog.showErrorDialog(resp.toString());
            }
          },
          failed: (resp) {
            closeDialogIfOpen();
            LoadingDialog.showErrorDialog(resp.toString());
          });
    } else {
      LoadingDialog.showErrorDialog("Please select location.");
    }
  }

  //////////////////////////////////////// WO HISTORY FUNCTIONALITY END////////////////////////////////////////
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  //////////////////////////////////////// CANCEL WO FUNCTIONALITY START////////////////////////////////////////
  clearCancelWOPage() async {
    cwoSM = null;
    cwoDataTableList.clear();
    cwoSelectedWOT = null;
    cWOSelectedWOTLocation = null;
    cWOSelectedWOTChannel = null;
    cWOSelectedWOTTelecasteType = null;
    cWOSelectedWOProgram = null;
    cWOtelDate.value = false;
    cwoisEnableAll = false;
    cWOfromEpiTC.clear();
    cWOToEpiTC.clear();
    cwoTelDTFrom.text = getCurrentDateTime;
    cwoTelDTTo.text = getCurrentDateTime;
  }

  handleOnLocChangedInCWO(DropDownValue? val) {
    cWOSelectedWOTLocation = val;
    if (val != null) {
      LoadingDialog.call();
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.MAM_WORK_ORDER_WO_CANCEL_GET_CHANNEL(
              val.key ?? "", Get.find<MainController>().user?.logincode ?? ""),
          fun: (resp) {
            closeDialogIfOpen();
            if (resp != null &&
                resp is Map<String, dynamic> &&
                resp.containsKey("dtLocationWoHistory") &&
                resp['dtLocationWoHistory'] != null) {
              List<dynamic> resp2 =
                  resp['dtLocationWoHistory'] as List<dynamic>;
              cWOSelectedWOTChannel = null;
              cWOChannelList.clear();
              cWOChannelList.addAll(resp2
                  .map((e) => DropDownValue(
                      key: e['channelCode'], value: e['channelName']))
                  .toList());
            } else {
              LoadingDialog.showErrorDialog(resp.toString());
            }
          },
          failed: (resp) {
            closeDialogIfOpen();
            LoadingDialog.showErrorDialog(resp.toString());
          });
    } else {
      LoadingDialog.showErrorDialog("Please select location.");
    }
  }

  showCancelWOData() async {
    if (cwoSelectedWOT == null ||
        cWOSelectedWOTLocation == null ||
        cWOSelectedWOTChannel == null) {
      LoadingDialog.showErrorDialog(
          "Selecting work order type,location and channel for cancellation is mandatory.");
    } else {
      LoadingDialog.call();
      Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.MAM_WORK_ORDER_WO_CANCEL_SHOW_DATA,
        fun: (resp) {
          closeDialogIfOpen();
          if (resp != null &&
              resp is Map<String, dynamic> &&
              resp['program_Response'] != null &&
              resp['program_Response']['lstWoCancel'] != null) {
            cwoDataTableList.clear();
            int i = 0;
            for (var element in resp['program_Response']['lstWoCancel']) {
              element['rownumber'] = i;
              cwoDataTableList.add(CancelWOModel.fromJson(element));
              i++;
            }
            cwoDataTableList.refresh();
            if (cwoDataTableList.isEmpty) {
              LoadingDialog.showErrorDialog("No data found");
            }
          } else {
            LoadingDialog.showErrorDialog(resp.toString());
          }
        },
        json: {
          "workflowId": cwoSelectedWOT?.key,
          "locationCode": cWOSelectedWOTLocation?.key,
          "channelCode": cWOSelectedWOTChannel?.key,
          "programCode": cWOSelectedWOProgram?.key,
          "fromEpisodeNo": num.tryParse(cWOfromEpiTC.text),
          "toEpisodeNo": num.tryParse(cWOToEpiTC.text),
          "originalRepeatCode": cWOSelectedWOTTelecasteType?.key,
          "chkIncludeTelDt": cWOtelDate.value,
          "telecastFromDate": DateFormat('yyyy-MM-dd')
              .format(DateFormat("dd-MM-yyyy").parse(cwoTelDTFrom.text)),
          "telecastToDate": DateFormat('yyyy-MM-dd')
              .format(DateFormat("dd-MM-yyyy").parse(cwoTelDTTo.text)),
        },
      );
    }
  }

  cancelWOData() {
    if (cWOSelectedWOTLocation == null || cWOSelectedWOTChannel == null) {
      LoadingDialog.showErrorDialog(
          "Location, Channel are mandatory to select.");
    } else {
      LoadingDialog.call();
      Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.MAM_WORK_ORDER_WO_CANCEL_CANCEL_DATA,
        fun: (resp) {
          closeDialogIfOpen();
          if (resp != null &&
              resp is Map<String, dynamic> &&
              resp['program_Response'] != null &&
              resp['program_Response']['strMessage'] != null) {
            // for (var element in resp['program_Response']['strMessage']) {
            //   LoadingDialog.callDataSaved(msg: element.toString());
            // }
            showMsgDialogSuccess(resp['program_Response']['strMessage']);
            // LoadingDialog.callDataSaved(msg: resp.toString());
          } else {
            LoadingDialog.showErrorDialog(resp.toString());
          }
        },
        json: {
          "locationCode": cWOSelectedWOTLocation?.key,
          "channelCode": cWOSelectedWOTChannel?.key,
          "LoggedUser": Get.find<MainController>().user?.logincode,
          "lstCancelWo": cwoDataTableList
              .map((element) => element.toJson(fromSave: true))
              .toList()
        },
      );
    }
  }

  // cancelWOViewDataTableDoubleTap(String columnName) {
  //   cwoisEnableAll = !cwoisEnableAll;
  //   cwoDataTableList.value = cwoDataTableList.map((element) {
  //     element.cancelWO = cwoisEnableAll;
  //     return element;
  //   }).toList();
  // }

  cancelWOViewDataTableEdit(PlutoGridOnChangedEvent event) {
    cwoDataTableList[event.rowIdx].cancelWO =
        event.value.toString().toLowerCase() == "true";
  }

  cancelWOViewDataTableDoubleTap(PlutoGridOnRowDoubleTapEvent event) {
    cwoSM?.setCurrentCell(event.cell, event.rowIdx);
    if (cwoSM != null && event.cell.column.field == "woId") {
      int rowNumber = int.tryParse(event.row.cells['rownumber']?.value) ?? -1;
      if (rowNumber != -1) {
        bool val = cwoDataTableList[rowNumber].cancelWO ?? false;
        for (var i = 0; i < (cwoDataTableList.length); i++) {
          if (cwoDataTableList[rowNumber].ep == cwoDataTableList[i].ep) {
            cwoDataTableList[i].cancelWO = !val;
            cwoSM!.changeCellValue(
                cwoSM!.getRowByIdx(i)!.cells['cancelWO']!, (!val).toString(),
                force: true, callOnChangedEvent: false, notify: true);
          }
        }
      }
    }
  }

  //////////////////////////////////////// CANCEL WO FUNCTIONALITY END//////////////////////////////////////////
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  //////////////////////////////////////// WO RE-PUSH FUNCTIONALITY START//////////////////////////////////////////
  clearWORepushPage() async {
    rePushJsonTC.value = "";
    rePushModel.value = REPushModel();
    canEnableRePush = false;
    woRepushSM = null;
  }

  rePushLoadGetData() {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
      api: ApiFactory.MAM_WORK_ORDER_WO_RE_PUSH_GET_DATA,
      fun: (resp) {
        closeDialogIfOpen();
        if (resp != null &&
            resp is Map<String, dynamic> &&
            resp['program_Response']['lstResendWorkOrders'] != null) {
          rePushModel.value = REPushModel.fromJson(resp);
        } else {
          LoadingDialog.showErrorDialog(resp.toString());
        }
      },
      failed: (resp) {
        closeDialogIfOpen();
        LoadingDialog.showErrorDialog(resp.toString());
      },
    );
  }

  handleOnChangedInDTInWORePush(PlutoGridOnChangedEvent event) {
    rePushModel.value.programResponse?.lstResendWorkOrders?[event.rowIdx]
        .resend = event.value.toString().toLowerCase() == "true";
  }

  handleDoubleTabInDTInWORePush(String columnName) {
    canEnableRePush = !canEnableRePush;
    rePushModel.value.programResponse?.lstResendWorkOrders =
        rePushModel.value.programResponse?.lstResendWorkOrders?.map((e) {
      e.resend = canEnableRePush;
      return e;
    }).toList();
    rePushModel.refresh();
  }

  getJSONINWORepush(PlutoGridOnSelectedEvent event) {
    event.rowIdx;
    if (event.rowIdx != null) {
      rePushModel.value.programResponse?.lstResendWorkOrders?[event.rowIdx!];
      LoadingDialog.call();
      Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.MAM_WORK_ORDER_WO_RE_PUSH_GET_JSON,
        fun: (resp) {
          closeDialogIfOpen();
          if (resp != null &&
              resp is Map<String, dynamic> &&
              resp['dtRepush_WorkOrder']['strMessage'] != null) {
            rePushJsonTC.value = resp['dtRepush_WorkOrder']['strMessage'];
          } else {
            LoadingDialog.showErrorDialog(resp.toString());
          }
        },
        json: {
          "rowIndex": event.rowIdx!,
          "columnIndex": 15,
          "lstRepushWorkOrder": rePushModel
              .value.programResponse?.lstResendWorkOrders
              ?.map((e) => e.toJson(fromSave: true))
              .toList(),
        },
      );
    }
  }

  rePushWO() {
    LoadingDialog.call();
    Get.find<ConnectorControl>().POSTMETHOD(
      api: ApiFactory.MAM_WORK_ORDER_WO_RE_PUSH_SAVE_DATA,
      fun: (resp) {
        closeDialogIfOpen();
        if (resp != null &&
            resp is Map<String, dynamic> &&
            resp['dtRepush_WorkOrder']['message'] != null) {
          // showMsgDialogSuccess(resp['dtRepush_WorkOrder']['message']);
          LoadingDialog.callDataSaved(
              msg: resp['dtRepush_WorkOrder']['message'].toString(),
              callback: () {
                clearPage();
              });
        } else {
          LoadingDialog.showErrorDialog(resp.toString());
        }
      },
      json: rePushModel.value.programResponse?.lstResendWorkOrders
          ?.map((e) => e.toJson(fromSave: true))
          .toList(),
    );
  }

  //////////////////////////////////////// WO RE-PUSH NON FPC FUNCTIONALITY END//////////////////////////////////////////
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  //////////////////////////////////////// RELEASE WO NON FPC FUNCTIONALITY START//////////////////////////////////////////
  clearReleaseWONonFPCPage() async {
    segmentsList.value = [];
    woNonFPCSM = null;
    nonFPCSelectedWorkOrderType = null;
    nonFPCSelectedLoc = null;
    nonFPCSelectedChannel = null;
    nonFPCSelectedBMSProgram = null;
    nonFPCSelectedRMSProgram.value = DropDownValue();
    nonFPCSelectedTelecasteType = null;
    nonFPCQualityHD = false;
    // nonFPCAutoTC = false;
    nonFPCWOReleaseTXID = false;
    onloadData.refresh();
    nonFPCChannelList.clear();
    nonFPCFromEpi.clear();
    nonFPCToEpi.clear();
    nonFPCEpiSegments.clear();
    nonFPCTxID.clear();
    nonFPCTelTime.text = "00:00:00";
    nonFPCDataTableList.clear();
    nonFPCTelDate.text = getCurrentDateTime;
  }

  multiPleSegmentsDialog({bool fromBtnClick = false, bool fromSave = false}) {
    if (nonFPCSelectedWorkOrderType == null) {
      LoadingDialog.showErrorDialog("Please select work order type.");
    } else if (nonFPCSelectedLoc == null) {
      LoadingDialog.showErrorDialog("Please select Location.");
    } else if (nonFPCSelectedChannel == null) {
      LoadingDialog.showErrorDialog("Please select Channel.");
    } else if (nonFPCSelectedBMSProgram == null) {
      LoadingDialog.showErrorDialog("Please select BMS program.");
    } else if (nonFPCSelectedRMSProgram.value.key == null) {
      LoadingDialog.showErrorDialog("Please select RMS program.");
    } else if (nonFPCFromEpi.text.isEmpty) {
      LoadingDialog.showErrorDialog("Please enter from episode.");
    } else if (nonFPCToEpi.text.isEmpty) {
      LoadingDialog.showErrorDialog("Please enter to episode.");
    } else if (nonFPCSelectedTelecasteType == null) {
      LoadingDialog.showErrorDialog("Please select Telecast Type");
    } else if (nonFPCEpiSegments.text.isEmpty) {
      LoadingDialog.showErrorDialog("Please enter to episode segs.");
    } else if (nonFPCFromEpi.text == nonFPCToEpi.text) {
      handleReleaseWoNonFpcTelecastTypeOnChanged();
    } else {
      if (nonFPCTxID.text.isEmpty) {
        nonFPCTxID.text = "AUTOID";
      }
      if (nonFPCFromEpi.text == nonFPCToEpi.text) {
        return;
      }

      var isLoading = true;
      var textEditingControllersDate = <TextEditingController>[];
      var textEditingControllersTime = <TextEditingController>[];
      if (!fromBtnClick) {
        segmentsList.value = [];
        try {
          Get.find<ConnectorControl>().GETMETHODCALL(
            api: ApiFactory.MAM_WORK_ORDER_NON_FPC_GETSEGMENTSOn_TELECAST_LEAVE(
              nonFPCWOReleaseTXID,
              nonFPCSelectedBMSProgram?.key ?? '',
              nonFPCSelectedTelecasteType?.key ?? '',
              nonFPCFromEpi.text,
              nonFPCToEpi.text,
              onloadData.value.nMaxEpsGap.toString(),
              nonFPCTxID.text,
              nonFPCEpiSegments.text,
            ),
            fun: (resp) {
              if (resp != null && resp is Map<String, dynamic>) {
                var tempModel =
                    ReleaseWoNonFPCMultipleSegmensModel.fromJson(resp);
                segmentsList.value =
                    tempModel.infoLeaveTelecast?.lstEpisodeDetails ?? [];
                textEditingControllersDate = [];
                textEditingControllersTime = [];
                for (var i = 0;
                    i <
                        (tempModel.infoLeaveTelecast?.lstEpisodeDetails ?? [])
                            .length;
                    i++) {
                  textEditingControllersDate.add(TextEditingController(
                      text: tempModel.infoLeaveTelecast!.lstEpisodeDetails![i]
                          .telecastDate));
                  textEditingControllersTime.add(TextEditingController(
                      text: tempModel.infoLeaveTelecast!.lstEpisodeDetails![i]
                          .telecastTime));
                }
                bMET = tempModel.infoLeaveTelecast?.bMET;
              }
              isLoading = false;
              segmentsList.refresh();
            },
          );
        } catch (e) {
          isLoading = false;
          segmentsList.refresh();
        }
      } else {
        textEditingControllersDate = [];
        textEditingControllersTime = [];
        for (var i = 0; i < (segmentsList).length; i++) {
          textEditingControllersDate
              .add(TextEditingController(text: segmentsList[i].telecastDate));
          textEditingControllersTime
              .add(TextEditingController(text: segmentsList[i].telecastTime));
        }
        isLoading = false;
        segmentsList.refresh();
      }

      if (fromSave) {
        return;
      }

      Get.defaultDialog(
        confirm: FormButton(
          btnText: 'Save Eps info.',
          callback: () {
            Get.back();
          },
        ),
        cancel: FormButton(
          btnText: 'Cancel',
          callback: () {
            Get.back();
          },
        ),
        title: "Multiple Segments",
        content: SizedBox(
          width: Get.width * .55,
          height: Get.height * .6,
          child: Obx(() {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              decoration: segmentsList.value.isEmpty
                  ? BoxDecoration(border: Border.all(color: Colors.grey))
                  : null,
              child: (segmentsList.isEmpty)
                  ? isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : null
                  : DataGridFromMap3(
                      rowHeight: 35,
                      editKeys: ['telecastDate', 'telecastTime'],
                      customWidgetInRenderContext: {
                        "telecastDate":
                            (PlutoColumnRendererContext renderContext) {
                          return DateWithThreeTextField1(
                            title: "",
                            widthRation: .1,
                            isEnable: true,
                            rowIdx: renderContext.rowIdx,
                            mainTextController: textEditingControllersDate[
                                renderContext.rowIdx],
                            stateManager: renderContext.stateManager,
                            hideTitle: true,
                          );
                        },
                        "telecastTime": (renderContext) {
                          return StatefulBuilder(builder: (context, re) {
                            return TimeWithThreeTextField1(
                              title: "",
                              widthRation: .1,
                              isEnable: true,
                              rowIdx: renderContext.rowIdx,
                              mainTextController: textEditingControllersTime[
                                  renderContext.rowIdx],
                              hideTitle: true,
                              stateManager: renderContext.stateManager,
                            );
                          });
                        },
                      },
                      mapData:
                          segmentsList.value.map((e) => e.toJson()).toList(),
                      mode: PlutoGridMode.selectWithOneTap,
                      hideCode: false,
                      columnAutoResize: true,
                      onload: (sm) {
                        // sm.stateManager.setEditing(true);
                        // gridSM = sm.stateManager;
                        // gridSM?.setCurrentCell(
                        //     sm.stateManager
                        //         .getRowByIdx(selectedRowIdx.value)!
                        //         .cells['telecastDate'],
                        //     selectedRowIdx.value);
                        // handleSelectTap(selectedRowIdx.value);
                      },
                      // onSelected: (event) {
                      //   // handleSelectTap(event.rowIdx ?? 0);
                      // },
                      // onRowDoubleTap: (event) {
                      //   // handleSelectTap(event.rowIdx);
                      //   // gridSM?.setCurrentCell(event.cell, event.rowIdx);
                      // },
                    ),
            );
          }),
        ),
      ).then((value) {
        for (var i = 0; i < (segmentsList).length; i++) {
          segmentsList[i].telecastDate = textEditingControllersDate[i].text;
          segmentsList[i].telecastTime = textEditingControllersTime[i].text;
        }
      });
    }
  }

  handleNONFPCLocationChanged(DropDownValue? val) {
    nonFPCSelectedLoc = val;
    if (val != null) {
      LoadingDialog.call();
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.MAM_WORK_ORDER_NON_FPC_LOCATION_LEAVE(val.key),
          fun: (resp) {
            closeDialogIfOpen();
            if (resp != null &&
                resp is Map<String, dynamic> &&
                resp.containsKey("dtChannelList") &&
                resp['dtChannelList'] != null) {
              List<dynamic> resp2 = resp['dtChannelList'] as List<dynamic>;
              nonFPCSelectedChannel = null;
              nonFPCChannelList.clear();
              nonFPCChannelList.addAll(resp2
                  .map((e) => DropDownValue(
                      key: e['channelCode'], value: e['channelName']))
                  .toList());
            } else {
              LoadingDialog.showErrorDialog(resp.toString());
            }
          },
          failed: (resp) {
            closeDialogIfOpen();
            LoadingDialog.showErrorDialog(resp.toString());
          });
    } else {
      LoadingDialog.showErrorDialog("Please select location.");
    }
  }

  handleReleaseWoNonFpcTelecastTypeOnChanged() {
    if (nonFPCTxID.text.trim().isEmpty) {
      nonFPCTxID.text = "AUTOID";
    }
    Get.find<ConnectorControl>().POSTMETHOD(
      api: ApiFactory.MAM_WORK_ORDER_NON_FPC_GETTXID,
      fun: (resp) {
        if (resp != null &&
            resp is Map<String, dynamic> &&
            resp['txId'] != null) {
          nonFPCTxID.text = resp['txId'].toString();
        }
      },
      json: {
        "bmsProgram": nonFPCSelectedBMSProgram?.key,
        "fromEpisodeNumber": nonFPCFromEpi.text,
        "toEpisodeNumber": nonFPCToEpi.text,
        "telecastTypeId": nonFPCSelectedTelecasteType?.key,
        "istxid": nonFPCWOReleaseTXID,
        "txId": nonFPCTxID.text,
        "segmentsPerEps": nonFPCEpiSegments.text,
      },
    );
  }

  handleNONFPCBMSOnChanged(DropDownValue? val) async {
    nonFPCSelectedBMSProgram = val;
    if (nonFPCSelectedWorkOrderType == null) {
      LoadingDialog.showErrorDialog("Please select Work Order Type");
    } else if (nonFPCSelectedLoc == null) {
      LoadingDialog.showErrorDialog("Please select location");
    } else if (nonFPCSelectedChannel == null) {
      LoadingDialog.showErrorDialog("Please select channel");
    } else if (nonFPCSelectedBMSProgram == null) {
      LoadingDialog.showErrorDialog("Please select Program");
    } else {
      try {
        LoadingDialog.call();
        await Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.MAM_WORK_ORDER_NON_FPC_ON_BMS_LEAVE(
              nonFPCSelectedBMSProgram?.key),
          fun: (resp) {
            closeDialogIfOpen();
            if (resp is Map<String, dynamic> &&
                resp.containsKey("dtBMSPrograms") &&
                resp['dtBMSPrograms'] != null &&
                resp['dtBMSPrograms']['lstProgramMaster'] != null) {
              DropDownValue? val;
              try {
                val = DropDownValue(
                  key: (resp['dtBMSPrograms']['lstProgramMaster'][0]
                              ['rmsProgramCode'] ??
                          '')
                      .toString(),
                  value: (resp['dtBMSPrograms']['lstProgramMaster'][0]
                              ['rmsProgramName'] ??
                          '')
                      .toString(),
                );
              } catch (e) {
                print("Exception while binding RMS Programming $e");
                LoadingDialog.showErrorDialog(e.toString());
              }
              if (val != null) {
                nonFPCSelectedRMSProgram.value = val;
                handleNONFPCRMSOnChanged(nonFPCSelectedRMSProgram.value);
              }
            } else {
              LoadingDialog.showErrorDialog(resp.toString());
            }
          },
        );
      } catch (e) {
        closeDialogIfOpen();
        LoadingDialog.showErrorDialog(e.toString());
      }
    }
  }

  Future<void> handleNONFPCRMSOnChanged(DropDownValue? val) async {
    if (val == null || val.key == null || val.key!.isEmpty) {
      LoadingDialog.showErrorDialog("RMS selected value not found");
    } else {
      try {
        LoadingDialog.call();
        await Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.MAM_WORK_ORDER_NON_FPC_GET_DATA,
          fun: (resp) async {
            closeDialogIfOpen();
            if (resp is Map<String, dynamic> &&
                resp['program_Response']['lstProgram'] != null &&
                resp['program_Response']['lstProgram'] is List<dynamic>) {
              nonFPCDataTableList.clear();
              // var list =
              //     (resp['program_Response']['lstProgram'] as List<dynamic>)
              //         .map((e) => NonFPCWOModel.fromJson(e))
              //         .toList();
              // await Future.delayed(Duration(seconds: 1));
              nonFPCDataTableList.addAll(
                  (resp['program_Response']['lstProgram'] as List<dynamic>)
                      .map((e) => NonFPCWOModel.fromJson(e))
                      .toList());
              nonFPCDataTableList.refresh();
              if (nonFPCDataTableList.isEmpty) {
                LoadingDialog.showErrorDialog("Data not found");
              }
            } else {
              LoadingDialog.showErrorDialog(resp.toString());
            }
          },
          json: {
            "workOrderTypeId": nonFPCSelectedWorkOrderType?.key,
            "workOrderTypeName": nonFPCSelectedWorkOrderType?.value,
            "locationCode": nonFPCSelectedLoc?.key,
            "channelCode": nonFPCSelectedChannel?.key,
            "programCode": nonFPCSelectedRMSProgram.value.key,
            "programname": nonFPCSelectedRMSProgram.value.value,
          },
        );
      } catch (e) {
        closeDialogIfOpen();
        LoadingDialog.showErrorDialog(e.toString());
      }
    }
  }

  Future<void> handleOnSaveNonFPCWO() async {
    var from = num.tryParse(nonFPCFromEpi.text) ?? 0; //1
    var to = num.tryParse(nonFPCToEpi.text) ?? 0; //2
    if (nonFPCSelectedWorkOrderType == null) {
      LoadingDialog.showErrorDialog("Please select work order type");
    } else if (nonFPCSelectedLoc == null) {
      LoadingDialog.showErrorDialog("Please select location");
    } else if (nonFPCSelectedChannel == null) {
      LoadingDialog.showErrorDialog("Please select channel");
    } else if (nonFPCSelectedBMSProgram == null) {
      LoadingDialog.showErrorDialog("Please select BMS program");
    } else if (nonFPCSelectedRMSProgram.value.key == null) {
      LoadingDialog.showErrorDialog("Please select RMS program");
    } else if (nonFPCSelectedTelecasteType == null) {
      LoadingDialog.showErrorDialog("Please select telecaste type");
    } else if (nonFPCFromEpi.text.isEmpty ||
        nonFPCToEpi.text.isEmpty ||
        (from > to) ||
        (from == 0 || to == 0)) {
      LoadingDialog.showErrorDialog(
          "Input string was not in a correct format.");
    } else if (from == to && (nonFPCTxID.text.trim().isEmpty)) {
      LoadingDialog.showErrorDialog("Tx id can't be blank.");
    } else if (from == to && nonFPCTelTime.text == "00:00:00") {
      LoadingDialog.showErrorDialog("Telecast Time should not be blank.");
    } else if ((from != to &&
        nonFPCWOReleaseTXID &&
        validateMultipleEpisodeSave())) {
      LoadingDialog.showErrorDialog(
          "While releasing work order with TX Id, TelecastDate and TelecastTime should not be same per Exporttapecode.");
    } else {
      if (from != to &&
          ((to - from) != 0) &&
          (to - from <= (onloadData.value.nMaxEpsGap ?? 0))) {
        bMET = true;
      }

      try {
        LoadingDialog.call();
        await Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.MAM_WORK_ORDER_NON_FPC_SAVE_DATA,
          fun: (resp) async {
            closeDialogIfOpen();
            if (resp != null &&
                resp is Map<String, dynamic> &&
                resp['program_Response'] != null) {
              if (resp['program_Response']['strMessage'] != null) {
                showMsgDialogSuccess2(resp['program_Response']['strMessage'],
                    () {
                  Future.delayed(Duration(milliseconds: 400)).then((value) {
                    multiPleSegmentsDialog(fromSave: true);
                    Future.delayed(const Duration(milliseconds: 800))
                        .then((value) {
                      nonFPCWOReleaseTXID = false;
                      onloadData.refresh();
                    });
                  });
                });
              } else {
                LoadingDialog.showErrorDialog(
                    resp['program_Response']['strMessage'].toString());
              }
            } else {
              LoadingDialog.showErrorDialog(resp.toString());
            }
          },
          json: {
            "chkWithTXId": nonFPCWOReleaseTXID,
            "txId": nonFPCTxID.text.trim(),
            "fromEpisodeNumber": num.tryParse(nonFPCFromEpi.text.trim()),
            "toEpisodeNumber": num.tryParse(nonFPCToEpi.text.trim()),
            "telecastDate": DateFormat("yyyy-MM-dd").format(
                DateFormat('dd-MM-yyyy')
                    .parse(nonFPCTelDate.text)), // dd-MM-yyyy
            "telecastTime": nonFPCTelTime.text, // 00:00:00
            "workflowId": nonFPCSelectedWorkOrderType?.key,
            "LocationName": nonFPCSelectedLoc?.value,
            "ChannelName": nonFPCSelectedChannel?.value,
            "ProgramName": nonFPCSelectedRMSProgram.value.value,
            "locationCode": nonFPCSelectedLoc?.key,
            "channelCode": nonFPCSelectedChannel?.key,
            "programCode": nonFPCSelectedRMSProgram.value.key,
            "originalRepeatCode": nonFPCSelectedTelecasteType?.key,
            "bmsProgramCode": nonFPCSelectedBMSProgram?.key,
            "episodeSegCount": nonFPCEpiSegments.text,
            "exportTapeCode": nonFPCTxID.text.trim(),
            "telecastTypeCode": nonFPCSelectedTelecasteType?.key,
            "loggedUser": Get.find<MainController>().user?.logincode,
            "chkQuality": nonFPCQualityHD,
            "bMET": bMET ?? false,
            // "bMET": !(nonFPCFromEpi.text == nonFPCToEpi.text),
            "lstGetProgram": nonFPCDataTableList
                .map((element) => element.toJson(fromSave: true))
                .toList(),
            "lstEpisodeDetails": segmentsList
                .map((element) => element.toJson(fromSave: true))
                .toList(),
          },
        );
      } catch (e) {
        closeDialogIfOpen();
        LoadingDialog.showErrorDialog(e.toString());
      }
    }
  }

  bool validateMultipleEpisodeSave() {
    bool foundDublicateVal = false;

    for (var i = 0; i < segmentsList.length; i++) {
      for (var j = 0; j < segmentsList.length; j++) {
        if (i < j) {
          if (segmentsList[i].telecastTime == segmentsList[j].telecastTime) {
            foundDublicateVal = true;
            break;
          }
        }
      }
    }

    return foundDublicateVal;
  }

  handleColumTapNonFPCWO(String columnName) {
    nonFPCEnableAll = !nonFPCEnableAll;
    nonFPCDataTableList.value = nonFPCDataTableList.map(
      (element) {
        element.release = nonFPCEnableAll;
        return element;
      },
    ).toList();
  }

  ////////////////////////////////////////// RELEASE WO NON FPC FUNCTIONALITY END//////////////////////////////////////////
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ////////////////////////////////////////// WO AS PER DAILY DAILY FPC FUNCTIONALITY START////////////////////////////////////////

  handleOnAsPerDailyFpcLocationChanged(DropDownValue? val) {
    woAsPerDailyFPCSelectedLocation = val;
    if (val == null) {
      LoadingDialog.showErrorDialog("Please select location");
    } else {
      woAsPerDailyFPCSelectedChannel = null;
      woAsPerDailyFPCChannelList.clear();
      getAsperDailyFPCChannelList();
    }
  }

  onLeaveTelecasteDateInWODFPC(String date) {
    try {
      if (woAsPerDailyFPCSelectedLocation == null ||
          woAsPerDailyFPCSelectedChannel == null ||
          woAsPerDailyFPCSelectedWoType == null) {
        return;
      }
      LoadingDialog.call();
      Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.MAM_WORK_ORDER_WO_ADFPC_GET_DATATABLE_DATA,
        fun: (resp) {
          closeDialogIfOpen();
          if (resp != null &&
              resp is Map<String, dynamic> &&
              resp['program_Response'] != null) {
            woASPDFPCModel.value = WOAPDFPCModel.fromJson(resp);

            if (woASPDFPCModel.value.programResponse?.dailyFpc?.isEmpty ??
                true) {
              LoadingDialog.showErrorDialog("No data found.");
            }
          }
        },
        json: {
          "locationCode": woAsPerDailyFPCSelectedLocation!.key,
          "channelCode": woAsPerDailyFPCSelectedChannel!.key,
          "telecastDate": DateFormat("yyyy-MM-ddT00:00:00").format(
              DateFormat("dd-MM-yyyy").parse(woAPDFPCTelecateDateTC.text)),
          "workFlowId": num.tryParse(woAsPerDailyFPCSelectedWoType?.key ?? "0"),
        },
      );
    } catch (e) {
      closeDialogIfOpen();
      LoadingDialog.showErrorDialog(e.toString());
    }
  }

  saveWOAsPerDailyFPC() async {
    if (woAsPerDailyFPCSelectedWoType == null ||
        woAsPerDailyFPCSelectedLocation == null ||
        woAsPerDailyFPCSelectedChannel == null) {
      LoadingDialog.showErrorDialog(
          "Work order type, Location and Channel selection is mandatory");
    } else {
      LoadingDialog.call();
      Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.MAM_WORK_ORDER_WO_ADFPC_SAVE_DATA,
        fun: (resp) {
          closeDialogIfOpen();
          if (resp != null &&
              resp is Map<String, dynamic> &&
              resp['dtRepush_WorkOrder'] != null) {
            if (resp['dtRepush_WorkOrder']['lstdgvWorkOrderTypeFPC'] != null) {
              woAsPerDailyFPCSaveList.clear();
              for (var element in resp['dtRepush_WorkOrder']
                  ['lstdgvWorkOrderTypeFPC']) {
                woAsPerDailyFPCSaveList.add(element);
              }
              woAsPerDailyFPCSaveList.refresh();
            }
            if (resp['dtRepush_WorkOrder']['message'] != null) {
              var msgList =
                  resp['dtRepush_WorkOrder']['message'] as List<dynamic>;
              showMsgDialog(msgList);
            }
          } else {
            LoadingDialog.showErrorDialog(resp.toString());
          }
        },
        json: {
          "workFlowId": woAsPerDailyFPCSelectedWoType?.key,
          "locationCode": woAsPerDailyFPCSelectedLocation?.key,
          "LocationName": woAsPerDailyFPCSelectedLocation?.value,
          "channelCode": woAsPerDailyFPCSelectedChannel?.key,
          "ChannelName": woAsPerDailyFPCSelectedChannel?.value,
          "loginCode": Get.find<MainController>().user?.logincode,
          "lstdtDailyFpc": woASPDFPCModel.value.programResponse?.dailyFpc
              ?.map((e) => e.toJson(fromSave: true))
              .toList(),
        },
      );
    }
  }

  showMsgDialog(List<dynamic> msgList) {
    if (msgList.length == 1) {
      LoadingDialog.callDataSaved(
          msg: msgList.first,
          callback: () {
            clearPage();
          });
    } else {
      LoadingDialog.showErrorDialog(msgList.first, callback: () {
        msgList.removeAt(0);
        showMsgDialog(msgList);
      });
    }
  }

  showMsgDialogSuccess(List<dynamic> msgList) {
    msgList = msgList.reversed.toList();
    if (msgList.isNotEmpty) {
      LoadingDialog.callDataSaved(
          msg: msgList.last,
          callback: () {
            msgList.removeLast();
            print(msgList.length);
            showMsgDialogSuccess(msgList);
          });
    } else {
      print("showMsgDialogSuccess");
      return;
    }
  }

  showMsgDialogSuccess2(List<dynamic> msgList, Function() callBack) {
    msgList = msgList.reversed.toList();
    if (msgList.isNotEmpty) {
      LoadingDialog.callDataSaved(
          msg: msgList.last,
          callback: () {
            msgList.removeLast();
            if (msgList.isEmpty) {
              callBack();
            }
            showMsgDialogSuccess2(msgList, callBack);
          });
    } else {
      return;
    }
  }

  getAsperDailyFPCChannelList() {
    LoadingDialog.call();
    try {
      Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.MAM_WORK_ORDER_WO_ADFPC_GET_CHANNEL(
            woAsPerDailyFPCSelectedLocation?.key ?? "",
            Get.find<MainController>().user?.logincode ?? ""),
        fun: (resp) {
          closeDialogIfOpen();
          if (resp != null &&
              resp is Map<String, dynamic> &&
              resp['dtLocationFPC'] != null) {
            woAsPerDailyFPCChannelList
                .addAll((resp['dtLocationFPC'] as List<dynamic>)
                    .map(
                      (e) => DropDownValue(
                        key: e['channelCode'],
                        value: e['channelName'],
                      ),
                    )
                    .toList());
          } else {
            LoadingDialog.showErrorDialog(resp.toString());
          }
        },
        failed: (msg) {
          closeDialogIfOpen();
          LoadingDialog.showErrorDialog(msg.toString());
        },
      );
    } catch (e) {
      closeDialogIfOpen();
      LoadingDialog.showErrorDialog(e.toString());
    }
  }

  aPDFPCOnDataTableEdit(PlutoGridOnChangedEvent event) {
    if (event.columnIdx == 1) {
      woASPDFPCModel.value.programResponse?.dailyFpc?[event.rowIdx].release =
          event.value.toString().toLowerCase() == 'true';
    } else {
      woASPDFPCModel.value.programResponse?.dailyFpc?[event.rowIdx].quality =
          event.value.toString();
    }
  }

  aPDFPCOnColumnDoubleTap(String columName) {
    if (columName == 'release') {
      woAsPerDFPCEnableAll = !woAsPerDFPCEnableAll;
    } else if (columName == 'quality') {
      woAsPerDFPCSwapToHDSD = !woAsPerDFPCSwapToHDSD;
    }
    woASPDFPCModel.value.programResponse?.dailyFpc =
        woASPDFPCModel.value.programResponse?.dailyFpc?.map((e) {
              if (columName == 'release') {
                e.release = woAsPerDFPCEnableAll;
              } else if (columName == 'quality') {
                e.quality = woAsPerDFPCSwapToHDSD ? "HD" : "SD";
              }
              return e;
            }).toList() ??
            [];
    woASPDFPCModel.refresh();
  }

  clearWOAsperDailyFPCPage() {
    woAsPerDailyFPCSelectedWoType = null;
    woAsPerDailyFPCSelectedLocation = null;
    woAsPerDailyFPCSelectedChannel = null;
    woASPDFPCModel.value = WOAPDFPCModel();
    woAsPerDFPCEnableAll = false;
    woAsPerDailyFPCSaveList.clear();
    woAPDFPCTelecateDateTC.text = getCurrentDateTime;
    woAsPerDailyFPCSMFirst = null;
    woAsPerDailyFPCSMSecond = null;
  }

  ////////////////////////////////////////// WO AS PER DAILY DAILY FPC FUNCTIONALITY END//////////////////////////////////////////
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  //////////////////////////////// COMMON FUNCTION ON THIS FORM START///////////////////////////////////////////////////

  @override
  void onReady() {
    super.onReady();
    initalizeAPI();
    fetchUserSetting1();

    telecasteTypeFN.onKey = (node, event) {
      if (LogicalKeyboardKey.tab == event.logicalKey) {
        if (!event.isShiftPressed) {
          Future.delayed(Duration(milliseconds: 100)).then((value) {
            if (!canRetriveData) {
              canRetriveData = true;
              multiPleSegmentsDialog();
            }
          });
        }
      }
      return KeyEventResult.ignored;
    };
  }

  fetchUserSetting1() async {
    userDataSettings = await Get.find<HomeController>().fetchUserSetting2();
    if (selectedTab.value == mainTabs[0]) {
      nonFPCDataTableList.refresh();
    } else if (selectedTab.value == mainTabs[1]) {
      woASPDFPCModel.refresh();
      woAsPerDailyFPCSaveList.refresh();
    } else if (selectedTab.value == mainTabs[2]) {
      rePushModel.refresh();
    } else if (selectedTab.value == mainTabs[3]) {
      cwoDataTableList.refresh();
    } else if (selectedTab.value == mainTabs[4]) {
      wHDTList.refresh();
    }
  }

  initalizeAPI() async {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.MAM_WORK_ORDER_INITIALIZE,
        fun: (resp) {
          closeDialogIfOpen();
          try {
            if (resp != null &&
                resp is Map<String, dynamic> &&
                resp['on_Initilasation'] != null) {
              onloadData.value =
                  MAMWORKORDERONLOADMODEL.fromJson(resp['on_Initilasation']);
              nonFPCSelectedWorkOrderType =
                  onloadData.value.lstcboWorkOrderType?.first;
              nonFPCSelectedTelecasteType =
                  onloadData.value.lstcboTelecastType?.first;
              woAsPerDailyFPCSelectedWoType =
                  onloadData.value.lstcboWOTypeFPC?.first;
              cwoSelectedWOT = onloadData.value.lstcboWOTypeCancelWO?.first;
              onloadData.refresh();
            } else {
              LoadingDialog.showErrorDialog("Fail to get initial data");
            }
          } catch (e) {
            LoadingDialog.showErrorDialog(e.toString());
          }
        },
        failed: (resp) {
          closeDialogIfOpen();
          LoadingDialog.showErrorDialog(resp.toString());
        });
  }

  closeDialogIfOpen() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  formHandler(btn) {
    if (btn == "Clear") {
      clearPage();
    } else if (btn == "Exit") {
      Get.find<HomeController>().postUserGridSetting2(listStateManager: [
        {"woNonFPCSM": woNonFPCSM},
        {"woAsPerDailyFPCSMFirst": woAsPerDailyFPCSMFirst},
        {"woAsPerDailyFPCSMSecond": woAsPerDailyFPCSMSecond},
        {"woRepushSM": woRepushSM},
        {"cwoSM": cwoSM},
        {"woHistorySM": woHistorySM},
      ]);
    }
  }

  clearPage() async {
    await clearWOHistoryPage();
    await clearCancelWOPage();
    await clearWORepushPage();
    await clearWOAsperDailyFPCPage();
    await clearReleaseWONonFPCPage();
    selectedTab.value = "Release WO Non FPC";
    onloadData.refresh();
    pageController.animateToPage(0,
        duration: const Duration(milliseconds: 200), curve: Curves.linear);
    nonFPCWOTypeFN.requestFocus();
  }

  String get getCurrentDateTime =>
      "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";

//////////////////////////////// COMMON FUNCTION ON THIS FORM END///////////////////////////////////////////////////
}

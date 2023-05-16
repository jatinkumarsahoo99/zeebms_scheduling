import 'dart:convert';
import 'dart:developer';

import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/controller/MainController.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/modules/MamWorkOrders/models/mamworkonloadorder_model.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MamWorkOrdersController extends GetxController {
  /// Common Varaibles START
  List<String> mainTabs = ["Release WO Non FPC", "WO As Per Daily FPC", "WO Re-push", "Cancel WO", "WO History"];
  var selectedTab = "Release WO Non FPC".obs;
  PageController pageController = PageController();
  var onloadData = MAMWORKORDERONLOADMODEL().obs;
  // Common Varaibles START
  ///
  ///
  ///
  ///
  ///
  /// Release WO NON FPC Varaibles START
  var nonFPCWOTypeFN = FocusNode();
  bool nonFPCEnableAll = false;
  var nonFPCChannelList = <DropDownValue>[].obs;
  var nonFPCSelectedRMSProgram = DropDownValue().obs;
  DropDownValue? nonFPCSelectedWorkOrderType, nonFPCSelectedLoc, nonFPCSelectedChannel, nonFPCSelectedBMSProgram, nonFPCSelectedTelecasteType;
  bool nonFPCQualityHD = true, nonFPCAutoTC = false, nonFPCWOReleaseTXID = false;
  var nonFPCFromEpi = TextEditingController(),
      nonFPCToEpi = TextEditingController(),
      nonFPCEpiSegments = TextEditingController(),
      nonFPCTxID = TextEditingController(),
      nonFPCTelDate = TextEditingController(),
      nonFPCTelTime = TextEditingController(text: "00:00:00");
  var nonFPCDataTableList = [].obs;
  // Release WO NON FPC Varaibles END
  ///
  ///
  ///
  ///
  ///
  /// WO AS PER DAILY DAILY FPC VARAIBLES START
  DropDownValue? woAsPerDailyFPCSelectedWoType, woAsPerDailyFPCSelectedLocation, woAsPerDailyFPCSelectedChannel;
  var woAsPerDailyFPCChannelList = <DropDownValue>[].obs;
  // WO AS PER DAILY DAILY FPC VARAIBLES END
  ///
  ///
  ///
  ///
  ///
  ///

  @override
  void onReady() {
    super.onReady();
    initalizeAPI();
  }

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
  //////////////////////////////////////// RELEASE WO NON FPC FUNCTIONALITY START//////////////////////////////////////////
  clearReleaseWONonFPCPage() {
    nonFPCSelectedWorkOrderType = null;
    nonFPCSelectedLoc = null;
    nonFPCSelectedChannel = null;
    nonFPCSelectedBMSProgram = null;
    nonFPCSelectedRMSProgram.value = DropDownValue();
    nonFPCSelectedTelecasteType = null;
    nonFPCQualityHD = false;
    nonFPCAutoTC = false;
    nonFPCWOReleaseTXID = false;
    onloadData.refresh();
    nonFPCChannelList.clear();
    nonFPCFromEpi.clear();
    nonFPCToEpi.clear();
    nonFPCEpiSegments.clear();
    nonFPCTxID.clear();
    nonFPCTelTime.text = "00:00:00";
    nonFPCDataTableList.clear();
    if (pageController.page == 0) {
      nonFPCWOTypeFN.requestFocus();
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
            if (resp != null && resp is Map<String, dynamic> && resp.containsKey("dtChannelList") && resp['dtChannelList'] != null) {
              List<dynamic> resp2 = resp['dtChannelList'] as List<dynamic>;
              nonFPCSelectedChannel = null;
              nonFPCChannelList.clear();
              nonFPCChannelList.addAll(resp2.map((e) => DropDownValue(key: e['channelCode'], value: e['channelName'])).toList());
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
          api: ApiFactory.MAM_WORK_ORDER_NON_FPC_ON_BMS_LEAVE(nonFPCSelectedBMSProgram?.key),
          fun: (resp) {
            closeDialogIfOpen();
            if (resp is Map<String, dynamic> && resp.containsKey("dtBMSPrograms") && resp['dtBMSPrograms'] != null) {
              nonFPCSelectedRMSProgram.value = DropDownValue(
                key: resp['dtBMSPrograms']['lstProgramMaster'][0]['rmsProgramCode'].toString(),
                value: resp['dtBMSPrograms']['lstProgramMaster'][0]['rmsProgramName'].toString(),
              );
              handleNONFPCRMSOnChanged(nonFPCSelectedRMSProgram.value);
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
          fun: (resp) {
            closeDialogIfOpen();
            if (resp is Map<String, dynamic> &&
                resp['program_Response']['lstProgram'] != null &&
                resp['program_Response']['lstProgram'] is List<dynamic>) {
              nonFPCDataTableList.value = resp['program_Response']['lstProgram'];
              if (nonFPCDataTableList.value.isEmpty) {
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
    } else if (nonFPCFromEpi.text.isEmpty || nonFPCToEpi.text.isEmpty) {
      LoadingDialog.showErrorDialog("Input string was not in a correct format.");
    } else {
      var from = num.tryParse(nonFPCFromEpi.text) ?? 0;
      var to = num.tryParse(nonFPCToEpi.text) ?? 0;
      if (from == 0 && to == 0 || from < to) {
        LoadingDialog.showErrorDialog("From and To Episode No cannot be zero and To Episode No should be greater than From Episode No.");
      } else {
        try {
          LoadingDialog.call();
          await Get.find<ConnectorControl>().POSTMETHOD(
            api: ApiFactory.MAM_WORK_ORDER_NON_FPC_SAVE_DATA,
            fun: (resp) {
              closeDialogIfOpen();
            },
            json: {
              "chkWithTXId": nonFPCWOReleaseTXID,
              "txId": nonFPCTxID.text.trim(),
              "fromEpisodeNumber": num.tryParse(nonFPCFromEpi.text.trim()),
              "toEpisodeNumber": num.tryParse(nonFPCToEpi.text.trim()),
              "telecastDate": "${nonFPCTelDate.text}T00:00:00", // dd-MM-yyyy
              "telecastTime": "2023-01-11T${nonFPCTelTime.text}", // 00:00:00
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
              "loggedUser": Get.find<MainController>().user?.logincode,
              "chkQuality": nonFPCQualityHD,
              "lstGetProgram": nonFPCDataTableList
                  .map((e) => {
                        "release": e['release'] == true ? 1 : 0,
                        "contentTypeId": e['contentTypeId'].toString(),
                        "contentFormatId": e['contentFormatId'].toString(),
                        "vendorCode": e['vendorCode'].toString(),
                        "languageCode": e['languageCode'].toString(),
                        "segmented": e['segmented'] == true ? 1.toString() : 0.toString(),
                        "timeCodeRequired": (e['timeCodeRequired'] ?? false) == true ? 1.toString() : 0.toString(),
                        "requiredApproval": (e['requiredApproval'] ?? false) == true ? 1.toString() : 0.toString(),
                      })
                  .toList()
            },
          );
        } catch (e) {
          closeDialogIfOpen();
          LoadingDialog.showErrorDialog(e.toString());
        }
      }
    }
  }

  handleColumTapNonFPCWO(String columnName) {
    nonFPCEnableAll = !nonFPCEnableAll;
    nonFPCDataTableList.value = nonFPCDataTableList
        .map(
          (element) => element['release'] == nonFPCEnableAll,
        )
        .toList();
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

  getAsperDailyFPCChannelList() {}

  clearWOAsperDailyFPCPage() {
    woAsPerDailyFPCSelectedWoType = null;
    woAsPerDailyFPCSelectedLocation = null;
    woAsPerDailyFPCSelectedChannel = null;
    onloadData.refresh();
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
  ///
  ////////////////////////////////////////// RELEASE WO NON FPC FUNCTIONALITY END//////////////////////////////////////////
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  //////////////////////////////// COMMON FUNCTION ON THIS FORM START///////////////////////////////////////////////////

  initalizeAPI() async {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.MAM_WORK_ORDER_INITIALIZE,
        fun: (resp) {
          closeDialogIfOpen();
          try {
            if (resp != null && resp is Map<String, dynamic> && resp['on_Initilasation'] != null) {
              onloadData.value = MAMWORKORDERONLOADMODEL.fromJson(resp['on_Initilasation']);
              nonFPCSelectedWorkOrderType = onloadData.value.lstcboWorkOrderType?.first;
              nonFPCSelectedTelecasteType = onloadData.value.lstcboTelecastType?.first;
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
    }
  }

  clearPage() {
    clearReleaseWONonFPCPage();
    clearWOAsperDailyFPCPage();
  }

  //////////////////////////////// COMMON FUNCTION ON THIS FORM END///////////////////////////////////////////////////
}

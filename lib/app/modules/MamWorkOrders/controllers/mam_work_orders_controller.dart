import 'dart:convert';
import 'dart:developer';

import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/modules/MamWorkOrders/models/mamworkonloadorder_model.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MamWorkOrdersController extends GetxController {
  List<String> mainTabs = ["Release WO Non FPC", "WO As Per Daily FPC", "WO Re-push", "Cancel WO", "WO History"];
  var selectedTab = "Release WO Non FPC".obs;
  PageController pageController = PageController();
  final count = 0.obs;
  var onloadData = MAMWORKORDERONLOADMODEL().obs;

  /// Release WO NON FPC Varaibles START
  var nonFPCWOTypeFN = FocusNode();
  var nonFPCChannelList = <DropDownValue>[].obs;
  DropDownValue? nonFPCSelectedWorkOrderType,
      nonFPCSelectedLoc,
      nonFPCSelectedChannel,
      nonFPCSelectedBMSProgram,
      nonFPCSelectedRMSProgram,
      nonFPCSelectedTelecasteType;
  bool nonFPCQualityHD = false, nonFPCAutoTC = false, nonFPCWOReleaseTXID = false;

  var nonFPCFromEpi = TextEditingController(),
      nonFPCToEpi = TextEditingController(),
      nonFPCEpiSegments = TextEditingController(),
      nonFPCTxID = TextEditingController(),
      nonFPCTelDate = TextEditingController(),
      nonFPCTelTime = TextEditingController();

  /// Release WO NON FPC Varaibles END
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    initalizeAPI();
  }

  formHandler(btn) {
    if (btn == "Clear") {
      clearPage();
    }
  }

  clearPage() {
    clearReleaseWONonFPCPage();
  }

  //////////////////////////////////////// RELEASE WO NON FPC FUNCTIONALITY START//////////////////////////////////////////
  clearReleaseWONonFPCPage() {
    nonFPCSelectedWorkOrderType = null;
    nonFPCSelectedLoc = null;
    nonFPCSelectedChannel = null;
    nonFPCSelectedBMSProgram = null;
    nonFPCSelectedRMSProgram = null;
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
        await Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.MAM_WORK_ORDER_NON_FPC_GET_DATA,
          fun: (resp) {
            closeDialogIfOpen();
          },
          json: {
            "workOrderTypeId": nonFPCSelectedWorkOrderType?.key,
            "workOrderTypeName": nonFPCSelectedWorkOrderType?.value,
            "locationCode": nonFPCSelectedLoc?.key,
            "channelCode": nonFPCSelectedChannel?.key,
            "programCode": nonFPCSelectedBMSProgram?.key,
            "programname": nonFPCSelectedBMSProgram?.value,
          },
        );
      } catch (e) {
        closeDialogIfOpen();
        LoadingDialog.showErrorDialog(e.toString());
      }
    }
  }

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
  //////////////////////////////// COMMON FUNCTION ON THIS FORM END///////////////////////////////////////////////////
}

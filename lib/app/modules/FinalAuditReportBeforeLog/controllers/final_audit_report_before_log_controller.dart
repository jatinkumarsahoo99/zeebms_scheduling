import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:flutter/material.dart' show TextEditingController, FocusNode;
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/PlutoGrid/src/manager/pluto_grid_state_manager.dart';
import '../../../controller/HomeController.dart';
import '../../../data/PermissionModel.dart';
import '../../../data/user_data_settings_model.dart';
import '../../../providers/ExportData.dart';
import '../../../providers/Utils.dart';
import '../../../routes/app_pages.dart';

class FinalAuditReportBeforeLogController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    initialAPI();
    fetchUserSetting1();
  }

  UserDataSettings? userDataSettings;

  fetchUserSetting1() async {
    userDataSettings = await Get.find<HomeController>().fetchUserSetting2();
    dataTBList.refresh();
  }

  DropDownValue? selectedLocation, selectedChannel;
  List<PermissionModel>? formPermissions;
  var efficitveDateTC = TextEditingController(),
      startTimeTC = TextEditingController();
  var dataTBList = <dynamic>[].obs;
  var locationList = <DropDownValue>[].obs, channelList = <DropDownValue>[].obs;
  var locationFN = FocusNode();
  var standByLog = false.obs;

  convertToExcelAndSave() {
    if (selectedLocation == null) {
      LoadingDialog.showErrorDialog("Please select Location");
    } else if (selectedChannel == null) {
      LoadingDialog.showErrorDialog("Please select Channel");
    } else if (dataTBList.value.isEmpty) {
      LoadingDialog.showErrorDialog("No Records Found");
    } else {
      // ASIA_ZEE TV_05_Jul_2023_FAR.xls
      ExportData().exportExcelFromJsonList(dataTBList.value,
          "${selectedLocation?.value}_${selectedChannel?.value}_${DateFormat("dd_MMM_yyyy").format(DateFormat("dd-MM-yyyy").parse(efficitveDateTC.text))}_FAR");
    }
  }

  @override
  void onInit() {
    formPermissions = Utils.fetchPermissions1(
        Routes.FINAL_AUDIT_REPORT_BEFORE_LOG.replaceAll("/", ""));
    super.onInit();
  }

  initialAPI() {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
      api: ApiFactory.FINAL_REPORT_BT_INITAIL,
      fun: (resp) {
        closeDialog();
        if (resp != null &&
            resp is Map<String, dynamic> &&
            resp['pageload'] != null &&
            resp['pageload']['lstlocation'] != null) {
          locationList.clear();
          locationList.addAll((resp['pageload']['lstlocation'] as List<dynamic>)
              .map((e) => DropDownValue.fromJson({
                    "key": e['locationCode'].toString(),
                    "value": e["locationName"].toString(),
                  }))
              .toList());
        }
      },
      failed: (resp) {
        closeDialog();
      },
    );
  }

  getChannels(DropDownValue? val) {
    if (val == null) {
      LoadingDialog.showErrorDialog("Please select location.");
      return;
    }
    selectedLocation = val;
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
      api: ApiFactory.FINAL_REPORT_BT_GET_CHANNELS(selectedLocation!.key!),
      fun: (resp) {
        closeDialog();
        if (resp != null &&
            resp is Map<String, dynamic> &&
            resp['channels'] != null) {
          channelList.clear();
          channelList.addAll((resp['channels'] as List<dynamic>)
              .map((e) => DropDownValue.fromJson({
                    "key": e['channelCode'].toString(),
                    "value": e["channelName"].toString(),
                  }))
              .toList());
        }
      },
      failed: (resp) {
        closeDialog();
      },
    );
  }

  closeDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  handleReportTap() {
    if (selectedLocation == null || selectedChannel == null) {
      LoadingDialog.showErrorDialog("Please select Location,channel.");
    } else {
      LoadingDialog.call();
      Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.FINAL_REPORT_BT_GET_DATA,
          fun: (resp) {
            closeDialog();
            if (resp != null &&
                resp is Map<String, dynamic> &&
                resp['genrateclick'] != null &&
                (resp['genrateclick'] is List<dynamic>)) {
              dataTBList.clear();
              dataTBList.addAll((resp['genrateclick'] as List<dynamic>));
              if (dataTBList.isEmpty) {
                LoadingDialog.showErrorDialog("No data found.");
              }
            } else {
              LoadingDialog.showErrorDialog(resp.toString());
            }
          },
          json: {
            "locationcode": selectedLocation?.key,
            "channelcode": selectedChannel?.key,
            "standbyLog": standByLog.value ? 1 : 0,
            "telecastdate": DateFormat("yyyy-MM-dd").format(
                DateFormat("dd-MM-yyyy")
                    .parse(efficitveDateTC.text)), //"2023-03-03"
            // "todate": DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy").parse(toTC.text)),
            // "flag": "S",
          });
    }
  }

  clearPage() {
    selectedLocation = null;
    selectedChannel = null;
    dataTBList.clear();
    locationList.refresh();
    channelList.refresh();
    standByLog.value = false;
    startTimeTC.text = "00:00:00";
    efficitveDateTC.clear();
    locationFN.requestFocus();
    stateManager = null;
  }

  PlutoGridStateManager? stateManager;

  formHandler(btn) {
    if (btn == "Save") {
      convertToExcelAndSave();
    } else if (btn == "Clear") {
      clearPage();
    } else if (btn == "Exit") {
      Get.find<HomeController>().postUserGridSetting2(listStateManager: [
        {"stateManager": stateManager},
      ]);
    }
  }
}

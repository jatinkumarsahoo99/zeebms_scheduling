import 'package:bms_scheduling/app/controller/MainController.dart';
import 'package:bms_scheduling/app/data/PermissionModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/LoadingDialog.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../data/DropDownValue.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/Utils.dart';
import '../../../routes/app_pages.dart';
import '../model/manage_channel_inventory_model.dart';

class ManageChannelInvemtoryController extends GetxController {
  var effectiveDateTC = TextEditingController(), weekDaysTC = TextEditingController();
  var locationList = <DropDownValue>[].obs, channelList = <DropDownValue>[].obs;
  DropDownValue? selectedLocation, selectedChannel, selectedProgram;
  var locationFN = FocusNode();
  List<PermissionModel>? formPermissions;
  var dataTableList = <ManageChannelInventory>[].obs;
  var count = 0.obs;
  var bottomControllsEnable = true.obs;
  // var toDateFN = FocusNode();
  var buttonsList = ["Default", "Save Today", "Save All Days", "Special"];
  var programs = <DropDownValue>[].obs;

  @override
  void onInit() {
    formPermissions = Utils.fetchPermissions1(Routes.MANAGE_CHANNEL_INVENTORY.replaceAll("/", ""));
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    getOnLoadData();
  }

  saveSpecial(String fromDate, String toDate, String fromTime, String toTime, List<bool> weekdays, String updateType, int tempCount) {
    if (fromDate == toDate) {
      LoadingDialog.showErrorDialog("Special to Date cannot be less than Special From Date.");
    }
    //  else if ((Utils.convertToSecond(value: toTime) - Utils.convertToSecond(value: fromTime)) <= 0) {
    //   LoadingDialog.showErrorDialog("Please enter Duration.");
    // }
    else if (tempCount <= 0) {
      LoadingDialog.showErrorDialog("Please enter Duration.");
    }
    // else if (selectedProgram == null) {
    //   LoadingDialog.showErrorDialog("Please select Program.");
    // }
    else if (updateType.isEmpty) {
      LoadingDialog.showErrorDialog("Select Default or Add or Fixed for update.");
    } else {
      int upType = 1;
      if (updateType == "Default") {
        upType = 1;
      } else if (updateType == "Add") {
        upType = 2;
      } else if (updateType == "Fixed") {
        upType = 3;
      }
      LoadingDialog.call();
      Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.MANAGE_CHANNEL_INV_SAVE_SPECIAL,
        fun: (resp) {
          Get.back();
          if (resp != null && resp is Map<String, dynamic> && resp['isError'] != null && !(resp['isError'] as bool)) {
            LoadingDialog.callDataSaved(
              msg: resp['genericMessage'].toString(),
              callback: () {
                Get.back();
                Get.back();
                closeDialogIfOpen();
                handleGenerateButton();
              },
            );
          } else {
            LoadingDialog.showErrorDialog(resp.toString());
          }
        },
        json: {
          "updateType": upType,
          "locationcode": selectedLocation?.key ?? "",
          "channelcode": selectedChannel?.key ?? "",
          "duration": tempCount,
          "fromDate": DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy").parse(fromDate)),
          "toDate": DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy").parse(toDate)),
          "fromTime": fromTime,
          "toTime": toTime,
          "programCode": selectedProgram?.key ?? "",
          "sun": weekdays[1] ? 1 : 0,
          "mon": weekdays[2] ? 1 : 0,
          "tue": weekdays[3] ? 1 : 0,
          "wed": weekdays[4] ? 1 : 0,
          "thu": weekdays[5] ? 1 : 0,
          "fri": weekdays[6] ? 1 : 0,
          "sat": weekdays[7] ? 1 : 0,
        },
      );
    }
  }

  getPrograms(String from, String to, String weekDays) {
    LoadingDialog.call();
    Get.find<ConnectorControl>().POSTMETHOD(
      api: ApiFactory.MANAGE_CHANNEL_INV_PROGRAM_SEARCH,
      fun: (resp) {
        closeDialogIfOpen();
        if (resp != null && resp is List<dynamic>) {
          programs.clear();
          programs.addAll((resp).map((e) => DropDownValue(key: e['programcode'].toString(), value: e['programname'].toString())).toList());
        }
      },
      json: {
        "locationcode": selectedLocation?.key,
        "channelcode": selectedChannel?.key,
        "fromDate": DateFormat("dd-MMM-yyyy").format(DateFormat("dd-MM-yyyy").parse(from)),
        "toDate": DateFormat("dd-MMM-yyyy").format(DateFormat("dd-MM-yyyy").parse(to)),
        "daysInCommaSep": weekDays,
      },
    );
  }

  handleOnDefaultClick() {
    if (count.value <= 0) {
      LoadingDialog.showErrorDialog("Enter commercial duration.");
    } else if (dataTableList.isNotEmpty) {
      for (var i = 0; i < dataTableList.length; i++) {
        if (dataTableList[i].episodeDuration != null) {
          dataTableList[i].commDuration = (dataTableList[i].episodeDuration ?? 0) * count.value / 30;
        }
      }
      dataTableList.refresh();
    }
  }

  void saveTodayAndAllData(bool fromSaveToday) {
    if (selectedLocation == null || selectedChannel == null) {
      LoadingDialog.showErrorDialog("Please select Location,Channel.");
    } else if (dataTableList.isEmpty) {
      LoadingDialog.showErrorDialog("No changes to save");
    } else {
      LoadingDialog.call();
      Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.MANAGE_CHANNEL_INV_SAVE_TODAY_ALL_DATA,
        fun: (resp) {
          closeDialogIfOpen();
          LoadingDialog.callDataSaved(msg: resp.toString());
          if (resp != null && resp is Map<String, dynamic> && resp['isError'] != null && !(resp['isError'] as bool)) {
            LoadingDialog.callDataSaved(
              msg: resp['genericMessage'].toString(),
              callback: () {
                Get.back();
                closeDialogIfOpen();
                handleGenerateButton();
              },
            );
          } else {
            LoadingDialog.showErrorDialog(resp.toString());
          }
        },
        json: {
          "locationCode": selectedLocation?.key,
          "channelCode": selectedChannel?.key,
          "effectiveDate": DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy").parse(effectiveDateTC.text)),
          "loginCode": Get.find<MainController>().user?.logincode ?? "",
          "allDays": fromSaveToday ? "N" : "Y",
          "saveTodayDataRequest": dataTableList.value.map((e) => e.toJson(fromSave: true)).toList(),
        },
      );
    }
  }

  clearPage() {
    selectedProgram = null;
    dataTableList.clear();
    effectiveDateTC.clear();
    weekDaysTC.clear();
    selectedLocation = null;
    selectedChannel = null;
    locationList.refresh();
    channelList.refresh();
    locationFN.requestFocus();
    programs.clear();
    count.value = 0;
  }

  handleOnChangedLocation(DropDownValue? val) {
    selectedLocation = val;
    if (val != null) {
      closeDialogIfOpen();
      LoadingDialog.call();
      Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.MANAGE_CHANNEL_INV_LEAVE_LOCATION(val.key.toString(), Get.find<MainController>().user?.logincode ?? ""),
        fun: (resp) {
          closeDialogIfOpen();
          if (resp != null && resp is List<dynamic>) {
            channelList.clear();
            selectedChannel = null;
            channelList.addAll((resp)
                .map((e) => DropDownValue(
                      key: e['channelCode'].toString(),
                      value: e['channelName'].toString(),
                    ))
                .toList());
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
  }

  getOnLoadData() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.MANAGE_CHANNEL_INV_ON_LOAD,
        fun: (resp) {
          closeDialogIfOpen();
          if (resp != null && resp is List<dynamic>) {
            locationList.value.addAll((resp)
                .map((e) => DropDownValue(
                      key: e['locationCode'].toString(),
                      value: e['locationName'].toString(),
                    ))
                .toList());
            if (locationList.isNotEmpty) {
              selectedLocation = locationList.first;
              locationList.refresh();
            }
          } else {
            LoadingDialog.showErrorDialog(resp.toString());
          }
        },
        failed: (resp) {
          closeDialogIfOpen();
          LoadingDialog.showErrorDialog(resp.toString());
        });
  }

  void handleGenerateButton() {
    if (selectedLocation == null || selectedChannel == null) {
      LoadingDialog.showErrorDialog("select location and channel first.");
    } else {
      LoadingDialog.call();
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.MANAGE_CHANNEL_INV_DISPLAY_DATA(selectedLocation?.key ?? "", selectedChannel?.key ?? "",
              DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy").parse(effectiveDateTC.text))),
          fun: (resp) {
            closeDialogIfOpen();
            if (resp != null && resp is List<dynamic>) {
              dataTableList.clear();
              dataTableList.addAll((resp).map((e) => ManageChannelInventory.fromJson(e)).toList());
            } else {
              LoadingDialog.showErrorDialog(resp.toString());
            }
          },
          failed: (resp) {
            closeDialogIfOpen();
            LoadingDialog.showErrorDialog(resp.toString());
          });
    }
  }

  closeDialogIfOpen() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  formHandler(btn) {
    if (btn == "Clear") {
      clearPage();
    } else if (btn == "Save") {}
  }
}

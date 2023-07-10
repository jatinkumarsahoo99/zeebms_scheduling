import 'package:bms_scheduling/app/data/PermissionModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/DropDownValue.dart';
import '../../../providers/Utils.dart';
import '../../../routes/app_pages.dart';

class CommercialTimeUpdateController extends GetxController {
  var effectiveDateTC = TextEditingController(), weekDaysTC = TextEditingController();
  var locationList = <DropDownValue>[].obs, channelList = <DropDownValue>[].obs;
  DropDownValue? selectedLocation, selectedChannel;
  var locationFN = FocusNode();
  List<PermissionModel>? formPermissions;
  var dataTableList = [].obs;
  var buttonsList = ["Default", "Save Today", "Save All Days", "Special"];
  var weekDaysList = ["Default", "Save Today", "Save All Days", "Special"];

  @override
  void onInit() {
    formPermissions = Utils.fetchPermissions1(Routes.COMMERCIAL_TIME_UPDATE.replaceAll("/", ""));
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  clearPage() {
    dataTableList.clear();
    effectiveDateTC.clear();
    weekDaysTC.clear();
    selectedLocation = null;
    selectedChannel = null;
    locationList.refresh();
    channelList.refresh();
    locationFN.requestFocus();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void handleGenerateButton() {}

  formHandler(btn) {}
}

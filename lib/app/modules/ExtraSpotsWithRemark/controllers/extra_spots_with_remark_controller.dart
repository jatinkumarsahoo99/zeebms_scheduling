import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/PermissionModel.dart';
import '../../../providers/Utils.dart';
import '../../../routes/app_pages.dart';

class ExtraSpotsWithRemarkController extends GetxController {
  var fromDateTC = TextEditingController(), toDateTC = TextEditingController();
  var locationList = <DropDownValue>[].obs, channelList = <DropDownValue>[].obs;
  DropDownValue? selectedLocation, selectedChannel;
  var locationFN = FocusNode();
  List<PermissionModel>? formPermissions;
  var dataTableList = [].obs;

  @override
  void onInit() {
    formPermissions = Utils.fetchPermissions1(Routes.EXTRA_SPOTS_WITH_REMARK.replaceAll("/", ""));
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  clearPage() {
    dataTableList.clear();
    fromDateTC.clear();
    toDateTC.clear();
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

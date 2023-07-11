import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/DropDownValue.dart';
import '../../../data/PermissionModel.dart';
import '../../../providers/Utils.dart';
import '../../../routes/app_pages.dart';

class LanguageMasterController extends GetxController {
  List<PermissionModel>? formPermissions;
  var fromDateTC = TextEditingController(), toDateTC = TextEditingController();

  var dataTableList = [].obs;
  var locationList = <DropDownValue>[].obs;
  DropDownValue? selectedLocation, selectedChannel;
  var locationFN = FocusNode();
  var channelList = <DropDownValue>[].obs;

  @override
  void onInit() {
    formPermissions = Utils.fetchPermissions1(Routes.LANGUAGE_MASTER.replaceAll("/", ""));
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  formHandler(btn) {}
}

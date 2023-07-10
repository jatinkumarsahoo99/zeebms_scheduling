import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/DropDownValue.dart';
import '../../../data/PermissionModel.dart';
import '../../../providers/Utils.dart';
import '../../../routes/app_pages.dart';
import '../../SalesAuditNotTelecastReport/ChannelListModel.dart';

class InventoryStatusReportController extends GetxController {
  List<PermissionModel>? formPermissions;
  var fromDateTC = TextEditingController(), toDateTC = TextEditingController();

  var dataTableList = [].obs;
  var locationList = <DropDownValue>[].obs;
  DropDownValue? selectedLocation, selectedChannel;
  var locationFN = FocusNode();
  var channelList = <ChannelListModel>[].obs;

  @override
  void onInit() {
    formPermissions = Utils.fetchPermissions1(Routes.INVENTORY_STATUS_REPORT.replaceAll("/", ""));
    channelList.add(
      ChannelListModel(
        ischecked: true,
        channelName: "one",
      ),
    );
    channelList.add(
      ChannelListModel(
        ischecked: true,
        channelName: "two",
      ),
    );
    channelList.add(
      ChannelListModel(
        ischecked: true,
        channelName: "three",
      ),
    );
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

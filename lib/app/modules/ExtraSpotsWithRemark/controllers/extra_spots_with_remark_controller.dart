import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/LoadingDialog.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../controller/HomeController.dart';
import '../../../data/PermissionModel.dart';
import '../../../providers/ApiFactory.dart';
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
    formPermissions = Utils.fetchPermissions1(
        Routes.EXTRA_SPOTS_WITH_REMARK.replaceAll("/", ""));
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    getInitialData();
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

  // clearAll() {
  //   Get.delete<ExtraSpotsWithRemarkController>();
  //   Get.find<HomeController>().clearPage1();
  // }

  void handleGenerateButton() {
    if (selectedLocation == null || selectedChannel == null) {
      LoadingDialog.showErrorDialog("Please select Location,Channel.");
    } else {
      LoadingDialog.call();
      Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.EXTRA_SPOT_WITH_REVIEW_REPORT_GENERATE(
          selectedLocation!.key,
          selectedChannel!.key,
          DateFormat("yyyy-MM-ddT00:00:00")
              .format(DateFormat("dd-MM-yyyy").parse(fromDateTC.text)),
          DateFormat("yyyy-MM-ddT00:00:00")
              .format(DateFormat("dd-MM-yyyy").parse(toDateTC.text)),
        ),
        fun: (resp) {
          closeDialogIfOpen();
          if (resp != null &&
              resp is Map<String, dynamic> &&
              resp['extraSpotsReport'] != null) {
            dataTableList.clear();
            dataTableList.addAll((resp['extraSpotsReport']));
          } else {
            LoadingDialog.showErrorDialog(resp.toString());
          }
        },
      );
    }
  }

  formHandler(btn) {
    if (btn == "Clear") {
      clearPage();
    }
  }

  void getInitialData() {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
      api: ApiFactory.EXTRA_SPOT_WITH_REVIEW_ON_LOAD,
      fun: (resp) {
        closeDialogIfOpen();
        if (resp != null && resp is Map<String, dynamic>) {
          if (resp['extraSpotsPageLoad']['location'] != null) {
            locationList.clear();
            locationList.addAll(
                (resp['extraSpotsPageLoad']['location'] as List<dynamic>)
                    .map((e) => DropDownValue(
                          key: e['locationCode'].toString(),
                          value: e['locationName'].toString(),
                        ))
                    .toList());
            // if (locationList.isNotEmpty) {
            //   selectedLocation = locationList.first;
            //   locationList.refresh();
            // }
            channelList.clear();
            channelList
                .addAll((resp['extraSpotsPageLoad']['channel'] as List<dynamic>)
                    .map((e) => DropDownValue(
                          key: e['channelCode'].toString(),
                          value: e['channelName'].toString(),
                        ))
                    .toList());
          }
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

  closeDialogIfOpen() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}

// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/LoadingDialog.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../data/DropDownValue.dart';
import '../../../data/PermissionModel.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/Utils.dart';
import '../../../routes/app_pages.dart';

class SalesAuditExtraSpotsReportController extends GetxController {
  List<PermissionModel>? formPermissions;
  var dataTBList = [].obs;
  var locationList = <DropDownValue>[].obs, channelList = <DropDownValue>[].obs;
  var locationFn = FocusNode();
  DropDownValue? selectedLocation, selectedChannel;

  var fromDateIDCtr = TextEditingController(), toDateCtr = TextEditingController();

  @override
  void onInit() {
    formPermissions = Utils.fetchPermissions1(Routes.SALES_AUDIT_EXTRA_SPOTS_REPORT.replaceAll("/", ""));
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    getOnLoadData();
  }

  formHandler(String btnName) {
    if (btnName == "Clear") {
      clearData();
    } else if (btnName == "Save") {}
  }

  clearData() {
    selectedLocation = null;
    selectedChannel = null;
    locationList.refresh();
    channelList.refresh();
    locationFn.requestFocus();
    fromDateIDCtr.clear();
    toDateCtr.clear();
    dataTBList.clear();
  }

  generateData() {
    if (selectedLocation == null || selectedChannel == null) {
      LoadingDialog.showErrorDialog("Please select Location, Channel");
    } else {
      LoadingDialog.call();
      Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.SALES_AUDIT_EXTRA_SPOTS_GENERATE,
        fun: (resp) {
          closeDialogIfOpen();
          if (resp != null && resp is Map<String, dynamic> && resp['onLoad_SlideMaster'] != null) {
          } else {
            LoadingDialog.showErrorDialog(resp.toString());
          }
        },
        json: {
          "locationcode": selectedLocation?.key ?? "",
          "channelcode": selectedChannel?.key ?? "",
          "fromdate": DateFormat("yyyy-MM-dd").format(DateFormat('dd-MM-yyyy').parse(fromDateIDCtr.text)),
          "todate": DateFormat("yyyy-MM-dd").format(DateFormat('dd-MM-yyyy').parse(toDateCtr.text)),
        },
      );
    }
  }

  handleOnChangedLocation(DropDownValue? val) {
    selectedLocation = val;
  }

  getOnLoadData() {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.SALES_AUDIT_EXTRA_SPOTS_ON_LOAD,
        fun: (resp) {
          closeDialogIfOpen();
          if (resp != null && resp is Map<String, dynamic> && resp['pageload'] != null) {
            if (resp['pageload']['lstlocation'] != null) {
              locationList.value.addAll((resp['pageload']['lstlocation'] as List<dynamic>)
                  .map((e) => DropDownValue(
                        key: e['locationCode'].toString(),
                        value: e['locationName'].toString(),
                      ))
                  .toList());
            }
            if (resp['pageload']['lstchannel'] != null) {
              channelList.value.addAll((resp['pageload']['lstchannel'] as List<dynamic>)
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
        });
  }

  closeDialogIfOpen() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}

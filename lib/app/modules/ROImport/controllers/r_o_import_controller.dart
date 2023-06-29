import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/LoadingDialog.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../data/DropDownValue.dart';
import '../../../data/PermissionModel.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/Utils.dart';
import '../../../routes/app_pages.dart';

class ROImportController extends GetxController {
  var locationList = <DropDownValue>[].obs, channelList = <DropDownValue>[].obs;
  List<PermissionModel>? formPermissions;
  DropDownValue? selectedLocation, selectedChannel;
  var locationFn = FocusNode();

  @override
  void onInit() {
    formPermissions = Utils.fetchPermissions1(Routes.SLIDE_MASTER.replaceAll("/", ""));
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    getOnLoadData();
  }

  handleOnChangedLocation(DropDownValue? val) {
    selectedLocation = val;

    if (val != null) {
      closeDialogIfOpen();
      LoadingDialog.call();
      Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.SLIDE_MASTER_GET_CHANNEL(val.key.toString()),
        fun: (resp) {
          closeDialogIfOpen();
          if (resp != null && resp is Map<String, dynamic> && resp['onLeaveLocation'] != null) {
            channelList.clear();
            channelList.addAll((resp['onLeaveLocation'] as List<dynamic>)
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
        api: ApiFactory.SLIDE_MASTER_ON_LOAD,
        fun: (resp) {
          closeDialogIfOpen();
          if (resp != null && resp is Map<String, dynamic> && resp['onLoad_SlideMaster'] != null) {
            locationList.value.addAll((resp['onLoad_SlideMaster']['lstlocations'] as List<dynamic>)
                .map((e) => DropDownValue(
                      key: e['locationCode'].toString(),
                      value: e['locationName'].toString(),
                    ))
                .toList());
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

  formHandler(btn) {}
}

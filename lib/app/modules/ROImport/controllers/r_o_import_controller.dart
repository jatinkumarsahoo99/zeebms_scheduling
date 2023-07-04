import 'dart:io';
import 'dart:typed_data';

import 'package:bms_scheduling/app/controller/MainController.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/LoadingDialog.dart';
import '../../../../widgets/Snack.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../data/DropDownValue.dart';
import '../../../data/PermissionModel.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/Utils.dart';
import '../../../routes/app_pages.dart';
import 'package:dio/dio.dart' as dio;

class ROImportController extends GetxController {
  var saveEnabled = false.obs;
  var locationList = <DropDownValue>[].obs, channelList = <DropDownValue>[].obs;
  List<PermissionModel>? formPermissions;
  DropDownValue? selectedLocation, selectedChannel;
  var locationFn = FocusNode();
  var topLeftDataTable = [].obs, topRightDataTable = [].obs, bottomDataTable = [].obs;
  var leftMsg = "".obs, rightMsg = "".obs;

  @override
  void onInit() {
    formPermissions = Utils.fetchPermissions1(Routes.R_O_IMPORT.replaceAll("/", ""));
    super.onInit();
  }

  clearPage() {
    saveEnabled.value = false;
    topLeftDataTable.clear();
    topRightDataTable.clear();
    bottomDataTable.clear();
    leftMsg.value = "";
    rightMsg.value = "";
    selectedChannel = null;
    selectedLocation = null;
    locationList.refresh();
    channelList.refresh();
    locationFn.requestFocus();
    update(['buttons']);
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
        api: ApiFactory.R_O_IMPORT_ON_LEAVE_LOCATION(val.key.toString()),
        fun: (resp) {
          closeDialogIfOpen();
          if (resp != null && resp is Map<String, dynamic> && resp['info_OnLeaveLocation'] != null) {
            selectedChannel = null;
            channelList.clear();
            channelList.addAll((resp['info_OnLeaveLocation'] as List<dynamic>)
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
        api: ApiFactory.R_O_IMPORT_ON_LOAD,
        fun: (resp) {
          closeDialogIfOpen();
          if (resp != null && resp is Map<String, dynamic> && resp['info_ROImportLoad'] != null) {
            locationList.value.addAll((resp['info_ROImportLoad']['lstLocation'] as List<dynamic>)
                .map((e) => DropDownValue(
                      key: e['locationCode'].toString(),
                      value: e['locationName'].toString(),
                    ))
                .toList());
            channelList.value.addAll((resp['info_ROImportLoad']['lstChannel'] as List<dynamic>)
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
        });
  }

  closeDialogIfOpen() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  formHandler(btn) {
    if (btn == "Clear") {
      clearPage();
    } else if (btn == "Save") {
      saveData();
    }
  }

  saveData() {
    if (selectedLocation == null) {
      Snack.callError("Please select location");
    } else if (selectedChannel == null) {
      Snack.callError("Please select channel");
    } else {
      Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.R_O_IMPORT_IMPORT_SAVE,
        fun: (resp) {
          print(resp);
          LoadingDialog.callDataSaved(
            msg: resp.toString(),
            callback: () {
              clearPage();
            },
          );
        },
        json: {
          "bookingDetail": "",
          "locationCode": selectedLocation?.key,
          "channelCode": selectedChannel?.key,
          "modifiedBy": Get.find<MainController>().user?.logincode,
          "action": "",
          "lstdgvMissingData": topRightDataTable,
          "lstdgvImportData": topLeftDataTable.value,
        },
      );
    }
  }

  Future<void> handleImportTap() async {
    if (selectedLocation == null) {
      Snack.callError("Please select location");
    } else if (selectedChannel == null) {
      Snack.callError("Please select channel");
    } else {
      FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: false, type: FileType.custom, allowedExtensions: ['xlsx', 'xls']);

      if (result != null && result.files.isNotEmpty) {
        LoadingDialog.call();
        List<int> encodedFile = [];
        if (result.files[0].name.endsWith("xls")) {
          try {
            var excel = Excel.decodeBytes(result.files[0].bytes!.toList());
            encodedFile = excel.encode()?.toList() ?? [];
          } catch (e) {
            Get.back();
            LoadingDialog.showErrorDialog(e.toString());
            return;
          }
        } else {
          encodedFile = result.files[0].bytes?.toList() ?? [];
        }
        dio.FormData formData = dio.FormData.fromMap(
          {
            "ChannelCode": selectedChannel?.key ?? "",
            "LocationCode": selectedLocation?.key ?? "",
            "ModifiedBy": Get.find<MainController>().user?.logincode,
            'file': dio.MultipartFile.fromBytes(
              encodedFile,
              filename: result.files[0].name,
            ),
          },
        );
        Get.find<ConnectorControl>().POSTMETHOD_FORMDATA(
            api: ApiFactory.R_O_IMPORT_IMPORT_CLICK,
            json: formData,
            fun: (r) {
              closeDialogIfOpen();
              if (r != null && r is Map<String, dynamic> && r['info_OnLeaveLocation'] != null) {
                topLeftDataTable.clear();
                topRightDataTable.clear();
                leftMsg.value = '';
                rightMsg.value = '';
                var data = r['info_OnLeaveLocation'];
                if (data['lstImportData'] != null && (data['lstImportData'] is List<dynamic>)) {
                  topLeftDataTable.clear();
                  topLeftDataTable.value.addAll((data['lstImportData']));
                }
                if (data['lstMissingData'] != null && (data['lstMissingData'] is List<dynamic>)) {
                  topRightDataTable.value.addAll((data['lstMissingData']));
                }
                if (data['message'] != null && data['message'] is List<dynamic> && (data['message'] as List<dynamic>).isNotEmpty) {
                  LoadingDialog.showErrorDialog(data['message'][0]);
                }
                if (data['labelMessage'] != null && data['labelMessage'] is List<dynamic> && (data['labelMessage'] as List<dynamic>).isNotEmpty) {
                  leftMsg.value = data['labelMessage'][0];
                }
                if (data['message_Missing'] != null &&
                    data['message_Missing'] is List<dynamic> &&
                    (data['message_Missing'] as List<dynamic>).isNotEmpty) {
                  rightMsg.value = data['message_Missing'][0];
                }
                if (topLeftDataTable.isNotEmpty && topRightDataTable.isEmpty) {
                  saveEnabled.value = true;
                } else {
                  saveEnabled.value = false;
                  update(['buttons']);
                }
              } else {
                LoadingDialog.showErrorDialog(r.toString());
                saveEnabled.value = false;
                update(['buttons']);
              }
            });
      }
    }
  }
}

import 'dart:convert';

import 'package:bms_scheduling/app/controller/MainController.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/LoadingDialog.dart';
import '../../../../widgets/PlutoGrid/src/manager/pluto_grid_state_manager.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../data/DropDownValue.dart';
import '../../../providers/ExportData.dart';
import '../../../providers/Utils.dart';
import '../promo_model.dart';
import 'package:dio/dio.dart' as dio;

class PromosController extends GetxController {
  var locations = <DropDownValue>[].obs;
  var channels = <DropDownValue>[].obs;
  RxBool controllsEnabled = true.obs;
  var locationFN = FocusNode();
  var myEnabled = true.obs;
  DropDownValue? selectLocation, selectChannel;
  var left1stDT = <DailyFPC>[].obs, left2ndDT = <PromoScheduled>[].obs, right3rdDT = [].obs;
  var fromdateTC = TextEditingController();
  var timeBand = "00:00:00:00".obs, programName = "PrgName".obs;
  PlutoGridStateManager? left1stSM, left2ndSM, rightSM;
  var left2ndGridSelectedIdx = 0, left1stGridSelectedIdx = 0, rightGridSelectedIdx = 0;
  var rightCount = "00:00:00:00".obs;
  // var mainData = {};
  PromoModel? mainModel;
  var availableTC = TextEditingController(),
      scheduledTC = TextEditingController(),
      countTC = TextEditingController(),
      promoIDTC = TextEditingController(),
      promoCaptionTC = TextEditingController();

  clearPage() {
    // mainData = {};
    left1stSM = null;
    mainModel = null;
    left2ndSM = null;
    rightSM = null;
    left2ndGridSelectedIdx = 0;
    left1stGridSelectedIdx = 0;
    rightGridSelectedIdx = 0;
    selectLocation = null;
    selectChannel = null;
    locations.refresh();
    channels.refresh();
    controllsEnabled.value = true;
    myEnabled.value = false;
    timeBand.value = "";
    programName.value = "PrgName";
    rightCount.value = "00:00:00:00";
    availableTC.clear();
    scheduledTC.clear();
    countTC.clear();
    promoIDTC.clear();
    left1stDT.clear();
    left2ndDT.clear();
    promoCaptionTC.clear();
    right3rdDT.clear();
    locationFN.requestFocus();
  }

  @override
  void onReady() {
    super.onReady();
    getLocation();
  }

  formHandler(btnName) async {
    if (btnName == "Clear") {
      clearPage();
    } else if (btnName == "Save") {
      saveData();
    }
  }

  void getChannel(DropDownValue? val) {
    selectLocation = val;
    if (val != null) {
      LoadingDialog.call();
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.PROMOS_GET_CHANNELS(val.key ?? ""),
          fun: (resp) {
            if (resp != null && resp is List<dynamic>) {
              closeDialog();
              selectChannel = null;
              channels.clear();
              channels.addAll(resp
                  .map((e) => DropDownValue(
                        key: e['channelCode'],
                        value: e['channelName'],
                      ))
                  .toList());
            } else {
              LoadingDialog.showErrorDialog(resp.toString());
            }
          },
          failed: (resp) {});
    }
  }

  void getLocation() {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.PROMOS_GET_LOCATION,
        fun: (resp) {
          closeDialog();
          if (resp != null && resp is List<dynamic>) {
            locations.clear();
            locations.addAll(resp
                .map((e) => DropDownValue(
                      key: e['locationCode'].toString(),
                      value: e['locationName'].toString(),
                    ))
                .toList());
          }
        },
        failed: (resp) {
          closeDialog();
          LoadingDialog.showErrorDialog(resp.toString());
        });
  }

  void showDetails() {
    if (selectLocation == null && selectChannel == null) {
      LoadingDialog.showErrorDialog("Please select Location and Channel.");
      return;
    }
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
      api: ApiFactory.PROMOS_SHOW_DETAILS(selectLocation?.key ?? "", selectChannel?.key ?? "",
          DateFormat("yyyy-MM-ddT00:00:00").format(DateFormat("dd-MM-yyyy").parse(fromdateTC.text))),
      fun: (resp) {
        closeDialog();
        if (resp != null && resp is Map<String, dynamic>) {
          mainModel = PromoModel.fromJson(resp);
          if (mainModel?.promoScheduled != null) {
            for (var i = 0; i < (mainModel?.promoScheduled?.length ?? 0); i++) {
              mainModel?.promoScheduled?[i].rowNo = i;
            }
          }
          left1stDT.clear();
          left1stDT.addAll(mainModel?.dailyFPC ?? []);
          if (left1stDT.isEmpty) {
            LoadingDialog.showErrorDialog("Daily FPC not present.");
          } else {
            controllsEnabled.value = false;
            availableTC.text = "00:02:00:00";
            scheduledTC.text = "";
          }
        } else {
          LoadingDialog.showErrorDialog(resp.toString());
        }
      },
      failed: (resp) {
        closeDialog();
        LoadingDialog.showErrorDialog(resp.toString());
      },
    );
  }

  handleDoubleTapInLeft1stTable(int index) {
    left1stGridSelectedIdx = index;
    timeBand.value = left1stDT[index].startTime ?? "00:00:00:00";
    programName.value = left1stDT[index].programName ?? "";
    availableTC.text = "00:02:00:00";
    scheduledTC.text = "00:00:00:00";
    left1stSM?.setCurrentCell(left1stSM?.getRowByIdx(index)?.cells['startTime'], index);
    left2ndDT.clear();
    if (mainModel?.promoScheduled != null) {
      left2ndDT.value = mainModel?.promoScheduled?.where((element) => timeBand.value == element.telecastTime).toList() ?? [];
      countTC.text = left2ndDT.length.toString();
    }
  }

  handleDoubleTapInRightTable(int index) {
    if (left2ndDT.isEmpty) {
      LoadingDialog.showErrorDialog("ProgramSegaments can't be empty");
    } else {
      rightGridSelectedIdx = index;
      rightSM?.setCurrentCell(rightSM?.getRowByIdx(index)?.cells['caption'], index);
      var tempRightModel = right3rdDT[index];
      var insertModel = PromoScheduled(
        promoPolicyName: "MANUAL",
        promoCaption: tempRightModel['caption'],
        priority: left2ndDT[left2ndGridSelectedIdx].priority,
        promoDuration: rightCount.value,
        houseId: tempRightModel['txId'],
        programName: left1stDT[left1stGridSelectedIdx].programName,
        telecastTime: left1stDT[left1stGridSelectedIdx].startTime,
        programCode: left1stDT[left1stGridSelectedIdx].programCode,
        promoCode: left2ndDT[left2ndGridSelectedIdx].promoCode,
        promoSchedulingCode: left2ndDT[left2ndGridSelectedIdx].promoSchedulingCode,
      );

      if (mainModel?.promoScheduled != null && left2ndDT[left2ndGridSelectedIdx].rowNo != null) {
        mainModel?.promoScheduled?.insert(left2ndDT[left2ndGridSelectedIdx].rowNo! + 1, insertModel);
        for (var i = 0; i < (mainModel?.promoScheduled?.length ?? 0); i++) {
          mainModel?.promoScheduled?[i].rowNo = i;
        }
      }
      left2ndDT.insert(left2ndGridSelectedIdx + 1, insertModel);
      left2ndGridSelectedIdx = left2ndGridSelectedIdx + 1;
      left2ndDT.refresh();
      scheduledTC.text = Utils.convertToTimeFromDouble(value: (Utils.convertToSecond(value: scheduledTC.text)) + (tempRightModel['duration'] ?? 0));
      if ((Utils.convertToSecond(value: scheduledTC.text)) + (tempRightModel['duration'] ?? 0) > Utils.convertToSecond(value: "00:02:00:00")) {
        left1stDT[left1stGridSelectedIdx].exceed = true;
        left1stDT.refresh();
      }
      countTC.text = left2ndDT.length.toString();
    }
  }

  void handleDelete() {
    if (selectLocation == null && selectChannel == null) {
      LoadingDialog.showErrorDialog("Please select Location and Channel.");
      return;
    }
    LoadingDialog.delete("Want to delete promo scheduling for selected date?", () {
      LoadingDialog.call();
      Get.find<ConnectorControl>().DELETEMETHOD(
        api: ApiFactory.PROMOS_DELETE(selectLocation?.key ?? "", selectChannel?.key ?? "",
            DateFormat("yyyy-MM-ddT00:00:00").format(DateFormat("dd-MM-yyyy").parse(fromdateTC.text))),
        fun: (resp) {
          closeDialog();
          if (resp != null) {
          } else {
            LoadingDialog.showErrorDialog(resp.toString());
          }
        },
      );
    });
  }

  void handleAddTap() {
    handleDoubleTapInRightTable(rightGridSelectedIdx);
  }

  void handleSearchTap() {
    if (selectLocation == null && selectChannel == null) {
      LoadingDialog.showErrorDialog("Please select Location and Channel.");
      return;
    }
    LoadingDialog.call();
    Get.find<ConnectorControl>().POSTMETHOD(
      api: ApiFactory.PROMOS_SEARCH,
      fun: (resp) {
        closeDialog();
        if (resp != null && resp is List<dynamic>) {
          right3rdDT.clear();
          right3rdDT.addAll(resp);
        } else {
          LoadingDialog.showErrorDialog(resp.toString());
        }
      },
      json: {
        "locationCode": selectLocation?.key ?? "",
        "channelCode": selectChannel?.key ?? "",
        "telecastDate": DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy").parse(fromdateTC.text)),
        "mine": myEnabled.value,
        "txID": promoIDTC.text,
        "caption": promoCaptionTC.text,
      },
    );
  }

  handleOnSelectRightTable(int index) {
    rightGridSelectedIdx = index;
    if (right3rdDT[index]['duration'] != null && index != -1) {
      rightCount.value = Utils.convertToTimeFromDouble(value: right3rdDT[index]['duration']);
    }
  }

  void saveData() {
    if (selectLocation == null && selectChannel == null) {
      LoadingDialog.showErrorDialog("Please select Location and Channel.");
      return;
    }
    if (mainModel?.promoScheduled == null || (mainModel?.promoScheduled?.isEmpty ?? true)) {
      LoadingDialog.showErrorDialog("Nothing to save. Please schedule promos");
      return;
    }
    LoadingDialog.call();
    Get.find<ConnectorControl>().POSTMETHOD(
      api: ApiFactory.PROMOS_SAVE,
      fun: (resp) {
        closeDialog();
        if (resp != null && resp.toString().contains("Record saved successfully.")) {
          LoadingDialog.callDataSaved(
              msg: resp.toString(),
              callback: () {
                clearPage();
              });
        } else {
          LoadingDialog.showErrorDialog(resp.toString());
        }
      },
      json: {
        "locationCode": selectLocation?.key,
        "channelCode": selectChannel?.key,
        "telecastDate": DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy").parse(fromdateTC.text)),
        "modifiedBy": Get.find<MainController>().user?.logincode,
        "promoSchSaveDetails": mainModel?.promoScheduled?.map((e) => e.toJson(fromSave: true)).toList(),
      },
    );
  }

  void handleAutoAddTap() {} // not in use

  Future<void> handleImportTap() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single != null) {
      PlatformFile file = result.files.single;
      String? fileName = result.files.single.name;
      LoadingDialog.call();
      String captionSTR = promoCaptionTC.text.isEmpty ? "null" : promoCaptionTC.text;
      dio.FormData formData = dio.FormData.fromMap(
        {
          "Caption": captionSTR,
          "LocationCode": selectLocation?.key ?? "",
          "ChannelCode": selectChannel?.key ?? "",
          "TeleCastDate": DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy").parse(fromdateTC.text)),
          "IsMine": myEnabled.value,
          'ImportFile': dio.MultipartFile.fromBytes(
            file.bytes!.toList(),
            filename: fileName,
          ),
        },
      );

      Get.find<ConnectorControl>().POSTMETHOD_FORMDATA(
        api: ApiFactory.PROMOS_IMPORT_EXCEL_VALIDATE,
        json: formData,
        fun: (resp) {
          closeDialog();

          if (resp != null && resp is Map<String, dynamic>) {
            if (resp.containsKey("isError") && resp['isError']) {
              LoadingDialog.showErrorDialog(resp['errorMessage'].toString());
            } else if (!(resp['isError'] as bool) && resp['genericMessage'] != null) {
              LoadingDialog.showErrorDialog(resp['genericMessage'].toString(), callback: () {
                LoadingDialog.call();
                dio.FormData formData2 = dio.FormData.fromMap(
                  {
                    "Caption": captionSTR,
                    "LocationCode": selectLocation?.key ?? "",
                    "ChannelCode": selectChannel?.key ?? "",
                    "TeleCastDate": DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy").parse(fromdateTC.text)),
                    "IsMine": myEnabled.value,
                    'ImportFile': dio.MultipartFile.fromBytes(
                      file.bytes!.toList(),
                      filename: fileName,
                    ),
                  },
                );
                Get.find<ConnectorControl>().POSTMETHOD_FORMDATA(
                  api: ApiFactory.PROMOS_IMPORT_EXCEL,
                  json: formData2,
                  fun: (resp2) {
                    Get.back();
                    LoadingDialog.showErrorDialog(resp2.toString());
                    // ExportData().exportFilefromByte(base64Decode(resp2), fileName);
                  },
                );
              });
            } else {
              LoadingDialog.showErrorDialog(resp['errorMessage'].toString());
            }
          } else {
            LoadingDialog.showErrorDialog(resp.toString());
          }
        },
      );
    }
  }

  closeDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}

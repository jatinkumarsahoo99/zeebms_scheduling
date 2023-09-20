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
import '../../../controller/HomeController.dart';
import '../../../data/DropDownValue.dart';
import '../../../data/user_data_settings_model.dart';
import '../../../providers/ExportData.dart';
import '../../../providers/Utils.dart';
import '../promo_model.dart';
import 'package:dio/dio.dart' as dio;

class SchedulePromoController extends GetxController {
  var locations = <DropDownValue>[].obs;
  var channels = <DropDownValue>[].obs;
  RxBool controllsEnabled = true.obs;
  var locationFN = FocusNode();
  var myEnabled = true.obs;

  DropDownValue? selectLocation, selectChannel;
  var dailyFpc = <DailyFPC>[].obs,
      promoScheduled = <PromoScheduled>[].obs,
      searchPromos = [].obs;
  var fromdateTC = TextEditingController();
  var timeBand = "00:00:00:00".obs, programName = "PrgName".obs;
  PlutoGridStateManager? fpcStateManager,
      scheduledPromoStateManager,
      searchedPromoStateManager;
  var schedulePromoSelectedIdx = 0,
      fpcSelectedIdx = 0,
      searchPromoSelectedIdx = 0;
  var schedulePromoSelectedCol = "",
      fpcSelectedCol = "",
      searchPromoSelectedCol = "";
  var rightCount = "00:00:00:00".obs;
  // var mainData = {};
  PromoModel? promoData;
  var availableTC = TextEditingController(),
      scheduledTC = TextEditingController(),
      countTC = TextEditingController(),
      promoIDTC = TextEditingController(),
      promoCaptionTC = TextEditingController();

  clearPage() {
    // mainData = {};
    fpcStateManager = null;
    promoData = null;
    scheduledPromoStateManager = null;
    searchedPromoStateManager = null;
    schedulePromoSelectedIdx = 0;
    fromdateTC.text = "";
    fpcSelectedIdx = 0;
    searchPromoSelectedIdx = 0;
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
    dailyFpc.clear();
    promoScheduled.clear();
    promoCaptionTC.clear();
    searchPromos.clear();
    locationFN.requestFocus();
  }

  @override
  void onReady() {
    super.onReady();
    getLocation();
    fetchUserSetting1();
  }

  UserDataSettings? userDataSettings;

  fetchUserSetting1() async {
    userDataSettings = await Get.find<HomeController>().fetchUserSetting2();
    dailyFpc.refresh();
    promoScheduled.refresh();
    searchPromos.refresh();
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
    if (selectLocation == null || selectChannel == null) {
      LoadingDialog.showErrorDialog("Please select Location and Channel.");
    } else {
      LoadingDialog.call();
      Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.PROMOS_SHOW_DETAILS(
            selectLocation?.key ?? "",
            selectChannel?.key ?? "",
            DateFormat("yyyy-MM-ddT00:00:00")
                .format(DateFormat("dd-MM-yyyy").parse(fromdateTC.text))),
        fun: (resp) {
          closeDialog();
          if (resp != null && resp is Map<String, dynamic>) {
            promoData = PromoModel.fromJson(resp);
            if (promoData?.promoScheduled != null) {
              for (var i = 0;
                  i < (promoData?.promoScheduled?.length ?? 0);
                  i++) {
                promoData?.promoScheduled?[i].rowNo = i;
              }
            }
            dailyFpc.clear();
            dailyFpc.addAll(promoData?.dailyFPC ?? []);
            if (dailyFpc.isEmpty) {
              LoadingDialog.showErrorDialog("Daily FPC not present.");
            } else {
              controllsEnabled.value = false;
              if (promoData?.dailyFPC?.isNotEmpty ?? false) {
                availableTC.text = Utils.convertToTimeFromDouble(
                    value: promoData?.dailyFPC?[0].promoCap ?? 0);
              } else {
                availableTC.text = "00:00:00:00";
              }
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
  }

  handleDoubleTapInLeft1stTable(int index, String col) {
    fpcSelectedIdx = index;
    fpcSelectedCol = col;
    schedulePromoSelectedIdx = 0;
    timeBand.value = dailyFpc[index].startTime ?? "00:00:00:00";
    programName.value = dailyFpc[index].programName ?? "";
    if (promoData?.dailyFPC?.isNotEmpty ?? false) {
      availableTC.text = Utils.convertToTimeFromDouble(
          value: promoData?.dailyFPC?[0].promoCap ?? 0);
    } else {
      availableTC.text = "00:00:00:00";
    }
    scheduledTC.text = "00:00:00:00";
    fpcStateManager?.setCurrentCell(
        fpcStateManager?.getRowByIdx(index)?.cells[col], index);
    promoScheduled.clear();
    if (promoData?.promoScheduled != null) {
      promoScheduled.value = promoData?.promoScheduled
              ?.where((element) => timeBand.value == element.telecastTime)
              .toList() ??
          [];
      countTC.text = promoScheduled.length.toString();
    }
    calcaulateExceed(index);
  }

  handleDoubleTapInRightTable(int? index, String col) {
    if (promoScheduled.isEmpty) {
      LoadingDialog.showErrorDialog("ProgramSegments can't be empty");
    } else {
      searchPromoSelectedIdx = index ?? 0;
      searchedPromoStateManager?.setCurrentCell(
          searchedPromoStateManager
              ?.getRowByIdx(searchPromoSelectedIdx)
              ?.cells[col],
          searchPromoSelectedIdx);
      var tempRightModel = searchPromos[searchPromoSelectedIdx];
      var insertModel = PromoScheduled(
        promoPolicyName: "MANUAL",
        promoCaption: tempRightModel['caption'],
        priority: promoScheduled[schedulePromoSelectedIdx].priority,
        promoDuration:
            Utils.convertToTimeFromDouble(value: tempRightModel['duration']),
        houseId: tempRightModel['txId'],
        programName: dailyFpc[fpcSelectedIdx].programName,
        telecastTime: dailyFpc[fpcSelectedIdx].startTime,
        programCode: dailyFpc[fpcSelectedIdx].programCode,
        promoCode: tempRightModel["eventCode"],
        promoSchedulingCode:
            promoScheduled[schedulePromoSelectedIdx].promoSchedulingCode,
      );

      if (promoData?.promoScheduled != null &&
          promoScheduled[schedulePromoSelectedIdx].rowNo != null) {
        promoData?.promoScheduled?.insert(
            promoScheduled[schedulePromoSelectedIdx].rowNo! + 1, insertModel);
        for (var i = 0; i < (promoData?.promoScheduled?.length ?? 0); i++) {
          promoData?.promoScheduled?[i].rowNo = i;
        }
      }
      promoScheduled.insert(schedulePromoSelectedIdx + 1, insertModel);
      schedulePromoSelectedIdx = schedulePromoSelectedIdx + 1;
      promoScheduled.refresh();
      scheduledTC.text = Utils.convertToTimeFromDouble(
          value: (Utils.oldBMSConvertToSecondsValue(value: scheduledTC.text)) +
              (tempRightModel['duration'] ?? 0));
      calcaulateExceed(fpcSelectedIdx);
      countTC.text = promoScheduled.length.toString();
    }
  }

  calcaulateExceed(index, {bool focusBackGrid = false}) {
    timeBand.value = dailyFpc[index].startTime ?? "00:00:00:00";
    programName.value = dailyFpc[index].programName ?? "";

    List<PromoScheduled>? promos = promoData?.promoScheduled
            ?.where((element) => timeBand.value == element.telecastTime)
            .toList() ??
        [];
    num _totalPromoTime = 0;
    for (var promo in promos) {
      _totalPromoTime = _totalPromoTime +
          Utils.oldBMSConvertToSecondsValue(
              value: promo.promoDuration ?? "00:00:00:00");
    }
    if (_totalPromoTime > (promoData?.dailyFPC?[index].promoCap ?? 0)) {
      dailyFpc[index].exceed = true;
    } else {
      dailyFpc[index].exceed = false;
    }

    // scheduledTC.text = Utils.getDurationSecond(second: _totalPromoTime);
    scheduledTC.text = Utils.convertToTimeFromDouble(value: _totalPromoTime);
    countTC.text = promoScheduled.length.toString();
    dailyFpc.refresh();
    if (focusBackGrid) {
      Future.delayed(
        const Duration(milliseconds: 800),
        () {
          promoScheduled.refresh();
        },
      );
    }
  }

  void handleDelete() {
    if (selectLocation == null || selectChannel == null) {
      LoadingDialog.showErrorDialog("Please select Location and Channel.");
      return;
    } else {
      LoadingDialog.delete("Want to delete promo scheduling for selected date?",
          () {
        LoadingDialog.call();
        Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.PROMOS_DELETE(
              selectLocation?.key ?? "",
              selectChannel?.key ?? "",
              DateFormat("yyyy-MM-ddT00:00:00")
                  .format(DateFormat("dd-MM-yyyy").parse(fromdateTC.text))),
          fun: (resp) {
            closeDialog();

            if (resp != null) {
            } else {
              LoadingDialog.showErrorDialog(resp.toString());
            }
            showDetails();
          },
        );
      });
    }
  }

  void handleAddTap() {
    handleDoubleTapInRightTable(searchPromoSelectedIdx, searchPromoSelectedCol);
  }

  void handleSearchTap() {
    if (selectLocation == null || selectChannel == null) {
      LoadingDialog.showErrorDialog("Please select Location and Channel.");
      return;
    }
    LoadingDialog.call();
    Get.find<ConnectorControl>().POSTMETHOD(
      api: ApiFactory.PROMOS_SEARCH,
      fun: (resp) {
        closeDialog();
        if (resp != null && resp is List<dynamic>) {
          searchPromos.clear();
          searchPromos.addAll(resp);
        } else {
          LoadingDialog.showErrorDialog(resp.toString());
        }
      },
      json: {
        "locationCode": selectLocation?.key ?? "",
        "channelCode": selectChannel?.key ?? "",
        "telecastDate": DateFormat("yyyy-MM-dd")
            .format(DateFormat("dd-MM-yyyy").parse(fromdateTC.text)),
        "mine": myEnabled.value,
        "txID": promoIDTC.text,
        "caption": promoCaptionTC.text,
      },
    );
  }

  handleOnSelectRightTable(int index, String col) {
    searchPromoSelectedIdx = index;
    searchPromoSelectedCol = col;
    if (searchPromos[index]['duration'] != null && index != -1) {
      rightCount.value =
          Utils.convertToTimeFromDouble(value: searchPromos[index]['duration']);
    }
  }

  void saveData() {
    if (selectLocation == null || selectChannel == null) {
      LoadingDialog.showErrorDialog("Please select Location and Channel.");
      return;
    } else if (promoData?.promoScheduled == null ||
        (promoData?.promoScheduled?.isEmpty ?? true)) {
      LoadingDialog.showErrorDialog("Nothing to save. Please schedule promos");
      return;
    } else {
      LoadingDialog.call();
      Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.PROMOS_SAVE,
        fun: (resp) {
          closeDialog();
          if (resp != null &&
              resp.toString().contains("Record saved successfully.")) {
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
          "telecastDate": DateFormat("dd-MMM-yyyy")
              .format(DateFormat("dd-MM-yyyy").parse(fromdateTC.text)),
          "modifiedBy": Get.find<MainController>().user?.logincode,
          "promoSchSaveDetails": promoData?.promoScheduled
              ?.map((e) => e.toJson(fromSave: true))
              .toList(),
        },
      );
    }
  }

  // void handleAutoAddTap() {
  //   if (selectLocation == null && selectChannel == null) {
  //     LoadingDialog.showErrorDialog("Please select Location and Channel.");
  //   } else {
  //     LoadingDialog.call();
  //     Get.find<ConnectorControl>().POSTMETHOD(
  //       api: ApiFactory.PROMOS_SAVE_AUTO_PROMO,
  //       fun: (resp) {
  //         closeDialog();
  //         if (resp != null && resp is List<dynamic>) {
  //           if (resp.isNotEmpty) {
  //             promoData?.promoScheduled = [];
  //             promoData?.promoScheduled?.addAll(resp.map((e) => PromoScheduled.fromJson(e)).toList());
  //             handleDoubleTapInLeft1stTable(fpcSelectedIdx);
  //           }
  //         } else {
  //           LoadingDialog.showErrorDialog(resp.toString());
  //         }
  //       },
  //       json: {
  //         "locationCode": selectLocation?.key,
  //         "channelCode": selectChannel?.key,
  //         "telecastDate": DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy").parse(fromdateTC.text)),
  //         "txId": promoIDTC.text,
  //       },
  //     );
  //   }
  // } // not in use

  Future<void> handleImportTap() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single != null) {
      PlatformFile file = result.files.single;
      String? fileName = result.files.single.name;
      LoadingDialog.call();
      String captionSTR =
          promoCaptionTC.text.isEmpty ? "null" : promoCaptionTC.text;
      dio.FormData formData = dio.FormData.fromMap(
        {
          "Caption": captionSTR,
          "LocationCode": selectLocation?.key ?? "",
          "ChannelCode": selectChannel?.key ?? "",
          "TeleCastDate": DateFormat("yyyy-MM-dd")
              .format(DateFormat("dd-MM-yyyy").parse(fromdateTC.text)),
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
            } else if (!(resp['isError'] as bool) &&
                resp['genericMessage'] != null) {
              if (resp['genericMessage'].toString().contains("\n") &&
                  resp['genericMessage'].toString().split("\n").length > 2) {
                promoIDTC.text =
                    resp['genericMessage'].toString().split("\n")[1];
              }
              LoadingDialog.showErrorDialog(resp['genericMessage'].toString(),
                  callback: () {
                LoadingDialog.call();
                dio.FormData formData2 = dio.FormData.fromMap(
                  {
                    "Caption": captionSTR,
                    "LocationCode": selectLocation?.key ?? "",
                    "ChannelCode": selectChannel?.key ?? "",
                    "TeleCastDate": DateFormat("yyyy-MM-dd").format(
                        DateFormat("dd-MM-yyyy").parse(fromdateTC.text)),
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
                    if (resp2 != null && resp2 is List<dynamic>) {
                      LoadingDialog.showErrorDialog(
                          "File imported successfully.");
                      if (resp2.isNotEmpty) {
                        promoScheduled.value = [];
                        for (var element in resp2) {
                          promoScheduled.value
                              .add(PromoScheduled.fromJson(element));
                        }
                        promoScheduled.refresh();
                      }
                    } else {
                      LoadingDialog.showErrorDialog(resp2.toString());
                    }
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

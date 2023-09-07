import 'dart:convert';

import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:bms_scheduling/widgets/Snack.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';

import '../../../controller/ConnectorControl.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../data/DropDownValue.dart';
import '../../../data/user_data_settings_model.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/ExportData.dart';
import '../LogAdditionModel.dart';

class LogAdditionsController extends GetxController {
  //TODO: Implement LogAdditionsController

  var locations = RxList<DropDownValue>();
  var channels = RxList<DropDownValue>([]);
  var additions = RxList<DropDownValue>([]);
  RxBool isEnable = RxBool(true);

  //input controllers
  DropDownValue? selectLocation;
  Rxn<DropDownValue> selectChannel = Rxn<DropDownValue>(null);
  Rxn<DropDownValue> selectAdditions = Rxn<DropDownValue>(null);

  // DropDownValue? selectAdditions;
  PlutoGridStateManager? gridStateManager;

  TextEditingController selectedDate = TextEditingController();
  TextEditingController remarks = TextEditingController();
  var isStandby = RxBool(false);
  var isIgnoreSpot = RxBool(false);
  RxnString verifyType = RxnString("Primary");
  RxnString additionCount = RxnString("--");
  RxnString cancelCount = RxnString("--");

  LogAdditionModel? logAdditionModel;
  PlutoGridMode selectedPlutoGridMode = PlutoGridMode.normal;

  // RxString logAddionName = RxString("Addition");

  UserDataSettings? userDataSettings;

  @override
  void onReady() {
    super.onReady();
    fetchUserSetting1();
  }

  fetchUserSetting1() async {
    userDataSettings = await Get.find<HomeController>().fetchUserSetting2();
    update(['transmissionList']);
  }

  @override
  void onInit() {
    getLocations();
    super.onInit();
  }

  getLocations() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.LOG_ADDITION_LOCATION,
        fun: (Map map) {
          locations.clear();
          map["location"].forEach((e) {
            locations.add(DropDownValue.fromJson1(e));
          });
        });
  }

  getChannels(String key) {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.LOG_ADDITION_CHANNEL + key,
        fun: (Map map) {
          channels.clear();
          map["locationSelect"].forEach((e) {
            channels.add(
                DropDownValue.fromJsonDynamic(e, "channelCode", "channelName"));
          });
        });
  }

  getShowDetails() {
    if (selectLocation == null) {
      Snack.callError("Please select location");
    } else if (selectChannel == null) {
      Snack.callError("Please select channel");
    } else {
      LoadingDialog.call();
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.LOG_ADDITION_SHOW_DETAILS(
              selectLocation!,
              selectChannel.value!,
              selectedDate.text,
              verifyType.value == "Primary" ? true : false,
              isStandby.value,
              isIgnoreSpot.value),
          fun: (Map<String, dynamic> map) {
            Navigator.pop(Get.context!);
            logAdditionModel = LogAdditionModel.fromJson(map);
            if (logAdditionModel != null &&
                logAdditionModel?.displayPreviousAdditon != null &&
                logAdditionModel?.displayPreviousAdditon?.previousAdditons !=
                    null &&
                (logAdditionModel
                    ?.displayPreviousAdditon?.previousAdditons?.isNotEmpty)!) {
              additionCount.value =
                  logAdditionModel?.displayPreviousAdditon?.additionCount ??
                      "--";
              cancelCount.value =
                  logAdditionModel?.displayPreviousAdditon?.cancellationCount ??
                      "--";
              isEnable.value = false;
              update(["transmissionList"]);
            } else {
              logAdditionModel = null;
              update(["transmissionList"]);
              Snack.callError("No Data Found");
            }
          });
    }
  }

  getShowPreviousAddition() {
    if (selectLocation == null) {
      Snack.callError("Please select location");
    } else if (selectChannel == null) {
      Snack.callError("Please select channel");
    } else {
      LoadingDialog.call();
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.LOG_ADDITION_PREVIOUS_ADDITION(
            selectLocation?.value ?? "",
            selectChannel?.value?.value ?? "",
            selectedDate.text,
            selectAdditions?.value?.key ?? "",
          ),
          fun: (Map<String, dynamic> map) {
            Get.back();

            // print(">>>getShowPreviousAddition()>>>" + jsonEncode(map));
            logAdditionModel = LogAdditionModel.fromJson(map);
            /*print(">>>getShowPreviousAddition() Model>>>" +
                jsonEncode(logAdditionModel?.toJson()));*/
            if (logAdditionModel != null &&
                logAdditionModel?.displayPreviousAdditon != null &&
                logAdditionModel?.displayPreviousAdditon?.previousAdditons !=
                    null &&
                (logAdditionModel
                    ?.displayPreviousAdditon?.previousAdditons?.isNotEmpty)!) {
              remarks.text =
                  logAdditionModel?.displayPreviousAdditon?.remarks ?? "";
              isEnable.value = false;
              update(["transmissionList"]);
            } else {
              logAdditionModel = null;
              update(["transmissionList"]);
              Snack.callError("No Data Found");
            }
          });
    }
  }

  getAdditionList() {
    if (selectLocation == null) {
      // Snack.callError("Please select location");
    } else if (selectChannel == null) {
      // Snack.callError("Please select channel");
    } else if (selectedDate.text == "") {
      // Snack.callError("Please select date");
    } else {
      print("Channel is>>>" + jsonEncode(selectChannel.toJson()));
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.LOG_ADDITION_GET_ADDITIONS(
            selectLocation!,
            selectChannel.value!,
            selectedDate.text,
          ),
          fun: (Map<String, dynamic> map) {
            additions.value.clear();
            map["displayPreviousAdditon"].forEach((v) {
              additions.value
                  .add(DropDownValue.fromJsonDynamic(v, "value", "name"));
            });
          });
    }
  }

  saveAddition() {
    if (selectLocation == null) {
      Snack.callError("Please select location");
    } else if (selectChannel.value == null) {
      Snack.callError("Please select channel");
    } else if (selectedDate.text == "") {
      Snack.callError("Please select date");
    }
    /*else if (selectAdditions.value == null) {
      Snack.callError("Please select addition");
    } */
    else {
      if (selectAdditions.value?.value == null ||
          (selectAdditions.value?.value != "All" &&
              selectAdditions.value?.value != "New")) {
        LoadingDialog.recordExists(
            "Do you want to update the remarks?",
            () {
              postData();
            },
            deleteCancel: "No",
            deleteTitle: "Yes",
            cancel: () {
              postData();
            });
      } else {
        postData();
      }
    }
  }

  postData() {
    LoadingDialog.call();
    var mapData = {
      "additionNameselectedVal": selectAdditions?.value?.key ?? "",
      "additionNameselected": selectAdditions?.value?.value ?? "",
      "optPrimary": verifyType.value == "Primary" ? true : false,
      "remarks": remarks.text,
      "locationcode": selectLocation?.key ?? "",
      "locationName": selectLocation?.value ?? "",
      "channelcode": selectChannel.value?.key ?? "",
      "channelName": selectChannel.value?.value ?? "",
      "telecastDate": selectedDate.text,
      "chkIgnore": isIgnoreSpot.value,
      "chkStandby": isStandby
          .value /*,
        "additions": (logAdditionModel?.displayPreviousAdditon?.previousAdditons
            ?.map((e) => e.toJson1())
            .toList())*/
    };
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.LOG_ADDITION_SAVE_ADDITION(),
        json: mapData,
        fun: (map) {
          Navigator.pop(Get.context!);
          if (map is Map &&
                  map.containsKey("postAdditionsoutput") &&
                  map["postAdditionsoutput"] != null &&
                  map["postAdditionsoutput"].containsKey(
                      "success") /*&&
              map["postAdditionsoutput"]["success"] == "success"*/
              ) {
            // logAddionName.value = logAddionName.value + map["postAdditionsoutput"]["additionselected"];
            // getAdditionListCheck("Addition"+map["postAdditionsoutput"]["additionselected"]);
            if (map["postAdditionsoutput"]["lstAddition"] != null) {
              additions.value.clear();
              map["postAdditionsoutput"]["lstAddition"].forEach((v) {
                additions.value
                    .add(DropDownValue.fromJsonDynamic(v, "value", "name"));
                if ("Addition" +
                        map["postAdditionsoutput"]["additionselected"] ==
                    v["name"].toString().trim()) {
                  selectAdditions.value =
                      DropDownValue.fromJsonDynamic(v, "value", "name");
                }
              });
            }
            LoadingDialog.callDataSaved(callback: () {
              ExportData().exportExcelFromJsonList(
                  (logAdditionModel?.displayPreviousAdditon?.previousAdditons
                      ?.map((e) => e.toJson1())
                      .toList())!,
                  "${selectLocation?.value ?? ""} ${selectChannel?.value?.value ?? ""} ${DateFormat('yyyy-MM-dd').format(DateFormat("dd-MM-yyyy").parse(selectedDate.text))} ${"Addition " + (map["postAdditionsoutput"]["additionselected"] ?? "1")}",
                  callBack: () {});
            });
          } else {
            Snack.callError(map.toString());
          }
        });
  }

  showDetails() {
    if (selectLocation == null) {
      Snack.callError("Please select location");
    } else if (selectChannel == null) {
      Snack.callError("Please select channel");
    } else {
      if (selectAdditions.value == null) {
        getShowDetails();
      } else {
        if (selectAdditions?.value?.key != "0") {
          getShowPreviousAddition();
        } else {
          getShowDetails();
        }
      }
    }
  }

  getSetting() {
    for (var value in (gridStateManager?.columns)!) {
      print("Width value>>>" +
          value.width.toString() +
          " key is>>>" +
          value.title);
    }
  }
}

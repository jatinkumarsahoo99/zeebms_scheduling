import 'package:bms_scheduling/app/controller/MainController.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/LoadingDialog.dart';
import '../../../../widgets/PlutoGrid/src/manager/pluto_grid_state_manager.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../controller/HomeController.dart';
import '../../../data/DropDownValue.dart';
import '../../../data/PermissionModel.dart';
import '../../../data/user_data_settings_model.dart';
import '../../../providers/Utils.dart';
// import '../../promos/promo_model.dart';
import '../../../routes/app_pages.dart';
import '../../CommonSearch/views/common_search_view.dart';
import '../model/schedule_secondary_event_model.dart';

class EventSecondaryController extends GetxController {
  var locations = <DropDownValue>[].obs;
  var channels = <DropDownValue>[].obs;
  RxBool controllsEnabled = true.obs;
  var locationFN = FocusNode();
  var myEnabled = true.obs;
  DropDownValue? selectLocation, selectChannel;
  var left1stDT = <DetailResponse>[].obs,
      left2ndDT = <SegementsResponse>[].obs,
      right3rdDT = [].obs;
  var fromdateTC = TextEditingController(),
      toDateGetPreviousTC = TextEditingController(),
      fromDateGetPTC = TextEditingController();
  var timeBand = "00:00:00:00".obs, programName = "PrgName".obs;
  PlutoGridStateManager? left1stSM, left2ndSM, rightSM;
  var left2ndGridSelectedIdx = 0,
      left1stGridSelectedIdx = 0,
      rightGridSelectedIdx = 0;
  var rightCount = "00:00:00:00".obs;
  var all = true.obs, even = true.obs, odd = true.obs;
  List<PermissionModel>? formPermissions;
  // var mainData = {};
  ScheduleSecondaryEventModel? mainModel;
  var availableTC = TextEditingController(),
      scheduledTC = TextEditingController(),
      countTC = TextEditingController(),
      secondaryIDTC = TextEditingController(),
      secCaptionTC = TextEditingController();

  @override
  void onInit() {
    formPermissions =
        Utils.fetchPermissions1(Routes.EVENT_SECONDARY.replaceAll("/", ""));
    super.onInit();
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
    left1stDT.refresh();
    left2ndDT.refresh();
    right3rdDT.refresh();
  }

  clearPage() {
    // mainData = {};
    fromdateTC.clear();
    toDateGetPreviousTC.clear();
    fromDateGetPTC.clear();
    all.value = false;
    myEnabled.value = false;
    even.value = false;
    odd.value = false;
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
    secondaryIDTC.clear();
    left1stDT.clear();
    left2ndDT.clear();
    secCaptionTC.clear();
    right3rdDT.clear();
    Future.delayed(Duration(milliseconds: 200)).then((value) {
      locationFN.requestFocus();
    });
  }

  formHandler(btnName) async {
    if (btnName == "Clear") {
      clearPage();
    } else if (btnName == "Save") {
      saveData();
    } else if (btnName == "Exit") {
      Get.find<HomeController>().postUserGridSetting2(listStateManager: [
        {"rightSM": rightSM},
        {"left2ndSM": left2ndSM},
        {"left1stSM": left1stSM},
      ]);
    } else if (btnName == "Search") {
      Get.to(
        SearchPage(
          key: Key("Schedule Seconday Event"),
          screenName: "Schedule Seconday Event",
          appBarName: "Schedule Seconday Event",
          strViewName: "BMS_view_SecondaryEventScheduling",
          isAppBarReq: true,
        ),
      );
    }
  }

  void getChannel(DropDownValue? val) {
    selectLocation = val;
    if (val != null) {
      LoadingDialog.call();
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.EVENT_GET_CHANNELS(val.key ?? ""),
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
        api: ApiFactory.EVENT_GET_LOCATION,
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

  void handleGetPreviousTap() {
    if (selectLocation == null) {
      LoadingDialog.showErrorDialog("Please select Location.");
    } else if (selectChannel == null) {
      LoadingDialog.showErrorDialog("Please select Channel.");
    } else {
      Get.defaultDialog(
        title: "Select Date",
        content: Row(
          children: [
            DateWithThreeTextField(
              title: "From Date",
              widthRation: .10,
              mainTextController: fromDateGetPTC,
              endDate: DateTime.now(),
            ),
            SizedBox(width: 20),
            DateWithThreeTextField(
              title: "To Date",
              widthRation: .10,
              mainTextController: toDateGetPreviousTC,
              startDate: DateTime.now(),
            ),
          ],
        ),
        // onCancel: () {
        //   Get.back();
        // },
        cancel: FormButton(
          btnText: "Cancel",
          callback: () {
            Get.back();
          },
        ),
        actions: [
          FormButton(
            btnText: "Clear",
            callback: () {
              fromDateGetPTC.clear();
              toDateGetPreviousTC.clear();
            },
          ),
        ],
        confirm: FormButton(
          btnText: "Done",
          callback: () {
            Get.back();
            LoadingDialog.call();
            Get.find<ConnectorControl>().POSTMETHOD(
              api: ApiFactory.EVENT_PREVIOUS_DETAILS,
              fun: (resp) {
                closeDialog();
                if (resp != null &&
                        resp.toString().contains("Secondary event of") ||
                    resp.toString().contains('secondary events')) {
                  LoadingDialog.callDataSaved(msg: resp.toString());
                } else {
                  LoadingDialog.showErrorDialog(resp.toString());
                }
              },
              json: {
                "locationcode": selectLocation?.key ?? "",
                "channelCode": selectChannel?.key ?? "",
                "fromDate": DateFormat("yyyy-MM-ddT00:00:00").format(
                    DateFormat("dd-MM-yyyy").parse(fromDateGetPTC.text)),
                "forDate": DateFormat("yyyy-MM-ddT00:00:00").format(
                    DateFormat("dd-MM-yyyy").parse(toDateGetPreviousTC.text)),
              },
            );
          },
        ),
        // onConfirm: () {},
      );
    }
  }

  void showDetails() {
    if (selectLocation == null) {
      LoadingDialog.showErrorDialog("Please select Location.");
    } else if (selectChannel == null) {
      LoadingDialog.showErrorDialog("Please select Channel.");
    } else {
      LoadingDialog.call();
      Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.EVENT_SHOW_DETAILS,
        fun: (resp) {
          closeDialog();
          if (resp != null && resp is Map<String, dynamic>) {
            left2ndGridSelectedIdx = 0;
            left1stGridSelectedIdx = 0;

            mainModel = ScheduleSecondaryEventModel.fromJson(resp);
            if (mainModel?.segementsResponse != null) {
              for (var i = 0;
                  i < (mainModel?.segementsResponse?.length ?? 0);
                  i++) {
                mainModel?.segementsResponse?[i].rowNo = i;
              }
            }
            left1stDT.clear();
            left1stDT.addAll(mainModel?.detailResponse ?? []);
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
        json: {
          "locationcode": selectLocation?.key ?? "",
          "channelCode": selectChannel?.key ?? "",
          "telecastDate": DateFormat("yyyy-MM-ddT00:00:00")
              .format(DateFormat("dd-MM-yyyy").parse(fromdateTC.text)),
        },
      );
    }
  }

  handleDoubleTapInLeft1stTable(int index) {
    left1stGridSelectedIdx = index;
    left2ndGridSelectedIdx = 0;
    timeBand.value = left1stDT[index].startTime ?? "00:00:00:00";
    programName.value = left1stDT[index].programName ?? "";
    availableTC.text = "00:02:00:00";
    scheduledTC.text = "00:00:00:00";
    left1stSM?.setCurrentCell(
        left1stSM?.getRowByIdx(index)?.cells['startTime'], index);
    left2ndDT.clear();
    if (mainModel?.segementsResponse != null) {
      left2ndDT.value = mainModel?.segementsResponse
              ?.where((element) => timeBand.value == element.telecastTime)
              .toList() ??
          [];
      countTC.text = left2ndDT.length.toString();
    }
  }

  handleDoubleTapInRightTable(int index, {bool fromAutoAdd = false}) async {
    if (left2ndDT.isEmpty) {
      LoadingDialog.showErrorDialog("ProgramSegaments can't be empty");
    } else {
      rightGridSelectedIdx = index;
      if (!fromAutoAdd) {
        rightSM?.setCurrentCell(
            rightSM?.getRowByIdx(index)?.cells['caption'], index);
      }
      // var tempRightModel = right3rdDT[index];
      var insertModel = SegementsResponse(
        eventCaption: right3rdDT[rightGridSelectedIdx]['caption'],
        breakNo: left2ndDT[left2ndGridSelectedIdx].breakNo,
        eventDuration: Utils.convertToTimeFromDouble(
            value: right3rdDT[rightGridSelectedIdx]['duration'] ?? 0),
        houseId: right3rdDT[rightGridSelectedIdx]['txId'],
        telecastTime: left2ndDT[left2ndGridSelectedIdx].telecastTime,
        eventCode: right3rdDT[rightGridSelectedIdx]['eventCode'] ?? 0,
        eventSchedulingCode:
            left2ndDT[left2ndGridSelectedIdx].eventSchedulingCode,
      );

      if (mainModel?.segementsResponse != null &&
          left2ndDT[left2ndGridSelectedIdx].rowNo != null) {
        mainModel?.segementsResponse
            ?.insert(left2ndDT[left2ndGridSelectedIdx].rowNo! + 1, insertModel);
        for (var i = 0; i < (mainModel?.segementsResponse?.length ?? 0); i++) {
          mainModel?.segementsResponse?[i].rowNo = i;
        }
      }
      left2ndDT.insert(left2ndGridSelectedIdx + 1, insertModel);
      left2ndGridSelectedIdx = left2ndGridSelectedIdx + 1;
      if (!fromAutoAdd) {
        left2ndDT.refresh();
      }
      // scheduledTC.text = Utils.convertToTimeFromDouble(value: (Utils.convertToSecond(value: scheduledTC.text)) + (tempRightModel['duration'] ?? 0));
      // if ((Utils.convertToSecond(value: scheduledTC.text)) + (tempRightModel['duration'] ?? 0) > Utils.convertToSecond(value: "00:02:00:00")) {
      //   left1stDT[left1stGridSelectedIdx].exceed = true;
      //   left1stDT.refresh();
      // }
      // countTC.text = left2ndDT.length.toString();
    }
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
      api: ApiFactory.EVENT_SEARCH,
      fun: (resp) {
        closeDialog();
        if (resp != null && resp is List<dynamic>) {
          right3rdDT.clear();
          rightGridSelectedIdx = 0;
          right3rdDT.addAll(resp);
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
        "txID": secondaryIDTC.text,
        "caption": secCaptionTC.text,
      },
    );
  }

  handleOnSelectRightTable(int index) {
    rightGridSelectedIdx = index;
    if (right3rdDT[index]['duration'] != null && index != -1) {
      rightCount.value =
          Utils.convertToTimeFromDouble(value: right3rdDT[index]['duration']);
    }
  }

  void saveData() {
    if (selectLocation == null && selectChannel == null) {
      LoadingDialog.showErrorDialog("Please select Location and Channel.");
      return;
    }
    if (mainModel?.segementsResponse == null ||
        (mainModel?.segementsResponse?.isEmpty ?? true)) {
      LoadingDialog.showErrorDialog("Nothing to save. Please schedule promos");
      return;
    }
    LoadingDialog.call();
    Get.find<ConnectorControl>().POSTMETHOD(
      api: ApiFactory.EVENT_SAVE,
      fun: (resp) {
        closeDialog();
        if (resp != null && resp.toString().contains("Record saved")) {
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
        "telecastDate": DateFormat("yyyy-MM-dd")
            .format(DateFormat("dd-MM-yyyy").parse(fromdateTC.text)),
        // "modifiedBy": Get.find<MainController>().user?.logincode,
        "scheduleSecondayEvents": mainModel?.segementsResponse
            ?.map((e) => e.toJson(fromSave: true))
            .toList(),
      },
    );
  }

  closeDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  void handleDeleteAllTap() {
    mainModel?.segementsResponse?.removeWhere((element) =>
        (element.telecastTime ==
            (left1stDT[left1stGridSelectedIdx].startTime ?? "00:00:00:00")) &&
        (element.eventCaption != null));
    handleDoubleTapInLeft1stTable(left1stGridSelectedIdx);
  }

  void handleAddFPCTap() async {
    if (right3rdDT.isEmpty) {
      LoadingDialog.showErrorDialog("Please select row");
    } else if (left2ndDT.isEmpty) {
      LoadingDialog.showErrorDialog("Please add row");
    } else {
      var temp = left2ndGridSelectedIdx;
      if (all.value) {
        if (mainModel?.segementsResponse != null) {
          int previousBreakNo = 0;
          for (int i = 0; i < left2ndDT.length; i++) {
            if (previousBreakNo != (left2ndDT[i].breakNo ?? 1)) {
              left2ndGridSelectedIdx = i;
              await handleDoubleTapInRightTable(rightGridSelectedIdx,
                  fromAutoAdd: true);
            }
            previousBreakNo = (left2ndDT[i].breakNo ?? 1);
          }
        }
      } else if (even.value) {
        if (mainModel?.segementsResponse != null) {
          int previousBreakNo = 0;
          for (int i = 0; i < left2ndDT.length; i++) {
            if (previousBreakNo != (left2ndDT[i].breakNo ?? 1) &&
                ((left2ndDT[i].breakNo ?? 1) % 2 == 0)) {
              left2ndGridSelectedIdx = i;
              await handleDoubleTapInRightTable(rightGridSelectedIdx,
                  fromAutoAdd: true);
            }
            previousBreakNo = (left2ndDT[i].breakNo ?? 1);
          }
        }
      } else if (odd.value) {
        if (mainModel?.segementsResponse != null) {
          int previousBreakNo = 0;
          for (int i = 0; i < left2ndDT.length; i++) {
            if (previousBreakNo != (left2ndDT[i].breakNo ?? 1) &&
                ((left2ndDT[i].breakNo ?? 0) % 2 != 0)) {
              left2ndGridSelectedIdx = i;
              await handleDoubleTapInRightTable(rightGridSelectedIdx,
                  fromAutoAdd: true);
            }
            previousBreakNo = (left2ndDT[i].breakNo ?? 1);
          }
        }
      }
      left2ndGridSelectedIdx = temp;
      handleDoubleTapInLeft1stTable(left1stGridSelectedIdx);
    }
  }
}

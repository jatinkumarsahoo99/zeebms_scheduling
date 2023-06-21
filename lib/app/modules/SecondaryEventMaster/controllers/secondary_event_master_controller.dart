import 'package:bms_scheduling/app/controller/MainController.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controller/ConnectorControl.dart';
import '../../../data/PermissionModel.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/Utils.dart';
import '../../../routes/app_pages.dart';
import '../../CommonSearch/views/common_search_view.dart';
import '../model/secondary_event_master_model.dart';

class SecondaryEventMasterController extends GetxController {
  List<PermissionModel>? formPermissions;
  @override
  void onInit() {
    formPermissions = Utils.fetchPermissions1(Routes.SECONDARY_EVENT_MASTER.replaceAll("/", ""));
    super.onInit();
  }

  var locationList = <DropDownValue>[].obs, channelList = <DropDownValue>[].obs;
  DropDownValue? selectedLoc, selectedChannel;
  var locFN = FocusNode();
  var selectedRadio = "".obs;
  var controllsEnabled = true.obs;
  var txNoTC = TextEditingController(),
      eventNameTC = TextEditingController(),
      txCaptionTC = TextEditingController(),
      startDateTC = TextEditingController(),
      endDateTC = TextEditingController(),
      somTC = TextEditingController(),
      // durationTC = TextEditingController(),
      eomTC = TextEditingController();
  var eventNameFN = FocusNode(), eomFN = FocusNode(), txNOFN = FocusNode();
  var duration = "00:00:00:00".obs;
  SecondaryEventModel? secondaryEventModel;
  String? eventCode;

  clearPage() {
    startDateTC.clear();
    endDateTC.clear();
    selectedLoc = null;
    eventCode = null;
    secondaryEventModel = null;
    selectedChannel = null;
    locationList.refresh();
    channelList.refresh();
    selectedRadio.value = "";
    txNoTC.clear();
    eventNameTC.clear();
    txCaptionTC.clear();
    somTC.text = "00:00:00:00";
    eomTC.text = "00:00:00:00";
    duration.value = "00:00:00:00";
    controllsEnabled.value = true;
    locFN.requestFocus();
  }

  @override
  void onReady() {
    super.onReady();
    initialAPI();
    handleONListener();
  }

  displayData() {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.SECONDARY_EVENT_MASTER_DISPLAY_DATA(txNoTC.text),
        fun: (resp) {
          closeDialog();
          if (resp != null && resp is Map<String, dynamic> && resp['display'] != null) {
            secondaryEventModel = SecondaryEventModel.fromJson(resp);
            if ((secondaryEventModel != null) && (secondaryEventModel?.display != null) && (secondaryEventModel!.display?.isNotEmpty ?? false)) {
              controllsEnabled.value = false;
              eventCode = secondaryEventModel!.display?[0].eventCode.toString();
              var tempLoc = locationList.firstWhereOrNull((element) => element.key == secondaryEventModel!.display?[0].locationCode);
              if (tempLoc != null) {
                selectedLoc = tempLoc;
                locationList.refresh();
              }
              var tempChannel = channelList.firstWhereOrNull((element) => element.key == secondaryEventModel!.display?[0].channelCode);
              if (tempChannel != null) {
                selectedChannel = tempChannel;
                channelList.refresh();
              } else if (selectedLoc != null) {
                getChannels(selectedLoc).then((value) {
                  var tempChannel2 = channelList.firstWhereOrNull((element) => element.key == secondaryEventModel!.display?[0].channelCode);
                  if (tempChannel2 != null) {
                    selectedChannel = tempChannel2;
                    channelList.refresh();
                  }
                });
              }
              if (secondaryEventModel!.display?[0].houseID != null) {
                txNoTC.text = secondaryEventModel!.display?[0].houseID ?? "";
              }
              if (secondaryEventModel!.display?[0].eventCaption != null) {
                eventNameTC.text = secondaryEventModel!.display?[0].eventCaption ?? "";
              }
              if (secondaryEventModel!.display?[0].tXcaption != null) {
                txCaptionTC.text = secondaryEventModel!.display?[0].tXcaption ?? "";
              }
              if (secondaryEventModel!.display?[0].duration != null) {
                duration.value = Utils.convertToTimeFromDouble(value: secondaryEventModel!.display?[0].duration ?? 0);
              }
              if (secondaryEventModel!.display?[0].startDate != null) {
                startDateTC.text =
                    DateFormat("dd-MM-yyyy").format(DateFormat("yyyy-MM-ddThh:mm:ss").parse(secondaryEventModel!.display![0].startDate!));
              }
              if (secondaryEventModel!.display?[0].killDate != null) {
                endDateTC.text = DateFormat("dd-MM-yyyy").format(DateFormat("yyyy-MM-ddThh:mm:ss").parse(secondaryEventModel!.display![0].killDate!));
              }
              if (secondaryEventModel!.display?[0].som != null) {
                // somTC.text = (secondaryEventModel!.display?[0].som ?? "00:00:00:00").contains("T")
                //     ? (secondaryEventModel!.display?[0].som ?? "00:00:00:00").split("T")[1]
                //     : (secondaryEventModel!.display?[0].som ?? "00:00:00:00");
                somTC.text = (secondaryEventModel!.display?[0].som ?? "00:00:00:00");
                eomTC.text = Utils.convertToTimeFromDouble(
                    value: Utils.oldBMSConvertToSecondsValue(value: somTC.text) + Utils.oldBMSConvertToSecondsValue(value: duration.value));
              }
              // if (secondaryEventModel!.display?[0].killTime != null) {
              //   var tempEOM = (secondaryEventModel!.display?[0].killTime ?? "00:00:00:00").contains("T")
              //       ? (secondaryEventModel!.display?[0].killTime ?? "00:00:00:00").split("T")[1]
              //       : (secondaryEventModel!.display?[0].killTime ?? "00:00:00:00");

              //   eomTC.text = Utils.convertToTimeFromDouble(
              //       value: Utils.oldBMSConvertToSecondsValue(value: tempEOM) + Utils.oldBMSConvertToSecondsValue(value: duration.value));
              // }
            } else {
              secondaryEventModel = null;
              controllsEnabled.value = true;
            }
          } else {
            secondaryEventModel = SecondaryEventModel();
            closeDialog();
            LoadingDialog.showErrorDialog(resp.toString());
          }
        });
  }

  initialAPI() {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
      api: ApiFactory.SECONDARY_EVENT_MASTER_INITAIL,
      fun: (resp) {
        closeDialog();
        if (resp != null && resp is Map<String, dynamic> && resp['pageload'] != null && resp['pageload']['lstlocation'] != null) {
          locationList.clear();
          locationList.addAll((resp['pageload']['lstlocation'] as List<dynamic>)
              .map((e) => DropDownValue.fromJson({
                    "key": e['locationCode'].toString(),
                    "value": e["locationName"].toString(),
                  }))
              .toList());
        }
      },
      failed: (resp) {
        closeDialog();
      },
    );
  }

  handleONListener() {
    eventNameFN.addListener(() {
      if (!eventNameFN.hasFocus) {
        txCaptionTC.text = "SEC/${eventNameTC.text}";
      }
    });
    txNOFN.addListener(() {
      if (!txNOFN.hasFocus && txNoTC.text.isNotEmpty) {
        displayData();
      }
    });
    eomFN.addListener(() {
      if (!eomFN.hasFocus) {
        try {
          num diff = (Utils.oldBMSConvertToSecondsValue(value: eomTC.text) - Utils.oldBMSConvertToSecondsValue(value: somTC.text));
          if (diff.isNegative) {
            eomTC.clear();
            LoadingDialog.showErrorDialog("EOM should not less than SOM", callback: () {
              eomFN.requestFocus();
            });
          } else {
            duration.value = Utils.convertToTimeFromDouble(value: diff);
          }
        } catch (e) {
          print(e.toString());
        }
      }
    });
  }

  Future<void> getChannels(DropDownValue? val) async {
    if (val == null) {
      LoadingDialog.showErrorDialog("Please select location.");
      return;
    }
    selectedLoc = val;
    LoadingDialog.call();
    await Get.find<ConnectorControl>().GETMETHODCALL(
      api: ApiFactory.SECONDARY_EVENT_MASTER_GET_CHANNELS(selectedLoc!.key!),
      fun: (resp) {
        closeDialog();
        if (resp != null && resp is Map<String, dynamic> && resp['channels'] != null) {
          selectedChannel = null;
          channelList.clear();
          channelList.addAll((resp['channels'] as List<dynamic>)
              .map((e) => DropDownValue.fromJson({
                    "key": e['channelCode'].toString(),
                    "value": e["channelName"].toString(),
                  }))
              .toList());
        }
      },
      failed: (resp) {
        closeDialog();
      },
    );
  }

  closeDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  saveData() {
    if (selectedLoc == null || selectedChannel == null) {
      LoadingDialog.showErrorDialog("Please select Location,Channel");
    } else {
      LoadingDialog.call();
      Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.SECONDARY_EVENT_MASTER_SAVE_DATA,
        fun: (resp) {
          closeDialog();
          if (resp != null && resp is Map<String, dynamic> && resp['save'] != null) {
            if (resp['save']['strmessage'] != null) {
              LoadingDialog.callDataSaved(msg: resp['save']['strmessage'].toString());
            } else {
              LoadingDialog.showErrorDialog(resp['save']['strmessage'].toString());
            }
          } else {
            LoadingDialog.showErrorDialog(resp.toString());
          }
        },
        json: {
          "eventCode": num.tryParse(eventCode ?? "0"),
          "houseid": txNoTC.text.trim(),
          "eventCaption": eventNameTC.text.trim(),
          "txCaption": txCaptionTC.text.trim(),
          "locationcode": selectedLoc?.key,
          "channelCode": selectedChannel?.key,
          "som": somTC.text.trim(),
          "duration": Utils.oldBMSConvertToSecondsValue(value: duration.value),
          "startdate": DateFormat("yyyy-MM-ddT00:00:00").format(DateFormat("dd-MM-yyyy").parse(startDateTC.text)),
          "killdate": DateFormat("yyyy-MM-ddT00:00:00").format(DateFormat("dd-MM-yyyy").parse(endDateTC.text)),
          "killtime": DateFormat("yyyy-MM-ddT00:00:00").format(DateFormat("dd-MM-yyyy").parse(endDateTC.text)),
          "modifiedby": Get.find<MainController>().user?.logincode,
          "optBug": selectedRadio.value == "Bug",
          "optAstonLoop": selectedRadio.value == "Aston",
        },
      );
    }
  }

  formHandler(String btnName) {
    if (btnName == "Clear") {
      clearPage();
    } else if (btnName == "Save") {
      if (secondaryEventModel != null) {
        LoadingDialog.recordExists("This Event already exists.\nDo you want to modify it?", () {
          saveData();
        });
      } else {
        saveData();
      }
    } else if (btnName == "Search") {
      Get.to(
        SearchPage(
          key: Key("Non Commercial Secondary Events"),
          screenName: "Non Commercial Secondary Events",
          appBarName: "Non Commercial Secondary Events",
          strViewName: "BMS_view_secondaryEventMaster",
          isAppBarReq: true,
        ),
      );
    }
  }
}

import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/ConnectorControl.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/Utils.dart';

class SecondaryEventMasterController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    txCaptionFN.addListener(() {
      if (!txCaptionFN.hasFocus) {
        var tempText = txCaptionTC.text;
        if (tempText.isNotEmpty && !(tempText.startsWith("SEC/"))) {
          txCaptionTC.text = "SEC/$tempText";
        }
      }
    });
  }

  var locationList = <DropDownValue>[].obs, channelList = <DropDownValue>[].obs;
  DropDownValue? selectedLoc, selectedChannel;
  var locFN = FocusNode();
  var selectedRadio = "Bug".obs;
  var controllsEnabled = true.obs;
  var txNoTC = TextEditingController(),
      eventNameTC = TextEditingController(),
      txCaptionTC = TextEditingController(),
      startDateTC = TextEditingController(),
      endDateTC = TextEditingController(),
      somTC = TextEditingController(),
      durationTC = TextEditingController(),
      eomTC = TextEditingController();
  var txCaptionFN = FocusNode();

  clearPage() {
    selectedLoc = null;
    selectedChannel = null;
    locationList.refresh();
    channelList.refresh();
    selectedRadio.value = "Bug";
    txNoTC.clear();
    eventNameTC.clear();
    txCaptionTC.clear();
    somTC.text = "00:00:00:00";
    eomTC.text = "00:00:00:00";
    durationTC.text = "00:00:00:00";
    controllsEnabled.value = true;
    locFN.requestFocus();
  }

  initialAPI() {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
      api: ApiFactory.FINAL_REPORT_BT_INITAIL,
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

  getChannels(DropDownValue? val) {
    if (val == null) {
      LoadingDialog.showErrorDialog("Please select location.");
      return;
    }
    selectedLoc = val;
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
      api: ApiFactory.FINAL_REPORT_BT_GET_CHANNELS(selectedLoc!.key!),
      fun: (resp) {
        closeDialog();
        if (resp != null && resp is Map<String, dynamic> && resp['channels'] != null) {
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

  calculateDuration() {
    try {
      num diff = (Utils.oldBMSConvertToSecondsValue(value: somTC.text) - Utils.oldBMSConvertToSecondsValue(value: eomTC.text));
      if (diff.isNegative) {
        LoadingDialog.showErrorDialog("EOM should not less than SOM");
      } else {
        durationTC.text = Utils.convertToTimeFromDouble(value: diff);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  saveData() {
    if (selectedLoc == null || selectedChannel == null) {
      LoadingDialog.showErrorDialog("Please select Location,Channel");
    } else {}
  }

  formHandler(String string) {}
}

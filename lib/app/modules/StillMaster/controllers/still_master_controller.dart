import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StillMasterController extends GetxController {
  var locationList = <DropDownValue>[].obs, channelList = <DropDownValue>[].obs, tapeList = <DropDownValue>[].obs;
  DropDownValue? selectedChannel, selectedLocation, selectedProgram, selectedTape;
  var programPickerList = [];
  var locationFN = FocusNode();
  var firststSelectedRadio = "Opening".obs, secondSelectedRadio = "Dated".obs;
  var captionTC = TextEditingController(),
      txCaptionTC = TextEditingController(),
      tapIDTC = TextEditingController(),
      segTC = TextEditingController(),
      houseIDTC = TextEditingController(),
      somTC = TextEditingController(),
      eomTC = TextEditingController(),
      copyTC = TextEditingController();
  var duration = "00:00:00:00".obs;

  @override
  void onReady() {
    super.onReady();
    initialAPI();
  }

  clearPage() {
    selectedTape = null;
    selectedChannel = null;
    selectedLocation = null;
    selectedProgram = null;
    programPickerList.clear();
    locationList.refresh();
    channelList.refresh();
    captionTC.clear();
    copyTC.clear();
    tapIDTC.text = "AUTO";
    houseIDTC.text = "AUTO";
    segTC.text = "1";
    txCaptionTC.clear();
    firststSelectedRadio.value = "Opening";
    secondSelectedRadio.value = "Dated";
    duration.value = "00:00:00:00";
    somTC.text = "00:00:00:00";
    eomTC.text = "00:00:00:00";
    locationFN.requestFocus();
  }

  handleOnChangedProgram(DropDownValue? val) {
    selectedProgram = val;
  }

  initialAPI() {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
      api: ApiFactory.STILL_MASTER_FORM_LOAD,
      fun: (resp) {
        closeDialog();
        if (resp != null && resp is Map<String, dynamic> && resp['pageload'] != null && resp['pageload']['lstLocaction'] != null) {
          locationList.clear();
          locationList.addAll((resp['pageload']['lstLocaction'] as List<dynamic>)
              .map((e) => DropDownValue.fromJson({
                    "key": e['locationCode'].toString(),
                    "value": e["locationName"].toString(),
                  }))
              .toList());
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

  formHandler(String btnName) {
    if (btnName == "Save") {
    } else if (btnName == "Clear") {
      clearPage();
    } else if (btnName == "Refresh") {
      refreshPage();
    }
  }

  closeDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  refreshPage() {
    initialAPI();
  }

  getChannels(DropDownValue? val) {
    if (val == null) {
      LoadingDialog.showErrorDialog("Please select location.");
      return;
    }
    selectedLocation = val;
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
      api: ApiFactory.STILL_MASTER_GET_CHANNELS(selectedLocation!.key!),
      fun: (resp) {
        closeDialog();
        if (resp != null && resp is Map<String, dynamic> && resp['listchannel'] != null) {
          selectedChannel = null;
          channelList.clear();
          channelList.addAll((resp['listchannel'] as List<dynamic>)
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
}

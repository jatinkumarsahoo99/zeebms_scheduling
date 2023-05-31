import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/controller/MainController.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart' show FocusNode;

class SlideMasterController extends GetxController {
  String strCode = "";
  var controllsEnable = true.obs;
  @override
  void onReady() {
    super.onReady();
    getOnLoadData();
    tapIDFN.addListener(() {
      if (!tapIDFN.hasFocus) {
        retriveData();
      }
    });
  }

  var tapIDFN = FocusNode();
  var isDated = true.obs;
  var selectedRadio = "Dated".obs;

  var locationList = <DropDownValue>[].obs, channelList = <DropDownValue>[].obs;
  var tapeTypeList = <Map<String, dynamic>>[].obs;
  var slideTypeList = <Map<String, dynamic>>[].obs;

  var houseIDCtr = TextEditingController(),
      txCaptionCtr = TextEditingController(),
      segNoCtr = TextEditingController(),
      tapeIDCtr = TextEditingController(),
      captionCtr = TextEditingController(),
      somCtr = TextEditingController(),
      eomCtr = TextEditingController(),
      durationCtr = TextEditingController(),
      updateTodateCtr = TextEditingController();

  DropDownValue? selectedLocation, selectedChannel, selectedTape, selectedSlide;

  clearData() {
    selectedLocation = null;
    selectedChannel = null;
    selectedTape = null;
    selectedSlide = null;
    txCaptionCtr.clear();
    segNoCtr.text = "1";
    tapeIDCtr.text = "AUTO";
    houseIDCtr.text = "AUTO";
    // houseIDCtr.clear();
    controllsEnable.value = true;
    captionCtr.clear();
    somCtr.text = "00:00:00:00";
    eomCtr.text = "00:00:00:00";
    durationCtr.text = "00:00:00:00";
    selectedRadio.value = "Dated";
    locationList.refresh();
    channelList.refresh();
    tapeTypeList.refresh();
    slideTypeList.refresh();
  }

  formHandler(String string) {}

  handleOnChangedTapeType(DropDownValue? val) {
    selectedTape = val;
  }

  fillDataInUI(Map<String, dynamic> data) {}

  handleOnChangedSlideType(DropDownValue? val) {
    selectedSlide = val;
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

  handleOnChangedChannel(DropDownValue? val) {
    selectedChannel = val;
  }

  retriveData() {
    if (segNoCtr.text.isNotEmpty) {
      strCode = "";
      closeDialogIfOpen();
      LoadingDialog.call();
      Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.SLIDE_MASTER_RETRIVE_DATA,
        fun: (resp) {
          closeDialogIfOpen();
          if (resp != null && resp is Map<String, dynamic> && resp['tapeIDLeave'] != null) {
          } else {
            LoadingDialog.showErrorDialog(resp.toString());
          }
        },
        json: {
          "exportTapeCode": tapeIDCtr.text,
          "segmentNumber": segNoCtr.text,
          "code": strCode,
          "houseID": houseIDCtr.text,
          "eventType": "",
        },
      );
    }
  }

  getOnLoadData() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.SLIDE_MASTER_ON_LOAD(Get.find<MainController>().user!.logincode!),
        fun: (resp) {
          closeDialogIfOpen();
          if (resp != null && resp is Map<String, dynamic> && resp['onLoad_SlideMaster'] != null) {
            locationList.value.addAll((resp['onLoad_SlideMaster']['lstlocations'] as List<dynamic>)
                .map((e) => DropDownValue(
                      key: e['locationCode'].toString(),
                      value: e['locationName'].toString(),
                    ))
                .toList());
            for (var element in resp['onLoad_SlideMaster']['lstSlideType']) {
              slideTypeList.add(element);
            }
            for (var element in resp['onLoad_SlideMaster']['lstTapeType']) {
              tapeTypeList.add(element);
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

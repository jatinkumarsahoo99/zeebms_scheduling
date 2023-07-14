import 'dart:developer';

import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/LoadingDialog.dart';
import '../../../../widgets/Snack.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/Utils.dart';
import '../RetriveDataModel.dart';

class ComingUpMenuController extends GetxController {
  //TODO: Implement ComingUpMenuController
  bool isEnable = true;

  final count = 0.obs;
  var clientDetails = RxList<DropDownValue>();
  DropDownValue? selectedClientDetails;
  var controllsEnabled = true.obs;
  var selectedRadio = "".obs;

  FocusNode tapeIdFocus = FocusNode();
  FocusNode segNoFocus = FocusNode();
  FocusNode houseIdFocus = FocusNode();
  FocusNode locationFocus = FocusNode();
  FocusNode channelFocus = FocusNode();

  RxList<DropDownValue> locationList = RxList([]);
  RxList<DropDownValue> channelList = RxList([]);
  RxList<DropDownValue> programList = RxList([]);
  RxList<DropDownValue> programTypeList = RxList([]);

  DropDownValue? selectedLocation;
  DropDownValue? selectedChannel;
  DropDownValue? selectedProgram;
  DropDownValue? selectedProgramType;

  TextEditingController tapeIdController = TextEditingController();
  TextEditingController segNoController = TextEditingController();
  TextEditingController houseIdController = TextEditingController();
  TextEditingController programController = TextEditingController();
  TextEditingController txCaptionController = TextEditingController();
  TextEditingController somController = TextEditingController();
  TextEditingController eomController = TextEditingController();
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();

  Rx<TextEditingController> durationController = TextEditingController().obs;
  TextEditingController uptoDateController = TextEditingController();
  TextEditingController menuDateController = TextEditingController();
  num sec = 0;
  String strCode = "";
  String strTapeID = "";
  bool isListenerActive = false;

  RxString duration=RxString("00:00:00:00");

  @override
  void onInit() {
    fetchPageLoadData();
    tapeIdFocus.addListener(() {
      if (!tapeIdFocus.hasFocus) {
        txtTapeIDLeave();
      }
    });
    super.onInit();
  }

  clearAll() {
    Get.delete<ComingUpMenuController>();
    Get.find<HomeController>().clearPage1();
  }

  fetchPageLoadData() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.COMING_UP_MENU_MASTER_LOAD,
        fun: (Map map) {
          // if (map is List && map.isNotEmpty) {
          locationList.clear();
          for (var e in map["location"]) {
            locationList.add(DropDownValue.fromJsonDynamic(
                e, "locationCode", "locationName"));
          }
          // } else {
          //   locationList.clear();
          // }
        });
  }

  fetchListOfChannel(String code) {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.COMING_UP_MENU_MASTER_CHANNELLIST + code,
        fun: (map) {
          channelList.clear();
          // if (map is List && map.isNotEmpty) {
          for (var e in map["channel"]) {
            channelList.add(
                DropDownValue.fromJsonDynamic(e, "channelCode", "channelName"));
          }
          // } else {
          //   channelList.clear();
          // }
        });
  }

  void calculateDuration() {
    num secondSom =
        Utils.oldBMSConvertToSecondsValue(value: (somController.text));
    num secondEom =
        Utils.oldBMSConvertToSecondsValue(value: eomController.text);
    durationController.value.text =
        Utils.convertToTimeFromDouble(value: secondEom - secondSom);

    sec =
        Utils.oldBMSConvertToSecondsValue(value: durationController.value.text);

    print(">>>>>>>>>" + durationController.value.text);
    print(">>>>>>>>>" + sec.toString());
  }

  validateAndSaveRecord() {
    if (selectedLocation == null) {
      Snack.callError("Please select Location Name.");
    } else if (selectedChannel == null) {
      Snack.callError("Please select Channel Name.");
    } else if (tapeIdController.text == null || tapeIdController.text == "") {
      Snack.callError("Tape ID cannot be empty.");
    } else if (segNoController.text == null || segNoController.text == "") {
      Snack.callError("Segment No. cannot be empty.");
    } else if (houseIdController.text == null || houseIdController.text == "") {
      Snack.callError("House ID cannot be empty.");
    } else if (txCaptionController.text == null ||
        txCaptionController.text == "") {
      Snack.callError("Export Tape Caption cannot be empty.");
    } else if (somController.text == null || somController.text == "") {
      Snack.callError("Please enter SOM.");
    } else if (eomController.text == null ||
        eomController.text == "" ||
        eomController.text == "00:00:00:00") {
      Snack.callError("Please enter EOM.");
    } else if (durationController.value.text == null ||
        durationController.value.text == "" ||
        durationController.value.text == "00:00:00:00") {
      Snack.callError("Duration cannot be empty or 00:00:00:00.");
    } else if (selectedRadio == null) {
      Snack.callError("Please mark Dated.");
    } else {
      Map<String, dynamic> postData = {
        "menuCode": strCode,
        "locationCode": selectedLocation?.key ?? "",
        "channelCode": selectedChannel?.key ?? "",
        "exportTapeCaption": txCaptionController.text,
        "exportTapeCode": tapeIdController.text,
        "segmentNumber": segNoController.text,
        "houseId": houseIdController.text,
        "menuDate": menuDateController.text,
        "menuDuration": sec,
        "som": somController.text,
        "menuStartTime": startTimeController.text,
        "menuEndTime": endTimeController.text,
        "dated": "Y",
        "killDate": DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ")
            .format(DateFormat("dd-MM-yyyy").parse(uptoDateController.text)),
        "modifiedBy": Get.find<MainController>().user?.logincode ?? "",
        "eom": eomController.text
      };
      log(">>>>>>>>>>" + postData.toString());
      Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.COMING_UP_MENU_MASTER_SAVE,
          json: postData,
          fun: (map) {
            log(">>>>" + map.toString());
            if (map != null) {}
          });
    }
  }

  void checkRetrieve() {
    strCode = "";
    retrieveRecord(tapeIdController.text.trim(), segNoController.text.trim(),
        houseIdController.text);
  }

  void retrieveRecord(String tapeId, String segNo, String houseID) {
    Map<String, dynamic> data = {
      "menuCode": Null,
      "segmentNumber": segNo,
      "exportTapeCode": tapeId,
      "houseId": houseID
    };
    print(">>>>" + data.toString());
    Get.find<ConnectorControl>().GET_METHOD_WITH_PARAM(
        api: ApiFactory.COMING_UP_MENU_MASTER_GET_RETRIVERECORD,
        json: data,
        fun: (map) {
          log(">>>>" + map.toString());
          if (map is Map &&
              map.containsKey("retrive") &&
              map["retrive"] != null) {
            Map<String, dynamic> responseMap = map["retrive"][0];
            RetriveDataModel retriveDataModel=RetriveDataModel.fromJson(responseMap);
            txCaptionController.text=retriveDataModel.exportTapeCaption??"";
            segNoController.text=retriveDataModel.segmentNumber.toString()??"";
            somController.text=retriveDataModel.som.toString()??"";
            eomController.text=retriveDataModel.eom.toString()??"";
            startTimeController.text=retriveDataModel.menuStartTime.toString()??"";
            endTimeController.text=retriveDataModel.menuEndTime.toString()??"";
            duration.value=retriveDataModel.menuEndTime.toString()??"";
          }
        });
  }

  String replaceInvalidChar(String text, {bool upperCase = false}) {
    text = text.trim();
    if (upperCase == false) {
      text = text.toLowerCase();
      text = text
          .split(' ')
          .map((word) =>
              word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '')
          .join(' ');
    } else {
      text = text.toUpperCase();
    }
    text = text.replaceAll("'", "`");
    return text;
  }

  Future<String> CheckExportTapeCode(String tapeId, String segNo,
      String strCode, String houseId, String api) async {
    Map<String, dynamic> data = {
      "exportTapeCode": tapeId,
      "segmentNumber": segNo,
      "code": strCode,
      "houseID": houseId,
      "eventType": ""
    };

    await Get.find<ConnectorControl>().POSTMETHOD(
        api: api,
        json: data,
        fun: (map) {
          log(">>>>" + map.toString());
          if (map != null) {
            return "";
          }
          return "";
        });
    return "";
  }

  void txtTapeIDLeave() {
    if (tapeIdController.text != "") {
      tapeIdController.text =
          replaceInvalidChar(tapeIdController.text, upperCase: true);
      houseIdController.text = tapeIdController.text;
      checkRetrieve();
      if (tapeIdController.text != "" &&
          (segNoController.text != "" && segNoController.text != "0")) {
        String res = CheckExportTapeCode(
            tapeIdController.text,
            segNoController.text,
            strCode,
            "",
            ApiFactory.COMING_UP_MENU_MASTER_TAPEIDLEAVE) as String;
        if (res != "") {
          LoadingDialog.recordExists(
              "Tape ID & Segment Number you entered is already used for " +
                  res.toString(), () {
            isEnable = true;
            isListenerActive = false;
            if (strCode != "") {
              tapeIdController.text = strTapeID;
            } else {
              // tapeIdController.text ="";
              print(">>>");
            }
            // update(['updateLeft']);
          }, cancel: () {
            Get.back();
          });
        }
      }
    }
  }

  void txtSegNoLeave() {
    if (segNoController.text == "") {
      segNoController.text = "0";
    }
    segNoController.text =
        replaceInvalidChar(segNoController.text, upperCase: true);
    checkRetrieve();
    if (tapeIdController.text != "" &&
        (segNoController.text != "" && segNoController.text != "0")) {
      String res = CheckExportTapeCode(
          tapeIdController.text,
          segNoController.text,
          strCode,
          "",
          ApiFactory.COMINGUPTOMORROWMASTER_SEGNOLEAVE) as String;
      if (res != "") {
        LoadingDialog.recordExists(
            "Tape ID & Segment Number you entered is already used for " +
                res.toString(), () {
          isEnable = true;
          isListenerActive = false;
          if (strCode != "") {
            // tapeIdController.text = strTapeID;
            print(">>>>>" + segNoController.text);
          } else {
            // segNoController.text ="";
            print(">>>>>");
          }
          // update(['updateLeft']);
        }, cancel: () {
          Get.back();
        });
      }
    }
  }

  void txtHouseIDLeave() {
    if (houseIdController.text != "") {
      houseIdController.text =
          replaceInvalidChar(houseIdController.text, upperCase: true);
      if (houseIdController.text != "") {
        String res = CheckExportTapeCode(
            "",
            "",
            strCode,
            houseIdController.text,
            ApiFactory.COMINGUPTOMORROWMASTER_HOUSEIDLEAVE) as String;
        if (res != "") {
          LoadingDialog.recordExists(
              "House ID you entered is already used for " + res.toString(), () {
            isEnable = true;
            isListenerActive = false;
            if (strCode != "") {
              // tapeIdController.text = strTapeID;
              print(">>>>>" + houseIdController.text);
            } else {
              // houseIdController.text ="";
              print(">>>>>" + houseIdController.text);
            }
            // update(['updateLeft']);
          }, cancel: () {
            Get.back();
          });
        }
      }
    }
  }

  formHandler(String string) {}
}

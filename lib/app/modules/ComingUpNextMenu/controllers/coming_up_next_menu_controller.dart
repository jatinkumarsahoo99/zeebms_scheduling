import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/LoadingDialog.dart';
import '../../../../widgets/Snack.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/Utils.dart';
import '../../CommonSearch/views/common_search_view.dart';
import '../CommingUpNextRetriveModel.dart';

class ComingUpNextMenuController extends GetxController {
  //TODO: Implement ComingUpNextMenuController

  bool isEnable = true;
  Rx<bool> isEnable1 = Rx<bool>(true);

  RxList<DropDownValue> locationList = RxList([]);
  RxList<DropDownValue> channelList = RxList([]);
  RxList<DropDownValue> programList = RxList([]);

  final count = 0.obs;
  var clientDetails = RxList<DropDownValue>();
  DropDownValue? selectedClientDetails;
  var disableRadio = true.obs;
  var selectedRadio = "Dated".obs;

  FocusNode tapeIdFocus = FocusNode();
  FocusNode segNoFocus = FocusNode();

  FocusNode houseIdFocus = FocusNode();
  FocusNode locationFocus = FocusNode();
  FocusNode channelFocus = FocusNode();

  Rxn<DropDownValue>? selectedLocation = Rxn<DropDownValue>(null);
  Rxn<DropDownValue>? selectedChannel = Rxn<DropDownValue>(null);
  Rxn<DropDownValue>? selectedProgram = Rxn<DropDownValue>(null);

  TextEditingController tapeIdController = TextEditingController();
  TextEditingController segNoController = TextEditingController(text: "1");
  TextEditingController houseIdController = TextEditingController();
  TextEditingController programController = TextEditingController();
  TextEditingController txCaptionController = TextEditingController();
  TextEditingController somController = TextEditingController();
  TextEditingController eomController = TextEditingController();
  // TextEditingController durationController = TextEditingController();
  TextEditingController uptoDateController = TextEditingController();
  DateTime startDate = DateTime.now();

  TextEditingController durationController = TextEditingController();
  RxString duration = RxString("00:00:00:00");

  String? strCode = "";
  String? strSegmentNumber = "";
  String strTapeID = "";
  String strHouseID = "";
  // String strS  egmentNumber = "";
  //HCLP0045

  fetchPageLoadData() {
    LoadingDialog.call();

    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.COMINGUPNEXTMASTER_NEW_LOAD,
        fun: (map) {
          closeDialogIfOpen();
          if (map is List && map.isNotEmpty) {
            locationList.clear();
            for (var e in map) {
              locationList.add(DropDownValue.fromJsonDynamic(
                  e, "locationCode", "locationName"));
            }
          } else {
            locationList.clear();
          }
        });
  }

  fetchListOfChannel(String code) {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.COMINGUPNEXTMASTER_GET_CHANNEL + code,
        fun: (map) {
          closeDialogIfOpen();
          channelList.clear();
          List<DropDownValue> dataList = [];
          if (map is List && map.isNotEmpty) {
            for (var e in map) {
              dataList.add(DropDownValue.fromJsonDynamic(
                  e, "channelcode", "channelName"));
            }
            channelList.addAll(dataList);
          } else {
            channelList.clear();
          }
        });
  }

  num sec = 0;
  void calculateDuration() {
    num secondSom =
        Utils.oldBMSConvertToSecondsValue(value: (somController.text));
    num secondEom =
        Utils.oldBMSConvertToSecondsValue(value: eomController.text);

    if (eomController.text.length >= 11) {
      if ((secondEom - secondSom) < 0) {
        LoadingDialog.showErrorDialog("EOM should not be less than SOM.");
      } else {
        durationController.text =
            Utils.convertToTimeFromDouble(value: secondEom - secondSom);
        duration.value =
            Utils.convertToTimeFromDouble(value: secondEom - secondSom);

        sec = Utils.oldBMSConvertToSecondsValue(
            value: durationController.value.text);
      }
    }
  }

  clearAll() {
    Get.delete<ComingUpNextMenuController>();
    Get.find<HomeController>().clearPage1();
  }

  validateAndSaveRecord() {
    if (strCode != null && strCode != "") {
      LoadingDialog.recordExists(
          "Record Already exist!\nDo you want to modify it?", () {
        callSaveApi();
      });
    } else {
      callSaveApi();
    }
  }

  callSaveApi() {
    if (selectedLocation == null) {
      Snack.callError("Please select Location Name.");
    } else if (selectedChannel == null) {
      Snack.callError("Please select Channel Name.");
    } else if (tapeIdController.text == null || tapeIdController.text == "") {
      Snack.callError("Tape ID cannot be empty.");
    } else if (segNoController.text == null || segNoController.text == "") {
      Snack.callError("Segment No. cannot be empty.");
    } else if (segNoController.text == "0") {
      Snack.callError("Segment No. cannot be ZERO.");
    } else if (houseIdController.text == null || houseIdController.text == "") {
      Snack.callError("House ID cannot be empty.");
    } else if (txCaptionController.text == null ||
        txCaptionController.text == "") {
      Snack.callError("Export Tape Caption cannot be empty.");
    } else if (selectedProgram == null) {
      Snack.callError("Please select Program.");
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
      Snack.callError("Please mark Dated / Non-Dated.");
    } else {
      Map<String, dynamic> postData = {
        "cunCode": strCode,
        "channelCode": selectedChannel?.value?.key ?? "",
        "houseID": houseIdController.text,
        "exportTapeCode": tapeIdController.text,
        "programCode": selectedProgram?.value?.key ?? "",
        // "programTypeCode": "",
        // "originalRepeatCode": "string",
        "exportTapeCaption": txCaptionController.text,
        "segmentNumber": segNoController.text,
        "slideDuration": sec,
        "som": somController.text,
        // "activeNonActive": "string",
        "dated": ((selectedRadio.value == "Dated") ? "Y" : "N"),
        // "killDate": "2023-07-11T15:06:29.531Z",
        "killDate": DateFormat("yyyy-MM-ddTHH:mm:ss")
            .format(DateFormat("dd-MM-yyyy").parse(uptoDateController.value.text)),
        "modifiedBy": Get.find<MainController>().user?.logincode ?? "",
        "locationCode": selectedLocation?.value?.key ?? "",
        "eom": eomController.text
      };
      LoadingDialog.call();
      Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.COMINGUPNEXTMASTER_SAVE,
          json: postData,
          fun: (map) {
            Get.back();
            if (map != null && map is Map && map.containsKey("message")) {
              if (strCode != "") {
                Snack.callSuccess(map['message'] ?? "Record is updated successfully.");
              } else {
                strCode = map['cunCode'];
                tapeIdController.text = map['exportTapeCode'];
                houseIdController.text= map['houseID'];
                Snack.callSuccess(map['message'] ?? "Record is inserted successfully.");
              }
            } else {
              Snack.callError((map ?? "Something went wrong").toString());
            }
          });
    }
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

  CommingUpNextRetriveModel? commingUpNextRetriveModel;
  void checkRetrieve({bool isTapeId = false}) {
    if (segNoController.text.trim() != "" &&
        tapeIdController.text.trim() != "") {
      strCode = "";
      retrieveRecord(tapeIdController.text.trim(), segNoController.text.trim(),
          isTapeId: isTapeId);
    }
  }

  void retrieveRecord(String tapeId, String? segNo, {bool isTapeId = false}) {
    LoadingDialog.call();
    // "HCLP0045"
    Map<String, dynamic> data = {
      "SegmentNumber": int.parse((segNo != null && segNo != "")?segNo:"0"),
      "ExportTapeCode": tapeId,
    };
    Get.find<ConnectorControl>().GET_METHOD_WITH_PARAM(
        api: ApiFactory.COMINGUPNEXTMASTER_GET_RETRIVE_RECORD,
        json: data,
        fun: (map) {
          closeDialogIfOpen();
          if (map is Map  && map.containsKey("lstComingUpNextMenu") &&
              map['lstComingUpNextMenu'] != null ) {
            commingUpNextRetriveModel =
                CommingUpNextRetriveModel.fromJson(map['lstComingUpNextMenu'][0]);
            strCode = commingUpNextRetriveModel?.cunCode ?? "";

            startDate = (DateFormat("yyyy-MM-ddTHH:mm:ss")
                .parse(commingUpNextRetriveModel!.killDate!));

            durationController.text =
                commingUpNextRetriveModel?.slideDuration.toString() ?? "";

            strTapeID = commingUpNextRetriveModel?.exportTapeCode ?? "";
            strHouseID = commingUpNextRetriveModel?.houseID ?? "";
            strSegmentNumber =
                (commingUpNextRetriveModel?.segmentNumber ?? "").toString();

            for (var element in locationList) {
              if (element.key.toString().trim() ==
                  commingUpNextRetriveModel!.locationCode.toString().trim()) {
                selectedLocation?.value = DropDownValue(
                    key: commingUpNextRetriveModel!.locationCode ?? "",
                    value: element.value);
                break;
              }
            }

            segNoController.text =
                (commingUpNextRetriveModel?.segmentNumber ?? 0).toString();
            houseIdController.text = commingUpNextRetriveModel?.houseID ?? "";

            selectedProgram?.value = DropDownValue(
                key: commingUpNextRetriveModel?.programCode ?? "",
                value: commingUpNextRetriveModel?.programName??"");

            txCaptionController.text =
                commingUpNextRetriveModel?.exportTapeCaption ?? "";
            strCode = commingUpNextRetriveModel?.cunCode ?? "";
            somController.text =
                (commingUpNextRetriveModel?.som) ?? "00:00:00:00";
            eomController.text =
                (commingUpNextRetriveModel?.eom) ?? "00:00:00:00";

            uptoDateController.text = (DateFormat("dd-MM-yyyy").format(
                DateFormat("yyyy-MM-ddTHH:mm:ss")
                    .parse(commingUpNextRetriveModel!.killDate!)))
                .toString();

            print(">>>>>>>>>date"+uptoDateController.text);
            print(">>>>>>>>>date"+(startDate).toString());
            print(">>>>>>>>>>>>>>>"+DateTime.now().toString());
            update(['date']);
            calculateDuration();
            isEnable1.value = false;
            if (commingUpNextRetriveModel != null &&
                commingUpNextRetriveModel?.dated == "N") {
              selectedRadio.value = "Non-Dated";
            } else {
              selectedRadio.value = "Dated";
            }
            selectedRadio.refresh();
            isEnable1.refresh();
            if(map.containsKey("lstChannel") && map['lstChannel'] != null && map['lstChannel'].length >0){
              channelList.clear();
              List<DropDownValue> dataList = [];
              map['lstChannel'].forEach((e){
                dataList.add(DropDownValue.fromJsonDynamic(e, "channelcode", "channelName"));
              });
              channelList.addAll(dataList);
              for (var element in channelList) {
                if (element.key.toString().trim() ==
                    commingUpNextRetriveModel!.channelCode.toString().trim()) {
                  selectedChannel?.value = DropDownValue(
                      key: commingUpNextRetriveModel!.channelCode ?? "",
                      value: element.value);
                  break;
                }
              }
            }
            selectedLocation?.refresh();
            selectedChannel?.refresh();
            selectedProgram?.refresh();

            checkCode(isTapeId: isTapeId);
          } else {
            commingUpNextRetriveModel = null;
            strCode = "";
            checkCode(isTapeId: isTapeId);
          }
        });
  }

  Future<String> checkExportTapeCode(String tapeId, String segNo,
      String strCode, String houseId, String api) async {
    Completer<String> completer = Completer<String>();
    Map<String, dynamic> data = {
      "exportTapeCode": tapeId,
      "segmentNumber": segNo,
      "code": strCode,
      "houseID": houseId
    };
    String res = "";
    try {
      await Get.find<ConnectorControl>().GET_METHOD_WITH_PARAM(
          api: api,
          json: data,
          fun: (map) {
            if (map is Map &&
                map.containsKey('eventName') &&
                map['eventName'] != null &&
                map['eventName'] != "null") {
              res = map['eventName'];
              completer.complete(res);
            } else {
              completer.complete(res);
            }
          });
    } catch (e) {
      completer.complete(res);
    }
    return completer.future;
  }

  Future<void> txtTapeIDLeave() async {
    if (tapeIdController.text != "") {
      tapeIdController.text =
          replaceInvalidChar(tapeIdController.text, upperCase: true);
      houseIdController.text = tapeIdController.text;
      checkRetrieve(isTapeId: true);
    }
  }

  void txtSegNoLeave() async {
    if (segNoController.text == "") {
      segNoController.text = "0";
    }
    segNoController.text =
        replaceInvalidChar(segNoController.text, upperCase: true);
    checkRetrieve(isTapeId: false);
  }

  checkCode({bool isTapeId = false}) async {
    if (isTapeId) {
      if (tapeIdController.text != "" &&
          (segNoController.text != "" && segNoController.text != "0")) {
        String res = "";
        await checkExportTapeCode(tapeIdController.text, segNoController.text,
                strCode ?? "", "", ApiFactory.COMINGUPNEXTMASTER_TAPEIDLEAVE)
            .then((value) {
          res = value;
        });
        
        if (res != "") {
          LoadingDialog.callInfoMessage(
            res ??
                "Tape ID & Segment Number you entered is already used for " +
                    "coming up next",
            callback: () {
              isEnable = true;

              if (strCode != "") {
                tapeIdController.text = strTapeID;
                // update(['top']);
              } else {
                tapeIdController.text = "";
                tapeIdFocus.requestFocus();

                // update(['top']);
              }
              // update(['updateLeft']);
            },
          );
        }
      }
    } else {
      if (tapeIdController.text != "" &&
          (segNoController.text != "" && segNoController.text != "0")) {
        String res = "";
        await checkExportTapeCode(tapeIdController.text, segNoController.text,
                strCode ?? "", "", ApiFactory.COMINGUPNEXTMASTER_SEGNOLEAVE)
            .then((value) {
          res = value;
        });
        if (res != "") {
          LoadingDialog.callInfoMessage(
            res ?? "",
            callback: () {
              isEnable = true;
              if (strCode != "") {
                segNoController.text = strSegmentNumber ?? "0";
              } else {
                segNoController.text = "";
                segNoFocus.requestFocus();
              }
              // update(['updateLeft']);
            },
          );
        }
      }
    }
  }

  Future<void> txtHouseIDLeave() async {
    if (houseIdController.text != "") {
      houseIdController.text =
          replaceInvalidChar(houseIdController.text, upperCase: true);
      if (houseIdController.text != "") {
        String res = "";
        await checkExportTapeCode("", "", strCode ?? "", houseIdController.text,
                ApiFactory.COMINGUPNEXTMASTER_HOUSEIDLEAVE)
            .then((value) {
          res = value;
        });
        if (res != "") {
          LoadingDialog.callInfoMessage(
            res ??
                "House ID you entered is already used for " + "coming up next",
            callback: () {
              isEnable = true;
              if (strCode != "") {
                houseIdController.text = strHouseID;
              } else {
                houseIdController.text = "";
                houseIdFocus.requestFocus();
              }
              // update(['updateLeft']);
            },
          );
        }
      }
    }
  }

  closeDialogIfOpen() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  @override
  void onInit() {

    segNoFocus = FocusNode(
      onKeyEvent: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.tab) {
          txtSegNoLeave();
          return KeyEventResult.ignored;
        }
        return KeyEventResult.ignored;
      },
    );
    houseIdFocus = FocusNode(
      onKeyEvent: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.tab) {
          txtHouseIDLeave();
          return KeyEventResult.ignored;
        }
        return KeyEventResult.ignored;
      },
    );
    tapeIdFocus = FocusNode(
      onKeyEvent: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.tab) {
          txtTapeIDLeave();
          return KeyEventResult.ignored;
        }
        return KeyEventResult.ignored;
      },
    );

    super.onInit();
  }

  @override
  void onReady() {
    fetchPageLoadData();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  formHandler(String string) {
    if (string == "Save") {
      validateAndSaveRecord();
    } else if (string == "Clear") {
      clearAll();
    } else if (string == "Search") {
      Get.to(
        const SearchPage(
          key: Key("Coming Up Next Master"),
          screenName: "Coming Up Next Master",
          appBarName: "Coming Up Next Master",
          strViewName: "vTesting",
          isAppBarReq: true,
        ),
      );
    }
  }

  void increment() => count.value++;
}

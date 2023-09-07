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
import '../../ComingUpNextMenu/CommingUpNextRetriveModel.dart';
import '../../CommonSearch/views/common_search_view.dart';

class ComingUpTomorrowMenuController extends GetxController {
  //TODO: Implement ComingUpTomorrowMenuController
  bool isEnable = true;
  Rx<bool> isEnable1 = Rx<bool>(true);

  final count = 0.obs;
  var clientDetails = RxList<DropDownValue>();
  DropDownValue? selectedClientDetails;
  var controllsEnabled = true.obs;
  var selectedRadio = "Dated".obs;

  FocusNode tapeIdFocus = FocusNode();
  FocusNode segNoFocus = FocusNode();
  FocusNode houseIdFocus = FocusNode();
  FocusNode locationFocus = FocusNode();
  FocusNode channelFocus = FocusNode();
  FocusNode programFocus = FocusNode();
  FocusNode programTypeFocus = FocusNode();

  RxList<DropDownValue> locationList = RxList([]);
  RxList<DropDownValue> channelList = RxList([]);
  RxList<DropDownValue> programList = RxList([]);
  RxList<DropDownValue> programTypeList = RxList([]);

  Rxn<DropDownValue>? selectedLocation = Rxn<DropDownValue>(null);
  Rxn<DropDownValue>? selectedChannel = Rxn<DropDownValue>(null);
  Rxn<DropDownValue>? selectedProgram = Rxn<DropDownValue>(null);
  Rxn<DropDownValue>? selectedProgramType = Rxn<DropDownValue>(null);

  TextEditingController tapeIdController = TextEditingController();
  TextEditingController segNoController = TextEditingController(text: "1");
  TextEditingController houseIdController = TextEditingController();
  TextEditingController programController = TextEditingController();
  TextEditingController txCaptionController = TextEditingController();
  TextEditingController somController = TextEditingController();
  TextEditingController eomController = TextEditingController();

  TextEditingController durationController = TextEditingController();
  RxString duration = RxString("00:00:00:00");

  TextEditingController uptoDateController = TextEditingController();
  num sec = 0;
  String strCode = "";
  String strTapeID = "";
  String strHouseID = "";
  String strSegmentNumber = "";
  clearAll() {
    Get.delete<ComingUpTomorrowMenuController>();
    Get.find<HomeController>().clearPage1();
  }

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
        sec = Utils.oldBMSConvertToSecondsValue(value: durationController.text);
      }
    }

    print(">>>>>>>>>" + durationController.text);
    print(">>>>>>>>>" + sec.toString());
  }

  fetchPageLoadData() {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.COMINGUPTOMORROWMASTER_LOAD,
        fun: (map) {
          closeDialogIfOpen();
          // print(">>>>>map"+jsonEncode(map) .toString());
          if (map is Map) {
            if (map.containsKey('lstLocation') &&
                map['lstLocation'] != null &&
                map['lstLocation'].length > 0) {
              locationList.clear();
              map['lstLocation'].forEach((e) {
                locationList.add(DropDownValue.fromJsonDynamic(
                    e, "locationCode", "locationName"));
              });
            }
            if (map.containsKey('lstProgramType') &&
                map['lstProgramType'] != null &&
                map['lstProgramType'].length > 0) {
              programTypeList.clear();
              map['lstProgramType'].forEach((e) {
                programTypeList.add(DropDownValue.fromJsonDynamic(
                    e, "programTypecode", "programTypeName"));
              });
            }
          }
        });
  }

  fetchListOfChannel(String code) {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.COMINGUPTOMORROWMASTER_GETCHANNEL_LIST + code,
        fun: (map) {
          closeDialogIfOpen();
          channelList.clear();
          if (map is List && map.isNotEmpty) {
            for (var e in map) {
              channelList.add(DropDownValue.fromJsonDynamic(
                  e, "channelcode", "channelName"));
            }
          } else {
            channelList.clear();
          }
        });
  }

  fetchProgram(String code,{String programTypeCosde = ""}) {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.COMINGUPTOMORROWMASTER_PROGRAMTYPELOSTFOCUS + code,
        fun: (map) {
          programList.clear();
          List<DropDownValue> dataList = [];
          if (map is List && map.isNotEmpty) {
            for (var e in map) {
              dataList.add(DropDownValue.fromJsonDynamic(
                  e, "programCode", "programName"));
            }
            programList.addAll(dataList);
            if(programTypeCosde != ""){
              for(var element in programList){
                if (element.key.toString().trim() ==
                    programTypeCosde.toString().trim()) {
                  selectedProgram?.value = DropDownValue(
                      key: programTypeCosde ?? "",
                      value: element.value??"");
                  break;
                }
              }
            }
          } else {
            programList.clear();
          }
        });
  }

  bool contin = true;

  validateAndSaveRecord() {
    if (strCode != "0" && strCode != "") {
      // Record Already exist!
      // Snack.callError("Record Already exist!\nDo you want to modify it?");
      LoadingDialog.recordExists(
          "Record Already exist!\nDo you want to modify it?", () {
        isEnable = true;
        contin = false;
        saveRecord();
      });

    } else{
      saveRecord();
    }


  }

  saveRecord(){
    if (selectedLocation?.value == null) {
      Snack.callError("Please select Location Name.");
    } else if (selectedChannel?.value == null) {
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
    } else if (selectedProgramType?.value == null) {
      Snack.callError("Please select Program Type.");
    } else if (selectedProgram?.value == null) {
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
      Snack.callError("Please mark Dated.");
    }
    else {
      LoadingDialog.call();
      Map<String, dynamic> postData = {
        "cutCode": strCode,
        "channelCode": selectedChannel?.value?.key ?? "",
        "houseID": houseIdController.text,
        "exportTapeCode": tapeIdController.text,
        "programCode": selectedProgram?.value?.key ?? "",
        "programTypeCode": selectedProgramType?.value?.key ?? "",
        // "originalRepeatCode": "string",
        "exportTapeCaption": txCaptionController.text,
        "segmentNumber": segNoController.text,
        "slideDuration": sec,
        "som": somController.text,
        // "activeNonActive": "string",
        "dated": ((selectedRadio.value == "Dated") ? "Y" : "N"),
        // "killDate": "2023-07-11T15:06:29.531Z",
        "killDate": DateFormat("yyyy-MM-ddTHH:mm:ss")
            .format(DateFormat("dd-MM-yyyy").parse(uptoDateController.text)),
        "modifiedBy": Get.find<MainController>().user?.logincode ?? "",
        "locationCode": selectedLocation?.value?.key ?? "",
        "eom": eomController.text
      };
      Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.COMINGUPTOMORROWMASTER_SAVE,
          json: postData,
          fun: (map) {
            closeDialogIfOpen();
            if (map is Map && map.containsKey("message") && map['message'] != null) {
              if (strCode != "") {
                Snack.callSuccess((map['message'] ?? "Record is updated successfully.").toString());
              } else {
                strCode = map['cutCode'];
                houseIdController.text = map['houseID'];
                tapeIdController.text = map['exportTapeCode'];
                Snack.callSuccess((map['message'] ?? "Record is inserted successfully.").toString());
              }
            } else {
              Snack.callError((map ?? "Something went wrong").toString());
            }
          });
    }
  }

  void checkRetrieve({bool isTapeId = false}) {
    if (segNoController.text.trim() != "" &&
        tapeIdController.text.trim() != "") {
      strCode = "";
      retrieveRecord(tapeIdController.text.trim(), segNoController.text.trim(),isTapeId:isTapeId);
    }
  }

  CommingUpNextRetriveModel? commingUpNextRetriveModel;

  closeDialogIfOpen() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
  upDateSelectedChannel(Map map ){
    if( map.containsKey("lstChannel") && map['lstChannel'] != null &&
        map['lstChannel'].length > 0){
      channelList.clear();
      List<DropDownValue> dataList = [];
      // if (map is List && map.isNotEmpty) {
      for (var e in map['lstChannel']) {
        dataList.add(
            DropDownValue.fromJsonDynamic(e, "channelcode", "channelName"));
      }
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
  }

  void retrieveRecord(String tapeId, String segNo,{bool isTapeId = false}) {
    LoadingDialog.call();
    Map<String, dynamic> data = {
      "cutCode": strCode,
      "segmentNumber": segNo,
      "exportTapeCode": tapeId
    };
    Get.find<ConnectorControl>().GET_METHOD_WITH_PARAM(
        api: ApiFactory.COMINGUPTOMORROWMASTER_RETRIVERECORD,
        json: data,
        fun: (map) async {
          closeDialogIfOpen();
          if (map is Map && map.containsKey("lstComingUpTomorrow") && map['lstComingUpTomorrow'] != null &&
              map['lstComingUpTomorrow'].length > 0) {
            commingUpNextRetriveModel =
                CommingUpNextRetriveModel.fromJson(map['lstComingUpTomorrow'][0]);
            strCode = commingUpNextRetriveModel!.cunCode.toString();
            durationController.text =
                commingUpNextRetriveModel?.slideDuration.toString() ?? "";
            upDateSelectedChannel(map);
            fetchProgram(commingUpNextRetriveModel?.programTypeCode??"",programTypeCosde: commingUpNextRetriveModel?.programCode??"");

            for (var element in locationList) {
              if (element.key.toString().trim() ==
                  commingUpNextRetriveModel?.locationCode.toString().trim()) {
                selectedLocation?.value = DropDownValue(
                    key: commingUpNextRetriveModel?.locationCode ?? "",
                    value: element.value);
                break;
              }
            }

            strTapeID = commingUpNextRetriveModel?.exportTapeCode ?? "";
            strHouseID = commingUpNextRetriveModel?.houseID ?? "";
            strSegmentNumber =
                (commingUpNextRetriveModel?.segmentNumber ?? 1).toString();
            segNoController.text =
                (commingUpNextRetriveModel?.segmentNumber ?? 0).toString();

            houseIdController.text = commingUpNextRetriveModel?.houseID ?? "";

            for (var element in programTypeList) {
              if (element.key.toString().trim() ==
                  (commingUpNextRetriveModel?.programTypeCode ?? "")
                      .toString()
                      .trim()) {
                selectedProgramType?.value = DropDownValue(
                    key: commingUpNextRetriveModel?.programTypeCode ?? "",
                    value: element.value ?? "");
                break;
              }
            }

            txCaptionController.text =
                commingUpNextRetriveModel?.exportTapeCaption ?? "";
            strCode = commingUpNextRetriveModel?.cunCode ?? "";
            somController.text =
                (commingUpNextRetriveModel?.som) ?? "00:00:00:00";
            eomController.text =
                (commingUpNextRetriveModel?.eom) ?? "00:00:00:00";
            // durationController.value.text =  Utils.convertToTimeFromDouble(value:num.parse((commingUpNextRetriveModel?.slideDuration??10).toString()));
            uptoDateController.text = (DateFormat("dd-MM-yyyy").format(
                    DateFormat("yyyy-MM-ddTHH:mm:ss")
                        .parse(commingUpNextRetriveModel!.killDate!)))
                .toString();
            calculateDuration();

            selectedLocation?.refresh();
            selectedProgram?.refresh();
            selectedChannel?.refresh();
            selectedProgramType?.refresh();
            isEnable1.value = false;
            isEnable1.refresh();


            exportTapeCodeValidate(isTapeId:isTapeId);
          }
          else {
            commingUpNextRetriveModel = null;
            strCode = "";
            exportTapeCodeValidate(isTapeId:isTapeId );
            // update(['top']);
          }
        });
  }

  Future<void> exportTapeCodeValidate({bool isTapeId = false}) async {
    if(isTapeId){
      if (tapeIdController.text != "" &&
          (segNoController.text != "" && segNoController.text != "0")) {
        String? res = "";
        await checkExportTapeCode(tapeIdController.text, segNoController.text,
        strCode, "", ApiFactory.COMINGUPTOMORROWMASTER_TAPEIDLEAVE)
            .then((value) {
          res = value;
        });
        if(commingUpNextRetriveModel != null && commingUpNextRetriveModel?.dated == "N"){
          selectedRadio.value = "Non-Dated";
        }else{
          selectedRadio.value = "Dated";
        }
        selectedRadio.refresh();
        if (res != "" && res != null) {
          LoadingDialog.callInfoMessage(
              res ??"", callback: () {
            isEnable = true;
            if (strCode != "") {
              tapeIdController.text = strTapeID;
            }else{
              tapeIdController.text = "";
              tapeIdFocus.requestFocus();
            }

            // update(['updateLeft']);
          });
        }
      }
    }
    else{
      if (tapeIdController.text != "" &&
          (segNoController.text != "" && segNoController.text != "0")) {
        String res = "";
        await checkExportTapeCode(tapeIdController.text, segNoController.text,
        strCode, "", ApiFactory.COMINGUPTOMORROWMASTER_SEGNOLEAVE)
            .then((value) {
          res = value;
        });
        isEnable1.value = false;
        isEnable1.refresh();
        if(commingUpNextRetriveModel != null && commingUpNextRetriveModel?.dated == "N"){
          selectedRadio.value = "Non-Dated";
        }else{
          selectedRadio.value = "Dated";
        }
        selectedRadio.refresh();
        if (res != "") {
          LoadingDialog.callInfoMessage(
              res ??
                  "", callback: () {
            isEnable = true;
            if (strCode != "") {
              // tapeIdController.text = strTapeID;
              segNoController.text = strSegmentNumber;
            }else{
              segNoController.text = "";
              segNoFocus.requestFocus();
            }

            // update(['updateLeft']);
          });
        }
      }
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

  Future<String> checkExportTapeCode(String tapeId, String segNo,
      String strCode, String houseId, String api) async {
    Completer<String> completer = Completer<String>();
    Map<String, dynamic> data = {
      "exportTapeCode": tapeId,
      "segmentNumber": segNo,
      "code": strCode,
      "houseID": houseId,
      "eventType": ""
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

  void txtTapeIDLeave() async {
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

  void txtHouseIDLeave() async {
    if (houseIdController.text != "") {
      houseIdController.text =
          replaceInvalidChar(houseIdController.text, upperCase: true);
      if (houseIdController.text != "") {
        LoadingDialog.call();
        String res = "";
        await checkExportTapeCode("", "", strCode, houseIdController.text,
                ApiFactory.COMINGUPTOMORROWMASTER_HOUSEIDLEAVE)
            .then((value) {
          res = value;
        });
        closeDialogIfOpen();
        if (res != "") {
          LoadingDialog.callInfoMessage(
              res ??
                  "", callback: () {
            isEnable = true;
            if (strCode != "") {
              // tapeIdController.text = strTapeID;
              houseIdController.text = strHouseID;
            }
            houseIdController.text = "";
            houseIdFocus.requestFocus();
            // update(['updateLeft']);
          });
        }
      }
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
          key: Key("Coming Up Tomorrow Master"),
          screenName: "Coming Up Tomorrow Master",
          appBarName: "Coming Up Tomorrow Master",
          strViewName: "vTesting",
          isAppBarReq: true,
        ),
      );
    }
  }

  void increment() => count.value++;
}

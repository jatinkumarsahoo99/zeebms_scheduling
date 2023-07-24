import 'dart:async';
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
import '../../CommonSearch/views/common_search_view.dart';
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
  TextEditingController segNoController = TextEditingController(text: "1");
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

  RxString duration = RxString("00:00:00:00");

  @override
  void onInit() {
    fetchPageLoadData();
    /*  tapeIdFocus.addListener(() {
      if (!tapeIdFocus.hasFocus) {
        txtTapeIDLeave();
      }
    });*/
    segNoFocus.addListener(() {
      if (segNoFocus.hasFocus) {
        isListenerActive = true;
      }
      if (!segNoFocus.hasFocus && isListenerActive) {
        txtSegNoLeave();
      }
    });
    houseIdFocus.addListener(() {
      if (houseIdFocus.hasFocus) {
        isListenerActive = true;
      }
      if (!houseIdFocus.hasFocus && isListenerActive) {
        txtHouseIDLeave();
      }
    });
    tapeIdFocus.addListener(() {
      if (tapeIdFocus.hasFocus) {
        isListenerActive = true;
      }
      if (!tapeIdFocus.hasFocus && isListenerActive) {
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
    duration.value =  Utils.convertToTimeFromDouble(value: secondEom - secondSom);

    sec =
        Utils.oldBMSConvertToSecondsValue(value: durationController.value.text);

    print(">>>>>>>>>" + durationController.value.text);
    print(">>>>>>>>>" + sec.toString());
  }
  bool contin = true;
  validateAndSaveRecord() {
    if(strCode != 0 && contin){
      // Record Already exist!
      // Snack.callError("Record Already exist!\nDo you want to modify it?");
      LoadingDialog.recordExists(
          "Record Already exist!\nDo you want to modify it?",
              (){
            isEnable = true;
            isListenerActive =false;
            contin= false;
            update(['top']);
          },cancel: (){
        contin= false;
        Get.back();
      });
    }
    else if (selectedLocation == null) {
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
        "menuDate":  DateFormat("yyyy-MM-ddTHH:mm:ss")
            .format(DateFormat("dd-MM-yyyy").parse(menuDateController.text)),
        "menuDuration": duration.value,
        "som": somController.text,
        "menuStartTime": startTimeController.text,
        "menuEndTime": endTimeController.text,
        "dated": "Y",
        "killDate": DateFormat("yyyy-MM-ddTHH:mm:ss")
            .format(DateFormat("dd-MM-yyyy").parse(uptoDateController.text)),
        "modifiedBy": Get.find<MainController>().user?.logincode ?? "",
        "eom": eomController.text
      };
      print(">>>>>>>>>>" + postData.toString());
      LoadingDialog.call();
      Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.COMING_UP_MENU_MASTER_SAVE,
          json: postData,
          fun: (map) {
            Get.back();
            // log(">>>>" + map.toString());
            print(">>>>"+map.toString());
            if(map is Map && map.containsKey("save") && map['save'] != null ){
              if(strCode != ""){
                clearAll();
                Snack.callSuccess(map['save']??"Record is updated successfully.");
              }else{
                clearAll();
                Snack.callSuccess(map['save']??"Record is inserted successfully.");
              }
            }else if(map is Map){
              Snack.callError("Something went wrong");
            }else{
              Snack.callError("Something went wrong");
            }
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
          print(">>>>" + map.toString());
          if (map is Map &&
              map.containsKey("retrive") &&
              map["retrive"] != null && map['retrive'].length >0) {
            Map<String, dynamic> responseMap = map["retrive"][0];
            RetriveDataModel retriveDataModel =
                RetriveDataModel.fromJson(responseMap);
            txCaptionController.text = retriveDataModel.exportTapeCaption ?? "";
            segNoController.text =
                retriveDataModel.segmentNumber.toString() ?? "";
            somController.text = retriveDataModel.som.toString() ?? "";
            eomController.text = retriveDataModel.eom.toString() ?? "";
            startTimeController.text =
                retriveDataModel.menuStartTime.toString() ?? "";
            endTimeController.text =
                retriveDataModel.menuEndTime.toString() ?? "";



            duration.value = retriveDataModel.menuDuration.toString() ?? "00:00:00:00";
            durationController.value.text = retriveDataModel.menuDuration.toString() ?? "00:00:00:00" ;
            calculateDuration();

            strCode = retriveDataModel.menuCode ?? "";

            menuDateController.text = (DateFormat("dd-MM-yyyy").format(
                    DateFormat("yyyy-MM-ddTHH:mm:ss").parse(
                        (retriveDataModel.menuDate != null &&
                                retriveDataModel.menuDate != "")
                            ? retriveDataModel.menuDate!
                            : DateFormat('dd-MM-yyyy').format(DateTime.now()))))
                .toString();

            uptoDateController.text = (DateFormat("dd-MM-yyyy").format(
                    DateFormat("yyyy-MM-ddTHH:mm:ss").parse(
                        (retriveDataModel.killdate != null &&
                                retriveDataModel.killdate != "")
                            ? retriveDataModel.killdate!
                            : DateFormat('dd-MM-yyyy').format(DateTime.now()))))
                .toString();

            for (var e in locationList) {
              if (e.key.toString().trim() ==
                  retriveDataModel.locationCode.toString().trim()) {
                selectedLocation = DropDownValue(
                    value: e.value, key: retriveDataModel.locationCode);
                break;
              }
            }
            selectedChannel = DropDownValue(
                value: "Channel", key: retriveDataModel.channelCode);
            for (var e in channelList) {
              if (e.key.toString() ==
                  retriveDataModel.channelCode.toString().trim()) {
                selectedChannel = DropDownValue(
                    value: e.value, key: retriveDataModel.channelCode);
              }
            }
            update(['top']);
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

    Completer<String> completer=Completer<String>();
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
            log(">>>>" + map.toString());
            if (map is Map &&
                map.containsKey('houseid') &&
                map['houseid'] != null) {
              if (map['houseid'].containsKey('eventName') &&
                  map['houseid']['eventName'] != null &&
                  map['houseid']['eventName'] != null) {
                res = map['houseid']['eventName'];
                // return res;
                completer.complete(res);
              } else {
                res = "";
                completer.complete(res);
                // return res;
              }
            }
            else if (map is Map &&
                map.containsKey('segnoleave') &&
                map['segnoleave'] != null) {
              if (map['segnoleave'].containsKey('eventName') &&
                  map['segnoleave']['eventName'] != null &&
                  map['segnoleave']['eventName'] != null) {
                res = map['segnoleave']['eventName'];
                // return res;
                completer.complete(res);
              } else {
                res = "";
                completer.complete(res);
                // return res;
              }
            }
            else if (map is Map &&
                map.containsKey('tapeid') &&
                map['tapeid'] != null) {
              if (map['tapeid'].containsKey('eventName') &&
                  map['tapeid']['eventName'] != null &&
                  map['tapeid']['eventName'] != null) {
                res = map['tapeid']['eventName'];
                // return res;
                completer.complete(res);
              } else {
                res = "";
                // return res;
                completer.complete(res);
              }
            }

            else {
              completer.complete(res);
              // return res;
            }
          });
    } catch (e) {
      completer.complete(res);
      // return res;
    }
    return completer.future;
    // return res;
  }

  Future<void> txtTapeIDLeave() async {
    if (tapeIdController.text != "") {
      tapeIdController.text =
          replaceInvalidChar(tapeIdController.text, upperCase: true);
      houseIdController.text = tapeIdController.text;
      checkRetrieve();
      if (tapeIdController.text != "" &&
          (segNoController.text != "" && segNoController.text != "0")) {
        /* String res = CheckExportTapeCode(
            tapeIdController.text,
            segNoController.text,
            strCode,
            "",
            ApiFactory.COMING_UP_MENU_MASTER_TAPEIDLEAVE) as String;*/

        String res = "";
        await CheckExportTapeCode(tapeIdController.text, segNoController.text,
                strCode, "", ApiFactory.COMING_UP_MENU_MASTER_TAPEIDLEAVE)
            .then((value) {
          res = value;
        });
        print("res>>>>>>>>>"+res.toString());
        isListenerActive= false;
        if (res != "") {
          LoadingDialog.callInfoMessage(
              res??"Tape ID & Segment Number you entered is already used for ",
                  callback: () {
            isEnable = true;
            isListenerActive = false;
            if (strCode != "") {
              tapeIdController.text = strTapeID;
            } else {
              // tapeIdController.text ="";
              print(">>>");
            }
            // update(['updateLeft']);
          },);
        }
      }
    }
  }

  Future<void> txtSegNoLeave() async {
    if (segNoController.text == "") {
      segNoController.text = "0";
    }
    segNoController.text =
        replaceInvalidChar(segNoController.text, upperCase: true);
    checkRetrieve();
    if (tapeIdController.text != "" &&
        (segNoController.text != "" && segNoController.text != "0")) {
      /*  String res = CheckExportTapeCode(
          tapeIdController.text,
          segNoController.text,
          strCode,
          "",
          ApiFactory.COMINGUPTOMORROWMASTER_SEGNOLEAVE) as String;*/
      String res = "";
      await CheckExportTapeCode(tapeIdController.text, segNoController.text,
              strCode, "", ApiFactory.COMING_UP_MENU_MASTER_SEGLNOLEAVE)
          .then((value) {
        res = value;
      });
      isListenerActive= false;
      if (res != "") {
        LoadingDialog.callInfoMessage(
            res??"Tape ID & Segment Number you entered is already used for ",
                callback: () {
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
        },);
      }
    }
  }

  Future<void> txtHouseIDLeave() async {
    if (houseIdController.text != "") {
      houseIdController.text =
          replaceInvalidChar(houseIdController.text, upperCase: true);
      if (houseIdController.text != "") {
        /*  String res = CheckExportTapeCode(
            "",
            "",
            strCode,
            houseIdController.text,
            ApiFactory.COMING_UP_MENU_MASTER_HOUSEIDLEAVE) as String;*/

        String res=await CheckExportTapeCode("", "", strCode, houseIdController.text,
                ApiFactory.COMING_UP_MENU_MASTER_HOUSEIDLEAVE);
        print(">>>>res" + res);
        isListenerActive= false;
        if (res != "") {
          LoadingDialog.callInfoMessage(
              res ?? "House ID you entered is already used for ",callback:  () {
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
          },);
        }
      }
    }
  }

  formHandler(String string) {
    if(string == "Save"){
      validateAndSaveRecord();
    }else if(string == "Clear"){
      clearAll();
    }else if (string == "Search") {
      Get.to(
        SearchPage(
          key: Key("Coming Up Menu Master"),
          screenName: "Coming Up Meu Master",
          appBarName: "Coming Up Menu Master",
          strViewName: "BMS_view_ComingUpMenu",
          isAppBarReq: true,
        ),
      );
    }
  }
}

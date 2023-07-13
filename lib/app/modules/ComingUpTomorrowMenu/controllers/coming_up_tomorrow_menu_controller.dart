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

class ComingUpTomorrowMenuController extends GetxController {
  //TODO: Implement ComingUpTomorrowMenuController
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
  Rx<TextEditingController> durationController = TextEditingController().obs;
  TextEditingController uptoDateController = TextEditingController();
  num sec = 0;
  String strCode = "";
  String strTapeID = "";
  bool isListenerActive = false;
  clearAll() {
    Get.delete<ComingUpTomorrowMenuController>();
    Get.find<HomeController>().clearPage1();
  }


  void calculateDuration() {

    num secondSom =
    Utils.oldBMSConvertToSecondsValue(value: (somController.text));
    num secondEom =
    Utils.oldBMSConvertToSecondsValue(value: eomController.text);
    durationController.value.text =
        Utils.convertToTimeFromDouble(value: secondEom - secondSom);

    sec = Utils.oldBMSConvertToSecondsValue(value: durationController.value.text);

    print(">>>>>>>>>" + durationController.value.text);
    print(">>>>>>>>>" + sec.toString());
  }

  fetchPageLoadData() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.COMINGUPTOMORROWMASTER_LOAD,
        fun: (map) {
          if (map is List && map.isNotEmpty) {
            locationList.clear();
            /*for (var e in map) {
              locationList.add(DropDownValue.fromJsonDynamic(e, "locationCode", "locationName"));
            }*/
          }else{
            locationList.clear();
          }
        });
  }

  fetchListOfChannel(String code) {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.COMINGUPTOMORROWMASTER_GETCHANNEL_LIST + code,
        fun: ( map) {
          channelList.clear();
          if(map is List && map.isNotEmpty){
            for (var e in map) {
              channelList.add(DropDownValue.fromJsonDynamic(
                  e, "channelcode", "channelName"));
            }
          }else{
            channelList.clear();
          }

        });
  }

  validateAndSaveRecord(){
    if(selectedLocation == null){
      Snack.callError("Please select Location Name.");
    }else if(selectedChannel == null){
      Snack.callError("Please select Channel Name.");
    }else if(tapeIdController.text == null || tapeIdController.text == ""){
      Snack.callError("Tape ID cannot be empty.");
    }else if(segNoController.text == null || segNoController.text == ""){
      Snack.callError("Segment No. cannot be empty.");
    }else if(segNoController.text == "0"){
      Snack.callError("Segment No. cannot be ZERO.");
    }else if(houseIdController.text == null || houseIdController.text == ""){
      Snack.callError("House ID cannot be empty.");
    }else if(txCaptionController.text == null || txCaptionController.text == ""){
      Snack.callError("Export Tape Caption cannot be empty.");
    }else if(selectedProgramType == null){
      Snack.callError("Please select Program Type.");
    }else if(selectedProgram == null){
      Snack.callError("Please select Program.");
    }else if(somController.text == null || somController.text == ""){
      Snack.callError("Please enter SOM.");
    }else if(eomController.text == null || eomController.text == "" || eomController.text == "00:00:00:00"){
      Snack.callError("Please enter EOM.");
    }else if(durationController.value.text == null || durationController.value.text == "" || durationController.value.text == "00:00:00:00"){
      Snack.callError("Duration cannot be empty or 00:00:00:00.");
    }else if(selectedRadio == null){
      Snack.callError("Please mark Dated.");
    }else{
      Map<String,dynamic> postData = {
        "cunCode": strCode,
        "channelCode": selectedChannel?.key??"",
        "houseID":houseIdController.text,
        "exportTapeCode": tapeIdController.text,
        "programCode": selectedProgram?.key??"",
        "programTypeCode":selectedProgramType?.key??"",
        // "originalRepeatCode": "string",
        "exportTapeCaption": txCaptionController.text,
        "segmentNumber": segNoController.text,
        "slideDuration": sec,
        "som": somController.text,
        // "activeNonActive": "string",
        "dated": ((selectedRadio.value == "Dated")?"Y":"N"),
        // "killDate": "2023-07-11T15:06:29.531Z",
        "killDate": DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ").format( DateFormat("dd-MM-yyyy").parse(uptoDateController.text)),
        "modifiedBy": Get.find<MainController>().user?.logincode??"",
        "locationCode": selectedLocation?.key??"",
        "eom": eomController.text
      };
      log(">>>>>>>>>>"+postData.toString());
      Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.COMINGUPTOMORROWMASTER_SAVE,
          json: postData,
          fun: (map) {
            log(">>>>"+map.toString());
            if(map != null){

            }
          });

    }
  }

  void checkRetrieve() {
    if (segNoController.text.trim() != "" &&
        tapeIdController.text.trim() != "") {
      strCode = "";
      retrieveRecord(tapeIdController.text.trim(), segNoController.text.trim());
    }
  }
  void retrieveRecord(String tapeId,String segNo){
    Map<String,dynamic> data = {
      "cutCode":strCode,
      "segmentNumber": "1",
      "exportTapeCode": "HCLP0045"
    };
    print(">>>>"+data.toString());
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.COMINGUPTOMORROWMASTER_RETRIVERECORD,
        json: data,
        fun: (map) {
          log(">>>>"+map.toString());
          if(map != null){

          }
        });
  }

  String replaceInvalidChar(String text, {bool upperCase = false}) {
    text = text.trim();
    if (upperCase == false) {
      text = text.toLowerCase();
      text = text.split(' ').map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1) : '').join(' ');
    } else {
      text = text.toUpperCase();
    }
    text = text.replaceAll("'", "`");
    return text;
  }

  String CheckExportTapeCode(String tapeId,String segNo,String strCode,String houseId, String api){
    Map<String,dynamic> data = {
      "exportTapeCode": tapeId,
      "segmentNumber": segNo,
      "code": strCode,
      "houseID": houseId,
      "eventType": ""
    };

    Get.find<ConnectorControl>().POSTMETHOD(
        api: api,
        json: data,
        fun: (map) {
          log(">>>>"+map.toString());
          if(map != null){

          }
        });
    return "";
  }

  void txtTapeIDLeave(){
    if(tapeIdController.text != ""){
      tapeIdController.text = replaceInvalidChar(tapeIdController.text,upperCase: true);
      houseIdController.text = tapeIdController.text;
      checkRetrieve();
      if(tapeIdController.text != "" && (segNoController.text != "" && segNoController.text != "0") ){
        String res = CheckExportTapeCode(tapeIdController.text,segNoController.text,strCode,"",
            ApiFactory.COMINGUPTOMORROWMASTER_TAPEIDLEAVE);
        if(res != ""){
          LoadingDialog.recordExists(
              "Tape ID & Segment Number you entered is already used for "+res.toString(),
                  (){
                isEnable = true;
                isListenerActive =false;
                if(strCode != ""){
                  tapeIdController.text = strTapeID;
                }else{
                  tapeIdController.text ="";
                }
                // update(['updateLeft']);
              },cancel: (){
            Get.back();
          });
        }

      }
    }
  }

  void txtSegNoLeave(){
    if(segNoController.text == ""){
      segNoController.text = "0";
    }
    segNoController.text = replaceInvalidChar(segNoController.text,upperCase: true);
    checkRetrieve();
    if(tapeIdController.text != "" && (segNoController.text != "" && segNoController.text != "0")){
      String res = CheckExportTapeCode(tapeIdController.text,segNoController.text,strCode,"",
          ApiFactory.COMINGUPTOMORROWMASTER_SEGNOLEAVE);
      if(res != ""){
        LoadingDialog.recordExists(
            "Tape ID & Segment Number you entered is already used for "+res.toString(),
                (){
              isEnable = true;
              isListenerActive =false;
              if(strCode != ""){
                // tapeIdController.text = strTapeID;
                print(">>>>>"+segNoController.text);
              }else{
                segNoController.text ="";
              }
              // update(['updateLeft']);
            },cancel: (){
          Get.back();
        });
      }
    }
  }

  void txtHouseIDLeave(){
    if(houseIdController.text != ""){
      houseIdController.text =  replaceInvalidChar(houseIdController.text,upperCase: true);
      if(houseIdController.text != ""){
        String res = CheckExportTapeCode("","",strCode,houseIdController.text,ApiFactory.COMINGUPTOMORROWMASTER_HOUSEIDLEAVE);
        if(res != ""){
          LoadingDialog.recordExists(
              "House ID you entered is already used for "+res.toString(),
                  (){
                isEnable = true;
                isListenerActive =false;
                if(strCode != ""){
                  // tapeIdController.text = strTapeID;
                  print(">>>>>"+houseIdController.text);
                }else{
                  houseIdController.text ="";
                }
                // update(['updateLeft']);
              },cancel: (){
            Get.back();
          });
        }
      }
    }
  }

  @override
  void onInit() {
    segNoFocus.addListener(() {
      if(segNoFocus.hasFocus){
        isListenerActive = true;
      }
      if(!segNoFocus.hasFocus && isListenerActive){
        checkRetrieve();
      }
    });
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  formHandler(String string) {

  }
  void increment() => count.value++;
}

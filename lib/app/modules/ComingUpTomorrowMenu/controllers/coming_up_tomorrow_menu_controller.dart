import 'dart:convert';
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
import '../../ComingUpNextMenu/CommingUpNextRetriveModel.dart';
import '../../CommonSearch/views/common_search_view.dart';

class ComingUpTomorrowMenuController extends GetxController {
  //TODO: Implement ComingUpTomorrowMenuController
  bool isEnable = true;

  final count = 0.obs;
  var clientDetails = RxList<DropDownValue>();
  DropDownValue? selectedClientDetails;
  var controllsEnabled = true.obs;
  var selectedRadio =  "Dated".obs;

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
  TextEditingController segNoController = TextEditingController(text: "0");
  TextEditingController houseIdController = TextEditingController();
  TextEditingController programController = TextEditingController();
  TextEditingController txCaptionController = TextEditingController();
  TextEditingController somController = TextEditingController();
  TextEditingController eomController = TextEditingController();

  TextEditingController durationController = TextEditingController();
  RxString duration =RxString("00:00:00:00");

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
    durationController.text =
        Utils.convertToTimeFromDouble(value: secondEom - secondSom);
    duration.value =  Utils.convertToTimeFromDouble(value: secondEom - secondSom);
    sec = Utils.oldBMSConvertToSecondsValue(value: durationController.text);

    print(">>>>>>>>>" + durationController.text);
    print(">>>>>>>>>" + sec.toString());
  }

  fetchPageLoadData() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.COMINGUPTOMORROWMASTER_LOAD,
        fun: (map) {
          // print(">>>>>map"+jsonEncode(map) .toString());
          if(map is Map){
            if ( map.containsKey('lstLocation') && map['lstLocation'] != null
                && map['lstLocation'].length > 0 ) {
              locationList.clear();
              map['lstLocation'].forEach((e){
                locationList.add(DropDownValue.fromJsonDynamic(e, "locationCode", "locationName"));
              });
              /*for (var e in map) {
              locationList.add(DropDownValue.fromJsonDynamic(e, "locationCode", "locationName"));
            }*/
            }
            if(map.containsKey('lstProgramType') && map['lstProgramType'] != null
                && map['lstProgramType'].length > 0){
              programTypeList.clear();
              map['lstProgramType'].forEach((e){
                programTypeList.add(DropDownValue.fromJsonDynamic(e, "programTypecode", "programTypeName"));
              });
            }
          }
        });
  }

  fetchListOfChannel(String code) {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.COMINGUPTOMORROWMASTER_GETCHANNEL_LIST + code,
        fun: ( map) {
          channelList.clear();
          print(">>>>>map"+jsonEncode(map) .toString());
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

  fetchProgram(String code){
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.COMINGUPTOMORROWMASTER_PROGRAMTYPELOSTFOCUS + code,
        fun: ( map) {
          programList.clear();
          print(">>>>>map"+jsonEncode(map) .toString());
          if(map is List && map.isNotEmpty){
            for (var e in map) {
              programList.add(DropDownValue.fromJsonDynamic(
                  e, "programCode", "programName"));
            }
          }else{
            programList.clear();
          }

        });
  }

  bool contin = true ;
  validateAndSaveRecord(){
    if(strCode != "" && contin){
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
    else if(selectedLocation == null){
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
      LoadingDialog.call();
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
        "killDate": DateFormat("yyyy-MM-ddTHH:mm:ss").format( DateFormat("dd-MM-yyyy").parse(uptoDateController.text)),
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
            Get.back();
            log(">>>>strCode"+strCode.toString());
            if(map != null){
              if(strCode != ""){
                clearAll();
                Snack.callSuccess("Record is updated successfully.");
              }else{
                clearAll();
                Snack.callSuccess("Record is inserted successfully.");
              }
            }else{
              Snack.callError("Something went wrong");
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
  CommingUpNextRetriveModel? commingUpNextRetriveModel;
  void retrieveRecord(String tapeId,String segNo){
    Map<String,dynamic> data = {
      "cutCode":strCode,
      "segmentNumber": segNo,
      "exportTapeCode": tapeId
    };
    print(">>>>"+data.toString());
    Get.find<ConnectorControl>().GETMETHODWITHPARAM(
        api: ApiFactory.COMINGUPTOMORROWMASTER_RETRIVERECORD,
        json: data,
        fun: (map) {
          print(">>>>"+ jsonEncode(map) .toString());
          if(map is List && map.length >0){
            commingUpNextRetriveModel = CommingUpNextRetriveModel.fromJson(map[0]);
            strCode = commingUpNextRetriveModel!.cunCode.toString();
            durationController.text = commingUpNextRetriveModel?.slideDuration.toString()??"" ;
            for (var element in channelList) {
              if(element.key.toString().trim() ==
                  commingUpNextRetriveModel!.channelCode.toString().trim()){
                selectedChannel = DropDownValue(key:commingUpNextRetriveModel!.channelCode??"",
                    value: element.value);
                break;
              }
            }
            for (var element in locationList) {
              if(element.key.toString().trim() ==
                  commingUpNextRetriveModel!.locationCode.toString().trim()){
                selectedLocation = DropDownValue(key:commingUpNextRetriveModel!.locationCode??"",
                    value: element.value);
                break;
              }
            }
            segNoController.text =(commingUpNextRetriveModel?.segmentNumber??0).toString();
            houseIdController.text = commingUpNextRetriveModel?.houseID??"";
            selectedProgram = DropDownValue(key:commingUpNextRetriveModel?.programCode??"" ,value:"program");
            txCaptionController.text = commingUpNextRetriveModel?.exportTapeCaption??"";
            strCode =commingUpNextRetriveModel?.cunCode??"";
            somController.text =(commingUpNextRetriveModel?.som) ??"00:00:00:00";
            eomController.text =(commingUpNextRetriveModel?.eom) ??"00:00:00:00";
            // durationController.value.text =  Utils.convertToTimeFromDouble(value:num.parse((commingUpNextRetriveModel?.slideDuration??10).toString()));
            uptoDateController.text = (DateFormat("dd-MM-yyyy").format
              (DateFormat("yyyy-MM-ddTHH:mm:ss").parse(commingUpNextRetriveModel!.killDate!))).toString() ;
            calculateDuration();
            // durationController.refresh();
            update(['top']);
          }
          else{
            commingUpNextRetriveModel = null;
            strCode="";
            // update(['top']);
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

  Future<String> CheckExportTapeCode(String tapeId,String segNo,String strCode,String houseId, String api) async {
    Map<String,dynamic> data = {
      "exportTapeCode": tapeId,
      "segmentNumber": segNo,
      "code": strCode,
      "houseID": houseId,
      "eventType": ""
    };
    String res = "";
    // print(">>>>>>>>>"+CheckExportTapeCode.toString());
    try{
    await  Get.find<ConnectorControl>().GETMETHODWITHPARAM(
          api: api,
          json: data,
          fun: (map) {
            log(">>>>"+map.toString());
            if(map is Map && map.containsKey('eventName') &&  map['eventName'] != null && map['eventName'] != "null" ){
              res = map['eventName'];
              return res;
            }else{
              return res;
            }
          });
    }catch(e){
      return res;
    }

    return res;
  }

  void txtTapeIDLeave() async  {
    if(tapeIdController.text != ""){
      tapeIdController.text = replaceInvalidChar(tapeIdController.text,upperCase: true);
      houseIdController.text = tapeIdController.text;
      checkRetrieve();
      if(tapeIdController.text != "" && (segNoController.text != "" && segNoController.text != "0") ){
       /* String res = CheckExportTapeCode(tapeIdController.text,segNoController.text,strCode,"",
            ApiFactory.COMINGUPTOMORROWMASTER_TAPEIDLEAVE);*/
        String res ="";
        await CheckExportTapeCode(tapeIdController.text,segNoController.text,strCode,"",
        ApiFactory.COMINGUPTOMORROWMASTER_TAPEIDLEAVE).then((value) {
          res=value;
        });
        isListenerActive = false;
        if(res != ""){
          LoadingDialog.callInfoMessage(
              "Tape ID & Segment Number you entered is already used for "+"COMING UP NEXT",
                 callback:  (){
                isEnable = true;
                isListenerActive =false;
                if(strCode != ""){
                  tapeIdController.text = strTapeID;
                }else{
                  tapeIdController.text ="";
                }
                // update(['updateLeft']);
              });
        }

      }
    }
  }

  void txtSegNoLeave() async {
    if(segNoController.text == ""){
      segNoController.text = "0";
    }
    segNoController.text = replaceInvalidChar(segNoController.text,upperCase: true);
    checkRetrieve();
    if(tapeIdController.text != "" && (segNoController.text != "" && segNoController.text != "0")){
      /*String res = CheckExportTapeCode(tapeIdController.text,segNoController.text,strCode,"",
          ApiFactory.COMINGUPTOMORROWMASTER_SEGNOLEAVE);*/
      String res ="";
      await CheckExportTapeCode(tapeIdController.text,segNoController.text,strCode,"",
          ApiFactory.COMINGUPTOMORROWMASTER_SEGNOLEAVE).then((value) {
        res=value;
      });
      isListenerActive = false;
      if(res != ""){
        LoadingDialog.callInfoMessage(
            "Tape ID & Segment Number you entered is already used for "+"COMING UP NEXT",
            callback:(){
              isEnable = true;
              isListenerActive =false;
              if(strCode != ""){
                // tapeIdController.text = strTapeID;
                print(">>>>>"+segNoController.text);
              }else{
                segNoController.text ="";
              }
              // update(['updateLeft']);
            });
      }
    }
  }

  void txtHouseIDLeave() async {
    if(houseIdController.text != ""){
      houseIdController.text =  replaceInvalidChar(houseIdController.text,upperCase: true);
      if(houseIdController.text != ""){
        /* String res =
        CheckExportTapeCode("","",strCode,houseIdController.text,
            ApiFactory.COMINGUPTOMORROWMASTER_HOUSEIDLEAVE);
        */
        String res ="";
        await CheckExportTapeCode("","",strCode,houseIdController.text,
        ApiFactory.COMINGUPTOMORROWMASTER_HOUSEIDLEAVE).then((value) {
          res=value;
        });
        isListenerActive = false;

        if(res != ""){
          LoadingDialog.callInfoMessage(
              "House ID you entered is already used for "+"COMING UP NEXT",
                 callback: (){
                isEnable = true;
                isListenerActive =false;
                if(strCode != ""){
                  // tapeIdController.text = strTapeID;
                  print(">>>>>"+houseIdController.text);
                }else{
                  houseIdController.text ="";
                }
                // update(['updateLeft']);
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
        txtSegNoLeave();
      }
    });
    houseIdFocus.addListener(() {
      if(houseIdFocus.hasFocus){
        isListenerActive = true;
      }
      if(!houseIdFocus.hasFocus && isListenerActive){
        txtHouseIDLeave();
      }
    });
    tapeIdFocus.addListener(() {
      if(tapeIdFocus.hasFocus){
        isListenerActive = true;
      }
      if(!tapeIdFocus.hasFocus && isListenerActive){
        txtTapeIDLeave();
      }
    });
    fetchPageLoadData();
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
    if(string == "Save"){
      validateAndSaveRecord();
    }else if(string == "Clear"){
      clearAll();
    }else if (string == "Search") {
      Get.to(
        SearchPage(
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

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
import '../../CommonSearch/views/common_search_view.dart';
import '../CommingUpNextRetriveModel.dart';

class ComingUpNextMenuController extends GetxController {
  //TODO: Implement ComingUpNextMenuController

  bool isEnable = true;

  RxList<DropDownValue> locationList = RxList([]);
  RxList<DropDownValue> channelList = RxList([]);
  RxList<DropDownValue> programList = RxList([]);

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

  DropDownValue? selectedLocation;
  DropDownValue? selectedChannel;
  DropDownValue? selectedProgram;
  TextEditingController tapeIdController = TextEditingController();
  TextEditingController segNoController = TextEditingController(text: "1");
  TextEditingController houseIdController = TextEditingController();
  TextEditingController programController = TextEditingController();
  TextEditingController txCaptionController = TextEditingController();
  TextEditingController somController = TextEditingController();
  TextEditingController eomController = TextEditingController();
  // TextEditingController durationController = TextEditingController();
  TextEditingController uptoDateController = TextEditingController();

  TextEditingController durationController = TextEditingController();
  RxString duration =RxString("00:00:00:00");

  int strCode = 0;
  String strTapeID = "";
  // String strS  egmentNumber = "";
  //HCLP0045
  bool isListenerActive = false;

  fetchPageLoadData() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.COMINGUPNEXTMASTER_NEW_LOAD,
        fun: (map) {
          if (map is List && map.isNotEmpty) {
            locationList.clear();
            for (var e in map) {
              locationList.add(DropDownValue.fromJsonDynamic(
                  e, "locationCode", "locationName"));
            }
          }else{
            locationList.clear();
          }
        });
  }

  fetchListOfChannel(String code) {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.COMINGUPNEXTMASTER_GET_CHANNEL + code,
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
  num sec = 0;
  void calculateDuration() {

    num secondSom =
    Utils.oldBMSConvertToSecondsValue(value: (somController.text));
    num secondEom =
    Utils.oldBMSConvertToSecondsValue(value: eomController.text);
    durationController.text =
        Utils.convertToTimeFromDouble(value: secondEom - secondSom);
    duration.value =  Utils.convertToTimeFromDouble(value: secondEom - secondSom);

     sec = Utils.oldBMSConvertToSecondsValue(value: durationController.value.text);
    // durationController.refresh();

    print(">>>>>>>>>" + durationController.text);
    print(">>>>>>>>>" + sec.toString());
  }
  clearAll() {
    Get.delete<ComingUpNextMenuController>();
    Get.find<HomeController>().clearPage1();
  }
  bool contin = true;
  validateAndSaveRecord(){
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
    }else if(selectedProgram == null){
      Snack.callError("Please select Program.");
    }else if(somController.text == null || somController.text == ""){
      Snack.callError("Please enter SOM.");
    }else if(eomController.text == null || eomController.text == "" || eomController.text == "00:00:00:00"){
      Snack.callError("Please enter EOM.");
    }else if(durationController.value.text == null || durationController.value.text == "" || durationController.value.text == "00:00:00:00"){
      Snack.callError("Duration cannot be empty or 00:00:00:00.");
    }else if(selectedRadio == null){
      Snack.callError("Please mark Dated / Non-Dated.");
    }else{
      Map<String,dynamic> postData = {
        "cunCode": strCode,
        "channelCode": selectedChannel?.key??"",
        "houseID":houseIdController.text,
        "exportTapeCode": tapeIdController.text,
        "programCode": selectedProgram?.key??"",
        // "programTypeCode": "",
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
      LoadingDialog.call();
      log(">>>>>>>>>>"+postData.toString());
      Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.COMINGUPNEXTMASTER_SAVE,
          json: postData,
          fun: (map) {
            Get.back();
            print(">>>>"+map.toString());
            if(map != null && map is String){
              if(strCode != ""){
                clearAll();
                Snack.callSuccess(map??"Record is updated successfully.");
              }else{
                clearAll();
                Snack.callSuccess(map??"Record is inserted successfully.");
              }

            }else{
              Snack.callError(map??"Something went wrong");
            }
          });
    }
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
  CommingUpNextRetriveModel? commingUpNextRetriveModel;
  void checkRetrieve() {
    if (segNoController.text.trim() != "" &&
        tapeIdController.text.trim() != "") {
        strCode = 0;
      retrieveRecord(tapeIdController.text.trim(), segNoController.text.trim());
    }
  }
  void retrieveRecord(String tapeId,String segNo){
    // "HCLP0045"
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.COMINGUPNEXTMASTER_GET_RETRIVE_RECORD+
            "?SegmentNumber="+segNo +"&ExportTapeCode="+tapeId,
        // json: data,
        fun: (map) {
              print(">>>>"+ jsonEncode(map) .toString());
              if(map is List && map.length >0){
                commingUpNextRetriveModel = CommingUpNextRetriveModel.fromJson(map[0]);
                strCode = int.parse((commingUpNextRetriveModel!.cunCode != null &&
                    commingUpNextRetriveModel!.cunCode != "")?commingUpNextRetriveModel!.cunCode.toString():"0") ;
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
                strCode = int.parse(( commingUpNextRetriveModel?.cunCode != null &&
                    commingUpNextRetriveModel?.cunCode != "")? commingUpNextRetriveModel!.cunCode.toString():"0");
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
                strCode=0;
                // update(['top']);
              }
        });
  }

  fetchProgram(String prg){
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.COMINGUPNEXTMASTER_PROGRAMSEARCH+"",
        // json: data,
        fun: (map) {
          print(">>>>"+ jsonEncode(map) .toString());
          // programList

        });
  }


  Future<String> CheckExportTapeCode(String tapeId,String segNo,String strCode,String houseId,String api) async {
      Map<String,dynamic> data = {
        "exportTapeCode": tapeId,
        "segmentNumber": segNo,
        "code": strCode,
        "houseID": houseId
      };
      String res = "";
      // print(">>>>>>>>>"+CheckExportTapeCode.toString());
      try{
       await  Get.find<ConnectorControl>().GET_METHOD_WITH_PARAM(
            api:api,
            json: data,
            fun: (map) {
              log(">>>>"+map.toString());
              if(map is Map && map.containsKey('eventName') &&
                  map['eventName'] != null && map['eventName'] != "null" ){
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

 Future<void> txtTapeIDLeave() async {
    if(tapeIdController.text != ""){
      tapeIdController.text = replaceInvalidChar(tapeIdController.text,upperCase: true);
      houseIdController.text = tapeIdController.text;
        checkRetrieve();
      if(tapeIdController.text != "" && (segNoController.text != "" && segNoController.text != "0") ){
        String res ="";
         await CheckExportTapeCode(tapeIdController.text,segNoController.text,strCode.toString(),"",
            ApiFactory.COMINGUPNEXTMASTER_TAPEIDLEAVE).then((value) {
           res = value;
        });
         print(">>>>>res"+res);
        isListenerActive= false;
        if(res != ""){
          LoadingDialog.callInfoMessage(
            res??"Tape ID & Segment Number you entered is already used for "+"coming up next",
              callback:(){
                isEnable = true;
                isListenerActive =false;
                if(strCode != ""){
                  // tapeIdController.text = strTapeID;
                  // update(['top']);
                }else{
                  tapeIdController.text ="";
                  isListenerActive =false;
                  // update(['top']);
                }
                // update(['updateLeft']);
              }, );

          /*LoadingDialog.recordExists(
              "Tape ID & Segment Number you entered is already used for "+res.toString(),
                  (){
                isEnable = true;
                isListenerActive =false;
                if(strCode != ""){
                  // tapeIdController.text = strTapeID;
                  // update(['top']);
                }else{
                  tapeIdController.text ="";
                  isListenerActive =false;
                  update(['top']);
                }
                // update(['updateLeft']);
              },
              cancel: (){
            Get.back();
          });*/
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
      /*String res = await CheckExportTapeCode(tapeIdController.text,segNoController.text,strCode,"",
          ApiFactory.COMINGUPNEXTMASTER_SEGNOLEAVE);*/
      String res ="";
      await  CheckExportTapeCode(tapeIdController.text,segNoController.text,strCode.toString(),"",
          ApiFactory.COMINGUPNEXTMASTER_SEGNOLEAVE).then((value) {
        res=value;
      });
      print(">>>>>res>txtSegNoLeave"+res);
      isListenerActive= false;
      if(res != ""){

        LoadingDialog.callInfoMessage(
          res??"Tape ID & Segment Number you entered is already used for "+"coming up next",
          callback:  (){
            isEnable = true;
            isListenerActive =false;
            if(strCode != ""){
              // tapeIdController.text = strTapeID;
              print(">>>>>"+segNoController.text);
            }else{
              segNoController.text ="";
              isListenerActive =false;
              // update(['top']);
            }
            // update(['updateLeft']);
          },
        );

       /* LoadingDialog.recordExists(
            "Tape ID & Segment Number you entered is already used for "+res.toString(),
                (){
              isEnable = true;
              isListenerActive =false;
              if(strCode != ""){
                // tapeIdController.text = strTapeID;
                print(">>>>>"+segNoController.text);
              }else{
                segNoController.text ="";
                isListenerActive =false;
                update(['top']);
              }
              // update(['updateLeft']);
            },
            cancel: (){
          Get.back();
        });*/
      }
    }
 }

 Future<void> txtHouseIDLeave() async {
    if(houseIdController.text != ""){
      houseIdController.text =  replaceInvalidChar(houseIdController.text,upperCase: true);
      if(houseIdController.text != ""){
         /* String res = await CheckExportTapeCode("","",strCode,houseIdController.text,
            ApiFactory.COMINGUPNEXTMASTER_HOUSEIDLEAVE);*/
          String res ="";
          await CheckExportTapeCode("","",strCode.toString(),houseIdController.text,
              ApiFactory.COMINGUPNEXTMASTER_HOUSEIDLEAVE).then((value) {
            res=value;
          });
          print(">>>>>res>txtSegNoLeave"+res);
        isListenerActive =false;
        if(res != ""){

          LoadingDialog.callInfoMessage(
            res??"House ID you entered is already used for "+"coming up next",
            callback: (){
              isEnable = true;
              isListenerActive =false;
              if(strCode != ""){
                // tapeIdController.text = strTapeID;
                print(">>>>>"+houseIdController.text);
              }else{
                houseIdController.text ="";
                // update(['top']);
              }
              // update(['updateLeft']);
            },
          );

        /*  LoadingDialog.recordExists(
              "House ID you entered is already used for "+res.toString(),
                  (){
                isEnable = true;
                isListenerActive =false;
                if(strCode != ""){
                  // tapeIdController.text = strTapeID;
                  print(">>>>>"+houseIdController.text);
                }else{
                  houseIdController.text ="";
                  update(['top']);
                }
                // update(['updateLeft']);
              },
              cancel: (){
            Get.back();
          });*/
        }
      }
    }
 }



  @override
  void onInit() {
    fetchPageLoadData();
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

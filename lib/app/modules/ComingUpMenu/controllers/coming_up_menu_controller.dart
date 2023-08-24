import 'dart:async';
import 'dart:developer';

import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/providers/Debounce.dart';
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
  FocusNode txFocus = FocusNode();

  RxList<DropDownValue> locationList = RxList([]);
  RxList<DropDownValue> channelList = RxList([]);
  RxList<DropDownValue> programList = RxList([]);
  RxList<DropDownValue> programTypeList = RxList([]);

  Rxn<DropDownValue>? selectedLocation = Rxn<DropDownValue>(null);
  Rxn<DropDownValue>? selectedChannel = Rxn<DropDownValue>(null);

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

  // bool isListenerActive1 = false;
  // bool isListenerActive2 = false;
  // bool isListenerActive3 = false;
  // bool isListenerActive3 = false;
  // bool isListenerActive4 = false;

  RxString duration = RxString("00:00:00:00");

  void segNoFocusCallBack() {
    if ((!segNoFocus.hasFocus)) {
      txtSegNoLeave();
    }
  }

  void houseIdFocusCallBack() {
    if ((!houseIdFocus.hasFocus)) {
      txtHouseIDLeave();
    }
  }

  void tapeIdFocusCallBack() {
    if (!tapeIdFocus.hasFocus) {
      txtTapeIDLeave();
    }
  }

  @override
  void onClose() {
    print("\n\n>>>>>>>>>>dispose call\n");
    // segNoFocus.removeListener(segNoFocusCallBack);
    // houseIdFocus.removeListener(houseIdFocusCallBack);
    // tapeIdFocus.removeListener(tapeIdFocusCallBack);
    super.onClose();
  }

  callAddListener() {
    // segNoFocus.addListener(segNoFocusCallBack);
    // houseIdFocus.addListener(houseIdFocusCallBack);
    // tapeIdFocus.addListener(tapeIdFocusCallBack);
  }

  @override
  void onInit() {
    tapeIdFocus = FocusNode(
      onKeyEvent: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.tab) {
            txtTapeIDLeave();
            return KeyEventResult.ignored;
        }
        return KeyEventResult.ignored;
      },
    );
    segNoFocus = FocusNode(
      onKeyEvent: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.tab) {
          txtSegNoLeave();
          return KeyEventResult.ignored;
        }
        return KeyEventResult.ignored;
      },
    );
    houseIdFocus =  FocusNode(
      onKeyEvent: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.tab) {
          txtHouseIDLeave();
          return KeyEventResult.ignored;
        }
        return KeyEventResult.ignored;
      },
    );

    super.onInit();
  }
  @override
  void onReady() {
    super.onReady();
    fetchPageLoadData();
    // callAddListener();
  }

  clearAll() {
    Get.delete<ComingUpMenuController>();
    Get.find<HomeController>().clearPage1();
  }

  fetchPageLoadData() {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.COMING_UP_MENU_MASTER_LOAD,
        fun: (Map map) {
          closeDialogIfOpen();
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

    if (eomController.text.length >= 11) {
      if ((secondEom - secondSom) < 0) {
        LoadingDialog.showErrorDialog("EOM should not be less than SOM.");
      } else {
        durationController.value.text =
            Utils.convertToTimeFromDouble(value: secondEom - secondSom);
        duration.value =
            Utils.convertToTimeFromDouble(value: secondEom - secondSom);

        sec = Utils.oldBMSConvertToSecondsValue(
            value: durationController.value.text);
      }
    }

    print(">>>>>>>>>" + durationController.value.text);
    print(">>>>>>>>>" + sec.toString());
  }

  bool contin = true;
  validateAndSaveRecord() {
    if (strCode != "") {
      // Record Already exist!
      // Snack.callError("Record Already exist!\nDo you want to modify it?");
      LoadingDialog.recordExists(
          "Record Already exist!\nDo you want to modify it?", () {
        isEnable = true;
        contin = false;
        saveRecord();
        // update(['top']);
      });
    } else {
      saveRecord();
    }
  }

  saveRecord() {
    if (selectedLocation?.value == null) {
      Snack.callError("Please select Location Name.");
    } else if (selectedChannel?.value == null) {
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
        "locationCode": selectedLocation?.value?.key ?? "",
        "channelCode": selectedChannel?.value?.key ?? "",
        "exportTapeCaption": txCaptionController.text,
        "exportTapeCode": tapeIdController.text,
        "segmentNumber": segNoController.text,
        "houseId": houseIdController.text,
        "menuDate": DateFormat("yyyy-MM-ddTHH:mm:ss")
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
            closeDialogIfOpen();
            // log(">>>>" + map.toString());
            print(">>>>" + map.toString());
            if (map is Map && map.containsKey("save") && map['save'] != null && map["save"] is Map) {
              if (strCode != "") {
                Snack.callSuccess(
                   ( map['save']['message'] ?? "Record is updated successfully.").toString());
              } else {
                strCode = map['save']['menuCode'];
                houseIdController.text =  map['save']['houseId'];
                tapeIdController.text = map['save']['exportTapeCode'];
                Snack.callSuccess(
                    (map['save']['message'] ?? "Record is inserted successfully.").toString());
              }
            } else if (map is Map) {
              Snack.callError((map ?? "Something went wrong").toString());
            } else {
              Snack.callError((map ?? "Something went wrong").toString());
            }
          });
    }
  }

  Future<void> checkRetrieve(bool isTapeId) async{
    strCode = "";
     retrieveRecord(tapeIdController.text.trim(), segNoController.text.trim(),
        houseIdController.text,isTapeId);
  }

  void retrieveRecord(String tapeId, String segNo, String houseID,bool isTapeId) {
    LoadingDialog.call();
    Map<String, dynamic> data = {
      "menuCode": strCode,
      "segmentNumber": segNo,
      "exportTapeCode": tapeId,
      "houseId": houseID
    };
    Get.find<ConnectorControl>().GET_METHOD_WITH_PARAM(
        api: ApiFactory.COMING_UP_MENU_MASTER_GET_RETRIVERECORD,
        json: data,
        fun: (map) async {
          closeDialogIfOpen();
          // print(">>>>" + map.toString());
          if (map is Map &&
              map.containsKey("retrive") &&
              map["retrive"] != null &&
              map['retrive'].containsKey("lstcomingmodel") &&
              map['retrive']['lstcomingmodel'] != null &&
              map['retrive']['lstcomingmodel'].length > 0) {
            Map<String, dynamic> responseMap =
                map["retrive"]['lstcomingmodel'][0];
            RetriveDataModel retriveDataModel =
                RetriveDataModel.fromJson(responseMap);
            txCaptionController.text = retriveDataModel.exportTapeCaption ?? "";
            segNoController.text =
                retriveDataModel.segmentNumber.toString() ?? "1";
            somController.text =
                (retriveDataModel.som ?? "00:00:00:00").toString();
            eomController.text =
                (retriveDataModel.eom ?? "00:00:00:00").toString();
            startTimeController.text =
                (retriveDataModel.menuStartTime ?? "00:00:00").toString();
            endTimeController.text =
                (retriveDataModel.menuEndTime ?? "00:00:00").toString();

            duration.value =
                (retriveDataModel.menuDuration ?? "00:00:00:00").toString();
            durationController.value.text =
                (retriveDataModel.menuDuration ?? "00:00:00:00").toString();
            calculateDuration();
            houseIdController.text =retriveDataModel.houseId ??"" ;
            tapeIdController.text =retriveDataModel.exportTapeCode??"" ;

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
                selectedLocation?.value = DropDownValue(
                    value: e.value, key: retriveDataModel.locationCode);
                break;
              }
            }
            if( map['retrive'].containsKey("lstchannel") &&
                map['retrive']['lstchannel'] != null &&
                map['retrive']['lstchannel'].length > 0){
              channelList.clear();
              List<DropDownValue> dataList = [];
              // if (map is List && map.isNotEmpty) {
              for (var e in map['retrive']['lstchannel']) {
                dataList.add(
                    DropDownValue.fromJsonDynamic(e, "channelCode", "channelName"));
              }
              channelList.addAll(dataList);
              for (var e in channelList) {
                if (e.key.toString().trim() ==
                    retriveDataModel.channelCode.toString().trim()) {
                  selectedChannel?.value = DropDownValue(
                      value: e.value ?? "",
                      key: retriveDataModel.channelCode ?? "");
                }
              }
            }

            selectedChannel?.refresh();
            selectedLocation?.refresh();
            duration.refresh();
            durationController.refresh();

            if(isTapeId){
              if (tapeIdController.text != "" &&
                  (segNoController.text != "" && segNoController.text != "0")) {
                String? res = "";
                await CheckExportTapeCode(tapeIdController.text, segNoController.text,
                    strCode, "", ApiFactory.COMING_UP_MENU_MASTER_TAPEIDLEAVE)
                    .then((value) {
                  res = value;
                });
                if (res != "" && res != null) {
                  LoadingDialog.callInfoMessage(
                    res ?? "Tape ID & Segment Number you entered is already used for ",
                    callback: () {
                      isEnable = true;
                      if (strCode != "") {
                        tapeIdController.text = strTapeID;
                      } else {
                        tapeIdFocus.requestFocus();
                        // tapeIdController.text ="";
                      }
                      // update(['updateLeft']);
                    },
                  );
                }
              }
            }
            else{
              if (tapeIdController.text != "" &&
                  (segNoController.text != "" && segNoController.text != "0")) {
                String? res = "";
                await CheckExportTapeCode(tapeIdController.text, segNoController.text,
                    strCode, "", ApiFactory.COMING_UP_MENU_MASTER_SEGLNOLEAVE)
                    .then((value) {
                  res = value;
                });

                if (res != "" && res != null) {
                  LoadingDialog.callInfoMessage(
                    res ?? "Tape ID & Segment Number you entered is already used for ",
                    callback: () {
                      isEnable = true;
                      if (strCode != "") {
                        // tapeIdController.text = strTapeID;
                        segNoController.text = "";
                        print(">>>>>" + segNoController.text);
                      } else {
                        segNoFocus.requestFocus();
                        // segNoController.text ="";
                      }
                      // update(['updateLeft']);
                    },
                  );
                }
              }
            }




          }
          else{
            if(isTapeId){
              if (tapeIdController.text != "" &&
                  (segNoController.text != "" && segNoController.text != "0")) {
                String? res = "";
                await CheckExportTapeCode(tapeIdController.text, segNoController.text,
                    strCode, "", ApiFactory.COMING_UP_MENU_MASTER_TAPEIDLEAVE)
                    .then((value) {
                  res = value;
                });
                if (res != "" && res != null) {
                  LoadingDialog.callInfoMessage(
                    res ?? "Tape ID & Segment Number you entered is already used for ",
                    callback: () {
                      isEnable = true;
                      if (strCode != "") {
                        tapeIdController.text = strTapeID;
                      } else {
                        tapeIdFocus.requestFocus();
                        // tapeIdController.text ="";
                      }
                      // update(['updateLeft']);
                    },
                  );
                }
              }
            }
            else{
              if (tapeIdController.text != "" &&
                  (segNoController.text != "" && segNoController.text != "0")) {
                String? res = "";
                await CheckExportTapeCode(tapeIdController.text, segNoController.text,
                    strCode, "", ApiFactory.COMING_UP_MENU_MASTER_SEGLNOLEAVE)
                    .then((value) {
                  res = value;
                });

                if (res != "" && res != null) {
                  LoadingDialog.callInfoMessage(
                    res ?? "Tape ID & Segment Number you entered is already used for ",
                    callback: () {
                      isEnable = true;
                      if (strCode != "") {
                        // tapeIdController.text = strTapeID;
                        segNoController.text = "";
                        print(">>>>>" + segNoController.text);
                      } else {
                        segNoFocus.requestFocus();
                        // segNoController.text ="";
                      }
                      // update(['updateLeft']);
                    },
                  );
                }
              }
            }

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

  closeDialogIfOpen() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  Future<String> CheckExportTapeCode(String tapeId, String segNo,
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
            log(">>>>" + map.toString());
            if (map is Map &&
                map.containsKey('houseid') &&
                map['houseid'] != null) {
              if (map['houseid'].containsKey('eventName') &&
                  map['houseid']['eventName'] != null) {
                res = map['houseid']['eventName'];
                // return res;
                completer.complete(res);
              } else {
                res = "";
                completer.complete(res);
                // return res;
              }
            } else if (map is Map &&
                map.containsKey('segnoleave') &&
                map['segnoleave'] != null) {
              if (map['segnoleave'].containsKey('eventName') &&
                  map['segnoleave']['eventName'] != null) {
                res = map['segnoleave']['eventName'];
                // return res;
                completer.complete(res);
              } else {
                res = "";
                completer.complete(res);
                // return res;
              }
            } else if (map is Map &&
                map.containsKey('tapeid') &&
                map['tapeid'] != null) {
              if (map['tapeid'].containsKey('eventName') &&
                  map['tapeid']['eventName'] != null) {
                res = map['tapeid']['eventName'];
                // return res;
                completer.complete(res);
              } else {
                res = "";
                // return res;
                completer.complete(res);
              }
            } else {
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
       checkRetrieve(true);

    }
  }

  Future<void> txtSegNoLeave() async {
    if (segNoController.text == "") {
      segNoController.text = "0";
    }
    segNoController.text =
        replaceInvalidChar(segNoController.text, upperCase: true);
     checkRetrieve(false);


  }

  Future<void> txtHouseIDLeave() async {
    if (houseIdController.text != "") {
      houseIdController.text =
          replaceInvalidChar(houseIdController.text, upperCase: true);
      if (houseIdController.text.trim() != "") {
        LoadingDialog.call();
        String? res = "";
        await CheckExportTapeCode("", "", strCode, houseIdController.text,
                ApiFactory.COMING_UP_MENU_MASTER_HOUSEIDLEAVE)
            .then((value) {
          res = value;
        });
        closeDialogIfOpen();
        if (res != "" && res != null) {
          LoadingDialog.callInfoMessage(
            res ?? "House ID you entered is already used for ",
            callback: () {
              isEnable = true;
              if (strCode != "") {
                houseIdController.text = "";
                // tapeIdController.text = strTapeID;
                print(">>>>>" + houseIdController.text);
              } else {
                houseIdFocus.requestFocus();
                // houseIdController.text ="";
                print(">>>>>" + houseIdController.text);
              }
              // update(['updateLeft']);
            },
          );
        }
      }
    }
  }

  formHandler(String string) {
    if (string == "Save") {
      validateAndSaveRecord();
    } else if (string == "Clear") {
      clearAll();
    } else if (string == "Search") {
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

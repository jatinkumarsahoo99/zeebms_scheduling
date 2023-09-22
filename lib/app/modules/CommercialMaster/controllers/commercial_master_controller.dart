import 'dart:convert';
import 'dart:developer';

import 'package:bms_scheduling/app/controller/HomeController.dart';
import 'package:bms_scheduling/app/modules/RoCancellation/bindings/ro_cancellation_doc.dart';
import 'package:bms_scheduling/app/providers/ExportData.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/src/manager/pluto_grid_state_manager.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/FormButton.dart';
import '../../../../widgets/LoadingDialog.dart';
import '../../../../widgets/Snack.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../controller/MainController.dart';
import '../../../data/DropDownValue.dart';
import '../../../data/user_data_settings_model.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/Utils.dart';
import '../../CommonDocs/controllers/common_docs_controller.dart';
import '../../CommonDocs/views/common_docs_view.dart';
import '../../CommonSearch/views/common_search_view.dart';
import '../CommercialTapeMasterData.dart';
import '../CommercialTapeMasterPostData.dart';

class CommercialMasterController extends GetxController {
  //TODO: Implement CommercialMasterController

  final count = 0.obs;
  var language = RxList<DropDownValue>();
  var revenueType = RxList<DropDownValue>();
  var tapeType = RxList<DropDownValue>();
  var censorShipType = RxList<DropDownValue>();
  var secType = RxList<DropDownValue>();
  var clientDetails = RxList<DropDownValue>();
  var agencyDetails = RxList<DropDownValue>();
  var agencyDetailsMaster = RxList<DropDownValue>();
  var brandType = RxList<DropDownValue>();

  DropDownValue? selectedLanguage;
  DropDownValue? selectedRevenueType;
  DropDownValue? selectedTapeType;
  DropDownValue? selectedCensorShipType;
  Rxn<DropDownValue>? selectedSecType = Rxn<DropDownValue>(null);
  Rxn<DropDownValue> ? selectedClientDetails= Rxn<DropDownValue>(null);
  Rxn<DropDownValue> ? selectedAgencyDetails= Rxn<DropDownValue>(null);
  Rxn<DropDownValue> ? selectedBrandType= Rxn<DropDownValue>(null);
  DropDownValue? selectedEvent;

  TextEditingController clientController = TextEditingController();
  TextEditingController level1Controller = TextEditingController();
  TextEditingController level2Controller = TextEditingController();
  TextEditingController level3Controller = TextEditingController();

  TextEditingController somController = TextEditingController();
  TextEditingController eomController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  TextEditingController tcInController = TextEditingController();
  TextEditingController tcOutController = TextEditingController();

  TextEditingController captionController = TextEditingController();
  TextEditingController txCaptionController = TextEditingController();

  // TextEditingController tapeIdController = TextEditingController();
  // TextEditingController tapeIdNewController = TextEditingController();

  TextEditingController segController = TextEditingController();
  TextEditingController txNoController = TextEditingController(text: "AUTO");
  TextEditingController agencyIdController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController agencyNameController = TextEditingController();
  TextEditingController clockIdController = TextEditingController();

  TextEditingController endDateController = TextEditingController();
  TextEditingController dispatchDateController = TextEditingController();

  Rx<TextEditingController> duration = TextEditingController().obs;
  Rx<TextEditingController> tapeIdController =
      TextEditingController(text: "AUTO").obs;
  PlutoGridStateManager? gridStateManager;
  List<Annotations> eventList = [];
  String? commercialCode = '0';

  bool isEnable = true;
  bool isEnableSelective = true;
  FocusNode captionFocus = FocusNode();
  FocusNode tapeIdFocus = FocusNode();
  FocusNode clockIdFocus = FocusNode();
  FocusNode txNoFocus = FocusNode();
  FocusNode segNoFocus = FocusNode();
  FocusNode languageFocus = FocusNode();
  FocusNode revenueFocus = FocusNode();
  FocusNode secTypeFocus = FocusNode();
  FocusNode tapeTypeFocus = FocusNode();
  FocusNode censhorShipFocus = FocusNode();
  FocusNode clientFocus = FocusNode();
  FocusNode brandFocus = FocusNode();
  FocusNode agencyFocus = FocusNode();
  FocusNode agencyNameFocus = FocusNode();
  FocusNode eventFocus = FocusNode();

  // bool segEnable = true;
  bool isListenerActive = false;

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

  @override
  void onInit() {
    duration.value.text = "00:00:00:00";
    segController.text = '1';
    getAllDropDownList();

    captionFocus = FocusNode(
      onKeyEvent: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.tab) {
          if ( captionController.text != null && captionController.text != "") {
            captionController.text = replaceInvalidChar(captionController.text,upperCase: true) ;
            txCaptionController.text =
                captionController.text;
            fetchCommercialTapeMasterData(captionController.text, "", 0, "");
          }
          return KeyEventResult.ignored;
        }
        return KeyEventResult.ignored;
      },
    );

    txNoFocus = FocusNode(
      onKeyEvent: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.tab) {
          validateTxNo(txNoController.text, "", "");
          return KeyEventResult.ignored;
        }
        return KeyEventResult.ignored;
      },
    );

    tapeIdFocus = FocusNode(
      onKeyEvent: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.tab) {
          if (tapeIdController.value.text != null &&
              tapeIdController.value.text != "") {
            txNoController.text =
                "${tapeIdController.value.text}-${segController.text}";
            fetchCommercialTapeMasterData("", tapeIdController.value.text,
                int.parse((segController.text) ?? "0"), "");
            // validateTxNo("", tapeIdController.value.text, segController.text);
          }
          return KeyEventResult.ignored;
        }
        return KeyEventResult.ignored;
      },
    );

    clockIdFocus = FocusNode(
      onKeyEvent: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.tab) {
          if (clockIdController.text != "" && clockIdController.text != null) {
            if(tapeIdController.value.text == ""){
              fetchCommercialTapeMasterData("", "", 0, clockIdController.text);
            }
          }
          return KeyEventResult.ignored;
        }
        return KeyEventResult.ignored;
      },
    );

    segNoFocus = FocusNode(
      onKeyEvent: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.tab) {
          validateTxNo1("", tapeIdController.value.text, segController.text);
          return KeyEventResult.ignored;
        }
        return KeyEventResult.ignored;
      },
    );

    /* captionFocus.addListener(() {
      if (isListenerActive && !captionFocus.hasFocus) {
        print("api called on focus changed");
        if (captionController.text != "" && captionController.text != null) {
          txCaptionController.text =
              captionController.text.toString().toUpperCase();
          fetchCommercialTapeMasterData(captionController.text, "", 0, "");
        }
      }
      if (captionFocus.hasFocus) {
        isListenerActive = true;
      }
    });

    tapeIdFocus.addListener(() {
      if (isListenerActive && !tapeIdFocus.hasFocus) {
        if (tapeIdController.value.text != null &&
            tapeIdController.value.text != "") {
          fetchCommercialTapeMasterData("", tapeIdController.value.text,
              int.parse((segController.text) ?? "0"), "");
          validateTxNo("", tapeIdController.value.text, segController.text);
        }
        isListenerActive = false;
      }
      if (tapeIdFocus.hasFocus) {
        isListenerActive = true;
      }
    });

    txNoFocus.addListener(() {
      if (isListenerActive && !txNoFocus.hasFocus) {
        validateTxNo(txNoController.text, "", "");
      }
      if (txNoFocus.hasFocus) {
        isListenerActive = true;
      }
    });

    clockIdFocus.addListener(() {
      if (isListenerActive && !(clockIdFocus.hasFocus)) {
        if (clockIdController.text != "" && clockIdController.text != null) {
          fetchCommercialTapeMasterData("", "", 0, clockIdController.text);
        }
      }
      if (clockIdFocus.hasFocus) {
        isListenerActive = true;
      }
    });


    segNoFocus.addListener(() {
      if (isListenerActive && (segNoFocus.hasFocus == false)) {
        print("listener call");
        validateTxNo1("", tapeIdController.value.text, segController.text);
      }
      if (segNoFocus.hasFocus) {
        // txNoController.text = tapeIdController.value.text + "-" + segController.text;
        isListenerActive = true;
      }
    });*/

    super.onInit();
  }

  void search() {
    // Get.delete<TransformationController>();
    Get.to(SearchPage(
        key: Key("CommercialTapeMaster"),
        screenName: "Commercial Tape Master",
        appBarName: "Commercial Tape Master",
        strViewName: "BMS_View_Commercialmaster",
        isAppBarReq: true));
  }

  clearAll() {
    Get.delete<CommercialMasterController>();
    Get.find<HomeController>().clearPage1();
    /* commercialCode = "0";
     selectedLanguage=null;
     selectedRevenueType=null;
     selectedTapeType=null;
     selectedCensorShipType=null;
     selectedSecType=null;
     selectedClientDetails=null;
     selectedAgencyDetails=null;
     selectedBrandType=null;
     selectedEvent=null;

     clientController.text="";
     level1Controller.text="";
     level2Controller.text="";
     level3Controller.text="";
     somController.text="00:00:00:00";
     eomController.text="00:00:00:00";
     durationController.text="";
     tcInController.text="00:00:00:00";
     tcOutController.text="00:00:00:00";
     captionController.text="";
     txCaptionController.text="";
     tapeIdController.value.text="";
     segController.text="";
     txNoController.text="";
     agencyIdController.text="";
     productNameController.text="";
     agencyNameController.text="";
     clockIdController.text="";
     duration.value.text = "00:00:00:00";
     segController.text="1";
     isEnable = true;
     eventList.clear();
     // Get.back();
     update(['eventTable','updateLeft']);*/
  }

  void calculateDuration() {
    num secondSom =
        Utils.oldBMSConvertToSecondsValue(value: somController.text);
    num secondEom =
        Utils.oldBMSConvertToSecondsValue(value: eomController.text);

    var sec;
    if (eomController.text.length >= 11) {
      if ((secondEom - secondSom) < 0) {
        LoadingDialog.showErrorDialog("EOM should not be less than SOM.");
      } else {
        duration.value.text =
            Utils.convertToTimeFromDouble(value: secondEom - secondSom);

         sec = Utils.oldBMSConvertToSecondsValue(value: duration.value.text);
      }
    }

    print(">>>>>>>>>" + duration.value.text);
    print(">>>>>>>>>" + sec.toString());
  }

  bool contin = true;
  closeDialogIfOpen() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  saveData() {
    if (captionController.text == "" || captionController.text == null) {
      Snack.callError("Please enter caption");
    } else if (txCaptionController.text == "" ||
        txCaptionController.text == null) {
      Snack.callError("Please enter tx-caption");
    } else if (selectedLanguage == null) {
      Snack.callError("Please select language");
    } else if (segController.text == null || segController.text == "") {
      Snack.callError("Please enter Segment Id.");
    } else if (txNoController.text == null || txNoController.text == "") {
      Snack.callError("Please enter TX No");
    } else if (selectedTapeType == null) {
      Snack.callError("Please select tape type");
    } else if (somController.text == "00:00:00:00" ||
        somController.text == "") {
      Snack.callError("Please enter SOM.");
    } /*else if (eomController.text == "00:00:00:00" ||
        eomController.text == "") {
      Snack.callError("Please enter EOM.");
    }*/
    else if (duration.value.text == "00:00:00:00" ||
        duration.value.text == "") {
      Snack.callError("Please enter duration.");
    } else if (selectedBrandType == null) {
      Snack.callError("Please select brand");
    } else if (selectedAgencyDetails == null) {
      Snack.callError("Please select Agency.");
    } else if ((commercialCode != "0" && commercialCode != "")) {
      LoadingDialog.recordExists("Do you want to modify it?", () {
        isEnable = true;
        callSaveApi();
        update(['updateLeft']);
      });
    } else {
      callSaveApi();
    }
  }

  callSaveApi() {
    LoadingDialog.recordExists(
        "End Date selected is ${DateFormat('dd/MM/yyyy').format(DateFormat("dd-MM-yyyy").parse(endDateController.text))} ${DateFormat('hh:mm:ss').format(DateTime.now())}. Want to proceed?",
        () {
      isEnable = true;
      callSaveBtnApi();
      update(['updateLeft']);
    });
  }

  callSaveBtnApi() {
    LoadingDialog.call();
    CommercialTapeMasterPostData commercialTapeMasterPostData =
        CommercialTapeMasterPostData(
            commercialCaption: captionController.text,
            exportTapeCaption: txCaptionController.text,
            agencyCode: selectedAgencyDetails?.value?.key ?? "",
            agencytapeid: agencyIdController.text,
            brandCode: selectedBrandType?.value?.key ?? "",
            censorshipCode: selectedCensorShipType?.key ?? "",
            clockid: clockIdController.text,
            commercialCode: commercialCode ?? "0",
            eom: eomController.text,
            som: somController.text,
            commercialDuration:
                Utils.oldBMSConvertToSecondsValue(value: duration.value.text)
                    .toString(),
            despatchDate: DateFormat('M/d/yyyy hh:mm:ss a').format(
                DateFormat("dd-MM-yyyy").parse(dispatchDateController.text)),
            killDate: DateFormat('M/d/yyyy hh:mm:ss a')
                .format(DateFormat("dd-MM-yyyy").parse(endDateController.text)),
            eventsubtype: selectedSecType?.value?.key ?? "",
            eventtypecode: selectedRevenueType?.key ?? "",
            houseID: txNoController.text,
            segmentNumber: segController.text,
            languagecode: selectedLanguage?.key ?? "",
            exportTapeCode: tapeIdController.value.text,
            tapeTypeCode: selectedTapeType?.key ?? "",
            annotations: eventList,
            recievedOn:
                DateFormat('M/d/yyyy hh:mm:ss a').format(DateTime.now()));
    // print((jsonEncode(commercialTapeMasterPostData.toJson())));

    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.COMMERCIAL_MASTER_SAVE_COMMERCIALTAPE,
        json: commercialTapeMasterPostData.toJson(),
        fun: (map) {
          Get.back();
          if (map is Map && map.containsKey("result") && map['result'].containsKey("isError")) {
            if (map['result']['isError'] == false) {
              LoadingDialog.callDataSavedMessage(
                  map['genericMessage'] ?? "Record Saved Successfully",
                  callback: () {
                // clearAll();
              });
              if (map['result'].containsKey('saveModel') &&
                  map['result']['saveModel'] != null &&
                  map['result']['saveModel'].length > 0) {
                txNoController.text = map['result']['saveModel'][0]['houseid'];
                tapeIdController.value.text =
                    map['result']['saveModel'][0]['exportTapecode'];
                commercialCode = map['result']['saveModel'][0]['commercialCode'];
              }
            } else {
              // Get.back();
              LoadingDialog.showErrorDialog(
                  (map ?? "Something went wrong").toString());
            }
          } else {
            // Get.back();
            LoadingDialog.showErrorDialog(
                (map ?? "Something went wrong").toString());
          }
        });
  }

  addEvent() {
    if (selectedEvent == null) {
      Snack.callError("Please select event");
    } else if (tcInController.text == null || tcInController.text == "") {
      Snack.callError("Please enter tcIn");
    } else if (tcOutController.text == null || tcOutController.text == "") {
      Snack.callError("Please enter tcOut");
    } else {
      /* eventList.add({"eventName":selectedEvent!.value ,
        "tcIn":tcInController.text??"","tcOut":tcOutController.text??""});*/
      if(gridStateManager?.rows.length == 0){
        eventList.clear();
      }
      eventList.add(new Annotations(
          eventName: selectedEvent!.value,
          tcIn: tcInController.text ?? "",
          tcOut: tcOutController.text ?? ""));
      log("eventList" + eventList.toString());
      selectedEvent = null;
      // tcInController.text = "00:00:00:00";
      // tcOutController.text = "00:00:00:00";
      update(['eventTable']);
    }
    // {"eventName":"","tcIn":"","tcOut":""}
  }

  getAllDropDownList() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.COMMERCIAL_MASTER_ALLDROPDOWN,
        fun: (map) {
          log(">>>" + map.toString());
          if (map is Map) {
            if (map.containsKey("language") && map["language"].length > 0) {
              language.clear();
              map['language'].forEach((e) {
                language.add(DropDownValue.fromJson1(e));
              });
            }
            // secType
           /* if (map.containsKey("secType") && map["secType"].length > 0) {
              secType.clear();
              map['secType'].forEach((e) {
                secType.add(DropDownValue.fromJsonDynamic(e,"eventCode","eventName"));
              });
            }*/
            if (map.containsKey("revenueType") &&
                map["revenueType"].length > 0) {
              revenueType.clear();
              // log("revenueType"+map['revenueType'].toString());
              map['revenueType'].forEach((e) {
                revenueType.add(DropDownValue.fromJson1(e));
              });
            }
            if (map.containsKey("tapeType") && map["tapeType"].length > 0) {
              tapeType.clear();
              // log("tapeType"+map['tapeType'].toString());
              map['tapeType'].forEach((e) {
                tapeType.add(DropDownValue.fromJson1(e));
              });
            }
            if (map.containsKey("censorshipType") &&
                map["censorshipType"].length > 0) {
              censorShipType.clear();
              // log("tapeType"+map['tapeType'].toString());
              map['censorshipType'].forEach((e) {
                censorShipType.add(DropDownValue.fromJson1(e));
              });
            }
          }
        });
  }

  List<RoCancellationDocuments> documents = [];

  docs() async {
    String documentKey = "";
    if (commercialCode == "" || commercialCode == '0') {
      documentKey = "";
    } else {
      documentKey = "CommercialMaster $commercialCode";
    }

    Get.defaultDialog(
      title: "Documents",
      content: CommonDocsView(documentKey: documentKey),
    ).then((value) {
      Get.delete<CommonDocsController>(tag: "commonDocs");
    });
  }

  getSecType(String key,{int ? keyName}) {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.COMMERCIAL_MASTER_GETSECTYPE + key,
        fun: ( map) {
          if (map is List && map.isNotEmpty) {
            secType.clear();
            for (var e in map) {
              secType.add(
                  DropDownValue.fromJsonDynamic(e, "eventCode", "eventName"));
            }
            if( keyName != null){
              for (var element in secType) {
                if(element.key.toString().trim() == keyName.toString().trim()){
                  selectedSecType?.value = DropDownValue(key:element.key.toString() ,value:element.value??"");
                  selectedSecType?.refresh();
                  break;
                }
              }
            }

          }
        });
  }

  getClientDetails(String clientName) {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.COMMERCIAL_MASTER_GETCLIENTDETAILS + clientName,
        fun: ( map) {
          if (map is List && map.isNotEmpty) {
            clientDetails.clear();

            for (var e in map) {
              clientDetails.add(
                  DropDownValue.fromJsonDynamic(e, "clientCode", "clientName"));
            }
          }
        });
  }

  getAgencyBrandType(String clientCode,{String? agName,String? agKey,
    String? braName,String ?braKey}) {
    try{
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.COMMERCIAL_MASTER_GETAGENCYBRAND + clientCode,
          fun: ( map) {
            if (map is Map && map.containsKey("result") && map['result'] != null) {
              agencyDetails.clear();
              agencyDetailsMaster.clear();
              brandType.clear();
              selectedBrandType = Rxn<DropDownValue>(null);
              selectedAgencyDetails = Rxn<DropDownValue>(null);
              agencyNameController.text = "";
              if (map['result'].containsKey('agencyType') && map['result']['agencyType'].length > 0) {
                agencyDetails.clear();
                agencyDetailsMaster.clear();
                map['result']['agencyType'].forEach((e) {
                  agencyDetails.add(DropDownValue.fromJsonDynamic(
                      e, "agencyCode", "agencyName"));
                  agencyDetailsMaster.add(DropDownValue.fromJsonDynamic(
                      e, "agencyCode", "agencyName"));
                });
                agencyDetails.refresh();
                agencyDetailsMaster.refresh();

              }
              if(agKey != null && agName != null && agKey.trim() != "" && agName.trim() != ""){
                selectedAgencyDetails?.value = DropDownValue(value:agName ,key:agKey );
                agencyNameController.text = agName;
                selectedAgencyDetails?.refresh();
              }
              if (map['result'].containsKey('brandType') && map['result']['brandType'].length > 0) {
                brandType.clear();
                map['result']['brandType'].forEach((e) {
                  brandType.add(DropDownValue.fromJsonDynamic(e, "brandCode", "brandName"));
                });
                brandType.refresh();
              }
              if(braKey != null && braName != null && braKey.trim() != "" && braName.trim() != ""){
                selectedBrandType?.value = DropDownValue(value:braName ,key:braKey );
                selectedBrandType?.refresh();
              }
            }
          });
    }catch(e){

    }

  }

  getLevelDetails(String brandCode) {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.COMMERCIAL_MASTER_GETLEVELSDETAILS + brandCode,
        fun: ( map) {
          if (map is Map && map.containsKey("result") && map['result'] != null) {
            level1Controller.text = map['result']['level1'];
            level2Controller.text = map['result']['level2'];
            level3Controller.text = map['result']['level3'];
            agencyNameFocus.requestFocus();
            // update(['level']);
          } else {
            level1Controller.text = "";
            level2Controller.text = "";
            level3Controller.text = "";
            agencyNameFocus.requestFocus();
            // update(['level']);
          }
        });
  }

  validateTxNo(String houseId, String exportTapeCode, String segNumber) {
    isListenerActive = false;
    Map<String, dynamic> postData = {
      "exportTapeCode": exportTapeCode ?? "",
      "segmentNumber": segNumber ?? "",
      "commercialCode": commercialCode ?? "0",
      "houseid": houseId ?? ""
    };
    // isListenerActive =true;
    print(">>>>" + postData.toString());
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.COMMERCIAL_MASTER_VALIDATE_TXNO,
        json: postData,
        fun: (Map map) {
          log("genericMessage>>>>" + map.toString());
          if (map is Map) {
            if (map['isError'] == false) {
              if (map['genericMessage'] != null &&
                  map['genericMessage'] != "null") {
                txNoController.text = "";
                Snack.callError(map['genericMessage'] ?? "");
              } else if (map['genericMessage'] == null ||
                  map['genericMessage'] == "null") {
                txNoController.text =
                    tapeIdController.value.text + "-" + segController.text;
                isListenerActive = false;
              } else {
                txNoController.text =
                    tapeIdController.value.text + "-" + segController.text;
                isListenerActive = false;
              }
            }
          } else {
            Snack.callError("Something went wrong");
          }
        });
  }

  validateTxNo1(String houseId, String exportTapeCode, String segNumber) {
    Map<String, dynamic> postData = {
      "exportTapeCode": exportTapeCode ?? "",
      "segmentNumber": segNumber ?? "",
      "commercialCode": commercialCode ?? "0",
      "houseid": houseId ?? ""
    };
    isListenerActive = false;
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.COMMERCIAL_MASTER_VALIDATE_TXNO,
        json: postData,
        fun: (map) {
          if (map is Map) {
            if (map['isError'] == false) {
              if (map['genericMessage'] != null &&
                  map['genericMessage'] != "null") {
                txNoController.text = "";
                isListenerActive = false;
                Snack.callError(map['genericMessage'] ?? "");
              } else if (map['genericMessage'] == null ||
                  map['genericMessage'] == "null") {
                txNoController.text =
                    tapeIdController.value.text + "-" + segController.text;
                isListenerActive = false;

                fetchCommercialTapeMasterData(
                    "",
                    tapeIdController.value.text,
                    int.parse(
                        (segController.text != null && segController.text != "")
                            ? segController.text
                            : "0"),
                    "");
              } else {
                txNoController.text =
                    tapeIdController.value.text + "-" + segController.text;
                isListenerActive = false;

                fetchCommercialTapeMasterData(
                    "",
                    tapeIdController.value.text,
                    int.parse(
                        (segController.text != null && segController.text != "")
                            ? segController.text
                            : "0"),
                    "");
              }
            }
          } else {
            Snack.callError("Something went wrong");
          }
        });
  }

  getAgencyDetails(String data) {
    Map<String, dynamic> postData = {
      "AgencyName": data,
      "clientCode": selectedClientDetails?.value?.key ?? "",
    };
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.COMMERCIAL_MASTER_GET_AGENCYDETAILS,
        json: postData,
        fun: (map) {
          // print("map>>>" + map.toString());
          if (map is Map && map.containsKey("result") && map['result'] != null) {
            agencyDetails.clear();
            for (var e in map['result']) {
              agencyDetails.add(DropDownValue.fromJsonDynamic(e, "agencyCode", "agencyName"));
            }
            // agencyDetails.refresh();
          } else {
            // agencyDetailsMaster
            agencyDetails.clear();
            agencyDetails.addAll(agencyDetailsMaster);
            // agencyDetails.refresh();
          }
        });
  }

  CommercialTapeMasterData? commercialTapeMasterData;
  var df = DateFormat('yyyy-MM-ddTHH:mm:ss');

  fetchCommercialTapeMasterData(
      String caption, String tapeCode, int segNumber, String clockId) {
    LoadingDialog.call();
    isListenerActive = false;
    // isListenerActive = true;
    Map<String, dynamic> postData = {
      "commercialCode": "0",
      "commercialCaption": caption ?? "",
      "exportTapeCode": tapeCode ?? "",
      "segmentNumber": segNumber ?? 0,
      "clockid": clockId ?? ""
    };
    // Get.back();
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.COMMERCIAL_MASTER_GET_COMMERCIALTAPEMASTER,
        json: postData,
        fun: (map) {
          closeDialogIfOpen();
          if (map is Map && map.containsKey("result") &&  map['result'].isNotEmpty) {
            commercialTapeMasterData =
                CommercialTapeMasterData.fromJson(map['result'][0]);
            eventList.clear();

            for (var element in language) {
              if (element.key == commercialTapeMasterData!.languagecode) {
                selectedLanguage = element;
                break;
              }
            }
            for (var element in revenueType) {
              if (element.key == commercialTapeMasterData!.eventtypecode) {
                selectedRevenueType = element;
                break;
              }
            }
            for (var element in tapeType) {
              if (element.key == commercialTapeMasterData!.tapeTypeCode) {
                selectedTapeType = element;
                break;
              }
            }
            for (var element in censorShipType) {
              if (element.key == commercialTapeMasterData!.censorshipCode) {
                selectedCensorShipType = element;
                break;
              }
            }
            // selectedRevenueType = revenueType.where((p0) => p0.key == commercialTapeMasterData.)

            /*selectedRevenueType = revenueType
                .where(
                    (p0) => p0.key == commercialTapeMasterData!.eventtypecode)
                .toList()[0];

            selectedTapeType = tapeType
                .where((p0) => p0.key == commercialTapeMasterData!.tapeTypeCode)
                .toList()[0];
            selectedCensorShipType = censorShipType
                .where(
                    (p0) => p0.key == commercialTapeMasterData!.censorshipCode)
                .toList()[0];*/

            selectedClientDetails?.value = DropDownValue(
                value: commercialTapeMasterData?.clientName,
                key: commercialTapeMasterData?.clientCode);
            clientController.text = commercialTapeMasterData!.clientName ?? "";

            /*selectedAgencyDetails?.value = DropDownValue(
                value: commercialTapeMasterData?.agencyName,
                key: commercialTapeMasterData?.agencyCode);

            selectedBrandType?.value = DropDownValue(
                value: commercialTapeMasterData?.brandName,
                key: commercialTapeMasterData?.brandCode);*/



            agencyNameController.text =
                commercialTapeMasterData!.agencyName ?? "";

            level1Controller.text = commercialTapeMasterData?.level1Name ?? "";
            level2Controller.text = commercialTapeMasterData?.level2Name ?? "";
            level3Controller.text = commercialTapeMasterData?.level3Name ?? "";

            somController.text = commercialTapeMasterData?.som ?? "";
            eomController.text = commercialTapeMasterData?.eom ?? "";

            num secondSom =
                Utils.oldBMSConvertToSecondsValue(value: somController.text);
            num secondEom =
                Utils.oldBMSConvertToSecondsValue(value: eomController.text);
            duration.value.text =
                Utils.convertToTimeFromDouble(value: secondEom - secondSom);

            agencyIdController.text =
                commercialTapeMasterData?.agencytapeid ?? "";
            // print(">>>>jks "+somController.text);
            tapeIdController.value.text =
                commercialTapeMasterData?.exportTapeCode ?? "";

            durationController.text =
                commercialTapeMasterData?.commercialDuration.toString() ?? "";
            captionController.text =
                commercialTapeMasterData?.commercialCaption ?? "";
            txCaptionController.text =
                commercialTapeMasterData?.exportTapeCaption ?? "";
            segController.text =
                commercialTapeMasterData?.segmentNumber.toString() ?? "";
            txNoController.text = commercialTapeMasterData!.houseID ?? "";
            // agencyIdController.text=commercialTapeMasterData.ag;
            productNameController.text =
                commercialTapeMasterData?.productName ?? "";
            // agencyNameController.text="";
            clockIdController.text = commercialTapeMasterData?.clockid ?? "";
            endDateController.text = DateFormat("dd-MM-yyyy").format(
                df.parse(commercialTapeMasterData!.killDate.toString()));
            dispatchDateController.text = DateFormat("dd-MM-yyyy").format(
                df.parse(commercialTapeMasterData!.despatchDate.toString()));
            commercialCode = commercialTapeMasterData!.commercialCode ?? "0";
            // eventList
            if (commercialTapeMasterData?.lstAnnotation != null &&
                (commercialTapeMasterData?.lstAnnotation?.length ?? 0) > 0) {
              commercialTapeMasterData?.lstAnnotation?.forEach((element) {
                eventList.add(Annotations(
                    tcIn: element.tCin,
                    tcOut: element.tCout,
                    eventName: element.eventname));
              });
            }

            getSecType(selectedRevenueType?.key??"",keyName:commercialTapeMasterData?.eventsubtype);

            getAgencyBrandType(commercialTapeMasterData?.clientCode??"",
                agKey:commercialTapeMasterData?.agencyCode,
                agName: commercialTapeMasterData?.agencyName,
                braKey: commercialTapeMasterData?.brandCode ,
                braName: commercialTapeMasterData?.brandName  );

            isEnable = true;
            isEnableSelective = false;

            update(['updateLeft', 'eventTable']);
            clockIdFocus.nextFocus();
          }
        });
  }

  getTapeId(String? key) {
    // isListenerActive = true;
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.COMMERCIAL_MASTER_GET_TAPID(
            selectedRevenueType!.key ?? "", selectedSecType?.value?.key ?? ""),
        fun: (String map) {
          if (map != "" && map != null) {
            tapeIdController.value.text = map ?? "";

            fetchCommercialTapeMasterData(
                "",
                tapeIdController.value.text,
                int.parse(
                    (segController.text != null && segController.text != "")
                        ? segController.text
                        : "0"),
                "");
          } else {
            // isListenerActive =true;
            tapeIdController.value.text = "";
            // update(['tapeId']);
          }
        });
  }

  @override
  void onReady() {
    super.onReady();
    fetchUserSetting1();
  }

  UserDataSettings? userDataSettings;

  fetchUserSetting1() async {
    userDataSettings = await Get.find<HomeController>().fetchUserSetting2();
  }

  @override
  void onClose() {
    /*captionFocus.dispose();
     tapeIdFocus.dispose();
     clockIdFocus.dispose();*/
    super.onClose();
  }

  @override
  void dispose() {
    /*captionFocus.dispose();
    tapeIdFocus.dispose();
    clockIdFocus.dispose();*/
    super.dispose();
  }

  void increment() => count.value++;

  formHandler(String string) {
    if (string == "Clear") {
      clearAll();
    } else if (string == "Save") {
      saveData();
    } else if (string == "Exit") {
      Get.find<HomeController>().postUserGridSetting2(listStateManager: [
        {"gridStateManager": gridStateManager},
      ]);
    } else if (string == "Search") {
      search();
    } else if (string == "Docs") {
      docs();
    }
  }
}

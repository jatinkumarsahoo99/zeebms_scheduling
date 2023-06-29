import 'dart:convert';
import 'dart:developer';

import 'package:bms_scheduling/app/controller/HomeController.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/LoadingDialog.dart';
import '../../../../widgets/Snack.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../data/DropDownValue.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/Utils.dart';
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
  DropDownValue? selectedSecType;
  DropDownValue? selectedClientDetails;
  DropDownValue? selectedAgencyDetails;
  DropDownValue? selectedBrandType;
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
  TextEditingController txNoController = TextEditingController();
  TextEditingController agencyIdController = TextEditingController();
  TextEditingController productNameController = TextEditingController();
  TextEditingController agencyNameController = TextEditingController();
  TextEditingController clockIdController = TextEditingController();

  TextEditingController endDateController = TextEditingController();
  TextEditingController dispatchDateController = TextEditingController();

  Rx<TextEditingController> duration = TextEditingController().obs;
  Rx<TextEditingController> tapeIdController = TextEditingController().obs;

  List<Annotations> eventList = [];
  String? commercialCode = '0';

  bool isEnable = true;
  FocusNode captionFocus = FocusNode();
  FocusNode tapeIdFocus = FocusNode();
  FocusNode clockIdFocus = FocusNode();
  FocusNode txNoFocus = FocusNode();

  // bool segEnable = true;
  bool isListenerActive = true;

  @override
  void onInit() {
    duration.value.text = "00:00:00:00";
    segController.text = '1';
    getAllDropDownList();
    captionFocus.addListener(() {
      if ( isListenerActive && !captionFocus.hasFocus) {
        print("api called on focus changed");
        txCaptionController.text =
            captionController.text.toString().toUpperCase();
        fetchCommercialTapeMasterData(
            captionController.text,
            "",
            0,
            "");
      }if(captionFocus.hasFocus){
        isListenerActive=true;
      }

    });
    tapeIdFocus.addListener(() {
      if (isListenerActive && !tapeIdFocus.hasFocus) {
        if (segController.text == null || segController.text == "") {
          // validateTxNo(tapeIdController.value.text + "-" + "1" , "", "");
          validateTxNo("" ,tapeIdController.value.text,segController.text);
        } else {
          // validateTxNo(tapeIdController.value.text + "-" + segController.text, "", "");
          validateTxNo("",tapeIdController.value.text,segController.text);
        }
      }if(tapeIdFocus.hasFocus){
        isListenerActive=true;
      }
    });
    txNoFocus.addListener(() {
      if (!txNoFocus.hasFocus) {
        validateTxNo(txNoController.text,"", "");
      }
    });
    clockIdFocus.addListener(() {
      if (isListenerActive && !clockIdFocus.hasFocus) {
        if(clockIdController.text != "" && clockIdController.text != null){
          fetchCommercialTapeMasterData(
              "",
              "",
              0,
              clockIdController.text);
        }else{
          Snack.callError("Please enter clock id");
        }
      }if(clockIdFocus.hasFocus){
        isListenerActive=true;
      }
    });

    super.onInit();
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
    duration.value.text =
        Utils.convertToTimeFromDouble(value: secondEom - secondSom);

    var sec = Utils.oldBMSConvertToSecondsValue(value: duration.value.text);

    print(">>>>>>>>>" + duration.value.text);
    print(">>>>>>>>>" + sec.toString());
  }
  bool contin = true;
  saveData() {
    if (captionController.text == "" || captionController.text == null) {
      Snack.callError("Please enter caption");
    } else if((commercialCode != "0" && commercialCode != "") && contin ){

      LoadingDialog.recordExists(
          "Do you want to modify it?",
              (){
            isEnable = true;
            isListenerActive =false;
            contin= false;
            update(['updateLeft']);
          },cancel: (){
        contin= false;
        Get.back();
      });
    }
    else if (txCaptionController.text == "" ||
        txCaptionController.text == null) {
      Snack.callError("Please enter tx-caption");
    } else if (selectedLanguage == null) {
      Snack.callError("Please select language");
    } else if (selectedRevenueType == null) {
      Snack.callError("Please select revenueType");
    } else if (selectedSecType == null) {
      Snack.callError("Please select secType");
    } else if (tapeIdController.value.text == null ||
        tapeIdController.value.text == "") {
      Snack.callError("Please enter tapeId");
    } else if (txNoController.text == null || txNoController.text == "") {
      Snack.callError("Please enter TX No");
    } else if (agencyIdController.text == null ||
        agencyIdController.text == "") {
      Snack.callError("Please enter agency Id");
    } else if (selectedTapeType == null) {
      Snack.callError("Please select tape type");
    } else if (censorShipType == null) {
      Snack.callError("Please select censorShipType");
    } else if (somController.text == "00:00:00:00") {
      Snack.callError("Please enter SOM");
    } else if (eomController.text == "00:00:00:00") {
      Snack.callError("Please enter EOM");
    } else if (selectedClientDetails == null) {
      Snack.callError("Please select client");
    } else if (selectedBrandType == null) {
      Snack.callError("Please select brand");
    } else if (productNameController.text == null ||
        productNameController.text == "") {
      Snack.callError("Please enter product name");
    }
    /*else if(level1Controller.text == null || level1Controller.text==""){
      Snack.callError("Please enter level1");
    }else if(level2Controller.text == null || level2Controller.text==""){
      Snack.callError("Please enter level2");
    }else if(level3Controller.text == null || level3Controller.text==""){
      Snack.callError("Please enter level3");
    }*/
    /* else if(clockIdController.text == null || clockIdController.text == ""){
      Snack.callError("Please enter clock id");
    }*/

    else if (eventList.isEmpty) {
      Snack.callError("Please add some event");
    } else {
      LoadingDialog.call();
      CommercialTapeMasterPostData commercialTapeMasterPostData =
          new CommercialTapeMasterPostData(
              commercialCaption: captionController.text,
              exportTapeCaption: txCaptionController.text,
              agencyCode: selectedAgencyDetails!.key,
              agencytapeid: agencyIdController.text,
              brandCode: selectedBrandType!.key,
              censorshipCode: selectedCensorShipType!.key,
              clockid: clockIdController.text,
              commercialCode: commercialCode ?? "0",
              eom: eomController.text,
              som: somController.text,
              commercialDuration:
                  Utils.oldBMSConvertToSecondsValue(value: duration.value.text)
                      .toString(),
              despatchDate: DateFormat('M/d/yyyy hh:mm:ss a').format(
                  DateFormat("dd-MM-yyyy").parse(dispatchDateController.text)),
              killDate: DateFormat('M/d/yyyy hh:mm:ss a').format(
                  DateFormat("dd-MM-yyyy").parse(endDateController.text)),
              eventsubtype: selectedSecType!.key ?? "",
              eventtypecode: selectedRevenueType!.key ?? "",
              houseID: txNoController.text,
              segmentNumber: segController.text,
              languagecode: selectedLanguage!.key,
              exportTapeCode: tapeIdController.value.text,
              tapeTypeCode: selectedTapeType!.key ?? "",
              annotations: eventList,
              recievedOn:
                  DateFormat('M/d/yyyy hh:mm:ss a').format(DateTime.now()));
      print((jsonEncode(commercialTapeMasterPostData.toJson())));

      Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.COMMERCIAL_MASTER_SAVE_COMMERCIALTAPE,
          json: commercialTapeMasterPostData.toJson(),
          fun: (map) {
            Get.back();
            print("map>>>>>" + map.toString());
            if (map is Map && map.containsKey("isError")) {
              if (map['isError'] == false) {
                LoadingDialog.callDataSavedMessage("Data Saved Successfully",callback: (){
                  clearAll();
                });

              } else {
                // Get.back();
                Snack.callError("Something went wrong");
              }
            } else {
              // Get.back();
              Snack.callError("Something went wrong");
            }
          });
    }
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

  getSecType(String key) {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.COMMERCIAL_MASTER_GETSECTYPE + key,
        fun: (List<dynamic> map) {
          log("map" + map.toString());
          secType.clear();
          if (map is List && map.isNotEmpty) {
            map.forEach((e) {
              secType.add(
                  DropDownValue.fromJsonDynamic(e, "eventCode", "eventName"));
            });
          }
        });
  }

  getClientDetails(String clientName) {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.COMMERCIAL_MASTER_GETCLIENTDETAILS + clientName,
        fun: (List<dynamic> map) {
          clientDetails.clear();
          if (map is List && map.isNotEmpty) {
            map.forEach((e) {
              clientDetails.add(
                  DropDownValue.fromJsonDynamic(e, "clientCode", "clientName"));
            });
          }
        });
  }

  getAgencyBrandType(String clientCode) {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.COMMERCIAL_MASTER_GETAGENCYBRAND + clientCode,
        fun: (Map map) {
          if (map is Map) {
            log("agencyType" + map['agencyType'].toString());
            agencyDetails.clear();
            agencyDetailsMaster.clear();
            brandType.clear();
            if (map.containsKey('agencyType') && map['agencyType'].length > 0) {
              log("agencyType" + map['agencyType'].toString());
              agencyDetails.clear();
              agencyDetailsMaster.clear();
              map['agencyType'].forEach((e) {
                agencyDetails.add(DropDownValue.fromJsonDynamic(
                    e, "agencyCode", "agencyName"));
                agencyDetailsMaster.add(DropDownValue.fromJsonDynamic(
                    e, "agencyCode", "agencyName"));
              });
            }
            if (map.containsKey('brandType') && map['brandType'].length > 0) {
              brandType.clear();
              map['brandType'].forEach((e) {
                brandType.add(
                    DropDownValue.fromJsonDynamic(e, "brandCode", "brandName"));
              });
            }
          }
        });
  }

  getLevelDetails(String brandCode) {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.COMMERCIAL_MASTER_GETLEVELSDETAILS + brandCode,
        fun: (Map map) {
          if (map is Map) {
            level1Controller.text = map['level1'];
            level2Controller.text = map['level2'];
            level3Controller.text = map['level3'];
            update(['level']);
          } else {
            level1Controller.text = "";
            level2Controller.text = "";
            level3Controller.text = "";
            update(['level']);
          }
        });
  }

  validateTxNo(String houseId,String exportTapeCode,String segNumber) {
    Map<String, dynamic> postData = {
      "exportTapeCode": exportTapeCode ?? "",
      "segmentNumber": segNumber ?? "",
      "commercialCode": commercialCode ?? "0",
      "houseid": houseId ?? ""
    };
    // isListenerActive =true;
    print(">>>>"+postData.toString());
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
                isListenerActive =false;
                update(['updateLeft']);
              } else {
                txNoController.text =
                    tapeIdController.value.text + "-" + segController.text;
                isListenerActive =false;
                update(['updateLeft']);
              }
            }
          } else {
            Snack.callError("Something went wrong");
          }
        });
  }
  validateTxNo1(String houseId,String exportTapeCode,String segNumber) {
    Map<String, dynamic> postData = {
      "exportTapeCode": exportTapeCode ?? "",
      "segmentNumber": segNumber ?? "",
      "commercialCode": commercialCode ?? "0",
      "houseid": houseId ?? ""
    };
    // isListenerActive =true;
    print(">>>>"+postData.toString());
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
                isListenerActive =false;
                update(['updateLeft']);
                fetchCommercialTapeMasterData(
                    "",
                    tapeIdController.value.text,
                    int.parse((segController.text != null && segController.text != "")
                        ? segController.text
                        : "0"), "");
              } else {
                txNoController.text =
                    tapeIdController.value.text + "-" + segController.text;
                isListenerActive =false;
                update(['updateLeft']);
                fetchCommercialTapeMasterData(
                    "",
                    tapeIdController.value.text,
                    int.parse((segController.text != null && segController.text != "")
                        ? segController.text
                        : "0"), "");
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
      "clientCode": selectedClientDetails!.key ?? "",
    };
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.COMMERCIAL_MASTER_GET_AGENCYDETAILS,
        json: postData,
        fun: (List<dynamic> map) {
          if (map.isNotEmpty) {
            agencyDetails.clear();
            for (var e in map) {
              agencyDetails.add(
                  DropDownValue.fromJsonDynamic(e, "agencyCode", "agencyName"));
            }
          } else {
            // agencyDetailsMaster
            agencyDetails.clear();
            agencyDetails.addAll(agencyDetailsMaster);
          }
        });
  }

  CommercialTapeMasterData? commercialTapeMasterData;
  var df = DateFormat('yyyy-MM-ddTHH:mm:ss');

  fetchCommercialTapeMasterData(
      String caption, String tapeCode, int segNumber, String clockId) {
    LoadingDialog.call();
    // isListenerActive = true;
    Map<String, dynamic> postData = {
      "commercialCode": "0",
      "commercialCaption": caption ?? "",
      "exportTapeCode": tapeCode ?? "",
      "segmentNumber": segNumber ?? 0,
      "clockid": clockId ?? ""
    };
    // Get.back();
    print("postData>>>"+postData.toString());
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.COMMERCIAL_MASTER_GET_COMMERCIALTAPEMASTER,
        json: postData,
        fun: (map) {
          Get.back();
          log("map>>> " + map.toString());
          if (map is List && map.isNotEmpty) {
            commercialTapeMasterData =
                CommercialTapeMasterData.fromJson(map[0]);
            print(">>>>" + commercialTapeMasterData!.toJson().toString());
            // selectedLanguage =  ;
            /*selectedLanguage = language
                .where((el) => el.key == commercialTapeMasterData!.languagecode)
                .toList()[0];*/

            for (var element in language) {
              if(element.key == commercialTapeMasterData!.languagecode){
                selectedLanguage = element;
                break;
              }
            }
            for (var element in revenueType) {
              if(element.key == commercialTapeMasterData!.eventtypecode){
                selectedRevenueType = element;
                break;
              }
            }
            for (var element in tapeType) {
              if(element.key == commercialTapeMasterData!.tapeTypeCode){
                selectedTapeType = element;
                break;
              }
            }
            for (var element in censorShipType) {
              if(element.key == commercialTapeMasterData!.censorshipCode){
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



            selectedSecType = DropDownValue(
                key: commercialTapeMasterData!.eventsubtype.toString() ?? "",
                value: selectedRevenueType!.value);

            selectedClientDetails = DropDownValue(
                value: commercialTapeMasterData!.clientName,
                key: commercialTapeMasterData!.clientCode);
            clientController.text = commercialTapeMasterData!.clientName ?? "";

            selectedAgencyDetails = DropDownValue(
                value: commercialTapeMasterData!.agencyName,
                key: commercialTapeMasterData!.agencyCode);

            selectedBrandType = DropDownValue(
                value: commercialTapeMasterData!.brandName,
                key: commercialTapeMasterData!.brandCode);

            agencyNameController.text =
                commercialTapeMasterData!.agencyName ?? "";

            level1Controller.text = commercialTapeMasterData!.level1Name ?? "";
            level2Controller.text = commercialTapeMasterData!.level2Name ?? "";
            level3Controller.text = commercialTapeMasterData!.level3Name ?? "";

            somController.text = commercialTapeMasterData!.som ?? "";
            eomController.text = commercialTapeMasterData!.eom ?? "";

            num secondSom =
                Utils.oldBMSConvertToSecondsValue(value: somController.text);
            num secondEom =
                Utils.oldBMSConvertToSecondsValue(value: eomController.text);
            duration.value.text =
                Utils.convertToTimeFromDouble(value: secondEom - secondSom);

            agencyIdController.text =
                commercialTapeMasterData!.agencytapeid ?? "";
            // print(">>>>jks "+somController.text);
            tapeIdController.value.text =
                commercialTapeMasterData!.exportTapeCode ?? "";

            durationController.text =
                commercialTapeMasterData!.commercialDuration.toString() ?? "";
            captionController.text =
                commercialTapeMasterData!.commercialCaption ?? "";
            txCaptionController.text =
                commercialTapeMasterData!.exportTapeCaption ?? "";
            segController.text =
                commercialTapeMasterData!.segmentNumber.toString() ?? "";
            txNoController.text = commercialTapeMasterData!.houseID ?? "";
            // agencyIdController.text=commercialTapeMasterData.ag;
            productNameController.text =
                commercialTapeMasterData!.productName ?? "";
            // agencyNameController.text="";
            clockIdController.text = commercialTapeMasterData!.clockid ?? "";
            endDateController.text = DateFormat("dd-MM-yyyy").format(
                df.parse(commercialTapeMasterData!.killDate.toString()));
            dispatchDateController.text = DateFormat("dd-MM-yyyy").format(
                df.parse(commercialTapeMasterData!.despatchDate.toString()));
            commercialCode = commercialTapeMasterData!.commercialCode ?? "0";
            print(">>>>jks " + endDateController.text);

            isEnable = false;
            isListenerActive =false;

            update(['updateLeft']);
          }
          else{
            isListenerActive =false;
            commercialCode="0";
          }
        });
  }

  getTapeId() {
    // isListenerActive = true;
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.COMMERCIAL_MASTER_GET_TAPID(
            selectedRevenueType!.key ?? "", selectedSecType!.key ?? ""),
        fun: (String map) {
          if (map != "" && map != null) {
            tapeIdController.value.text = map ?? "";
            // validateTxNo(tapeIdController.value.text +"-"+ segController.text);
            isListenerActive =false;
            update(['tapeId']);
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
    }
  }
}

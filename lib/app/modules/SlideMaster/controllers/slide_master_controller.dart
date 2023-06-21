import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/controller/MainController.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/PermissionModel.dart';
import '../../../providers/Utils.dart';
import '../../../routes/app_pages.dart';
import '../../CommonSearch/views/common_search_view.dart';

class SlideMasterController extends GetxController {
  var controllsEnable = true.obs;

  var locationFn = FocusNode(),
      tapeIDFN = FocusNode(),
      segFN = FocusNode(),
      houseIDFN = FocusNode(),
      txCaptionFN = FocusNode(),
      eomFN = FocusNode(),
      captionFN = FocusNode();
  var isDated = true.obs;
  var selectedRadio = "Dated".obs;

  var locationList = <DropDownValue>[].obs, channelList = <DropDownValue>[].obs;
  var tapeTypeList = <Map<String, dynamic>>[].obs;
  var slideTypeList = <Map<String, dynamic>>[].obs;

  var houseIDCtr = TextEditingController(),
      txCaptionCtr = TextEditingController(),
      segNoCtr = TextEditingController(),
      tapeIDCtr = TextEditingController(),
      captionCtr = TextEditingController(),
      somCtr = TextEditingController(text: "00:00:00:00"),
      eomCtr = TextEditingController(text: "00:00:00:00"),
      durationCtr = TextEditingController(text: "00:00:00:00"),
      updateTodateCtr = TextEditingController();
  List<PermissionModel>? formPermissions;

  DropDownValue? selectedLocation, selectedChannel, selectedTape, selectedSlide;

  String strCode = "", strTapeID = "", strSegmentNumber = "", strHouseID = "";

  @override
  void onInit() {
    formPermissions = Utils.fetchPermissions1(Routes.SLIDE_MASTER.replaceAll("/", ""));
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    getOnLoadData();
    addListeners2();
  }

  addListeners2() {
    captionFN.addListener(() {
      if (!captionFN.hasFocus) {
        txCaptionCtr.text = captionCtr.text;
      }
    });

    /// TAPE ID
    // tapeIDFN.addListener(() {
    //   if (!tapeIDFN.hasFocus) {
    //     tapeIDLeave();
    //   }
    // });
    tapeIDFN.onKey = (node, event) {
      // print("isShiftPressed:${!event.isShiftPressed} hasPrimaryFocus:${tapeIDFN.hasFocus} logicalKey:${event.logicalKey.debugName}");
      if (!event.isShiftPressed && event.logicalKey == LogicalKeyboardKey.tab && tapeIDCtr.text.isNotEmpty) {
        tapeIDLeave().then((value) {
          if (value) {
            tapeIDFN.requestFocus();
          } else {
            closeDialog();
            segFN.requestFocus();
          }
        });
        return KeyEventResult.handled;
      } else {
        return KeyEventResult.ignored;
      }
    };

    /// SEG NO.
    // segFN.addListener(() {
    //   if (!segFN.hasFocus) {
    //     segNoLeave();
    //   }
    // });
    segFN.onKey = (node, event) {
      if (!event.isShiftPressed && event.logicalKey == LogicalKeyboardKey.tab && segNoCtr.text.isNotEmpty) {
        segNoLeave().then((value) {
          if (value) {
            segFN.requestFocus();
          } else {
            closeDialog();
            houseIDFN.requestFocus();
          }
        });
        return KeyEventResult.handled;
      } else {
        return KeyEventResult.ignored;
      }
    };

    /// HOUSE ID
    // houseIDFN.addListener(() {
    //   if (!houseIDFN.hasFocus) {
    //     houseIDLeave();
    //   }
    // });
    houseIDFN.onKey = (node, event) {
      if (!event.isShiftPressed && event.logicalKey == LogicalKeyboardKey.tab && houseIDCtr.text.isNotEmpty) {
        houseIDLeave().then((value) {
          if (value) {
            houseIDFN.requestFocus();
          } else {
            closeDialog();
            txCaptionFN.requestFocus();
          }
        });
        return KeyEventResult.handled;
      } else {
        return KeyEventResult.ignored;
      }
    };

    /// EOM
    eomFN.addListener(() {
      if (!eomFN.hasFocus) {
        var diff = (Utils.oldBMSConvertToSecondsValue(value: eomCtr.text) - Utils.oldBMSConvertToSecondsValue(value: somCtr.text));
        if (diff.isNegative) {
          eomCtr.clear();
          LoadingDialog.showErrorDialog("EOM should not less than SOM", callback: () {
            eomFN.requestFocus();
          });
        } else {
          durationCtr.text = Utils.convertToTimeFromDouble(value: diff);
        }
      }
    });
  }

  Future<bool> tapeIDLeave() async {
    bool hasError = false;
    if (tapeIDCtr.text.isNotEmpty) {
      houseIDCtr.text = tapeIDCtr.text;
      await checkRetrieve();
      if (tapeIDCtr.text.isNotEmpty && tapeIDCtr.text != "0") {
        LoadingDialog.call();
        await Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.SLIDE_MASTER_TAPE_ID_LEAVE,
          fun: (resp) {
            closeDialog();
            if (resp != null && resp is Map<String, dynamic> && resp['tapeid'] != null && resp['tapeid']['eventName'] != null) {
              hasError = true;
              LoadingDialog.showErrorDialog(resp['tapeid']['eventName'].toString(), callback: () {
                tapeIDFN.requestFocus();
              });
            }
            if (strCode.isNotEmpty) {
              tapeIDCtr.text = strTapeID;
            }
          },
          json: {
            "exportTapeCode": tapeIDCtr.text,
            "segmentNumber": segNoCtr.text,
            "code": strCode,
            "houseID": houseIDCtr.text,
            "eventType": "",
          },
        );
      }
    }
    return hasError;
  }

  Future<bool> segNoLeave() async {
    bool hasError = false;
    await checkRetrieve();
    if (tapeIDCtr.text.isNotEmpty && segNoCtr.text != "0") {
      LoadingDialog.call();
      await Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.SLIDE_MASTER_TAPE_SEG_NO_LEAVE,
        fun: (resp) {
          closeDialog();
          if (resp != null && resp is Map<String, dynamic> && resp['segNumber'] != null && resp['segNumber']['eventName'] != null) {
            hasError = true;
            LoadingDialog.showErrorDialog(resp['segNumber']['eventName'].toString(), callback: () {
              segFN.requestFocus();
            });
            if (strCode.isNotEmpty) {
              houseIDCtr.text = strHouseID;
            }
          }
        },
        json: {
          "exportTapeCode": tapeIDCtr.text,
          "segmentNumber": segNoCtr.text,
          "code": strCode,
          "houseID": houseIDCtr.text,
          "eventType": "",
        },
      );
    }
    return hasError;
  }

  Future<bool> houseIDLeave() async {
    bool foundData = false;
    if (houseIDCtr.text.isNotEmpty) {
      LoadingDialog.call();
      await Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.SLIDE_MASTER_TAPE_HOUSE_ID_LEAVE,
        fun: (resp) {
          closeDialog();
          if (resp != null && resp is Map<String, dynamic> && resp['houseID'] != null && resp['houseID']['eventName'] != null) {
            foundData = true;
            LoadingDialog.showErrorDialog(resp['houseID']['eventName'].toString(), callback: () {
              houseIDFN.requestFocus();
            });
            if (strCode.isNotEmpty) {
              segNoCtr.text = strHouseID;
            }
          }
        },
        json: {
          "exportTapeCode": "",
          "segmentNumber": segNoCtr.text,
          "code": strCode,
          "houseID": houseIDCtr.text,
          "eventType": "",
        },
      );
    }
    return foundData;
  }

  closeDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
      while ((Get.isDialogOpen ?? false)) {
        Get.back();
      }
    }
  }

  retrievRecord({required String tapeid, required String segNoT, required String locationCode, required String channelCode}) async {
    LoadingDialog.call();
    await Get.find<ConnectorControl>().POSTMETHOD(
      api: ApiFactory.SLIDE_MASTER_GET_RETRIVE_DATA,
      fun: (resp) {
        closeDialog();
        if (resp != null && (resp is Map<String, dynamic>) && resp['retriveRecord'] != null && (resp['retriveRecord'] as List<dynamic>).isNotEmpty) {
          var map = (resp['retriveRecord'] as List<dynamic>)[0];

          if (map['stillCode'] != null) {
            strCode = map['stillCode'];
          }

          if (map['locationCode'] != null) {
            var tempLoc = locationList.firstWhereOrNull((element) => element.key == map['locationCode']);
            if (tempLoc != null) {
              selectedLocation = tempLoc;
              locationList.refresh();
            }
          }
          if (map['channelCode'] != null) {
            var tempChannel = channelList.firstWhereOrNull((element) => element.key == map['channelCode']);
            if (tempChannel != null) {
              selectedChannel = tempChannel;
              channelList.refresh();
            } else {
              handleOnChangedLocation(selectedLocation).then((value) {
                var tempChannel = channelList.firstWhereOrNull((element) => element.key == map['channelCode']);
                if (tempChannel != null) {
                  selectedChannel = tempChannel;
                  channelList.refresh();
                }
              });
            }
          }

          ///TAPE ID
          if (map['exportTapeCode'] != null) {
            tapeIDCtr.text = map['exportTapeCode'].toString();
          }

          if (map['segmentNumber'] != null) {
            segNoCtr.text = map['segmentNumber'].toString();
          }

          if (map['houseId'] != null) {
            houseIDCtr.text = map['houseId'].toString();
          }

          /// TX Caption
          if (map['exportTapeCaption'] != null) {
            if (map['exportTapeCaption'].toString().contains("/")) {
              txCaptionCtr.text = map['exportTapeCaption'].toString().split("/")[1];
            } else {
              txCaptionCtr.text = map['exportTapeCaption'].toString();
            }
          }

          ///Caption
          if (map['slideCaption'] != null) {
            captionCtr.text = map['slideCaption'];
          }
          if (map['slideType'] != null) {
            var tempSlideType =
                slideTypeList.firstWhereOrNull((element) => element['lookupCode'].toString().trim() == map['slideType'].toString().trim());
            if (tempSlideType != null) {
              selectedSlide = DropDownValue(
                key: tempSlideType['lookupCode'].toString(),
                value: tempSlideType['lookupName'].toString(),
              );
              slideTypeList.refresh();
            }
          }

          if (map['tapeTypeCode'] != null) {
            var tempTapeType =
                tapeTypeList.firstWhereOrNull((element) => element['tapetypecode'].toString().trim() == map['tapeTypeCode'].toString().trim());
            if (tempTapeType != null) {
              selectedTape = DropDownValue(
                key: tempTapeType['tapetypecode'],
                value: tempTapeType['tapeTypeName'],
              );
              tapeTypeList.refresh();
            }
          }

          if (map['som'] != null) {
            somCtr.text = map['som'];
          }

          if (map['killDate'] != null) {
            updateTodateCtr.text = DateFormat("dd-MM-yyyy").format(DateFormat("yyyy-MM-ddThh:mm:ss").parse(map['killDate'].toString()));
          }

          strTapeID = tapeIDCtr.text;

          strHouseID = houseIDCtr.text;
          // var diff = (Utils.oldBMSConvertToSecondsValue(value: eomCtr.text) - Utils.oldBMSConvertToSecondsValue(value: somCtr.text));
          if (map['exportTapeDuration'] != null) {
            durationCtr.text = Utils.convertToTimeFromDouble(value: map['exportTapeDuration']);
          }

          if (map['eom'] != null) {
            eomCtr.text = map['eom'];
          }

          if (map['eom'] == null) {
            eomCtr.text = Utils.convertToTimeFromDouble(
                value: Utils.convertToSecond(value: map['exportTapeDuration']) + Utils.convertToSecond(value: map['som']));
          }
          controllsEnable.value = false;
        }
      },
      json: {
        "segmentNumber": num.parse(segNoT),
        "exportTapeCode": tapeid,
      },
    );
  }

  Future<void> checkRetrieve() async {
    if (segNoCtr.text.isNotEmpty && tapeIDCtr.text.isNotEmpty) {
      strCode = "";
      await retrievRecord(
        tapeid: tapeIDCtr.text,
        segNoT: segNoCtr.text,
        locationCode: selectedLocation?.key ?? " ",
        channelCode: selectedChannel?.key ?? " ",
      );
    }
  }

  clearData() {
    selectedLocation = null;
    selectedChannel = null;
    selectedTape = null;
    selectedSlide = null;
    txCaptionCtr.clear();
    segNoCtr.text = "1";
    tapeIDCtr.text = "AUTO";
    houseIDCtr.text = "AUTO";
    controllsEnable.value = true;
    captionCtr.clear();
    somCtr.text = "00:00:00:00";
    eomCtr.text = "00:00:00:00";
    durationCtr.text = "00:00:00:00";
    selectedRadio.value = "Dated";
    updateTodateCtr.clear();
    locationList.refresh();
    channelList.refresh();
    tapeTypeList.refresh();
    slideTypeList.refresh();
    locationFn.requestFocus();
  }

  formHandler(String btnName) {
    if (btnName == "Clear") {
      clearData();
    } else if (btnName == "Save") {
      if (strCode.isNotEmpty) {
        LoadingDialog.recordExists("Record Already exist!\nDo you want to modify it?", () {
          saveData();
        });
      } else {
        saveData();
      }
    } else if (btnName == "Search") {
      Get.to(
        SearchPage(
          key: Key("Slide Master"),
          screenName: "Slide Master",
          appBarName: "Slide Master",
          strViewName: "vTesting",
          isAppBarReq: true,
        ),
      );
    }
  }

  saveData() {
    if (selectedLocation == null) {
      LoadingDialog.showErrorDialog("Please select Location Name.");
    } else if (selectedChannel == null) {
      LoadingDialog.showErrorDialog("Please select Channel Name.");
    } else if (selectedTape == null) {
      LoadingDialog.showErrorDialog("Please select Tape.");
    } else if (tapeIDCtr.text.isEmpty) {
      LoadingDialog.showErrorDialog("Tape ID cannot be empty.", callback: () {
        tapeIDFN.requestFocus();
      });
    } else if (segNoCtr.text.isEmpty) {
      LoadingDialog.showErrorDialog("Segment No. cannot be empty.", callback: () {
        segFN.requestFocus();
      });
    } else if (strCode.isEmpty && strCode == "0") {
      LoadingDialog.showErrorDialog("Segment No. cannot be ZERO.", callback: () {
        segFN.requestFocus();
      });
    } else if (houseIDCtr.text.isEmpty) {
      LoadingDialog.showErrorDialog("House ID cannot be empty.", callback: () {
        houseIDFN.requestFocus();
      });
    } else if (txCaptionCtr.text.isEmpty) {
      LoadingDialog.showErrorDialog("Export Tape Caption cannot be empty.", callback: () {
        txCaptionFN.requestFocus();
      });
    } else if (somCtr.text.isEmpty) {
      LoadingDialog.showErrorDialog("Please enter SOM", callback: () {
        txCaptionFN.requestFocus();
      });
    } else if (durationCtr.text.isEmpty || durationCtr.text == "00:00:00:00") {
      LoadingDialog.showErrorDialog("Duration cannot be empty or 00:00:00:00.", callback: () {
        txCaptionFN.requestFocus();
      });
    } else if (eomCtr.text.isEmpty) {
      LoadingDialog.showErrorDialog("Please enter EOM", callback: () {
        txCaptionFN.requestFocus();
      });
    } else if ((Utils.oldBMSConvertToSecondsValue(value: eomCtr.text) - Utils.oldBMSConvertToSecondsValue(value: somCtr.text)).isNegative) {
      LoadingDialog.showErrorDialog("EOM should not less than SOM", callback: () {
        eomFN.requestFocus();
      });
    } else {
      LoadingDialog.call();
      Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.SLIDE_MASTER_TAPE_SAVE_DATA,
        fun: (resp) {
          closeDialog();
          if (resp != null && resp is Map<String, dynamic> && resp['saveRecords'] != null && resp['saveRecords']['strMessage'] != null) {
            if (resp['saveRecords']['strMessage'].toString().contains("Record is inserted successfully.")) {
              LoadingDialog.callDataSaved(msg: resp.toString());
            } else {
              LoadingDialog.showErrorDialog(resp.toString());
            }
          } else {
            LoadingDialog.showErrorDialog(resp.toString());
          }
        },
        json: {
          "slideCode": strCode,
          "slideCaption": captionCtr.text,
          "locationCode": selectedLocation?.key,
          "channelCode": selectedChannel?.key,
          "modifiedBy": Get.find<MainController>().user?.logincode,
          "exportTapeDuration": Utils.convertToSecond(value: durationCtr.text),
          "exportTapeCode": tapeIDCtr.text,
          "exportTapeCaption": "L/${txCaptionCtr.text}",
          "slideType": selectedSlide?.key,
          "tapeTypeCode": selectedTape?.key,
          "houseId": houseIDCtr.text,
          "segmentNumber": segNoCtr.text,
          "som": somCtr.text,
          "eom": eomCtr.text,
          "killDate": DateFormat("yyyy-MM-ddT00:00:00").format(DateFormat("dd-MM-yyyy").parse(updateTodateCtr.text)),
          "dated": "Y",
        },
      );
    }
  }

  handleOnChangedLocation(DropDownValue? val) {
    selectedLocation = val;

    if (val != null) {
      closeDialogIfOpen();
      LoadingDialog.call();
      Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.SLIDE_MASTER_GET_CHANNEL(val.key.toString()),
        fun: (resp) {
          closeDialogIfOpen();
          if (resp != null && resp is Map<String, dynamic> && resp['onLeaveLocation'] != null) {
            channelList.clear();
            channelList.addAll((resp['onLeaveLocation'] as List<dynamic>)
                .map((e) => DropDownValue(
                      key: e['channelCode'].toString(),
                      value: e['channelName'].toString(),
                    ))
                .toList());
          } else {
            LoadingDialog.showErrorDialog(resp.toString());
          }
        },
        failed: (resp) {
          closeDialogIfOpen();
          LoadingDialog.showErrorDialog(resp.toString());
        },
      );
    }
  }

  getOnLoadData() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.SLIDE_MASTER_ON_LOAD,
        fun: (resp) {
          closeDialogIfOpen();
          if (resp != null && resp is Map<String, dynamic> && resp['onLoad_SlideMaster'] != null) {
            locationList.value.addAll((resp['onLoad_SlideMaster']['lstlocations'] as List<dynamic>)
                .map((e) => DropDownValue(
                      key: e['locationCode'].toString(),
                      value: e['locationName'].toString(),
                    ))
                .toList());
            for (var element in resp['onLoad_SlideMaster']['lstSlideType']) {
              slideTypeList.add(element);
            }
            for (var element in resp['onLoad_SlideMaster']['lstTapeType']) {
              tapeTypeList.add(element);
            }
          } else {
            LoadingDialog.showErrorDialog(resp.toString());
          }
        },
        failed: (resp) {
          closeDialogIfOpen();
          LoadingDialog.showErrorDialog(resp.toString());
        });
  }

  closeDialogIfOpen() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
}

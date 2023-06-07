import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/controller/MainController.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../providers/Utils.dart';

class StillMasterController extends GetxController {
  var locationList = <DropDownValue>[].obs, channelList = <DropDownValue>[].obs, tapeList = <DropDownValue>[].obs;
  DropDownValue? selectedChannel, selectedLocation, selectedProgram, selectedTape;
  var programPickerList = [];
  var locationFN = FocusNode(),
      tapeIDFN = FocusNode(),
      segFN = FocusNode(),
      houseIDFN = FocusNode(),
      copyFN = FocusNode(),
      eomFN = FocusNode(),
      txCaptionFN = FocusNode();
  var firststSelectedRadio = "Opening".obs, secondSelectedRadio = "Dated".obs;
  var captionTC = TextEditingController(),
      txCaptionTC = TextEditingController(),
      tapIDTC = TextEditingController(),
      segTC = TextEditingController(),
      houseIDTC = TextEditingController(),
      somTC = TextEditingController(),
      eomTC = TextEditingController(),
      upToDateTC = TextEditingController(),
      copyTC = TextEditingController();
  var duration = "00:00:00:00".obs;
  var prefixText = "OE/".obs;
  String strCode = "", strTapeID = "", strSegmentNumber = "", strHouseID = "";
  var controllsEnabled = true.obs;

  @override
  void onReady() {
    super.onReady();
    initialAPI();
    addListeners();
  }

  clearPage() {
    controllsEnabled.value = true;
    strCode = "";
    strTapeID = "";
    strHouseID = "";
    strSegmentNumber = "";
    selectedTape = null;
    selectedChannel = null;
    selectedLocation = null;
    selectedProgram = null;
    programPickerList.clear();
    locationList.refresh();
    channelList.refresh();
    captionTC.clear();
    copyTC.clear();
    tapIDTC.text = "AUTO";
    houseIDTC.text = "AUTO";
    segTC.text = "1";
    txCaptionTC.clear();
    secondSelectedRadio.value = "Dated";
    duration.value = "00:00:00:00";
    somTC.text = "00:00:00:00";
    eomTC.text = "00:00:00:00";
    locationFN.requestFocus();
  }

  handleOnChangedProgram(DropDownValue? val) {
    selectedProgram = val;
    if (txCaptionTC.text.isNotEmpty) {
      createCaption(val?.value ?? "");
    }
  }

  addListeners() {
    copyFN.addListener(() {
      if (!copyFN.hasFocus) {
        copyLeave();
      }
    });

    tapeIDFN.addListener(() {
      if (!tapeIDFN.hasFocus) {
        tapeIDLeave();
      }
    });

    segFN.addListener(() {
      if (!segFN.hasFocus) {
        segNoLeave();
      }
    });

    houseIDFN.addListener(() {
      if (!houseIDFN.hasFocus) {
        houseIDLeave();
      }
    });

    eomFN.addListener(() {
      if (!eomFN.hasFocus) {
        var diff = (Utils.oldBMSConvertToSecondsValue(value: eomTC.text) - Utils.oldBMSConvertToSecondsValue(value: somTC.text));
        if (diff.isNegative) {
          eomTC.clear();
          LoadingDialog.showErrorDialog("EOM should not less than SOM", callback: () {
            eomFN.requestFocus();
          });
        } else {
          duration.value = Utils.convertToTimeFromDouble(value: diff);
        }
      }
    });
  }

  handleChangeInRadio(String newVal) {
    firststSelectedRadio.value = newVal;
    if (firststSelectedRadio.value == "Bumper") {
      prefixText.value = "S/";
    } else if (firststSelectedRadio.value == "Opening") {
      prefixText.value = "OE/";
    } else if (firststSelectedRadio.value == "Closing") {
      prefixText.value = "CE/";
    } else if (firststSelectedRadio.value == "Generic") {
      prefixText.value = "CE/";
    }
  }

  saveData() {
    if (selectedLocation == null) {
      LoadingDialog.showErrorDialog("Please select Location Name.");
    } else if (selectedChannel == null) {
      LoadingDialog.showErrorDialog("Please select Location Name.");
    } else if (selectedProgram == null) {
      LoadingDialog.showErrorDialog("Please select Program.");
    } else if (tapIDTC.text.isEmpty) {
      LoadingDialog.showErrorDialog("Tape ID cannot be empty.", callback: () {
        tapeIDFN.requestFocus();
      });
    } else if (segTC.text.isEmpty) {
      LoadingDialog.showErrorDialog("Segment No. cannot be empty.", callback: () {
        segFN.requestFocus();
      });
    } else if (strCode.isEmpty && strCode == "0") {
      LoadingDialog.showErrorDialog("Segment No. cannot be ZERO.", callback: () {
        segFN.requestFocus();
      });
    } else if (houseIDTC.text.isEmpty) {
      LoadingDialog.showErrorDialog("House ID cannot be empty.", callback: () {
        houseIDFN.requestFocus();
      });
    } else if (txCaptionTC.text.isEmpty) {
      LoadingDialog.showErrorDialog("Export Tape Caption cannot be empty.", callback: () {
        txCaptionFN.requestFocus();
      });
    } else if ((Utils.oldBMSConvertToSecondsValue(value: eomTC.text) - Utils.oldBMSConvertToSecondsValue(value: somTC.text)).isNegative) {
      LoadingDialog.showErrorDialog("EOM should not less than SOM", callback: () {
        eomFN.requestFocus();
      });
    } else {
      LoadingDialog.call();
      Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.STILL_MASTER_TAPE_SAVE_DATA,
        fun: (resp) {},
        json: {
          "stillCode": strCode,
          "locationCode": selectedLocation?.key,
          "channelCode": selectedChannel?.key,
          "modifiedBy": Get.find<MainController>().user?.logincode,
          "stillDuration": duration.value,
          "exportTapeCode": tapIDTC.text,
          "exportTapeCaption": prefixText.value + txCaptionTC.text,
          "programCode": selectedProgram?.key,
          "tapeTypeCode": tapIDTC.text,
          "houseId": houseIDTC.text,
          "segmentNumber": segTC.text,
          "som": somTC.text,
          "eom": eomTC.text,
          "killDate": DateFormat("yyyy-MM-ddT00:00:00").format(DateFormat("dd-MM-yyyy").parse(upToDateTC.text)),
          "dated": "Y",
          "stillCaption": "<string>",
          "optBumper": firststSelectedRadio.value == "Bumper",
          "optOpening": firststSelectedRadio.value == "Opening",
          "optClosing": firststSelectedRadio.value == "Closing",
          "optGeneric": firststSelectedRadio.value == "Generic",
        },
      );
    }
  }

  Future<void> checkRetrieve() async {
    if (segTC.text.isNotEmpty) {
      strCode = "";
      await retrievRecord(
        tapeid: tapIDTC.text,
        segNo: segTC.text,
        locationCode: selectedLocation?.key ?? " ",
        channelCode: selectedChannel?.key ?? " ",
      );
    }
  }

  tapeIDLeave() {
    if (tapIDTC.text.isNotEmpty) {
      houseIDTC.text = tapIDTC.text;
      checkRetrieve();
      if (tapIDTC.text.isNotEmpty && segTC.text != "0") {
        Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.STILL_MASTER_TAPE_ID_LEAVE,
          fun: (resp) {
            if (resp != null && resp is Map<String, dynamic> && resp['tapeid'] != null && resp['tapeid']['eventName'] != null) {
              LoadingDialog.showErrorDialog(resp['tapeid']['eventName'].toString(), callback: () {
                tapeIDFN.requestFocus();
              });
            }
            if (strCode.isNotEmpty) {
              tapIDTC.text = strTapeID;
            }
          },
          json: {
            "exportTapeCode": tapIDTC.text,
            "segmentNumber": segTC.text,
            "code": strCode,
            "houseID": houseIDTC.text,
            "eventType": "",
          },
        );
      }
    }
  }

  segNoLeave() {
    if (segTC.text.isEmpty) {
      segTC.text = "1";
    }
    checkRetrieve();
    if (tapIDTC.text.isNotEmpty && segTC.text != "0") {
      Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.STILL_MASTER_TAPE_SEG_NO_LEAVE,
        fun: (resp) {
          if (resp != null && resp is Map<String, dynamic> && resp['segnoleave'] != null && resp['segnoleave']['eventName'] != null) {
            LoadingDialog.showErrorDialog(resp['segnoleave']['eventName'].toString(), callback: () {
              segFN.requestFocus();
            });
            if (strCode.isNotEmpty) {
              houseIDTC.text = strHouseID;
            }
          }
        },
        json: {
          "exportTapeCode": tapIDTC.text,
          "segmentNumber": segTC.text,
          "code": strCode,
          "houseID": houseIDTC.text,
          "eventType": "",
        },
      );
    }
  }

  houseIDLeave() {
    if (houseIDTC.text.isNotEmpty) {
      Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.STILL_MASTER_TAPE_SEG_NO_LEAVE,
        fun: (resp) {
          if (resp != null && resp is Map<String, dynamic> && resp['tapeid'] != null && resp['tapeid']['eventName'] != null) {
            LoadingDialog.showErrorDialog(resp['tapeid']['eventName'].toString(), callback: () {
              houseIDFN.requestFocus();
            });
            if (strCode.isNotEmpty) {
              segTC.text = strHouseID;
            }
          }
        },
        json: {
          "exportTapeCode": tapIDTC.text,
          "segmentNumber": segTC.text,
          "code": strCode,
          "houseID": houseIDTC.text,
          "eventType": "",
        },
      );
    }
  }

  copyLeave() async {
    retrievRecord(tapeid: copyTC.text, segNo: "1", locationCode: selectedLocation?.key ?? "", channelCode: selectedChannel?.key ?? "");
    strCode = "";
    tapIDTC.text = "AUTO";
    controllsEnabled.value = true;
    houseIDTC.text = "1";
    if (selectedProgram != null) {
      createCaption(selectedProgram?.value ?? "");
    }
  }

  tblProgramPickerCellDoubleClick() {
    createCaption("program");
  }

  createCaption(String program) {
    String s = "";
    if (firststSelectedRadio.value == "Bumper") {
      s = "1";
    } else if (firststSelectedRadio.value == "Opening") {
      s = "2";
    } else if (firststSelectedRadio.value == "Closing") {
      s = "3";
    } else if (firststSelectedRadio.value == "Generic") {
      s = "4";
    }

    if (program.length >= 28) {
      captionTC.text = "B$s${program.substring(1, 28)}${DateFormat('yyyyMMdd').format(DateTime.now())}";
    } else {
      captionTC.text = "B$s$program${DateFormat('yyyyMMdd').format(DateTime.now())}";
    }
  }

  retrievRecord({required String tapeid, required String segNo, required String locationCode, required String channelCode}) async {
    await Get.find<ConnectorControl>().GETMETHODCALL(
      api: ApiFactory.STILL_MASTER_GET_RETRIVE_DATA(locationCode, channelCode, segNo, tapeid),
      fun: (resp) {
        if (resp != null && resp['getRecord'] != null && (resp['getRecord'] is List<dynamic>) && (resp['getRecord'] as List<dynamic>).isNotEmpty) {
          var map = resp['getRecord'][0];
          if (map['stillCode'] != null) {
            strCode = map['stillCode'];
          }
          if (map['stillDuration'] != null) {
            duration.value = Utils.convertToTimeFromDouble(value: map['stillDuration']);
          }
          if (map['stillCaption'] != null) {
            txCaptionTC.text = map['stillCaption'];
          }
          if (map['locationcode'] != null) {
            var tempLoc = locationList.firstWhereOrNull((element) => element.key == map['locationcode']);
            if (tempLoc != null) {
              selectedLocation = tempLoc;
              locationList.refresh();
            }
          }
          if (map['channelcode'] != null) {
            var tempChannel = channelList.firstWhereOrNull((element) => element.key == map['channelcode']);
            if (tempChannel != null) {
              selectedChannel = tempChannel;
              channelList.refresh();
            }
          }
          if (map['exportTapeCode'] != null) {
            tapIDTC.text = map['exportTapeCode'];
          }
          strTapeID = tapIDTC.text;
          controllsEnabled.value = false;
          if (map['exportTapeCaption'] != null) {
            if (map['exportTapeCaption'].toString().contains("S/")) {
              handleChangeInRadio("Bumper");
              txCaptionTC.text = map['exportTapeCaption'].toString().split("/")[1];
            } else if (map['exportTapeCaption'].toString().contains("OE/")) {
              handleChangeInRadio("Opening");
              txCaptionTC.text = map['exportTapeCaption'].toString().split("/")[1];
            } else if (map['exportTapeCaption'].toString().contains("CE/")) {
              handleChangeInRadio("Closing");
              txCaptionTC.text = map['exportTapeCaption'].toString().split("/")[1];
            }
          }

          if (map['programCode'] != null && map['programName'] != null) {
            selectedProgram = DropDownValue(key: map['programCode'].toString(), value: map['programName'].toString());
            locationList.refresh();
          }
          if (map['houseId'] != null) {
            houseIDTC.text = map['houseId'].toString();
          }
          strHouseID = houseIDTC.text;
          if (map['segmentNumber'] != null) {
            segTC.text = map['segmentNumber'].toString();
          }
          if (map['eom'] != null) {
            eomTC.text = map[''];
          }
          if (map['som'] != null) {
            somTC.text = map[''];
          }
          if (map['killDate'] != null) {
            upToDateTC.text = DateFormat("dd-MM-yyyy").format(DateFormat("yyyy-MM-ddThh:mm:ss").parse(map['killDate'].toString()));
          }
        }
      },
    );
  }

  Future<bool> getProgramPickerData() async {
    await Get.find<ConnectorControl>().GETMETHODCALL(
      api: ApiFactory.STILL_MASTER_GET_PROGRAM_DATA(selectedLocation!.key!, selectedChannel!.key!),
      fun: (resp) {
        if (resp != null && resp is Map<String, dynamic> && resp['getprogram'] != null) {
          programPickerList = resp['getprogram'];
        }
      },
    );
    return false;
  }

  initialAPI() {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
      api: ApiFactory.STILL_MASTER_FORM_LOAD,
      fun: (resp) {
        closeDialog();
        if (resp != null && resp is Map<String, dynamic> && resp['pageload'] != null && resp['pageload']['lstLocaction'] != null) {
          locationList.clear();
          locationList.addAll((resp['pageload']['lstLocaction'] as List<dynamic>)
              .map((e) => DropDownValue.fromJson({
                    "key": e['locationCode'].toString(),
                    "value": e["locationName"].toString(),
                  }))
              .toList());
        } else {
          LoadingDialog.showErrorDialog(resp.toString());
        }
      },
      failed: (resp) {
        closeDialog();
        LoadingDialog.showErrorDialog(resp.toString());
      },
    );
  }

  formHandler(String btnName) {
    if (btnName == "Save") {
      if (strCode.isNotEmpty) {
        LoadingDialog.recordExists("Record Already exist!\nDo you want to modify it?", () {
          saveData();
        });
      }
    } else if (btnName == "Clear") {
      clearPage();
    } else if (btnName == "Refresh") {
      refreshPage();
    }
  }

  closeDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  refreshPage() {
    initialAPI();
  }

  getChannels(DropDownValue? val) {
    if (val == null) {
      LoadingDialog.showErrorDialog("Please select location.");
      return;
    }
    selectedLocation = val;
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
      api: ApiFactory.STILL_MASTER_GET_CHANNELS(selectedLocation!.key!),
      fun: (resp) {
        closeDialog();
        if (resp != null && resp is Map<String, dynamic> && resp['listchannel'] != null) {
          selectedChannel = null;
          channelList.clear();
          channelList.addAll((resp['listchannel'] as List<dynamic>)
              .map((e) => DropDownValue.fromJson({
                    "key": e['channelCode'].toString(),
                    "value": e["channelName"].toString(),
                  }))
              .toList());
        }
      },
      failed: (resp) {
        closeDialog();
      },
    );
  }
}

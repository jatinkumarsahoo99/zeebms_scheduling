import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/providers/Utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/LoadingDialog.dart';
import '../../../controller/MainController.dart';
import '../../../data/DropDownValue.dart';
import '../../../providers/ApiFactory.dart';

class NewShortContentFormController extends GetxController {
  var locations = RxList<DropDownValue>([]);
  var channels = RxList<DropDownValue>([]);
  var types = RxList<DropDownValue>([]);
  var categeroies = RxList<DropDownValue2>([]);
  var formIdCategeroies = RxList<DropDownValue>([]);

  var tapes = RxList<DropDownValue2>([]);
  var orgRepeats = RxList<DropDownValue>([]);
  Rx<TextEditingController> durationController = TextEditingController().obs;
  RxString duration = RxString("00:00:00:00");
  num sec = 0;
  var formId = ''.obs;
  Rx<bool> enable = Rx<bool>(true);

  bool isLocOpen = false;
  bool isChnlOpen = false;
  bool isCatOpen = false;

  FocusNode houseFocusNode = FocusNode(),
      locationFocusNode = FocusNode(),
      channelFocusNode = FocusNode(),
      typeFocusNode = FocusNode(),
      categoryFocusNode = FocusNode(),
      programFocusNode = FocusNode(),
      tapeFocusNode = FocusNode(),
      orgFocusNode = FocusNode(),
      eomFN = FocusNode(),
      somFN = FocusNode(),
      durationFN = FocusNode(),
      captionFN = FocusNode(),
      segmentFN = FocusNode();
  String? typeCode;

  Rxn<DropDownValue> selectedLocation = Rxn<DropDownValue>();
  Rxn<DropDownValue> selectedChannel = Rxn<DropDownValue>();
  Rxn<DropDownValue> selectedType = Rxn<DropDownValue>();
  Rxn<DropDownValue2> selectedCategory = Rxn<DropDownValue2>();
  Rxn<DropDownValue> selectedProgram = Rxn<DropDownValue>();
  Rxn<DropDownValue2> selectedTape = Rxn<DropDownValue2>();
  Rxn<DropDownValue> selectedOrgRep = Rxn<DropDownValue>();

  TextEditingController caption = TextEditingController(),
      txCaption = TextEditingController(),
      houseId = TextEditingController(text: "AUTOID"),
      som = TextEditingController(text: "10:00:00:00"),
      eom = TextEditingController(text: "00:00:00:00"),
      // duration = TextEditingController(text: "00:00:00:00"),
      startData = TextEditingController(),
      endDate = TextEditingController(),
      segment = TextEditingController(text: "1"),
      remark = TextEditingController();
  var toBeBilled = RxBool(false);

  getInitData() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.NEW_SHORT_CONTENT_INIT,
        fun: (rawdata) {
          if (rawdata is Map && rawdata.containsKey("onLoadShortCode")) {
            Map data = rawdata["onLoadShortCode"];

            locations.value = [];
            for (var location in data["lstLocation"]) {
              locations.add(DropDownValue(
                  key: location["locationCode"],
                  value: location["locationName"]));
            }
            // types.value = [];
            // for (var revenue in data["lstFormType"]) {
            //   types.add(DropDownValue(
            //       key: revenue["formCode"], value: revenue["formName"]));
            // }
            categeroies.value = [];
            formIdCategeroies.value = [];
            for (var categeroi in data["lstCategory"]) {
              categeroies.add(DropDownValue2(
                  type: categeroi["ssvType"],
                  value: categeroi["ssvName"],
                  key: categeroi["ssvCode"]));
              // formIdCategeroies.add(DropDownValue(
              //     key: categeroi["ssvCode"], value: categeroi["ssvName"]));
            }
          }
        });
  }

  void calculateDuration() {
    num secondSom = Utils.oldBMSConvertToSecondsValue(value: (som.text));
    num secondEom = Utils.oldBMSConvertToSecondsValue(value: eom.text);

    if (eom.text.length >= 11) {
      if ((secondEom - secondSom) < 0) {
        LoadingDialog.showErrorDialog("EOM should not be less than SOM.",
            callback: () {
          eomFN.requestFocus();
        });
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

  Future<void> getChannel(locationCode) async {
    await Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.NEW_SHORT_CONTENT_LOCATION_LEAVE(locationCode),
        fun: (rawdata) {
          if (rawdata is Map && rawdata.containsKey("onLeaveLocation")) {
            channels.value = [];
            for (var channel in rawdata["onLeaveLocation"]) {
              channels.add(DropDownValue(
                  key: channel["channelCode"], value: channel["channelName"]));
            }
          }
        });
  }

  Future<void> typeleave(formCode) async {
    if (formCode == "STILL MASTER") {
      await Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.NEW_SHORT_CONTENT_GetStillTypeMaster,
          fun: (rawdata) {
            if (rawdata is Map && rawdata.containsKey("infoStillType")) {
              tapes.value = [];
              for (var data in rawdata["infoStillType"]) {
                tapes.add(
                  DropDownValue2(
                    key: data["tapetypecode"],
                    value: data["tapeTypeName"],
                    type: data['isActive'].toString(),
                  ),
                );
              }
            }
          });
    }
    if (formCode == "SLIDE MASTER") {
      await Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.NEW_SHORT_CONTENT_GetSlideTypeMaster,
          fun: (rawdata) {
            if (rawdata is Map && rawdata.containsKey("infoSlideTypes")) {
              tapes.value = [];
              for (var data in rawdata["infoSlideTypes"]) {
                tapes.add(
                  DropDownValue2(
                    key: data["tapetypecode"],
                    value: data["tapeTypeName"],
                    type: data['isActive'].toString(),
                  ),
                );
              }
            }
          });
    }
    if (formCode == "VIGNETTE MASTER") {
      await Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.NEW_SHORT_CONTENT_GetVignetee,
          fun: (rawdata) {
            if (rawdata is Map && rawdata.containsKey("infoVignetteType")) {
              orgRepeats.value = [];
              for (var category in rawdata["infoVignetteType"]) {
                orgRepeats.add(DropDownValue(
                    key: category["originalRepeatCode"],
                    value: category["originalRepeatName"]));
              }
            }
          });
    }

    // Get.find<ConnectorControl>().GETMETHODCALL(
    //     api: ApiFactory.NEW_SHORT_CONTENT_Type_LEAVE(formCode),
    //     fun: (rawdata) {
    //       if (rawdata is Map && rawdata.containsKey("onLeaveTypeCategory")) {
    //         categeroies.value = [];
    //         for (var category in rawdata["onLeaveTypeCategory"]) {
    //           categeroies.add(DropDownValue(
    //               key: category["typeId"], value: category["typeName"]));
    //         }
    //       }
    //     });
  }

  houseleave() {
    try {
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.NEW_SHORT_CONTENT_HOUSEID_LEAVE(
              houseId.text, txCaption.text, caption.text),
          fun: (rawdata) {
            if (rawdata is Map &&
                rawdata.containsKey("houseIDLeave") &&
                rawdata["houseIDLeave"]["message"] != null) {
              LoadingDialog.callInfoMessage(rawdata["houseIDLeave"]["message"]);
            }
          });
    } catch (e) {
      print("error in house ID");
    }
  }

  retriveRecord() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.NEW_SHORT_CONTENT_RETRIEVE(
            selectedLocation.value?.key ?? "",
            selectedChannel.value?.key ?? "",
            selectedCategory.value?.value ?? "",
            houseId.text ?? "",
            segment.text ?? ""),
        fun: (rawdata) {
          // print(">>>>>>>responseData"+rawdata.toString());

          if (rawdata is List && rawdata.isNotEmpty) {
            Map data = rawdata[0];
            enable.value = false;
            enable.refresh();
            selectedCategory.value = categeroies.firstWhereOrNull((element) {
              var result = element.key!.toString().toLowerCase() ==
                      data['SlideType'].toString().toLowerCase().trim() ||
                  element.key!.toString().toLowerCase() ==
                      data['Stilltype'].toString().toLowerCase().trim() ||
                  element.key!.toString().toLowerCase() ==
                      data['SSVCode'].toString().toLowerCase().trim();
              // print(result);
              return result;
            });
            print("===== ${selectedCategory.value?.type}");
            switch (selectedCategory.value?.type) {
              //       {
              //     "stillCode": null,
              //     "stillCaption": null,
              //     "programCode": null,
              //     "programName": null,
              //     "programTypeCode": null,
              //     "exportTapeCaption": "ZEETV ID YEH 10",
              //     "exportTapeCode": "533190",
              //     "segmentNumber": 5,
              //     "stillDuration": null,
              //     "houseId": "Z6667",
              //     "som": "10:00:00:00",
              //     "tapeTypeCode": "ZABET00003",
              //     "dated": "Y",
              //     "killDate": "2005-03-01T00:00:00",
              //     "modifiedBy": "BIN0000161",
              //     "locationcode": "ZAZEE00001",
              //     "channelcode": "ZAZEE00001",
              //     "eom": null,
              //     "stillType": 1,
              //     "slideCode": 1033,
              //     "slideCaption": "ZEETV ID YEH HAI ZTV 10",
              //     "segmentNumber_SL": null,
              //     "slideType": "W ",
              //     "exportTapeDuration": 10,
              //     "vignetteCode": null,
              //     "vignetteCaption": null,
              //     "vignetteDuration": null,
              //     "exportTapeCode_VG": null,
              //     "originalRepeatCode": null,
              //     "segmentNumber_VG": null,
              //     "startDate": null,
              //     "remarks": null,
              //     "billflag": null,
              //     "companycode": ""
              // },

              // formCode: "ZASTI00001"formName: "Still Master"
              case "STILL MASTER":
                formId.value = "S/";
                selectedLocation.value = locations.firstWhereOrNull((element) =>
                    element.key?.toLowerCase() ==
                    (data["Locationcode"] ?? "").toLowerCase());
                getChannel(data["Locationcode"]).then((value) {
                  // selectedChannel.value = channels.firstWhereOrNull((element) {
                  //   return element.key?.toLowerCase() ==
                  //       (data["Channelcode"] ?? "").toLowerCase();
                  // });
                  var tempChannel = channels.firstWhereOrNull((element) =>
                      element.key?.toLowerCase() ==
                      (data["Channelcode"] ?? "").toLowerCase());
                  if (tempChannel != null) {
                    selectedChannel.value = tempChannel;
                  } else {
                    LoadingDialog.callErrorMessage1(
                        msg:
                            "You do not have required channel rights. Please contact support team.");
                  }
                });
                typeleave(selectedCategory.value?.type).then((value) {
                  selectedTape.value = tapes.firstWhereOrNull((element) =>
                      element.key?.toLowerCase() ==
                      (data["TapeTypeCode"] ?? "").toString().toLowerCase());
                });
                typeCode = data["StillCode"];
                caption.text = data["StillCaption"] ?? "";
                txCaption.text = data["ExportTapeCaption"] ?? "";

                if (txCaption.text.contains('S/')) {
                  txCaption.text = txCaption.text.replaceAll(r'S/', "");
                }

                selectedCategory.value =
                    categeroies.firstWhereOrNull((element) {
                  var result = element.key!.toLowerCase() ==
                      data['Stilltype'].toString().toLowerCase().trim();

                  return result;
                });
                som.text = data["SOM"];
                eom.text = data["EOM"];
                calculateDuration();

                // duration.value = Utils.convertToTimeFromDouble(
                //     value: int.tryParse(
                //             data["StillDuration"].toString().split(".")[0]) ??
                //         0);
                selectedProgram.value = DropDownValue(
                  key: data["ProgramCode"] ?? "",
                  value: data["ProgramName"] ?? "",
                );
                // remark.text = data["remark"];
                print("DATE: ${data["KillDate"]}");

                endDate.text = DateFormat("dd-MM-yyyy").format(
                    DateFormat("MM/dd/yyyy hh:mm:ss").parse(data["KillDate"]));
                toBeBilled.value = data["billflag"] == "0";

                break;
              //  "formCode": "ZASLI00045", "formName": "Slide Master"
              case "SLIDE MASTER":
                formId.value = "L/";
                selectedLocation.value = locations.firstWhereOrNull((element) =>
                    element.key?.toLowerCase() ==
                    (data["LocationCode"] ?? "").toLowerCase());
                // getChannel(data["LocationCode"]).then((value) {
                //   selectedChannel.value = channels.firstWhereOrNull((element) {
                //     print(element.key);
                //     print(element.key?.toLowerCase() ==
                //         (data["ChannelCode"] ?? "").toLowerCase());
                //     return element.key?.toLowerCase() ==
                //         (data["ChannelCode"] ?? "").toLowerCase();
                //   });
                // });
                getChannel(data["LocationCode"]).then((value) {
                  var tempChannel = channels.firstWhereOrNull((element) =>
                      element.key?.toLowerCase() ==
                      (data["ChannelCode"] ?? "").toLowerCase());
                  if (tempChannel != null) {
                    selectedChannel.value = tempChannel;
                  } else {
                    LoadingDialog.callErrorMessage1(
                        msg:
                            "You do not have required channel rights. Please contact support team.");
                  }
                });
                typeleave(selectedCategory.value?.type).then((value) {
                  selectedTape.value = tapes.firstWhereOrNull((element) =>
                      element.key?.toLowerCase() ==
                      (data["TapeTypeCode"] ?? "").toString().toLowerCase());
                });
                typeCode = data["SlideCode"];

                caption.text = data["SlideCaption"] ?? "";
                txCaption.text = data["ExportTapeCaption"] ?? "";
                if (txCaption.text.contains('L/')) {
                  txCaption.text = txCaption.text.replaceAll(r'L/', "");
                }
                selectedCategory.value =
                    categeroies.firstWhereOrNull((element) {
                  var result = element.key!.toString().toLowerCase() ==
                      data['SlideType'].toString().toLowerCase().trim();

                  return result;
                });
                som.text = data["SOM"];
                eom.text = data["EOM"] ?? "00:00:00:00";
                calculateDuration();
                // duration.value =
                //  Utils.convertToTimeFromDouble(
                //     value: int.tryParse(data["ExportTapeDuration"]
                //             .toString()
                //             .split(".")[0]) ??
                //         0);
                // remark.text = data["remark"];
                // startData.text = DateFormat("dd-MM-yyy").format(
                //     DateFormat("dd/MM/yyyy hh:mm:ss").parse(data["ModifiedOn"]));
                endDate.text = DateFormat("dd-MM-yyy").format(
                    DateFormat("MM/dd/yyyy hh:mm:ss").parse(data["KillDate"]));
                toBeBilled.value = data["billflag"] == "0";

                break;
              // "formCode": "ZADAT00117", "formName": "Vignette Master"
              case "VIGNETTE MASTER":
                formId.value = "VP/";
                selectedLocation.value = locations.firstWhereOrNull((element) =>
                    element.key?.toLowerCase() ==
                    (data["Locationcode"] ?? "").toLowerCase());
                // getChannel(data["Locationcode"]).then((value) {
                //   selectedChannel.value = channels.firstWhereOrNull((element) {
                //     return element.key?.toLowerCase() ==
                //         (data["ChannelCode"] ?? "").toLowerCase();
                //   });
                // });
                getChannel(data["Locationcode"]).then((value) {
                  var tempChannel = channels.firstWhereOrNull((element) =>
                      element.key?.toLowerCase() ==
                      (data["ChannelCode"] ?? "").toLowerCase());
                  if (tempChannel != null) {
                    selectedChannel.value = tempChannel;
                  } else {
                    LoadingDialog.callErrorMessage1(
                        msg:
                            "You do not have required channel rights. Please contact support team.");
                  }
                });
                typeCode = data["VignetteCode"];
                caption.text = data["VignetteCaption"] ?? "";
                txCaption.text = data["ExportTapeCaption"] ?? "";
                if (txCaption.text.contains('VP/')) {
                  txCaption.text = txCaption.text.replaceAll(r'VP/', "");
                }
                selectedCategory.value =
                    categeroies.firstWhereOrNull((element) {
                  var result = element.key!.toString().toLowerCase() ==
                      data['SSVCode'].toString().toLowerCase().trim();

                  return result;
                });
                typeleave(selectedCategory.value?.type).then((value) {
                  selectedOrgRep.value = orgRepeats.firstWhereOrNull(
                      (element) =>
                          element.key?.toLowerCase() ==
                          (data["OriginalRepeatCode"] ?? "")
                              .toString()
                              .toLowerCase());
                });

                selectedProgram.value = DropDownValue(
                  key: data["ProgramCode"] ?? "",
                  value: data["ProgramName"] ?? "",
                );
                som.text = data["SOM"];
                eom.text = data["EOM"];
                calculateDuration();

                // duration.value = Utils.convertToTimeFromDouble(
                //     value: int.tryParse(
                //             data["VignetteDuration"].toString().split(".")[0]) ??
                //         0);
                remark.text = data["remarks"];
                startData.text = DateFormat("dd-MM-yyy").format(
                    DateFormat("MM/dd/yyyy hh:mm:ss").parse(data["StartDate"]));
                endDate.text = DateFormat("dd-MM-yyy").format(
                    DateFormat("MM/DD/yyyy hh:mm:ss").parse(data["KillDate"]));
                toBeBilled.value = data["billflag"] == "1";

                break;

              default:
            }
          } else {
            enable.value = true;
            enable.refresh();
          }
        },
        failed: (data) {
          // print(">>>>>>>responseData"+data.toString());
          enable.value = true;
          enable.refresh();
        });
  }

  saveValidate() {
    late DateTime startD, endD;
    startD = DateFormat("dd-MM-yyyy").parse(startData.text);
    endD = DateFormat("dd-MM-yyyy").parse(endDate.text);
    if (selectedLocation.value?.key == null) {
      LoadingDialog.showErrorDialog("Location cannot be empty.");
    } else if (selectedChannel.value?.key == null) {
      LoadingDialog.showErrorDialog("Channel cannot be empty.");
    } else if (selectedCategory.value?.key == null) {
      LoadingDialog.showErrorDialog("Category cannot be empty.");
    } else if (som.text.trim().isEmpty) {
      LoadingDialog.showErrorDialog("Please enter SOM.");
    } else if (eom.text.trim().isEmpty || eom.text.trim() == "00:00:00:00") {
      LoadingDialog.showErrorDialog("Please enter EOM.");
      eomFN.requestFocus();
    } else if ((Utils.oldBMSConvertToSecondsValue(value: eom.text) -
            Utils.oldBMSConvertToSecondsValue(value: som.text))
        .isNegative) {
      eom.clear();
      LoadingDialog.showErrorDialog("EOM should not less than SOM",
          callback: () {
        eomFN.requestFocus();
      });
    } else if (startD.isAfter(endD)) {
      LoadingDialog.showErrorDialog("Start date should not more than end date");
    } else if (selectedProgram.value == null &&
        selectedCategory.value!.type == "STILL MASTER") {
      LoadingDialog.showErrorDialog("Program cannot be empty.");
    }

    //  else if (selectedCategory.value!.type == "STILL MASTER" &&
    //     selectedProgram.value!.key == null) {
    //   LoadingDialog.showErrorDialog("Program cannot be empty.");
    // }
    // else if (fillerNameCtr.text.trim().isEmpty) {
    //   LoadingDialog.showErrorDialog("Filler Caption cannot be empty.");
    // } else if (txCaptionCtr.text.trim().isEmpty) {
    //   LoadingDialog.showErrorDialog("Export Tape Caption cannot be empty.");
    // } else if (tapeIDCtr.text.trim().isEmpty) {
    //   LoadingDialog.showErrorDialog("Export Tape Code cannot be empty.");
    // } else if (segNoCtrLeft.text.trim().isEmpty) {
    //   LoadingDialog.showErrorDialog("Segment Number cannot be empty.");
    // } else if (txNoCtr.text.trim().isEmpty) {
    //   LoadingDialog.showErrorDialog("House ID cannot be empty.");
    // }
    //  else {
    //   if (fillerCode.isNotEmpty) {
    //     LoadingDialog.recordExists(
    //       "Record Already exits!\nDo you want to modify it?",
    //       () {
    //         save();
    //       },
    //     );
    //   }
    else {
      save();
    }
    // }
  }

  save() async {
    var body = {};
    List _durations = duration.value.split(":");
    num intDuration = Duration(
            hours: int.parse(_durations[0]),
            minutes: int.parse(_durations[1]),
            seconds: int.parse(_durations[2]))
        .inSeconds;
    // formCode: "ZASTI00001"formName: "Still Master"
    if (selectedCategory.value?.type == "STILL MASTER") {
      body = {
        "SSVName": selectedCategory.value?.value,
        "stillCode": typeCode,
        "stillCaption": caption.text,
        "programCode": selectedProgram.value?.key, // Common in (still/Vignette)
        "exportTapeCaption":
            formId.value + txCaption.text, // Common in (still/Slide)
        "exportTapeCode": houseId.text, // Common in (still/Slide)
        "segmentNumber": segment.text,
        // int.tryParse(segment.text),
        "stillDuration": intDuration,
        "houseId": houseId.text, // Common in (still/Slide/vignetee)
        "som": som.text, // Common in (still/Slide/vignetee)
        "tapeTypeCode": selectedTape.value?.key, // Common in (still/Slide)
        "dated": DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy")
            .parse(startData.text)), // Common in (still/Slide)
        "killDate": DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy")
            .parse(endDate.text)), // Common in (still/Slide/vignetee)
        "modifiedBy": Get.find<MainController>()
            .user
            ?.logincode, // Common in (still/Slide)
        "locationcode":
            selectedLocation.value?.key, // Common in (still/Slide/Vignette)
        "channelcode": selectedChannel
            .value?.key, // Common in (still/Slide/vignetteCaption)
        "eom": eom.text, // Common in (still/Slide/vignetee)
        "stillType": num.parse(selectedCategory.value!.key.toString()),
      };
    }
    //  "formCode": "ZASLI00045", "formName": "Slide Master"
    if (selectedCategory.value?.type == "SLIDE MASTER") {
      body = {
        "SSVName": selectedCategory.value?.value,
        "slideCode": typeCode,
        "slideCaption": caption.text,
        "segmentNumber_SL": int.tryParse(segment.text) ?? 0,
        "slideType": selectedCategory.value!.key,
        "exportTapeDuration": intDuration, //Common in (Slide/Vignette)
        "houseId": houseId.text, // Common in (still/Slide/vignetee)
        "som": som.text, // Common in (still/Slide/vignetee)
        "tapeTypeCode": selectedTape.value?.key, // Common in (still/Slide)
        "dated": DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy")
            .parse(startData.text)), // Common in (still/Slide)
        "killDate": DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy")
            .parse(endDate.text)), // Common in (still/Slide/vignetee)
        "modifiedBy": Get.find<MainController>()
            .user
            ?.logincode, // Common in (still/Slide)
        "locationcode":
            selectedLocation.value?.key, // Common in (still/Slide/Vignette)
        "channelcode": selectedChannel
            .value?.key, // Common in (still/Slide/vignetteCaption)
        "eom": eom.text, // Common in (still/Slide/vignetee)
        "exportTapeCaption":
            formId.value + txCaption.text, // Common in (still/Slide)
        "exportTapeCode": houseId.text,
      };
    }
    // "formCode": "ZADAT00117", "formName": "Vignette Master"
    if (selectedCategory.value?.type == "VIGNETTE MASTER") {
      body = {
        "SSVName": selectedCategory.value?.value,
        "vignetteCode": typeCode,
        "vignetteCaption": caption.text,
        "vignetteDuration": intDuration,
        "exportTapeCode_VG": houseId.text,
        "exportTapeCaption": formId.value + txCaption.text,
        "originalRepeatCode": selectedOrgRep.value?.key,
        "segmentNumber_VG": int.parse(segment.text),
        "startDate": DateFormat("yyyy-MM-dd")
            .format(DateFormat("dd-MM-yyyy").parse(startData.text)),
        "remarks": remark.text,
        "billflag": toBeBilled.value ? 1 : 0,
        "companycode": "",
        "exportTapeDuration": intDuration, //Common in (Slide/Vignette)
        "locationcode":
            selectedLocation.value?.key, // Common in (still/Slide/Vignette)
        "channelcode": selectedChannel
            .value?.key, // Common in (still/Slide/vignetteCaption)
        "eom": eom.text, // Common in (still/Slide/vignetee)
        "killDate": DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy")
            .parse(endDate.text)), // Common in (still/Slide/vignetee)
        "houseId": houseId.text, // Common in (still/Slide/vignetee)
        "som": som.text, // Common in (still/Slide/vignetee)
        "programCode": selectedProgram.value?.key,
        "modifiedBy": Get.find<MainController>().user?.logincode,
      };
    }
    LoadingDialog().callwithCancel();

    await Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.NEW_SHORT_CONTENT_SAVE,
        json: body,
        fun: (rawdata) {
          Get.back();
          try {
            if (rawdata is Map && rawdata.containsKey("onSaveShortCode")) {
              enable.value = false;
              enable.refresh();
              if (selectedCategory.value!.type == "SLIDE MASTER") {
                LoadingDialog.callDataSaved(
                    msg:
                        "${rawdata["onSaveShortCode"]["message"]}\nID: ${rawdata["onSaveShortCode"]["lstShortCode"][0]['Exporttapecode']}",
                    callback: () {
                      houseId.text = rawdata["onSaveShortCode"]["lstShortCode"]
                          [0]['Exporttapecode'];
                    });
              } else if (selectedCategory.value!.type == "STILL MASTER") {
                LoadingDialog.callDataSaved(
                    msg:
                        "${rawdata["onSaveShortCode"]["message"]}\nID: ${rawdata["onSaveShortCode"]["lstShortCode"][0]['Exporttapecode']}",
                    callback: () {
                      houseId.text = rawdata["onSaveShortCode"]["lstShortCode"]
                          [0]['Exporttapecode'];
                    });
              } else {
                LoadingDialog.callDataSaved(
                    msg:
                        "${rawdata["onSaveShortCode"]["message"]}\nID: ${rawdata["onSaveShortCode"]["lstShortCode"][0]['ExportTapecode']}",
                    callback: () {
                      houseId.text = rawdata["onSaveShortCode"]["lstShortCode"]
                          [0]['ExportTapecode'];
                    });
              }

              return true;
            } else if (rawdata is String) {
              enable.value = true;
              enable.refresh();
              LoadingDialog.callErrorMessage1(msg: rawdata);
            }
          } catch (e) {
            enable.value = true;
            enable.refresh();
            LoadingDialog.callErrorMessage1(msg: "Save Failed");
            return false;
          }
        });

    return true;
  }

  setCaption() {
    if (caption.text.trim().isNotEmpty) {
      txCaption.text = caption.text.toUpperCase();
      caption.text = caption.text.toUpperCase();
    } else {
      txCaption.text = "";
    }
  }

  houseIdValidate() {
    // if (selectedLocation.value?.key == null) {
    //   LoadingDialog.showErrorDialog("Location cannot be empty.", callback: () {
    //     locationFocusNode.requestFocus();
    //   });
    // } else if (selectedChannel.value?.key == null) {
    //   LoadingDialog.showErrorDialog("Channel cannot be empty.", callback: () {
    //     channelFocusNode.requestFocus();
    //   });
    // } else if (selectedCategory.value?.key == null) {
    //   LoadingDialog.showErrorDialog("Category cannot be empty.", callback: () {
    //     categoryFocusNode.requestFocus();
    //   });
    // } else
    if (segment.text.isEmpty) {
      LoadingDialog.showErrorDialog("Segment Number cannot be empty.",
          callback: () {
        segmentFN.requestFocus();
      });
    } else if (houseId.text.isEmpty) {
      LoadingDialog.showErrorDialog("House ID cannot be empty.", callback: () {
        houseFocusNode.requestFocus();
      });
    } else {
      // houseleave();
      retriveRecord();
    }
  }

  @override
  void onInit() {
    getInitData();

    houseFocusNode = FocusNode(
      onKeyEvent: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.tab &&
            event is KeyDownEvent) {
          if (houseId.text != "AUTOID") {
            houseIdValidate();
          }
          return KeyEventResult.ignored;
        }
        return KeyEventResult.ignored;
      },
    );
    captionFN.addListener(() {
      if (!captionFN.hasFocus) {
        setCaption();
      }
    });
    super.onInit();

    // locationFocusNode.addListener(() {
    //   if (!locationFocusNode.hasFocus) {
    //     if (locations.value != null &&
    //         !isLocOpen &&
    //         selectedLocation.value == null &&
    //         (!(Get.isDialogOpen ?? false))) {
    //       LoadingDialog.callErrorMessage1(
    //           msg: "Please select location",
    //           callback: () {
    //             locationFocusNode.requestFocus();
    //           });
    //     }
    //   }
    // });
    // channelFocusNode.addListener(() {
    //   if (!channelFocusNode.hasFocus) {
    //     if (!isChnlOpen &&
    //         selectedChannel.value == null &&
    //         (!(Get.isDialogOpen ?? false))) {
    //       LoadingDialog.callErrorMessage1(
    //           msg: "Please select channel",
    //           callback: () {
    //             channelFocusNode.requestFocus();
    //           });
    //     }
    //   }
    // });
    // categoryFocusNode.addListener(() {
    //   if (!categoryFocusNode.hasFocus) {
    //     if (!isCatOpen &&
    //         selectedCategory.value == null &&
    //         (!(Get.isDialogOpen ?? false))) {
    //       LoadingDialog.callErrorMessage1(
    //           msg: "Please select category",
    //           callback: () {
    //             categoryFocusNode.requestFocus();
    //           });
    //     }
    //   }
    // });
    // somFN.addListener(() {
    //   if (!somFN.hasFocus) {
    //     if (som.value == "" &&
    //         som.value == "00:00:00:00" &&
    //         (!(Get.isDialogOpen ?? false))) {
    //       LoadingDialog.callErrorMessage1(
    //           msg: "Please enter som",
    //           callback: () {
    //             somFN.requestFocus();
    //           });
    //     }
    //   }
    // });
    // eomFN.addListener(() {
    //   if (!eomFN.hasFocus) {
    //     if (eom.value == "" &&
    //         eom.value == "00:00:00:00" &&
    //         (!(Get.isDialogOpen ?? false))) {
    //       LoadingDialog.callErrorMessage1(
    //           msg: "Please enter som",
    //           callback: () {
    //             eomFN.requestFocus();
    //           });
    //     }else{
    //       calculateDuration();
    //     }
    //   }
    // });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  clearPage() {
    som.text = "00:00:00:00";
    eom.text = "00:00:00:00";
    duration.value = "00:00:00:00";
    selectedLocation.value = null;
    selectedChannel.value = null;
    selectedType.value = null;
    selectedCategory.value = null;
    selectedProgram.value = null;
    selectedTape.value = null;
    selectedOrgRep.value = null;

    caption.clear();
    txCaption.clear();
    houseId.text = "AUTOID";
    startData.clear();
    endDate.clear();
    segment.text = "1";
    remark.clear();
    toBeBilled.value = false;
    typeCode = null;
    enable.value = true;
    enable.refresh();
  }
}

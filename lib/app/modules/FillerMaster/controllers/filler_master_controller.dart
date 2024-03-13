import 'dart:math';

import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/controller/MainController.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/app/routes/app_pages.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/PermissionModel.dart';
import '../../../providers/Utils.dart';
import '../../CommonSearch/views/common_search_view.dart';
import '../model/filler_annotation_model.dart';
import '../model/filler_master_on_load_model.dart';
import '../model/retrive_record_f_m.dart';

class FillerMasterController extends GetxController {
  /// 0=>location
  /// 1=>channel
  /// 2=>banner
  /// 3=>tapeType
  /// 4=>type
  /// 5=>censhorship
  /// 6=>langauge
  /// 7=>production
  /// 8=>color
  /// 9=>region
  /// 10=>energy
  /// 11=>era
  /// 12=>songgrade
  /// 13=>mood
  /// 14=>tempo
  /// 15=>moviegrade
  /// 16=>source
  /// 17=>ID NO
  /// 18=>event
  /// 19=>channel
  late List<DropDownValue?> selectedDropDowns;
  Rxn<DropDownValue2> selectedTapeType = Rxn<DropDownValue2>();
  late List<FocusNode?> focusNodeList;
  List<PermissionModel>? formPermissions;
  FillerMasterOnLoadModel? onloadModel;
  var rightDataTable = <FillerMasterAnnotationModel>[].obs;
  String fillerCode = "";
  var channelList = <DropDownValue>[].obs;
  int rightTableSelectedIdx = -1;
  double componentWidthRatio = .17;
  Rx<TextEditingController> durationController = TextEditingController().obs;
  RxString duration = RxString("00:00:00:00");
  num sec = 0;

  var startDateCtr = TextEditingController(),
      endDateCtr = TextEditingController(),
      synopsisCtr = TextEditingController(),
      copyCtr = TextEditingController(),
      segNoCtrRight = TextEditingController(text: "1"),
      fillerNameCtr = TextEditingController(),
      tcInCtr = TextEditingController(text: "00:00:00:00"),
      tcOutCtr = TextEditingController(text: "00:00:00:00"),
      txCaptionCtr = TextEditingController(),
      tapeIDCtr = TextEditingController(text: "AUTOID"),
      segNoCtrLeft = TextEditingController(text: "1"),
      segIDCtr = TextEditingController(),
      txNoCtr = TextEditingController(),
      eomCtr = TextEditingController(text: "00:00:00:00"),
      somCtr = TextEditingController(text: "10:00:00:00"),
      // durationCtr = TextEditingController(text: "00:00:00:00"),
      movieNameCtr = TextEditingController(),
      releaseYearCtr = TextEditingController(),
      singerCtr = TextEditingController(),
      musicDirectorCtr = TextEditingController(),
      musicCompanyCtr = TextEditingController();

  var locationFN = FocusNode(),
      channelFN = FocusNode(),
      bannerFN = FocusNode(),
      eomFN = FocusNode(),
      fillerNameFN = FocusNode(),
      txCaptionFN = FocusNode(),
      somFN = FocusNode(),
      segNoFN = FocusNode(),
      txNoFN = FocusNode(),
      tapeIDFN = FocusNode(),
      tapeTypeFN = FocusNode(),
      typeFN = FocusNode(),
      censorFN = FocusNode(),
      langFN = FocusNode(),
      prodFN = FocusNode(),
      colorFN = FocusNode(),
      idNoFN = FocusNode(),
      rightTableFN = FocusNode();

  bool isLocOpen = false,
      isChannelOpen = false,
      isBannerOpen = false,
      isTypOpen = false,
      isCensorOpen = false,
      isLangOpen = false,
      isPrdOpen = false,
      isColorOpen = false,
      isIdOpen = false,
      isTapeTypOpen = false;

  clearPage() {
    rightDataTable.clear();
    startDateCtr.clear();
    endDateCtr.clear();
    synopsisCtr.clear();
    copyCtr.clear();
    segNoCtrRight.text = "1";
    fillerNameCtr.clear();
    txCaptionCtr.clear();
    tapeIDCtr.text = "AUTOID";
    segNoCtrLeft.text = "1";
    txNoCtr.text = "AUTOID";
    somCtr.text = "00:00:00:00";
    eomCtr.text = "00:00:00:00";
    // durationCtr.clear();
    duration.value = "00:00:00:00";
    tcInCtr.text = "00:00:00:00";
    tcOutCtr.text = "00:00:00:00";
    segIDCtr.clear();
    movieNameCtr.clear();
    releaseYearCtr.clear();
    singerCtr.clear();
    musicDirectorCtr.clear();
    musicCompanyCtr.clear();
    fillerCode = "";
    selectedDropDowns = List.generate(20, (index) => null);
    focusNodeList = List.generate(17, (index) => FocusNode());
    if (onloadModel?.fillerMasterOnload?.lsttapesource != null &&
        onloadModel!.fillerMasterOnload!.lsttapesource!.isNotEmpty) {
      selectedDropDowns[16] =
          onloadModel!.fillerMasterOnload!.lsttapesource![0];
    }
    if (onloadModel?.fillerMasterOnload?.lstProducerTape != null &&
        onloadModel!.fillerMasterOnload!.lstProducerTape!.isNotEmpty) {
      selectedDropDowns[17] =
          onloadModel!.fillerMasterOnload!.lstProducerTape![0];
    }
    if (onloadModel?.fillerMasterOnload?.company != null &&
        onloadModel!.fillerMasterOnload!.company!.isNotEmpty) {
      selectedDropDowns[2] = onloadModel!.fillerMasterOnload!.company![0];
    }
    updateUI();
    locationFN.requestFocus();
  }

  @override
  void onInit() {
    selectedDropDowns = List.generate(20, (index) => null);
    focusNodeList = List.generate(17, (index) => FocusNode());
    formPermissions =
        Utils.fetchPermissions1(Routes.FILLER_MASTER.replaceAll("/", ""));
    super.onInit();
    // locationFN.addListener(() {
    //   if (!locationFN.hasFocus) {
    //     if (onloadModel?.fillerMasterOnload != null &&
    //         selectedDropDowns[0] == null &&
    //         !isLocOpen &&
    //         (!(Get.isDialogOpen ?? false))) {
    //       LoadingDialog.callErrorMessage1(msg: "Please select location",callback: (){
    //         locationFN.requestFocus();
    //       });
    //       // locationFN.requestFocus();
    //     }
    //   }
    // });
    // channelFN.addListener(() {
    //   if (!channelFN.hasFocus) {
    //     if (selectedDropDowns[19] == null &&
    //         !isChannelOpen &&
    //         (!(Get.isDialogOpen ?? false))) {
    //       LoadingDialog.callErrorMessage1(msg: "Please select channel",callback: (){
    //         channelFN.requestFocus();
    //       });
    //       // channelFN.requestFocus();
    //     }
    //   }
    // });
    // bannerFN.addListener(() {
    //   if (!bannerFN.hasFocus) {
    //     if (selectedDropDowns[2] == null &&
    //         !isBannerOpen &&
    //         (!(Get.isDialogOpen ?? false))) {
    //       LoadingDialog.callErrorMessage1(msg: "Please select banner",callback: (){
    //         bannerFN.requestFocus();
    //       });
    //     }
    //   }
    // });
    // fillerNameFN.addListener(() {
    //   if (!fillerNameFN.hasFocus) {
    //     if (fillerNameCtr.text == "" && (!(Get.isDialogOpen ?? false))) {
    //       LoadingDialog.callErrorMessage1(msg: "Please enter file name",callback: (){
    //         fillerNameFN.requestFocus();
    //       });
    //     }
    //   }
    // });
    // txCaptionFN.addListener(() {
    //   if (!txCaptionFN.hasFocus) {
    //     if (txCaptionCtr.text == "" && (!(Get.isDialogOpen ?? false))) {
    //       LoadingDialog.callErrorMessage1(msg: "Please enter tx caption",callback: (){
    //         txCaptionFN.requestFocus();
    //       });
    //     }
    //   }
    // });
    // tapeIDFN.addListener(() {
    //   if (!tapeIDFN.hasFocus) {
    //     if (tapeIDCtr.text == "" && (!(Get.isDialogOpen ?? false))) {
    //       LoadingDialog.callErrorMessage1(msg: "Please enter tape id",callback: (){
    //         tapeIDFN.requestFocus();
    //       });
    //     }
    //   }
    // });
    // segNoFN.addListener(() {
    //   if (!segNoFN.hasFocus) {
    //     if (segNoCtrLeft.text == "" && (!(Get.isDialogOpen ?? false))) {
    //       LoadingDialog.callErrorMessage1(msg: "Please enter seg no",callback: (){
    //         segNoFN.requestFocus();
    //       });
    //     }
    //   }
    // });
    // txNoFN.addListener(() {
    //   if (!txNoFN.hasFocus) {
    //     if (txNoCtr.text == "" && (!(Get.isDialogOpen ?? false))) {
    //       LoadingDialog.callErrorMessage1(msg: "Please enter tx no",callback: (){
    //         txNoFN.requestFocus();
    //       });
    //     }
    //   }
    // });
    // somFN.addListener(() {
    //   if (!somFN.hasFocus) {
    //     if (somCtr.text == "" && (!(Get.isDialogOpen ?? false))) {
    //       LoadingDialog.callErrorMessage1(msg: "Please enter som",callback: (){
    //         somFN.requestFocus();
    //       });
    //     }
    //   }
    // });
    // eomFN.addListener(() {
    //   if (!eomFN.hasFocus) {
    //     if (eomCtr.text == "" && (!(Get.isDialogOpen ?? false))) {
    //       LoadingDialog.callErrorMessage1(msg: "Please enter eom",callback: (){
    //         eomFN.requestFocus();
    //       });
    //     } else {
    //       calculateDuration();
    //     }
    //   }
    // });
    // tapeTypeFN.addListener(() {
    //   if (!tapeTypeFN.hasFocus) {
    //     if (selectedDropDowns[3] == null &&
    //         !isTapeTypOpen &&
    //         (!(Get.isDialogOpen ?? false))) {
    //       LoadingDialog.callErrorMessage1(msg: "Please select tape type",callback: (){
    //         tapeTypeFN.requestFocus();
    //       });
    //       // channelFN.requestFocus();
    //     }
    //   }
    // });
    // typeFN.addListener(() {
    //   if (!typeFN.hasFocus) {
    //     if (selectedDropDowns[4] == null &&
    //         !isTypOpen &&
    //         (!(Get.isDialogOpen ?? false))) {
    //       LoadingDialog.callErrorMessage1(msg: "Please select type",callback: (){
    //         typeFN.requestFocus();
    //       });
    //       // channelFN.requestFocus();
    //     }
    //   }
    // });
    // censorFN.addListener(() {
    //   if (!censorFN.hasFocus) {
    //     if (selectedDropDowns[5] == null &&
    //         !isCensorOpen &&
    //         (!(Get.isDialogOpen ?? false))) {
    //       LoadingDialog.callErrorMessage1(msg: "Please select censorship",callback: (){
    //         censorFN.requestFocus();
    //       });
    //       // channelFN.requestFocus();
    //     }
    //   }
    // });
    // langFN.addListener(() {
    //   if (!langFN.hasFocus) {
    //     if (selectedDropDowns[6] == null &&
    //         !isLangOpen &&
    //         (!(Get.isDialogOpen ?? false))) {
    //       LoadingDialog.callErrorMessage1(msg: "Please select language",callback: (){
    //         langFN.requestFocus();
    //       });
    //       // channelFN.requestFocus();
    //     }
    //   }
    // });
    // prodFN.addListener(() {
    //   if (!prodFN.hasFocus) {
    //     if (selectedDropDowns[7] == null &&
    //         !isPrdOpen &&
    //         (!(Get.isDialogOpen ?? false))) {
    //       LoadingDialog.callErrorMessage1(msg: "Please select production",callback: (){
    //         prodFN.requestFocus();
    //       });
    //       // channelFN.requestFocus();
    //     }
    //   }
    // });
    // colorFN.addListener(() {
    //   if (!colorFN.hasFocus) {
    //     if (selectedDropDowns[8] == null &&
    //         !isColorOpen &&
    //         (!(Get.isDialogOpen ?? false))) {
    //       LoadingDialog.callErrorMessage1(msg: "Please select color",callback: (){
    //         colorFN.requestFocus();
    //       });
    //       // channelFN.requestFocus();
    //     }
    //   }
    // });
    // /*colorFN.addListener(() {
    //   if (!colorFN.hasFocus) {
    //     if (selectedDropDowns[8] == null &&
    //         !isColorOpen &&
    //         (!(Get.isDialogOpen ?? false))) {
    //       LoadingDialog.callErrorMessage1(msg: "Please select color");
    //       // channelFN.requestFocus();
    //     }
    //   }
    // });*/
    // idNoFN.addListener(() {
    //   if (!idNoFN.hasFocus) {
    //     if (selectedDropDowns[17] == null &&
    //         !isIdOpen &&
    //         (!(Get.isDialogOpen ?? false))) {
    //       LoadingDialog.callErrorMessage1(msg: "Please select id",callback: (){
    //         idNoFN.requestFocus();
    //       });
    //       // channelFN.requestFocus();
    //     }
    //   }
    // });
  }

  @override
  void onReady() {
    super.onReady();

    onLoadData();
    addListeneres2();
  }

  void calculateDuration() {
    num secondSom = Utils.oldBMSConvertToSecondsValue(value: (somCtr.text));
    num secondEom = Utils.oldBMSConvertToSecondsValue(value: eomCtr.text);

    if (eomCtr.text.length >= 11) {
      if ((secondEom - secondSom) < 0) {
        LoadingDialog.showErrorDialog("EOM should not be less than SOM.",
            callback: () {
          // eomFN.requestFocus();
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

  // calculateDuration({bool showDialog = true}) {
  //   var diff = (Utils.oldBMSConvertToSecondsValue(value: eomCtr.text) -
  //       Utils.oldBMSConvertToSecondsValue(value: somCtr.text));

  //   if (diff.isNegative && showDialog) {
  //     eomCtr.clear();
  //     LoadingDialog.showErrorDialog("EOM should not less than SOM",
  //         callback: () {
  //       eomFN.requestFocus();
  //     });
  //   } else {
  //     durationCtr.text = Utils.convertToTimeFromDouble(value: diff);
  //   }
  // }

  formHandler(String btnName) {
    if (btnName == "Clear") {
      clearPage();
    } else if (btnName == "Save") {
      saveValidate();
    } else if (btnName == "Search") {
      Get.to(
        const SearchPage(
          key: Key("Filler Master"),
          screenName: "Filler Master",
          appBarName: "Filler Master",
          strViewName: "bms_view_fillermaster",
          isAppBarReq: true,
        ),
      );
    }
  }

  updateUI() {
    update(['rootUI']);
  }

  addListeneres2() {
    fillerNameFN.onKey = (node, event) {
      if (event.logicalKey == LogicalKeyboardKey.tab && !event.isShiftPressed) {
        if (fillerNameCtr.text.isNotEmpty) {
          txCaptionCtr.text = fillerNameCtr.text.toUpperCase();
          fillerNameCtr.text = fillerNameCtr.text.capitalizeFirst!;
          retrievRecord(text: fillerNameCtr.text.trim()).then((val) {
            closeDialogIfOpen();
          });
        }
      }
      return KeyEventResult.ignored;
    };
    tapeIDFN.onKey = (node, event) {
      if (event.logicalKey == LogicalKeyboardKey.tab) {
        if (!event.isShiftPressed) {
          tapeIDCtr.text = tapeIDCtr.text.toUpperCase();
          tapeIDLeave();
        }
      }
      return KeyEventResult.ignored;
    };
    segNoFN.onKey = (node, event) {
      if (event.logicalKey == LogicalKeyboardKey.tab) {
        if (!event.isShiftPressed) {
          segNoLeftLeave();
        }
      }
      return KeyEventResult.ignored;
    };
    /*eomFN.onKey = (node, event) {
      if (event.logicalKey == LogicalKeyboardKey.tab && !event.isShiftPressed) {
        calculateDuration();
      }
      return KeyEventResult.ignored;
    };*/
  }

  setCartNo() async {
    if (tapeIDCtr.text.trim().isNotEmpty &&
        segNoCtrLeft.text.trim().isNotEmpty) {
      var cartNo = tapeIDCtr.text.trim();
      txNoCtr.text = cartNo.substring(0, min(cartNo.length, 13));
    } else {
      txNoCtr.text = "";
    }
    txNoCtr.text = txNoCtr.text.trim();
  }

  segNoLeftLeave() async {
    if (segNoCtrLeft.text.trim().isEmpty) {
      segNoCtrLeft.text = "0";
    }
    await setCartNo();
    if (segNoCtrLeft.text.trim().isNotEmpty) {
      tapeIDCtr.text = tapeIDCtr.text.trim();
      // txNoCtr.text = "${tapeIDCtr.text.trim()}-${segNoCtrLeft.text.trim()}";
      if (tapeIDCtr.text.trim().isNotEmpty &&
          segNoCtrLeft.text.trim() != "0" &&
          segNoCtrLeft.text.trim().isNotEmpty) {
        LoadingDialog.call();
        await Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.FILLER_MASTER_SEGNO_LEAVE,
          fun: (resp) {
            Get.back();
            if (resp != null &&
                resp is Map<String, dynamic> &&
                resp['segNumber'] != null &&
                resp['segNumber']['eventName'] != null) {
              LoadingDialog.showErrorDialog(
                  resp['segNumber']['eventName'].toString(), callback: () {
                tapeIDFN.requestFocus();
              });
            }
          },
          json: {
            "exportTapeCode": tapeIDCtr.text,
            "segmentNumber": segNoCtrLeft.text,
            "code": fillerCode,
            "houseID": txNoCtr.text,
            "eventType": "",
          },
        );
      }
    } else {
      segNoCtrLeft.text = "0";
    }
    retrievRecord(
        tapeCode: tapeIDCtr.text, segNo: segNoCtrLeft.text, fromCopy: true);
  }

  tapeIDLeave() async {
    tapeIDCtr.text = tapeIDCtr.text.trim();
    await setCartNo();
    if (tapeIDCtr.text.trim().isNotEmpty &&
        (segNoCtrLeft.text.trim().isNotEmpty && segNoCtrLeft.text != "0")) {
      LoadingDialog.call();
      await Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.FILLER_MASTER_TAPE_ID_LEAVE,
        fun: (resp) {
          Get.back();
          if (resp != null &&
              resp is Map<String, dynamic> &&
              resp['tapeID_Leave'] != null &&
              resp['tapeID_Leave']['eventName'] != null) {
            LoadingDialog.showErrorDialog(
                resp['tapeID_Leave']['eventName'].toString(), callback: () {
              tapeIDFN.requestFocus();
            });
          }
        },
        json: {
          "exportTapeCode": tapeIDCtr.text,
          "segmentNumber": segNoCtrLeft.text,
          "code": fillerCode,
          "houseID": txNoCtr.text,
          "eventType": "",
        },
      );
    } else {
      tapeIDCtr.text = "AUTOID";
    }
  }

  Future<void> locationOnChanged(DropDownValue? val) async {
    if (val != null) {
      selectedDropDowns[0] = val;
      LoadingDialog.call();
      await Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.FILLER_MASTER_ON_LEAVE_LOCATION(val.key ?? ""),
        fun: (resp) {
          closeDialogIfOpen();
          if (resp != null &&
              resp is Map<String, dynamic> &&
              resp["onLeaveLocation"] != null) {
            selectedDropDowns[19] = null;
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

  Future<void> retrievRecord(
      {String text = "",
      String code = "",
      String tapeCode = "",
      String segNo = "",
      bool fromCopy = false}) async {
    LoadingDialog.call();
    await Get.find<ConnectorControl>().POSTMETHOD(
      api: ApiFactory.FILLER_MASTER_RETRIVE_RECORDS,
      fun: (resp) {
        closeDialogIfOpen();
        if (resp != null && resp is Map<String, dynamic>) {
          var tempModel = RetriveRecordFillerMasterModel.fromJson(resp);
          HouseID? tempModel2 = (tempModel.houseID?.isNotEmpty ?? false)
              ? tempModel.houseID![0]
              : null;

          if (tempModel2 != null && onloadModel != null) {
            /// FILLER CODE
            if (tempModel2.fillerCode != null) {
              fillerCode = tempModel2.fillerCode!;
            }

            ///LOCATION
            var tempLocation = onloadModel?.fillerMasterOnload?.lstLocation
                ?.firstWhereOrNull(
                    (element) => element.key == tempModel2.locationcode);
            if (tempLocation != null) {
              selectedDropDowns[0] = tempLocation;
            }

            /// CHANNELS
            var tempChannel = channelList.firstWhereOrNull(
                (element) => element.key == tempModel2.channelcode);
            if (tempChannel != null) {
              selectedDropDowns[19] = tempChannel;
            } else if (selectedDropDowns[0] != null) {
              locationOnChanged(selectedDropDowns[0]).then((value) {
                var tempChannel2 = channelList.firstWhereOrNull(
                    (element) => element.key == tempModel2.channelcode);
                if (tempChannel2 != null) {
                  selectedDropDowns[19] = tempChannel2;
                } else {
                  LoadingDialog.callErrorMessage1(
                      msg:
                          "You do not have required channel rights. Please contact support team.");
                }
              });
            }

            ///MOVIE GRADE
            var movieGrade = onloadModel?.fillerMasterOnload?.lstMovieGrade
                ?.firstWhereOrNull(
                    (element) => element.key == tempModel2.grade);
            if (movieGrade != null) {
              selectedDropDowns[15] = movieGrade;
            }

            /// BANNER CODE
            if (tempModel2.bannerCode != null &&
                tempModel2.bannerName != null) {
              selectedDropDowns[2] = DropDownValue(
                  key: tempModel2.bannerCode, value: tempModel2.bannerName);
            }

            /// TX-CAPTION
            if (tempModel2.exportTapeCaption != null) {
              txCaptionCtr.text = tempModel2.exportTapeCaption ?? "";
              if (txCaptionCtr.text.contains("F/")) {
                txCaptionCtr.text = txCaptionCtr.text.replaceAll(r'F/', "");
              }
            }

            /// FILLER-NAME
            ///
            if (fromCopy && tempModel2.fillerCaption != null) {
              print(tempModel2.fillerCaption);
              fillerNameCtr.text = tempModel2.fillerCaption ?? "";
            }

            /// TAPE-ID
            if (tempModel2.exportTapeCode != null) {
              tapeIDCtr.text = tempModel2.exportTapeCode ?? "";
            }

            /// SEG-NO-LEFT
            if (tempModel2.segmentNumber != null) {
              segNoCtrLeft.text = tempModel2.segmentNumber.toString();
            }

            /// TX-NO
            if (tempModel2.houseId != null) {
              txNoCtr.text = tempModel2.houseId.toString();
            }

            /// SOM
            if (tempModel2.som != null) {
              somCtr.text = tempModel2.som.toString();
            }

            /// EOM
            if (tempModel2.eom != null) {
              eomCtr.text = tempModel2.eom.toString();
            }
            calculateDuration();

            /// TAPE-TYPE
            var tapeTypeCode = onloadModel
                ?.fillerMasterOnload?.lstTapetypemaster
                ?.firstWhereOrNull(
                    (element) => element.key == tempModel2.tapeTypeCode);
            if (tapeTypeCode != null) {
              selectedTapeType.value = tapeTypeCode;
            }

            /// TYPE
            var typeCode = onloadModel?.fillerMasterOnload?.lstfillertypemaster
                ?.firstWhereOrNull(
                    (element) => element.key == tempModel2.fillerTypeCode);
            if (typeCode != null) {
              selectedDropDowns[4] = typeCode;
            }

            /// CENSHORSHIP
            var censhorShipCode = onloadModel
                ?.fillerMasterOnload?.lstCensorshipMaster
                ?.firstWhereOrNull(
                    (element) => element.key == tempModel2.censorshipCode);
            if (censhorShipCode != null) {
              selectedDropDowns[5] = censhorShipCode;
            }

            /// LANGAUGE
            var langaugeCode = onloadModel
                ?.fillerMasterOnload?.lstLanguagemaster
                ?.firstWhereOrNull(
                    (element) => element.key == tempModel2.languageCode);
            if (langaugeCode != null) {
              selectedDropDowns[6] = langaugeCode;
            }

            /// PRODUCTION
            var production = onloadModel?.fillerMasterOnload?.lstproduction
                ?.firstWhereOrNull(
                    (element) => element.key == tempModel2.inHouseOutHouse);
            if (production != null) {
              selectedDropDowns[7] = production;
            }

            /// SEG-ID
            /// COLOR
            var color = onloadModel?.fillerMasterOnload?.lstcolor
                ?.firstWhereOrNull(
                    (element) => element.key == tempModel2.blackWhite);
            if (color != null) {
              selectedDropDowns[8] = color;
            }

            /// REGION
            var region = onloadModel?.fillerMasterOnload?.lstRegion
                ?.firstWhereOrNull((element) =>
                    element.key == tempModel2.regioncode.toString());
            if (region != null) {
              selectedDropDowns[9] = color;
            }

            /// ENERGY
            var energy = onloadModel?.fillerMasterOnload?.lstEnegry
                ?.firstWhereOrNull((element) =>
                    element.key == tempModel2.energyCode.toString());
            if (energy != null) {
              selectedDropDowns[10] = energy;
            }

            /// ERA
            var era = onloadModel?.fillerMasterOnload?.lstEra?.firstWhereOrNull(
                (element) => element.key == tempModel2.eraCode.toString());
            if (era != null) {
              selectedDropDowns[11] = era;
            }

            /// SONG-GRADE
            var songGrade = onloadModel?.fillerMasterOnload?.lstSongGrade
                ?.firstWhereOrNull((element) =>
                    element.key == tempModel2.gradeCode.toString());
            if (songGrade != null) {
              selectedDropDowns[12] = songGrade;
            }

            /// MOOD
            var mood = onloadModel?.fillerMasterOnload?.lstMood
                ?.firstWhereOrNull(
                    (element) => element.key == tempModel2.moodCode.toString());
            if (mood != null) {
              selectedDropDowns[13] = mood;
            }

            /// TEMPO
            var tempo = onloadModel?.fillerMasterOnload?.lstTempo
                ?.firstWhereOrNull((element) =>
                    element.key == tempModel2.tempoCode.toString());
            if (tempo != null) {
              selectedDropDowns[14] = tempo;
            }

            /// MOVIE-NAME
            if (tempModel2.moviename != null) {
              movieNameCtr.text = tempModel2.moviename.toString();
            }

            /// RELEASE-YEAR
            if (tempModel2.releaseYear != null) {
              releaseYearCtr.text = tempModel2.releaseYear.toString();
            }

            /// SINGER
            if (tempModel2.singerName != null) {
              singerCtr.text = tempModel2.singerName.toString();
            }

            /// MUSIC-DIRECTOR
            if (tempModel2.musicDirector != null) {
              musicDirectorCtr.text = tempModel2.musicDirector.toString();
            }

            /// MUSIC-COMPANY
            if (tempModel2.musicCompany != null) {
              musicCompanyCtr.text = tempModel2.musicCompany.toString();
            }

            /// SOURCE

            /// ID-NO

            /// START-DATE
            if (tempModel2.fromDate != null) {
              startDateCtr.text = DateFormat("dd-MM-yyyy").format(
                  DateFormat("yyyy-MM-ddThh:mm:ss")
                      .parse(tempModel2.fromDate ?? "2023-06-14T23:59:59"));
            }

            /// END-DATE
            if (tempModel2.killDate != null) {
              endDateCtr.text = DateFormat("dd-MM-yyyy").format(
                  DateFormat("yyyy-MM-ddThh:mm:ss")
                      .parse(tempModel2.killDate ?? "2023-06-14T23:59:59"));
            }

            if (tempModel2.lstAnnotationLoadDatas != null) {
              rightDataTable.clear();
              rightDataTable.addAll(tempModel2.lstAnnotationLoadDatas!);
            }

            /// SYNOPSIS
            if (tempModel2.fillerSynopsis != null) {
              synopsisCtr.text = tempModel2.fillerSynopsis ?? "";
            }

            /// EVENT
            /// TC-IN
            /// TC-OUT
            /// COPY
            /// SEG-NO-RIGHT
            updateUI();
          }
        } else {
          // LoadingDialog.showErrorDialog(resp.toString());
        }
      },
      json: {
        "fillerCode": code,
        "fillerName": text,
        "exportTapeCode": tapeCode,
        "segno": segNo.isEmpty ? 0 : num.parse(segNo),
      },
    );
  }

  saveValidate() {
    if (selectedDropDowns[0] == null) {
      LoadingDialog.showErrorDialog("Location cannot be empty.");
    } else if (selectedDropDowns[19] == null) {
      LoadingDialog.showErrorDialog("Channel cannot be empty.");
    } else if (selectedDropDowns[17] == null) {
      LoadingDialog.showErrorDialog("ID No cannot be empty.");
    } else if (fillerNameCtr.text.trim().isEmpty) {
      LoadingDialog.showErrorDialog("Filler Caption cannot be empty.");
    } else if (txCaptionCtr.text.trim().isEmpty) {
      LoadingDialog.showErrorDialog("Export Tape Caption cannot be empty.");
    } else if (tapeIDCtr.text.trim().isEmpty) {
      LoadingDialog.showErrorDialog("Export Tape Code cannot be empty.");
    } else if (segNoCtrLeft.text.trim().isEmpty) {
      LoadingDialog.showErrorDialog("Segment Number cannot be empty.");
    } else if (txNoCtr.text.trim().isEmpty) {
      LoadingDialog.showErrorDialog("House ID cannot be empty.");
    } else {
      if (fillerCode.isNotEmpty) {
        LoadingDialog.recordExists(
          "Record Already exits!\nDo you want to modify it?",
          () {
            saveRecord();
          },
        );
      } else {
        saveRecord();
      }
    }
  }

  void saveRecord() {
    late DateTime startDate, endDate;
    try {
      startDate = DateFormat("dd-MM-yyyy").parse(startDateCtr.text);
      endDate = DateFormat("dd-MM-yyyy").parse(endDateCtr.text);
    } catch (e) {
      print(e.toString());
    }
    if (somCtr.text.trim().isEmpty) {
      LoadingDialog.showErrorDialog("Please enter SOM.");
    } else if (eomCtr.text.trim().isEmpty ||
        eomCtr.text.trim() == "00:00:00:00") {
      LoadingDialog.showErrorDialog("Please enter EOM.");
    } else if ((Utils.oldBMSConvertToSecondsValue(value: eomCtr.text) -
            Utils.oldBMSConvertToSecondsValue(value: somCtr.text))
        .isNegative) {
      eomCtr.clear();
      LoadingDialog.showErrorDialog("EOM should not less than SOM",
          callback: () {
        eomFN.requestFocus();
      });
    } else if (selectedDropDowns[3] == null) {
      LoadingDialog.showErrorDialog("Tape Type cannot be empty.");
    } else if (selectedDropDowns[4] == null) {
      LoadingDialog.showErrorDialog("Filler Type cannot be empty.");
    } else if (selectedDropDowns[5] == null) {
      LoadingDialog.showErrorDialog("Censor ship cannot be empty.");
    } else if (selectedDropDowns[6] == null) {
      LoadingDialog.showErrorDialog("Language cannot be empty.");
    } else if (selectedDropDowns[7] == null) {
      LoadingDialog.showErrorDialog("Production cannot be empty.");
    } else if (selectedDropDowns[8] == null) {
      LoadingDialog.showErrorDialog("BlackWhite cannot be empty.");
    } else if (selectedDropDowns[2] == null) {
      LoadingDialog.showErrorDialog("Banner cannot be empty.");
    } else if (startDate.isAfter(endDate)) {
      LoadingDialog.showErrorDialog("Start date should not more than end date");
    } else {
      LoadingDialog.call();
      Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.FILLER_MASTER_SAVE,
        fun: (resp) {
          closeDialogIfOpen();
          if (resp != null &&
              resp is Map<String, dynamic> &&
              resp['saveRecord'] != null &&
              resp['saveRecord']['strMessage'] != null &&
              resp['saveRecord']['strMessage']
                  .toString()
                  .contains("successfully")) {
            // LoadingDialog.callDataSaved(
            //     msg: resp['saveRecord']['strMessage'].toString(),
            //     callback: () {
            //       // clearPage();
            //     });
            // tapeIDCtr.text = resp['saveRecord']['tapeID'].toString();
            var msg = resp['saveRecord']['strMessage'].toString();
            if (resp['saveRecord']['tapeID'] != null) {
              tapeIDCtr.text = resp['saveRecord']['tapeID'].toString();
              txNoCtr.text = resp['saveRecord']['tapeID'].toString();
              msg =
                  "${resp['saveRecord']['strMessage']}\nID: (${resp['saveRecord']['tapeID']})";
            }
            // if (msg.contains('inserted')) {}
            LoadingDialog.callDataSaved(
                msg: msg,
                callback: () {
                  // clearPage();
                });
          } else {
            LoadingDialog.showErrorDialog(resp.toString(), callback: () {
              clearPage();
            });
          }
        },
        json: {
          "fillerCode": fillerCode,
          "fillerCaption": fillerNameCtr.text,
          "fillerDuration": Utils.convertToSecond(value: duration.value),
          "fillerTypeCode": selectedDropDowns[4]?.key,
          "bannerCode": selectedDropDowns[2]?.key,
          "languageCode": selectedDropDowns[6]?.key,
          "censorshipCode": selectedDropDowns[5]?.key,
          "tapeTypeCode": selectedDropDowns[3]?.key,
          "exportTapeCode": tapeIDCtr.text,
          "exportTapeCaption": "F/${txCaptionCtr.text}",
          "blackWhite": selectedDropDowns[8]?.key,
          "inHouseOutHouse": selectedDropDowns[7]?.key,
          "segmentNumber": num.tryParse(segNoCtrLeft.text) ?? 0,
          "som": somCtr.text,
          "fromDate": DateFormat("yyyy-MM-ddT00:00:00")
              .format(startDate), // "2023-06-26T09:54:57.806Z"
          "killDate": DateFormat("yyyy-MM-ddT00:00:00")
              .format(endDate), // "2023-06-26T09:54:57.806Z"
          "fillerSynopsis": synopsisCtr.text,
          "modifiedBy": Get.find<MainController>().user?.logincode,
          "houseId": txNoCtr.text,
          "blanktapeid": selectedDropDowns[17]?.key,
          "locationcode": selectedDropDowns[0]?.key,
          "channelcode": selectedDropDowns[19]?.key,
          "seg": segIDCtr.text,
          "eom": eomCtr.text,
          "locationShortName": "AS",
          "movieName": movieNameCtr.text,
          "singer": singerCtr.text,
          "musicDirector": musicDirectorCtr.text,
          "musicCompany": musicCompanyCtr.text,
          "releaseYear": releaseYearCtr.text,
          "grade": selectedDropDowns[15]?.key, //
          "moodCode": num.tryParse(selectedDropDowns[13]?.key ?? ""),
          "energyCode": num.tryParse(selectedDropDowns[10]?.key ?? ""),
          "tempoCode": num.tryParse(selectedDropDowns[14]?.key ?? ""),
          "eraCode": num.tryParse(selectedDropDowns[11]?.key ?? ""),
          "gradeCode": num.tryParse(selectedDropDowns[12]?.key ?? ""), //
          "regioncode": num.tryParse(selectedDropDowns[9]?.key ?? ""), //
          "lstAnnotation": rightDataTable.value.map((e) => e.toJson()).toList(),
        },
      );
    }
  }

  clearBottomAnnotation() {
    tcInCtr.text = "00:00:00:00";
    tcOutCtr.text = "00:00:00:00";
  }

  void handleAddTap() {
    if (selectedDropDowns[18] == null) {
      LoadingDialog.showErrorDialog("Please enter event name.");
      return;
    }
    rightDataTable.add(FillerMasterAnnotationModel(
      eventId: int.tryParse(selectedDropDowns[18]?.key ?? "0") ?? 0,
      eventname: selectedDropDowns[18]?.value,
      tCin: tcInCtr.text,
      tCout: tcOutCtr.text,
    ));
    clearBottomAnnotation();
  }

  Future<void> handleCopyTap() async {
    await retrievRecord(
      tapeCode: copyCtr.text.trim(),
      segNo: segNoCtrRight.text.trim(),
      fromCopy: true,
    );
    tapeIDCtr.text = "AUTOID";
    txNoCtr.text = "AUTOID";
    segNoCtrLeft.text = "1";
    var now = DateTime.now();
    // DateFormat("yyyyMMdd").format(now);;
    var tempName = fillerNameCtr.text;
    fillerNameCtr.text = "$tempName-${DateFormat("yyyyMMdd").format(now)}";
    // txCaptionCtr.text = "${txCaptionCtr.text}-${DateFormat("yyyyMMdd").format(now)}";
    // txCaptionCtr.clear();
    // fillerNameFN.requestFocus();
    if (tempName.contains("F/")) {
      tempName = tempName.replaceAll(r'F/', "");
    }

    txCaptionCtr.text = "$tempName-${DateFormat("yyyyMMdd").format(now)}";
    startDateCtr.text = "${now.day}-${now.month}-${now.year}";
    now = now.copyWith(month: now.month + 3);
    endDateCtr.text = "${now.day}-${now.month}-${now.year}";
    fillerCode = "";
  }

  void onLoadData() {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
      api: ApiFactory.FILLER_MASTER_ON_LOAD,
      fun: (resp) {
        closeDialogIfOpen();
        if (resp is Map<String, dynamic> &&
            resp['fillerMasterOnload'] != null) {
          onloadModel = FillerMasterOnLoadModel.fromJson(resp);
          if (onloadModel?.fillerMasterOnload?.lsttapesource != null &&
              onloadModel!.fillerMasterOnload!.lsttapesource!.isNotEmpty) {
            selectedDropDowns[16] =
                onloadModel!.fillerMasterOnload!.lsttapesource![0];
          }
          if (onloadModel?.fillerMasterOnload?.lstProducerTape != null &&
              onloadModel!.fillerMasterOnload!.lstProducerTape!.isNotEmpty) {
            selectedDropDowns[17] =
                onloadModel!.fillerMasterOnload!.lstProducerTape![0];
          }

          if (onloadModel?.fillerMasterOnload?.company != null &&
              onloadModel!.fillerMasterOnload!.company!.isNotEmpty) {
            selectedDropDowns[2] = onloadModel!.fillerMasterOnload!.company![0];
          }
          updateUI();
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

  closeDialogIfOpen() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
      while (Get.isDialogOpen ?? false) {
        Get.back();
      }
    }
  }
}

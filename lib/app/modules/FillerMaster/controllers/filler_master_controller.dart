import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/app/routes/app_pages.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:flutter/material.dart';
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
  List<PermissionModel>? formPermissions;
  FillerMasterOnLoadModel? onloadModel;
  var rightDataTable = <FillerMasterAnnotationModel>[].obs;
  String fillerCode = "";
  var channelList = <DropDownValue>[].obs;

  var startDateCtr = TextEditingController(),
      endDateCtr = TextEditingController(),
      synopsisCtr = TextEditingController(),
      copyCtr = TextEditingController(),
      segNoCtrRight = TextEditingController(text: "1"),
      fillerNameCtr = TextEditingController(),
      tcInCtr = TextEditingController(text: "00:00:00:00"),
      tcOutCtr = TextEditingController(text: "00:00:00:00"),
      txCaptionCtr = TextEditingController(),
      tapeIDCtr = TextEditingController(),
      segNoCtrLeft = TextEditingController(text: "1"),
      segIDCtr = TextEditingController(),
      txNoCtr = TextEditingController(),
      eomCtr = TextEditingController(text: "00:00:00:00"),
      somCtr = TextEditingController(text: "00:00:00:00"),
      durationCtr = TextEditingController(text: "00:00:00:00"),
      movieNameCtr = TextEditingController(),
      releaseYearCtr = TextEditingController(),
      singerCtr = TextEditingController(),
      musicDirectorCtr = TextEditingController(),
      musicCompanyCtr = TextEditingController();

  var locationFN = FocusNode(), eomFN = FocusNode(), fillerNameFN = FocusNode(), segNoFN = FocusNode(), tapeIDFN = FocusNode();

  clearPage() {
    rightDataTable.clear();
    startDateCtr.clear();
    endDateCtr.clear();
    synopsisCtr.clear();
    copyCtr.clear();
    segNoCtrRight.text = "1";
    fillerNameCtr.clear();
    txCaptionCtr.clear();
    tapeIDCtr.text = "AUTO";
    segNoCtrLeft.text = "1";
    txNoCtr.text = "AUTO";
    somCtr.text = "00:00:00:00";
    eomCtr.text = "00:00:00:00";
    durationCtr.clear();
    tcInCtr.text = "00:00:00:00";
    tcOutCtr.text = "00:00:00:00";
    segIDCtr.clear();
    movieNameCtr.clear();
    releaseYearCtr.clear();
    singerCtr.clear();
    musicDirectorCtr.clear();
    musicCompanyCtr.clear();
    selectedDropDowns = List.generate(20, (index) => null);
    if (onloadModel?.fillerMasterOnload?.lsttapesource != null && onloadModel!.fillerMasterOnload!.lsttapesource!.isNotEmpty) {
      selectedDropDowns[16] = onloadModel!.fillerMasterOnload!.lsttapesource![0];
    }
    if (onloadModel?.fillerMasterOnload?.lstProducerTape != null && onloadModel!.fillerMasterOnload!.lstProducerTape!.isNotEmpty) {
      selectedDropDowns[17] = onloadModel!.fillerMasterOnload!.lstProducerTape![0];
    }
    updateUI();
    locationFN.requestFocus();
  }

  @override
  void onInit() {
    selectedDropDowns = List.generate(20, (index) => null);

    formPermissions = Utils.fetchPermissions1(Routes.FILLER_MASTER.replaceAll("/", ""));
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    onLoadData();
    addListeneres2();
  }

  calculateDuration() {
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

  formHandler(String btnName) {
    if (btnName == "Clear") {
      clearPage();
    } else if (btnName == "Search") {
      Get.to(
        SearchPage(
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
    segNoFN.addListener(() {
      if (!segNoFN.hasFocus) {
        segNoLeftLeave();
      }
    });
    tapeIDFN.addListener(() {
      if (!tapeIDFN.hasFocus) {
        tapeIDLeave();
      }
    });
    fillerNameFN.addListener(() {
      if (!fillerNameFN.hasFocus) {
        if (fillerNameCtr.text.isNotEmpty) {
          retrievRecord(text: fillerNameCtr.text.trim());
        }
      }
    });
    eomFN.addListener(() {
      if (!eomFN.hasFocus) {
        calculateDuration();
      }
    });
  }

  setCartNo() {
    if (tapeIDCtr.text.trim().isNotEmpty && segNoCtrLeft.text.trim().isNotEmpty) {
      txNoCtr.text = "${tapeIDCtr.text.trim()}-${segNoCtrLeft.text.trim()}";
    } else {
      txNoCtr.text = "";
    }
  }

  segNoLeftLeave() async {
    if (segNoCtrLeft.text.trim().isEmpty) {
      segNoCtrLeft.text = "0";
    }
    setCartNo();
    if (tapeIDCtr.text.trim().isNotEmpty && (segNoCtrLeft.text.trim().isNotEmpty && segNoCtrLeft.text != "0")) {
      LoadingDialog.call();
      await Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.FILLER_MASTER_SEGNO_LEAVE,
        fun: (resp) {
          closeDialogIfOpen();
          if (resp != null && resp is Map<String, dynamic> && resp['segNumber'] != null && resp['segNumber']['eventName'] != null) {
            LoadingDialog.showErrorDialog(resp['segNumber']['eventName'].toString(), callback: () {
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
      segNoCtrLeft.text = "0";
    }
    retrievRecord(tapeCode: tapeIDCtr.text, segNo: segNoCtrLeft.text);
  }

  tapeIDLeave() async {
    tapeIDCtr.text = tapeIDCtr.text.trim();
    setCartNo();
    txNoCtr.text = txNoCtr.text.trim();

    if (tapeIDCtr.text.trim().isNotEmpty && (segNoCtrLeft.text.trim().isNotEmpty && segNoCtrLeft.text != "0")) {
      LoadingDialog.call();
      await Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.FILLER_MASTER_TAPE_ID_LEAVE,
        fun: (resp) {
          closeDialogIfOpen();
          if (resp != null && resp is Map<String, dynamic> && resp['tapeid'] != null && resp['tapeid']['eventName'] != null) {
            LoadingDialog.showErrorDialog(resp['tapeid']['eventName'].toString(), callback: () {
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
      tapeIDCtr.text = "AUTO";
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
          if (resp != null && resp is Map<String, dynamic> && resp["onLeaveLocation"] != null) {
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

  retrievRecord({String text = "", String code = "", String tapeCode = "", String segNo = ""}) async {
    LoadingDialog.call();
    await Get.find<ConnectorControl>().POSTMETHOD(
      api: ApiFactory.FILLER_MASTER_RETRIVE_RECORDS,
      fun: (resp) {
        closeDialogIfOpen();
        if (resp != null && resp is Map<String, dynamic>) {
          var tempModel = RetriveRecordFillerMasterModel.fromJson(resp);
          HouseID? tempModel2 = (tempModel.houseID?.isNotEmpty ?? false) ? tempModel.houseID![0] : null;

          if (tempModel2 != null && onloadModel != null) {
            /// FILLER CODE
            if (tempModel2.fillerCode != null) {
              fillerCode = tempModel2.fillerCode!;
            }

            ///LOCATION
            var tempLocation = onloadModel?.fillerMasterOnload?.lstLocation?.firstWhereOrNull((element) => element.key == tempModel2.locationcode);
            if (tempLocation != null) {
              selectedDropDowns[0] = tempLocation;
            }

            /// CHANNELS
            var tempChannel = channelList.firstWhereOrNull((element) => element.key == tempModel2.channelcode);
            if (tempChannel != null) {
              selectedDropDowns[19] = tempChannel;
            } else if (selectedDropDowns[0] != null) {
              locationOnChanged(selectedDropDowns[0]).then((value) {
                var tempChannel2 = channelList.firstWhereOrNull((element) => element.key == tempModel2.channelcode);
                if (tempChannel2 != null) {
                  selectedDropDowns[19] = tempChannel2;
                }
              });
            }

            ///MOVIE GRADE
            var movieGrade = onloadModel?.fillerMasterOnload?.lstMovieGrade?.firstWhereOrNull((element) => element.key == tempModel2.grade);
            if (movieGrade != null) {
              selectedDropDowns[15] = movieGrade;
            }

            /// BANNER CODE
            if (tempModel2.bannerCode != null && tempModel2.bannerName != null) {
              selectedDropDowns[2] = DropDownValue(key: tempModel2.bannerCode, value: tempModel2.bannerName);
            }

            /// TX-CAPTION
            if (tempModel2.fillerCaption != null) {
              txCaptionCtr.text = tempModel2.fillerCaption ?? "";
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
            var tapeTypeCode =
                onloadModel?.fillerMasterOnload?.lstTapetypemaster?.firstWhereOrNull((element) => element.key == tempModel2.tapeTypeCode);
            if (tapeTypeCode != null) {
              selectedDropDowns[3] = tapeTypeCode;
            }

            /// TYPE
            var typeCode =
                onloadModel?.fillerMasterOnload?.lstfillertypemaster?.firstWhereOrNull((element) => element.key == tempModel2.fillerTypeCode);
            if (typeCode != null) {
              selectedDropDowns[4] = typeCode;
            }

            /// CENSHORSHIP
            var censhorShipCode =
                onloadModel?.fillerMasterOnload?.lstCensorshipMaster?.firstWhereOrNull((element) => element.key == tempModel2.censorshipCode);
            if (censhorShipCode != null) {
              selectedDropDowns[5] = censhorShipCode;
            }

            /// LANGAUGE
            var langaugeCode =
                onloadModel?.fillerMasterOnload?.lstLanguagemaster?.firstWhereOrNull((element) => element.key == tempModel2.languageCode);
            if (langaugeCode != null) {
              selectedDropDowns[6] = langaugeCode;
            }

            /// PRODUCTION
            var production = onloadModel?.fillerMasterOnload?.lstproduction?.firstWhereOrNull((element) => element.key == tempModel2.inHouseOutHouse);
            if (production != null) {
              selectedDropDowns[7] = production;
            }

            /// SEG-ID
            /// COLOR
            var color = onloadModel?.fillerMasterOnload?.lstcolor?.firstWhereOrNull((element) => element.key == tempModel2.blackWhite);
            if (color != null) {
              selectedDropDowns[8] = color;
            }

            /// REGION
            var region = onloadModel?.fillerMasterOnload?.lstRegion?.firstWhereOrNull((element) => element.key == tempModel2.regioncode.toString());
            if (region != null) {
              selectedDropDowns[9] = color;
            }

            /// ENERGY
            var energy = onloadModel?.fillerMasterOnload?.lstEnegry?.firstWhereOrNull((element) => element.key == tempModel2.energyCode.toString());
            if (energy != null) {
              selectedDropDowns[10] = energy;
            }

            /// ERA
            var era = onloadModel?.fillerMasterOnload?.lstEra?.firstWhereOrNull((element) => element.key == tempModel2.eraCode.toString());
            if (era != null) {
              selectedDropDowns[11] = era;
            }

            /// SONG-GRADE
            var songGrade =
                onloadModel?.fillerMasterOnload?.lstSongGrade?.firstWhereOrNull((element) => element.key == tempModel2.gradeCode.toString());
            if (songGrade != null) {
              selectedDropDowns[12] = songGrade;
            }

            /// MOOD
            var mood = onloadModel?.fillerMasterOnload?.lstMood?.firstWhereOrNull((element) => element.key == tempModel2.moodCode.toString());
            if (mood != null) {
              selectedDropDowns[13] = mood;
            }

            /// TEMPO
            var tempo = onloadModel?.fillerMasterOnload?.lstTempo?.firstWhereOrNull((element) => element.key == tempModel2.tempoCode.toString());
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
              startDateCtr.text =
                  DateFormat("dd-MM-yyyy").format(DateFormat("yyyy-MM-ddThh:mm:ss").parse(tempModel2.fromDate ?? "2023-06-14T23:59:59"));
            }

            /// END-DATE
            if (tempModel2.killDate != null) {
              endDateCtr.text =
                  DateFormat("dd-MM-yyyy").format(DateFormat("yyyy-MM-ddThh:mm:ss").parse(tempModel2.killDate ?? "2023-06-14T23:59:59"));
            }

            /// SYNOPSIS
            /// EVENT
            /// TC-IN
            /// TC-OUT
            /// COPY
            /// SEG-NO-RIGHT
            updateUI();
          }
        } else {
          LoadingDialog.showErrorDialog(resp.toString());
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
    } else if (selectedDropDowns[1] == null) {
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

  void saveRecord() {}

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
      eventID: selectedDropDowns[18]?.key,
      eventName: selectedDropDowns[18]?.key,
      tCIn: tcInCtr.text,
      tCOut: tcOutCtr.text,
    ));
    clearBottomAnnotation();
  }

  Future<void> handleCopyTap() async {
    await retrievRecord(
      tapeCode: copyCtr.text.trim(),
      segNo: segNoCtrRight.text.trim(),
    );
    tapeIDCtr.text = "AUTO";
    txNoCtr.text = "AUTO";
    segNoCtrLeft.text = "1";
    var now = DateTime.now();
    fillerNameCtr.text =
        "${"${fillerNameCtr.text}                                        ".toString().substring(0, 31)}-${now.day}-${now.month}-${now.year}";
    fillerNameFN.requestFocus();
    txCaptionCtr.clear();
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
        if (resp is Map<String, dynamic> && resp['fillerMasterOnload'] != null) {
          onloadModel = FillerMasterOnLoadModel.fromJson(resp);
          if (onloadModel?.fillerMasterOnload?.lsttapesource != null && onloadModel!.fillerMasterOnload!.lsttapesource!.isNotEmpty) {
            selectedDropDowns[16] = onloadModel!.fillerMasterOnload!.lsttapesource![0];
          }
          if (onloadModel?.fillerMasterOnload?.lstProducerTape != null && onloadModel!.fillerMasterOnload!.lstProducerTape!.isNotEmpty) {
            selectedDropDowns[17] = onloadModel!.fillerMasterOnload!.lstProducerTape![0];
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
    }
  }
}

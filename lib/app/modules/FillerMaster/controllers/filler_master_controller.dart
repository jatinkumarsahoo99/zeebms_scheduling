import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/app/routes/app_pages.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/PermissionModel.dart';
import '../../../providers/Utils.dart';
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
  late List<DropDownValue?> selectedDropDowns;
  List<PermissionModel>? formPermissions;
  FillerMasterOnLoadModel? onloadModel;
  var rightDataTable = [].obs;
  String fillerCode = "";

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
    selectedDropDowns = List.generate(19, (index) => null);
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
    selectedDropDowns = List.generate(19, (index) => null);

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
    if (btnName == "Clear") {}
    clearPage();
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
            if (tempModel2.fillerCode != null) {
              fillerCode = tempModel2.fillerCode!;
            }
            var tempLocation = onloadModel?.fillerMasterOnload?.lstLocation?.firstWhereOrNull((element) => element.key == tempModel2.locationcode);
            if (tempLocation != null) {
              selectedDropDowns[0] = tempLocation;
            }

            var movieGrade = onloadModel?.fillerMasterOnload?.lstMovieGrade?.firstWhereOrNull((element) => element.key == tempModel2.grade);
            if (movieGrade != null) {
              selectedDropDowns[15] = movieGrade;
            }

            /// banner code

            if (tempModel2.exportTapeCode != null) {
              tapeIDCtr.text = tempModel2.exportTapeCode ?? "";
            }
            if (tempModel2.segmentNumber != null) {
              segNoCtrLeft.text = tempModel2.segmentNumber.toString();
            }
            if (tempModel2.houseId != null) {
              txNoCtr.text = tempModel2.houseId.toString();
            }

            if (tempModel2.houseId != null) {
              txNoCtr.text = tempModel2.houseId.toString();
            }

            if (tempModel2.som != null) {
              somCtr.text = tempModel2.som.toString();
            }
            if (tempModel2.eom != null) {
              eomCtr.text = tempModel2.eom.toString();
            }
            calculateDuration();

            var tapeTypeCode =
                onloadModel?.fillerMasterOnload?.lstTapetypemaster?.firstWhereOrNull((element) => element.key == tempModel2.tapeTypeCode);
            if (movieGrade != null) {
              selectedDropDowns[3] = tapeTypeCode;
            }
            var typeCode =
                onloadModel?.fillerMasterOnload?.lstfillertypemaster?.firstWhereOrNull((element) => element.key == tempModel2.fillerTypeCode);
            if (movieGrade != null) {
              selectedDropDowns[4] = typeCode;
            }
            var censhorShipCode =
                onloadModel?.fillerMasterOnload?.lstCensorshipMaster?.firstWhereOrNull((element) => element.key == tempModel2.censorshipCode);
            if (movieGrade != null) {
              selectedDropDowns[5] = censhorShipCode;
            }
            var langaugeCode =
                onloadModel?.fillerMasterOnload?.lstLanguagemaster?.firstWhereOrNull((element) => element.key == tempModel2.languageCode);
            if (movieGrade != null) {
              selectedDropDowns[6] = langaugeCode;
            }
            var production = onloadModel?.fillerMasterOnload?.lstproduction?.firstWhereOrNull((element) => element.key == tempModel2.fillerCode);
            if (movieGrade != null) {
              selectedDropDowns[7] = production;
            }
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

  saveRecord() {}

  void handleAddTap() {}

  void handleCopyTap() {}

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

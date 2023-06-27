import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/modules/LogAdditions/bindings/log_additions_binding.dart';
// import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import '../../../../widgets/cutom_dropdown.dart';
import '../../../data/PermissionModel.dart';
import '../../../providers/Utils.dart';
import '../../../routes/app_pages.dart';
import '../../CommonSearch/views/common_search_view.dart';
import '../../FillerMaster/model/filler_annotation_model.dart';
import '../model/promo_master_on_load_model.dart';

class PromoMasterController extends GetxController {
  /// 0=>category
  /// 1=>company
  /// 2=>location
  /// 3=>channel
  /// 4=>promo type
  /// 5=>blank tape id down side
  /// 6=>program
  /// 7=>tag detail
  /// 8=>org/repeat
  /// 9=>billing
  /// 10=>tape type
  /// 11=>event
  late List<DropDownValue?> selectedDropDowns;
  List<PermissionModel>? formPermissions;

  var rightDataTable = <FillerMasterAnnotationModel>[].obs;
  String promoCode = "", strHouseID = "", strSegmentNumber = "", commercialCode = "";
  PromoMasterOnloadModel? onloadModel;
  var channelList = <DropDownValue>[].obs;
  var txCaptionPreFix = "".obs;
  var segHash = 2.obs;

  var startDateCtr = TextEditingController(),
      endDateCtr = TextEditingController(),
      copyCtr = TextEditingController(),
      tcInCtr = TextEditingController(text: "00:00:00:00"),
      tcOutCtr = TextEditingController(text: "00:00:00:00"),
      blankTapeIDCtr = TextEditingController(),
      captionCtr = TextEditingController(),
      txCaptionCtr = TextEditingController(),
      tapeIDCtr = TextEditingController(),
      segNoCtr = TextEditingController(text: "1"),
      txNoCtr = TextEditingController(),
      eomCtr = TextEditingController(text: "00:00:00:00"),
      somCtr = TextEditingController(text: "00:00:00:00"),
      durationCtr = TextEditingController(text: "00:00:00:00");

  var locationFN = FocusNode(),
      eomFN = FocusNode(),
      fillerNameFN = FocusNode(),
      captionFN = FocusNode(),
      segNoFN = FocusNode(),
      tapeIDFN = FocusNode(),
      txNoFN = FocusNode(),
      blanktapeIdFN = FocusNode(),
      rightTableFN = FocusNode();

  @override
  void onInit() {
    selectedDropDowns = List.generate(12, (index) => null);
    formPermissions = Utils.fetchPermissions1(Routes.PROMO_MASTER.replaceAll("/", ""));
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    initailAPICall();
    addListeners2();
  }

  addListeners2() {
    captionFN.addListener(() {
      if (!captionFN.hasFocus) {
        captionLeave();
      }
    });
    tapeIDFN.addListener(() {
      if (!tapeIDFN.hasFocus) {
        tapeIdLeave();
      }
    });
    txNoFN.addListener(() {
      if (!txNoFN.hasFocus) {
        txNoLeave();
      }
    });
    blanktapeIdFN.addListener(() {
      if (!blanktapeIdFN.hasFocus) {
        onleaveBlankTapeID();
      }
    });
  }

  formHandler(String btnName) {
    if (btnName == "Clear") {
      clearPage();
    } else if (btnName == "Save") {
      // saveValidate();
    } else if (btnName == "Search") {
      Get.to(
        SearchPage(
          key: Key("Promo Master"),
          screenName: "Promo Master",
          appBarName: "Promo Master",
          strViewName: "BMS_view_Promomaster",
          isAppBarReq: true,
        ),
      );
    }
  }

  clearPage() {
    promoCode = "";
    txCaptionPreFix.value = "PR/";
    segHash.value = 1;
    rightDataTable.clear();
    startDateCtr.clear();
    captionCtr.clear();
    blankTapeIDCtr.clear();
    endDateCtr.clear();
    copyCtr.clear();
    txCaptionCtr.clear();
    tapeIDCtr.text = "AUTO";
    txNoCtr.text = "AUTO";
    somCtr.text = "00:00:00:00";
    eomCtr.text = "00:00:00:00";
    durationCtr.clear();
    tcInCtr.text = "00:00:00:00";
    tcOutCtr.text = "00:00:00:00";
    segNoCtr.text = "1";
    selectedDropDowns = List.generate(12, (index) => null);
    updateUI();
    captionFN.requestFocus();
  }

  calculateDuration({bool showDialog = true}) {
    var diff = (Utils.oldBMSConvertToSecondsValue(value: eomCtr.text) - Utils.oldBMSConvertToSecondsValue(value: somCtr.text));

    if (diff.isNegative && showDialog) {
      eomCtr.clear();
      LoadingDialog.showErrorDialog("EOM should not less than SOM", callback: () {
        eomFN.requestFocus();
      });
    } else {
      durationCtr.text = Utils.convertToTimeFromDouble(value: diff);
    }
  }

  updateUI() {
    update(['rootUI']);
  }

  captionLeave() {
    if (captionCtr.text.trim().isNotEmpty) {
      txCaptionCtr.text = captionCtr.text.trim();
    }
  }

  tapeIdLeave() async {
    if (tapeIDCtr.text.trim().isNotEmpty && segHash.value != 0) {
      await retrieveRecord("", "", tapeIDCtr.text.trim(), segHash.value);
      if (promoCode.isNotEmpty) {
        txNoCtr.text = tapeIDCtr.text;
      }
    }
  }

  onleaveBlankTapeID() {
    if (blankTapeIDCtr.text.trim().isNotEmpty) {
      LoadingDialog.call();
      Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.PROMO_MASTER_BLANK_TAPE_ID_LEAVE(blankTapeIDCtr.text.trim()),
        fun: (resp) {
          Get.back();
          if (resp != null &&
              resp is Map<String, dynamic> &&
              resp['resLeaveBlankTapeId'] != null &&
              resp['resLeaveBlankTapeId']['message'] != null &&
              resp['resLeaveBlankTapeId']['message'].toString() == "Invalid blank tape id.") {
            LoadingDialog.showErrorDialog(resp['resLeaveBlankTapeId']['message'].toString(), callback: () {
              blanktapeIdFN.requestFocus();
            });
          }
        },
      );
    }
  }

  txNoLeave() async {
    LoadingDialog.call();
    if (txNoCtr.text.isNotEmpty) {
      await Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.PROMO_MASTER_TX_NO_LEAVE,
        fun: (resp) {
          Get.back();
          if (resp != null &&
              resp is Map<String, dynamic> &&
              resp['cartNo_Leave'] != null &&
              resp['cartNo_Leave']['eventName'] != null &&
              resp['cartNo_Leave']['eventName'].toString().contains("House ID you entered is already used for")) {
            if (promoCode.isNotEmpty) {
              txNoCtr.text = strHouseID;
            }
            LoadingDialog.showErrorDialog(resp['cartNo_Leave']['eventName'].toString(), callback: () {
              txNoFN.requestFocus();
            });
          }
        },
        json: {
          "exportTapeCode": "",
          "segmentNumber": "",
          "code": promoCode,
          "houseID": txNoCtr.text,
          "eventType": "",
        },
      );
    } else {
      txNoCtr.text = "AUTO";
    }

    if (txNoCtr.text.trim().isNotEmpty && segHash.value != 0) {
      retrieveRecord("", "", "", 0, houseid: txNoCtr.text.trim());
    }
  }

  Future<void> retrieveRecord(String text, String code, String exporttapecode, int segno, {houseid = 0}) async {
    LoadingDialog.call();
    await Get.find<ConnectorControl>().POSTMETHOD(
      api: ApiFactory.PROMO_MASTER_RETRIVE_RECORDS,
      fun: (resp) {
        closeDialogIfOpen();
        if (resp != null && resp['retrieveRecord'] != null) {}
      },
      json: {
        "promoCode": promoCode,
        "promoCaption": txCaptionCtr.text,
        "exportTapeCode": exporttapecode,
        "segmentNumber": segno,
        "houseid": num.tryParse(houseid) ?? 0,
      },
    );
  }

  Future<void> locationOnChanged(DropDownValue? val) async {
    if (val != null) {
      selectedDropDowns[2] = val;
      LoadingDialog.call();
      await Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.PROMO_MASTER_ON_LEAVE_LOCATION(val.key ?? ""),
        fun: (resp) {
          closeDialogIfOpen();
          if (resp != null && resp is Map<String, dynamic> && resp["onLeaveLocation"] != null) {
            selectedDropDowns[3] = null;
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

  void handleAddTapFromAnnotations() {}

  void handleCopyTap() {}

  initailAPICall() {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
      api: ApiFactory.PROMO_MASTER_ON_LOAD,
      fun: (resp) {
        closeDialogIfOpen();
        onloadModel = PromoMasterOnloadModel.fromJson(resp);
        if (onloadModel?.promoMasterOnLoad != null) {
          updateUI();
          captionFN.requestFocus();
        }
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

  void handleOnChangedCategory(DropDownValue? val) {
    selectedDropDowns[0] = val;
    if (val != null && val.value != null && val.value!.length >= 2) {
      txCaptionPreFix.value = "${val.value!.substring(0, 2)}/".toUpperCase();
    }
  }
}

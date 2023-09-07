import 'dart:convert';

import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/controller/MainController.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/modules/CommonDocs/controllers/common_docs_controller.dart';
import 'package:bms_scheduling/app/modules/LogAdditions/bindings/log_additions_binding.dart';
// import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:bms_scheduling/widgets/gridFromMap.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

// import '../../../../widgets/cutom_dropdown.dart';
import '../../../../widgets/DataGridShowOnly.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/PlutoGrid/src/manager/pluto_grid_state_manager.dart';
import '../../../../widgets/PlutoGrid/src/pluto_grid.dart';
import '../../../controller/HomeController.dart';
import '../../../data/PermissionModel.dart';
import '../../../data/user_data_settings_model.dart';
import '../../../providers/ExportData.dart';
import '../../../providers/Utils.dart';
import '../../../routes/app_pages.dart';
import '../../CommonDocs/views/common_docs_view.dart';
import '../../CommonSearch/views/common_search_view.dart';
import '../../FillerMaster/model/filler_annotation_model.dart';
import '../../RoCancellation/bindings/ro_cancellation_doc.dart';
import '../model/promo_master_on_load_model.dart';
import '../model/promo_master_retrive_model.dart';

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

  var rightDataTable = <LstAnnotationLoadDatas>[].obs;
  String promoCode = "",
      strHouseID = "",
      strSegmentNumber = "",
      commercialCode = "";
  PromoMasterOnloadModel? onloadModel;
  var channelList = <DropDownValue>[].obs;
  var txCaptionPreFix = "".obs;
  var segHash = 1.obs;
  int rightTableSelectedIdx = -1;
  List<RoCancellationDocuments> documents = [];
  double componentWidthRatio = .17;
  PlutoGridStateManager? stateManager;

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
      somFN = FocusNode(),
      categoryFN = FocusNode(),
      eomFN = FocusNode(),
      fillerNameFN = FocusNode(),
      captionFN = FocusNode(),
      segNoFN = FocusNode(),
      companyFN = FocusNode(),
      tapeIDFN = FocusNode(),
      txNoFN = FocusNode(),
      blanktapeIdFN = FocusNode(),
      rightTableFN = FocusNode();

  @override
  void onInit() {
    selectedDropDowns = List.generate(12, (index) => null);
    formPermissions =
        Utils.fetchPermissions1(Routes.PROMO_MASTER.replaceAll("/", ""));
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    initailAPICall();
    addListeners2();
  }

  UserDataSettings? userDataSettings;

  fetchUserSetting1() async {
    userDataSettings = await Get.find<HomeController>().fetchUserSetting2();
    rightDataTable.refresh();
  }

  addListeners2() {
    // rightTableFN.onKey = (focus, event) {
    //   if (event.isKeyPressed(LogicalKeyboardKey.delete)) {
    //     if (rightTableSelectedIdx != -1) {
    //       rightDataTable.removeAt(rightTableSelectedIdx);
    //       rightDataTable.refresh();
    //       return KeyEventResult.handled;
    //     }
    //   }
    //   return KeyEventResult.ignored;
    // };
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
      if (!txNoFN.hasFocus && !Get.isDialogOpen!) {
        txNoLeave();
      }
    });
    blanktapeIdFN.addListener(() {
      if (!blanktapeIdFN.hasFocus) {
        onleaveBlankTapeID();
      }
    });
    eomFN.addListener(() {
      if (!eomFN.hasFocus) {
        calculateDuration();
      }
    });
    // somFN.addListener(() {
    //   if (!somFN.hasFocus && !Get.isDialogOpen!) {
    //     calculateDuration();
    //   }
    // });
  }

  validateAndSaveRecord() {
    if (captionCtr.text.isEmpty) {
      LoadingDialog.showErrorDialog("Please enter caption.");
    } else if (selectedDropDowns[0] == null) {
      LoadingDialog.showErrorDialog("Please select category.");
    } else if (txCaptionCtr.text.isEmpty) {
      LoadingDialog.showErrorDialog("Please enter Tx No.");
    } else if (selectedDropDowns[1] == null) {
      LoadingDialog.showErrorDialog("Please select company.");
    } else if (selectedDropDowns[2] == null) {
      LoadingDialog.showErrorDialog("Please select Short location.");
    } else if (selectedDropDowns[3] == null) {
      LoadingDialog.showErrorDialog("Please select Channel.");
    } else if (selectedDropDowns[4] == null) {
      LoadingDialog.showErrorDialog("Please select Promo type.");
    } else if (txNoCtr.text.isEmpty) {
      LoadingDialog.showErrorDialog("Please enter cart no.");
    } else if (selectedDropDowns[9] == null) {
      LoadingDialog.showErrorDialog("Please select Promo type.");
    } else if (selectedDropDowns[10] == null) {
      LoadingDialog.showErrorDialog("Please select tape type.");
    } else if (tapeIDCtr.text.isEmpty) {
      LoadingDialog.showErrorDialog("Please enter Tape Id.");
    } else if (durationCtr.text.isEmpty || durationCtr.text == "00:00:00:00") {
      LoadingDialog.showErrorDialog("Please enter duration.");
    } else if (somCtr.text.isEmpty) {
      LoadingDialog.showErrorDialog("Please enter SOM.");
    } else if ((Utils.oldBMSConvertToSecondsValue(value: eomCtr.text) -
            Utils.oldBMSConvertToSecondsValue(value: somCtr.text))
        .isNegative) {
      eomCtr.clear();
      LoadingDialog.showErrorDialog("EOM should not less than SOM",
          callback: () {
        eomFN.requestFocus();
      });
    } else {
      if (promoCode.isNotEmpty) {
        LoadingDialog.recordExists(
            "Record Already exist!\nDo you want to modify it?", saveRecord);
      } else {
        saveRecord();
      }
    }
  }

  saveRecord() {
    LoadingDialog.call();
    Get.find<ConnectorControl>().POSTMETHOD(
      api: ApiFactory.PROMO_MASTER_SAVE_RECORD,
      fun: (resp) {
        closeDialogIfOpen();
        if (resp != null &&
            resp is Map<String, dynamic> &&
            resp['saveRecords'] != null &&
            resp['saveRecords']['strMessage'] != null &&
            resp['saveRecords']['strMessage']
                .toString()
                .contains("successfully")) {
          LoadingDialog.callDataSaved(
              msg: resp['saveRecords']['strMessage'].toString());
        } else {
          LoadingDialog.showErrorDialog(resp.toString());
        }
      },
      json: {
        "promoCode": promoCode,
        "promoCaption": captionCtr.text,
        "promoDuration": Utils.convertToSecond(value: durationCtr.text),
        "promoTypeCode": selectedDropDowns[4]?.key,
        "promoCategoryCode": selectedDropDowns[0]?.key,
        "exportTapeCode": tapeIDCtr.text,
        "exportTapeCaption": txCaptionPreFix + txCaptionCtr.text,
        "tapeTypeCode": selectedDropDowns[10]?.key,
        "channelCode": selectedDropDowns[3]?.key,
        "programCode": selectedDropDowns[6]?.key,
        "originalRepeatCode": selectedDropDowns[8]?.key,
        "houseId": txNoCtr.text,
        "segmentNumber": segHash.value,
        "som": somCtr.text,
        "dated": "D",
        "killDate": DateFormat('yyyy-MM-dd')
            .format(DateFormat("dd-MM-yyyy").parse(endDateCtr.text)),
        "modifiedBy": Get.find<MainController>().user?.logincode,
        "startDate": DateFormat('yyyy-MM-dd')
            .format(DateFormat("dd-MM-yyyy").parse(startDateCtr.text)),
        "ptype": selectedDropDowns[5]?.key,
        "remarks": "",
        "blanktapeid": blankTapeIDCtr.text,
        "locationcode": selectedDropDowns[2]?.key,
        "billflag": num.tryParse(selectedDropDowns[9]?.key ?? "0") ?? 0,
        "companycode": selectedDropDowns[1]?.key,
        "lstAnnotation":
            rightDataTable.map((element) => element.toJson()).toList(),
      },
    );
  }

  formHandler(String btnName) {
    if (btnName == "Clear") {
      clearPage();
    } else if (btnName == "Save") {
      validateAndSaveRecord();
    } else if (btnName == "Exit") {
      Get.find<HomeController>().postUserGridSetting2(listStateManager: [
        {"stateManager": stateManager},
      ]);
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
    } else if (btnName == "Docs") {
      docs();
    }
  }

  docs() async {
    String documentKey = "";
    if (promoCode.isEmpty) {
      documentKey = "";
    } else {
      documentKey = "Promomaster$promoCode";
    }

    Get.defaultDialog(
      title: "Documents",
      content: CommonDocsView(documentKey: documentKey),
    ).then((value) {
      Get.delete<CommonDocsController>(tag: "commonDocs");
    });
  }

  clearPage() {
    stateManager = null;
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
    var diff = (Utils.oldBMSConvertToSecondsValue(value: eomCtr.text) -
        Utils.oldBMSConvertToSecondsValue(value: somCtr.text));

    if (diff.isNegative && showDialog) {
      eomCtr.clear();
      LoadingDialog.showErrorDialog("EOM should not less than SOM",
          callback: () {
        eomFN.requestFocus();
      });
    } else {
      durationCtr.text = Utils.convertToTimeFromDouble(value: diff);
    }
  }

  updateUI() {
    update(['rootUI']);
  }

  captionLeave() async {
    if (captionCtr.text.trim().isNotEmpty && !(Get.isDialogOpen ?? false)) {
      txCaptionCtr.text = captionCtr.text.trim();
      await retrieveRecord(captionCtr.text, '', '', segHash.value, "");
      categoryFN.requestFocus();
    }
  }

  tapeIdLeave() async {
    if (tapeIDCtr.text.trim().isNotEmpty && segHash.value != 0) {
      await retrieveRecord("", "", tapeIDCtr.text, segHash.value, "");
      if (promoCode.isEmpty) {
        txNoCtr.text = tapeIDCtr.text;
      }
    }
  }

  onleaveBlankTapeID() {
    if (blankTapeIDCtr.text.trim().isNotEmpty) {
      LoadingDialog.call();
      Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.PROMO_MASTER_BLANK_TAPE_ID_LEAVE(
            blankTapeIDCtr.text.trim()),
        fun: (resp) {
          Get.back();
          if (resp != null &&
              resp is Map<String, dynamic> &&
              resp['resLeaveBlankTapeId'] != null &&
              resp['resLeaveBlankTapeId']['message'] != null &&
              resp['resLeaveBlankTapeId']['message'].toString() ==
                  "Invalid blank tape id.") {
            LoadingDialog.showErrorDialog(
                resp['resLeaveBlankTapeId']['message'].toString(),
                callback: () {
              blanktapeIdFN.requestFocus();
            });
          }
        },
      );
    }
  }

  txNoLeave() async {
    if (txNoCtr.text.isNotEmpty) {
      LoadingDialog.call();
      await Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.PROMO_MASTER_TX_NO_LEAVE,
        fun: (resp) {
          Get.back();
          if (resp != null &&
              resp is Map<String, dynamic> &&
              resp['cartNo_Leave'] != null &&
              resp['cartNo_Leave']['eventName'] != null &&
              resp['cartNo_Leave']['eventName']
                  .toString()
                  .contains("House ID you entered is already used for")) {
            // if (promoCode.isNotEmpty) {
            //   txNoCtr.text = strHouseID;
            // }
            LoadingDialog.showErrorDialog(
                resp['cartNo_Leave']['eventName'].toString(), callback: () {
              txNoFN.requestFocus();
            });
          } else {
            companyFN.requestFocus();
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

    if (txNoCtr.text.trim().isNotEmpty &&
        segHash.value != 0 &&
        !Get.isDialogOpen!) {
      retrieveRecord("", "", "", 0, txNoCtr.text.trim());
    }
  }

  Future<void> retrieveRecord(String text, String code, String exporttapecode,
      int segno, String houseID) async {
    LoadingDialog.call();
    await Get.find<ConnectorControl>().POSTMETHOD(
      api: ApiFactory.PROMO_MASTER_RETRIVE_RECORDS,
      fun: (resp) {
        closeDialogIfOpen();
        PromoMasterRetriveModel retriveM =
            PromoMasterRetriveModel.fromJson(resp);
        if (retriveM.retrieveRecord != null &&
            (retriveM.retrieveRecord?.isNotEmpty ?? false)) {
          RetrieveRecord record = retriveM.retrieveRecord![0];

          /// promo code
          if (record.promoCode != null) {
            promoCode = record.promoCode ?? "";
          }

          /// caption
          if (record.promoCaption != null) {
            captionCtr.text = record.promoCaption ?? "";
          }

          /// duration
          if (record.promoDuration != null) {
            durationCtr.text =
                Utils.convertToTimeFromDouble(value: record.promoDuration ?? 0);
          }

          /// promo-type
          if (record.promoTypeCode != null) {
            onloadModel?.promoMasterOnLoad?.lstPromoType = record.lstPromoType;
            var tempPromoType = onloadModel?.promoMasterOnLoad?.lstPromoType
                ?.firstWhereOrNull(
                    (element) => element.key == record.promoTypeCode);
            if (tempPromoType != null) {
              selectedDropDowns[4] = tempPromoType;
              update(['promoTypeUI']);
            }
          }

          /// category
          if (record.promoCategoryCode != null &&
              record.promoCategoryName != null) {
            handleOnChangedCategory(
              DropDownValue(
                key: record.promoCategoryCode,
                value: record.promoCategoryName,
              ),
              callAPI: false,
            );
          }

          /// tape-id
          if (record.exportTapeCode != null) {
            tapeIDCtr.text = record.exportTapeCode ?? "";
          }

          /// tx-caption
          if (record.promoCaption != null) {
            txCaptionCtr.text = record.promoCaption ?? "";
          }

          /// tape-type
          if (record.tapeTypeCode != null) {
            var tempTapetype = onloadModel?.promoMasterOnLoad?.lstTapeType
                ?.firstWhereOrNull(
                    (element) => element.key == record.tapeTypeCode);
            if (tempTapetype != null) {
              selectedDropDowns[10] = tempTapetype;
            }
          }

          /// location
          if (record.locationcode != null) {
            var tempLoaction = onloadModel?.promoMasterOnLoad?.lstLocation
                ?.firstWhereOrNull(
                    (element) => element.key == record.locationcode);
            if (tempLoaction != null) {
              selectedDropDowns[2] = tempLoaction;
            }
          }

          /// CHANNELS
          var tempChannel = channelList
              .firstWhereOrNull((element) => element.key == record.channelCode);
          if (tempChannel != null) {
            selectedDropDowns[3] = tempChannel;
          } else if (selectedDropDowns[0] != null) {
            locationOnChanged(selectedDropDowns[2]).then((value) {
              var tempChannel2 = channelList.firstWhereOrNull(
                  (element) => element.key == record.channelCode);
              if (tempChannel2 != null) {
                selectedDropDowns[3] = tempChannel2;
              }
            });
          }

          /// program
          if (record.programCode != null && record.programName != null) {
            selectedDropDowns[6] = DropDownValue(
              key: record.programCode,
              value: record.programName,
            );
          }

          /// org/repeat
          if (record.originalRepeatCode != null) {
            var temporiginalRepeatCode = onloadModel
                ?.promoMasterOnLoad?.lstOriginalRepeat
                ?.firstWhereOrNull(
                    (element) => element.key == record.originalRepeatCode);
            if (temporiginalRepeatCode != null) {
              selectedDropDowns[8] = temporiginalRepeatCode;
            }
          }

          /// tx-no
          if (record.houseId != null) {
            txNoCtr.text = record.houseId ?? "";
            strHouseID = (record.houseId ?? "");
          }

          /// segNo
          if (record.segmentNumber != null) {
            segHash.value = record.segmentNumber ?? 0;
            strSegmentNumber = (record.segmentNumber ?? 0).toString();
          }

          /// som
          if (record.som != null) {
            somCtr.text = record.som ?? "00:00:00:00";
          }

          /// eom
          if (record.eom != null) {
            eomCtr.text = record.eom ?? "00:00:00:00";
          }

          /// start-date
          if (record.startDate != null) {
            startDateCtr.text = DateFormat("dd-MM-yyyy").format(
                DateFormat("yyyy-MM-ddThh:mm:ss").parse(record.startDate!));
          }

          /// blan tape id
          if (record.blanktapeid != null) {
            blankTapeIDCtr.text = record.blanktapeid!;
          }

          /// billing
          if (record.billflag != null) {
            var tempBilling = onloadModel?.promoMasterOnLoad?.lstBilling
                ?.firstWhereOrNull(
                    (element) => element.key == record.billflag.toString());
            if (tempBilling != null) {
              selectedDropDowns[9] = tempBilling;
            }
          }

          /// company
          if (record.companycode != null && record.companyName != null) {
            selectedDropDowns[1] = DropDownValue(
              key: record.companycode,
              value: record.companyName,
            );
          }

          /// empty title dropdown
          if (record.ptype != null) {
            var tempPtype = onloadModel?.promoMasterOnLoad?.lstptype
                ?.firstWhereOrNull((element) => element.key == record.ptype);
            if (tempPtype != null) {
              selectedDropDowns[5] = tempPtype;
            }
          }

          /// end-date
          if (record.killDate != null) {
            endDateCtr.text = DateFormat("dd-MM-yyyy").format(
                DateFormat("yyyy-MM-ddThh:mm:ss").parse(record.killDate!));
          }

          /// right-table-data
          if (record.lstAnnotationLoadDatas != null) {
            rightDataTable.clear();
            rightDataTable.addAll(record.lstAnnotationLoadDatas ?? []);
          }

          updateUI();
        }
      },
      json: {
        "promoCode": promoCode,
        "promoCaption": captionCtr.text,
        "exportTapeCode": exporttapecode,
        "segmentNumber": segno,
        "houseid": houseID,
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
          if (resp != null &&
              resp is Map<String, dynamic> &&
              resp["onLeaveLocation"] != null) {
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

  void handleAddTapFromAnnotations() {
    if (selectedDropDowns[11] == null) {
      LoadingDialog.showErrorDialog("Please select Event");
      return;
    }
    rightDataTable.add(LstAnnotationLoadDatas(
      eventId: int.tryParse(selectedDropDowns[11]?.key ?? "0") ?? 0,
      eventname: selectedDropDowns[11]?.value,
      tCin: tcInCtr.text,
      tCout: tcOutCtr.text,
    ));
    tcInCtr.text = "00:00:00:00";
    tcOutCtr.text = "00:00:00:00";
  }

  Future<void> handleCopyTap() async {
    await retrieveRecord(
        "", "", copyCtr.text, (int.tryParse(segNoCtr.text) ?? 0), "");
    tapeIDCtr.text = "AUTO";
    txNoCtr.text = "AUTO";
    segHash.value = 1;
    segNoCtr.text = 1.toString();
    var now = DateTime.now();
    captionCtr.text =
        "${captionCtr.text}-${DateFormat("yyyyMMdd").format(now)}";
    txCaptionCtr.text =
        "${txCaptionCtr.text}-${DateFormat("yyyyMMdd").format(now)}";
    startDateCtr.text = "${now.day}-${now.month}-${now.year}";
    now = now.copyWith(month: now.month + 1);
    endDateCtr.text = "${now.day}-${now.month}-${now.year}";
    promoCode = "";
  }

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

  void handleOnChangedCategory(DropDownValue? val, {bool callAPI = false}) {
    selectedDropDowns[0] = val;
    if (callAPI) {
      selectedDropDowns[4] = null;
      Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.PROMO_MASTER_GET_PROMO_TYPE(val?.key ?? ""),
        fun: (resp) {
          if (resp != null && resp['promoType'] != null) {
            onloadModel?.promoMasterOnLoad?.lstPromoType = [];
            for (var element in resp['promoType']) {
              onloadModel?.promoMasterOnLoad?.lstPromoType?.add(
                DropDownValue(
                  key: element['code'].toString(),
                  value: element['name'].toString(),
                ),
              );
            }
            update(['promoTypeUI']);
          }
        },
      );
    }
    if (val != null && val.value != null && val.value!.length >= 2) {
      txCaptionPreFix.value = "${val.value!.substring(0, 2)}/".toUpperCase();
    }
  }

  void handleProgramPickerTap() {
    List<dynamic> tempList = [];
    if (selectedDropDowns[2] == null || selectedDropDowns[3] == null) {
      LoadingDialog.showErrorDialog("Please select Location, Channel");
      return;
    }
    Future<bool> getData() async {
      await Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.PROMO_MASTER_GET_PROGRAM_PICKER,
        fun: (resp) {
          if (resp != null &&
              resp is Map<String, dynamic> &&
              resp['programPicker'] != null) {
            tempList = resp['programPicker'];
          }
        },
        json: {
          "locationcode": selectedDropDowns[2]?.key,
          "channelcode": selectedDropDowns[3]?.key,
        },
      );
      return true;
    }

    Get.defaultDialog(
      title: "Program Picker",
      content: SizedBox(
        width: Get.width * .5,
        height: Get.height * .5,
        child: FutureBuilder(
          initialData: false,
          future: getData(),
          builder: (_, sn) {
            return Visibility(
              visible: sn.data!,
              replacement: const Center(
                child: CircularProgressIndicator(),
              ),
              child: Visibility(
                visible: tempList.isNotEmpty,
                replacement: const Center(
                  child: Text("No Data found"),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: DataGridFromMap(
                    mapData: tempList,
                    hideCode: false,
                    mode: PlutoGridMode.selectWithOneTap,
                    onRowDoubleTap: (row) {
                      selectedDropDowns[6] = DropDownValue(
                        key: tempList[row.rowIdx]['programCode'].toString(),
                        value: tempList[row.rowIdx]['programName'].toString(),
                      );
                      Get.back();
                      updateUI();
                      print(tempList[row.rowIdx]);
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

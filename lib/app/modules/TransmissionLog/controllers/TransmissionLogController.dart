import 'dart:async';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:bms_scheduling/app/controller/HomeController.dart';
import 'package:bms_scheduling/app/providers/ExportData.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';
import 'package:intl/intl.dart';
import '../../../../widgets/Snack.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../data/DropDownValue.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/Utils.dart';
import '../../CommonSearch/views/common_search_view.dart';
import '../CheckPromoTagModel.dart';
import '../ColorDataModel.dart';
import '../CommercialModel.dart';
import '../ExportFpcTimeModel.dart';
import '../InsertSearchModel.dart';
import '../TransmissionLogModel.dart';
import '../VerifyListModel.dart';

class TransmissionLogController extends GetxController {
  var locations = RxList<DropDownValue>();
  var channels = RxList<DropDownValue>([]);
  RxBool isEnable = RxBool(true);
  RxBool isFetch = RxBool(false);
  RxBool isAutoClick = RxBool(false);
  List<Map<String, List<PlutoRow>>> logDeletedEvent1 = [];
  List<PlutoRow>? listFilterVerify = [];
  List<PlutoRow>? listFilterAa = [];
  List<dynamic>? listVerification = [];
  String? selectAa;
  RxBool visibleChangeOffset = RxBool(true);
  RxBool visibleChangeDuration = RxBool(true);
  RxBool visibleChangeFpc = RxBool(true);
  RxInt tsPromoCap = RxInt(0);
  RxInt tsCommercialCap = RxInt(0);
  FocusNode epNoSegment_focus = FocusNode();
  FocusNode startTime_focus = FocusNode();

  //input controllers
  DropDownValue? selectLocation;
  DropDownValue? selectTapeSegmentDialog;
  DropDownValue? selectLocationCopyLog;
  DropDownValue? selectChannel;
  DropDownValue? selectChannelCopyLog;
  DropDownValue? selectEvent;
  DropDownValue? selectTimeForCommercial;
  DropDownValue? selectExportFpcFrom;
  DropDownValue? selectExportFpcTo;

  PlutoGridStateManager? gridStateManager;
  PlutoGridStateManager? gridStateManagerCommercial;
  PlutoGridStateManager? dgvCommercialsStateManager;
  PlutoGridStateManager? dgvTimeStateManager;
  PlutoGridStateManager? tblFastInsert;
  PlutoGridStateManager? tblSegement;
  InsertSearchModel? inserSearchModel;

  // TsModel? tsModel;
  List<dynamic>? tsListData;
  List<dynamic>? segmentList;

  bool blnMultipleGLs = false;

  // PlutoGridMode selectedPlutoGridMode = PlutoGridMode.normal;
  var isStandby = RxBool(false);
  var isMy = RxBool(true);
  var isAllByChange = RxBool(false);
  var isPartialLog = RxBool(false);
  var isInsertAfter = RxBool(false);
  var isAllDayReplace = RxBool(true);
  var isRowFilter = RxBool(false);
  TextEditingController selectedDate = TextEditingController();
  TextEditingController startTime_ = TextEditingController();
  TextEditingController offsetTime_ = TextEditingController();
  TextEditingController txtDtChange = TextEditingController();
  TextEditingController txtTransmissionTime = TextEditingController();
  TextEditingController txId_ = TextEditingController();
  TextEditingController txReplaceTxId_ = TextEditingController();
  TextEditingController txReplaceSegment_ = TextEditingController();
  TextEditingController txReplaceEvent_ = TextEditingController();
  TextEditingController txCaption_ = TextEditingController();
  TextEditingController insertDuration_ = TextEditingController();
  TextEditingController replaceDuration = TextEditingController();
  TextEditingController fromReplaceInsert_ = TextEditingController();
  TextEditingController toReplaceInsert_ = TextEditingController();
  TextEditingController fromReplaceIndexInsert_ = TextEditingController();
  TextEditingController toReplaceIndexInsert_ = TextEditingController();
  TextEditingController segmentFpcTime_ = TextEditingController();
  TextEditingController verifyMinTime = TextEditingController();
  TextEditingController txId_Change = TextEditingController();
  TextEditingController txtDate_Reschedule = TextEditingController();
  TextEditingController duration_change = TextEditingController()
    ..text = "00:00:00:00";
  TextEditingController offset_change = TextEditingController()
    ..text = "00:00:00:00";
  TextEditingController fpctime_change = TextEditingController()
    ..text = "00:00:00:00";
  TextEditingController segment_change =
      TextEditingController(); //txtChangeSegment
  TextEditingController txtSegment_fpctime = TextEditingController();
  TextEditingController txtSegment_epNo = TextEditingController();
  DropDownValue? selectProgramSegment;
  RxList<DropDownValue>? listTapeDetailsSegment = RxList([]);

  TransmissionLogModel? transmissionLog;
  PlutoGridMode selectedPlutoGridMode = PlutoGridMode.normal;
  int? selectedIndex;
  RxnString verifyType = RxnString();
  RxList<DropDownValue> listLocation = RxList([]);
  RxList<DropDownValue> listChannel = RxList([]);
  RxList<ColorDataModel> listColor = RxList([]);
  RxList<DropDownValue> listEventsinInsert = RxList([]);
  RxNum maxProgramStarttimeDiff = RxNum(0);
  VerifyListModel? verifyListModel;

  // bool chkTxCommercial = false;
  var chkTxCommercial = RxBool(false);
  bool logSaved = false;

  // PlutoRow? cutRow;
  PlutoRow? copyRow;
  String? lastSelectOption;
  CommercialModel? commercailModel;

  List<int> intCurrentRowIndex = List<int>.filled(4, 0);

  RxnString selectExportType = RxnString("Excel");

  ExportFPCTimeModel? exportFPCTime;
  RxString lastSavedLoggedUser = RxString("");
  bool isBackDated = false;

  @override
  void onInit() {
    super.onInit();
    getLocations();
    startTime_focus.addListener(() {
      if (!startTime_focus.hasFocus) {
        if (gridStateManager != null) {
          gridStateManager?.setCurrentCell(gridStateManager?.firstCell, 0);
          gridStateManager?.setKeepFocus(true);
        }
        colorGrid(false);
      }
    });
  }

  pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ["json"],
      dialogTitle: "Select import file",
      type: FileType.custom,
    );
    print("Called>>>");
    LoadingDialog.call();
    if (result != null && result.files.single != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      String fileContent = String.fromCharCodes(fileBytes!);
      // print(fileContent);
      Map<String, dynamic> mapData = jsonDecode(fileContent);
      transmissionLog = TransmissionLogModel.fromJson(mapData);
      if (transmissionLog != null &&
          transmissionLog?.loadSavedLogOutput != null &&
          transmissionLog?.loadSavedLogOutput?.lstTransmissionLog != null &&
          ((transmissionLog?.loadSavedLogOutput?.lstTransmissionLog?.length ??
                  0) !=
              0)) {
        startTime_.text = transmissionLog
                ?.loadSavedLogOutput?.lstTransmissionLog![0].transmissionTime ??
            "";
        isEnable.value = false;
        isFetch.value = true;
        update(["transmissionList"]);
        colorGrid(true);
        Get.back();
      } else {
        Get.back();
        LoadingDialog.callInfoMessage("No Data Found");
      }
    } else {
      Get.back();
    }
  }

  getLocations() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.TRANSMISSION_LOG_LOCATION(),
        fun: (Map map) {
          locations.clear();
          map["location"].forEach((e) {
            locations.add(DropDownValue.fromJson1(e));
          });
        });
  }

  getChannels(String key) {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.TRANSMISSION_LOG_CHANNEL(
          key,
        ),
        fun: (Map map) {
          channels.clear();
          map["locationSelect"].forEach((e) {
            channels.add(
                DropDownValue.fromJsonDynamic(e, "channelCode", "channelName"));
          });
        });
  }

  getBtnVerifyClick({Function? fun}) {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.TRANSMISSION_LOG_BUTTON_VERIFY(
            selectLocation?.key ?? "",
            selectChannel?.key ?? "",
            selectedDate.text,
            isStandby.value),
        fun: (map) {
          // print("jsonData"+map.toString());
          if (map is Map &&
              map.containsKey("lstCheckTimeBetweenCommercials") &&
              (map["lstCheckTimeBetweenCommercials"].length > 0)) {
            verifyListModel = VerifyListModel.fromJson(map);
            if (fun != null) {
              fun();
              update(['commercialsList']);
            }
          } else {
            Snack.callError(map.toString());
          }

          /* channels.clear();
          map["locationSelect"].forEach((e) {
            channels.add(
                DropDownValue.fromJsonDynamic(e, "channelCode", "channelName"));
          });*/
        });
  }

  getBtnVerifyDetailsClick({Function? fun}) {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.TRANSMISSION_LOG_BUTTON_DETAILS_VERIFY(
            selectLocation?.key ?? "",
            selectChannel?.key ?? "",
            selectedDate.text),
        fun: (map) {
          // print("jsonData"+map.toString());
          if (map is Map &&
              map.containsKey("lstVerifyInDetails") &&
              (map["lstVerifyInDetails"].length > 0)) {
            verifyListModel = VerifyListModel.fromJson(map);
            update(['verifyList']);
          } else {
            Snack.callError(map.toString());
          }
        });
  }

  void postPivotLog({Function? fun}) {
    LoadingDialog.call();
    var postMap = {
      /*"optBrand": selectAa=="client",
      "optTape": selectAa=="productName",
      "optProduct": selectAa=="productName",*/

      "optBrand": verifyType.value == "Brand",
      "optTape": verifyType.value == "Tape",
      "optProduct": verifyType.value == "Product",
      "lstTblPivotLog": gridStateManager?.rows
          .map((e) => e.toJson1(stringConverterKeys: ["datechange"]))
          .toList(),
    };
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.TRANSMISSION_LOG_POST_PIVOT_LOG(),
        json: postMap,
        fun: (map) {
          Get.back();
          // print("jsonData"+map.toString());
          if (map is Map &&
              map.containsKey("pivotLog") &&
              (map["pivotLog"][selectAa].length > 0)) {
            listVerification = map["pivotLog"][selectAa];
            update(['aAList']);
          } else {
            Snack.callError(map.toString());
          }
        });
  }

  void postTransmissionLog({Function? fun}) {
    LoadingDialog.call();
    var postMap = {
      "locationcode": selectLocation?.key ?? '',
      "channelcode": selectChannel?.key ?? '',
      "txtDate": selectedDate.text,
      "chkstandbyLog": isStandby.value,
      "lstTrassmissionLog": gridStateManager?.rows
          .map((e) => e.toTransmissionLogJson(intConverterKeys: [
                "rownumber",
                "breakNumber",
                "episodeNumber",
                "bookingdetailcode",
                "datechange"
              ]))
          .toList(),
    };
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.TRANSMISSION_LOG_POST_SAVE_LOG(),
        json: postMap,
        fun: (map) {
          Get.back();
          logSaved = true;
          LoadingDialog.callInfoMessage("Log Saved");
          // showMessageBox("Log Saved", MessageBoxType.information);
        });
  }

  void getBtnClick_TS({Function? fun}) {
    LoadingDialog.call();
    var postMap = {
      "locationCode": selectLocation?.key ?? "",
      "channelCode": selectChannel?.key ?? "",
      "txtDate": selectedDate.text,
      "lstInputTblTs": gridStateManager?.rows
          .map((e) => e.toJson1(stringConverterKeys: ["datechange"]))
          .toList(),
    };
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.TRANSMISSION_LOG_POST_TS(),
        json: postMap,
        fun: (map) {
          Get.back();
          // print("jsonData"+map.toString());
          if (map is Map &&
              map.containsKey("restscalc") &&
              map["restscalc"].containsKey("lstOutPutTblTs") &&
              map["restscalc"]["lstOutPutTblTs"] != null &&
              map["restscalc"]["lstOutPutTblTs"].length > 0) {
            // tsModel = TsModel.fromJson(map as Map<String, dynamic>);
            tsListData = map["restscalc"]["lstOutPutTblTs"];
            getInitTsCall();
            if (fun != null) {
              fun();
            }
            // update(['tsList']);
          } else {
            Snack.callError(map.toString());
          }
        });
  }

  void btnExportFetchFpc({Function? fun}) {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.TRANSMISSION_LOG_EXPORT_FPC_TIME(
            selectLocation?.key ?? '',
            selectChannel?.key ?? '',
            selectedDate.text,
            isStandby.value),
        fun: (map) {
          Get.back();
          // print("jsonData"+map.toString());
          if (map is Map && map.containsKey("resFPCTime")) {
            exportFPCTime =
                ExportFPCTimeModel.fromJson(map as Map<String, dynamic>);
            if (fun != null) {
              fun();
            }
          } else {
            Snack.callError(map.toString());
          }
        });
  }

  void btnRescheduleSpots({Function? fun}) {
    if (DateFormat("dd-MM-yyyy")
        .parse(selectedDate.text)
        .isAfter(DateFormat("dd-MM-yyyy").parse(txtDate_Reschedule.text))) {
      LoadingDialog.callInfoMessage(
          "Resceduling date should not be less than ");
      return;
    }
    LoadingDialog.call();
    var postMap = {
      "locationcode": selectLocation?.key ?? "",
      "channelcode": selectChannel?.key ?? "",
      "txtDate": selectedDate.text,
      "RescheduleToDate": txtDate_Reschedule.text,
      "lstBookingDetails": [
        {
          "bookingNumber":
              gridStateManager?.currentRow?.cells["bookingNumber"]?.value,
          "bookingDetailCode":
              gridStateManager?.currentRow?.cells["bookingdetailcode"]?.value
        }
      ]
    };
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.TRANSMISSION_LOG_POST_RESCHEDULE(),
        json: postMap,
        fun: (map) {
          Get.back();
          print("Data is>>>>" + map.toString());
          LoadingDialog.callInfoMessage(map.toString());
          // print("jsonData"+map.toString());
          /* if (map is Map &&
              map.containsKey("restscalc") &&
              map["restscalc"].containsKey("lstOutPutTblTs") &&
              map["restscalc"]["lstOutPutTblTs"] != null &&
              map["restscalc"]["lstOutPutTblTs"].length > 0) {
            // tsModel = TsModel.fromJson(map as Map<String, dynamic>);
            tsListData = map["restscalc"]["lstOutPutTblTs"];
            getInitTsCall();
            // update(['tsList']);
          } else {
            Snack.callError(map.toString());
          }*/
        });
  }

  void getBtnClick_LastSavedLog({Function? fun}) {
    // LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.TRANSMISSION_LOG_LAST_SAVEDLOG(
            selectLocation?.key ?? "",
            selectChannel?.key ?? "",
            selectedDate.text),
        fun: (map) {
          // Get.back();
          // print("jsonData"+map.toString());
          if (map is Map &&
              map.containsKey("lstTraicomplaince") &&
              map["lstTraicomplaince"] != null &&
              map["lstTraicomplaince"].length > 0) {
            // tsModel = TsModel.fromJson(map as Map<String, dynamic>);
            /*TsModel tsmodel1 = TsModel();
            Restscalc restscalc =
                Restscalc.fromJson(map as Map<String, dynamic>);
            tsmodel1.restscalc = restscalc;
            tsModel = tsmodel1;*/
            tsListData = map["lstTraicomplaince"];
            // update(['tsList']);
            getInitTsCall();
          } else {
            Snack.callError(map.toString());
          }
        });
  }

  void getEpisodeLeaveSegment({Function? fun}) {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.TRANSMISSION_LOG_PROF_LEAVE(
          selectProgramSegment?.key ?? "",
          txtSegment_epNo.text,
        ),
        fun: (map) {
          Get.back();
          listTapeDetailsSegment?.value.clear();
          if (map is Map &&
              map.containsKey("lstexporttapecode") &&
              map["lstexporttapecode"] != null) {
            map["lstexporttapecode"].forEach((e) {
              listTapeDetailsSegment?.add(DropDownValue(
                  key: e["exporttapecode"], value: e["exporttapecode1"]));
            });
          } else {
            Snack.callError(map.toString());
          }
        });
  }

  void btnSearchSegment({Function? fun}) {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.TRANSMISSION_LOG_SEARCH_SEGMENT(
            selectProgramSegment?.key ?? "",
            txtSegment_epNo.text,
            selectTapeSegmentDialog?.key ?? "",
            false),
        fun: (map) {
          Get.back();
          segmentList?.clear();
          if (map is Map &&
              map.containsKey("lstProgramSegments") &&
              map["lstProgramSegments"] != null) {
            segmentList = map["lstProgramSegments"];
            update(["segmentList"]);
          } else {
            Snack.callError(map.toString());
          }
        });
  }

  void getInitTsCall({Function? fun}) {
    // LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.TRANSMISSION_LOG_TS_GET_HIGHLIGHT(
          selectLocation?.key ?? "",
          selectChannel?.key ?? "",
        ),
        fun: (map) {
          if (map is Map &&
              map.containsKey("resHighlightTSGrid") &&
              map["resHighlightTSGrid"] != null) {
            tsPromoCap.value = map["resHighlightTSGrid"]["intPromoCap"];
            tsCommercialCap.value =
                map["resHighlightTSGrid"]["intCommercialCap"];
            update(['tsList']);
          } else {
            Snack.callError(map.toString());
          }
        });
  }

  getBtnInsertSearchClick(
      {Function? fun,
      required bool isMine,
      required String eventType,
      required String txId,
      required String txCaption}) {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.TRANSMISSION_LOG_SEARCH_INSERT(
            selectLocation?.key ?? "",
            selectChannel?.key ?? "",
            // Utils.dateFormatChange(selectedDate.text, "dd-MM-yyyy", "M/d/yyyy"),
            selectedDate.text,
            isMine,
            eventType,
            txId,
            txCaption),
        fun: (map) {
          Get.back();
          if (map.containsKey("lstListMyEventClips") &&
              map["lstListMyEventClips"] != null &&
              map["lstListMyEventClips"].containsKey("lstListMyEventClips") &&
              map["lstListMyEventClips"]["lstListMyEventClips"] != null) {
            inserSearchModel = InsertSearchModel.fromJson(map);
            insertDuration_.text = Utils.convertToTimeFromDouble(
                value:
                    inserSearchModel?.lstListMyEventData?.totalDuration ?? 0);
            update(["insertList"]);
          } else {
            LoadingDialog.showErrorDialog("No data found");
          }
        });
  }

  void btnInsProg_Addsegments_Click() {
    // Get.back();
    int insrow = gridStateManager?.currentRowIdx ?? 0;
    int rowCount = tblSegement?.rows.length ?? 0;
    List<PlutoRow> listAdd = [];
    gridStateManager?.setShowLoading(true);
    for (int i = rowCount - 1; i >= 0; i--) {
      var dr = tblSegement?.rows[i];
      listAdd.add(insertPlutoRow(
        segmentFpcTime_.text.substring(0, 8),
        i == 0 ? "P " : "S ",
        dr?.cells["exporttapeCaption"]?.value.toString() ?? "",
        dr?.cells["exportTapeCode"]?.value.toString() ?? "",
        Utils.convertToTimeFromDouble(
            value: num.tryParse(
                    dr?.cells["seGMENTdURATION"]?.value.toString() ?? "") ??
                0),
        dr?.cells["som"]?.value.toString() ?? "",
        BreakNumber:
            int.tryParse(dr?.cells["breakNumber"]?.value.toString() ?? "0") ??
                0,
        EpisodeNumber:
            int.tryParse(dr?.cells["episodeNumber"]?.value.toString() ?? "0") ??
                0,
      ));
    }
    addEventToUndo();
    gridStateManager?.insertRows(insrow, listAdd.reversed.toList());
    gridStateManager?.notifyListeners();
    // gridStateManager?.appendRows(listAdd);
    colorGrid(false);
    gridStateManager?.setShowLoading(false);

    gridStateManager?.moveScrollByRow(PlutoMoveDirection.down, insrow);
    // gridStateManager.firstDisplayedScrollingRowIndex = insrow;
  }

  void tblCommercials_CellDoubleClick(rowIndex) {
    int insrow = gridStateManager?.currentRowIdx ?? 0;
    addEventToUndo();
    PlutoRow? row = gridStateManagerCommercial?.rows[rowIndex];
    PlutoRow? insertRowDta = insertCommercial(
        row?.cells["tonumber"]?.value,
        row?.cells["bookingdetailcode"]?.value?.toString() ?? "",
        // row?.cells["Scheduletime"]?.value,
        row?.cells["scheduletime"]?.value,
        row?.cells["productname"]?.value,
        (row?.cells["rOsTime"]?.value == null)
            ? ""
            : row?.cells["rOsTime"]?.value,
        row?.cells["exportTapeCaption"]?.value,
        row?.cells["exporttapecode"]?.value,
        Utils.convertToTimeFromDouble(
            value:
                num.tryParse(row?.cells["duration"]?.value.toString() ?? "0") ??
                    0),
        row?.cells["som"]?.value);
    gridStateManager?.insertRows(insrow, [insertRowDta]);
    gridStateManagerCommercial?.removeCurrentRow();
    colorGrid(false);
    // gridStateManager.firstDisplayedScrollingRowIndex = insrow;
  }

  PlutoRow insertCommercial(
      String BookingNumber,
      String BookingDetailCode,
      String ScheduleTime,
      String ProductName,
      String ROsTimeBand,
      String ExportTapeCaption,
      String Exporttapecode,
      String Tapeduration,
      String SOM) {
    return insertPlutoRow(ScheduleTime, "C ", ExportTapeCaption, Exporttapecode,
        Tapeduration, SOM,
        BreakNumber: 0,
        EpisodeNumber: 0,
        BookingNumber: BookingNumber,
        BookingDetailCode: BookingDetailCode,
        ScheduleTime: ScheduleTime,
        ProductName: ProductName,
        ROsTimeBand: ROsTimeBand);
  }

  PlutoRow insertPlutoRow(
      String FpcTime,
      String EventType,
      String ExportTapeCaption,
      String Exporttapecode,
      String Tapeduration,
      String SOM,
      {int BreakNumber = 0,
      int EpisodeNumber = 0,
      String BookingNumber = "",
      String BookingDetailCode = "",
      String ScheduleTime = "",
      String ProductName = "",
      String ROsTimeBand = ""}) {
    int intRowIndex = gridStateManager?.currentRowIdx ?? 0;
    // int insertRowId = int.tryParse(gridStateManager?.currentRowIdx?.cells["rownumber"]?.value??"0")??0;
    int insertRowId = intRowIndex;
    if (insertRowId > 0) insertRowId = insertRowId - 1;
    // PlutoRow rowData = PlutoRow(cells: dr);
    PlutoRow rowData = PlutoRow(cells: {
      "fpCtime": PlutoCell(value: FpcTime ?? ""),
      "transmissionTime": PlutoCell(value: ""),
      "exportTapeCode": PlutoCell(value: Exporttapecode ?? ""),
      "exportTapeCaption": PlutoCell(value: ExportTapeCaption ?? ""),
      "tapeduration": PlutoCell(value: Tapeduration ?? ""),
      "som": PlutoCell(value: SOM ?? ""),
      "breakNumber": PlutoCell(value: BreakNumber.toString()),
      "episodeNumber": PlutoCell(value: EpisodeNumber.toString()),
      "breakEvent": PlutoCell(value: ""),
      "rownumber": PlutoCell(value: "0"),
      "eventType": PlutoCell(value: EventType),
      "bookingNumber": PlutoCell(value: BookingNumber),
      "bookingdetailcode": PlutoCell(value: BookingDetailCode.toString()),
      "scheduleTime": PlutoCell(value: ScheduleTime ?? ""),
      "productName": PlutoCell(value: ProductName ?? ""),
      "rosTimeBand": PlutoCell(value: ROsTimeBand ?? ""),
      "client": PlutoCell(value: ""),
      "promoTypecode": PlutoCell(value: ""),
      "datechange": PlutoCell(value: 0),
      "productGroup": PlutoCell(value: ""),
      "longCaption": PlutoCell(value: ""),
      "productname_Font": PlutoCell(value: ""),
      "exporttapecode_Font": PlutoCell(value: ""),
      "rosTimeBand_Font": PlutoCell(value: ""),
      "no": PlutoCell(value: 0),
    });
    return rowData;
    // if (insertRowId == 0) insertRowId = -1;
    // gridStateManager.rows.insertAt(dr, InsertRow + 1);
    print("Row val=>>" + insertRowId.toString());
    // gridStateManager?.appendNewRows();
    gridStateManager?.insertRows(0, [rowData]);
    // gridStateManager?.insertRows(insertRowId, [dr]);
    // dt.acceptChanges();
    colorGrid(false);
    // UnSelectAllRows(gridStateManager);
    // gridStateManager.firstDisplayedScrollingRowIndex = intCurrentRowIndex[3];
    // gridStateManager.rows[intRowIndex].selected = true;
    // gridStateManager.currentCell = gridStateManager.rows[intRowIndex].cells[1];
  }

  Future<void> btnReplace_Click() async {
    addEventToUndo();
    int replaceCount = 0;
    for (var dr in (tblFastInsert?.rows)!) {
      if (dr.cells["eventtype"]?.value.toString().trim().toLowerCase() !=
          txReplaceEvent_.text.toString().trim().toLowerCase()) {
        if (!["a", "w", "o", "t", "i"].contains(
            dr.cells["eventtype"]?.value.toString().trim().toLowerCase())) {
          LoadingDialog.callInfoMessage("Invalid events type");
          return;
        }
      }
    }

    int i = 0;
    int fromRow = 0;
    int toRow = 0;
    if (isAllDayReplace.value) {
      bool? isYes = await showDialogForYesNo(
          "You are replacing in all day, want to proceed?");
      isYes ??= false;
      if (isYes) {
        fromRow = 0;
        toRow = gridStateManager?.rows.length ?? 0 - 1;
      } else {
        return;
      }
    } else {
      // fromRow = txtReplaceFrom.text == "" ? 0 : int.parse(txtReplaceFrom.text);
      // toRow = txtReplaceTo.text == "" ? 0 : int.parse(txtReplaceTo.text);

      fromRow = fromReplaceIndexInsert_.text == ""
          ? 0
          : int.parse(fromReplaceIndexInsert_.text);
      toRow = toReplaceIndexInsert_.text == ""
          ? 0
          : int.parse(toReplaceIndexInsert_.text);
    }

    for (int row = fromRow; row <= toRow; row++) {
      if (gridStateManager?.rows[row].cells["exportTapeCode"]?.value ==
              txReplaceTxId_.text &&
          (gridStateManager?.rows[row].cells["eventType"]?.value
                      .toString()
                      .trim() ==
                  txReplaceEvent_.text.trim() ||
              ["a", "w", "o", "t", "i"].contains(gridStateManager
                  ?.rows[row].cells["eventType"]?.value
                  .toString()
                  .trim()
                  .toLowerCase()))) {
        replaceCount++;
        gridStateManager?.rows[row].cells["exportTapeCode"]?.value =
            tblFastInsert?.rows[i].cells["txId"]?.value;
        gridStateManager?.rows[row].cells["breakNumber"]?.value =
            tblFastInsert?.rows[i].cells["segmentNumber"]?.value;
        gridStateManager?.rows[row].cells["som"]?.value =
            tblFastInsert?.rows[i].cells["som"]?.value;
        gridStateManager?.rows[row].cells["tapeduration"]?.value =
            Utils.convertToTimeFromDouble(
                value: num.tryParse(tblFastInsert
                        ?.rows[i].cells["duration"]?.value
                        .toString() ??
                    "0")!);
        gridStateManager?.rows[row].cells["exportTapeCaption"]?.value =
            tblFastInsert?.rows[i].cells["txCaption"]?.value;
        gridStateManager?.rows[row].cells["eventType"]?.value =
            tblFastInsert?.rows[i].cells["eventtype"]?.value;

        i++;
        if (i >= (tblFastInsert?.rows.length ?? 0)) {
          i = 0;
        }
      }
    }

    colorGrid(false);
    LoadingDialog.callInfoMessage('$replaceCount replacements made');
  }

  void btnExportClick(type) async {
    bool? isDone =
        await showDialogForYesNo("Do you want to add secondary event?");
    LoadingDialog.call();
    String methodName = getExportMethod(type)!;
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.TRANSMISSION_LOG_EXPORT_CLICK(
            selectLocation?.key ?? "",
            selectChannel?.key ?? "",
            selectedDate.text,
            selectChannel?.value ?? "",
            selectLocation?.value ?? "",
            gridStateManager?.currentRowIdx ?? 0,
            "00:00",
            isDone!,
            methodName),
        fun: (map) {
          Get.back();
          if (map is Map && map.containsKey("outExportDataClick")) {
            String outputFormat = map["outExportDataClick"]["outputFormat"];
            String strFilePrefix = map["outExportDataClick"]["strFilePrefix"];
            String filechannel = map["outExportDataClick"]["filechannel"];
            logWrite(
              strFilePrefix + outputFormat.split("|")[1],
              type,
              isDone!,
            );
          } else {}
        });
  }

  void logWrite(String fileName, String type, bool isSecondary) async {
    switch (type) {
      case "Excel":
        LoadingDialog.call();
        Get.find<ConnectorControl>().GETMETHODCALL(
            api: ApiFactory.TRANSMISSION_LOG_WRITE_EXCEL(
                selectLocation?.key ?? "",
                selectChannel?.key ?? "",
                selectedDate.text,
                isStandby.value),
            fun: (map) {
              Get.back();
              ExportData().exportFilefromBase64(map, fileName);
            });
        break;
      case "Excel - Old":
        LoadingDialog.call();
        Get.find<ConnectorControl>().GETMETHODCALL(
            api: ApiFactory.TRANSMISSION_LOG_WRITE_OLDEXCEL(
                selectLocation?.key ?? "",
                selectChannel?.key ?? "",
                selectedDate.text,
                isStandby.value,
                fileName ?? "",
                ""),
            fun: (map) {
              Get.back();
              ExportData().exportFilefromBase64(map, fileName);
            });
        break;
      case "Excel - NEWS":
        LoadingDialog.call();
        Get.find<ConnectorControl>().GETMETHODCALL(
            api: ApiFactory.TRANSMISSION_LOG_WRITE_OLDEXCEL(
                selectLocation?.key ?? "",
                selectChannel?.key ?? "",
                selectedDate.text,
                isStandby.value,
                fileName ?? "",
                "NEWS"),
            fun: (map) {
              Get.back();
              ExportData().exportFilefromBase64(map, fileName);
            });
        break;
      case "VizRT":
        LoadingDialog.call();
        Get.find<ConnectorControl>().GETMETHODCALL(
            api: ApiFactory.TRANSMISSION_LOG_WRITE_VIZRT(
              selectLocation?.key ?? "",
              selectChannel?.key ?? "",
              selectedDate.text,
              isStandby.value,
            ),
            fun: (map) {
              Get.back();
              ExportData().exportFilefromBase64(map, fileName);
            });
        break;
      case "D Series":
        LoadingDialog.call();
        Get.find<ConnectorControl>().GETMETHODCALL(
            api: ApiFactory.TRANSMISSION_LOG_WRITE_DSERIES(
              selectLocation?.key ?? "",
              selectChannel?.key ?? "",
              selectedDate.text,
              isStandby.value,
              isSecondary,
              isPartialLog.value,
              selectExportFpcFrom?.value ?? "",
              selectExportFpcTo?.value ?? '',
            ),
            fun: (map) {
              Get.back();
              ExportData().exportFilefromBase64(map, fileName);
            });
        break;
      case "ADC -lst":
        LoadingDialog.call();
        Get.find<ConnectorControl>().GETMETHODCALL(
            api: ApiFactory.TRANSMISSION_LOG_WRITE_LST(
                selectLocation?.key ?? "",
                selectChannel?.key ?? "",
                selectedDate.text,
                isStandby.value,
                isPartialLog.value,
                selectExportFpcFrom?.value ?? "",
                selectExportFpcTo?.value ?? '',
                fileName),
            fun: (map) {
              Get.back();
              ExportData().exportFilefromBase64(map, fileName);
            });
        break;
      case "Grass Valley":
        LoadingDialog.call();
        Get.find<ConnectorControl>().GETMETHODCALL(
            api: ApiFactory.TRANSMISSION_LOG_WRITE_GRASS_VALLEY(
              selectLocation?.key ?? "",
              selectChannel?.key ?? "",
              selectedDate.text,
              isStandby.value,
            ),
            fun: (map) {
              Get.back();
              ExportData().exportFilefromBase64(map, fileName);
            });
        break;
      case "ADC Noida":
        LoadingDialog.call();
        Get.find<ConnectorControl>().GETMETHODCALL(
            api: ApiFactory.TRANSMISSION_LOG_WRITE_LST_NOIDA(
                selectLocation?.key ?? "",
                selectChannel?.key ?? "",
                selectedDate.text,
                isStandby.value,
                isSecondary,
                isPartialLog.value,
                selectExportFpcFrom?.value ?? "",
                selectExportFpcTo?.value ?? '',
                fileName),
            fun: (map) {
              Get.back();
              ExportData().exportFilefromBase64(map, fileName);
            });
        break;
      case "Commercial Replace":
        LoadingDialog.call();
        Get.find<ConnectorControl>().GETMETHODCALL(
            api: ApiFactory.TRANSMISSION_LOG_WRITE_COMMERCIAL_REPLACE(
              selectLocation?.key ?? "",
              selectChannel?.key ?? "",
              selectedDate.text,
              fileName,
              selectChannel?.value ?? "",
            ),
            fun: (map) {
              Get.back();
              ExportData().exportFilefromBase64(map, fileName);
            });
        break;
      case "Videocon GV":
        LoadingDialog.call();
        Get.find<ConnectorControl>().GETMETHODCALL(
            api: ApiFactory.TRANSMISSION_LOG_WRITE_VIDEOCON_GV(
              selectLocation?.key ?? "",
              selectChannel?.key ?? "",
              selectedDate.text,
              isStandby.value,
            ),
            fun: (map) {
              Get.back();
              ExportData().exportFilefromBase64(map, fileName);
            });
        break;
      case "Playbox":
        LoadingDialog.call();
        Get.find<ConnectorControl>().GETMETHODCALL(
            api: ApiFactory.TRANSMISSION_LOG_WRITE_PLAYBOX(
              selectLocation?.key ?? "",
              selectChannel?.key ?? "",
              selectedDate.text,
              isStandby.value,
            ),
            fun: (map) {
              Get.back();
              ExportData().exportFilefromBase64(map, fileName);
            });
        break;
      case "Eventz (Dubai)":
        LoadingDialog.call();
        Get.find<ConnectorControl>().GETMETHODCALL(
            api: ApiFactory.TRANSMISSION_LOG_WRITE_VZRT(
              selectLocation?.key ?? "",
              selectChannel?.key ?? "",
              selectedDate.text,
            ),
            fun: (map) {
              Get.back();
              ExportData().exportFilefromBase64(map, fileName);
            });
        break;
      case "ITX":
        LoadingDialog.call();
        Get.find<ConnectorControl>().GETMETHODCALL(
            api: ApiFactory.TRANSMISSION_LOG_WRITE_ITX(
                selectLocation?.key ?? "",
                selectChannel?.key ?? "",
                selectedDate.text,
                selectChannel?.value ?? "",
                fileName),
            fun: (map) {
              Get.back();
              ExportData().exportFilefromBase64(map, fileName);
            });
        break;
    }
  }

  String? getExportMethod(String type) {
    switch (type) {
      case "Excel":
        return "GetWriteExcel";
      case "Excel - Old":
        return "GetWriteOLDExcel";
      case "Excel - NEWS":
        return "GetWriteOLDExcel";
      case "VizRT":
        return "GetExportVizrt";
      case "D Series":
        return "GetWriteDSeriesLog";
      case "ADC -lst":
        return "GetWriteLst";
      case "Grass Valley":
        return "GetGVLog";
      case "ADC Noida":
        return "GetWriteLst";
      case "Commercial Replace":
        return "GetWriteCommercialReplacement";
      case "Videocon GV":
        return "GetWriteVideoconGV";
      case "Playbox":
        return "GetWritePlaybox";
      case "Eventz (Dubai)":
        return "GetWriteExcelevzrt";
      case "ITX":
        return "GetExportITX";
    }
  }

  void btnFastInsert_Add_Click() {
    // addEventToUndo();
    try {
      int row;
      // int eventdurat;
      blnMultipleGLs = false;
      int? noOfRows=tblFastInsert?.currentSelectingRows.length??0;
      print("Selected is>>" + (tblFastInsert?.currentSelectingRows.length.toString() ?? ""));
      if(noOfRows<=0){
        LoadingDialog.callInfoMessage("Nothing is selected");
        return;
      }
      for (var dr in (tblFastInsert?.currentSelectingRows)!) {
        String FPCTime;
        if (gridStateManager?.currentRowIdx == 0) {
          FPCTime = gridStateManager?.rows[gridStateManager?.currentRowIdx ?? 0]
              .cells["fpCtime"]?.value;
        } else {
          FPCTime = gridStateManager
              ?.rows[(gridStateManager?.currentRowIdx ?? 0) - 1]
              .cells["fpCtime"]
              ?.value;
        }

        if (dr.cells["eventtype"]?.value.toString().trim().toLowerCase() ==
            "gl") {
          FPCTime = gridStateManager?.rows[gridStateManager?.currentRowIdx ?? 0]
              .cells["fpCtime"]?.value;
        }

        if (dr.cells["eventtype"]?.value.toString().trim() == "GL") {
          if (["p", "s", "f", "gl"].contains(gridStateManager
              ?.currentRow?.cells["eventType"]?.value
              .toString()
              .trim()
              .toLowerCase())) {
            row = (gridStateManager?.currentRowIdx ?? 0) + 1;

            if ((gridStateManager?.rows.length ?? 0) > row) {
              while (gridStateManager?.rows[row].cells["eventType"]?.value
                      .toString()
                      .trim()
                      .toLowerCase() ==
                  "gl") {
                if (row < (gridStateManager?.rows.length ?? 0)) {
                  row = row + 1;
                }
              }
              gridStateManager?.setCurrentCell(
                  gridStateManager?.rows[row].cells[1], row);
            }
          } else {
            // MsgBox("Unable to add Secondary Events here!", vbExclamation, strAlertMessageTitle);
            Get.back();
            LoadingDialog.callInfoMessage(
                "Unable to add Secondary Events here!");
            return;
          }
        }

        if (isInsertAfter.value) {
          FPCTime = gridStateManager?.rows[gridStateManager?.currentRowIdx ?? 0]
              .cells["fpCtime"]?.value;
        }

        setInsertRowFastInsert(
            FPCTime,
            dr.cells["eventtype"]?.value,
            dr.cells["txCaption"]?.value,
            dr.cells["txId"]?.value,
            Utils.convertToTimeFromDouble(
                value: num.tryParse(dr.cells["duration"]?.value) ?? 0),
            dr.cells["som"]?.value,
            dr.cells["promoTypeCode"]?.value,
            dr.cells["segmentNumber"]?.value.toString() ?? "");

        // Adding Tags for promos
        // GoTo hell
        if (dr.cells["eventtype"]?.value.toString().trim().toLowerCase() ==
            "pr") {
          if ((inserSearchModel?.lstListMyEventData?.lstFastInsertTags
                      ?.where((x) => x.crTapeID == dr.cells["txId"]?.value)
                      .toList()
                      .length ??
                  0) >
              0) {
            List<LstFastInsertTags>? filterList = inserSearchModel
                ?.lstListMyEventData?.lstFastInsertTags
                ?.where((x) => x.crTapeID == dr.cells["txId"]?.value)
                .toList();
            if ((filterList?.length ?? 0) == 1) {
              row = gridStateManager?.currentRowIdx ?? 0 + 1;
              gridStateManager?.setCurrentCell(
                  gridStateManager?.rows[row].cells[0], row);
              setInsertRowFastInsert(
                  FPCTime,
                  dr.cells["eventtype"]?.value,
                  filterList![0].exportTapeCaption.toString(),
                  filterList![0].tagTapeid.toString(),
                  Utils.convertToTimeFromDouble(
                      value: num.tryParse(
                          filterList[0].promoDuration.toString() ?? "0")!),
                  filterList![0].som!,
                  filterList![0].promoTypeCode ?? "",
                  filterList![0].segmentNumber.toString());
              // UnSelectAllRows(gridStateManager ?);
              // gridStateManager?.rows[row - 1].selected = true;
              // gridStateManager?.currentCell = gridStateManager?.selectedRows[0].cells[1];
              gridStateManager?.setCurrentCell(
                  gridStateManager?.currentRow?.cells[1],
                  gridStateManager?.currentRowIdx);
            }
          }
        }

        // hell:
        // ColorGrid();
        blnMultipleGLs = true;
      }
    } catch (e) {
      print("Error found in btnFastInsert_Add_Click()" + e.toString());
      Get.back();
    }
  }

  void btnFastInsert_Add_Click1(int rowIdx) {
    // addEventToUndo();
    try {
      int row;
      // int eventdurat;
      blnMultipleGLs = false;
      print("Selected is>>" +
          (tblFastInsert?.currentSelectingRows.length.toString() ?? ""));
      // for (var dr in (tblFastInsert?.currentSelectingRows)!) {
      PlutoRow dr = (tblFastInsert?.rows[rowIdx])!;
      String FPCTime;
      if (gridStateManager?.currentRowIdx == 0) {
        FPCTime = gridStateManager?.rows[gridStateManager?.currentRowIdx ?? 0]
            .cells["fpCtime"]?.value;
      } else {
        FPCTime = gridStateManager
            ?.rows[(gridStateManager?.currentRowIdx ?? 0) - 1]
            .cells["fpCtime"]
            ?.value;
      }

      if (dr.cells["eventtype"]?.value.toString().trim().toLowerCase() ==
          "gl") {
        FPCTime = gridStateManager?.rows[gridStateManager?.currentRowIdx ?? 0]
            .cells["fpCtime"]?.value;
      }

      if (dr.cells["eventtype"]?.value.toString().trim() == "GL") {
        if (["p", "s", "f", "gl"].contains(gridStateManager
            ?.currentRow?.cells["eventType"]?.value
            .toString()
            .trim()
            .toLowerCase())) {
          row = (gridStateManager?.currentRowIdx ?? 0) + 1;

          if ((gridStateManager?.rows.length ?? 0) > row) {
            while (gridStateManager?.rows[row].cells["eventType"]?.value
                    .toString()
                    .trim()
                    .toLowerCase() ==
                "gl") {
              if (row < (gridStateManager?.rows.length ?? 0)) {
                row = row + 1;
              }
            }
            gridStateManager?.setCurrentCell(
                gridStateManager?.rows[row].cells[1], row);
          }
        } else {
          // MsgBox("Unable to add Secondary Events here!", vbExclamation, strAlertMessageTitle);
          // Get.back();
          LoadingDialog.callInfoMessage("Unable to add Secondary Events here!");
          return;
        }
      }

      if (isInsertAfter.value) {
        FPCTime = gridStateManager?.rows[gridStateManager?.currentRowIdx ?? 0]
            .cells["fpCtime"]?.value;
      }

      setInsertRowFastInsert(
          FPCTime,
          dr.cells["eventtype"]?.value,
          dr.cells["txCaption"]?.value,
          dr.cells["txId"]?.value,
          Utils.convertToTimeFromDouble(
              value: num.tryParse(dr.cells["duration"]?.value) ?? 0),
          dr.cells["som"]?.value,
          dr.cells["promoTypeCode"]?.value,
          dr.cells["segmentNumber"]?.value.toString() ?? "");

      // Adding Tags for promos
      // GoTo hell
      if (dr.cells["eventtype"]?.value.toString().trim().toLowerCase() ==
          "pr") {
        if ((inserSearchModel?.lstListMyEventData?.lstFastInsertTags
                    ?.where((x) => x.crTapeID == dr.cells["txId"]?.value)
                    .toList()
                    .length ??
                0) >
            0) {
          List<LstFastInsertTags>? filterList = inserSearchModel
              ?.lstListMyEventData?.lstFastInsertTags
              ?.where((x) => x.crTapeID == dr.cells["txId"]?.value)
              .toList();
          if ((filterList?.length ?? 0) == 1) {
            row = gridStateManager?.currentRowIdx ?? 0 + 1;
            gridStateManager?.setCurrentCell(
                gridStateManager?.rows[row].cells[0], row);
            setInsertRowFastInsert(
                FPCTime,
                dr.cells["eventtype"]?.value,
                filterList![0].exportTapeCaption.toString(),
                filterList![0].tagTapeid.toString(),
                Utils.convertToTimeFromDouble(
                    value: num.tryParse(
                        filterList[0].promoDuration.toString() ?? "0")!),
                filterList![0].som!,
                filterList![0].promoTypeCode ?? "",
                filterList![0].segmentNumber.toString());
            // UnSelectAllRows(gridStateManager ?);
            // gridStateManager?.rows[row - 1].selected = true;
            // gridStateManager?.currentCell = gridStateManager?.selectedRows[0].cells[1];
            gridStateManager?.setCurrentCell(
                gridStateManager?.currentRow?.cells[1],
                gridStateManager?.currentRowIdx);
          }
        }
      }

      // hell:
      // ColorGrid();
      blnMultipleGLs = true;
      // }
    } catch (e) {
      print("Error found in btnFastInsert_Add_Click()" + e.toString());
      Get.back();
    }
  }

  void setInsertRowFastInsert(
      String FpcTime,
      String EventType,
      String ExportTapeCaption,
      String Exporttapecode,
      String Tapeduration,
      String SOM,
      String Promotypecode,
      String BreakNumber) {
    int intRowIndex = gridStateManager?.currentRowIdx ?? 0;
    int InsertRow =
        int.tryParse(gridStateManager?.currentRow?.cells["rownumber"]?.value) ??
            0;
    addEventToUndo();
    if (InsertRow > 0) {
      if (isInsertAfter.value) {
        InsertRow = InsertRow + 1;
      } else {
        InsertRow = InsertRow - 1;
      }
    } else {
      if (isInsertAfter.value) {
        InsertRow = InsertRow + 1;
      }
    }

    // intCurrentRowIndex[3] = gridStateManager?.firstDisplayedScrollingRowIndex;
    // DataTable dt = gridStateManager?.dataSource;
    // PlutoRow dr = dt.newRow();
    PlutoRow dr = PlutoRow(cells: {});
    String? tapeDuration, transmissionTime;
    dr.cells["fpCtime"]?.value = FpcTime;

    if (EventType.trim().toLowerCase() == "gl" &&
        Tapeduration == "00:00:00:00") {
      for (int myRow = InsertRow; myRow >= 0; myRow--) {
        if (["p", "s", "f"].contains(gridStateManager
            ?.rows[myRow].cells["eventType"]?.value
            .toString()
            .trim()
            .toLowerCase())) {
          dr.cells["tapeduration"] =
              gridStateManager?.rows[myRow].cells["tapeduration"]?.value;
          tapeDuration =
              gridStateManager?.rows[myRow].cells["tapeduration"]?.value;
          break;
        }
      }
      transmissionTime = "00:00:00:00";
      dr.cells["transmissionTime"]?.value = "00:00:00:00";
    } else {
      transmissionTime = "";
      dr.cells["transmissionTime"]?.value = "";
      tapeDuration = Tapeduration;
      dr.cells["tapeduration"]?.value = Tapeduration;
    }
    dr.cells["exportTapeCaption"]?.value = ExportTapeCaption;
    dr.cells["exportTapeCode"]?.value = Exporttapecode;
    dr.cells["som"]?.value = SOM;

    if (BreakNumber != "") {
      dr.cells["breakNumber"]?.value = BreakNumber;
    }

    dr.cells["eventType"]?.value = EventType;
    dr.cells["promoTypecode"]?.value = Promotypecode;

    PlutoRow rowData = insertPlutoRow(
      FpcTime,
      EventType,
      ExportTapeCaption,
      Exporttapecode,
      tapeDuration!,
      SOM,
      BreakNumber: ((BreakNumber != null) ? int.tryParse(BreakNumber!) : 0)!,
    );
    if (InsertRow == 0) {
      InsertRow = -1;
    }

    print(">>>.Insert row is>>" + InsertRow.toString());
    gridStateManager?.insertRows(InsertRow + 1, [rowData]);
    // dt.acceptChanges();
    colorGrid(false);
    // gridStateManager?.firstDisplayedScrollingRowIndex = intCurrentRowIndex[3];

    /* if (EventType == "GL" && blnMultipleGLs) {
      gridStateManager?.rows[intRowIndex - 1].selected = true;
    } else {
      gridStateManager?.rows[intRowIndex].selected = true;
    }*/

    // gridStateManager?.currentCell = gridStateManager?.rows[intRowIndex].cells[1];
    gridStateManager?.setCurrentCell(
        gridStateManager?.rows[intRowIndex + 1].cells[1], intRowIndex + 1);
  }

  void btnReplace_GetEvent_Click() {
    if (gridStateManager?.currentRow == null) return;

    replaceDuration.text =
        gridStateManager?.currentRow?.cells["tapeduration"]?.value.toString() ??
            "";
    txReplaceTxId_.text = gridStateManager
            ?.currentRow?.cells["exportTapeCode"]?.value
            .toString() ??
        "";
    txReplaceSegment_.text =
        gridStateManager?.currentRow?.cells["breakNumber"]?.value.toString() ??
            "";
    txReplaceEvent_.text =
        gridStateManager?.currentRow?.cells["eventType"]?.value.toString() ??
            "";
    /*fromReplaceInsert_.text = gridStateManager
            ?.currentRow?.cells["transmissionTime"]?.value
            .toString() ??
        "";
    toReplaceInsert_.text = gridStateManager
            ?.currentRow?.cells["transmissionTime"]?.value
            .toString() ??
        "";*/
  }

  btnCopyLogClick({Function? fun}) {
    LoadingDialog.call();
    var sendData = {
      "locationcode": selectLocationCopyLog?.key ?? "",
      "channelcode": selectChannelCopyLog?.key ?? "",
      "standbyLog": isStandby.value,
      "telecastdate": selectedDate.text,
      "copylog": true
    };

    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.TRANSMISSION_LOG_RETRIVE(),
        json: sendData,
        fun: (Map<String, dynamic> map) {
          Get.back();
          Get.back();
          transmissionLog = TransmissionLogModel.fromJson(map);
          if (transmissionLog != null &&
              transmissionLog?.loadSavedLogOutput != null &&
              transmissionLog?.loadSavedLogOutput?.lstTransmissionLog != null &&
              ((transmissionLog
                          ?.loadSavedLogOutput?.lstTransmissionLog?.length ??
                      0) !=
                  0)) {
            startTime_.text = transmissionLog?.loadSavedLogOutput
                    ?.lstTransmissionLog![0].transmissionTime ??
                "";
            isEnable.value = false;
            isFetch.value = true;
            update(["transmissionList"]);
          } else {
            LoadingDialog.callInfoMessage("No Data Found");
          }
        });
  }

  void dgvCommercialsCellDoubleClick(int rowIndex) {
    addEventToUndo();
    try {
      String strExportTapeCode = dgvCommercialsStateManager
          ?.rows[rowIndex].cells["exportTapeCode"]?.value;
      listFilterVerify = gridStateManager?.rows
          .where((element) =>
              element.cells["exportTapeCode"]?.value == strExportTapeCode)
          .toList();
      update(['filterVerifyList']);

      String strTimeDiff = "";
      num? intSetTimeDiff = 0;

      if (listFilterVerify != null) {
        for (PlutoRow dr in listFilterVerify!) {
          if (strTimeDiff != "") {
            num intTimeDiff = Utils.oldBMSConvertToSecondsValue(
                    value: dr.cells["transmissionTime"]?.value)! -
                Utils.oldBMSConvertToSecondsValue(value: strTimeDiff)!;
            if (intSetTimeDiff! > intSetTimeDiff! || intSetTimeDiff == 0) {
              intSetTimeDiff = intTimeDiff;
            }
          }
          strTimeDiff = dr.cells["transmissionTime"]?.value;
        }
        print("Vlaue is>>>" + (intSetTimeDiff?.round().toString() ?? ""));
        verifyMinTime.text = Utils.convertToTimeFromDouble(
            value: num.tryParse(intSetTimeDiff?.round().toString() ?? "0")!);
      }
    } catch (ex) {
      Snack.callError("Error: " + ex.toString());
    }
  }

  dgvTimeCellDoubleClick(int rowIndex) {
    // gridStateManager?.moveScrollByRow(PlutoMoveDirection.up, 44);
    colorGrid(true);
    // unselectAllRows(gridStateManager?);
    int intRowNumber = int.tryParse(
            dgvTimeStateManager?.rows[rowIndex].cells["rownumber"]?.value) ??
        0;
    // int intRowNumber = rowIndex;
    print("Introw>>>>>>" + intRowNumber.toString());
    for (PlutoRow dr in (gridStateManager?.rows)!) {
      if (int.tryParse(dr.cells["rownumber"]?.value.toString() ?? "0") ==
          intRowNumber) {
        /*if (intRowNumber > 12) {
          // gridStateManager?.firstDisplayedScrollingRowIndex = intRowNumber - 12;
          print(">>>Response>>>>"+intRowNumber.toString());
          gridStateManager?.moveScrollByRow(PlutoMoveDirection.up, intRowNumber-12);
        } else {
          // gridStateManager?.firstDisplayedScrollingRowIndex = 0;
          gridStateManager?.moveScrollByRow(PlutoMoveDirection.up, 0);
        }*/
        // gridStateManager?.rows[intRowNumber].selected = true;
        gridStateManager?.moveScrollByRow(
            PlutoMoveDirection.down, intRowNumber);
        gridStateManager?.setCurrentCell(
            gridStateManager?.rows[intRowNumber].cells["no"], intRowNumber);
      }
    }
    print("Select row index is>>>" +
        (gridStateManager?.currentRowIdx.toString() ?? ""));
  }

  /*filterAaList() {
    List<PlutoRow>? list = gridStateManager?.rows
        .where((element) =>
            element.cells["bookingNumber"]?.value != null &&
            element.cells["bookingNumber"]?.value != "")
        .toList();
    // var counts = groupBy<PlutoRow, PlutoRow>(list!, (item) => item.cells["bookingNumber"]?.value));
    // Map<String,dynamic>? list2={};
    // Map<String,dynamic>? list1=list?.fold(list2, (map, item) => item.toJson());
    // print("Resposnnsnnsn>>>>>"+jsonEncode(list1));
    // var counts1 = groupBy<PlutoRow, PlutoRow>(list!, (item) => item.cells["bookingNumber"]?.value));

    */ /* counts.forEach((key, value) {
      print("KeyList:>>"+key.toString()+">>>value>>"+(value.toString()??""));
    });*/ /*

    listFilterAa = list;
    update(["aAList"]);
  }*/

  getChannelFocusOut() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.TRANSMISSION_LOG_CHANNEL_SPEC_SETTING(
          selectLocation?.key ?? "",
          selectChannel?.key ?? "",
        ),
        fun: (Map<String, dynamic> map) {
          chkTxCommercial.value =
              map["channelSpecsSettings"]["chkTxCommercial"];
          maxProgramStarttimeDiff.value =
              map["channelSpecsSettings"]["maxProgramStarttimeDiff"];
          print(">>>>Vlaue" +
              chkTxCommercial.value.toString() +
              ">>>>Max>>>" +
              maxProgramStarttimeDiff.value.toString());
        });
  }

  selectNextProgramClockHour() {
    String type = "fpCtime";
    String strValue = "";
    int intRowIndex = gridStateManager?.currentRowIdx ?? 0;
    bool blnLastRecord = true;

    if (type == "fpCtime") {
      strValue = gridStateManager?.currentRow?.cells["fpCtime"]?.value ?? "";
    } else {
      // strValue = gridStateManager?.currentRow.cells["FPCTime"].value;
    }

    for (int i = intRowIndex; i < (gridStateManager?.rows.length ?? 0); i++) {
      // if (type == "fpCtime") {
      if (strValue != gridStateManager?.rows[i].cells["fpCtime"]?.value) {
        // gridStateManager?.rows[i].cells["FPCTime"].selected = true;
        gridStateManager?.setCurrentCell(
            gridStateManager?.rows[i].cells["fpCtime"], i);
        gridStateManager?.moveScrollByRow(PlutoMoveDirection.down, i);
        // gridStateManager?.currentRow?.cells["fpCtime"] = gridStateManager?.rows[i].cells["fpCtime"]?.value ?? "";
        // gridStateManager?.firstDisplayedScrollingRowIndex = i - 12;
        // gridStateManager?.scroll = i - 12;
        blnLastRecord = false;
        return;
      }
      // }
    }

    if (blnLastRecord) {
      LoadingDialog.recordExists("Reached to last record, Want to start again?",
          () {
        gridStateManager?.setCurrentCell(
            gridStateManager?.rows[0].cells["fpCtime"], 0);
        gridStateManager?.moveScrollByRow(PlutoMoveDirection.up, 0);
      });
      // if (msgBox("Reached to last record, Want to start again?", MsgBoxStyle.question + MsgBoxStyle.yesNo, strAlertMessageTitle) == MsgBoxResult.yes) {
      //   gridStateManager?.rows[0].cells["FPCTime"].selected = true;
      //   gridStateManager?.currentCell[""]?.value = gridStateManager?.rows[0].cells["FPCTime"]?.value??'';
      // }
    }
  }

  btnUp_Click() {
    addEventToUndo();
    List<int> intSelectedRows = [];
    int intSelectedRow = 0;
    int intMoveUpDown = 0;

    try {
      /*for (DataGridViewRow dr in gridStateManager?.selectedRows) {
        intSelectedRows.add(dr.cells["RowNumber"].value);
        intMoveUpDown = dr.cells["rownumber"].value;
        intSelectedRow++;
      }
      intMoveUpDown--;*/

      cutCopy(
          isCut: true,
          row: gridStateManager?.currentRow,
          fun: () {
            paste((gridStateManager?.currentRowIdx ?? 0) - 1, fun: () {
              colorGrid(false);
            });
          });

      /*intSelectedRows.sort();
      intSelectedRows = intSelectedRows.reversed.toList();
      for (int i = intSelectedRows.length - 1; i >= 1; i--) {
        gridStateManager?.rows[intSelectedRows[i]].selected = true;
      }

      Cursor = Cursors.default;*/
    } catch (ex) {
      // Cursor = Cursors.default;
      // MsgBox(errorLog(ex.message, BMS.globals.loggedUser, this), MsgBoxStyle.critical, strAlertMessageTitle);
    }
  }

  btnDown_Click() {
    addEventToUndo();
    List<int> intSelectedRows = [];
    int intSelectedRow = 0;
    int intMoveUpDown = 0;

    try {
      cutCopy(
          isCut: true,
          row: gridStateManager?.currentRow,
          fun: () {
            paste((gridStateManager?.currentRowIdx ?? 0) + 1, fun: () {
              colorGrid(false);
            });
          });

      /*cutCopy(true);
      paste(intMoveUpDown);
      colorGrid(false);

      intSelectedRows.sort();
      intSelectedRows = intSelectedRows.reversed.toList();
      for (int i = intSelectedRows.length - 2; i >= 0; i--) {
        gridStateManager?.rows[intSelectedRows[i]].selected = true;
      }
      gridStateManager?.rows[intMoveUpDown - 1].selected = true;
      gridStateManager?.rows[intMoveUpDown].selected = false;

      Cursor = Cursors.default;*/
    } catch (ex) {
      // Cursor = Cursors.default;
      // MsgBox(errorLog(ex.message, BMS.globals.loggedUser, this), MsgBoxStyle.critical, strAlertMessageTitle);
    }
  }

  getColorList({Function? function}) {
    LoadingDialog.call();
    if (selectLocation != null && selectChannel != null) {
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.TRANSMISSION_LOG_COLOR_LIST(
            selectLocation?.key ?? "",
            selectChannel?.key ?? "",
            Utils.dateFormatChange(
                selectedDate.text, "dd-MM-yyyy", "dd-MMM-yyyy"),
          ),
          fun: (Map map) {
            Get.back();
            listColor.clear();
            map["lstLoadColours"].forEach((e) {
              listColor.value.add(new ColorDataModel.fromJson(e));
            });
            if (function != null) {
              function();
            } else {
              callRetrieve();
            }
          });
    }
  }

  getCommercialList({required Function fun}) {
    LoadingDialog.call();
    if (selectLocation != null && selectChannel != null) {
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.TRANSMISSION_LOG_COMMERCIAL_CLICK(
              selectLocation?.key ?? "",
              selectChannel?.key ?? "",
              Utils.dateFormatChange(
                  selectedDate.text, "dd-MM-yyyy", "M/d/yyyy"),
              isStandby.value),
          fun: (Map map) {
            Get.back();
            commercailModel =
                CommercialModel.fromJson(map as Map<String, dynamic>);
            fun(commercailModel);
          });
    }
  }

  getUpdateClick() {
    LoadingDialog.recordExists("Want to save log?", () {
      LoadingDialog.call();
      if (selectLocation != null && selectChannel != null) {
        Get.find<ConnectorControl>().GETMETHODCALL(
            api: ApiFactory.TRANSMISSION_LOG_UPDATED_CLICK(
                selectLocation?.key ?? "",
                selectChannel?.key ?? "",
                // Utils.dateFormatChange(selectedDate.text, "dd-MM-yyyy", "M/d/yyyy"),
                selectedDate.text,
                isStandby.value),
            fun: (map) {
              Get.back();
              if (map is Map && map.containsKey("lstUpdatedLog")) {
                TransmissionLogModel transmission = TransmissionLogModel();
                LoadSavedLogOutput model =
                    LoadSavedLogOutput.fromJson(map as Map<String, dynamic>);
                transmission.loadSavedLogOutput = model;
                transmissionLog = transmission;
                if (transmissionLog != null &&
                    transmissionLog?.loadSavedLogOutput != null &&
                    transmissionLog?.loadSavedLogOutput?.lstTransmissionLog !=
                        null &&
                    ((transmissionLog?.loadSavedLogOutput?.lstTransmissionLog
                                ?.length ??
                            0) !=
                        0)) {
                  startTime_.text = transmissionLog?.loadSavedLogOutput
                          ?.lstTransmissionLog![0].transmissionTime ??
                      "";
                  // isEnable.value = false;
                  // isFetch.value = true;
                  update(["transmissionList"]);
                  colorGrid(true);

                  btnSave_Click();
                } else {
                  // Get.back();
                  LoadingDialog.callInfoMessage("No Data Found");
                }
              } else {
                LoadingDialog.callInfoMessage(map.toString());
              }
            });
      }
    }, deleteCancel: "No", deleteTitle: "Yes");
  }

  btn_markError_Click(index) {
    if (["c", "cl"].contains(gridStateManager
        ?.rows[index].cells["eventType"]?.value
        .toString()
        .trim()
        .toLowerCase())) {
      LoadingDialog.recordExists("Want to remove and mark as error?", () {
        LoadingDialog.call();
        String bookNo =
            gridStateManager?.rows[index].cells["bookingNumber"]?.value;
        String bookCode =
            gridStateManager?.rows[index].cells["bookingdetailcode"]?.value;
        String eventType =
            gridStateManager?.rows[index].cells["eventType"]?.value;
        if (selectLocation != null && selectChannel != null) {
          Get.find<ConnectorControl>().GETMETHODCALL(
              api: ApiFactory.TRANSMISSION_LOG_MARK_AS_ERROR(
                  selectLocation?.key ?? "",
                  selectChannel?.key ?? "",
                  bookNo,
                  bookCode,
                  selectedDate.text,
                  eventType),
              fun: (map) {
                Get.back();
                if (map is Map) {
                  addEventToUndo();
                  gridStateManager
                      ?.removeRows([(gridStateManager?.rows[index])!]);
                  colorGrid(false);
                } else {
                  LoadingDialog.callInfoMessage(map.toString());
                }
              });
        }
      }, deleteCancel: "No", deleteTitle: "Yes");
    } else {
      LoadingDialog.callInfoMessage(
          "You can't remove and mark as error to event type other than C & CL");
    }
  }

  getEventListForInsert({required Function function}) {
    if ((listEventsinInsert.value.length ?? 0) > 0) {
      function();
      return;
    }
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.TRANSMISSION_LOG_EVENT_LIST(),
        fun: (Map map) {
          Get.back();
          listEventsinInsert.value.clear();
          map["lstFastInsertEventType"].forEach((e) {
            listEventsinInsert.add(DropDownValue(key: e, value: e));
          });
          function();
        });
  }

  callRetrieve() {
    if (selectLocation == null) {
      Snack.callError("Please select location");
    } else if (selectChannel == null) {
      Snack.callError("Please select channel");
    } else {
      LoadingDialog.call();
      var sendData = {
        "locationcode": selectLocation?.key ?? "",
        "channelcode": selectChannel?.key ?? "",
        "standbyLog": isStandby.value,
        "telecastdate": selectedDate.text,
        "copylog": false
      };

      Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.TRANSMISSION_LOG_RETRIVE(),
          json: sendData,
          fun: (Map<String, dynamic> map) {
            Get.back();
            transmissionLog = TransmissionLogModel.fromJson(map);
            if (transmissionLog != null &&
                transmissionLog?.loadSavedLogOutput != null &&
                transmissionLog?.loadSavedLogOutput?.lstTransmissionLog !=
                    null &&
                ((transmissionLog
                            ?.loadSavedLogOutput?.lstTransmissionLog?.length ??
                        0) !=
                    0)) {
              startTime_.text = transmissionLog?.loadSavedLogOutput
                      ?.lstTransmissionLog![0].transmissionTime ??
                  "";
              isEnable.value = false;
              isFetch.value = true;
              lastSavedLoggedUser.value = " Last Saved Log: " +
                  (transmissionLog?.loadSavedLogOutput?.logSavedBy ?? "");
              update(["transmissionList"]);
            } else {
              LoadingDialog.callInfoMessage("No Data Found");
            }
          });
    }
  }

  checkVerifyTime() {
    if (selectLocation == null) {
      Snack.callError("Please select location");
    } else if (selectChannel == null) {
      Snack.callError("Please select channel");
    } else if (gridStateManager == null) {
      Snack.callError("Table is not set");
    } else {
      LoadingDialog.call();
      var sendData = {
        // "lstgridStateManager": gridStateManager?.rows.map((e) => e.toJson1(stringConverterKeys: ["datechange",""])).toList()
        "lstTblLog": [
          gridStateManager?.currentRow
              ?.toJson1(stringConverterKeys: ["datechange", "tapeduration"])
        ]
      };

      Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.TRANSMISSION_LOG_POST_VERIFY(),
          json: sendData,
          fun: (map) {
            Get.back();
            if (map is Map &&
                map.containsKey("success") &&
                map["success"] != null) {
              LoadingDialog.callInfoMessage(map["success"].toString());
            } else {
              LoadingDialog.callInfoMessage("No Data Found");
            }
          });
    }
  }

  void btnChangeDone_Click() {
    addEventToUndo();
    intCurrentRowIndex[0] = gridStateManager?.currentRowIdx ?? 0;
    intCurrentRowIndex[1] = int.tryParse(gridStateManager
            ?.rows[intCurrentRowIndex[0]].cells["rownumber"]?.value) ??
        0;
    // intCurrentRowIndex[3] = gridStateManager?.FirstDisplayedScrollingRowIndex;
    intCurrentRowIndex[3] = 0;
    addEventToUndo();
    if (isAllByChange.value) {
      // Update all events with the replaced duration
      for (var dr in (gridStateManager?.rows)!) {
        if (dr.cells["exportTapeCode"]?.value.toString().trim() ==
                txId_Change.text.trim() &&
            dr.cells["breakNumber"]?.value.toString().trim() ==
                segment_change.text.trim()) {
          dr.cells["tapeduration"]?.value = duration_change.text.trim();
        }
      }
    } else {
      // Update current event with the duration & offset
      if (gridStateManager?.currentRow?.cells["exportTapeCode"]?.value ==
              txId_Change.text &&
          gridStateManager?.currentRow?.cells["breakNumber"]?.value
                  .toString() ==
              segment_change.text) {
        gridStateManager?.currentRow?.cells["tapeduration"]?.value =
            duration_change.text;

        if (gridStateManager?.currentRow?.cells["eventType"]?.value
                .toString()
                .trim()
                .toLowerCase() ==
            "gl") {
          gridStateManager?.currentRow?.cells["transmissionTime"]?.value =
              offset_change.text;
        } else {
          startTime_.text = Utils.convertToTimeFromDouble(
              value: Utils.oldBMSConvertToSecondsValue(value: startTime_.text) +
                  (Utils.oldBMSConvertToSecondsValue(
                          value: offset_change.text) -
                      Utils.oldBMSConvertToSecondsValue(
                          value: gridStateManager
                              ?.currentRow?.cells["transmissionTime"]?.value)));
        }

        gridStateManager?.currentRow?.cells["fpCtime"]?.value =
            fpctime_change.text.substring(0, 8);
      }
    }

    // grpChange.Visible = false;
    colorGrid(false);
  }

  void setChangeTime({required Function function}) {
    if (gridStateManager == null) return;

    if (gridStateManager?.currentRow?.cells["eventType"]?.value
            .toString()
            .trim()
            .toLowerCase() ==
        "gl") {
      visibleChangeOffset.value = true;
      offset_change.text =
          gridStateManager?.currentRow?.cells["transmissionTime"]?.value ?? "";
      visibleChangeDuration.value = true;
      duration_change.text =
          gridStateManager?.currentRow?.cells["tapeduration"]?.value ?? "";
      fpctime_change.text =
          (gridStateManager?.currentRow?.cells["fpCtime"]?.value ?? "") + ":00";
      visibleChangeFpc.value = true;
    } else {
      visibleChangeDuration.value = false;
      if (["p", "s", "f"].contains(gridStateManager
          ?.currentRow?.cells["eventType"]?.value
          .toString()
          .trim()
          .toLowerCase())) {
        visibleChangeDuration.value = true;
      }
      visibleChangeOffset.value = true;
      offset_change.text =
          gridStateManager?.currentRow?.cells["transmissionTime"]?.value ?? "";
      duration_change.text =
          gridStateManager?.currentRow?.cells["tapeduration"]?.value ?? "";
      fpctime_change.text =
          (gridStateManager?.currentRow?.cells["fpCtime"]?.value ?? "") + ":00";
      visibleChangeFpc.value = true;
    }

    txId_Change.text =
        gridStateManager?.currentRow?.cells["exportTapeCode"]?.value;
    segment_change.text =
        gridStateManager?.currentRow?.cells["breakNumber"]?.value;

    function();
  }

  verifyClick() {
    if (selectLocation == null) {
      Snack.callError("Please select location");
    } else if (selectChannel == null) {
      Snack.callError("Please select channel");
    } else {
      LoadingDialog.call();
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.TRANSMISSION_LOG_VERIFY_CLICK(
              selectLocation?.key ?? '',
              selectChannel?.key ?? '',
              selectedDate.text,
              isStandby.value),
          fun: (map) {
            Get.back();
          });
    }
  }

  callAuto(isPromo) {
    if (selectLocation == null) {
      Snack.callError("Please select location");
    } else if (selectChannel == null) {
      Snack.callError("Please select channel");
    } else {
      if (listColor.isEmpty) {
        getColorList(function: () {
          LoadingDialog.call();
          Get.find<ConnectorControl>().GETMETHODCALL(
              api: ApiFactory.TRANSMISSION_LOG_AUTO(
                  selectLocation?.key ?? "",
                  selectChannel?.key ?? "",
                  Utils.dateFormatChange(
                      selectedDate.text, "dd-MM-yyyy", "M/d/yyyy"),
                  isPromo,
                  chkTxCommercial.value),
              fun: (map) {
                Get.back();
                if (map is Map && map.containsKey("lstTXLog")) {
                  TransmissionLogModel transmissionLogModel =
                      TransmissionLogModel();
                  LoadSavedLogOutput loadSavedLogOutput =
                      LoadSavedLogOutput.fromJson(map as Map<String, dynamic>);
                  transmissionLogModel.loadSavedLogOutput = loadSavedLogOutput;
                  transmissionLog = transmissionLogModel;
                  startTime_.text = map["lstTXLog"][0]["transmissionTime"];
                  isFetch.value = true;
                  update(["transmissionList"]);
                  // colorGrid(false);
                } else {
                  LoadingDialog.callInfoMessage(map.toString());
                }
              });
        });
      } else {
        LoadingDialog.call();
        Get.find<ConnectorControl>().GETMETHODCALL(
            api: ApiFactory.TRANSMISSION_LOG_AUTO(
                selectLocation?.key ?? "",
                selectChannel?.key ?? "",
                Utils.dateFormatChange(
                    selectedDate.text, "dd-MM-yyyy", "M/d/yyyy"),
                isPromo,
                chkTxCommercial.value),
            fun: (map) {
              Get.back();
              if (map is Map && map.containsKey("lstTXLog")) {
                TransmissionLogModel transmissionLogModel =
                    TransmissionLogModel();
                LoadSavedLogOutput loadSavedLogOutput =
                    LoadSavedLogOutput.fromJson(map as Map<String, dynamic>);
                transmissionLogModel.loadSavedLogOutput = loadSavedLogOutput;
                transmissionLog = transmissionLogModel;
                startTime_.text = map["lstTXLog"][0]["transmissionTime"];
                isFetch.value = true;
                update(["transmissionList"]);
              }
            });
      }
    }
  }

  ColorDataModel? getMatchWithKey(String key) {
    ColorDataModel? data;
    // print("Steo 2>>" + key);
    for (int i = 0; i < listColor.value.length!; i++) {
      var element = listColor.value[i];
      if (element.eventType?.trim().toLowerCase() == key.trim().toLowerCase()) {
        data = element;
        break;
      }
    }
    return data;
  }

  setOffSetTime() {
    if ((selectedDate.text.trim() != "") &&
        (txtTransmissionTime.text.trim() != "")) {
      offsetTime_.text = Utils.convertToTimeFromDouble(
          value: ((Utils.oldBMSConvertToSecondsValue(
                      value: gridStateManager
                              ?.rows[0].cells["transmissionTime"]?.value ??
                          "00:00:00:00") -
                  Utils.oldBMSConvertToSecondsValue(value: selectedDate.text)))
              .abs());
    } else {
      offsetTime_.text = "00:00:00:00";
    }
  }

  calculateTransmissionTime() {
    if (transmissionLog == null ||
        transmissionLog?.loadSavedLogOutput == null ||
        transmissionLog?.loadSavedLogOutput?.lstTransmissionLog == null ||
        ((transmissionLog?.loadSavedLogOutput?.lstTransmissionLog?.length ??
                0) ==
            0)) {
      return;
    }

    num transmissionTime = 0;
    num secTransmissionTime;
    int i;
    int graphicEventCtr = 0;
    int intRowNumber = 0;
    intRowNumber = getFixedtimeRowindex();
    if (intRowNumber == 0) {
      if (!isRowFilter.value) {
        transmissionTime =
            Utils.oldBMSConvertToSecondsValue(value: startTime_.text);
      }
      gridStateManager?.rows[0].cells["transmissionTime"]?.value =
          Utils.convertToTimeFromDouble(value: transmissionTime);
    } else {
      transmissionTime = Utils.oldBMSConvertToSecondsValue(
          value: gridStateManager
                  ?.rows[intRowNumber].cells["transmissionTime"]?.value ??
              "00:00:00:00");
    }

    for (i = intRowNumber; i < (gridStateManager?.rows.length ?? 0); i++) {
      if ((i + 1) < (gridStateManager?.rows.length ?? 0)) {
        gridStateManager?.rows[i].cells["breakEvent"]?.value = "";
        //duration of secondary events is ignored for secondary events
        if (gridStateManager?.rows[i].cells["eventType"]?.value
                .toString()
                .trim()
                .toLowerCase() !=
            "gl") {
          graphicEventCtr = 0;
          transmissionTime = transmissionTime +
              Utils.oldBMSConvertToSecondsValue(
                  value:
                      gridStateManager?.rows[i].cells["tapeduration"]?.value ??
                          "00:00:00:00");
        } else {
          //'Set the transmission time for secondary evnts only
          if (gridStateManager?.rows[i].cells["exportTapeCode"]?.value
                  .toString()
                  .substring(0, 2)
                  .trim()
                  .toLowerCase() ==
              "gp") {
            if (gridStateManager?.rows[i].cells["transmissionTime"]?.value
                    .toString() ==
                "") {
              gridStateManager?.rows[i].cells["transmissionTime"]?.value =
                  "00:00:00:00";
            }
          } else {
            graphicEventCtr = graphicEventCtr + 1;
            secTransmissionTime = graphicEventCtr * 60;
            if (gridStateManager?.rows[i].cells["transmissionTime"]?.value ==
                "") {
              gridStateManager?.rows[i].cells["transmissionTime"]?.value =
                  Utils.convertToTimeFromDouble(value: secTransmissionTime);
            }
          }
        }
        // for all secondary events the transmissiontime is the offset and will not be automatically entered from this function
        if ((i + 1) < (gridStateManager?.rows.length ?? 0)) {
          if (gridStateManager?.rows[i + 1].cells["eventType"]?.value
                  .toString()
                  .trim()
                  .toLowerCase() !=
              "gl") {
            gridStateManager?.rows[i + 1].cells["transmissionTime"]?.value =
                Utils.convertToTimeFromDouble(value: transmissionTime);
          }
        }
      }
    }
    if (intRowNumber == 0) {
      transmissionTime =
          Utils.oldBMSConvertToSecondsValue(value: startTime_.text);
    } else {
      transmissionTime = Utils.oldBMSConvertToSecondsValue(
          value: gridStateManager
                  ?.rows[intRowNumber].cells["transmissionTime"]?.value ??
              "00:00:00:00");
    }
    for (int i = (intRowNumber - 1); i >= 0; i--) {
      gridStateManager?.rows[i].cells["breakEvent"]?.value = "";

      if (gridStateManager?.rows[i].cells["eventType"]?.value
              .toString()
              .trim()
              .toLowerCase() !=
          "gl") {
        transmissionTime = transmissionTime -
            Utils.oldBMSConvertToSecondsValue(
                value: gridStateManager?.rows[i].cells["tapeduration"]?.value ??
                    "00:00:00:00");
        gridStateManager?.rows[i].cells["transmissionTime"]?.value =
            Utils.convertToTimeFromDouble(value: transmissionTime);
      }
    }
    gridStateManager?.notifyListeners();
    setOffSetTime();
  }

  void updateRowNumber() {
    num secondaryEventCtr = 0, hr = 0;
    num startHour, datechange;
    int i = 0;

    PlutoRow? dr1 = gridStateManager?.rows[0];
    if (num.tryParse(
            dr1?.cells["transmissionTime"]?.value.toString().substring(0, 2) ??
                "0")! >
        20) {
      datechange = 0;
      startHour = num.parse(
          dr1?.cells["transmissionTime"]?.value.toString().substring(0, 2) ??
              "0");
    } else {
      datechange = 1;
      startHour = int.parse(
          dr1?.cells["transmissionTime"]?.value.toString().substring(0, 2) ??
              "0");
    }

    int strLastEventRowNumber = 0;
    // DataTable gridStateManager = gridStateManager?.dataSource;
    for (PlutoRow dr in (gridStateManager?.rows)!) {
      String? strEventType = "";
      if (i > 0) {
        strEventType = gridStateManager?.rows[i].cells["eventType"]?.value
            .toString()
            .trim()
            .toLowerCase();
        if (strEventType != "gl") {
          secondaryEventCtr = 0;
          if (num.tryParse(
                  dr.cells["transmissionTime"]?.value.substring(0, 2)!)! <
              num.tryParse(gridStateManager?.rows[strLastEventRowNumber]
                      .cells["transmissionTime"]?.value
                      .toString()
                      .substring(0, 2) ??
                  "0")!) {
            datechange = datechange + 1;
          }
          hr = (datechange * 24) +
              num.parse(dr.cells["transmissionTime"]?.value
                      .toString()
                      .substring(0, 2) ??
                  "0");
        } else {
          secondaryEventCtr = secondaryEventCtr + 1;
          if (dr.cells["transmissionTime"]?.value.toString() == "") {
            dr.cells["transmissionTime"]?.value =
                Utils.convertToTimeFromDouble(value: (secondaryEventCtr * 60));
          }
        }
      } else if (i == 0) {
        if (dr.cells["eventType"]?.value.toString().trim().toLowerCase() !=
            "gl") {
          hr = (datechange * 24) +
              int.parse(dr.cells["transmissionTime"]?.value
                      .toString()
                      .substring(0, 2) ??
                  "0");
        }
      }

      if (strEventType == "p" || strEventType == "s") {
        dr.cells["breakEvent"]?.value = "PGMNOBUG";
        if ((i + 1) < (gridStateManager?.rows.length ?? 0))
          gridStateManager?.rows[i + 1].cells["breakEvent"]?.value = "BRKNORML";
        if ((i + 2) < (gridStateManager?.rows.length ?? 0))
          gridStateManager?.rows[i + 2].cells["breakEvent"]?.value = "CLEARALL";
      }

      dr.cells["rownumber"]?.value = i.toString();
      dr.cells["datechange"]?.value = hr;
      i = i + 1;
      if (strEventType != "gl") {
        strLastEventRowNumber =
            int.parse(dr.cells["rownumber"]?.value.toString() ?? "0");
      }
    }
    gridStateManager?.notifyListeners();
  }

  int getFixedtimeRowindex() {
    if ((this.txtTransmissionTime.text == "")) {
      return 0;
    }
    for (int i = 0; (i < (gridStateManager?.rows.length ?? 0)); i++) {
      if (gridStateManager?.rows[i].cells["transmissionTime"]?.value ==
              txtTransmissionTime.text &&
          gridStateManager?.rows[i].cells["datechange"]?.value.toString() ==
              txtDtChange.text) {
        return i;
      }
    }
    return 0;
  }

  void colorGrid(bool dontSavefile) {
    print("Called once" + dontSavefile.toString());
    try {
      if ((gridStateManager?.rows.length == 0)) {
        return;
      }
      logSaved = false;
      if (!dontSavefile) {
        calculateTransmissionTime();
        updateRowNumber();
        _download();
      }
    } catch (ex) {
    } finally {
      /* gridStateManager?.PerformLayout();
      if ((DontSavefile == false)) {
        SaveFile();
        dtSTD[4] = DateTime
            .now()
            .millisecondsSinceEpoch;
        // changedRows(Changecounter) = gridStateManager?.FirstDisplayedScrollingRowIndex
        if (!(gridStateManager?.currentRow == null)) {
          changedRows(Changecounter) =
              gridStateManager?.currentRow.cells["rownumber"]?.value;
        }
        else {
          changedRows(Changecounter) = 0;
        }
      }
*/
      // MsgBox(dtSTD(0).ToString & Chr(13) & dtSTD(1).ToString & Chr(13) & dtSTD(2).ToString & Chr(13) & dtSTD(3).ToString & Chr(13) & dtSTD(4).ToString)
    }
/*
    GetDuplicateBookingNumber();
    HasWrongSecondaryEventOffset(false);
    dtSTD[5] = DateTime
        .now()
        .millisecondsSinceEpoch;
    if ((intCurrentRowIndex(0) == -1)) {
      return;
    }

    if (DontSavefile) {
      gridStateManager?.rows[intCurrentRowIndex(1)].cells[0].Selected = true;
      gridStateManager?.CurrentCell = gridStateManager?.rows[intCurrentRowIndex(1)].cells[0];
      gridStateManager?.FirstDisplayedScrollingRowIndex = intCurrentRowIndex(3);
      intCurrentRowIndex(0) = -1;
    }
    else {
      gridStateManager?.rows[intCurrentRowIndex(0)].cells[0].Selected = true;
      gridStateManager?.CurrentCell = gridStateManager?.rows[intCurrentRowIndex(0)].cells[0];
      gridStateManager?.FirstDisplayedScrollingRowIndex = intCurrentRowIndex(3);
    }

    intCurrentRowIndex(0) = -1;
    intCurrentRowIndex(3) = -1;
    dtSTD[6] = DateTime
        .now()
        .millisecondsSinceEpoch;*/
  }

  onDragCall() {}

  dataGridView1_DragDrop(index, PlutoRow plutoRow, Function function) {
    int roy;
    int? movedRowIndex =
        gridStateManager?.rows.indexWhere((element) => element == plutoRow);
    // int intFirstRow = index;
    int up = 0;
    // Point clientPoint = gridStateManager?.pointToClient(Point(e.x, e.y));
    List<int> intCurrentRowIndex = List.filled(4, 0).toList();

    intCurrentRowIndex[0] = index;
    intCurrentRowIndex[1] = int.tryParse(gridStateManager
            ?.rows[intCurrentRowIndex[0]].cells["rownumber"]?.value) ??
        0;
    intCurrentRowIndex[2] = int.tryParse(gridStateManager
            ?.rows[intCurrentRowIndex[0]].cells["rownumber"]?.value) ??
        0;
    intCurrentRowIndex[3] = movedRowIndex!;

    // List<PlutoRow>? bsPeople = gridStateManager?.rows;
    PlutoRow rowToMove = plutoRow;
    String strEventType = "", strRosTimeBand = "", strFPCTime = "";
    Map<String, PlutoCell>? cellsData = {};
    rowToMove.cells.forEach((key, value) {
      cellsData[key] = value;
    });
    strFPCTime = rowToMove.cells["fpCtime"]?.value;
    strRosTimeBand = rowToMove.cells["rosTimeBand"]?.value;
    strEventType = rowToMove.cells["eventType"]?.value;

    if (strEventType.trim().toLowerCase() == "c") {
      if (strRosTimeBand == "") {
        if (strFPCTime !=
            gridStateManager
                ?.rows[intCurrentRowIndex[0]].cells["fpCtime"]?.value
                .toString()) {
          LoadingDialog.callInfoMessage(
              "You cannot move selected commercial from $strFPCTime FPCTime to ${gridStateManager?.rows[intCurrentRowIndex[0]].cells["fpCtime"]?.value} FPCTime.");
          return;
        }
      }
    }

    if (index > movedRowIndex) {
      up = 0;
    } else {
      up = 1;
    }

    PlutoRow row = PlutoRow(cells: {});
    row.cells = cellsData;
    // row.itemArray = celldata;
    if (intCurrentRowIndex[0] > 0) {
      // row.cells["fpCtime"] = gridStateManager?.rows[gridStateManager?.rows[intCurrentRowIndex[0] - 1].cells["rownumber"]?.value].cells["fpCtime"]?.value;
      row.cells["fpCtime"]?.value = gridStateManager
          ?.rows[intCurrentRowIndex[0] - 1].cells["fpCtime"]?.value;
    } else {
      // row.cells["fpCtime"] = gridStateManager?.rows[gridStateManager?.rows[intCurrentRowIndex[0]].cells["rownumber"]?.value].cells["fpCtime"]?.value;
      row.cells["fpCtime"]?.value =
          gridStateManager?.rows[intCurrentRowIndex[0]].cells["fpCtime"]?.value;
    }
    if (["p", "s"].contains(strEventType.trim().toLowerCase())) {
      // row.cells["fpCtime"] = bsPeople.rows[gridStateManager?.rows[rowToMove?.index].cells["rownumber"].value]["fpCtime"];
      row.cells["fpCtime"]?.value =
          gridStateManager?.rows[movedRowIndex].cells["fpCtime"]?.value;
    }
    gridStateManager?.insertRows(intCurrentRowIndex[0], [row]);

    if (gridStateManager?.rows.length == movedRowIndex + 1) {
      // gridStateManager.rows.removeAt(gridStateManager?.rows[rowToMove.index].cells["rownumber"].value + 1);
      PlutoRow? row = gridStateManager?.rows[int.tryParse(gridStateManager
              ?.rows[movedRowIndex].cells["rownumber"]?.value)! +
          1];
      gridStateManager?.removeRows([row!]);
    } else {
      // bsPeople.rows.removeAt(gridStateManager?.rows[rowToMove.index + up].cells["rownumber"].value);
      // PlutoRow? row = gridStateManager?.rows[int.tryParse(gridStateManager?.rows[movedRowIndex+up].cells["rownumber"]?.value)!];
      // PlutoRow? row = gridStateManager?.rows[int.tryParse(gridStateManager?.rows[movedRowIndex].cells["rownumber"]?.value)!];
      PlutoRow? row = gridStateManager?.rows[movedRowIndex + up];
      gridStateManager?.removeRows([row!]);
    }

    if (up == 0) {
      intCurrentRowIndex[0] = intCurrentRowIndex[0] - 1;
    }

    colorGrid(false);
    // function();
  }

  getUniqueId() {
    return DateTime.now().microsecondsSinceEpoch.toString();
  }

  addEventToUndo({Function? function}) {
    String uniqueId = getUniqueId();
    // logCreates1.add({"deleteAll": uniqueId});
    logDeletedEvent1.add({uniqueId: (gridStateManager?.rows)!});
    if (function != null) {
      function();
    }
    // logDeletedScheduleProgram.add({uniqueId: (scheduledPrograms.value)});
  }

  undoClick() {
    if (logDeletedEvent1.isNotEmpty) {
      gridStateManager?.removeAllRows();
      gridStateManager?.insertRows(0, (logDeletedEvent1.last.values.first));
      gridStateManager?.notifyListeners();
      logDeletedEvent1.removeLast();
      // calculateTransmissionTime();
      // dtSTD[1] = DateTime.now().millisecondsSinceEpoch;

      updateRowNumber();
    }
  }

  beforeCallDraggble(List<PlutoRow> allList, indexToMove,
      List<PlutoRow> rowMoved, Function function) {
    // return true;
    print("On before called" +
        allList.length.toString() +
        "Row list>>>" +
        rowMoved.length.toString());
    addEventToUndo(function: () {
      // function();
      dataGridView1_DragDrop(indexToMove, rowMoved[0], function);
    });
    // function();
  }

  void fixedEvent(int index) {
    txtTransmissionTime.text =
        gridStateManager?.rows[index].cells["transmissionTime"]?.value ?? "";
    txtDtChange.text =
        gridStateManager?.rows[index].cells["datechange"]?.value.toString() ??
            '';
    // DataTable dt = gridStateManager?.dataSource;
    if (gridStateManager?.rows.length != 0) {
      try {
        offsetTime_.text = Utils.convertToTimeFromDouble(
            value: (Utils.oldBMSConvertToSecondsValue(
                        value: gridStateManager
                            ?.rows[0].cells["transmissionTime"]?.value) -
                    Utils.oldBMSConvertToSecondsValue(value: startTime_.text))
                .abs());
      } catch (ex) {
        print("Error is >>>" + ex.toString());
        // MsgBox(errorLog(ex.message, BMS.globals.loggedUser, this), MsgBoxStyle.critical, strAlertMessageTitle);
      }
    }
  }

  cutCopy({required bool isCut, required PlutoRow? row, Function? fun}) {
    if (isCut) {
      lastSelectOption = "cut";
      // var strAllowedEvent = "PR,PC,F,I,A,W,VP,GL,C,CL";
      List<String> strAllowedEvent = [
        "PR",
        "PC",
        "F",
        "I",
        "A",
        "W",
        "VP",
        "GL",
        "C",
        "CL"
      ];
      if (strAllowedEvent.contains(
          row?.cells["eventType"]?.value.toString().trim().toUpperCase() ??
              "")) {
        print("Cutt");
        copyRow = row;
        if (fun != null) {
          fun();
        }
      } else {
        LoadingDialog.callInfoMessage("We couldn't cut this row");
      }
    } else {
      lastSelectOption = "copy";
      List<String> strAllowedEvent = [
        "PR",
        "PC",
        "F",
        "I",
        "A",
        "W",
        "VP",
        "GL"
      ];
      print("Event is.>>>" +
          (row?.cells["eventType"]?.value.toString().trim().toUpperCase() ??
              ""));
      if (strAllowedEvent.contains(
          row?.cells["eventType"]?.value.toString().trim().toUpperCase() ??
              "")) {
        print("Copied");
        copyRow = row;
        if (fun != null) {
          fun();
        }
      } else {
        LoadingDialog.callInfoMessage("We couldn't copy this row");
      }
    }
  }

  paste(index, {Function? fun}) {
    if (lastSelectOption != null && copyRow != null) {
      addEventToUndo();
      switch (lastSelectOption) {
        case "cut":
          gridStateManager?.removeRows([copyRow!]);
          gridStateManager?.insertRows(index, [copyRow!]);
          copyRow = null;
          gridStateManager?.notifyListeners();
          if (fun != null) {
            fun();
          }
          break;
        case "copy":
          gridStateManager?.insertRows(index, [copyRow!]);
          gridStateManager?.notifyListeners();
          if (fun != null) {
            fun();
          }
          break;
      }
      gridStateManager?.setCurrentCell(
          gridStateManager?.rows[index].cells["no"], index);
      // gridStateManager?.setcurre(gridStateManager?.currentCell, index);
      print(" Now focus row is>>>>" +
          (gridStateManager?.currentRowIdx?.toString() ?? "0"));
    } else {
      LoadingDialog.callInfoMessage("Nothing is selected");
    }
  }

  dataGridRowFilter({required String matchValue, required String filterKey}) {
    // gridStateManager.(column: column)
    // gridStateManager?.fi
    // gridStateManager?.resolveNotifierFilter();
    // gridStateManager?.setFilter((e){return true;});
    gridStateManager?.setFilter((element) {
      print(
          "key is >>> ${element.cells[filterKey]?.value.toString()} match value >>>$matchValue");
      return (element.cells[filterKey]?.value.toString() == matchValue);
    });
  }

  dataGridRowFilterCommercial(
      {required String matchValue, required String filterKey}) {
    // gridStateManager.filteredCellValue(column: column)
    gridStateManagerCommercial
        ?.setFilter((element) => element.cells[filterKey]?.value == matchValue);
  }

  void _download() async {
    if (kDebugMode) {
      return;
    }
    List<Map<String, dynamic>>? list =
        gridStateManager?.rows.map((e) => e.toJson()).toList();
    var map = {
      "loadSavedLogOutput": {"lstTransmissionLog": list}
    };
    /*String data = await jsonEncode(
        gridStateManager?.rows.map((e) => e.toJson()).toList());*/
    // final stream = await Stream.fromIterable(data!.codeUnits);
    // download(stream, 'hello.txt');
    // final FileSystemAccessHandle? handle = await html.window.();
    // if (handle != null) {
    // Permission granted, continue with folder creation
    // } else {
    // Permission denied, handle accordingly
    // }

    List<String> dateSplit = selectedDate.text.split("-");

    String filename =
        "${selectLocation?.value ?? ""}${selectChannel?.value}${dateSplit[2]}${dateSplit[1]}${dateSplit[0]}.json";

    ExportData().exportFilefromString(jsonEncode(map), filename);
  }

  void btnSave_Click() async {
    try {
      // gridStateManager.myDataGridRowFilter(true, false);
      colorGrid(false);
      // dt = gridStateManager.dataSource;

      // gridStateManager.currentCell = null;
      bool? checkPromo = await checkPromoTags();
      if (!(checkPromo!)) {
        return;
      } else {
        // unselectAllRows(gridStateManager);
      }

      bool programSequence = await programSequenceValidation();
      if (!programSequence) {
        // cursor = Cursors.default;
        return;
      }

      bool? checkLostSec = await checkLostSecondaryEvents();
      if (!(checkLostSec!)) {
        return;
      }

      bool? hasWrongSec = await hasWrongSecondaryEventOffset(showMessage: true);
      if (hasWrongSec) {
        bool? data = await showDialogForYesNo(
            "Secondary events Scheduled beyond primary event Duration!\nDo you want to proceed?");
        // data=data??false;
        if (!(data!)) {
          return;
        }
      }

      bool? checkRosTransmission = await checkRosTransmissionTime();
      if (!(checkRosTransmission!)) {
        return;
      }

      print("maxProgramStarttimeDiff>>>" +
          maxProgramStarttimeDiff.value.toInt().toString());
      bool? diffFpcTransmission = await diffFPCTransmissionTime(
          seconds: maxProgramStarttimeDiff.value.toInt());
      if (!(diffFpcTransmission)) {
        return;
      }

      bool? checkBacktoBackProd = await checkBackToBackProducts();
      if (!(checkBacktoBackProd!)) {
        return;
      }

      bool? checkBacktoBackProdGrp = await checkBackToBackProductGroup();
      if (!(checkBacktoBackProdGrp!)) {
        return;
      }

      bool? checkRosTransmission1 =
          await checkRosTransmissionTime(seconds: 300);
      if (!(checkRosTransmission1!)) {
        return;
      }

      postTransmissionLog();
    } catch (ex) {
      print("Error is>>" + ex.toString());
      // cursor = Cursors.default;
      // showMessageBox(errorLog(ex.message, BMS.globals.loggedUser, this), MessageBoxType.critical, strAlertMessageTitle);
    }
  }

  Future<bool>? checkPromoTags() {
    print("Check promo tags");
    Completer<bool> completer = Completer<bool>();
    String strTapeCode;
    if (selectLocation != null && selectChannel != null) {
      // LoadingDialog.call();
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.TRANSMISSION_LOG_CHECK_PROMOTAGS(
              selectLocation?.key ?? "",
              selectChannel?.key ?? "",
              Utils.dateFormatChange(
                  selectedDate.text, "dd-MM-yyyy", "M/d/yyyy"),
              isStandby.value),
          fun: (map) async {
            // Get.back();
            if (map is Map) {
              if (map.containsKey("lstCheckPromoTags") &&
                  map["lstCheckPromoTags"] != null) {
                CheckPromoTagModel data =
                    CheckPromoTagModel.fromJson(map as Map<String, dynamic>);
                // List<dynamic> _dt = map["lstCheckPromoTags"];
                for (PlutoRow dr in (gridStateManager?.rows)!) {
                  strTapeCode = dr.cells["exportTapeCode"]?.value;
                  bool blnBefore = true;
                  List<LstCheckPromoTags>? query = data.lstCheckPromoTags
                      ?.where((x) => (x.cRtapeid == strTapeCode))
                      .toList();
                  if ((query?.length ?? 0) > 0) {
                    // DataTable queryDataTable = query.copyToDataTable();
                    // if (queryDataTable != null) {
                    for (var _dr in query!) {
                      if (_dr.act.toString().toLowerCase() == "before") {
                        // if (_dr.tgtapeid.toString() == gridStateManager?.rows[dr.index - (dr.index == 0 ? 0 : 1)].cells["ExportTapeCode"].value.toString()) {
                        if (_dr.tgtapeid.toString() ==
                            gridStateManager
                                ?.rows[dr.sortIdx - (dr.sortIdx == 0 ? 0 : 1)]
                                .cells["exportTapeCode"]
                                ?.value
                                .toString()) {
                          blnBefore = true;
                          break;
                        } else {
                          blnBefore = false;
                        }
                      } else {
                        if (_dr.tgtapeid.toString() !=
                            gridStateManager?.rows[dr.sortIdx + 1]
                                .cells["exportTapeCode"]?.value
                                .toString()) {
                          // gridStateManager.firstDisplayedScrollingRowIndex = dr.cells["rownumber"].value - 10;
                          gridStateManager?.moveScrollByRow(
                              PlutoMoveDirection.down,
                              int.tryParse(dr.cells["rownumber"]?.value)! - 10);
                          // gridStateManager.rows[dr.cells["rownumber"].value - 1].selected = true; //major change
                          gridStateManager?.setCurrentCell(
                              dr.cells["rownumber"],
                              int.tryParse(dr.cells["rownumber"]?.value)! - 1);
                          bool? data = await showDialogForYesNo(
                              "Promo & Tag mismatch! Tape ID: ${dr.cells["exportTapeCode"]?.value} on row number: ${dr.cells["rownumber"]?.value}\nDo you want to proceed with Save?");
                          if (data == null) {
                            data = false;
                          }
                          if (!data) {
                            completer.complete(false);
                            // return false;
                          }
                        }
                      }
                    }

                    if (!blnBefore) {
                      // gridStateManager.firstDisplayedScrollingRowIndex = dr.cells["rownumber"].value - 10;
                      gridStateManager?.moveScrollByRow(PlutoMoveDirection.down,
                          int.tryParse(dr.cells["rownumber"]?.value)! - 10);
                      // gridStateManager.rows[dr.cells["rownumber"].value - 1].selected = true; //major change
                      gridStateManager?.setCurrentCell(dr.cells["no"],
                          int.tryParse(dr.cells["rownumber"]?.value)!);
                      // gridStateManager.rows[dr.cells["rownumber"].value].selected = true;
                      bool? data = await showDialogForYesNo(
                          "Promo & Tag mismatch! Tape ID: ${dr.cells["exportTapeCode"]?.value} on row number: ${dr.cells["rownumber"]?.value}\nDo you want to proceed with Save?");
                      if (data == null) {
                        data = false;
                      }
                      if (!data) {
                        completer.complete(false);
                        // return false;
                      }
                    }
                    // }
                  }
                }
                completer.complete(true);
                // return true;
              } else {
                completer.complete(true);
                // return true;
              }
            } else {
              completer.complete(false);
              // return false;
            }
          },
          failed: (map) {
            completer.complete(false);
            // return false;
          });
    }
    return completer.future;
  }

  Future<bool> programSequenceValidation() async {
    Completer<bool> completer = Completer();
    try {
      int row = 0;
      // DataTable _dt = tblLog.dataSource;

      if (gridStateManager == null) {
        LoadingDialog.callInfoMessage("Nothing To save");
        completer.complete(false);
        // return false;
      }

      List<PlutoRow>? query = gridStateManager?.rows
          .where((element) => ["s", "p"].contains(element
                  .cells["eventType"]?.value
                  ?.toString()
                  .trim()
                  .toLowerCase() ??
              ""))
          .toList();
      if ((query?.length ?? 0) > 0) {
        // DataTable __dt = query.copyToDataTable();
        if (query != null) {
          String? strTapeID = "";
          int intSegmentNumber = 0;
          // for (var dr in __dt.rows) {
          for (var dr in query) {
            if (dr.cells["exportTapeCode"]?.value?.toLowerCase() != "tba" &&
                dr.cells["exportTapeCode"]?.value?.toLowerCase() != "news" &&
                dr.cells["exportTapeCode"]?.value?.toLowerCase() != "live") {
              if (strTapeID == dr.cells["exportTapeCode"]?.value.toString()) {
                if (intSegmentNumber >
                    int.parse(
                        dr.cells["breakNumber"]?.value.toString() ?? '')) {
                  // gridStateManager.firstDisplayedScrollingRowIndex = int.parse(dr["rownumber"].toString()) - 10;
                  gridStateManager?.moveScrollByRow(PlutoMoveDirection.down,
                      int.parse(dr.cells["rownumber"]?.value)! - 10);
                  // tblLog.rows[int.parse(dr.cells["rownumber"]?.value)].selected = true;
                  gridStateManager?.setCurrentCell(
                      dr.cells["no"], int.parse(dr.cells["rownumber"]?.value));
                  bool? data = await showDialogForYesNo(
                      "Program sequence mismatch on Tape ID: $strTapeID between Segment Numbers:  $intSegmentNumber and ${int.parse(dr.cells["breakNumber"]?.value.toString() ?? "0")}\nExit Save?");
                  /*if (data == null) {
                    data = false;
                  }*/
                  data = data ?? false;
                  if (data) {
                    completer.complete(false);
                    // return false;
                  }
                }
              } else {
                strTapeID = dr.cells["exportTapeCode"]?.value.toString();
                if (strTapeID == "tba" ||
                    strTapeID == "live" ||
                    strTapeID == "news") {
                  strTapeID = "z y x w v u";
                }
              }
            }
            intSegmentNumber =
                int.parse(dr.cells["breakNumber"]?.value.toString() ?? "0");
            row = row + 1;
          }
        }
        completer.complete(true);
        // return true;
      } else {
        completer.complete(true);
        // return true;
      }
    } catch (Exception) {
      completer.complete(false);
      // return false;
    }
    return completer.future;
  }

  bool? checkLostSecondaryEvents() {
    int i;
    List<String> allowedEvents = ["p", "s", "gl"];
    for (i = 0; i < (gridStateManager?.rows.length ?? 0); i++) {
      // for (PlutoRow row in (gridStateManager?.rows)!) {
      PlutoRow? row = gridStateManager?.rows[i];
      String? eventType =
          row?.cells["eventType"]?.value.toString().trim().toLowerCase();
      if (eventType == "gl") {
        if (allowedEvents.contains(gridStateManager
            ?.rows[i - 1].cells["eventType"]?.value
            .toString()
            .trim()
            .toLowerCase())) {
          // gridStateManager.firstDisplayedScrollingRowIndex = i - 12;
          gridStateManager?.moveScrollByRow(
              PlutoMoveDirection.down, (row?.sortIdx)! - 12);
          // tblLog.rows[i].selected = true;
          gridStateManager?.setCurrentCell(row?.cells["no"], row?.sortIdx);
          LoadingDialog.callInfoMessage(
              "Lost secondary event!\nUnable to proceed");
          // logMessage(tblLog.rows[i - 1].cells["rownumber"].value, "Lost secondary event!\nUnable to proceed", "");
          return false;
        }
      }
    }
    return true;
  }

  Future<bool> hasWrongSecondaryEventOffset({bool showMessage = false}) async {
    num? tapeDuration;
    String? eventType;
    bool errors = false;

    for (PlutoRow currentRow in (gridStateManager?.rows)!) {
      eventType =
          currentRow.cells["eventType"]?.value.toString().trim().toLowerCase();

      if (["p", "s"].contains(eventType)) {
        tapeDuration = Utils.oldBMSConvertToSecondsValue(
            value: (currentRow.cells["tapeduration"]?.value ?? ""));
      }

      if (eventType == "gl") {
        if (tapeDuration! <
            Utils.oldBMSConvertToSecondsValue(
                value: currentRow.cells["transmissionTime"]?.value)) {
          errors = true;

          if (showMessage == false) {
            // currentRow.cells["Transmissiontime"]?.style.font = new Font(Control.defaultFont, FontStyle.bold);
            // gridStateManager?.
          } else {
            // currentRow.selected = true;
            // gridStateManager?.firstDisplayedScrollingRowIndex = currentRow.index - 12;
            gridStateManager?.moveScrollByRow(
                PlutoMoveDirection.down, currentRow.sortIdx - 12);
            gridStateManager?.setCurrentCell(
                currentRow.cells["no"], currentRow.sortIdx);

            bool? response = await showDialogForYesNo(
                "Secondary events scheduled with an offset exceeding duration!\nDo you want to proceed?");
            if (response == null) {
              response = false;
            }
            if (!response) {
              break;
            }
          }
        }
      }
    }

    return errors;
  }

  void btnClear_Click() async {
    if (!logSaved) {
      bool? data = await showDialogForYesNo(
          "Log is not saved and all the work done will be lost. Do you want to proceed?");
      print("Data clicked clear");
      if (data != null) {
        if (data) {
          Get.delete<TransmissionLogController>();
          Get.find<HomeController>().clearPage1();
          // html.window.location.reload();
        } else {
          return;
        }
      } else {
        return;
      }
    } else {
      Get.delete<TransmissionLogController>();
      Get.find<HomeController>().clearPage1();
      // html.window.location.reload();
    }
  }

  void search() {
    // Get.delete<TransformationController>();
    Get.to(SearchPage(
        key: Key("TransmissionLog"),
        screenName: "TransmissionLog",
        appBarName: "Transmission Log",
        strViewName: "BMS_VTransmissionLog",
        isAppBarReq: true));
  }

  Future<bool> diffFPCTransmissionTime({int seconds = 0}) async {
    Completer<bool> completer = Completer();
    try {
      // var _dt = tblLog.DataSource;
      if (gridStateManager == null || (gridStateManager?.rows.isEmpty)!) {
        completer.complete(false);
        // return false;
      }
      List<PlutoRow>? eventTypeList = gridStateManager?.rows
          .where((element) =>
              element.cells["eventType"]?.value
                  .toString()
                  .trim()
                  .toLowerCase() ==
              "p")
          .toList();

      if (eventTypeList != null && (eventTypeList.length ?? 0) > 0) {
        String? strFPCTime = '';
        String? strTransmissionTime = '';
        num intFPCTime = 0;
        num intTransmissionTime = 0;
        num Ctr = 0;

        for (PlutoRow dr in eventTypeList) {
          strFPCTime = dr.cells['fpCtime']?.value != null
              ? dr.cells['fpCtime']?.value.toString()
              : '00:00:00';
          intFPCTime = Utils.oldBMSConvertToSecondsValue(value: strFPCTime!);
          strTransmissionTime = dr.cells['transmissionTime']?.value != null
              ? dr.cells['transmissionTime']?.value.toString()
              : '00:00:00';
          intTransmissionTime =
              Utils.oldBMSConvertToSecondsValue(value: strTransmissionTime!);

          if ((intTransmissionTime - intFPCTime).abs() > seconds) {
            // tblLog.FirstDisplayedScrollingRowIndex = dr['rownumber'] - 10;
            gridStateManager?.moveScrollByRow(PlutoMoveDirection.down,
                int.tryParse(dr.cells['rownumber']?.value)! - 10);
            if (int.tryParse(dr.cells['rownumber']?.value)! > 0) {
              // tblLog.Rows[dr['rownumber']].Selected = true;
              gridStateManager?.setCurrentCell(
                  dr.cells["no"], int.tryParse(dr.cells['rownumber']?.value)!);
            } else {
              // tblLog.Rows[0].Selected = true;
              gridStateManager?.setCurrentCell(dr.cells["no"], 0);
            }

            bool? isYes = await showDialogForYesNo(
                "FPC and Transmission time mismatch\nMismatch is ${Utils.convertToTimeFromDouble(value: (intTransmissionTime - intFPCTime).abs())}\nFPC Time: $strFPCTime\nTransmission Time: $strTransmissionTime.\nDo you want to proceed?");
            isYes = isYes ?? false;
            if (!isYes) {
              completer.complete(false);
              // return false;
            }
          }
          Ctr++;
        }
        completer.complete(true);
        // return true;
      } else {
        completer.complete(true);
        // return true;
      }
    } catch (ex) {
      completer.complete(false);
      // return false;
    }

    return completer.future;
  }

  Future<bool> checkRosTransmissionTime({int seconds = 0}) async {
    Completer<bool> completer = Completer();
    if (gridStateManager == null || (gridStateManager?.rows.isEmpty)!) {
      completer.complete(false);
      // return false;
    }
    print("checkRosTransmissionTime clicked");
    num MidStart = 0;
    num Midend = 0;
    var RosTimeBand = '';
    num RosStartTime = 0;
    num RosEndTime = 0;
    List<String> timeband = [];
    num? Telecasttime = 0;

    List<PlutoRow>? rosTimeBandList = gridStateManager?.rows
        .where((element) =>
            element.cells["rosTimeBand"]?.value.toString().trim() != "")
        .toList();
    // print("Length is>> "+(rosTimeBandList?.length??0).toString());
    if ((rosTimeBandList?.length ?? 0) > 0) {
      // var _dt = dt.AsEnumerable().where((x) => x.Field<String>('rostimeband').trim() != '').toList().copyToDataTable();
      for (PlutoRow dr in rosTimeBandList!) {
        RosTimeBand = dr.cells['rosTimeBand']?.value ?? "";
        Telecasttime = Utils.oldBMSConvertToSecondsValue(
                value: (dr.cells['transmissionTime']?.value
                        .toString()
                        .substring(0, 8) ??
                    "")) ??
            0;
        timeband = RosTimeBand.split('-');
        RosStartTime =
            Utils.oldBMSConvertToSecondsValue(value: timeband[0] + ':00') +
                seconds;
        RosEndTime =
            Utils.oldBMSConvertToSecondsValue(value: timeband[1] + ':59') -
                seconds;

        if (RosStartTime > RosEndTime) {
          Midend = Utils.oldBMSConvertToSecondsValue(value: '23:59:59');
          MidStart = 0;
        } else {
          Midend = RosEndTime;
          MidStart = RosEndTime;
        }

        if ((Telecasttime > RosStartTime && Telecasttime < Midend) ||
            (Telecasttime > MidStart && Telecasttime < RosEndTime)) {
          // do nothing
        } else {
          if (seconds == 0) {
            // tblLog.FirstDisplayedScrollingRowIndex = int.tryParse(dr.cells['rownumber']?.value??"")! - 10;
            // tblLog.Rows[dr['rownumber']].Selected = true;
            gridStateManager?.moveScrollByRow(PlutoMoveDirection.down,
                int.tryParse(dr.cells['rownumber']?.value ?? "")!);
            gridStateManager?.setCurrentCell(dr.cells["no"],
                int.tryParse(dr.cells['rownumber']?.value ?? "")!);
            LoadingDialog.callInfoMessage(
                "Ros spot outside contracted timeband!\nUnable to proceed with save");
            completer.complete(false);
            // return false;
          } else {
            // tblLog.FirstDisplayedScrollingRowIndex = dr['rownumber'] - 10;
            // tblLog.Rows[dr['rownumber']].Selected = true;
            gridStateManager?.moveScrollByRow(PlutoMoveDirection.down,
                int.tryParse(dr.cells['rownumber']?.value ?? ""));
            gridStateManager?.setCurrentCell(dr.cells["no"],
                int.tryParse(dr.cells['rownumber']?.value ?? "")!);
            bool? isYesClick = await showDialogForYesNo(
                "Ros spot within 5 minutes of contracted timeband!\nDo you want to proceed with Save?");
            if (isYesClick != null) {
              if (!isYesClick) {
                print("checkRosTransmissionTime(300)>>>>" +
                    dr.sortIdx.toString());
                completer.complete(false);
                // return false;
              }
            } else {}
          }
        }
      }
      print("checkRosTransmissionTime(300)>>>>yes1");
      completer.complete(true);
      // return true;
    } else {
      print("checkRosTransmissionTime(300)>>>>yes2");
      completer.complete(true);
      // return true;
    }
    return completer.future;
  }

  Future<bool> checkBackToBackProducts() {
    Completer<bool> completer = Completer();
    if (gridStateManager == null || (gridStateManager?.rows.isEmpty)!) {
      completer.complete(false);
      // return false;
    }
    int i = 0;
    String lastProduct = '';
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.TRANSMISSION_LOG_GET_BACKTOBACK_PRODUCT(),
        fun: (Map<String, dynamic> map) async {
          List<String> strAllowBackToBackProducts = [];
          if (map is Map && map.containsKey("lstAllowBackToBackProducts")) {
            map["lstAllowBackToBackProducts"].forEach((e) {
              strAllowBackToBackProducts.add(e["productName"]);
            });
          }
          print("List of product is>>" + strAllowBackToBackProducts.toString());
          try {
            for (var dr in (gridStateManager?.rows)!) {
              if (dr.cells['productName']?.value == lastProduct) {
                if (dr.cells['productName']?.value != '') {
                  if (!strAllowBackToBackProducts
                      .contains(dr.cells['productName']?.value + ',')) {
                    // tblLog.FirstDisplayedScrollingRowIndex = dr['rownumber'] - 10;
                    gridStateManager?.moveScrollByRow(PlutoMoveDirection.down,
                        int.tryParse(dr.cells['rownumber']?.value ?? "")! - 10);

                    if (int.tryParse(dr.cells['rownumber']?.value)! > 0) {
                      // tblLog.Rows[dr['rownumber']].Selected = true;
                      gridStateManager?.setCurrentCell(dr.cells["no"],
                          int.tryParse(dr.cells['rownumber']?.value ?? "")!);
                    } else {
                      // tblLog.Rows[0].Selected = true;
                      gridStateManager?.setCurrentCell(dr.cells["no"], 0);
                    }
                    bool? isYesClick = await showDialogForYesNo(
                        "Same Products back to back\nDo you want to proceed with Save?");
                    isYesClick = isYesClick ?? false;
                    if (!isYesClick) {
                      completer.complete(false);
                    }
                  }
                }
              } else {
                lastProduct = dr.cells['productName']?.value;
              }
            }
            completer.complete(true);
            // return true;
          } catch (ex) {
            completer.complete(false);
            // return false;
          }
        },
        failed: (v) {
          completer.complete(true);
        });

    return completer.future;
  }

  Future<bool> checkBackToBackProductGroup() async {
    int i = 0;
    String lastProduct = '';
    // var dt = tblLog.DataSource;
    Completer<bool> completer = Completer();
    if (gridStateManager == null || (gridStateManager?.rows.isEmpty)!) {
      completer.complete(false);
      // return false;
    }
    try {
      for (var dr in (gridStateManager?.rows)!) {
        if (dr.cells['productGroup']?.value == lastProduct) {
          if (dr.cells['productGroup']?.value != '') {
            // tblLog.FirstDisplayedScrollingRowIndex = dr['rownumber'] - 10;
            gridStateManager?.moveScrollByRow(PlutoMoveDirection.down,
                int.tryParse(dr.cells['rownumber']?.value ?? "")! - 10);
            if (int.tryParse(dr.cells['rownumber']?.value)! > 0) {
              // tblLog.Rows[dr['rownumber']].Selected = true;
              gridStateManager?.setCurrentCell(dr.cells["no"],
                  int.tryParse(dr.cells['rownumber']?.value ?? "")!);
            } else {
              // tblLog.Rows[0].Selected = true;
              gridStateManager?.setCurrentCell(dr.cells["no"], 0);
            }

            bool? isYesClick = await showDialogForYesNo(
                "Competing Products back to back\nDo you want to exit with Save?");
            isYesClick = isYesClick ?? false;
            if (isYesClick) {
              completer.complete(false);
            }
          }
        } else {
          lastProduct = dr.cells['productGroup']?.value;
        }
      }
      completer.complete(true);
      // return true;
    } catch (ex) {
      completer.complete(false);
      // return false;
    }
    return completer.future;
  }

  Future<bool>? showDialogForYesNo(String text) {
    Completer<bool> completer = Completer<bool>();
    LoadingDialog.recordExists(
      text,
      () {
        completer.complete(true);
        // return true;
      },
      cancel: () {
        completer.complete(false);
        // return false;
      },
    );
    return completer.future;
  }
}

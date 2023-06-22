import 'dart:convert';
import 'dart:html' as html;
import 'dart:html';

import 'package:bms_scheduling/app/providers/ExportData.dart';
// import 'package:download/download.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';
import 'package:intl/intl.dart';
import '../../../../widgets/Snack.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../data/DropDownValue.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/Utils.dart';
import '../ColorDataModel.dart';
import '../CommercialModel.dart';
import '../InsertSearchModel.dart';
import '../TransmissionLogModel.dart';
import 'dart:html' as html;

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

  //input controllers
  DropDownValue? selectLocation;
  DropDownValue? selectTapeSegmentDialog;
  DropDownValue? selectLocationCopyLog;
  DropDownValue? selectChannel;
  DropDownValue? selectChannelCopyLog;
  DropDownValue? selectEvent;
  DropDownValue? selectTimeForCommercial;
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
  TextEditingController fromReplaceInsert_ = TextEditingController();
  TextEditingController toReplaceInsert_ = TextEditingController();
  TextEditingController fromReplaceIndexInsert_ = TextEditingController();
  TextEditingController toReplaceIndexInsert_ = TextEditingController();
  TextEditingController segmentFpcTime_ = TextEditingController();
  TextEditingController verifyMinTime = TextEditingController();
  TextEditingController txId_Change = TextEditingController();
  TextEditingController txtDate_Reschedule = TextEditingController();
  TextEditingController duration_change = TextEditingController()
    ..text = "00:00:00";
  TextEditingController offset_change = TextEditingController()
    ..text = "00:00:00";
  TextEditingController fpctime_change = TextEditingController()
    ..text = "00:00:00";
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

  @override
  void onInit() {
    super.onInit();
    getLocations();
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

  void getBtnClick_TS({Function? fun}) {
    // LoadingDialog.call();
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
          // Get.back();
          // print("jsonData"+map.toString());
          if (map is Map &&
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
            Utils.dateFormatChange(selectedDate.text, "dd-MM-yyyy", "M/d/yyyy"),
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
    InsertCommercial(
        row?.cells["tonumber"]?.value,
        row?.cells["bookingdetailcode"]?.value,
        row?.cells["Scheduletime"]?.value,
        row?.cells["productname"]?.value,
        (row?.cells["ROsTime"]?.value == null)
            ? ""
            : row?.cells["ROsTime"]?.value,
        row?.cells["Exporttapecaption"]?.value,
        row?.cells["Exporttapecode"]?.value,
        Utils.convertToTimeFromDouble(
            value:
                num.tryParse(row?.cells["Duration"]?.value.toString() ?? "0") ??
                    0),
        row?.cells["som"]?.value);
    gridStateManagerCommercial?.removeCurrentRow();
    // gridStateManager.firstDisplayedScrollingRowIndex = insrow;
  }

  void InsertCommercial(
      String BookingNumber,
      String BookingDetailCode,
      String ScheduleTime,
      String ProductName,
      String ROsTimeBand,
      String ExportTapeCaption,
      String Exporttapecode,
      String Tapeduration,
      String SOM) {
    insertPlutoRow(ScheduleTime, "C ", ExportTapeCaption, Exporttapecode,
        Tapeduration, SOM,
        BreakNumber: 0,
        EpisodeNumber: 0,
        BookingNumber: BookingNumber,
        BookingDetailCode: BookingDetailCode,
        ScheduleTime: ScheduleTime,
        ProductName: ProductName,
        ROsTimeBand: ROsTimeBand);
  }

  insertPlutoRow(String FpcTime, String EventType, String ExportTapeCaption,
      String Exporttapecode, String Tapeduration, String SOM,
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

  void btnReplace_Click(sender, e) {
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
      /*if (showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('You are replacing in all day, want to proceed?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text('Yes'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text('No'),
                ),
              ],
            ),
          ) ==
          true) {
        fromRow = 0;
        toRow = gridStateManager.RowCount - 1;
      } else {
        return;
      }*/

      LoadingDialog.recordExists(
          "You are replacing in all day, want to proceed?",
          () {
            fromRow = 0;
            toRow = gridStateManager?.rows.length ?? 0 - 1;
          },
          deleteTitle: "Yes",
          deleteCancel: "No",
          cancel: () {
            Navigator.pop(Get.context!);
            return;
          });
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
    /*showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$replaceCount replacements made'),
        content: Text('$replaceCount replacements made'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );*/
  }

  void btnFastInsert_Add_Click() {
    int row;
    // int eventdurat;
    blnMultipleGLs = false;
    print(
        "Selected is>>" + (tblFastInsert?.checkedRows.length.toString() ?? ""));
    for (var dr in (tblFastInsert?.checkedRows)!) {
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
          Utils.convertToTimeFromDouble(value: dr.cells["duration"]?.value),
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
    int InsertRow = gridStateManager?.currentRow?.cells["rownumber"]?.value;

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

    gridStateManager?.insertRows(InsertRow + 1, [dr]);
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
        gridStateManager?.rows[intRowIndex].cells[1], intRowIndex);
  }

  void btnReplace_GetEvent_Click() {
    if (gridStateManager?.currentRow == null) return;

    insertDuration_.text =
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

  highlightTSGrid() {
    int intPromoCap, intCommercialCap;
    /*  var _ds = db.ExecuteDataSet("SELECT MaximumSecondsPerHour, PromoCap FROM ChannelSpecs WHERE LocationCode = '${Me.cboLocations.SelectedValue}' AND ChannelCode = '${Me.cboChannels.SelectedValue}'", CommandType.Text);
    for (var dr in _ds.Tables[0].rows) {
      intPromoCap = int.parse(dr["PromoCap"].toString());
      intCommercialCap = int.parse(dr["MaximumSecondsPerHour"].toString());
    }

    for (var dr in tblTS.rows) {
      if (dr.cells["PromoDuration"].value > intPromoCap / 60.0) {
        tblTS.rows[dr.index].cells["PromoDuration"].style.backgroundColor = Colors.red;
      }
      if (dr.cells["CommercialDuration"].value > intCommercialCap / 60.0) {
        tblTS.rows[dr.index].cells["CommercialDuration"].style.backgroundColor = Colors.red;
      }
      if (dr.cells["TotalAdd"].value > (intCommercialCap + intPromoCap) / 60.0) {
        tblTS.rows[dr.index].cells["Totaladd"].style.backgroundColor = Colors.red;
      }
    }

    tblTS.columns[0].width = 90;*/
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
                Utils.dateFormatChange(
                    selectedDate.text, "dd-MM-yyyy", "M/d/yyyy"),
                isStandby.value),
            fun: (map) {
              Get.back();
              if (map is Map) {
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
        if (selectLocation != null && selectChannel != null) {
          Get.find<ConnectorControl>().GETMETHODCALL(
              api: ApiFactory.TRANSMISSION_LOG_MARK_AS_ERROR(
                  selectLocation?.key ?? "",
                  selectChannel?.key ?? "",
                  bookNo,
                  bookCode,
                  selectedDate.text),
              fun: (map) {
                Get.back();
                if (map is Map) {
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
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.TRANSMISSION_LOG_EVENT_LIST(),
        fun: (Map map) {
          Get.back();
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
        "lstgridStateManager": gridStateManager?.rows
            .map((e) => e.toJson1(stringConverterKeys: ["datechange"]))
            .toList()
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
          gridStateManager?.currentRow?.cells["transmissionTime"]?.value;
      visibleChangeDuration.value = true;
      duration_change.text =
          gridStateManager?.currentRow?.cells["tapeduration"]?.value;
      fpctime_change.text =
          gridStateManager?.currentRow?.cells["fpCtime"]?.value + ":00";
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
          gridStateManager?.currentRow?.cells["transmissionTime"]?.value;
      duration_change.text =
          gridStateManager?.currentRow?.cells["tapeduration"]?.value;
      fpctime_change.text =
          gridStateManager?.currentRow?.cells["fpCtime"]?.value + ":00";
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
    List<int> dtSTD = [];
    String rosStart;
    String RosEnd;
    String MidRosEnd;
    String MidRosStart;
    String TxTime;
    int CurrentRowIndex;
    String CurrentProduct;
    String IsCommercial;
    String CurrentProductGroup;
    String CurrentTape;
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
        // if (strFPCTime != bsPeople?.rows[intCurrentRowIndex[0]]["FPCTime"].toString()) {
        if (strFPCTime !=
            gridStateManager
                ?.rows[intCurrentRowIndex[0]].cells["fpCtime"]?.value
                .toString()) {
          showDialog(
            context: Get.context!,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Alert"),
                content: Text(
                    "You cannot move selected commercial from $strFPCTime FPCTime to ${gridStateManager?.rows[intCurrentRowIndex[0]].cells["fpCtime"]?.value} FPCTime."),
                actions: [
                  TextButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
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
    calculateTransmissionTime();
    // dtSTD[1] = DateTime.now().millisecondsSinceEpoch;

    updateRowNumber();
    // dtSTD[2] = DateTime.now().millisecondsSinceEpoch;
    // }
    // colorGrid(false);
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
        LoadingDialog.callInfoMessage("We couldn't copy this row");
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
    // gridStateManager.filteredCellValue(column: column)
    gridStateManager
        ?.setFilter((element) => element.cells[filterKey]?.value == matchValue);
  }

  dataGridRowFilterCommercial(
      {required String matchValue, required String filterKey}) {
    // gridStateManager.filteredCellValue(column: column)
    gridStateManagerCommercial
        ?.setFilter((element) => element.cells[filterKey]?.value == matchValue);
  }

  void _download() async {
    String data = await jsonEncode(gridStateManager?.rows.map((e) => e.toJson()).toList());
    // final stream = await Stream.fromIterable(data!.codeUnits);
    // download(stream, 'hello.txt');
    // final FileSystemAccessHandle? handle = await html.window.();
    // if (handle != null) {
      // Permission granted, continue with folder creation
    // } else {
      // Permission denied, handle accordingly
    // }

    ExportData().exportFilefromString(data,"lib/hello.txt");
  }

  void selectFolder() async {
   /* final html.InputElement uploadInput = InputElement();
    uploadInput.type = 'file';
    uploadInput.multiple = true;
    uploadInput.directory = true;
    uploadInput.click();

    await uploadInput.onChange.first;

    // final directoryHandle = await uploadInput.getDirectoryHandle();
    final directoryHandle = await uploadInput.getDirectoryHandle();
    if (directoryHandle != null) {
      // Folder selected, continue with file operations
    } else {
      // No folder selected or error occurred
    }*/
  }


  void btnSave_Click(sender, e) async {
    int replaceCount = 0;
    // String strMessageLogFileName = "${Directory.current.path}\\MessageLogFiles\\${cboLocations.text}_${cboChannels.text}_${DateFormat('yyyyMMdd').format(txtDate.value)}.txt";
    try {
      // tblLog.MyDataGridRowFilter(true, false);
      colorGrid(false);
   /*   DataTable dt = tblLog.DataSource;

      tblLog.currentCell = null;
      if (!CheckPromoTags()) {
        Cursor = Cursors.Default;
        return;
      } else {
        UnSelectAllRows(tblLog);
      }

      if (!ProgramSequenceValidation()) {
        Cursor = Cursors.Default;
        return;
      }

      if (!CheckLostSecondaryEvents()) {
        Cursor = Cursors.Default;
        return;
      }

      if (HasWrongSecondaryEventOffset(true)) {
        if (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
                'Secondary events Scheduled beyond primary event Duration!'),
            content: Text('Do you want to proceed?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text('Yes'),
              ),
            ],
          ),
        )) {
          Cursor = Cursors.Default;
          return;
        }
      }

      tblLog.currentCell = null;
      if (!CHeckRosTransmissionTime()) {
        Cursor = Cursors.Default;
        return;
      }

      tblLog.currentCell = null;
      if (!Diff_FPC_Transmission_Time(MaxProgramStarttimeDiff)) {
        Cursor = Cursors.Default;
        return;
      } else {
        UnSelectAllRows(tblLog);
      }

      tblLog.currentCell = null;
      if (!CheckBackToBackProducts()) {
        Cursor = Cursors.Default;
        return;
      } else {
        UnSelectAllRows(tblLog);
      }
      tblLog.currentCell = null;
      if (!CheckBackToBackproductGroup()) {
        Cursor = Cursors.Default;
        return;
      } else {
        UnSelectAllRows(tblLog);
      }

      tblLog.currentCell = null;
      if (!CHeckRosTransmissionTime(300)) {
        Cursor = Cursors.Default;
        return;
      }*/

      /*Cursor = Cursors.WaitCursor;

      var query = tblLog.Rows.cast<DataGridRow>().map((t) =>
      {
        "RowIndex": t.Index,
        "FPCTime": "${t.Cells["FPCTime"].Value}",
        "TransmissionTime": "${t.Cells["TransmissionTime"].Value}",
        "ExportTapeCaption": "${t.Cells["ExportTapeCaption"].Value}",
        "ExportTapeCode": "${t.Cells["ExportTapeCode"].Value}",
        "TapeDuration": "${t.Cells["TapeDuration"].Value}",
        "SOM": "${t.Cells["SOM"].Value}",
        "EventType": "${t.Cells["EventType"].Value}",
        "BreakEvent": "${t.Cells["BreakEvent"].Value}",
        "BreakNumber": t.Cells["BreakNumber"].Value ?? 0,
        "EpisodeNumber": t.Cells["EpisodeNumber"].Value ?? 0,
        "BookingNumber": "${t.Cells["BookingNumber"].Value}",
        "BookingDetailCode": t.Cells["BookingDetailCode"].Value ?? 0,
        "datechange": t.Cells["datechange"].Value ?? 0
      }).toList();

      DataTable _dt = LINQToDataTable(query);

      db.AddParameter("@locationcode", cboLocations.selectedValue);
      db.AddParameter("@channelcode*/
    } catch (e) {}
  }
}

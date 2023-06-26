import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:bms_scheduling/app/controller/HomeController.dart';
import 'package:bms_scheduling/app/providers/ExportData.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:file_picker/file_picker.dart';
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

  RxnString selectExportType = RxnString("Excel");

  ExportFPCTimeModel? exportFPCTime;

  @override
  void onInit() {
    super.onInit();
    getLocations();
  }

  pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ["json"],
      dialogTitle: "Select import file",
      type: FileType.custom,
    );

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
        colorGrid(false);
      } else {
        LoadingDialog.callInfoMessage("No Data Found");
      }
    } else {}
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
  }

  void btnExportClick(type) async {
    bool? isDone =
        await showDialogForYesNo("Do you want to add secondary event?");
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.TRANSMISSION_LOG_EXPORT_CLICK(
            selectLocation?.key ?? "",
            selectChannel?.key ?? "",
            selectedDate.text,
            selectLocation?.value ?? "",
            selectChannel?.value ?? "",
            gridStateManager?.currentRowIdx ?? 0,
            "00:00",
            isDone!,
            "GetWriteOLDExcel"),
        fun: (map) {
          Get.back();
          if (map is Map && map.containsKey("outExportDataClick")) {
            String outputFormat = map["outExportDataClick"]["outputFormat"];
            String strFilePrefix = map["outExportDataClick"]["strFilePrefix"];
            String filechannel = map["outExportDataClick"]["filechannel"];
            logWrite(strFilePrefix + outputFormat.split("|")[1]);
          } else {}
        });
  }

  void logWrite(String fileName) async {
    // bool? isDone = await showDialogForYesNo("Do you want to add secondary event?");
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.TRANSMISSION_LOG_WRITE_OLDEXCEL(
            selectLocation?.key ?? "",
            selectChannel?.key ?? "",
            selectedDate.text,
            isStandby.value,
            fileName ?? ""),
        fun: (map) {
          Get.back();
          // print("Data>>>>"+map.toString());
          ExportData().exportFilefromBase64(map, fileName);
        });
  }

  String? getExportMethod(String type) {
    switch (type) {
      case "Excel":
        return "";
      case "Excel":
        return "";
      case "Excel":
        return "";
      case "Excel":
        return "";
      case "Excel":
        return "";
      case "Excel":
        return "";
      case "Excel":
        return "";
      case "Excel":
        return "";
      case "Excel":
        return "";
      case "Excel":
        return "";
      case "Excel":
        return "";
    }
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

    ExportData().exportFilefromString(jsonEncode(map), "lib_hello.json");
  }

  /*void btnSave_Click(sender, e) {
    DataTable dt = new DataTable();
    strMessageLogFileName = Application.startupPath + "\\MessageLogFiles\\" + (cboLocations.text + "_" + cboChannels.text + "_" + DateTime.parse(txtDate.value.toString()).toString("yyyyMMdd")).replaceAll(" ", "_") + ".txt";

    try {
      gridStateManager.myDataGridRowFilter(true, false);
      colorGrid(false);
      dt = gridStateManager.dataSource;

      gridStateManager.currentCell = null;
      if (!checkPromoTags()) {
        cursor = Cursors.default;
    return;
    } else {
    unselectAllRows(gridStateManager);
    }

    if (!programSequenceValidation()) {
    cursor = Cursors.default;
    return;
    }

    if (!checkLostSecondaryEvents()) {
    cursor = Cursors.default;
    return;
    }

    if (hasWrongSecondaryEventOffset(true)) {
    if (showMessageBox("Secondary events Scheduled beyond primary event Duration!\nDo you want to proceed?", MessageBoxType.warning, MessageBoxButtons.yesNo, MessageBoxDefaultButton.button2) == DialogResult.no) {
    cursor = Cursors.default;
    return;
    }
    }

    gridStateManager.currentCell = null;
    if (!checkRosTransmissionTime()) {
    cursor = Cursors.default;
    return;
    }

    gridStateManager.currentCell = null;
    if (!diffFpcTransmissionTime(maxProgramStarttimeDiff)) {
    cursor = Cursors.default;
    return;
    } else {
    unselectAllRows(gridStateManager);
    }

    gridStateManager.currentCell = null;
    if (!checkBackToBackProducts()) {
    cursor = Cursors.default;
    return;
    } else {
    unselectAllRows(gridStateManager);
    }

    gridStateManager.currentCell = null;
    if (!checkBackToBackProductGroup()) {
    cursor = Cursors.default;
    return;
    } else {
    unselectAllRows(gridStateManager);
    }

    gridStateManager.currentCell = null;
    if (!checkRosTransmissionTime(300)) {
    cursor = Cursors.default;
    return;
    }

    cursor = Cursors.waitCursor;

    var query = (from t in gridStateManager.rows.Cast<DataGridRow>()
    select new {
    RowIndex = t.index,
    FPCTime = t.cells["FPCTime"].value.toString(),
    TransmissionTime = t.cells["TransmissionTime"].value.toString(),
    ExportTapeCaption = t.cells["ExportTapeCaption"].value.toString(),
    ExportTapeCode = t.cells["ExportTapeCode"].value.toString(),
    TapeDuration = t.cells["TapeDuration"].value.toString(),
    SOM = t.cells["SOM"].value.toString(),
    EventType = t.cells["EventType"].value.toString(),
    BreakEvent = t.cells["BreakEvent"].value.toString(),
    BreakNumber = t.cells["BreakNumber"].value == null ? 0 : Convert.toInt(t.cells["BreakNumber"].value),
    EpisodeNumber = t.cells["EpisodeNumber"].value == null ? 0 : Convert.toInt(t.cells["EpisodeNumber"].value),
    BookingNumber = t.cells["BookingNumber"].value.toString(),
    BookingDetailCode = t.cells["BookingDetailCode"].value == null ? 0 : Convert.toInt(t.cells["BookingDetailCode"].value),
    DateChange = t.cells["datechange"].value == null ? 0 : Convert.toInt(t.cells["datechange"].value)
    }).toList();

    DataTable _dt = linqToDataTable(query);

    db.addParameter("@locationcode", cboLocations.selectedValue);
    db.addParameter("@channelcode", cboChannels.selectedValue);
    db.addParameter("@telecastdate", DateTime.parse(txtDate.value.toString()).date);
    db.addParameter("@modifiedby", BMS.loggedUser);
    db.addParameter("@standbyLog", chkStandBy.checked);
    db.addParameter("@dt", _dt);
    db.ExecuteNonQuery("BMS_Save_transmissionLog", CommandType.storedProcedure);
    logSaved = true;
    showMessageBox("Log Saved", MessageBoxType.information);
    logMessage(0, "Log Saved", "");

    if (File.exists(strMessageLogFileName)) {
    process.start(strMessageLogFileName);
    }

    cursor = Cursors.default;
    // } catch (SqlClient.SqlException ex) {
    //   showMessageBox(ex.message);
    } catch (Exception ex) {
    cursor = Cursors.default;
    showMessageBox(errorLog(ex.message, BMS.globals.loggedUser, this), MessageBoxType.critical, strAlertMessageTitle);
    }
  }*/

  Future<bool>? checkPromoTags() {
    String strTapeCode;
    if (selectLocation != null && selectChannel != null) {
      LoadingDialog.call();
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.TRANSMISSION_LOG_CHECK_PROMOTAGS(
              selectLocation?.key ?? "",
              selectChannel?.key ?? "",
              Utils.dateFormatChange(
                  selectedDate.text, "dd-MM-yyyy", "M/d/yyyy"),
              isStandby.value),
          fun: (map) async {
            Get.back();
            if (map is Map) {
              if (map.containsKey("lstCheckPromoTags") &&
                  map["lstCheckPromoTags"] != null) {
                CheckPromoTagModel data =
                    CheckPromoTagModel.fromJson(map as Map<String, dynamic>);
                // List<dynamic> _dt = map["lstCheckPromoTags"];
                for (PlutoRow dr in (gridStateManager?.rows)!) {
                  strTapeCode = dr.cells["ExportTapeCode"]?.value;
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
                                .cells["ExportTapeCode"]
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
                                .cells["ExportTapeCode"]?.value
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
                              "Promo & Tag mismatch! Tape ID: ${dr.cells["exporttapecode"]?.value} on row number: ${dr.cells["rownumber"]?.value}\nDo you want to proceed with Save?");
                          if (data == null) {
                            data = false;
                          }
                          if (!data) {
                            return false;
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
                          "Promo & Tag mismatch! Tape ID: ${dr.cells["exporttapecode"]?.value} on row number: ${dr.cells["rownumber"]?.value}\nDo you want to proceed with Save?");
                      if (data == null) {
                        data = false;
                      }
                      if (!data) {
                        return false;
                      }
                    }
                    // }
                  }
                }
                return true;
              } else {
                return true;
              }
            } else {
              return false;
            }
          },
          failed: (map) {
            return false;
          });
    }
  }

  Future<bool> programSequenceValidation() async {
    try {
      int row = 0;
      // DataTable _dt = tblLog.dataSource;

      if (gridStateManager == null) {
        LoadingDialog.callInfoMessage("Nothing To save");
        return false;
      }

      // List<PlutoRow> query = _dt.select((x) => x["EventType"].trim() == "P" || x["EventType"].trim() == "S").toList();
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
            if (dr.cells["exporttapecode"]?.value?.toLowerCase() != "tba" &&
                dr.cells["exporttapecode"]?.value?.toLowerCase() != "news" &&
                dr.cells["exporttapecode"]?.value?.toLowerCase() != "live") {
              if (strTapeID == dr.cells["exporttapecode"]?.value.toString()) {
                if (intSegmentNumber >
                    int.parse(
                        dr.cells["breaknumber"]?.value.toString() ?? '')) {
                  // gridStateManager.firstDisplayedScrollingRowIndex = int.parse(dr["rownumber"].toString()) - 10;
                  gridStateManager?.moveScrollByRow(PlutoMoveDirection.down,
                      int.parse(dr.cells["rownumber"]?.value)! - 10);
                  // tblLog.rows[int.parse(dr.cells["rownumber"]?.value)].selected = true;
                  gridStateManager?.setCurrentCell(
                      dr.cells["no"], int.parse(dr.cells["rownumber"]?.value));
                  bool? data = await showDialogForYesNo(
                      "Program sequence mismatch on Tape ID: $strTapeID between Segment Numbers:  $intSegmentNumber and ${int.parse(dr.cells["BreakNumber"]?.value.toString() ?? "0")}\nExit Save?");
                  if (data == null) {
                    data = false;
                  }
                  if (data) {
                    return false;
                  }
                }
              } else {
                strTapeID = dr.cells["exporttapecode"]?.value.toString();
                if (strTapeID == "tba" ||
                    strTapeID == "live" ||
                    strTapeID == "news") {
                  strTapeID = "z y x w v u";
                }
              }
            }
            intSegmentNumber =
                int.parse(dr.cells["breaknumber"]?.value.toString() ?? "0");
            row = row + 1;
          }
        }
        return true;
      } else {
        return true;
      }
    } catch (Exception) {
      return false;
    }
  }

  bool checkLostSecondaryEvents() {
    int i;
    List<String> allowedEvents = ["p", "s", "gl"];
    for (PlutoRow row in (gridStateManager?.rows)!) {
      String? eventType =
          row.cells["eventType"]?.value.toString().trim().toLowerCase();
      if (row.cells["eventtype"]?.value.toString().trim().toLowerCase() ==
          "gl") {
        if (allowedEvents.contains(eventType)) {
          // gridStateManager.firstDisplayedScrollingRowIndex = i - 12;
          gridStateManager?.moveScrollByRow(
              PlutoMoveDirection.down, row.sortIdx - 12);
          // tblLog.rows[i].selected = true;
          gridStateManager?.setCurrentCell(row.cells["no"], row.sortIdx);
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
      eventType = currentRow.cells["Eventtype"]?.value.toString().trim();

      if (eventType == "S" || eventType == "P") {
        tapeDuration = Utils.oldBMSConvertToSecondsValue(
            value: (currentRow.cells["Tapeduration"]?.value ?? ""));
      }

      if (eventType == "GL") {
        if (tapeDuration! <
            Utils.oldBMSConvertToSecondsValue(
                value: currentRow.cells["Transmissiontime"]?.value)) {
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
        } else {
          return;
        }
      } else {
        return;
      }
    } else {
      Get.delete<TransmissionLogController>();
      Get.find<HomeController>().clearPage1();
    }
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

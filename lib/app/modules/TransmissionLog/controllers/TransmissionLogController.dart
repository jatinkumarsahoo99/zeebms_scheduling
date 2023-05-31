import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';
import '../../../../widgets/Snack.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../data/DropDownValue.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/Utils.dart';
import '../ColorDataModel.dart';
import '../TransmissionLogModel.dart';

class TransmissionLogController extends GetxController {
  var locations = RxList<DropDownValue>();
  var channels = RxList<DropDownValue>([]);
  RxBool isEnable = RxBool(true);
  List<Map<String, List<PlutoRow>>> logDeletedEvent1 = [];

  //input controllers
  DropDownValue? selectLocation;
  DropDownValue? selectChannel;
  PlutoGridStateManager? gridStateManager;

  // PlutoGridMode selectedPlutoGridMode = PlutoGridMode.normal;
  var isStandby = RxBool(false);
  var isMy = RxBool(true);
  var isInsertAfter = RxBool(false);
  var isRowFilter = RxBool(false);
  TextEditingController selectedDate = TextEditingController();
  TextEditingController startTime_ = TextEditingController();
  TextEditingController offsetTime_ = TextEditingController();
  TextEditingController txtDtChange = TextEditingController();
  TextEditingController txtTransmissionTime = TextEditingController();
  TextEditingController txId_ = TextEditingController();
  TextEditingController txCaption_ = TextEditingController();
  TextEditingController insertDuration_ = TextEditingController();
  TextEditingController segmentFpcTime_ = TextEditingController();

  TransmissionLogModel? transmissionLog;
  PlutoGridMode selectedPlutoGridMode = PlutoGridMode.selectWithOneTap;
  int? selectedIndex;
  RxnString verifyType = RxnString();
  RxList<DropDownValue> listLocation = RxList([]);
  RxList<DropDownValue> listChannel = RxList([]);
  RxList<ColorDataModel> listColor = RxList([]);
  num maxProgramStarttimeDiff = 0;

  // bool chkTxCommercial = false;
  var chkTxCommercial = RxBool(false);
  bool logSaved = false;

  // PlutoRow? cutRow;
  PlutoRow? copyRow;
  String? lastSelectOption;

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

  getChannelFocusOut() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.TRANSMISSION_LOG_CHANNEL_SPEC_SETTING(
          selectLocation?.key ?? "",
          selectChannel?.key ?? "",
        ),
        fun: (Map<String, dynamic> map) {
          chkTxCommercial.value =
              map["channelSpecsSettings"]["chkTxCommercial"];
          maxProgramStarttimeDiff =
              map["channelSpecsSettings"]["maxProgramStarttimeDiff"];
        });
  }

  getColorList() {
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
            callRetrieve();
          });
    }
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
              update(["transmissionList"]);
              colorGrid(false);
            }
          });
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
                      value: transmissionLog?.loadSavedLogOutput
                              ?.lstTransmissionLog![0].transmissionTime ??
                          "00:00:00:00") -
                  Utils.oldBMSConvertToSecondsValue(value: selectedDate.text)))
              .abs());
    } else {
      offsetTime_.text = "00:00:00:00";
    }
  }

  calculateTransmissionTime() {
    if (transmissionLog != null &&
        transmissionLog?.loadSavedLogOutput != null &&
        transmissionLog?.loadSavedLogOutput?.lstTransmissionLog != null &&
        ((transmissionLog?.loadSavedLogOutput?.lstTransmissionLog?.length ??
                0) !=
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
    // DataTable gridStateManager = tblLog.dataSource;
    for (PlutoRow dr in (gridStateManager?.rows)!) {
      String? strEventType = "";
      if (i > 0) {
        strEventType = gridStateManager?.rows[i].cells["eventType"]?.value
            .toString()
            .trim()
            .toLowerCase();
        if (strEventType != "gl") {
          secondaryEventCtr = 0;
          if (num.tryParse(dr.cells["transmissionTime"]?.value.substring(0, 2)!)! <
              num.tryParse(gridStateManager
                      ?.rows[strLastEventRowNumber].cells["transmissionTime"]?.value
                      .toString()
                      .substring(0, 2) ??
                  "0")!) {
            datechange = datechange + 1;
          }
          hr = (datechange * 24) +
              num.parse(
                  dr.cells["transmissionTime"]?.value.toString().substring(0, 2) ??
                      "0");
        } else {
          secondaryEventCtr = secondaryEventCtr + 1;
          if (dr.cells["transmissionTime"]?.value
                  .toString() ==
              "") {
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

      dr.cells["rownumber"]?.value = i;
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
          gridStateManager?.rows[i].cells["datechange"]?.value ==
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
      dtSTD[0] = DateTime.now().millisecondsSinceEpoch;
      if (!dontSavefile) {
        calculateTransmissionTime();
        dtSTD[1] = DateTime.now().millisecondsSinceEpoch;

        updateRowNumber();
        dtSTD[2] = DateTime.now().millisecondsSinceEpoch;
      }

      dtSTD[3] = DateTime.now().millisecondsSinceEpoch;
      String strPriority;
      String FPcTime = "";

      // gridStateManager
      /*for (PlutoRow currentRow in (gridStateManager?.rows)!) {
        CurrentRowIndex = currentRow.sortIdx;
        CurrentProduct = (currentRow.cells["productname"]?.value ?? "" + "");
        if ((((currentRow.cells["Eventtype"]?.value ?? "" + "")).Trim() ==
            "C")) {
          CurrentTape = (currentRow.cells["exporttapecode"]?.value + "");
        }
        else {
          CurrentTape = "";
        }

        CurrentProductGroup = (currentRow.cells["productgroup"]?.value + "");
        String eventtype = currentRow.cells["EventType"]?.value.ToString.Trim();
        //                 If eventtype = "P" Then
        //  eventtype = "S"
        // End If
        if (GridColour.GridColorOptions.ContainsKey(eventtype)) {
          ColorCombo currentColor = GridColour.GridColorOptions(eventtype);
          currentRow.Defaultcellstyle.ForeColor = currentColor.GetForeColor;
          currentRow.Defaultcellstyle.BackColor = currentColor.GetBackColor;
          // gridStateManager.
          if ((FPcTime == currentRow.cells["FPCtime"]?.value)) {
            currentRow.cells["FPCTime"].Style.ForeColor =
                currentColor.GetBackColor;
          }
          else {
            FPcTime = currentRow.cells["FPCTime"]?.value;
          }
        }
        else {
          currentRow.Defaultcellstyle.ForeColor = Color.Black;
          currentRow.Defaultcellstyle.BackColor = Color.White;
          if ((FPcTime == currentRow.cells["FPCtime"]?.value)) {
            currentRow.cells["FPCTime"].Style.ForeColor = Color.White;
          }
          else {
            FPcTime = currentRow.cells["FPCTime"]?.value;
          }
        }

        if ((eventtype.trim() == "P")) {
          var strFPCTime = (((currentRow.cells["FPCTime"]?.value) ?? "00:00:00")
              .toString());
          var intFPCTime = Utils.oldBMSConvertToSecondsValue(value: strFPCTime);
          var strTransmissionTime = (((currentRow.cells["TransmissionTime"]
              ?.value) ?? "00:00:00").toString());
          var intTransmissionTime = Utils.oldBMSConvertToSecondsValue(
              value: strTransmissionTime);
          if ((((intTransmissionTime - intFPCTime)).abs() >
              maxProgramStarttimeDiff)) {
            currentRow.cells["Transmissiontime"].Style.Font =
            new Font(Control.DefaultFont, FontStyle.Bold);
          }
        }

        if ((CurrentProduct != "")) {
          // if current row is a commercial then check for out of timeband and back to back products
          strPriority =
          (currentRow.cells["BookingNumber"]?.value.ToString.Trim() +
              currentRow.cells["BookingDetailCode"]?.value.ToString.Trim());
          // spot priority only for commericals
          if ((strPriority != "")) {
            if (GridColour.GridColorOptions.ContainsKey(strPriority)) {
              ColorCombo currentColor = GridColour.GridColorOptions(
                  strPriority);
              currentRow.Defaultcellstyle.ForeColor = currentColor.GetForeColor;
              currentRow.Defaultcellstyle.BackColor = currentColor.GetBackColor;
              if ((currentRow.Index != 0)) {
                if ((currentRow.cells["FPCTime"]?.value ==
                    tblLog.Rows[(currentRow.Index - 1)].cells["fpctime"]
                        ?.value)) {
                  currentRow.cells["FPCTime"].Style.ForeColor =
                      currentColor.GetBackColor;
                }
              }
            }
          }

          // Checking Same product back to back
          if ((CurrentProduct != "")) {
            if ((CurrentRowIndex
                < ((gridStateManager?.rows.length)! - 2))) {
              if ((((CurrentProduct ==
                  (gridStateManager?.rows[(CurrentRowIndex + 1)]
                      .cells["productname"]
                      ?.value)
                      + ""))
                  || ((CurrentProduct ==
                      (gridStateManager?.rows[(CurrentRowIndex + 2)]
                          .cells["productname"]
                          ?.value)
                          + "")))) {
                // currentRow.cells["productname"].Style.Font =
                // new Font(Control.DefaultFont, FontStyle.Bold);
                currentRow.cells["productname"] =
                new Font(Control.DefaultFont, FontStyle.Bold);
              }
            }
          }

          // Checking Same Tape back to back
          if ((CurrentTape != "")) {
            if ((CurrentRowIndex
                < ((gridStateManager?.rows.length)! - 2))) {
              if ((((CurrentTape ==
                  (gridStateManager?.rows[(CurrentRowIndex + 1)]
                      .cells["exporttapecode"]
                      ?.value)
                      + ""))
                  || ((CurrentTape ==
                      (gridStateManager?.rows[(CurrentRowIndex + 2)]
                          .cells["exporttapecode"]
                          ?.value)
                          + "")))) {
                currentRow.cells["Exporttapecode"].Style.Font =
                new Font(Control.DefaultFont, FontStyle.Bold);
              }
            }
          }

          // Checking PRoduct Group back to back
          if ((CurrentProductGroup != "")) {
            if ((CurrentRowIndex
                < ((gridStateManager?.rows.length)! - 2))) {
              if ((((CurrentProductGroup ==
                  (gridStateManager?.rows[(CurrentRowIndex + 1)]
                      .cells["productgroup"]
                      ?.value)
                      + ""))
                  || ((CurrentProductGroup ==
                      (gridStateManager?.rows[(CurrentRowIndex + 2)]
                          .cells["productgroup"]
                          ?.value)
                          + "")))) {
                currentRow.cells["ProductGroup"].Style.Font =
                new Font(Control.DefaultFont, FontStyle.Bold);
              }
            }
          }

          // 'Dim rosStart As String, RosEnd As String, MidRosEnd As String, MidRosStart As String, TxTime As String
          List<String> ros = [];
          if ((currentRow.cells["ROStimeBand"]?.value != "")) {
            ros = currentRow.cells["ROStimeBand"]?.value.Split("-");
            rosStart = (ros[0] + ":00");
            RosEnd = (ros[1] + ":00");
            // if ((rosStart > RosEnd)) {
            if ((rosStart.compareTo(RosEnd) == 1)) {
              MidRosEnd = "23:59:59";
              MidRosStart = "00:00:00";
            }
            else {
              MidRosEnd = RosEnd;
              MidRosStart = RosEnd;
            }

            TxTime =
                currentRow.cells["Transmissiontime"]?.value.ToString.SubString(
                    0, 8);
            if ((((TxTime.compareTo(rosStart) == 1 )
                && (TxTime < MidRosEnd))
                || ((TxTime > MidRosStart)
                    && (TxTime < MidRosEnd)))) {
              if ((((TxTime.compareTo(rosStart) == 1)
                  && (MidRosEnd.compareTo(TxTime) == 1))
                  || ((TxTime.compareTo(MidRosStart) == 1)
                      && (MidRosEnd.compareTo(TxTime) == 1)))) {

              }
              else {
                currentRow.cells["RosTimeBand"].Style.Font =
                new Font(Control.DefaultFont, FontStyle.Bold);
              }
            }
          }
        }
      }*/

      dtSTD[3] = DateTime.now().millisecondsSinceEpoch;
      // If tblLog.Columns.Contains("longcaption") Then
      // tblLog.Columns["longcaption"].Width = 375;
      // DRR : Sports This being the last column, its not allowing to extend the column width.
      // End If
      // tblLog.FirstDisplayedScrollingRowIndex = r
      // Cursor = Cursors.Default
    } catch (ex) {
      // MsgBox(ex.Message);
    } finally {
      /* tblLog.PerformLayout();
      if ((DontSavefile == false)) {
        SaveFile();
        dtSTD[4] = DateTime
            .now()
            .millisecondsSinceEpoch;
        // changedRows(Changecounter) = tblLog.FirstDisplayedScrollingRowIndex
        if (!(tblLog.CurrentRow == null)) {
          changedRows(Changecounter) =
              tblLog.CurrentRow.cells["rownumber"]?.value;
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
      tblLog.Rows[intCurrentRowIndex(1)].cells[0].Selected = true;
      tblLog.CurrentCell = tblLog.Rows[intCurrentRowIndex(1)].cells[0];
      tblLog.FirstDisplayedScrollingRowIndex = intCurrentRowIndex(3);
      intCurrentRowIndex(0) = -1;
    }
    else {
      tblLog.Rows[intCurrentRowIndex(0)].cells[0].Selected = true;
      tblLog.CurrentCell = tblLog.Rows[intCurrentRowIndex(0)].cells[0];
      tblLog.FirstDisplayedScrollingRowIndex = intCurrentRowIndex(3);
    }

    intCurrentRowIndex(0) = -1;
    intCurrentRowIndex(3) = -1;
    dtSTD[6] = DateTime
        .now()
        .millisecondsSinceEpoch;*/
  }

  /*void getDuplicateBookingNumber() {
    try {
      List<PlutoRow> filterList = gridStateManager.

      Pivot pivot = Pivot(_dt);
      DataTable ddss = (pivot.multiAggregate(
          ["rownumber", "Exporttapecode"],
          [AggregateFunction.min, AggregateFunction.count],
          ["Bookingnumber", "bookingdetailcode"]
      )).select("exporttapecode<>1").copyToDataTable();

      for (DataRow q in ddss.rows) {
        tblLog.firstDisplayedScrollingRowIndex = q["rownumber"];
        tblLog.rows[q["rownumber"]].selected = true;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Duplicate Booking"),
              content: Text("Duplicate BookingNumber: ${q["BookingNumber"]} and BookingDetailCode: ${q["BookingDetailCode"]} and RowNumber: ${q["RowNumber"]} found & deleted."),
              actions: [
                TextButton(
                  child: Text("No"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    return;
                  },
                ),
                TextButton(
                  child: Text("Yes"),
                  onPressed: () {
                    deleteRowFromLog(int.parse(q["rownumber"].toString()));
                    colorGrid(false);
                    Navigator.of(context).pop();
                    return;
                  },
                ),
              ],
            );
          },
        );
        return;
      }
    } catch (e) {
      // handle exception
    }
  }*/

  onDragCall() {}

  dataGridView1_DragDrop(index, PlutoRow plutoRow, Function function) {
    int roy;
    int? movedRowIndex =
        gridStateManager?.rows.indexWhere((element) => element == plutoRow);
    // int intFirstRow = index;
    int up = 0;
    // Point clientPoint = tblLog.pointToClient(Point(e.x, e.y));
    List<int> intCurrentRowIndex = List.filled(4, 0).toList();

    intCurrentRowIndex[0] = index;
    intCurrentRowIndex[1] = int.tryParse(gridStateManager
            ?.rows[intCurrentRowIndex[0]].cells["rownumber"]?.value) ??
        0;
    intCurrentRowIndex[2] = int.tryParse(gridStateManager
            ?.rows[intCurrentRowIndex[0]].cells["rownumber"]?.value) ??
        0;
    intCurrentRowIndex[3] = movedRowIndex!;

    List<PlutoRow>? bsPeople = gridStateManager?.rows;
    PlutoRow rowToMove = plutoRow;
    String strEventType = "", strRosTimeBand = "", strFPCTime = "";

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
                    "You cannot move selected commercial from $strFPCTime FPCTime to ${gridStateManager?.rows[intCurrentRowIndex[0]].cells["fpCtime"]} FPCTime."),
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

    PlutoRow row = rowToMove;
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
      // row.cells["fpCtime"] = bsPeople.rows[tblLog.rows[rowToMove?.index].cells["rownumber"].value]["fpCtime"];
      row.cells["fpCtime"]?.value =
          gridStateManager?.rows[movedRowIndex].cells["fpCtime"]?.value;
    }
    gridStateManager?.insertRows(intCurrentRowIndex[0], [row]);

    if (gridStateManager?.rows.length == movedRowIndex + 1) {
      // gridStateManager.rows.removeAt(tblLog.rows[rowToMove.index].cells["rownumber"].value + 1);
      PlutoRow? row = gridStateManager?.rows[movedRowIndex];
      gridStateManager?.removeRows([row!]);
    } else {
      // bsPeople.rows.removeAt(tblLog.rows[rowToMove.index + up].cells["rownumber"].value);
      gridStateManager?.removeRows([plutoRow]);
    }

    if (up == 0) {
      intCurrentRowIndex[0] = intCurrentRowIndex[0] - 1;
    }
    // }
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
}

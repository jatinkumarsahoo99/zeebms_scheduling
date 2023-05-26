import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../../widgets/Snack.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../data/DropDownValue.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/Utils.dart';
import '../ColorDataModel.dart';
import '../TransmissionLogModel.dart';
import 'dart:math' as math;

class TransmissionLogController extends GetxController {
  var locations = RxList<DropDownValue>();
  var channels = RxList<DropDownValue>([]);
  RxBool isEnable = RxBool(true);

  //input controllers
  DropDownValue? selectLocation;
  DropDownValue? selectChannel;
  PlutoGridStateManager? gridStateManager;

  // PlutoGridMode selectedPlutoGridMode = PlutoGridMode.normal;
  var isStandby = RxBool(false);
  var isMy = RxBool(true);
  var isInsertAfter = RxBool(false);
  TextEditingController selectedDate = TextEditingController();
  TextEditingController startTime_ = TextEditingController();
  TextEditingController offsetTime_ = TextEditingController();
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
  bool chkTxCommercial = false;
  bool logSaved = false;

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
          chkTxCommercial = map["channelSpecsSettings"]["chkTxCommercial"];
          maxProgramStarttimeDiff =
          map["channelSpecsSettings"]["maxProgramStarttimeDiff"];
        });
  }

  getColorList() {
    if (selectLocation != null && selectChannel != null) {
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.TRANSMISSION_LOG_COLOR_LIST(
            selectLocation?.key ?? "",
            selectChannel?.key ?? "",
            Utils.dateFormatChange(
                selectedDate.text, "dd-MM-yyyy", "dd-MMM-yyyy"),
          ),
          fun: (Map map) {
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
            update(["transmissionList"]);
          });
    }
  }

  ColorDataModel? getMatchWithKey(String key) {
    ColorDataModel? data;
    print("Steo 2>>" + key);
    for (int i = 0; i < listColor.value.length!; i++) {
      var element = listColor.value[i];
      if (element.eventType?.trim().toLowerCase() == key.trim().toLowerCase()) {
        data = element;
        break;
      }
    }
    return data;
  }

  void colorGrid(bool DontSavefile) {
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
      ///S TimeAdd("00:00:52:22", "00:00:52:22", true);
      //  Dim r As Integer = tblLog.FirstDisplayedScrollingRowIndex
      if ((gridStateManager?.rows.length == 0)) {
        return;
      }

      // Cursor = Cursors.WaitCursor
      logSaved = false;
      // this.tblLog.SuspendLayout();
      dtSTD[0] = DateTime
          .now()
          .millisecondsSinceEpoch;
      if (!DontSavefile) {
        ///S CalculateTransmissionTime();
        dtSTD[1] = DateTime
            .now()
            .millisecondsSinceEpoch;

        ///S UpdateRowNumber();
        dtSTD[2] = DateTime
            .now()
            .millisecondsSinceEpoch;
      }

      dtSTD[3] = DateTime
          .now()
          .millisecondsSinceEpoch;
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

      dtSTD[3] = DateTime
          .now()
          .millisecondsSinceEpoch;
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
}

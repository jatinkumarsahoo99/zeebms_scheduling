import 'dart:convert';
import 'dart:developer';
import 'package:bms_scheduling/app/providers/extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../../widgets/LoadingDialog.dart';
import '../../../../widgets/Snack.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../data/DropDownValue.dart';
import '../../../data/PermissionModel.dart';
import '../../../data/system_envirtoment.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/DataGridMenu.dart';
import '../../../providers/SizeDefine.dart';
import '../../../providers/Utils.dart';
import '../../../routes/app_pages.dart';
import '../CommercialShowOnTabModel.dart';
import '../CommercialProgramModel.dart';

class ChannelModel {
  String? locationCode;

  String? channelCode;

  ChannelModel({this.locationCode, this.channelCode});

  ChannelModel.fromJson(Map<String, dynamic> json) {
    locationCode = json['locationCode'];
    channelCode = json['channelCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['locationCode'] = locationCode;
    data['channelCode'] = channelCode;
    data['selected'] = true;
    return data;
  }
}

class CommercialController extends GetxController {
  /// Radio Button
  int? tabIndex = 0;
  int selectIndex = 0;
  int? selectedDDIndex;

  int selectedGroup = 0;
  double widthSize = 0.17;
  String? fpcTimeSelected;
  DropDownValue? selectedChannel;
  DropDownValue? selectedLocation;

  var selectedIndex = RxInt(0);
  RxBool isEnable = RxBool(true);
  var channelEnable = RxBool(true);
  var locationEnable = RxBool(true);
  var selectedChannels = RxList([]);
  var commercialSpots = RxString("");
  var commercialDuration = RxString("");

  var locations = RxList<DropDownValue>();
  var channels = RxList<DropDownValue>([]);

  DateTime now = DateTime.now();
  DateTime? selectedDate = DateTime.now();
  DateFormat df = DateFormat("dd/MM/yyyy");
  DateFormat df1 = DateFormat("dd-MM-yyyy");
  DateFormat df2 = DateFormat("MM-dd-yyyy");
  DateFormat dfFinal = DateFormat("yyyy-MM-ddThh:mm:ss");

  List beams = [];
  List<PlutoRow> beamRows = [];
  List<PlutoRow> initRows = [];
  List<PlutoColumn> initColumn = [];
  List<PermissionModel>? formPermissions;
  List<CommercialProgramModel>? commercialProgramList = [];
  List<CommercialShowOnTabModel>? commercialShufflingList = [];
  List<CommercialShowOnTabModel>? commercialShowDetailsList = [];
  List<CommercialShowOnTabModel>? commercialShowFPCList = [];
  List<CommercialShowOnTabModel>? commercialShowMarkedList = [];

  /////////////Pluto Grid////////////
  List redBreaks = [];

  BuildContext? gridContext;
  PlutoGridStateManager? stateManager;
  PlutoGridStateManager? gridStateManager;
  PlutoGridStateManager? locChanStateManager;
  PlutoGridStateManager? bmsReportStateManager;
  PlutoGridMode selectedPlutoGridMode = PlutoGridMode.select;

  late PlutoGridStateManager conflictReportStateManager;

  List<SystemEnviroment>? channelList = [];
  List<SystemEnviroment>? locationList = [];

  CommercialProgramModel? selectedProgram;
  CommercialShowOnTabModel? selectedShowOnTab;

  TextEditingController date_ = TextEditingController();
  TextEditingController programName_ = TextEditingController();
  TextEditingController refDateContrl = TextEditingController(
      text: DateFormat("dd-MM-yyyy").format(DateTime.now()));

  @override
  void onInit() {
    super.onInit();
    getLocations();
  }

  getLocations() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.COMMERCIAL_LOCATION,
        fun: (Map map) {
          locations.clear();
          map["csload"]["lstLocations"].forEach((e) {
            locations.add(DropDownValue.fromJson1(e));
          });
        });
  }

  getChannel(locationCode) {
    try {
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.COMMERCIAL_CHANNEL(locationCode),
          fun: (data) {
            if (data["locationSelect"] is List) {
              channels.value = (data["locationSelect"] as List)
                  .map((e) => DropDownValue(
                      key: e["channelCode"], value: e["channelName"]))
                  .toList();
            } else {
              LoadingDialog.callErrorMessage1(
                  msg: "Failed To Load Initial Data");
            }
          });
    } catch (e) {
      LoadingDialog.callErrorMessage1(msg: "Failed To Load Initial Data");
    }
  }

  fetchProgramSchedulingDetails() {
    print(">>Key is>>>>>" + (selectedChannel?.key ?? ""));
    if (selectedLocation == null) {
      Snack.callError("Please select location");
    } else if (selectedChannel == null) {
      Snack.callError("Please select location");
    } else if (selectedDate == null) {
      Snack.callError("Please select date");
    } else {
      // LoadingDialog.call();
      selectedDate = df1.parse(date_.text);
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.COMMERCIAL_SHOW_FPC_SCHEDULLING_DETAILS(
              selectedLocation?.key ?? "",
              selectedChannel?.key ?? "",
              df1.format(selectedDate!)),
          fun: (dynamic list) {
            print("Json response is>>>" + jsonEncode(list));

            commercialProgramList?.clear();
            list['showDetails']["lstDailyFPC"].forEach((element) {
              commercialProgramList
                  ?.add(CommercialProgramModel.fromJson(element));
            });

            commercialSpots.value =
                list['showDetails']['bindGridOutPut']['commercialSpots'] ?? "";

            commercialDuration.value = list['showDetails']['bindGridOutPut']
                    ['commercialDuration'] ?? "";

            commercialShowDetailsList?.clear();
            list['showDetails']['lstCommercialShuffling'].forEach((element) {
              commercialShowDetailsList
                  ?.add(CommercialShowOnTabModel.fromJson(element));
            });

            commercialShufflingList?.clear();
            list['showDetails']['lstscheduling'].forEach((element) {
              commercialShufflingList
                  ?.add(CommercialShowOnTabModel.fromJson(element));
            });

            print(">>Program List Update Called");
            update(["fillerFPCTable"]);
            update(["fillerShowOnTabTable"]);
          },
          failed: (val) {
            Snack.callError(val.toString());
          });
    }
  }

  fetchSchedulingShowOnTabDetails() {
    print(">>Key is>>>>>" + (selectedChannel?.key ?? ""));
    if (selectedLocation == null) {
      Snack.callError("Please select location");
    } else if (selectedChannel == null) {
      Snack.callError("Please select location");
    } else if (selectedDate == null) {
      Snack.callError("Please select date");
    } else {
      // LoadingDialog.call();
      selectedDate = df1.parse(date_.text);
      //   "locationCode": "ZAZEE00001",
      // "channelCode": "ZAZEE00001",
      // "telecastDate": "31-03-2023",
      // "FpctimeSelected":"02:00:00",
      // "tabindex": "1",
      try {
        var jsonRequest = {
          "locationCode": selectedLocation?.key.toString(),
          "channelCode": selectedChannel?.key.toString(),
          "telecastDate": df1.format(selectedDate!),
          "FpctimeSelected": (fpcTimeSelected ?? "").toString(),
          "tabindex": selectedIndex.value.toString(),
          "lstCommercialShuffling":
              commercialShowDetailsList?.map((e) => e.toJson()).toList(),
        };
        print("requestedData1>>>" + jsonEncode(jsonRequest));
        Get.find<ConnectorControl>().POSTMETHOD(
            api: ApiFactory.COMMERCIAL_SHOW_ON_TAB_DETAILS(),
            fun: (dynamic data) {
              print("Json response is>>>" + jsonEncode(data));

              if (selectedIndex.value.toString() == "1") {
                commercialShowFPCList?.clear();
                data['tabchangeOutput']['lstFPCMismatch'].forEach((element) {
                  commercialShowFPCList
                      ?.add(CommercialShowOnTabModel.fromJson(element));
                });
              } else if (selectedIndex.value.toString() == "2") {
                commercialShowMarkedList?.clear();
                data['tabchangeOutput']['lstMarkedAsError'].forEach((element) {
                  commercialShowMarkedList
                      ?.add(CommercialShowOnTabModel.fromJson(element));
                });
              } else {
                commercialSpots.value = data['tabchangeOutput']['bindGridOutPut']
                        ['commercialSpots'].toString() ??
                    "";

                commercialDuration.value = data['tabchangeOutput']
                        ['bindGridOutPut']['commercialDuration'].toString() ??
                    "";

                // data['tabchangeOutput']['lstscheduling'].forEach((element) {
                //   commercialShowDetailsList?.add(CommercialShowOnTabModel.fromJson(element));
                // });
                //
                // data['tabchangeOutput']['lstCommercialShuffling'].forEach((element) {
                //   commercialShowDetailsList?.add(CommercialShowOnTabModel.fromJson(element));
                // });

                commercialShufflingList?.clear();
                data['tabchangeOutput']['lstscheduling'].forEach((element) {
                  commercialShufflingList
                      ?.add(CommercialShowOnTabModel.fromJson(element));
                });

                commercialShowDetailsList?.clear();
                data['tabchangeOutput']['lstCommercialShuffling']
                    .forEach((element) {
                  commercialShowDetailsList
                      ?.add(CommercialShowOnTabModel.fromJson(element));
                });
              }

              print(">>On Tap Update Called");
              update(["fillerShowOnTabTable"]);
            },
            json: jsonRequest);
      } catch (e) {
        LoadingDialog.callErrorMessage1(msg: "Failed To Load OnTab Data");
      }
    }
  }

  /// Not Completed
  saveSchedulingData() {
    if (selectedLocation == null) {
      Snack.callError("Please select location");
    } else if (selectedChannel == null) {
      Snack.callError("Please select location");
    } else if (selectedDate == null) {
      Snack.callError("Please select date");
    } else {
      selectedDate = df1.parse(date_.text);
      try {
        var jsonRequest = {
          "locationCode": selectedLocation?.key.toString(),
          "channelCode": selectedChannel?.key.toString(),
          "scheduleDate": df1.format(selectedDate!),
          "lstCommercialShuffling":
              commercialShowDetailsList?.map((e) => e.toJson()).toList(),
        };
        print("requestedToSaveData >>>" + jsonEncode(jsonRequest));
        Get.find<ConnectorControl>().POSTMETHOD(
            api: ApiFactory.SAVE_COMMERCIAL_DETAILS(),
            fun: (dynamic data) {
              print("Json response is>>>" + jsonEncode(data));

              print("saveSchedulingData Called");
              update(["fillerShowOnTabTable"]);
            },
            json: jsonRequest);
      } catch (e) {
        LoadingDialog.callErrorMessage1(msg: "Failed To Save Data");
      }
    }
  }

  formHandler(btnName) async {
    if (btnName == "Clear") {
      clear();
    }

    if (btnName == "Save") {
      saveSchedulingData();
    }

    if (btnName == "Exit") {
      exit();
    }
  }

  /// Useful in Columns
  loadColumnBeams(column) {
    List<PlutoRow> rows = [];
    for (Map row in beams.where((element) => element["beam"] == column)) {
      Map<String, PlutoCell> cells = {};

      for (var element in row.entries) {
        print(element.value);
        cells[element.key] = PlutoCell(
          value: element.key == "selected" || element.value == null
              ? ""
              : element.key.toString().toLowerCase().contains("date")
                  ? (element.value.toString().contains('T') &&
                          element.value.toString().split('T')[1] == '00:00:00')
                      ? DateFormat("dd/MM/yyyy").format(
                          DateFormat('yyyy-MM-ddTHH:mm:ss')
                              .parse(element.value.toString()))
                      : DateFormat("dd/MM/yyyy HH:mm:ss").format(
                          DateFormat('yyyy-MM-ddTHH:mm:ss')
                              .parse(element.value.toString()))
                  // DateFormat("dd-MM-yyyy hh:mm").format(DateTime.parse(element.value.toString().replaceAll("T", " ")))
                  : element.value.toString(),
        );
      }

      rows.add(PlutoRow(
        cells: cells,
      ));
    }
    if (bmsReportStateManager != null) {
      print("state working");

      bmsReportStateManager!.removeRows(bmsReportStateManager!.rows);
      bmsReportStateManager!.resetCurrentState();
      bmsReportStateManager!.appendRows(rows);
    }
    beamRows = [];
    update(["beams"]);
    beamRows = rows;
    rows = [];
    update(["beams"]);
  }

  /// Useful in Columns
  void loadBeams() {
    if (conflictReportStateManager.currentRow == null) {
      return;
    }
    // log("Rows");
    // log(conflictReportStateManager.currentRow!.cells["Program"]!.value);
    List<PlutoRow> rows = [];
    for (Map row in beams.where((element) =>
        element["program"] ==
        conflictReportStateManager.currentRow!.cells["Program"]!.value)) {
      Map<String, PlutoCell> cells = {};

      for (var element in row.entries) {
        cells[element.key] = PlutoCell(
          value: element.key == "selected" || element.value == null
              ? ""
              : element.key.toString().toLowerCase().contains("date")
                  ? (element.value.toString().contains('T') &&
                          element.value.toString().split('T')[1] == '00:00:00')
                      ? DateFormat("dd/MM/yyyy").format(
                          DateFormat('yyyy-MM-ddTHH:mm:ss')
                              .parse(element.value.toString()))
                      : DateFormat("dd/MM/yyyy HH:mm:ss").format(
                          DateFormat('yyyy-MM-ddTHH:mm:ss')
                              .parse(element.value.toString()))
                  // ? DateFormat("dd/MM/yyyy hh:mm").format(DateTime.parse(element.value.toString().replaceAll("T", " ")))
                  : element.value.toString(),
        );
      }

      rows.add(PlutoRow(
        cells: cells,
      ));
    }
    if (bmsReportStateManager != null) {
      print("state working");

      bmsReportStateManager!.removeRows(bmsReportStateManager!.rows);
      bmsReportStateManager!.resetCurrentState();
      bmsReportStateManager!.appendRows(rows);
    }
    beamRows = [];
    update(["beams"]);
    beamRows = rows;
    rows = [];
    update(["beams"]);
  }

  void clear() {
    selectedChannel = null;
    selectedLocation = null;
    commercialSpots.value = "";
    commercialDuration.value = "";

    commercialShowDetailsList?.clear();
    commercialProgramList?.clear();
    commercialShowFPCList?.clear();
    commercialShowMarkedList?.clear();

    locationEnable.value = true;
    channelEnable.value = true;

    update(["fillerShowOnTabTable"]);
    update(["fillerFPCTable"]);
    update(["initialData"]);
  }

  void exit() {
    clear();
    Get.find<HomeController>().selectChild1.value = null;
    Get.delete<CommercialController>();
  }

}

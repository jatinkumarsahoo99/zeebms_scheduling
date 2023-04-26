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
import '../../../data/DropDownValue.dart';
import '../../../data/PermissionModel.dart';
import '../../../data/system_envirtoment.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/DataGridMenu.dart';
import '../../../providers/SizeDefine.dart';
import '../../../providers/Utils.dart';
import '../../../routes/app_pages.dart';
import '../CommercialProgramModel.dart';

class FPCWeeklyTable extends DataTableSource {
  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => Get.find<CommercialController>().listData?.length ?? 0;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow? getRow(int index) {
    throw UnimplementedError();
  }

  // @override
  // DataRow getRow(int index) {
  //   Map<String,dynamic>? data =
  //   Get.find<CommercialController>().listData![index];
  //   return DataRow2(
  //     onSelectChanged: (tap){
  //       // Get.find<FPCMismatchController>().selectedProgram=data;
  //       Get.find<CommercialController>().selectIndex=index;
  //       notifyListeners();
  //     },
  //     selected: Get.find<CommercialController>().selectIndex==index,
  //     cells: data.values.map((e) => DataCell(
  //       InkWell(
  //         onTap: () {
  //           Get.find<CommercialController>().selectIndex=index;
  //           notifyListeners();
  //         },
  //         child: Center(
  //           child: Text(
  //             e.toString(),
  //             style: TextStyle(color: Colors.black, fontSize: 12),
  //             textAlign: TextAlign.center,
  //           ),
  //         ),
  //       ),
  //     )).toList()/*[
  //
  //       DataCell(
  //         InkWell(
  //           onTap: () {},
  //           child: Center(
  //             child: Text(
  //               (index + 1).toString(),
  //               style: TextStyle(color: Colors.black, fontSize: 12),
  //               textAlign: TextAlign.center,
  //             ),
  //           ),
  //         ),
  //       ),
  //       DataCell(
  //         InkWell(
  //           onTap: () {},
  //           child: Center(
  //             child: Text(
  //               data[0].value ?? "",
  //               style: TextStyle(color: Colors.black, fontSize: 12),
  //               textAlign: TextAlign.center,
  //             ),
  //           ),
  //         ),
  //       ),
  //       DataCell(
  //         InkWell(
  //           onTap: () {},
  //           child: Center(
  //             child: Text(
  //               data[1].value ?? "",
  //               style: TextStyle(color: Colors.black, fontSize: 12),
  //               textAlign: TextAlign.center,
  //             ),
  //           ),
  //         ),
  //         showEditIcon: false,
  //         placeholder: false,
  //       ),
  //       DataCell(
  //         InkWell(
  //           onTap: () {},
  //           child: Center(
  //             child: Text(
  //               data[2].value ?? "",
  //               style: TextStyle(color: Colors.black, fontSize: 12),
  //               textAlign: TextAlign.center,
  //             ),
  //           ),
  //         ),
  //         showEditIcon: false,
  //         placeholder: false,
  //       ),
  //       DataCell(
  //         InkWell(
  //           onTap: () {},
  //           child: Center(
  //             child: Text(
  //               data[3].value ?? "",
  //               style: TextStyle(color: Colors.black, fontSize: 12),
  //               textAlign: TextAlign.center,
  //             ),
  //           ),
  //         ),
  //         showEditIcon: false,
  //         placeholder: false,
  //       ), DataCell(
  //         InkWell(
  //           onTap: () {},
  //           child: Center(
  //             child: Text(
  //               data[4].value ?? "",
  //               style: TextStyle(color: Colors.black, fontSize: 12),
  //               textAlign: TextAlign.center,
  //             ),
  //           ),
  //         ),
  //         showEditIcon: false,
  //         placeholder: false,
  //       ), DataCell(
  //         InkWell(
  //           onTap: () {},
  //           child: Center(
  //             child: Text(
  //               data[5].value ?? "",
  //               style: TextStyle(color: Colors.black, fontSize: 12),
  //               textAlign: TextAlign.center,
  //             ),
  //           ),
  //         ),
  //         showEditIcon: false,
  //         placeholder: false,
  //       ), DataCell(
  //         InkWell(
  //           onTap: () {},
  //           child: Center(
  //             child: Text(
  //               data[6].value ?? "",
  //               style: TextStyle(color: Colors.black, fontSize: 12),
  //               textAlign: TextAlign.center,
  //             ),
  //           ),
  //         ),
  //         showEditIcon: false,
  //         placeholder: false,
  //       ), DataCell(
  //         InkWell(
  //           onTap: () {},
  //           child: Center(
  //             child: Text(
  //               data[7].value ?? "",
  //               style: TextStyle(color: Colors.black, fontSize: 12),
  //               textAlign: TextAlign.center,
  //             ),
  //           ),
  //         ),
  //         showEditIcon: false,
  //         placeholder: false,
  //       ),
  //     ]*/,
  //   );
  // }
}

class ProgramClipModel {
  int? mediaClipId;
  String? locationCode;
  String? channelCode;
  String? clipType;
  int? programCode;
  String? lookupName;
  String? clipId;
  String? locationName;
  String? channelName;

  ProgramClipModel(
      {this.mediaClipId,
      this.locationCode,
      this.channelCode,
      this.clipType,
      this.programCode,
      this.lookupName,
      this.clipId,
      this.locationName,
      this.channelName});

  ProgramClipModel.fromJson(Map<String, dynamic> json) {
    mediaClipId = json['mediaClipId'];
    locationCode = json['locationCode'];
    channelCode = json['channelCode'];
    clipType = json['clipType'];
    programCode = json['programCode'];
    lookupName = json['lookupName'];
    clipId = json['clipId'];
    locationName = json['locationName'];
    channelName = json['channelName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mediaClipId'] = this.mediaClipId;
    data['locationCode'] = this.locationCode;
    data['channelCode'] = this.channelCode;
    data['clipType'] = this.clipType;
    data['programCode'] = this.programCode;
    data['lookupName'] = this.lookupName;
    data['clipId'] = this.clipId;
    data['locationName'] = this.locationName;
    data['channelName'] = this.channelName;
    return data;
  }

  Map<String, dynamic> toJson1() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['mediaClipId'] = this.mediaClipId;
    // data['locationCode'] = this.locationCode;
    // data['channelCode'] = this.channelCode;
    // data['clipType'] = this.clipType;
    // data['programCode'] = this.programCode;
    data['Lookup Name'] = this.lookupName;
    data['Clip Id'] = this.clipId;
    data['Location Name'] = this.locationName;
    data['Channel Name'] = this.channelName;
    return data;
  }
}

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
  var locations = RxList<DropDownValue>();
  var channels = RxList<DropDownValue>([]);
  RxBool isEnable = RxBool(true);

  //input controllers
  DropDownValue? selectLocation;
  DropDownValue? selectChannel;
  PlutoGridStateManager? gridStateManager;

  List<PermissionModel>? formPermissions;
  List<PlutoRow> initRows = [];
  List<PlutoColumn> initColumn = [];
  List locationsForReport = [];
  List<ChannelModel> locationsForReport1 = [];
  List conflictReport = [];

  List<FPCMisMatchProgramModel>? programList = [
    new FPCMisMatchProgramModel(startTime: '01:00:00', programName: 'Test1'),
    new FPCMisMatchProgramModel(startTime: '01:00:00', programName: 'Test'),
    new FPCMisMatchProgramModel(startTime: '01:00:00', programName: 'Test'),
    new FPCMisMatchProgramModel(startTime: '01:00:00', programName: 'Test'),
    new FPCMisMatchProgramModel(startTime: '01:00:00', programName: 'Test5'),
    new FPCMisMatchProgramModel(startTime: '01:00:00', programName: 'Test'),
    new FPCMisMatchProgramModel(startTime: '01:00:00', programName: 'Test'),
    new FPCMisMatchProgramModel(startTime: '01:00:00', programName: 'Test'),
    new FPCMisMatchProgramModel(startTime: '01:00:00', programName: 'Test'),
    new FPCMisMatchProgramModel(startTime: '01:00:00', programName: 'Test10'),
    new FPCMisMatchProgramModel(startTime: '01:00:00', programName: 'Test'),
    new FPCMisMatchProgramModel(startTime: '01:00:00', programName: 'Test'),
    new FPCMisMatchProgramModel(startTime: '01:00:00', programName: 'Test'),
    new FPCMisMatchProgramModel(startTime: '01:00:00', programName: 'Test'),
    new FPCMisMatchProgramModel(startTime: '01:00:00', programName: 'Test15'),
    new FPCMisMatchProgramModel(startTime: '01:00:00', programName: 'Test'),
    new FPCMisMatchProgramModel(startTime: '01:00:00', programName: 'Test'),
    new FPCMisMatchProgramModel(startTime: '01:00:00', programName: 'Test'),
    new FPCMisMatchProgramModel(startTime: '01:00:00', programName: 'Test'),
    new FPCMisMatchProgramModel(startTime: '01:00:00', programName: 'Test20'),
    new FPCMisMatchProgramModel(startTime: '01:00:00', programName: 'Test'),
    new FPCMisMatchProgramModel(startTime: '01:00:00', programName: 'Test'),
    new FPCMisMatchProgramModel(startTime: '01:00:00', programName: 'Test'),
    new FPCMisMatchProgramModel(startTime: '01:00:00', programName: 'Test'),
    new FPCMisMatchProgramModel(startTime: '01:00:00', programName: 'Test'),
    new FPCMisMatchProgramModel(startTime: '01:00:00', programName: 'Test26'),
  ];
  List beams = [];
  int? conflictDays = 4;
  List conflictPrograms = [];
  List<PlutoRow> beamRows = [];
  var selectedChannels = RxList([]);
  var ignoreSingleTelecast = RxBool(false);
  Map<String, dynamic> reportBody = {};

  var selectedIndex = RxInt(0);
  late PlutoGridStateManager conflictReportStateManager;
  PlutoGridStateManager? bmsReportStateManager;
  PlutoGridStateManager? locChanStateManager;
  Map? initData;
  TextEditingController refDateContrl = TextEditingController(
      text: DateFormat("dd-MM-yyyy").format(DateTime.now()));

  DataTableSource dataTable = FPCWeeklyTable();
  List<SystemEnviroment>? channelList = [];
  List<SystemEnviroment>? clipTypeList = [];
  List<SystemEnviroment>? locationList = [];

  TextEditingController programName_ = TextEditingController();
  TextEditingController clip_ = TextEditingController();
  TextEditingController date_ = TextEditingController();
  DateTime now = DateTime.now();
  DateTime? selectedDate = DateTime.now();
  DateFormat df = DateFormat("dd/MM/yyyy");
  DateFormat df1 = DateFormat("dd-MM-yyyy");
  DateFormat df2 = DateFormat("MM-dd-yyyy");
  SystemEnviroment? selectedChannel;
  SystemEnviroment? selectedLocation;
  SystemEnviroment? selectedClipType;
  FPCMisMatchProgramModel? selectedProgram;
  int selectedGroup = 0;
  int selectIndex = 0;
  ProgramClipModel? selectedRow;
  List<Map<String, dynamic>>? listData = [];

  DateTime selectDate = DateTime.now();

  /////////////Pluto Grid////////////
  List redBreaks = [];
  BuildContext? gridContext;
  PlutoGridStateManager? stateManager;

  double widthSize = 0.17;
  var locationEnable = RxBool(true);
  var channelEnable = RxBool(true);

  @override
  void onInit() {
    super.onInit();
  }

  formHandler(btnName) async {
    if (btnName == "Clear") {
      initData = null;
      initRows = [];
      initColumn = [];
      locationsForReport = [];
      locationsForReport1 = [];
      conflictReport = [];

      beams = [];
      conflictDays = 4;
      conflictPrograms = [];
      beamRows = [];
      selectedChannels.value = [];
      ignoreSingleTelecast.value = false;

      Map<String, dynamic> reportBody = {};
      update(["initData"]);
      //getInitData();
    }
  }

  fetchInitial() {
    // Get.find<ConnectorControl>().GETMETHODCALL(
    //   api: ApiFactory.FPC_WEEKLY_INITIAL,
    //   fun: (Map<String, dynamic> map) {
    //     locationList?.clear();
    //     channelList?.clear();
    //     map["lstLocations"].forEach((element) {
    //       locationList?.add(SystemEnviroment(key: element["locationCode"], value: element["locationName"]));
    //     });
    //     map["lstChannels"].forEach((element) {
    //       channelList?.add(SystemEnviroment(key: element["channelcode"], value: element["channelName"]));
    //     });
    //     update(["initialData"]);
    //   },
    // );
  }
  // fetchInitial() {
  //   Get.find<ConnectorControl>().GETMETHODCALL(
  //     api: ApiFactory.FPC_WEEKLY_INITIAL,
  //     fun: (Map<String, dynamic> map) {
  //       locationList?.clear();
  //       channelList?.clear();
  //       map["lstLocations"].forEach((element) {
  //         locationList?.add(SystemEnviroment(key: element["locationCode"], value: element["locationName"]));
  //       });
  //       map["lstChannels"].forEach((element) {
  //         channelList?.add(SystemEnviroment(key: element["channelcode"], value: element["channelName"]));
  //       });
  //       update(["initialData"]);
  //     },
  //   );
  // }

  generateData() async {
    if (conflictDays == null) {
      // Snack.callError("Invalid Day Value");
      LoadingDialog.showErrorDialog("Invalid Day Value");
    } else if (locChanStateManager!.checkedRows.isEmpty) {
      LoadingDialog.showErrorDialog("Please select Location Channel");
    } else {
      // for (var element in locChanStateManager!.checkedRows) {
      //   locationsForReport.add(channels[element.sortIdx]);
      // }
      for (var element in locationsForReport) {
        element["selected"] = true;
      }
      reportBody["IgnoreSingleTelecast"] = ignoreSingleTelecast.value;
      reportBody["locationCodeChannels"] =
          locationsForReport1.map((e) => e.toJson()).toList();
      reportBody["ReferenceDate"] = DateFormat("yyyy-MM-dd")
          .format(DateFormat("dd-MM-yyyy").parse(refDateContrl.text));

      LoadingDialog.call();
      beams = [];
      conflictReport = [];
      conflictPrograms = [];
      update(["reports"]);
      // String value =
      //     await rootBundle.loadString('assets/json/ci_dashbaord_report.json');
      await Get.find<ConnectorControl>().POSTMETHOD_FORMDATA(
          // NEED TO PASS USER NAME
          timeout: 360000,
          api:
              "https://api-programming-bms-uat.zeeconnect.in//api/MovieConflictReport/GetMovieConflictReport",
          json: reportBody,
          fun: (map) async {
            beams = map["lstReportBaseData"];
            for (var element in beams.where((element) =>
                (element["days"] <= conflictDays && element["days"] >= 0))) {
              conflictPrograms.add(element["program"]);
            }
            conflictPrograms.toSet().toList();
            // log(conflictPrograms.toString());
            conflictReport = map["lstConflictReport"];
            update(["reports"]);
          });
      Get.back();
    }
  }

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

  fetchGenerate() {
    if (selectedLocation == null) {
      Snack.callError("Please select Location");
    } else if (selectedChannel == null) {
      Snack.callError("Please select Channel");
    } else if (selectDate == null) {
      Snack.callError("Please select from date");
    } else {
      selectDate = df1.parse(date_.text);
      listData?.clear();
      LoadingDialog.call();
    }
  }

  void clear() {
    listData?.clear();
    locationEnable.value = true;
    channelEnable.value = true;
    dataTable.notifyListeners();
  }

  void exit() {
    Get.find<HomeController>().selectChild1.value = null;
    Get.delete<CommercialController>();
  }

}

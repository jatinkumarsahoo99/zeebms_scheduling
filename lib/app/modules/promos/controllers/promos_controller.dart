import 'package:flutter/cupertino.dart';
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
import '../PromoModel.dart';
import '../PromoProgramModel.dart';

class PromosController extends GetxController  {

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

  List conflictReport = [];

  List<PromoProgramModel>? programList  = [
    PromoProgramModel
      (startTime: '01:00:00', programName: 'Test1'),
    PromoProgramModel
      (startTime: '01:00:00', programName: 'Test'),
    PromoProgramModel
      (startTime: '01:00:00', programName: 'Test'),
    PromoProgramModel
      (startTime: '01:00:00', programName: 'Test'),
    PromoProgramModel
      (startTime: '01:00:00', programName: 'Test5'),
    PromoProgramModel
      (startTime: '01:00:00', programName: 'Test'),
    PromoProgramModel
      (startTime: '01:00:00', programName: 'Test'),
    PromoProgramModel
      (startTime: '01:00:00', programName: 'Test'),
    PromoProgramModel
      (startTime: '01:00:00', programName: 'Test'),
    PromoProgramModel
      (startTime: '01:00:00', programName: 'Test10'),
    PromoProgramModel
      (startTime: '01:00:00', programName: 'Test'),
    PromoProgramModel
      (startTime: '01:00:00', programName: 'Test'),
    PromoProgramModel
      (startTime: '01:00:00', programName: 'Test'),
    PromoProgramModel
      (startTime: '01:00:00', programName: 'Test'),
    PromoProgramModel
      (startTime: '01:00:00', programName: 'Test15'),
    PromoProgramModel
      (startTime: '01:00:00', programName: 'Test'),
    PromoProgramModel
      (startTime: '01:00:00', programName: 'Test'),
    PromoProgramModel
      (startTime: '01:00:00', programName: 'Test'),
    PromoProgramModel
      (startTime: '01:00:00', programName: 'Test'),
    PromoProgramModel
      (startTime: '01:00:00', programName: 'Test20'),
    PromoProgramModel
      (startTime: '01:00:00', programName: 'Test'),
    PromoProgramModel
      (startTime: '01:00:00', programName: 'Test'),
    PromoProgramModel
      (startTime: '01:00:00', programName: 'Test'),
    PromoProgramModel
      (startTime: '01:00:00', programName: 'Test'),
    PromoProgramModel
      (startTime: '01:00:00', programName: 'Test'),
    PromoProgramModel
      (startTime: '01:00:00', programName: 'Test26',),

  ];

  List<PromoModel>? commercialList = [
    PromoModel
      (
        fpcTime:'01:00:00', breakNumber:'1', eventType:'S',
        exportTapeCode:'TBA', segmentCaption:'Caption', client:' ', brand:' ', duration: 0,
        product:' ', bookingNumber:' ', bookingDetailcode:' ',rostimeBand:' ', randid:' ',
        programName:'Program Name', rownumber:'O', bStatus:'B', pDailyFPC:' ', pProgramMaster:' '),
    PromoModel
      (
        fpcTime:'01:00:00', breakNumber:'1', eventType:'S',
        exportTapeCode:'TBA', segmentCaption:'Caption', client:' ', brand:' ', duration: 0,
        product:' ', bookingNumber:' ', bookingDetailcode:' ',rostimeBand:' ', randid:' ',
        programName:'Program Name', rownumber:'O', bStatus:'B', pDailyFPC:' ', pProgramMaster:' '),
    PromoModel
      (
        fpcTime:'01:00:00', breakNumber:'1', eventType:'S',
        exportTapeCode:'TBA', segmentCaption:'Caption', client:' ', brand:' ', duration: 0,
        product:' ', bookingNumber:' ', bookingDetailcode:' ',rostimeBand:' ', randid:' ',
        programName:'Program Name', rownumber:'O', bStatus:'B', pDailyFPC:' ', pProgramMaster:' '),
    PromoModel
      (
        fpcTime:'01:00:00', breakNumber:'1', eventType:'S',
        exportTapeCode:'TBA', segmentCaption:'Caption', client:' ', brand:' ', duration: 0,
        product:' ', bookingNumber:' ', bookingDetailcode:' ',rostimeBand:' ', randid:' ',
        programName:'Program Name', rownumber:'O', bStatus:'B', pDailyFPC:' ', pProgramMaster:' '),
    PromoModel
      (
        fpcTime:'01:00:00', breakNumber:'1', eventType:'S',
        exportTapeCode:'TBA', segmentCaption:'Caption', client:' ', brand:' ', duration: 0,
        product:' ', bookingNumber:' ', bookingDetailcode:' ',rostimeBand:' ', randid:' ',
        programName:'Program Name', rownumber:'O', bStatus:'B', pDailyFPC:' ', pProgramMaster:' '),
    PromoModel
      (
        fpcTime:'01:00:00', breakNumber:'1', eventType:'S',
        exportTapeCode:'TBA', segmentCaption:'Caption', client:' ', brand:' ', duration: 0,
        product:' ', bookingNumber:' ', bookingDetailcode:' ',rostimeBand:' ', randid:' ',
        programName:'Program Name', rownumber:'O', bStatus:'B', pDailyFPC:' ', pProgramMaster:' '),
    PromoModel
      (
        fpcTime:'01:00:00', breakNumber:'1', eventType:'S',
        exportTapeCode:'TBA', segmentCaption:'Caption', client:' ', brand:' ', duration: 0,
        product:' ', bookingNumber:' ', bookingDetailcode:' ',rostimeBand:' ', randid:' ',
        programName:'Program Name', rownumber:'O', bStatus:'B', pDailyFPC:' ', pProgramMaster:' '),
    PromoModel
      (
        fpcTime:'01:00:00', breakNumber:'1', eventType:'S',
        exportTapeCode:'TBA', segmentCaption:'Caption', client:' ', brand:' ', duration: 0,
        product:' ', bookingNumber:' ', bookingDetailcode:' ',rostimeBand:' ', randid:' ',
        programName:'Program Name', rownumber:'O', bStatus:'B', pDailyFPC:' ', pProgramMaster:' '),
    PromoModel
      (
        fpcTime:'01:00:00', breakNumber:'1', eventType:'S',
        exportTapeCode:'TBA', segmentCaption:'Caption', client:' ', brand:' ', duration: 0,
        product:' ', bookingNumber:' ', bookingDetailcode:' ',rostimeBand:' ', randid:' ',
        programName:'Program Name', rownumber:'O', bStatus:'B', pDailyFPC:' ', pProgramMaster:' '),
    PromoModel
      (
        fpcTime:'01:00:00', breakNumber:'1', eventType:'S',
        exportTapeCode:'TBA', segmentCaption:'Caption', client:' ', brand:' ', duration: 0,
        product:' ', bookingNumber:' ', bookingDetailcode:' ',rostimeBand:' ', randid:' ',
        programName:'Program Name', rownumber:'O', bStatus:'B', pDailyFPC:' ', pProgramMaster:' '),
    PromoModel
      (
        fpcTime:'01:00:00', breakNumber:'1', eventType:'S',
        exportTapeCode:'TBA', segmentCaption:'Caption', client:' ', brand:' ', duration: 0,
        product:' ', bookingNumber:' ', bookingDetailcode:' ',rostimeBand:' ', randid:' ',
        programName:'Program Name', rownumber:'O', bStatus:'B', pDailyFPC:' ', pProgramMaster:' '),
    PromoModel
      (
        fpcTime:'01:00:00', breakNumber:'1', eventType:'S',
        exportTapeCode:'TBA', segmentCaption:'Caption', client:' ', brand:' ', duration: 0,
        product:' ', bookingNumber:' ', bookingDetailcode:' ',rostimeBand:' ', randid:' ',
        programName:'Program Name', rownumber:'O', bStatus:'B', pDailyFPC:' ', pProgramMaster:' '),
    PromoModel
      (
        fpcTime:'01:00:00', breakNumber:'1', eventType:'S',
        exportTapeCode:'TBA', segmentCaption:'Caption', client:' ', brand:' ', duration: 0,
        product:' ', bookingNumber:' ', bookingDetailcode:' ',rostimeBand:' ', randid:' ',
        programName:'Program Name', rownumber:'O', bStatus:'B', pDailyFPC:' ', pProgramMaster:' '),
    PromoModel
      (
        fpcTime:'01:00:00', breakNumber:'1', eventType:'S',
        exportTapeCode:'TBA', segmentCaption:'Caption', client:' ', brand:' ', duration: 0,
        product:' ', bookingNumber:' ', bookingDetailcode:' ',rostimeBand:' ', randid:' ',
        programName:'Program Name', rownumber:'O', bStatus:'B', pDailyFPC:' ', pProgramMaster:' '),
    PromoModel
      (
        fpcTime:'01:00:00', breakNumber:'1', eventType:'S',
        exportTapeCode:'TBA', segmentCaption:'Caption', client:' ', brand:' ', duration: 0,
        product:' ', bookingNumber:' ', bookingDetailcode:' ',rostimeBand:' ', randid:' ',
        programName:'Program Name', rownumber:'O', bStatus:'B', pDailyFPC:' ', pProgramMaster:' '),
    PromoModel
      (
        fpcTime:'01:00:00', breakNumber:'1', eventType:'S',
        exportTapeCode:'TBA', segmentCaption:'Caption', client:' ', brand:' ', duration: 0,
        product:' ', bookingNumber:' ', bookingDetailcode:' ',rostimeBand:' ', randid:' ',
        programName:'Program Name', rownumber:'O', bStatus:'B', pDailyFPC:' ', pProgramMaster:' '),
    PromoModel
      (
        fpcTime:'01:00:00', breakNumber:'1', eventType:'S',
        exportTapeCode:'TBA', segmentCaption:'Caption', client:' ', brand:' ', duration: 0,
        product:' ', bookingNumber:' ', bookingDetailcode:' ',rostimeBand:' ', randid:' ',
        programName:'Program Name', rownumber:'O', bStatus:'B', pDailyFPC:' ', pProgramMaster:' '),
    PromoModel
      (
        fpcTime:'01:00:00', breakNumber:'1', eventType:'S',
        exportTapeCode:'TBA', segmentCaption:'Caption', client:' ', brand:' ', duration: 0,
        product:' ', bookingNumber:' ', bookingDetailcode:' ',rostimeBand:' ', randid:' ',
        programName:'Program Name', rownumber:'O', bStatus:'B', pDailyFPC:' ', pProgramMaster:' '),
    PromoModel
      (
        fpcTime:'01:00:00', breakNumber:'1', eventType:'S',
        exportTapeCode:'TBA', segmentCaption:'Caption', client:' ', brand:' ', duration: 0,
        product:' ', bookingNumber:' ', bookingDetailcode:' ',rostimeBand:' ', randid:' ',
        programName:'Program Name', rownumber:'O', bStatus:'B', pDailyFPC:' ', pProgramMaster:' '),

  ];

  List beams = [];
  int? conflictDays = 4;
  List conflictPrograms = [];
  List<PlutoRow> beamRows = [];
  var selectedChannels = RxList([]);

  Map<String, dynamic> reportBody = {};

  var selectedIndex = RxInt(0);
  late PlutoGridStateManager conflictReportStateManager;
  PlutoGridStateManager? bmsReportStateManager;
  PlutoGridStateManager? locChanStateManager;
  Map? initData;
  TextEditingController refDateContrl = TextEditingController(
      text: DateFormat("dd-MM-yyyy").format(DateTime.now()));

  List<SystemEnviroment>? channelList = [];
  List<SystemEnviroment>? locationList = [];

  TextEditingController programName_ = TextEditingController();
  TextEditingController date_ = TextEditingController();

  DateTime now = DateTime.now();
  DateTime? selectedDate = DateTime.now();
  DateFormat df = DateFormat("dd/MM/yyyy");
  DateFormat df1 = DateFormat("dd-MM-yyyy");
  DateFormat df2 = DateFormat("MM-dd-yyyy");

  SystemEnviroment? selectedChannel;
  SystemEnviroment? selectedLocation;

  /// List for Columns
  PromoProgramModel
  ? selectedProgram;
  PromoModel? selectedPromo;

  /// Radio Button
  int selectedGroup = 0;
  int selectIndex = 0;

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

      conflictReport = [];

      beams = [];
      conflictDays = 4;
      conflictPrograms = [];
      beamRows = [];
      selectedChannels.value = [];

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
  }

  void exit() {
    Get.find<HomeController>().selectChild1.value = null;
    Get.delete<PromosController>();
  }

}

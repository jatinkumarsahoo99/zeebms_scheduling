import 'dart:convert';

import 'package:bms_scheduling/app/modules/filler/FillerDailyFPCModel.dart';
import 'package:bms_scheduling/app/modules/filler/FillerDailyFPCModel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';

import '../../../../widgets/LoadingDialog.dart';
import '../../../../widgets/Snack.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../controller/HomeController.dart';
import '../../../data/DropDownValue.dart';
import '../../../data/PermissionModel.dart';
import '../../../data/system_envirtoment.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/ExportData.dart';
import '../FillerDailyFPCModel.dart';
import '../FillerSegmentModel.dart';
import 'package:dio/dio.dart' as dio;

class FillerController extends GetxController {
  var locations = RxList<DropDownValue>();
  var importLocations = RxList<DropDownValue>();
  var channels = RxList<DropDownValue>([]);
  var importChannels = RxList<DropDownValue>([]);
  var captions = RxList<DropDownValue>([]);

  List<FillerDailyFPCModel>? fillerDailyFpcList = [];
  List<FillerSegmentModel>? fillerSegmentList = [];

  RxBool isEnable = RxBool(true);
  bool isSearchFromCaption = false;
  bool candoFocusOnCaptionGrid = false;

  TextEditingController tapeId_ = TextEditingController()..text = "";
  TextEditingController segNo_ = TextEditingController()..text = "";
  TextEditingController segDur_ = TextEditingController()..text = "00:00:00:00";
  TextEditingController totalFiller = TextEditingController()..text = "";
  TextEditingController totalFillerDur = TextEditingController()..text = "";
  TextEditingController fromTime_ = TextEditingController()..text = "00:00:00:00";
  TextEditingController toTime_ = TextEditingController()..text = "00:00:00:00";

  late String fillerCode;

  /// Radio Button
  int selectedAfter = 0;

  //input controllers
  DropDownValue? selectLocation;
  DropDownValue? selectChannel;
  var selectCaption = Rxn<DropDownValue>();
  PlutoGridStateManager? gridStateManager;

  List<PermissionModel>? formPermissions;
  List<PlutoRow> initRows = [];
  List<PlutoColumn> initColumn = [];

  List conflictReport = [];
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

  List<SystemEnviroment>? channelList = [];
  List<SystemEnviroment>? locationList = [];

  TextEditingController refDateContrl = TextEditingController(text: DateFormat("dd-MM-yyyy").format(DateTime.now()));
  TextEditingController programName_ = TextEditingController();
  TextEditingController date_ = TextEditingController();
  TextEditingController fillerFromDate_ = TextEditingController();
  TextEditingController fillerToDate_ = TextEditingController();
  TextEditingController fillerCaptionName_ = TextEditingController();

  DateTime now = DateTime.now();
  DateTime selectDate = DateTime.now();
  DateTime? selectedDate = DateTime.now();
  DateFormat df = DateFormat("dd/MM/yyyy");
  DateFormat df3 = DateFormat("MM/dd/yyyy");
  DateFormat df1 = DateFormat("dd-MM-yyyy");
  DateFormat df2 = DateFormat("MM-dd-yyyy");
  DateFormat dfFinal = DateFormat("yyyy-MM-ddThh:mm:ss");

  DropDownValue? selectedLocation;
  DropDownValue? selectedChannel;

  DropDownValue? selectedImportLocation;
  DropDownValue? selectedImportChannel;

  SystemEnviroment? selectedChannelEnv;
  SystemEnviroment? selectedLocationEnv;
  SystemEnviroment? selectedCaption;

  /// List for Columns
  FillerDailyFPCModel? selectedDailyFPC;
  FillerSegmentModel? selectedSegment;

  List<Map<String, dynamic>>? listData = [];

  /////////////Pluto Grid////////////
  List redBreaks = [];
  BuildContext? gridContext;
  PlutoGridStateManager? stateManager;

  double widthSize = 0.10;

  /// Changed to set PROMO From Date width UI to 0.17
  var locationEnable = RxBool(true);
  var channelEnable = RxBool(true);

  var importedFile = Rxn<PlatformFile>();
  TextEditingController fileController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getLocation();
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

  // fetchInitial() {
  //   Get.find<ConnectorControl>().GETMETHODCALL(
  //     api: ApiFactory.FILLER_LOCATION,
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

  getLocation() {
    try {
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.FILLER_LOCATION,
          fun: (data) {
            if (data is List) {
              locations.value = data.map((e) => DropDownValue(key: e["locationCode"], value: e["locationName"])).toList();
            } else {
              LoadingDialog.callErrorMessage1(msg: "Failed To Load Initial Data");
            }
          });
    } catch (e) {
      LoadingDialog.callErrorMessage1(msg: "Failed To Load Initial Data");
    }
  }

  getChannel(locationCode) {
    try {
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.FILLER_CHANNEL(locationCode),
          fun: (data) {
            if (data is List) {
              channels.value = data.map((e) => DropDownValue(key: e["channelCode"], value: e["channelName"])).toList();
            } else {
              LoadingDialog.callErrorMessage1(msg: "Failed To Load Initial Data");
            }
          });
    } catch (e) {
      LoadingDialog.callErrorMessage1(msg: "Failed To Load Initial Data");
    }
  }

  importfile() async {
    LoadingDialog.call();
    dio.FormData formData = dio.FormData.fromMap(
      {
        "ChannelCode": selectedChannel?.key ?? "",
        "LocationCode": selectedLocation?.key ?? "",
        'ImportFile': dio.MultipartFile.fromBytes(
          importedFile.value!.bytes!.toList(),
          filename: importedFile.value!.name,
        ),
        "TelecastDate": DateFormat("dd/MM/yyyy").format(DateFormat("dd-MM-yyyy").parse(date_.text)), //05 / 31 / 2023,
      },
    );

    Get.find<ConnectorControl>().POSTMETHOD_FORMDATA(
        api: ApiFactory.FILLER_IMPORT_EXCEL,
        json: formData,
        fun: (value) {
          Get.back();
          try {
            ExportData().exportFilefromByte(base64Decode(value), importedFile.value!.name);
          } catch (e) {
            LoadingDialog.callErrorMessage1(msg: "Failed To Import File");
          }
        });
  }

  pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single != null) {
      importedFile.value = result.files.single;
      fileController.text = result.files.single.name;
      importfile();
    } else {
      // User canceled the pic5ker
    }
  }

  // getFillerValueByCaption(fillerCaption) {
  //   try {
  //     Get.find<ConnectorControl>().GETMETHODCALL(
  //         api: ApiFactory.FILLER_VALUE_BY_CAPTION(fillerCaption),
  //         fun: (dynamic data) {
  //           print('>>> Filler Caption Code data $data');
  //           print('>>> Filler Code data ${data['fillerCode']}');
  //           getFillerValuesByFillerCode(data['fillerCode']);
  //         });
  //   } catch (e) {
  //     LoadingDialog.callErrorMessage1(msg: "Failed To Load Initial Data");
  //   }
  // }

  getFillerValuesByFillerCode(fillerCode) {
    try {
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.FILLER_VALUES_BY_FILLER_CODE(fillerCode),
          fun: (data) {
            print('>> Fillers Value : ${data}');
            tapeId_.text = data['exportTapeCode'];
            segNo_.text = data['segmentNumber'];
            segDur_.text = data['fillerDuration'];
            // if (data is List) {
            //   channels.value = data
            //       .map((e) => DropDownValue(
            //       key: e["fillerCode"], value: e["fillerCaption"]))
            //       .toList();
            // } else {
            //   LoadingDialog.callErrorMessage1(
            //       msg: "Failed To Load Initial Data");
            // }
          });
    } catch (e) {
      LoadingDialog.callErrorMessage1(msg: "Failed To Load Initial Data");
    }
  }

  getFillerValuesByTapeCode(tapeCode) {
    try {
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.FILLER_VALUES_BY_TAPE_CODE(tapeCode),
          fun: (dynamic data) {
            print('>>> Data from Tape Code : $data');

            /// Need to show date in Filler caption, filler dropdown,tape idseg dur,total dur
            fillerCode = data['fillerCode'];

            ///selectCaption.value = data['fillerCaption'];
            tapeId_.text = data['exportTapeCode'];
            segNo_.text = data['segmentNumber'];
            segDur_.text = data['fillerDuration'];
          });
    } catch (e) {
      LoadingDialog.callErrorMessage1(msg: "Failed To Load Initial Data");
    }
  }

  getFillerValuesByImportFillersWithTapeCode() {
    var jsonRequest = {
      "LocationCode": selectedImportLocation?.key.toString(),
      "ChannelCode": selectedImportChannel?.key.toString(),
      "ImportFromDate": DateFormat("dd/MM/yyyy").format(DateFormat("dd-MM-yyyy").parse(fillerFromDate_.text)),
      "ImportToDate": DateFormat("dd/MM/yyyy").format(DateFormat("dd-MM-yyyy").parse(fillerToDate_.text)),
      "TelecastTime": fromTime_.text,
      "ImportTime": toTime_.text,
    };
    LoadingDialog.call();
    Get.find<ConnectorControl>().POSTMETHOD(
      api: ApiFactory.FILLER_IMPORT_FILLERS,
      fun: (dynamic data) {
        Get.back();
        if (data.toString() == "Saved Successfully!") {
          LoadingDialog.callDataSaved(
              msg: data.toString(),
              callback: () {
                Get.back();
                Get.back();
                Get.back();
              });
        } else {
          LoadingDialog.showErrorDialog(data.toString());
        }
      },
      json: jsonRequest,
    );
  }

  fetchFPCDetails() {
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
          api: ApiFactory.FPC_DETAILS(selectedLocation?.key ?? "", selectedChannel?.key ?? "", dfFinal.format(selectedDate!)),
          fun: (dynamic list) {
            print("Json response is>>>" + jsonEncode(list));
            // Get.back();
            fillerDailyFpcList?.clear();
            list['dailyFPC'].forEach((element) {
              fillerDailyFpcList?.add(FillerDailyFPCModel.fromJson(element));
            });
            print(">>Update Called");
            update(["fillerFPCTable"]);
          },
          failed: (val) {
            Snack.callError(val.toString());
          });
    }
  }

  fetchSegmentDetails(FillerDailyFPCModel fillerDailyFpc) {
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
          api: ApiFactory.SEGMENT_DETAILS(
              //    programCode, exportTapeCode, episodeNumber, originalRepeatCode, locationCode, channelCode, startTime, date),
              fillerDailyFpc.programCode,
              fillerDailyFpc.tapeID,
              fillerDailyFpc.epsNo,
              fillerDailyFpc.oriRep,
              selectedLocation?.key ?? "",
              selectedChannel?.key ?? "",
              fillerDailyFpc.fpcTime,
              dfFinal.format(selectedDate!)),
          //  selectedLocation?.key ?? "", selectedChannel?.key ?? "",
          //      df2.format(selectedDate!),fillerDailyFpc,"","","",""),
          fun: (List list) {
            // Get.back();
            fillerSegmentList?.clear();
            list.forEach((element) {
              fillerSegmentList?.add(FillerSegmentModel.fromJson(element));
            });
            update(["fillerSegmentTable"]);
          },
          failed: (val) {
            Snack.callError(val.toString());
          });
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
                  ? (element.value.toString().contains('T') && element.value.toString().split('T')[1] == '00:00:00')
                      ? DateFormat("dd/MM/yyyy").format(DateFormat('yyyy-MM-ddTHH:mm:ss').parse(element.value.toString()))
                      : DateFormat("dd/MM/yyyy HH:mm:ss").format(DateFormat('yyyy-MM-ddTHH:mm:ss').parse(element.value.toString()))
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
    for (Map row in beams.where((element) => element["program"] == conflictReportStateManager.currentRow!.cells["Program"]!.value)) {
      Map<String, PlutoCell> cells = {};

      for (var element in row.entries) {
        cells[element.key] = PlutoCell(
          value: element.key == "selected" || element.value == null
              ? ""
              : element.key.toString().toLowerCase().contains("date")
                  ? (element.value.toString().contains('T') && element.value.toString().split('T')[1] == '00:00:00')
                      ? DateFormat("dd/MM/yyyy").format(DateFormat('yyyy-MM-ddTHH:mm:ss').parse(element.value.toString()))
                      : DateFormat("dd/MM/yyyy HH:mm:ss").format(DateFormat('yyyy-MM-ddTHH:mm:ss').parse(element.value.toString()))
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

  bool isBMSTimeGreater(String? value, String? refrence) {
    var firstvalue = value!.split(":");
    var secondValue = refrence!.split(":");
    for (var i = 0; i < 4; i++) {
      if (int.parse(firstvalue[i]) > int.parse(secondValue[i])) {
        return true;
      }
    }
    return false;
  }

  void clear() {
    listData?.clear();
    locationEnable.value = true;
    channelEnable.value = true;
  }

  void exit() {
    Get.find<HomeController>().selectChild1.value = null;
    Get.delete<FillerController>();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

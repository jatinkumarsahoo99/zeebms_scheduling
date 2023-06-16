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
import '../../../providers/Utils.dart';
import '../FillerDailyFPCModel.dart';
import '../FillerSegmentModel.dart';
import 'package:dio/dio.dart' as dio;

class FillerController extends GetxController {
  var locations = <DropDownValue>[].obs;
  var importLocations = <DropDownValue>[].obs;
  var channels = <DropDownValue>[].obs;
  var importChannels = <DropDownValue>[].obs;
  var captions = <DropDownValue>[].obs;
  var locationFN = FocusNode();

  var fillerDailyFpcList = <FillerDailyFPCModel>[].obs;
  var fillerSegmentList = <FillerSegmentModel>[].obs;

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
  int bottomLastSelectedIdx = 0, topLastSelectedIdx = 0;

  late String fillerCode;

  /// Radio Button
  int selectedAfter = 0;

  //input controllers
  DropDownValue? selectLocation;
  DropDownValue? selectChannel;
  var selectCaption = Rxn<DropDownValue?>();
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

  void clear() {
    selectLocation = null;
    selectChannel = null;
    selectCaption.value = null;
    tapeId_.clear();
    segNo_.clear();
    fillerDailyFpcList.clear();
    fillerSegmentList.clear();
    segDur_.clear();
    totalFiller.clear();
    totalFillerDur.text = "00:00:00:00";
    segDur_.text = "00:00:00:00";
    listData?.clear();
    locationEnable.value = true;
    channelEnable.value = true;
    locationFN.requestFocus();
    bottomLastSelectedIdx = 0;
    topLastSelectedIdx = 0;
    clearBottonControlls();
  }

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
  PlutoGridStateManager? bottomSM;
  var tempMap = {};

  formHandler(btnName) async {
    if (btnName == "Clear") {
      clear();
    } else if (btnName == "Save") {
      saveData();
    }
  }

  saveData() {
    if (selectLocation == null) {
      LoadingDialog.showErrorDialog("Please select Location,Channel");
    } else {
      Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.FILLER_SAVE,
        fun: (resp) {},
      );
    }
  }

  getLocation() {
    LoadingDialog.call();
    try {
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.FILLER_LOCATION,
          fun: (data) {
            Get.back();
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
    LoadingDialog.call();
    try {
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.FILLER_CHANNEL(locationCode),
          fun: (data) {
            Get.back();
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

  getFillerValuesByFillerCode(DropDownValue fillerCode) {
    try {
      selectCaption.value = fillerCode;
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.FILLER_VALUES_BY_FILLER_CODE(fillerCode.key),
          fun: (data) {
            // print('>> Fillers Value : ${data}');
            tempMap = data;
            tapeId_.text = data['exportTapeCode'];
            segNo_.text = data['segmentNumber'];
            segDur_.text = data['fillerDuration'];
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
    if (selectedLocation == null) {
      Snack.callError("Please select location");
    } else if (selectedChannel == null) {
      Snack.callError("Please select location");
    } else if (selectedDate == null) {
      Snack.callError("Please select date");
    } else {
      LoadingDialog.call();
      selectedDate = df1.parse(date_.text);
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.FPC_DETAILS(selectedLocation?.key ?? "", selectedChannel?.key ?? "", dfFinal.format(selectedDate!)),
          fun: (dynamic list) {
            Get.back();
            fillerDailyFpcList.clear();
            list['dailyFPC'].forEach((element) {
              fillerDailyFpcList.add(FillerDailyFPCModel.fromJson(element));
            });
          },
          failed: (val) {
            Get.back();
            Snack.callError(val.toString());
          });
    }
  }

  fetchSegmentDetails(FillerDailyFPCModel fillerDailyFpc) {
    if (selectedLocation == null) {
      Snack.callError("Please select location");
    } else if (selectedChannel == null) {
      Snack.callError("Please select location");
    } else if (selectedDate == null) {
      Snack.callError("Please select date");
    } else {
      LoadingDialog.call();
      selectedDate = df1.parse(date_.text);
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.SEGMENT_DETAILS(
            fillerDailyFpc.programCode,
            fillerDailyFpc.tapeID,
            fillerDailyFpc.epsNo,
            fillerDailyFpc.oriRep,
            selectedLocation?.key ?? "",
            selectedChannel?.key ?? "",
            fillerDailyFpc.fpcTime,
            dfFinal.format(selectedDate!),
          ),
          fun: (List list) {
            Get.back();
            fillerSegmentList.clear();
            for (var element in list) {
              fillerSegmentList.add(FillerSegmentModel.fromJson(element));
            }
          },
          failed: (val) {
            Snack.callError(val.toString());
          });
    }
  }

  fetchGenerate() {
    if (selectedLocation == null) {
      Snack.callError("Please select Location");
    } else if (selectedChannel == null) {
      Snack.callError("Please select Channel");
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

  @override
  void onReady() {
    super.onReady();
    getLocation();
  }

  void handleAddTap() {
    if (selectCaption.value == null || selectCaption.value?.key == null || tempMap.isEmpty) {
      LoadingDialog.showErrorDialog("Please select caption");
      return;
    }
    try {
      var tempMode = FillerSegmentModel(
        segNo: null,
        brkNo: (fillerSegmentList[bottomLastSelectedIdx].segNo == null)
            ? fillerSegmentList[bottomLastSelectedIdx].brkNo
            : fillerSegmentList[bottomLastSelectedIdx].segNo,
        brktype: "A",
        fillerCode: tempMap['fillerCode'],
        allowMove: "1",
        segmentCaption: selectCaption.value?.value,
        segDur: segDur_.text,
        tapeID: tapeId_.text,
        som: Utils.convertToTimeFromDouble(
            value: ((Utils.convertToSecond(value: fillerSegmentList[bottomLastSelectedIdx].som ?? "")) +
                (Utils.convertToSecond(value: fillerSegmentList[bottomLastSelectedIdx].segDur ?? "")))),
      );
      bottomLastSelectedIdx = bottomLastSelectedIdx + 1;
      fillerSegmentList.insert(bottomLastSelectedIdx, tempMode);
      fillerSegmentList.refresh();
      var temp1st = fillerDailyFpcList[topLastSelectedIdx];
      var totalDuration = temp1st.fpcTime;
      var segDur = "0";
      int i = 1;
      fillerSegmentList.map((element) {
        if (i == 1) {
          element.som = totalDuration;
          i = 2;
        } else {
          element.som = totalDuration;
        }
        if (element.allowMove == "1") {
          segDur = "${Utils.convertToSecond(value: element.segDur ?? "")}$segDur";
        }
        totalDuration = Utils.convertToTimeFromDouble(
            value: (Utils.convertToSecond(value: totalDuration ?? "") + Utils.convertToSecond(value: element.segDur ?? "")));
        return element;
      });
      totalFiller.text = fillerSegmentList.where((o) => o.allowMove == "1").toList().length.toString();
      if (totalFillerDur.text == "00:00:00:00") {
        totalFillerDur.text = tempMap['fillerDuration'];
      } else {
        totalFillerDur.text = Utils.convertToTimeFromDouble(
            value: Utils.convertToSecond(value: totalFillerDur.text) + Utils.convertToSecond(value: tempMap['fillerDuration']));
      }
      // totalFillerDur.text = Utils.convertToTimeFromDouble(value: Utils.convertToSecond(value: segDur));
      clearBottonControlls();
      bottomSM?.setCurrentCell(bottomSM?.getRowByIdx(bottomLastSelectedIdx)?.cells['segNo'], bottomLastSelectedIdx);
    } catch (e) {
      LoadingDialog.showErrorDialog(e.toString());
    }
  }

  clearBottonControlls() {
    selectCaption.value = null;
    selectCaption.refresh();
    tapeId_.clear();
    segNo_.clear();
    segDur_.clear();
    tempMap.clear();
  }
}

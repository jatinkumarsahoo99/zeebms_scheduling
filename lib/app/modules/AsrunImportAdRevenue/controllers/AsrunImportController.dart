import 'package:bms_scheduling/app/modules/AsrunImportAdRevenue/bindings/arun_data.dart';
import 'package:bms_scheduling/app/modules/AsrunImportAdRevenue/bindings/asrun_fpc_data.dart';
import 'package:bms_scheduling/app/providers/extensions/string_extensions.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';
import 'package:intl/intl.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../controller/MainController.dart';
import '../../../data/DropDownValue.dart';
import '../../../providers/ApiFactory.dart';
import '../../home/controllers/home_controller.dart';
import '../AsrunImportModel.dart';
import 'package:dio/dio.dart' as dio;

class AsrunImportController extends GetxController {
  var locations = RxList<DropDownValue>();
  var channels = RxList<DropDownValue>([]);
  RxBool isEnable = RxBool(true);

  //input controllers
  DropDownValue? selectLocation;
  DropDownValue? selectChannel;
  List<AsRunData>? asrunData;
  List<AsrunFPCData>? viewFPCData;
  PlutoGridStateManager? gridStateManager;
  PlutoGridStateManager? fpcGridStateManager;
  int? selectedFPCindex;
  RxList<Map> checkboxes = RxList<Map>([
    {"name": "FPC", "value": false},
    {"name": "Mark Slot", "value": false},
    {"name": "Don't Update Exposure", "value": false},
    {"name": "GFK ", "value": false},
    {"name": "DailyFPC", "value": false},
    {"name": "Amagi", "value": false},
  ]);
  RxMap checkboxesMap = RxMap({"FPC": false, "Mark Slot": false, "Don't Update Exposure": false, "GFK": false, "DailyFPC": false, "Amagi": false});

  //  [
  //   {"name": "FPC", "value": false},
  //   {"name": "Mark Slot", "value": false},
  //   {"name": "Don't Update Exposure ", "value": false},
  //   {"name": "GFK ", "value": false},
  //   {"name": "DailyFPC", "value": false},
  //   {"name": "Amagi", "value": false},
  // ]);

  // PlutoGridMode selectedPlutoGridMode = PlutoGridMode.normal;
  var isStandby = RxBool(false);
  var isMy = RxBool(true);
  var isInsertAfter = RxBool(false);
  TextEditingController selectedDate = TextEditingController();
  TextEditingController startTime_ = TextEditingController();

  List<AsrunImportModel>? transmissionLogList = List.generate(100, (index) => new AsrunImportModel(episodeDuration: (index + 1), status: "data1"));
  PlutoGridMode selectedPlutoGridMode = PlutoGridMode.selectWithOneTap;
  int? selectedIndex;
  RxnString verifyType = RxnString();
  RxList<DropDownValue> listLocation = RxList([]);
  RxList<DropDownValue> listChannel = RxList([]);
  List addlbtns = [
    {"id": 6, "name": "Import", "isDisabled": true},
    {"id": 7, "name": "Commercials", "isDisabled": false},
    {"id": 8, "name": "Error", "isDisabled": false},
    {"id": 9, "name": "View FPC", "isDisabled": false},
    {"id": 10, "name": "SP Verify", "isDisabled": false},
    {"id": 11, "name": "Swap", "isDisabled": false},
    {"id": 12, "name": "Paste Up", "isDisabled": false},
    {"id": 13, "name": "Paste Down", "isDisabled": false},
    {"id": 14, "name": "Up", "isDisabled": false},
    {"id": 15, "name": "Down", "isDisabled": false},
  ];
  @override
  void onInit() {
    super.onInit();
    getLocations();
  }

  getLocations() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.AsrunImport_GetLoadLocation,
        fun: (Map map) {
          locations.clear();
          map["location"].forEach((e) {
            locations.add(DropDownValue.fromJson1(e));
          });
        });
  }

  getChannels(String locationCode) {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.AsrunImport_GetLocationSelect(locationCode),
        fun: (Map map) {
          channels.clear();
          map["locationSelect"].forEach((e) {
            channels.add(DropDownValue.fromJsonDynamic(e, "channelCode", "channelName"));
          });
        });
  }

  loadAsrunData() {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.AsrunImport_LoadRunData(selectLocation?.key, selectChannel?.key, selectedDate.text.fromdMyToyMd()),
        json: {},
        fun: (map) {
          if (map is Map && map.containsKey("asRunData")) {
            print("list found");

            if (map['asRunData'] != null) {
              asrunData = <AsRunData>[];
              map['asRunData'].forEach((v) {
                asrunData!.add(AsRunData.fromJson(v));
              });
            }

            update(["fpcData"]);
            Get.find<HomeController>().update(["transButtons"]);
          }
        });
  }

  loadviewFPCData() {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.AsrunImport_LoadFPCData(selectLocation?.key, selectChannel?.key, selectedDate.text.fromdMyToyMd()),
        json: {},
        fun: (map) {
          if (map is Map && map.containsKey("fpcData")) {
            print("list found");

            if (map['fpcData'] != null) {
              viewFPCData = <AsrunFPCData>[];
              map['fpcData'].forEach((v) {
                viewFPCData!.add(AsrunFPCData.fromJson(v));
              });
            }

            update(["fpcData"]);
          }
        });
  }

  updateFPCMismatch() {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.AsrunImport_UpdateFPCMismatch(selectLocation?.key, selectChannel?.key, selectedDate.text.fromdMyToyMd()),
        json: {},
        fun: (map) {
          if (map is Map && map.containsKey("progMismatch") && map["progMismatch"]["message"] != null) {
            LoadingDialog.callInfoMessage(map["progMismatch"]["message"]);
          }
        });
  }

  filterMainGrid(String fpcTime) {
    if (fpcTime.isNotEmpty) {
      gridStateManager?.setFilter((element) => element.cells["fpctIme"]?.value.toString() == fpcTime);
    }
  }

  saveTempDetails() {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.AsrunImport_SaveTempDetail,
        json: {
          "LocationCode": selectLocation?.key,
          "ChannelCode": selectChannel?.key,
          "TelecaseDate": selectedDate.text.fromdMyToyMd(),
          "ProcessFPC": checkboxesMap["FPC"],
          "MarkBookedCommercials": checkboxesMap["Mark Slot"],
          "exposureProgramUpdate": checkboxesMap["Don't Update Exposure"],
          "ReverseAsRunOrder": false,
          "ForMarkCommercial": false,
          "TemptableList": [
            {
              "EventNumber": asrunData?[gridStateManager!.currentRowIdx!].eventNumber,
              "TelecastDate": asrunData?[gridStateManager!.currentRowIdx!].telecastdate,
              "TeleCastTime": asrunData?[gridStateManager!.currentRowIdx!].telecasttime,
              "Tapeid": asrunData?[gridStateManager!.currentRowIdx!].tapeId,
              "SegmentNumber": asrunData?[gridStateManager!.currentRowIdx!].segmentnumber,
              "caption": asrunData?[gridStateManager!.currentRowIdx!].caption,
              "TelecastDuration": asrunData?[gridStateManager!.currentRowIdx!].telecastDuration,
              "EventType": asrunData?[gridStateManager!.currentRowIdx!].eventtype,
              "FPCtime": asrunData?[gridStateManager!.currentRowIdx!].fpctIme,
              "ProgramCode": asrunData?[gridStateManager!.currentRowIdx!].programCode,
              "BookingNumber": asrunData?[gridStateManager!.currentRowIdx!].bookingnumber,
              "BookingDetailcode": asrunData?[gridStateManager!.currentRowIdx!].bookingdetailcode,
              "CommercialCode": "",
              "ReconKey": ""
            }
          ]
        },
        fun: (map) {
          if (map is Map && map.containsKey("progMismatch") && map["progMismatch"]["message"] != null) {
            LoadingDialog.callInfoMessage(map["progMismatch"]["message"]);
          }
        });
  }

  checkMissingAsrun() {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.AsrunImport_CheckMissingAsRun,
        json: {"startTime": startTime_.text, "checkMissingAsRuns": asrunData?.map((e) => e.toJson()).toList()},
        fun: (map) {
          // if (map is Map && map.containsKey("progMismatch") && map["progMismatch"]["message"] != null) {
          //   LoadingDialog.callInfoMessage(map["progMismatch"]["message"]);
          // }
        });
  }

  updateFPCTime() {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.AsrunImport_UpdateFPCTime,
        json: {
          "programName": viewFPCData?[selectedFPCindex!].programName,
          "fpcTime": viewFPCData?[selectedFPCindex!].starttime,
          "programCode": viewFPCData?[selectedFPCindex!].programcode,
          "LocationCode": selectLocation?.key,
          "Channelcode": selectChannel?.key,
          "ObjProgList": [FPCProgramList.convertAsRunDataToFPCProgramList(asrunData![gridStateManager?.currentRowIdx ?? 0]).toJson()]
        },
        fun: (map) {
          if (map is Map && map.containsKey("asRunData")) {
            print("list found");

            // if (map['asRunData'] != null) {
            //   asrunData = <AsRunData>[];
            //   map['asRunData'].forEach((v) {
            //     asrunData!.add(AsRunData.fromJson(v));
            //   });
            // }

            // update(["fpcData"]);
          }
        });
  }

  checkError() {
    if (gridStateManager?.currentCell == null) {
      gridStateManager?.setCurrentCell(gridStateManager?.rows.first.cells.values.first, 0);
    }
    bool rowFound = false;
    for (var row in gridStateManager?.rows ?? <PlutoRow>[]) {
      if (row.sortIdx > gridStateManager!.currentCell!.row.sortIdx) {
        if ((row.cells["isMismatch"]?.value.toString() ?? "") == "1") {
          gridStateManager?.setCurrentCell(row.cells["isMismatch"], row.sortIdx);
          gridStateManager?.moveScrollByRow(PlutoMoveDirection.down, row.sortIdx);
          gridStateManager?.scrollByDirection(PlutoMoveDirection.down, 20);
          rowFound = true;
          break;
        }
      }
    }
    if (!rowFound) {
      LoadingDialog.modify("You have reached the end! Do you wanto restart?", () {
        gridStateManager?.setCurrentCell(gridStateManager?.rows.first.cells.values.first, 0);
        checkError();
      }, () {}, deleteTitle: "Yes", cancelTitle: "No");
    }
  }

  pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single != null) {
      importfile(result.files[0]);
    } else {
      // User canceled the pic5ker
    }
  }

  importfile(PlatformFile? file) async {
    LoadingDialog.call();
    dio.FormData formData = dio.FormData.fromMap({
      'ChannelCode': selectChannel?.key,
      'TelecastDate': '05/31/2023',
      'ImportFile': dio.MultipartFile.fromBytes(
        file!.bytes!.toList(),
        filename: file!.name,
      ),
      'LocationCode': selectLocation?.key,
      'LogDate': selectedDate.text.fromdMyToyMd(),
      'TelecastDate': selectedDate.text.fromdMyToyMd(),
      'CheckType': "${checkboxesMap["GFK"] ? "GFK," : ""}${checkboxesMap["DailyFPC"] ? "DailyFPC," : ""}${checkboxesMap["Amagi"] ? "Amagi" : ""}",
      'StartTime': '00:00:10:00',
      'ProcessFPC': checkboxesMap["FPC"],
    });

    Get.find<ConnectorControl>().POSTMETHOD_FORMDATA(
        api: ApiFactory.AsrunImport_AsunOnImport,
        json: formData,
        fun: (value) {
          Get.back();
          if (value is Map && value.containsKey("asrunDetails")) {
            if (value["asrunDetails"]["lstTempResponse"]['lstSaveTempDetailResponse'] != null) {
              asrunData = <AsRunData>[];
              value["asrunDetails"]["lstTempResponse"]['lstSaveTempDetailResponse'].forEach((v) {
                asrunData!.add(AsRunData.fromJson(v));
              });
            }
          }
          Get.find<HomeController>().update(["transButtons"]);

          update(["fpcData"]);
        });
  }
}

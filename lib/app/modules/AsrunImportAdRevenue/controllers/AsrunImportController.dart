import 'package:bms_scheduling/app/controller/HomeController.dart';
import 'package:bms_scheduling/app/modules/AsrunImportAdRevenue/bindings/arun_data.dart';
import 'package:bms_scheduling/app/modules/AsrunImportAdRevenue/bindings/asrun_fpc_data.dart';
import 'package:bms_scheduling/app/providers/ExportData.dart';
import 'package:bms_scheduling/app/providers/Utils.dart';
import 'package:bms_scheduling/app/providers/extensions/string_extensions.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';
import 'package:dio/dio.dart' as dio;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/ConnectorControl.dart';
import '../../../controller/MainController.dart';
import '../../../data/DropDownValue.dart';
import '../../../data/user_data_settings_model.dart';
import '../../../providers/ApiFactory.dart';
import '../AsrunImportModel.dart';

class AsrunImportController extends GetxController {
  var locations = RxList<DropDownValue>();
  var channels = RxList<DropDownValue>([]);
  RxBool isEnable = RxBool(true);
  final pickFileName = "".obs;

  //input controllers
  DropDownValue? selectLocation;
  DropDownValue? selectChannel;
  List<AsRunData>? asrunData;
  List<AsrunFPCData>? viewFPCData;
  PlutoGridStateManager? gridStateManager;
  PlutoGridStateManager? fpcGridStateManager;
  int? selectedFPCindex;

  int? fromIdx, toIdx, realFromIdx, realToIdx;
  RxList<Map> checkboxes = RxList<Map>([
    {"name": "FPC", "value": false},
    {"name": "Mark Slot", "value": false},
    {"name": "Don't Update Exposure", "value": false},
    {"name": "GFK ", "value": false},
    {"name": "DailyFPC", "value": false},
    {"name": "Amagi", "value": false},
  ]);
  RxMap checkboxesMap = RxMap({
    "FPC": false,
    "Mark Slot": false,
    "Don't Update Exposure": false,
    "GFK": false,
    "DailyFPC": false,
    "Amagi": false
  });
  var drgabbleDialog = Rxn<Widget>();

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
  var fromSwap = Rxn<AsRunData>();
  var toSwap = Rxn<AsRunData>();
  int? fromSwapIndex;
  int? toSwapIndex;

  TextEditingController selectedDate = TextEditingController();
  TextEditingController startTime_ = TextEditingController(text: "00:00:00");

  List<AsrunImportModel>? transmissionLogList = List.generate(
      100,
      (index) =>
          new AsrunImportModel(episodeDuration: (index + 1), status: "data1"));
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

  @override
  void onReady() {
    super.onReady();
    fetchUserSetting1();
  }

  UserDataSettings? userDataSettings;

  fetchUserSetting1() async {
    userDataSettings = await Get.find<HomeController>().fetchUserSetting2();
    update(['fpcData']);
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
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.AsrunImport_GetLocationSelect(locationCode),
        fun: (Map map) {
          Get.back();
          channels.clear();
          map["locationSelect"].forEach((e) {
            channels.add(
                DropDownValue.fromJsonDynamic(e, "channelCode", "channelName"));
          });
        });
  }

  loadAsrunData() async {
    isEnable.value = false;
    await Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.AsrunImport_LoadRunData(selectLocation?.key,
            selectChannel?.key, selectedDate.text.fromdMyToyMd()),
        json: {},
        fun: (map) {
          if (map is Map && map.containsKey("asRunData")) {
            print("list found");

            if (map['asRunData']["lstAsrunData"] != null) {
              asrunData = <AsRunData>[];
              int i = 0;
              map['asRunData']["lstAsrunData"].forEach((v) {
                v['rowNo'] = i;
                asrunData!.add(AsRunData.fromJson(v));
                i++;
              });
            }
            startTime_.text = map['asRunData']["startTime"];
            update(["fpcData"]);
            update(["transButtons"]);
          }
        });
  }

  loadviewFPCData() async {
    await Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.AsrunImport_LoadFPCData(selectLocation?.key,
            selectChannel?.key, selectedDate.text.fromdMyToyMd()),
        json: {},
        fun: (map) {
          if (map is Map && map.containsKey("fpcData")) {
            print("list found");

            if (map['fpcData'] != null) {
              viewFPCData = <AsrunFPCData>[];
              map['fpcData'].forEach((v) {
                viewFPCData!.add(AsrunFPCData.fromJson(v));
              });
              for (var i = 0; i < (viewFPCData ?? []).length; i++) {
                if (asrunData?.any((element) =>
                        element.fpctIme == viewFPCData?[i].starttime) ??
                    false) {
                  viewFPCData?[i].present = 1;
                }
              }
            }

            update(["fpcData"]);
          }
        });
  }

  updateFPCMismatch() {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.AsrunImport_UpdateFPCMismatch(selectLocation?.key,
            selectChannel?.key, selectedDate.text.fromdMyToyMd()),
        json: {},
        fun: (map) {
          if (map is Map &&
              map.containsKey("progMismatch") &&
              map["progMismatch"]["message"] != null) {
            LoadingDialog.callInfoMessage(map["progMismatch"]["message"]);
          }
        });
  }

  filterMainGrid(String fpcTime) {
    if (fpcTime.isNotEmpty) {
      gridStateManager?.setFilter(
          (element) => element.cells["fpctIme"]?.value.toString() == fpcTime);
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
          "ForMarkCommercial": true,
          "startTime": startTime_.text,
          "TemptableList":
              asrunData?.map((e) => e.toJson(isSegInt: false)).toList()
          //  [
          //   {
          //     "EventNumber":
          //         asrunData?[gridStateManager!.currentRowIdx!].eventNumber,
          //     "TelecastDate":
          //         asrunData?[gridStateManager!.currentRowIdx!].telecastdate,
          //     "TeleCastTime":
          //         asrunData?[gridStateManager!.currentRowIdx!].telecasttime,
          //     "Tapeid": asrunData?[gridStateManager!.currentRowIdx!].tapeId,
          //     "SegmentNumber": asrunData?[gridStateManager!.currentRowIdx!]
          //         .segmentnumber
          //         .toString(),
          //     "caption": asrunData?[gridStateManager!.currentRowIdx!].caption,
          //     "TelecastDuration":
          //         asrunData?[gridStateManager!.currentRowIdx!].telecastDuration,
          //     "EventType":
          //         asrunData?[gridStateManager!.currentRowIdx!].eventtype,
          //     "FPCtime": asrunData?[gridStateManager!.currentRowIdx!].fpctIme,
          //     "ProgramCode":
          //         asrunData?[gridStateManager!.currentRowIdx!].programCode,
          //     "BookingNumber":
          //         asrunData?[gridStateManager!.currentRowIdx!].bookingnumber,
          //     "BookingDetailcode": (asrunData?[gridStateManager!.currentRowIdx!]
          //                 .bookingdetailcode ??
          //             "")
          //         .toString(),
          //     "CommercialCode": "",
          //     "ReconKey": ""
          //   }
          // ]
        },
        fun: (map) {
          if (map is Map &&
              map.containsKey("asrunTempDetails") &&
              map["asrunTempDetails"]["lstSaveTempDetailResponse"] != null) {
            asrunData = <AsRunData>[];
            map["asrunTempDetails"]["lstSaveTempDetailResponse"].forEach((v) {
              asrunData!.add(AsRunData.fromJson(v));
            });
            update(["fpcData"]);
            update(["transButtons"]);
          }
        });
  }

  checkMissingAsrun() {
    if (startTime_.text.isEmpty || asrunData!.isEmpty) {
      LoadingDialog.showErrorDialog("No Data to Save");
    } else {
      LoadingDialog.call();
      Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.AsrunImport_CheckMissingAsRun,
          json: {
            "startTime": startTime_.text,
            "checkMissingAsRuns":
                asrunData?.map((e) => e.toJson(isSegInt: false)).toList()
          },
          fun: (map) {
            Get.back();
            if (map is Map &&
                map.containsKey("isCheck") &&
                map.containsKey("message")) {
              if (map["message"].toString().split("\n").first != "null") {
                LoadingDialog.callInfoMessage(
                    map["message"].toString().split("\n").first, callback: () {
                  LoadingDialog.modify(
                      "Asrun Missing Do Yount Want To Proceed with Save?", () {
                    saveAsrun();
                  }, () {}, cancelTitle: "No", deleteTitle: "Yes");
                });
                // saveAsrun();
              } else {
                saveAsrun();
              }
            }
            // if (map is Map && map.containsKey("progMismatch") && map["progMismatch"]["message"] != null) {
            //   LoadingDialog.callInfoMessage(map["progMismatch"]["message"]);
            // }
          });
    }
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
          "ObjProgList": [
            FPCProgramList.convertAsRunDataToFPCProgramList(
                    asrunData![gridStateManager?.currentRow?.sortIdx ?? 0])
                .toJson()
          ]
        },
        fun: (map) {
          if (map is Map && map.containsKey("asRunData")) {
            if (map is Map && map.containsKey("fpcProgramData")) {
              var currentCell = gridStateManager!.currentCell;
              int index = gridStateManager!.currentRow!.sortIdx;
              asrunData?[index].programName =
                  viewFPCData?[selectedFPCindex!].programName;
              asrunData?[index].programCode =
                  viewFPCData?[selectedFPCindex!].programcode;
              asrunData?[index].fpctIme =
                  viewFPCData?[selectedFPCindex!].starttime;

              // if (map['asRunData'] != null) {
              //   asrunData = <AsRunData>[];
              //   map['asRunData'].forEach((v) {
              //     asrunData!.add(AsRunData.fromJson(v));
              //   });
              // }

              update(["fpcData"]);
              gridStateManager?.setCurrentCell(
                  gridStateManager!.currentCell, index);
            }

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

  manualUpdateFPCTime(
    programName,
    programCode,
    fpcTime,
    AsRunData asRunData,
  ) {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.AsrunImport_UpdateFPCTime,
        json: {
          "programName": programName,
          "fpcTime": fpcTime,
          "programCode": programCode,
          "LocationCode": selectLocation?.key,
          "Channelcode": selectChannel?.key,
          "ObjProgList": [
            FPCProgramList.convertAsRunDataToFPCProgramList(asRunData).toJson()
          ]
        },
        fun: (map) {
          if (map is Map && map.containsKey("fpcProgramData")) {
            int index = gridStateManager!.currentRow!.sortIdx;
            asrunData?[index].programName = programName;
            asrunData?[index].programCode = programCode;
            asrunData?[index].fpctIme = fpcTime;
            for (var i = 0; i < asrunData!.length; i++) {
              if ((asrunData?[i].fpctIme == null ||
                      asrunData?[i].fpctIme == "") &&
                  i < gridStateManager!.currentRow!.sortIdx) {
                asrunData?[i].fpctIme = fpcTime;
              }
            }

            // gridStateManager?.changeCellValue(
            //     gridStateManager!.currentRow!.cells["programName"]!,
            //     map["fpcProgramData"][0]["programName"],
            //     force: true);
            // asrunData![gridStateManager!.currentRow!.sortIdx].fpctIme =
            //     map["fpcProgramData"][0]["fpcTime"] ?? "";
            // asrunData![gridStateManager!.currentRow!.sortIdx].programCode =
            //     map["fpcProgramData"][0]["programCode"] ?? "";
            // asrunData![gridStateManager!.currentRow!.sortIdx].programName =
            //     map["fpcProgramData"][0]["programName"] ?? "";
            // gridStateManager?.changeCellValue(
            //     gridStateManager!.currentRow!.cells["fpctIme"]!,
            //     map["fpcProgramData"][0]["fpcTime"] ?? "",
            //     force: true);

            // if (map['asRunData'] != null) {
            //   asrunData = <AsRunData>[];
            //   map['asRunData'].forEach((v) {
            //     asrunData!.add(AsRunData.fromJson(v));
            //   });
            // }
            print("object");
            update(["fpcData"]);
          }
        });
  }

  checkError() {
    if (gridStateManager?.currentCell == null) {
      gridStateManager?.setCurrentCell(
          gridStateManager?.rows.first.cells.values.first, 0);
    }
    bool rowFound = false;
    for (var row in gridStateManager?.rows ?? <PlutoRow>[]) {
      if (row.sortIdx > gridStateManager!.currentCell!.row.sortIdx) {
        if ((row.cells["isMismatch"]?.value.toString() ?? "") == "1") {
          gridStateManager?.setCurrentCell(
              row.cells["isMismatch"], row.sortIdx);
          gridStateManager?.moveScrollByRow(
              PlutoMoveDirection.down, row.sortIdx);
          gridStateManager?.scrollByDirection(PlutoMoveDirection.down, 20);
          rowFound = true;
          break;
        }
      }
    }
    if (!rowFound) {
      LoadingDialog.modify("You have reached the end! Do you wanto restart?",
          () {
        gridStateManager?.setCurrentCell(
            gridStateManager?.rows.first.cells.values.first, 0);
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
      'TelecastDate': selectedDate.text.fromdMyToyMd(),
      'ImportFile': dio.MultipartFile.fromBytes(
        file!.bytes!.toList(),
        filename: file.name,
      ),
      'LocationCode': selectLocation?.key,
      'LogDate': selectedDate.text.fromdMyToyMd(),
      'TelecastDate': selectedDate.text.fromdMyToyMd(),
      'CheckType':
          "${checkboxesMap["GFK"] ? "GFK," : ""}${checkboxesMap["DailyFPC"] ? "DailyFPC," : ""}${checkboxesMap["Amagi"] ? "Amagi" : ""}",
      'StartTime': '00:00:10:00',
      'ProcessFPC': checkboxesMap["FPC"],
    });

    Get.find<ConnectorControl>().POSTMETHOD_FORMDATA(
        api: ApiFactory.AsrunImport_AsunOnImport,
        json: formData,
        fun: (value) {
          Get.back();
          if (value is Map && value.containsKey("asrunDetails")) {
            if (value["asrunDetails"]["lstTempResponse"]
                    ['lstSaveTempDetailResponse'] !=
                null) {
              asrunData = <AsRunData>[];
              value["asrunDetails"]["lstTempResponse"]
                      ['lstSaveTempDetailResponse']
                  .forEach((v) {
                asrunData!.add(AsRunData.fromJson(v));
              });
            }
            update(["fpcData"]);
            if (value["asrunDetails"]["lstTempResponse"]['showPopup'] != null &&
                value["asrunDetails"]["lstTempResponse"]['showPopup']
                    ["isCheck"]) {
              LoadingDialog.callInfoMessage(value["asrunDetails"]
                  ["lstTempResponse"]['showPopup']["message"]);
            }
          }

          update(["transButtons"]);
        });
  }

  saveAsrun() {
    LoadingDialog.call();
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.AsrunImport_SaveAsrunDetail,
        json: {
          "LocationCode": selectLocation?.key,
          "ChannelCode": selectChannel?.key,
          "AsrunDate": selectedDate.text.fromdMyToyMd(),
          "ModifiedBy": Get.find<MainController>().user?.logincode ?? "",
          "SaveDt": asrunData
              ?.map((e) => {
                    "EventNo": e.eventNumber,
                    "TelecastDate": e.telecastdate,
                    "fpctime": e.fpctIme,
                    "ProgramName": e.programName,
                    "TelecastTime": e.telecasttime,
                    "ExportTapeCode": e.tapeId,
                    "SegmentNumber": e.segmentnumber,
                    "ExportTapeCaption": e.caption,
                    "TapeDurationss": e.telecastDuration,
                    "EventType": e.eventtype,
                    "BookingNumber": e.bookingnumber,
                    "BookingDetailcode": e.bookingdetailcode,
                    "mismatch": int.tryParse(e.isMismatch ?? "")
                  })
              .toList(),
          "IsGFK": checkboxesMap["GFK"]
        },
        fun: (map) {
          Get.back();
          if (map is Map && map.containsKey("asrunDetails")) {
            Map asrundeatils = map["asrunDetails"];

            if (map["asrunDetails"]["isError"]) {
              LoadingDialog.callErrorMessage1(
                  msg: map["asrunDetails"]["errorMessage"]);
            } else {
              LoadingDialog.callDataSaved(
                  msg: map["asrunDetails"]["genericMessage"]);
            }
            if (asrundeatils["asrunSaveResponseGFK"] != null) {
              if (asrundeatils["asrunSaveResponseGFK"]["isGFK"]) {
                ExportData().exportFilefromBase64(
                    asrundeatils["asrunSaveResponseGFK"]["fileBytes"],
                    asrundeatils["asrunSaveResponseGFK"]["fileName"]);
              }
            }

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

  checkProgramSequence() {
    LoadingDialog.call();
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.AsrunImport_CheckProgramSequence,
        json: {
          "LocationCode": selectLocation?.key,
          "ChannelCode": selectChannel?.key,
          "AsrunDate": selectedDate.text.fromdMyToyMd(),
          "ModifiedBy": Get.find<MainController>().user?.logincode ?? "",
          "SaveDt": asrunData
              ?.map((e) => {
                    "EventNo": e.eventNumber,
                    "TelecastDate": e.telecastdate,
                    "fpctime": e.fpctIme,
                    "ProgramName": e.programName,
                    "TelecastTime": e.telecasttime,
                    "ExportTapeCode": e.tapeId,
                    "SegmentNumber": e.segmentnumber,
                    "ExportTapeCaption": e.caption,
                    "TapeDurationss": e.telecastDuration,
                    "EventType": e.eventtype,
                    "BookingNumber": e.bookingnumber,
                    "BookingDetailcode": e.bookingdetailcode,
                    "mismatch": int.tryParse(e.isMismatch ?? "")
                  })
              .toList(),
          "IsGFK": checkboxesMap["GFK"]
        },
        fun: (map) {
          Get.back();
          if (map is Map && map.containsKey("result")) {
            Map asrundeatils = map["result"];
            if (map["result"]["isError"]) {
              LoadingDialog.modify(
                map["result"]["errorMessage"],
                cancelTitle: "No",
                deleteTitle: "Yes",
                () {
                  print("yes");
                  checkMissingAsrun();
                },
                () {
                  print("no");
                  Get.back();
                },
              );
            }
          }
        });
  }

  checkGFK() {
    print(checkboxesMap.value['GFK']);
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.GFKCheck,
        json: {
          "LocationCode": selectLocation?.key,
          "ChannelCode": selectChannel?.key,
          "telecastDate": selectedDate.text.fromdMyToyMd(),
          "checkType": checkboxesMap.value['GFK']
        },
        fun: (map) {
          if (map is Map && map.containsKey("result")) {
            if (map["result"]["genericMessage"] != null) {
              LoadingDialog.modify(map["result"]["genericMessage"], () {
                print("yes");
                getfileName();
              }, () {
                print("no");
              }, cancelTitle: "No", deleteTitle: "Yes");
            } else {
              getfileName();
            }
            // checkMissingAsrun();
          }
        });
  }

  getfileName() {
    try {
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.AsrunImport_FileFormat(
            selectLocation?.key ?? '',
            selectChannel?.key ?? '',
            selectedDate.text.fromdMyToyMd(),
          ),
          fun: (data) {
            if (data != null) {
              String value = data['result'];
              print("Copy Value: $value");
              Utils.copyToClipboardHack(value);
              pickFile();
            } else {
              LoadingDialog.callErrorMessage1(
                  msg: "Failed To Load Initial Data");
            }
          });
    } catch (e) {
      LoadingDialog.callErrorMessage1(msg: "Failed To Load Initial Data");
    }
  }
}

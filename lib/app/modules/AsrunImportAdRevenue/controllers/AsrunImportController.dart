import 'package:bms_scheduling/app/modules/AsrunImportAdRevenue/bindings/arun_data.dart';
import 'package:bms_scheduling/app/modules/AsrunImportAdRevenue/bindings/asrun_fpc_data.dart';
import 'package:bms_scheduling/app/providers/extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';
import 'package:intl/intl.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../controller/MainController.dart';
import '../../../data/DropDownValue.dart';
import '../../../providers/ApiFactory.dart';
import '../AsrunImportModel.dart';

class AsrunImportController extends GetxController {
  var locations = RxList<DropDownValue>();
  var channels = RxList<DropDownValue>([]);
  RxBool isEnable = RxBool(true);

  //input controllers
  DropDownValue? selectLocation;
  DropDownValue? selectChannel;
  List<AsRunData>? asrunData;
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

  List<AsrunImportModel>? transmissionLogList = List.generate(100, (index) => new AsrunImportModel(episodeDuration: (index + 1), status: "data1"));
  PlutoGridMode selectedPlutoGridMode = PlutoGridMode.selectWithOneTap;
  int? selectedIndex;
  RxnString verifyType = RxnString();
  RxList<DropDownValue> listLocation = RxList([]);
  RxList<DropDownValue> listChannel = RxList([]);

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
        }
      }
    }
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/LoadingDialog.dart';
import '../../../../widgets/PlutoGrid/src/manager/pluto_grid_state_manager.dart';
import '../../../../widgets/PlutoGrid/src/model/pluto_cell.dart';
import '../../../../widgets/PlutoGrid/src/model/pluto_row.dart';
import '../../../../widgets/PlutoGrid/src/pluto_grid.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../providers/ApiFactory.dart';
import '../DSeriesModel.dart';

class DSeriesSpecificationController extends GetxController {
  final count = 0.obs;
  double widthSize = 0.12;
  RxList<DropDownValue> locationList = RxList([]);
  RxList<DropDownValue> channelList = RxList([]);
  RxList<DropDownValue> eventList = RxList([]);
  TextEditingController from_ = TextEditingController();
  TextEditingController to_ = TextEditingController();
  TextEditingController value_ = TextEditingController();
  TextEditingController desc_ = TextEditingController();
  RxBool chckLastSegment = RxBool(false);

  DropDownValue? selectLocation;
  DropDownValue? selectChannel;
  Rxn<DropDownValue>? selectEvent = Rxn();
  DSeriesModel? dSeriesModel;

  PlutoGridStateManager? stateManager;
  FocusNode gridFocus = FocusNode();
  FocusNode locationFocus = FocusNode();
  FocusNode channelFocus = FocusNode();
  FocusNode eventFocus = FocusNode();
  @override
  void onInit() {
    getLocations();
    super.onInit();
  }

  getLocations() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.DSERIES_SPECIFICATION_LOAD,
        fun: (Map map) {
          print("Location dta>>>" + jsonEncode(map));
          locationList.clear();
          eventList.clear();
          map["pageload"]["location"].forEach((e) {
            locationList.add(DropDownValue.fromJsonDynamic(
                e, "locationCode", "locationName"));
          });
          map["pageload"]["eventmaster"].forEach((e) {
            eventList.add(
                DropDownValue.fromJsonDynamic(e, "eventtype", "eventname"));
          });
        });
  }

  getChannel(key) {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.DSERIES_SPECIFICATION_CHANNEL(key),
        fun: (Map map) {
          print("Location dta>>>" + jsonEncode(map));
          channelList.clear();
          map["channels"].forEach((e) {
            channelList.add(
                DropDownValue.fromJsonDynamic(e, "channelCode", "channelName"));
          });
        });
  }

  getChannelLeave() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.DSERIES_SPECIFICATION_CHANNEL_LEAVE(
            selectLocation?.key ?? "", selectChannel?.key ?? ""),
        fun: (map) {
          print("DSERIES_SPECIFICATION_CHANNEL_LEAVE>>>" + jsonEncode(map));
          if (map is Map &&
              map.containsKey("search") &&
              map["search"] != null) {
            dSeriesModel = DSeriesModel.fromJson(map as Map<String, dynamic>);
            update(["listUpdate"]);
          }
        });
  }

  void btnAdd_Click() async {
    List<PlutoRow>? dt = stateManager?.rows;
    for (int i = 0; i < (dt?.length ?? 0); i++) {
      PlutoRow drc = dt![i];
      if (drc.cells["eventType"]?.value == selectEvent?.value?.key &&
          drc.cells["isLastSegment"]?.value == chckLastSegment.value &&
          drc.cells["startPosition"]?.value == from_.text) {
        bool? isYes = await showDialogForYesNo(
            "This entry already exists!\nDo you want to modify it?");
        if (isYes == false) {
          return;
        } else {
          stateManager?.removeRows([drc]);
          break;
        }
      }
    }

    PlutoRow rowData = PlutoRow(cells: {
      "no": PlutoCell(value: 0),
      "eventType": PlutoCell(value: selectEvent?.value?.key),
      "isLastSegment": PlutoCell(value: chckLastSegment.value),
      "startPosition": PlutoCell(value: from_.text),
      "endPosition": PlutoCell(value: to_.text),
      "dataValue": PlutoCell(value: value_.text),
      "description": PlutoCell(value: desc_.text),
    });
    if (stateManager != null) {
      stateManager?.insertRows((stateManager?.rows.length)! - 1, [rowData]);
    } else {
      stateManager?.insertRows(0, [rowData]);
    }
    stateManager?.notifyListeners();
  }

  void btnRemove_Click() {
    if (stateManager != null) {
      stateManager?.removeCurrentRow();
    }
  }

  void save() {
    if (selectLocation == null) {
      LoadingDialog.callInfoMessage("Please select location");
    } else if (selectChannel == null) {
      LoadingDialog.callInfoMessage("Please select location");
    } else if (stateManager == null) {
      LoadingDialog.callInfoMessage("Table not available");
    } else {
      LoadingDialog.call();
      var postMap = {
        "locationCode": selectLocation?.key,
        "channelcode": selectChannel?.key,
        "dseriesSpecs": stateManager?.rows.map((e) => e.toJsonIntConvert(intConverterKeys: ["startPosition","endPosition"],boolList:["isLastSegment"])).toList()
      };
      Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.DSERIES_SPECIFICATION_SAVE,
          json: postMap,
          fun: (map) {
            Get.back();
            if (map is Map && map.containsKey("save") && map["save"].toString().contains("successfully")) {
              LoadingDialog.callDataSavedMessage("Data successfully");
            }else{
              LoadingDialog.callInfoMessage(map.toString());
            }
          });
    }
  }

  void onDoubleClick(PlutoGridOnSelectedEvent onClick) {
    from_.text =
        stateManager?.rows[onClick.rowIdx ?? 0].cells["startPosition"]?.value;
    to_.text =
        stateManager?.rows[onClick.rowIdx ?? 0].cells["endPosition"]?.value;
    value_.text =
        stateManager?.rows[onClick.rowIdx ?? 0].cells["dataValue"]?.value;
    desc_.text =
        stateManager?.rows[onClick.rowIdx ?? 0].cells["description"]?.value;
    chckLastSegment.value = (stateManager
            ?.rows[onClick.rowIdx ?? 0].cells["isLastSegment"]?.value ==
        "true");
    print("ROw Data index is>>>" + onClick.rowIdx.toString());
    DropDownValue? data;
    eventList.forEach((element) {
      if (element.key.toString().trim().toLowerCase() ==
          stateManager?.rows[onClick.rowIdx ?? 0].cells["eventType"]?.value
              .toString()
              .trim()
              .toLowerCase()) {
        data = element;
      }
    });
    print("Dataa>>>" + jsonEncode(data?.toJson()));
    // selectEvent?.value = DropDownValue(key: stateManager?.rows[onClick.rowIdx ?? 0].cells["eventType"]?.value, value: stateManager?.rows[onClick.rowIdx ?? 0].cells["eventType"]?.value);
    selectEvent?.value = data;
    update(["updateView"]);
  }

  Future<bool>? showDialogForYesNo(String text) {
    Completer<bool> completer = Completer<bool>();
    LoadingDialog.recordExists(
      text,
      () {
        completer.complete(true);
        // return true;
      },
      cancel: () {
        completer.complete(false);
        // return false;
      },
    );
    return completer.future;
  }
}

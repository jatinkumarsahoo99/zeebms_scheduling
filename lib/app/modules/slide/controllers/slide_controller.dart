import 'package:bms_scheduling/app/controller/MainController.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/src/manager/pluto_grid_state_manager.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/src/pluto_grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/LoadingDialog.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../providers/ApiFactory.dart';
import '../model/slide_model.dart';

class SlideController extends GetxController {
  var locationList = <DropDownValue>[].obs, channelList = <DropDownValue>[].obs;
  DropDownValue? selectedLocation, selectedChannel;
  var telecastedateTC = TextEditingController(), importDateTc = TextEditingController();
  var locationFN = FocusNode();
  var dataTableList = <SlideModel>[].obs;
  int lastSelectedIdx = 0;
  PlutoGridStateManager? stateManager;
  @override
  void onReady() {
    super.onReady();
    getLocation();
  }

  clearPage() {
    telecastedateTC.clear();
    importDateTc.clear();
    selectedLocation = null;
    selectedChannel = null;
    dataTableList.clear();
    locationList.refresh();
    channelList.refresh();
    locationFN.requestFocus();
  }

  void getChannel(DropDownValue? val) {
    selectedLocation = val;
    if (val != null) {
      LoadingDialog.call();
      Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.SLIDE_GET_CHANNELS(val.key ?? ""),
        fun: (resp) {
          if (resp != null && resp is Map<String, dynamic> && resp['listchannel'] != null) {
            closeDialog();
            selectedChannel = null;
            channelList.clear();
            channelList.addAll((resp['listchannel'] as List<dynamic>)
                .map((e) => DropDownValue(
                      key: e['channelCode'],
                      value: e['channelName'],
                    ))
                .toList());
          } else {
            LoadingDialog.showErrorDialog(resp.toString());
          }
        },
        failed: (resp) {
          closeDialog();
          LoadingDialog.showErrorDialog(resp.toString());
        },
      );
    }
  }

  void getLocation() {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.SLIDE_GET_LOCATION,
        fun: (resp) {
          closeDialog();
          if (resp != null && resp is Map<String, dynamic> && resp['pageload'] != null && resp['pageload']['lstLocaction'] != null) {
            locationList.clear();
            locationList.addAll((resp['pageload']['lstLocaction'] as List<dynamic>)
                .map((e) => DropDownValue(
                      key: e['locationCode'].toString(),
                      value: e['locationName'].toString(),
                    ))
                .toList());
          }
        },
        failed: (resp) {
          closeDialog();
          LoadingDialog.showErrorDialog(resp.toString());
        });
  }

  onleaveTelecasteDate() {
    if (selectedLocation == null || selectedChannel == null) {
      return;
    }
    LoadingDialog.call();
    Get.find<ConnectorControl>().POSTMETHOD(
      api: ApiFactory.SLIDE_GET_DATA,
      fun: (resp) {
        closeDialog();
        if (resp != null && resp is Map<String, dynamic> && resp['lstFPC'] != null) {
          dataTableList.clear();
          lastSelectedIdx = 0;
          dataTableList.value.addAll((resp['lstFPC'] as List<dynamic>).map((e) => SlideModel.fromJson(e)).toList());
        } else {
          LoadingDialog.showErrorDialog(resp.toString());
        }
      },
      json: {
        "locationCode": selectedLocation?.key,
        "channelCode": selectedChannel?.key,
        "telecastDate": DateFormat("yyyy-MM-ddT00:00:00").format(DateFormat("dd-MM-yyyy").parse(telecastedateTC.text)),
        "import": false,
        "importdate": DateFormat("yyyy-MM-ddT00:00:00").format(DateFormat("dd-MM-yyyy").parse(importDateTc.text)),
      },
    );
  }

  save() {
    if (selectedLocation == null || selectedChannel == null) {
      LoadingDialog.showErrorDialog("Please select Location,Channel.");
      return;
    }
    LoadingDialog.call();
    Get.find<ConnectorControl>().POSTMETHOD(
      api: ApiFactory.SLIDE_SAVE,
      fun: (resp) {
        closeDialog();
        if (resp != null && resp is Map<String, dynamic> && resp['postsave'] != null && resp['postsave'].toString().contains("Records are updated")) {
          LoadingDialog.callDataSaved(
              msg: resp['postsave'].toString(),
              callback: () {
                clearPage();
              });
        } else {
          LoadingDialog.showErrorDialog(resp.toString());
        }
      },
      json: {
        "locationCode": selectedLocation?.key,
        "channelCode": selectedChannel?.key,
        "telecastDate": DateFormat("yyyy-MM-ddT00:00:00").format(DateFormat("dd-MM-yyyy").parse(telecastedateTC.text)),
        "modifiedBy": Get.find<MainController>().user?.logincode,
        "saveSlides": dataTableList.map((element) => element.toJson(fromSave: true)).toList(),
      },
    );
  }

  void closeDialog() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  formHandler(btn) {
    if (btn == "Clear") {
      clearPage();
    } else if (btn == "Save") {
      save();
    }
  }

  actionOnPress(PlutoGridCellPosition position, bool isSpaceCalled) {
    if (isSpaceCalled) {
      lastSelectedIdx = position.rowIdx ?? 0;
      if (stateManager != null) {
        stateManager?.changeCellValue(
          stateManager!.currentCell!,
          stateManager!.currentCell!.value == "true" ? "false" : "true",
          force: true,
          callOnChangedEvent: true,
          notify: true,
        );
      }
    }
  }

  onEdit(PlutoGridOnChangedEvent event) {
    lastSelectedIdx = event.rowIdx;
    if (event.columnIdx == 3) {
      dataTableList.value[event.rowIdx].stationIdCheck = (event.value.toString() == "true");
    } else if (event.columnIdx == 4) {
      dataTableList.value[event.rowIdx].presentsCheck = (event.value.toString() == "true");
    } else if (event.columnIdx == 5) {
      dataTableList.value[event.rowIdx].presentationCheck = (event.value.toString() == "true");
    } else if (event.columnIdx == 6) {
      dataTableList.value[event.rowIdx].commProgCheck = (event.value.toString() == "true");
    } else if (event.columnIdx == 7) {
      dataTableList.value[event.rowIdx].commMenuCheck = (event.value.toString() == "true");
    } else if (event.columnIdx == 8) {
      dataTableList.value[event.rowIdx].commUpTom = (event.value.toString() == "true");
    } else if (event.columnIdx == 9) {
      dataTableList.value[event.rowIdx].networkId = (event.value.toString() == "true");
    } else if (event.columnIdx == 10) {
      dataTableList.value[event.rowIdx].marrideId = (event.value.toString() == "true");
    }
  }
}

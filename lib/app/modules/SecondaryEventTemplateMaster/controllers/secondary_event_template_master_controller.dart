import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/controller/MainController.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/data/PermissionModel.dart';
import 'package:bms_scheduling/app/modules/SecondaryEventTemplateMaster/bindings/secondary_event_template_master_programs.dart';
import 'package:bms_scheduling/app/modules/SecondaryEventTemplateMaster/bindings/secondary_event_template_program_grid.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/app/providers/Utils.dart';
import 'package:bms_scheduling/app/routes/app_pages.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SecondaryEventTemplateMasterController extends GetxController {
  RxList<DropDownValue> locations = RxList<DropDownValue>();
  RxList<DropDownValue> channels = RxList<DropDownValue>();
  RxList<DropDownValue> events = RxList<DropDownValue>();

  DropDownValue? selectedLocation, selectedChannel;
  var selectedProgram = Rxn<DropDownValue>();
  DropDownValue? selectedEvent;
  RxBool mine = RxBool(false);
  FocusNode txIdFocusNode = FocusNode();
  RxBool enableFields = RxBool(true);
  List<SecondaryEventTemplateMasterProgram> gridPrograms = [];
  SecondaryEventTemplateMasterProgram? copiedProgram;

  List<SecondaryEventTemplateProgramGridData> searchPrograms = [];
  TextEditingController txCaption = TextEditingController(), txID = TextEditingController();
  PlutoGridStateManager? programGrid;
  PlutoGridStateManager? searchGrid;
  List<PermissionModel>? formPermissions;

  @override
  void onInit() {
    formPermissions = Utils.fetchPermissions1(Routes.SECONDARY_EVENT_TEMPLATE_MASTER.replaceAll("/", ""));
    getInitData();

    txIdFocusNode.addListener(() {
      if (!txIdFocusNode.hasFocus) {
        if (txID.text.isEmpty) {
          LoadingDialog.modify("Do you want to search all events?", () {
            postFastSearch();
          }, () {}, deleteTitle: "YES", cancelTitle: "NO");
        } else {
          postFastSearch();
        }
      }
    });
    

    super.onInit();
  }

  calculateRowNo() {
    for (var i = 0; i < gridPrograms.length; i++) {
      gridPrograms[i].rowNumber = i;
    }
  }

  var checkBoxes = RxMap({"First Segment": false, "Last Segment": false, "All Segments": false, "Pre Event": false, "Post Event": false});

  getInitData() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.SecondaryEventTemplateMasterInitData,
        fun: (data) {
          if (data is Map && data.containsKey("pageload")) {
            for (var e in data["pageload"]["lstlocation"]) {
              locations.add(DropDownValue(key: e["locationCode"], value: e["locationName"]));
            }
            for (var e in data["pageload"]["lstEventType"]) {
              events.add(DropDownValue(key: e, value: e));
            }
          }
        });
  }

  getChannel(locCode) {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.SecondaryEventTemplateMasterGetChannel(locCode),
        fun: (data) {
          if (data is Map && data.containsKey("channel")) {
            for (var e in data["channel"]) {
              channels.add(DropDownValue(key: e["channelCode"], value: e["channelName"]));
            }
          }
        });
  }

  getProgramPick() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.SecondaryEventTemplateMasterGetProgramPicker(selectedLocation?.key, selectedChannel?.key),
        fun: (data) {
          if (data is Map && data.containsKey("getprogram")) {
            Get.defaultDialog(
              title: "Pick Program",
              content: Container(
                  height: Get.height / 2,
                  width: Get.width / 2,
                  child: DataGridShowOnlyKeys(
                    mapData: data["getprogram"],
                    hideCode: false,
                    onRowDoubleTap: (rowTap) {
                      selectedProgram.value = DropDownValue(
                          value: data["getprogram"][rowTap.rowIdx]["programName"], key: data["getprogram"][rowTap.rowIdx]["programCode"]);
                    },
                  )),
            );
          }
        });
  }

  getProgramLeave() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.SecondaryEventTemplateMasterGetProgramLeave(selectedLocation?.key, selectedChannel?.key, selectedProgram.value?.key),
        fun: (data) {
          if (data is Map && data.containsKey("getprogram")) {
            for (var program in data["getprogram"]) {
              gridPrograms.add(SecondaryEventTemplateMasterProgram.fromJson(program));
            }
            update(["gridData"]);
          }
        });
  }

  postFastSearch() {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.SecondaryEventTemplateMasterFastProgSearch,
        json: {
          "locationcode": selectedLocation?.key,
          "channelcode": selectedChannel?.key,
          "mine": mine.value,
          "eventType": selectedEvent?.key,
          "txID": txID.text,
          "caption": txCaption.text
        },
        fun: (data) {
          if (data is Map && data.containsKey("insertSearch")) {
            for (var element in data["insertSearch"]) {
              searchPrograms.add(SecondaryEventTemplateProgramGridData.fromJson(element));
            }
            update(["searchGrid"]);
          }
        });
  }

  save() {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.SecondaryEventTemplateMasterSave,
        json: {
          "locationcode": selectedLocation?.key,
          "channelcode": selectedChannel?.key,
          "programCode": selectedProgram.value?.key,
          "loggedUser": Get.find<MainController>().user?.logincode ?? "",
          "templateMaster": gridPrograms.map((e) => e.toJson()).toList()
        },
        fun: (data) {
          if (data is Map && data.containsKey("save")) {
            LoadingDialog.callDataSaved(msg: data["save"]);
          } else if (data is String) {
            LoadingDialog.callErrorMessage1(msg: data);
          }
        });
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

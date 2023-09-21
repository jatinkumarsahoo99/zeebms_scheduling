import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/controller/MainController.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/data/PermissionModel.dart';
import 'package:bms_scheduling/app/modules/SecondaryEventTemplateMaster/bindings/secondary_event_template_master_color.dart';
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

import '../../../controller/HomeController.dart';
import '../../../data/user_data_settings_model.dart';

class SecondaryEventTemplateMasterController extends GetxController {
  RxList<DropDownValue> locations = RxList<DropDownValue>();
  RxList<DropDownValue> channels = RxList<DropDownValue>();
  RxList<DropDownValue> events = RxList<DropDownValue>();
  List<SecondaryTemplateEventColors> colors = [];
  var durationCtr = TextEditingController(text: '00:00:00:00');
  var controllsEnable = true.obs;
  var programFN = FocusNode();

  DropDownValue? selectedLocation, selectedChannel;
  var selectedProgram = Rxn<DropDownValue>();
  DropDownValue? selectedEvent;
  RxBool mine = RxBool(false);
  FocusNode txIdFocusNode = FocusNode(),
      locFocusNode = FocusNode(),
      programFocusNode = FocusNode();
  RxBool enableFields = RxBool(true);

  List<SecondaryEventTemplateMasterProgram> gridPrograms = [];
  SecondaryEventTemplateMasterProgram? copiedProgram;

  List<SecondaryEventTemplateProgramGridData> searchPrograms = [];
  TextEditingController txCaption = TextEditingController(),
      txID = TextEditingController();
  PlutoGridStateManager? programGrid;
  PlutoGridStateManager? searchGrid;
  List<PermissionModel>? formPermissions;
  UserDataSettings? userDataSettings;

  @override
  void onInit() {
    formPermissions = Utils.fetchPermissions1(
        Routes.SECONDARY_EVENT_TEMPLATE_MASTER.replaceAll("/", ""));
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

  @override
  void onReady() {
    super.onReady();
    fetchUserSetting1();
  }

  fetchUserSetting1() async {
    userDataSettings = await Get.find<HomeController>().fetchUserSetting2();
    update(['gridData', 'searchGrid']);
  }

  calculateRowNo() {
    for (var i = 0; i < gridPrograms.length; i++) {
      gridPrograms[i].rowNumber = i;
    }
  }

  var checkBoxes = RxMap({
    "First Segment": false,
    "Last Segment": false,
    "All Segments": false,
    "Pre Event": false,
    "Post Event": false
  });

  getInitData() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.SecondaryEventTemplateMasterInitData,
        fun: (data) {
          if (data is Map && data.containsKey("pageload")) {
            locations.value = [];
            for (var e in data["pageload"]["lstlocation"]) {
              locations.add(DropDownValue(
                  key: e["locationCode"], value: e["locationName"]));
            }
            events.value = [];
            for (var e in data["pageload"]["lstEventType"]) {
              events.add(DropDownValue(key: e, value: e));
            }
            colors = [];
            for (var e in data["pageload"]["lstLoadColours"]) {
              colors.add(SecondaryTemplateEventColors.fromJson(e));
            }
          }
        });
  }

  getChannel(locCode) {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.SecondaryEventTemplateMasterGetChannel(locCode),
        fun: (data) {
          Get.back();
          if (data is Map && data.containsKey("channel")) {
            for (var e in data["channel"]) {
              channels.add(DropDownValue(
                  key: e["channelCode"], value: e["channelName"]));
            }
          }
        });
  }

  getProgramPick() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.SecondaryEventTemplateMasterGetProgramPicker(
            selectedLocation?.key, selectedChannel?.key),
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
                          value: data["getprogram"][rowTap.rowIdx]
                              ["programName"],
                          key: data["getprogram"][rowTap.rowIdx]
                              ["programCode"]);
                    },
                  )),
            );
          }
        });
  }

  getProgramLeave() {
    if (selectedLocation == null || selectedChannel == null) {
      LoadingDialog.callErrorMessage1(msg: "Please Select Location & Channel.");
    } else {
      LoadingDialog.call();

      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.SecondaryEventTemplateMasterGetProgramLeave(
              selectedLocation?.key,
              selectedChannel?.key,
              selectedProgram.value?.key),
          fun: (data) {
            Get.back();
            if (data is Map && data.containsKey("getprogram")) {
              gridPrograms = [];
              for (var program in data["getprogram"]) {
                gridPrograms
                    .add(SecondaryEventTemplateMasterProgram.fromJson(program));
              }
              programFocusNode.nextFocus();
              Future.delayed(Duration(milliseconds: 100)).then((value) {
                programFocusNode.requestFocus();
              });
              enableFields.value = false;
              update(["gridData"]);
            }
          });
    }
  }

  postFastSearch() {
    LoadingDialog.call();
    try {
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
            Get.back();
            if (data is Map && data.containsKey("insertSearch")) {
              searchPrograms = [];
              for (var element in data["insertSearch"]) {
                searchPrograms.add(
                    SecondaryEventTemplateProgramGridData.fromJson(element));
              }
              update(["searchGrid"]);
            }
          });
    } catch (e) {
      Get.back();
      printError(info: "Failed to search");
    }
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
}

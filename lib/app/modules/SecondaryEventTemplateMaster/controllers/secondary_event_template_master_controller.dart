import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SecondaryEventTemplateMasterController extends GetxController {
  RxList<DropDownValue> locations = RxList<DropDownValue>();
  RxList<DropDownValue> channels = RxList<DropDownValue>();

  DropDownValue? selectedLocation, selectedChannel;
  var selectedProgram = Rxn<DropDownValue>();
  final count = 0.obs;
  @override
  void onInit() {
    getInitData();
    super.onInit();
  }

  getInitData() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.SecondaryEventTemplateMasterInitData,
        fun: (data) {
          if (data is Map && data.containsKey("pageload")) {
            for (var e in data["pageload"]["lstlocation"]) {
              locations.add(DropDownValue(key: e["locationCode"], value: e["locationName"]));
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

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}

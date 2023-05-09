import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/ConnectorControl.dart';
import '../../../data/DropDownValue.dart';

class RoCancellationController extends GetxController {
  //TODO: Implement RoCancellationController
  RxList<DropDownValue> locations = <DropDownValue>[].obs;
  RxList<DropDownValue> channels = <DropDownValue>[].obs;
  TextEditingController scheduleDate = TextEditingController();
  DropDownValue? selectedLocation;
  DropDownValue? selectedChannel;
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  getLocation() {
    try {
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.IMPORT_DIGITEX_RUN_ORDER_LOCATION,
          fun: (data) {
            if (data is List) {
              locations.value = data
                  .map((e) => DropDownValue(
                      key: e["locationCode"], value: e["locationName"]))
                  .toList();
            } else {
              LoadingDialog.callErrorMessage1(
                  msg: "Failed To Load Initial Data");
            }
          });
    } catch (e) {
      LoadingDialog.callErrorMessage1(msg: "Failed To Load Initial Data");
    }
  }

  getChannel(locationCode) {
    try {
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.IMPORT_DIGITEX_RUN_ORDER_CHANNEL(locationCode),
          fun: (data) {
            if (data is List) {
              channels.value = data
                  .map((e) => DropDownValue(
                      key: e["channelCode"], value: e["channelName"]))
                  .toList();
            } else {
              LoadingDialog.callErrorMessage1(
                  msg: "Failed To Load Initial Data");
            }
          });
    } catch (e) {
      LoadingDialog.callErrorMessage1(msg: "Failed To Load Initial Data");
    }
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

import 'dart:math';

import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MaterialIdSearchController extends GetxController {
  //TODO: Implement MaterialIdSearchController
  TextEditingController tapeIdCode = TextEditingController(), programName = TextEditingController(), epsCaption = TextEditingController();
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  List<Map> data = [];

  getData() {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.SearchTapeCode,
        json: {"exportTapeCode": tapeIdCode.text, "programName": programName.text, "epsCaption": epsCaption.text},
        fun: (data) {
          if (data is Map && (data.containsKey("SearchTapeCode") || data.containsKey("searchTapeCode"))) {
            data = data["SearchTapeCode"] ?? data["searchTapeCode"];
            update(["gridData"]);
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

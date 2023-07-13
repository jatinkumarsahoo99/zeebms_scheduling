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

  var data = RxList<Map>([]);

  getData() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.SearchTapeCode(tapeIdCode.text, programName.text, epsCaption.text),
        fun: (map) {
          if (map is Map && (map.containsKey("searchTapeCode"))) {
            for (var element in map["searchTapeCode"]) {
              data.add(element);
            }
            data.refresh();
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

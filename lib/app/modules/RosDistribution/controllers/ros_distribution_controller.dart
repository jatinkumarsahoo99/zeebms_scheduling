// ignore_for_file: unused_import

import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:get/get.dart';

class RosDistributionController extends GetxController {
  //TODO: Implement RosDistributionController

  List topButtons = [
    {"name": "Show", "callback": () {}},
    {"name": "Empty", "callback": () {}},
    {"name": "Report", "callback": () {}},
    {"name": "Allocate", "callback": () {}},
    {"name": "Un", "callback": () {}},
    {"name": "Service", "callback": () {}},
    {"name": "De Alloc", "callback": () {}},
    {"name": "FPC", "callback": () {}},
  ];

  var checkBoxes = RxList([
    {"name": "Show Open Deals", "value": false},
    {"name": "Show ROS Spots", "value": false},
    {"name": "Show Spot Buys", "value": false}
  ]);
  @override
  void onInit() {
    super.onInit();
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

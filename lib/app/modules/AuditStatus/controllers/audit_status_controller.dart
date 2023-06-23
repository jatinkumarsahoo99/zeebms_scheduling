import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/controller/MainController.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/app/providers/extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/DropDownValue.dart';

class AuditStatusController extends GetxController {
  //TODO: Implement AuditStatusController
  var locations = RxList<DropDownValue>([]);
  var channels = RxList<DropDownValue>([]);
  RxBool isEnable = RxBool(true);
  TextEditingController dateController = TextEditingController();
  List<String> auditTypes = ["Addition", "Cancellation", "Reschedule"];
  String currentType = "Addition";

  //input controllers
  DropDownValue? selectLocation;
  DropDownValue? selectChannel;

  getLocations() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.NewBookingActivityReport_GetLoadLocation,
        fun: (Map map) {
          locations.clear();
          map["location"].forEach((e) {
            locations.add(DropDownValue.fromJson1(e));
          });
        });
  }

  getChannels(locationCode) {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.NewBookingActivityReport_cbolocationLeave(locationCode),
        fun: (Map map) {
          channels.clear();
          map["onLeaveLocation"].forEach((e) {
            channels.add(DropDownValue(key: e["channelCode"], value: e["channelName"]));
          });
        });
  }

  showBtnData() {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.NewBookingActivityReport_BtnShow,
        json: {
          "locationCode": selectLocation?.key,
          "channelCode": selectChannel?.key,
          "date": dateController.text.fromdMyToyMd(),
          "loggedUser": Get.find<MainController>().user?.logincode,
          "type": currentType
        },
        fun: (Map map) {});
  }

  @override
  void onInit() {
    getLocations();
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

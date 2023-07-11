import 'dart:convert';

import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/ConnectorControl.dart';
import '../../../providers/ApiFactory.dart';

class DSeriesSpecificationController extends GetxController {
  final count = 0.obs;
  double widthSize = 0.12;
  RxList<DropDownValue> locationList = RxList([]);
  RxList<DropDownValue> channelList = RxList([]);
  TextEditingController from_ = TextEditingController();
  TextEditingController to_ = TextEditingController();
  TextEditingController value_ = TextEditingController();
  TextEditingController desc_ = TextEditingController();
  RxBool chckLastSegment = RxBool(false);

  DropDownValue? selectLocation;
  DropDownValue? selectChannel;
  DropDownValue? selectEvent;

  @override
  void onInit() {
    getLocations();
    super.onInit();
  }

  getLocations() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.TRANSMISSION_LOG_LOCATION(),
        fun: (Map map) {
          print("Location dta>>>"+jsonEncode(map));
          locationList.clear();
          map["location"].forEach((e) {
            locationList.add(DropDownValue.fromJson1(e));
          });
        });
  }

  getChannel(key) {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.DSERIES_SPECIFICATION_CHANNEL(key),
        fun: (Map map) {
          print("Location dta>>>"+jsonEncode(map));
          channelList.clear();
          map["location"].forEach((e) {
            channelList.add(DropDownValue.fromJson1(e));
          });
        });
  }

  getChannelLeave() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.DSERIES_SPECIFICATION_CHANNEL_LEAVE(selectLocation?.key??"",selectChannel?.key??""),
        fun: (Map map) {
          print("Location dta>>>"+jsonEncode(map));
          channelList.clear();
          map["location"].forEach((e) {
            channelList.add(DropDownValue.fromJson1(e));
          });
        });
  }
}

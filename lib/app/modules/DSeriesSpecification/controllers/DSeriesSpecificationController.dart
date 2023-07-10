import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DSeriesSpecificationController extends GetxController {

  final count = 0.obs;
  double widthSize = 0.12;
  RxList<DropDownValue> locationList=RxList([]);
  RxList<DropDownValue> channelList=RxList([]);
  TextEditingController from_=TextEditingController();
  TextEditingController to_=TextEditingController();
  TextEditingController value_=TextEditingController();
  TextEditingController desc_=TextEditingController();
RxBool chckLastSegment=RxBool(false);
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}

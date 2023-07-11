import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../data/DropDownValue.dart';


class EuropeDropSpotsController extends GetxController {
  //TODO: Implement EuropeDropSpotsController

  TextEditingController selectedDate=TextEditingController();
  TextEditingController selectedFrmDate=TextEditingController();
  TextEditingController selectedToDate=TextEditingController();
  TextEditingController toNumber=TextEditingController();
  RxInt segmentedControlGroupValue = RxInt(0);

  final Map<int, Widget> myTabs = const <int, Widget>{
    0: Text("Dropped Spots"),
    1: Text("Remove Running Order"),
    2: Text("Delete Russia Commercial"),
  };
  double widthSize = 0.12;
  double widthSize1 = 0.17;
  RxList<DropDownValue> locationList=RxList([]);
  RxList<DropDownValue> channelList=RxList([]);


  @override
  void onInit() {
    super.onInit();
  }


}

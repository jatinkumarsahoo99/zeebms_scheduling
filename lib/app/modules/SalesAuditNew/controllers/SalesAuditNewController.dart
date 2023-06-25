import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../controller/ConnectorControl.dart';
import '../../../providers/ApiFactory.dart';

class SalesAuditNewController extends GetxController {
  //TODO: Implement SalesAuditNewController
  RxBool isEnable = RxBool(true);
  var isStandby = RxBool(false);
  final count = 0.obs;
  RxList<DropDownValue> list=RxList([]);

  RxList<DropDownValue> locationList = RxList([]);
  RxList<DropDownValue> channelList = RxList([]);
  TextEditingController scheduledController = TextEditingController();

  RxBool showError = RxBool(true);
  RxBool showCancel = RxBool(true);
  DropDownValue? selectedLocation;

  fetchPageLoadData(){
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.SALESAUDIT_NEW_LOAD,
        fun: (Map map) {
           if(map is Map && map.containsKey("listlocations") && map['listlocations'].length > 0){
             map['listlocations'].forEach((e){
               locationList.add(DropDownValue.fromJsonDynamic(e, "locationCode", "locationName"));
             });
           }
        });
  }

  @override
  void onInit() {
    fetchPageLoadData();
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

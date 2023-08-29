import 'dart:convert';

import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/PlutoGrid/src/manager/pluto_grid_state_manager.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/Utils.dart';

class EuropeCommercialImportStatusController extends GetxController {


  TextEditingController selectedDate=TextEditingController();
  List<dynamic>? listData;
  PlutoGridStateManager? stateManager;
  List<Map<String, double>>? userGridSetting1 = [];
  @override
  void onInit() {
    fetchUserSetting1();
    super.onInit();
  }

  getGenerate(){
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.EUROPE_COMMERCIAL_GENERATE(Utils.dateFormatChange(selectedDate.text, "dd-MM-yyyy", "dd-MMM-yyyy")),
        fun: (map) {
          print("Location dta>>>" + jsonEncode(map));
          Get.back();
          if(map is Map && map.containsKey("genrate") && map["genrate"]!=null && map["genrate"].length>0){
            listData=map["genrate"];
            print("Data length is>>>"+(listData?.length.toString()??""));
            update(["listUpdate"]);
          }
        });
  }

  postUserSetting() {
    if (stateManager == null) return;
    Map<String, dynamic> singleMap = {};
    for (var element in stateManager?.columns ?? []) {
      singleMap[element.field] = element.width;
    }
    String? mapData = jsonEncode(singleMap);
    // Map<String, dynamic>? mapDataResult = jsonDecode(mapData);

    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.USER_SETTINGS,
        json: {
          "lstUserSettings": [
            {
              "formName": Get.find<MainController>().formName ?? "",
              "controlName": "1ST Table",
              "userSettings": mapData
            }
          ]
        },
        fun: (map) {});
  }
  fetchUserSetting1() async {
    userGridSetting1 = await Get.find<HomeController>().fetchUserSetting();
    userGridSetting1?.forEach((e){
      print("Data in UI>>>"+e.toString());
    });
    update(["listUpdate"]);
  }

}

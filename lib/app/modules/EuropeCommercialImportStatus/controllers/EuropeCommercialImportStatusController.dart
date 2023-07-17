import 'dart:convert';

import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/ConnectorControl.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/Utils.dart';

class EuropeCommercialImportStatusController extends GetxController {


  TextEditingController selectedDate=TextEditingController();
  List<dynamic>? listData;

  @override
  void onInit() {
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


}

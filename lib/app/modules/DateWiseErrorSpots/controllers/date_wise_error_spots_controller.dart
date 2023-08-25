import 'dart:convert';

import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/LoadingDialog.dart';
import '../../../../widgets/PlutoGrid/src/manager/pluto_grid_state_manager.dart';
import '../../../../widgets/Snack.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../providers/ApiFactory.dart';
import '../DatewiseErrorSpotsModel.dart';



class DateWiseErrorSpotsController extends GetxController {
  //TODO: Implement DateWiseErrorSpotsController

  final count = 0.obs;
  bool isEnable = true;

  var clientDetails = RxList<DropDownValue>();
  DropDownValue? selectedClientDetails;
  var controllsEnabled = true.obs;
  var selectedRadio = "".obs;
  FocusNode gridFocus = FocusNode();

  FocusNode locationFocus = FocusNode();
  FocusNode channelFocus = FocusNode();

  RxList<DropDownValue> locationList = RxList([]);
  RxList<DropDownValue> channelList = RxList([]);


  DropDownValue? selectedLocation;
  DropDownValue? selectedChannel;
  PlutoGridStateManager? gridStateManager;

  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController =  TextEditingController();
  DatewiseErrorSpotsModel? datewiseErrorSpotsModel;
  closeDialogIfOpen() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }
  fetchPageLoadData() {
   LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.DATEWISEERROR_LOAD,
        fun: ( map) {
          closeDialogIfOpen();
          if(map is Map && map.containsKey('dateWiseLoadInfo') &&  map['dateWiseLoadInfo'] != null){
            if (map['dateWiseLoadInfo'].containsKey("location") && map['dateWiseLoadInfo']['location'] != null &&
                map['dateWiseLoadInfo']['location'].length > 0) {
              locationList.clear();
              map['dateWiseLoadInfo']['location'].forEach((e) {
                locationList.add(DropDownValue.fromJsonDynamic(
                    e, "locationCode", "locationName"));
              });
            }
            if (map['dateWiseLoadInfo'].containsKey("channel") && map['dateWiseLoadInfo']['channel'] != null &&
                map['dateWiseLoadInfo']['channel'].length > 0) {
              channelList.clear();
              map['dateWiseLoadInfo']['channel'].forEach((e) {
                channelList.add(DropDownValue.fromJsonDynamic(
                    e, "channelcode", "channelname"));
              });
            }

          }

        });
  }

  callGetRetrieve() {
    if (selectedLocation == null) {
      Snack.callError("Please select location");
    } else if (selectedChannel == null) {
      Snack.callError("Please select channel");
    } else if (fromDateController.text == null ||
        fromDateController.text == "") {
      Snack.callError("Please select from date");
    } else if (toDateController.text == null ||
        toDateController.text == "") {
      Snack.callError("Please select to date");
    } else {
      LoadingDialog.call();
      // print(">>>>date"+dateController.text);
      DateTime formatdate1 = DateFormat("dd-MM-yyyy").parse(fromDateController.text);
      String date1 = DateFormat("yyyy-MM-ddTHH:mm:ss").format (formatdate1).toString();

      DateTime formatdate2 = DateFormat("dd-MM-yyyy").parse(toDateController.text);
      String date2 = DateFormat("yyyy-MM-ddTHH:mm:ss").format (formatdate2).toString();

      print(">>>>$date1");

      // ((Get.find<MainController>().user != null) ? Aes.encrypt(Get.find<MainController>().user?.personnelNo ?? "") : "")
      Map<String,dynamic> postData = {
        "locationcode": selectedLocation?.key??"",
        "channelcode": selectedChannel?.key??"",
        "fromdate": date1,
        "todate": date2,
        "logincode": Get.find<MainController>().user?.logincode ?? ""
      } ;
      print(">>>>>>>>"+postData.toString());
      // LoadingDialog.call();
      Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.DATEWISEERROR_GENERATE,
          json: postData,
          fun: (map) {
            Get.back();
            print("response"+jsonEncode(map) .toString());
            if(map is Map && map.containsKey("datewiseErrorSpots") &&
                map['datewiseErrorSpots'] != null && map['datewiseErrorSpots'].length >0 ){
              datewiseErrorSpotsModel = DatewiseErrorSpotsModel.fromJson(map as Map<String,dynamic>);
              update(['grid']);
            }else{
              datewiseErrorSpotsModel = null;
              update(['grid']);
            }
          });
    }
  }
  clearAll() {
    Get.delete<DateWiseErrorSpotsController>();
    Get.find<HomeController>().clearPage1();
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    fetchPageLoadData();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
  formHandler(String string) {
    if(string == "Clear"){
      clearAll();
    }
  }
  void increment() => count.value++;
}

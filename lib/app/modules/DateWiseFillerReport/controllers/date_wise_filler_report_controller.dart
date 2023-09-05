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
import '../../../data/user_data_settings_model.dart';
import '../../../providers/ApiFactory.dart';
import '../DateWiseFillerModel.dart';

class DateWiseFillerReportController extends GetxController {
  //TODO: Implement DateWiseFillerReportController

  final count = 0.obs;
  bool isEnable = true;

  var clientDetails = RxList<DropDownValue>();
  DropDownValue? selectedClientDetails;
  var controllsEnabled = true.obs;
  var selectedRadio = "".obs;
  RxList<DropDownValue> locationList = RxList([]);
  RxList<DropDownValue> channelList = RxList([]);
  FocusNode gridFocus = FocusNode();

  FocusNode locationFocus = FocusNode();
  FocusNode channelFocus = FocusNode();

  DropDownValue? selectedLocation;
  DropDownValue? selectedChannel;
  PlutoGridStateManager? gridStateManager;

  TextEditingController dateController = new TextEditingController();
  DateWiseFillerModel? dateWiseFillerModel;
  UserDataSettings? userDataSettings;
  PlutoGridStateManager? dateWiseReportGSM;
  @override
  void onInit() {
    super.onInit();
    fetchUserSetting1();
  }

  fetchUserSetting1() async {
    userDataSettings = await Get.find<HomeController>().fetchUserSetting2();
    update(['grid']);
  }

  closeDialogIfOpen() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  fetchPageLoadData() {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.DATEWISEFILLER_LOAD,
        fun: (map) {
          closeDialogIfOpen();
          if (map is Map) {
            if (map.containsKey("location") &&
                map['location'] != null &&
                map['location'].length > 0) {
              locationList.clear();
              map['location'].forEach((e) {
                locationList.add(DropDownValue.fromJsonDynamic(
                    e, "locationCode", "locationName"));
              });
            }
            if (map.containsKey("channel") &&
                map['channel'] != null &&
                map['channel'].length > 0) {
              channelList.clear();
              map['channel'].forEach((e) {
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
    } else if (dateController.text == null || dateController.text == "") {
      Snack.callError("Please select date");
    } else {
      LoadingDialog.call();
      print(">>>>date" + dateController.text);
      DateTime formatdate = DateFormat("dd-MM-yyyy").parse(dateController.text);
      String date =
          DateFormat("yyyy-MM-ddTHH:mm:ss").format(formatdate).toString();

      print(">>>>$date");

      // ((Get.find<MainController>().user != null) ? Aes.encrypt(Get.find<MainController>().user?.personnelNo ?? "") : "")
      Map<String, dynamic> postData = {
        "locationcode": selectedLocation?.key ?? "",
        "channelcode": selectedChannel?.key ?? "",
        "teldate": date ?? ""
      };
      print(">>>>>>>>" + postData.toString());
      // LoadingDialog.call();
      Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.DATEWISEFILLER_GENERATE,
          json: postData,
          fun: (map) {
            Get.back();
            print("response" + jsonEncode(map).toString());
            if (map is Map &&
                map.containsKey("datewiseErrorSpots") &&
                map['datewiseErrorSpots'] != null &&
                map['datewiseErrorSpots'].length > 0) {
              dateWiseFillerModel =
                  DateWiseFillerModel.fromJson(map as Map<String, dynamic>);
              update(['grid']);
            } else {
              dateWiseFillerModel = null;
              update(['grid']);
            }
          });
    }
  }

  clearAll() {
    Get.delete<DateWiseFillerReportController>();
    Get.find<HomeController>().clearPage1();
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
    if (string == "Clear") {
      clearAll();
    } else if (string == "Exit") {
      Get.find<HomeController>().postUserGridSetting2(listStateManager: [
        {"dateWiseReportGSM": dateWiseReportGSM}
      ]);
    }
  }

  void increment() => count.value++;
}

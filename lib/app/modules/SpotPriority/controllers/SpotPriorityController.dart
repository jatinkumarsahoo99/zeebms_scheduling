import 'dart:collection';

import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';
import '../../../../widgets/Snack.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../controller/HomeController.dart';
import '../../../data/DropDownValue.dart';
import '../../../data/user_data_settings_model.dart';
import '../../../providers/ApiFactory.dart';
import '../SpotPriorityModel.dart';

class SpotPriorityController extends GetxController {
  var locations = RxList<DropDownValue>();
  var channels = RxList<DropDownValue>([]);
  var priorityList = RxList<DropDownValue>([]);

  Set<String> uniqueList = {};

  // Map list = HashMap();
  RxBool isEnable = RxBool(true);

  //input controllers
  DropDownValue? selectLocation;
  DropDownValue? selectChannel1;
  Rxn<DropDownValue> selectChannel = Rxn<DropDownValue>();
  DropDownValue? selectPriority;
  PlutoGridStateManager? gridStateManager;

  TextEditingController frmDate = TextEditingController();
  TextEditingController toDate = TextEditingController();

  SpotPriorityModel? spotPriorityModel;
  PlutoGridMode selectedPlutoGridMode = PlutoGridMode.normal;

  @override
  void onInit() {
    getLocations();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    fetchUserSetting1();
  }

  UserDataSettings? userDataSettings;

  fetchUserSetting1() async {
    userDataSettings = await Get.find<HomeController>().fetchUserSetting2();
    update(['spotPriorityList']);
  }

  getLocations() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.SPOT_PRIORITY_LOCATION(),
        fun: (Map map) {
          locations.clear();
          priorityList.clear();
          map["setSpotPriority"]["location"].forEach((e) {
            locations.add(DropDownValue.fromJson1(e));
          });
          map["setSpotPriority"]["priority"].forEach((e) {
            priorityList.add(DropDownValue.fromJsonDynamic(
                e, "priorityCode", "priorityName"));
          });
        });
  }

  getChannels(String key) {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.SPOT_PRIORITY_CHANNEL() + key,
        fun: (Map map) {
          channels.clear();
          map["lstchannels"].forEach((e) {
            channels.add(
                DropDownValue.fromJsonDynamic(e, "channelCode", "channelName"));
          });
        });
  }

  getShowDetails() {
    if (selectLocation == null) {
      Snack.callError("Please select location");
    } else if (selectChannel == null) {
      Snack.callError("Please select channel");
    } else {
      LoadingDialog.call();
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.SPOT_PRIORITY_SHOW_DETAILS(selectLocation?.key ?? "",
              selectChannel?.value?.key ?? "", frmDate.text, toDate.text),
          fun: (Map<String, dynamic> map) {
            Get.back();
            if (map.containsKey("showDetails") && map["showDetails"].containsKey("lstbookingdetail") && map["showDetails"]["lstbookingdetail"]!=null) {
              spotPriorityModel =
                  SpotPriorityModel.fromJson(map["showDetails"]);
              update(["spotPriorityList"]);
            } else {
              spotPriorityModel=null;
              update(["spotPriorityList"]);
              Snack.callError("No Data Found");
            }
          });
    }
  }

  saveSpotPriority() {
    if (selectLocation == null) {
      Snack.callError("Please select location");
    } else if (selectChannel.value == null) {
      Snack.callError("Please select channel");
    } else if (gridStateManager == null || spotPriorityModel == null) {
      Snack.callError("Sorry! There is no data to save");
    } else {
      if (spotPriorityModel?.areRecordExistsInSpotPriority != null &&
          (spotPriorityModel?.areRecordExistsInSpotPriority ?? false)) {
        LoadingDialog.recordExists(
            "Priority already defined!\nDo you want to overwrite this?", () {
          postData();
        }, deleteTitle: "Yes", deleteCancel: "No", cancel: () {});
      } else {
        postData();
      }
    }
  }

  postData() {
    var filterList = spotPriorityModel?.lstbookingdetail?.where((e) {
      return (e.priorityCode! > 0);
    });
    var mapData = {
      "locationcode": selectLocation?.key ?? "",
      "channelcode": selectChannel?.value?.key ?? "",
      "fromDate": frmDate.text,
      "toDate": toDate.text,
      "spotprioritys": filterList?.map((e) {
        return e.toJson1();
      }).toList()
    };
    LoadingDialog.call();
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.SPOT_PRIORITY_SAVE(),
        json: mapData,
        fun: (Map<String, dynamic> map) {
          Get.back();
          if (map.containsKey("postSave") &&
              map["postSave"] == "Records are updated successfully.") {
            LoadingDialog.callDataSaved(callback: () {
              Get.delete<SpotPriorityController>();
              Get.find<HomeController>().clearPage1();
            });
          } else {
            Snack.callError(map.toString());
          }
        });
  }
}

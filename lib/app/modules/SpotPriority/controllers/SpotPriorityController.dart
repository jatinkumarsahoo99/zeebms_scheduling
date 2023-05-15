import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../../widgets/Snack.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../controller/MainController.dart';
import '../../../data/DropDownValue.dart';
import '../../../providers/ApiFactory.dart';
import '../SpotPriorityModel.dart';

class SpotPriorityController extends GetxController {
  var locations = RxList<DropDownValue>();
  var channels = RxList<DropDownValue>([]);
  var priorityList = RxList<DropDownValue>([]);
  RxBool isEnable = RxBool(true);

  //input controllers
  DropDownValue? selectLocation;
  DropDownValue? selectChannel;
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

  getLocations() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.SPOT_PRIORITY_LOCATION(),
        fun: (Map map) {
          locations.clear();
          map["setSpotPriority"]["location"].forEach((e) {
            locations.add(DropDownValue.fromJson1(e));
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
              selectChannel?.key ?? "", frmDate.text, toDate.text),
          fun: (Map<String, dynamic> map) {
            Get.back();
            if (map.containsKey("ShowDetails")) {
              spotPriorityModel =
                  SpotPriorityModel.fromJson(map["ShowDetails"]);
              update(["spotPriorityList"]);
            }
          });
    }
  }
}

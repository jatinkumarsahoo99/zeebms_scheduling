import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../controller/ConnectorControl.dart';
import '../../../controller/MainController.dart';
import '../../../data/DropDownValue.dart';
import '../../../providers/ApiFactory.dart';
import '../SpotPriorityModel.dart';

class SpotPriorityController extends GetxController {

  var locations = RxList<DropDownValue>();
  var channels = RxList<DropDownValue>([]);
  var additions = RxList<DropDownValue>([
    new DropDownValue(key: "All",value: "All"),
    new DropDownValue(key: "New",value: "New"),
  ]);
  RxBool isEnable = RxBool(true);

  //input controllers
  DropDownValue? selectLocation;
  DropDownValue? selectChannel;
  DropDownValue? selectAdditions;
  PlutoGridStateManager? gridStateManager;

  TextEditingController selectedDate = TextEditingController();
  TextEditingController remarks = TextEditingController();
  var isStandby = RxBool(false);
  var isIgnoreSpot = RxBool(false);
  RxnString verifyType = RxnString();

  List<SpotPriorityModel>? logAdditionModel = [
    new SpotPriorityModel(rowNo: 1, status: "data"),
    new SpotPriorityModel(rowNo: 1, status: "data"),
    new SpotPriorityModel(rowNo: 1, status: "data"),
    new SpotPriorityModel(rowNo: 1, status: "data"),
    new SpotPriorityModel(rowNo: 1, status: "data"),
    new SpotPriorityModel(rowNo: 1, status: "data"),
    new SpotPriorityModel(rowNo: 1, status: "data"),
    new SpotPriorityModel(rowNo: 1, status: "data"),
    new SpotPriorityModel(rowNo: 1, status: "data"),
    new SpotPriorityModel(rowNo: 1, status: "data"),
    new SpotPriorityModel(rowNo: 1, status: "data"),
    new SpotPriorityModel(rowNo: 1, status: "data"),
    new SpotPriorityModel(rowNo: 1, status: "data"),
    new SpotPriorityModel(rowNo: 1, status: "data"),
    new SpotPriorityModel(rowNo: 1, status: "data"),
    new SpotPriorityModel(rowNo: 1, status: "data"),
    new SpotPriorityModel(rowNo: 1, status: "data"),
    new SpotPriorityModel(rowNo: 1, status: "data"),
    new SpotPriorityModel(rowNo: 1, status: "data"),
    new SpotPriorityModel(rowNo: 1, status: "data"),
  ];
  PlutoGridMode selectedPlutoGridMode = PlutoGridMode.normal;



  @override
  void onInit() {
    super.onInit();
  }

  getLocations() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.MOVIE_PLANNER_GET_LOCATIONS,
        fun: (Map map) {
          locations.clear();
          map["location"].forEach((e) {
            locations.add(DropDownValue.fromJson1(e));
          });
        });
  }

  getChannels(String key) {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.MOVIE_PLANNER_GET_DATA_ON_LOCATION_SELECT(
          userId: Get.find<MainController>().user?.logincode ?? "",
          location: key,
        ),
        fun: (Map map) {
          channels.clear();
          map["locationSelect"].forEach((e) {
            channels.add(
                DropDownValue.fromJsonDynamic(e, "channelCode", "channelName"));
          });
        });
  }
}

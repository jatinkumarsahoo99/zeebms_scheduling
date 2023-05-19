import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../controller/ConnectorControl.dart';
import '../../../controller/MainController.dart';
import '../../../data/DropDownValue.dart';
import '../../../providers/ApiFactory.dart';
import '../../TransmissionLog/TransmissionLogModel.dart';

class SlideController extends GetxController {

  var locations = RxList<DropDownValue>();
  var channels = RxList<DropDownValue>([]);
  RxBool isEnable = RxBool(true);

  //input controllers
  DropDownValue? selectLocation;
  DropDownValue? selectChannel;
  PlutoGridStateManager? gridStateManager;

  // PlutoGridMode selectedPlutoGridMode = PlutoGridMode.normal;
  var isStandby = RxBool(false);
  var isMy = RxBool(true);
  var isInsertAfter = RxBool(false);
  TextEditingController selectedDate = TextEditingController();
  TextEditingController startTime_ = TextEditingController();
  TextEditingController offsetTime_ = TextEditingController();
  TextEditingController txId_ = TextEditingController();
  TextEditingController txCaption_ = TextEditingController();
  TextEditingController insertDuration_ = TextEditingController();
  TextEditingController segmentFpcTime_ = TextEditingController();

  List<TransmissionLogModel>? transmissionLogList = [
    new TransmissionLogModel(rowNo: 1, status: "data"),
    new TransmissionLogModel(rowNo: 1, status: "data"),
    new TransmissionLogModel(rowNo: 1, status: "data"),
    new TransmissionLogModel(rowNo: 1, status: "data"),
    new TransmissionLogModel(rowNo: 1, status: "data"),
    new TransmissionLogModel(rowNo: 1, status: "data"),
    new TransmissionLogModel(rowNo: 1, status: "data"),
    new TransmissionLogModel(rowNo: 1, status: "data"),
    new TransmissionLogModel(rowNo: 1, status: "data"),
    new TransmissionLogModel(rowNo: 1, status: "data"),
    new TransmissionLogModel(rowNo: 1, status: "data"),
    new TransmissionLogModel(rowNo: 1, status: "data"),
    new TransmissionLogModel(rowNo: 1, status: "data"),
    new TransmissionLogModel(rowNo: 1, status: "data"),
    new TransmissionLogModel(rowNo: 1, status: "data"),
    new TransmissionLogModel(rowNo: 1, status: "data"),
    new TransmissionLogModel(rowNo: 1, status: "data"),
    new TransmissionLogModel(rowNo: 1, status: "data"),
    new TransmissionLogModel(rowNo: 1, status: "data"),
    new TransmissionLogModel(rowNo: 1, status: "data"),
  ];
  PlutoGridMode selectedPlutoGridMode = PlutoGridMode.normal;
  int? selectedIndex;
  RxnString verifyType = RxnString();
  RxList<DropDownValue> listLocation = RxList([]);
  RxList<DropDownValue> listChannel = RxList([]);

  @override
  void onInit() {
    super.onInit();
    getLocations();
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


  pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single != null) {
      // importedFile.value = result.files.single;
      // fileController.text = result.files.single.name;
      // importfile();
    } else {
      // User canceled the pic5ker
    }
  }
}

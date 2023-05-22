import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../controller/MainController.dart';
import '../../../data/DropDownValue.dart';
import '../../../providers/ApiFactory.dart';
import '../TransmissionLogModel.dart';

class TransmissionLogController extends GetxController {
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

  TransmissionLogModel? transmissionLog;
  PlutoGridMode selectedPlutoGridMode = PlutoGridMode.selectWithOneTap;
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
        api: ApiFactory.TRANSMISSION_LOG_LOCATION(),
        fun: (Map map) {
          locations.clear();
          map["location"].forEach((e) {
            locations.add(DropDownValue.fromJson1(e));
          });
        });
  }

  getChannels(String key) {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.TRANSMISSION_LOG_CHANNEL(
          key,
        ),
        fun: (Map map) {
          channels.clear();
          map["locationSelect"].forEach((e) {
            channels.add(
                DropDownValue.fromJsonDynamic(e, "channelCode", "channelName"));
          });
        });
  }

  getChannelFocusOut() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.TRANSMISSION_LOG_CHANNEL_SPEC_SETTING(
          selectLocation?.key ?? "",
          selectChannel?.key ?? "",
        ),
        fun: (Map map) {
          channels.clear();
          map["locationSelect"].forEach((e) {
            channels.add(
                DropDownValue.fromJsonDynamic(e, "channelCode", "channelName"));
          });
        });
  }

  callRetrieve() {
    LoadingDialog.call();
    var sendData = {
      "locationcode": "ZAZEE00001",
      "channelcode": "ZAZEE00001",
      "standbyLog": "False",
      "telecastdate": "03-03-2023",
      "copylog": false,
      "dontSavefile": false,
      "maxProgramStarttimeDiff": 0,
      "txtTransmissionTime": "1",
      "txtDateChange": "01-Mar-2023",
      "txtDStarttime": "01-Mar-2023",
      "tblLog_DefaultView_RowFilter": ""
    };
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.TRANSMISSION_LOG_RETRIVE(),
        json: sendData,
        fun: (Map<String, dynamic> map) {
          Get.back();
          transmissionLog = TransmissionLogModel.fromJson(map);
          update(["transmissionList"]);
        });
  }
}

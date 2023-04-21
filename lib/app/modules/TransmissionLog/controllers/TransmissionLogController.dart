import 'package:bms_scheduling/app/modules/TransmissionLog/bindings/transmission_log_binding.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../data/DropDownValue.dart';
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

  @override
  void onInit() {
    super.onInit();
  }
}

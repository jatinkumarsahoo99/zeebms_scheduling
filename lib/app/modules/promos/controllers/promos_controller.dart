import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';
import '../../../../widgets/LoadingDialog.dart';
import '../../../../widgets/Snack.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../controller/HomeController.dart';
import '../../../data/DropDownValue.dart';
import '../../../data/PermissionModel.dart';
import '../../../data/system_envirtoment.dart';
import '../../filler/FillerDailyFPCModel.dart';
import '../../filler/FillerSegmentModel.dart';

class PromosController extends GetxController {
  var locations = <DropDownValue>[].obs;
  var channels = <DropDownValue>[].obs;
  RxBool controllsEnabled = true.obs;
  var locationFN = FocusNode();
  var myEnabled = true.obs;
  DropDownValue? selectLocation, selectChannel;
  var left1stDT = [].obs, left2ndDT = [].obs, right3rdDT = [].obs;
  var fromdateTC = TextEditingController();
  var timeBand = "00:00:00:00".obs, programName = "PrgName".obs;

  var availableTC = TextEditingController(),
      scheduledTC = TextEditingController(),
      countTC = TextEditingController(),
      promoIDTC = TextEditingController(),
      promoCaptionTC = TextEditingController();

  clearPage() {
    selectLocation = null;
    selectChannel = null;
    locations.refresh();
    channels.refresh();
    controllsEnabled.value = true;
    myEnabled.value = true;
    timeBand.value = "";
    programName.value = "PrgName";
    availableTC.clear();
    scheduledTC.clear();
    countTC.clear();
    promoIDTC.clear();
    left1stDT.clear();
    left2ndDT.clear();
    promoCaptionTC.clear();
    right3rdDT.clear();
    locationFN.requestFocus();
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    getLocation();
  }

  formHandler(btnName) async {
    if (btnName == "Clear") {
      clearPage();
    }
  }

  void getChannel(DropDownValue? val) {
    selectLocation = val;
    if (val != null) {
      LoadingDialog.call();
      Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.PROMOS_GET_CHANNELS(val.key ?? ""),
        fun: (resp) {
          if (resp != null && resp is List<dynamic>) {
            selectChannel = null;
            channels.clear();
            channels.addAll(resp
                .map((e) => DropDownValue(
                      key: e['locationCode'],
                      value: e['locationName'],
                    ))
                .toList());
          } else {
            LoadingDialog.showErrorDialog(resp.toString());
          }
        },
      );
    }
  }

  void getLocation() {
    Get.find<ConnectorControl>().GETMETHODCALL(
      api: ApiFactory.PROMOS_GET_LOCATION,
      fun: (resp) {
        if (resp != null && resp is List<dynamic>) {
          locations.clear();
          locations.addAll(resp
              .map((e) => DropDownValue(
                    key: e['locationCode'].toString(),
                    value: e['locationName'].toString(),
                  ))
              .toList());
        }
      },
    );
  }

  void showDetails() {}

  void handleDelete() {}

  void handleImportTap() {}

  void handleAddTap() {}

  void handleSearchTap() {}

  void handleAutoAddTap() {}
}

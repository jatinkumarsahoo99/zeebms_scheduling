import 'dart:convert';
import 'dart:developer';
import 'package:bms_scheduling/app/providers/extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../../widgets/LoadingDialog.dart';
import '../../../../widgets/Snack.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../data/DropDownValue.dart';
import '../../../data/PermissionModel.dart';
import '../../../data/system_envirtoment.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/DataGridMenu.dart';
import '../../../providers/SizeDefine.dart';
import '../../../providers/Utils.dart';
import '../../../routes/app_pages.dart';
import '../CommercialProgramModel.dart';
import '../CommercialShowOnTabModel.dart';

class CommercialController extends GetxController {
  /// Radio Button
  int? tabIndex = 0;
  int selectIndex = 0;
  int? selectedDDIndex;

  int selectedGroup = 0;
  double widthSize = 0.17;
  String? programFpcTimeSelected;
  int? mainSelectedIndex;
  String? programCodeSelected;
  String? exportTapeCodeSelected;
  String? pDailyFPCSelected;
  DropDownValue? selectedChannel;
  DropDownValue? selectedLocation;

  var selectedIndex = RxInt(0);
  RxBool isEnable = RxBool(true);
  var channelEnable = RxBool(true);
  var locationEnable = RxBool(true);
  var selectedChannels = RxList([]);
  var commercialSpots = RxString("");
  var commercialDuration = RxString("");

  var locations = RxList<DropDownValue>();
  var channels = RxList<DropDownValue>([]);

  DateTime? selectedDate = DateTime.now();
  DateFormat df = DateFormat("dd/MM/yyyy");
  DateFormat df1 = DateFormat("dd-MM-yyyy");
  DateFormat df2 = DateFormat("MM-dd-yyyy");
  DateFormat dfFinal = DateFormat("yyyy-MM-ddThh:mm:ss");

  List beams = [];
  List<PlutoRow> beamRows = [];
  List<PlutoRow> initRows = [];
  List<PlutoColumn> initColumn = [];
  List<PermissionModel>? formPermissions;
  List<CommercialProgramModel>? commercialProgramList = [];
  RxList<CommercialShowOnTabModel>? showCommercialDetailsList =
      <CommercialShowOnTabModel>[].obs;
  RxList<CommercialShowOnTabModel>? mainCommercialShowDetailsList =
      <CommercialShowOnTabModel>[].obs;

  /////////////Pluto Grid////////////
  PlutoGridStateManager? stateManager;
  PlutoGridStateManager? gridStateManager;
  PlutoGridStateManager? locChanStateManager;
  PlutoGridStateManager? bmsReportStateManager;
  PlutoGridMode selectedTabPlutoGridMode = PlutoGridMode.select;
  PlutoGridMode selectedProgramPlutoGridMode = PlutoGridMode.selectWithOneTap;
  late PlutoGridStateManager conflictReportStateManager;

  List<SystemEnviroment>? channelList = [];
  List<SystemEnviroment>? locationList = [];

  CommercialProgramModel? selectedProgram;
  CommercialShowOnTabModel? selectedShowOnTab;

  TextEditingController date_ = TextEditingController();
  TextEditingController refDateControl = TextEditingController(
      text: DateFormat("dd-MM-yyyy").format(DateTime.now()));

  @override
  void onInit() {
    super.onInit();
    getLocations();
  }

  getLocations() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.COMMERCIAL_LOCATION,
        fun: (Map map) {
          locations.clear();
          map["csload"]["lstLocations"].forEach((e) {
            locations.add(DropDownValue.fromJson1(e));
          });
        });
  }

  getChannel(locationCode) {
    try {
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.COMMERCIAL_CHANNEL(locationCode),
          fun: (data) {
            if (data["locationSelect"] is List) {
              channels.value = (data["locationSelect"] as List)
                  .map((e) => DropDownValue(
                      key: e["channelCode"], value: e["channelName"]))
                  .toList();
            } else {
              LoadingDialog.callErrorMessage1(
                  msg: "Failed To Load Initial Data");
            }
          });
    } catch (e) {
      LoadingDialog.callErrorMessage1(msg: "Failed To Load Initial Data");
    }
  }

  fetchSchedulingDetails() {
    print("Selected Channel is : ${selectedChannel?.key ?? ""}");
    if (selectedLocation == null) {
      Snack.callError("Please select location");
    } else if (selectedChannel == null) {
      Snack.callError("Please select location");
    } else if (selectedDate == null) {
      Snack.callError("Please select date");
    } else {
      LoadingDialog.call();
      selectedDate = df1.parse(date_.text);
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.COMMERCIAL_SHOW_FPC_SCHEDULLING_DETAILS(
              selectedLocation?.key ?? "",
              selectedChannel?.key ?? "",
              df1.format(selectedDate!)),
          fun: (dynamic list) {
            print("Json response is>>>" + jsonEncode(list));

            commercialProgramList?.clear();
            list['showDetails']["lstDailyFPC"].forEach((element) {
              commercialProgramList
                  ?.add(CommercialProgramModel.fromJson(element));
            });

            mainCommercialShowDetailsList?.clear();
            showCommercialDetailsList?.clear();
            list['showDetails']['lstCommercialShuffling']
                .asMap()
                .forEach((index, element) {
              mainCommercialShowDetailsList
                  ?.add(CommercialShowOnTabModel.fromJson( element, index ));
            });
            showCommercialDetailsList?.value = mainCommercialShowDetailsList!
                .where((o) => o.bStatus.toString() == 'B')
                .toList();

            // commercialSpots.value =
            //     list['showDetails']['bindGridOutPut']['commercialSpots'] ?? "";
            // commercialDuration.value = list['showDetails']['bindGridOutPut']
            // ['commercialDuration'] ?? "";

            print("fetchProgramSchedulingDetails() Called");
            updateTab();
            // update(["programTable"]);
            // update(["schedulingTable"]);
            // update(["fpcMismatchTable"]);
            // update(["misMatchTable"]);
            Get.back();
          },
          failed: (val) {
            Snack.callError(val.toString());
          });
    }
  }

  updateTab() {
    update(["programTable"]);
    update(["schedulingTable"]);
    update(["fpcMismatchTable"]);
    update(["misMatchTable"]);
  }

  formHandler(btnName) async {
    if (btnName == "Clear") {
      clear();
    }

    if (btnName == "Save") {
      saveSchedulingData();
    }

    if (btnName == "Exit") {
      exit();
    }
  }

  Future<dynamic> showTabList() async {
    showCommercialDetailsList?.clear();
    if (selectedIndex.value == 1) {
      ///Filter bStatus F, calculate spot duration then calling ColorGrid filter
      showCommercialDetailsList?.value = mainCommercialShowDetailsList!
          .where((o) => o.bStatus.toString() == 'F')
          .toList();
      showCommercialDetailsList?.refresh();
    } else if (selectedIndex.value == 2) {
      ///Filter bStatus E, calculate spot duration then calling ColorGrid filter
      showCommercialDetailsList?.value = mainCommercialShowDetailsList!
      .where((o) => o.bStatus.toString() == 'E')
          .toList();
      showCommercialDetailsList?.refresh();
    } else {
      ///Filter bStatus B, calculate spot duration then calling ColorGrid filter
      showCommercialDetailsList?.value = mainCommercialShowDetailsList!
          .where((o) => o.bStatus.toString() == 'B')
          .toList();
      showCommercialDetailsList?.refresh();
    }
    updateTab();
    return showCommercialDetailsList?.value;
  }

  Future<dynamic> showSelectedProgramList(BuildContext context) async {
    if (selectedIndex.value == 1) {
      ///Filter F, calculate spot duration then calling ColorGrid filter
      print(programFpcTimeSelected.toString());
      showCommercialDetailsList?.value = mainCommercialShowDetailsList!
          .where((o) =>
              o.fpcTime.toString() == programFpcTimeSelected &&
              o.bStatus.toString() == 'F')
          .toList();
      showCommercialDetailsList?.refresh();
    } else if (selectedIndex.value == 2) {
      ///Filter E, calculate spot duration then calling ColorGrid filter
      print(programFpcTimeSelected.toString());
      showCommercialDetailsList?.value = mainCommercialShowDetailsList!
          .where((o) =>
      o.fpcTime.toString() == programFpcTimeSelected &&
          o.bStatus.toString() == 'E')
          .toList();
      showCommercialDetailsList?.refresh();
    } else {
      /// Filter B, calculate spot duration then calling ColorGrid filter.
      showCommercialDetailsList?.value = mainCommercialShowDetailsList!
          .where((o) =>
      o.fpcTime.toString() == programFpcTimeSelected &&
          o.bStatus.toString() == 'B')
          .toList();
      showCommercialDetailsList?.refresh();
    }
    updateTab();
    return showCommercialDetailsList?.value;
  }

  RxList<CommercialShowOnTabModel>? changeFPCOnClick() {
    /// BStatus == "B" &&
    /// FPCTime == programFpcTimeSelected &&
    /// PProgramMaster = programProgramCodeSelected &&
    /// PDailyFPC == programProgramCodeSelected
    print(exportTapeCodeSelected.toString());
    var list = mainCommercialShowDetailsList!
        .where((o) => o.bStatus.toString() == 'F')
        .toList();
    var target = list[mainSelectedIndex!];
    print(mainSelectedIndex!.toString());
    print("changeFPCOnClick : $target");
    target.bStatus = 'B';
    target.fpcTime = programFpcTimeSelected;
    target.pProgramMaster = programCodeSelected;
    target.pDailyFPC = programCodeSelected;
    mainCommercialShowDetailsList?.refresh();
    updateTab();
    showTabList();

    return mainCommercialShowDetailsList;
  }

  RxList<CommercialShowOnTabModel>? misMatchOnClick() {
    /// BStatus == "B" && PProgramMaster = PDailyFPC
    print(exportTapeCodeSelected.toString());
    // var target = mainCommercialShowDetailsList!
    //     .firstWhere((item) => item.exportTapeCode == exportTapeCodeSelected);

    var list = mainCommercialShowDetailsList!
        .where((o) => o.bStatus.toString() == 'F')
        .toList();
    var target = list[mainSelectedIndex!];
    print("misMatchOnClick : $target");
    target.bStatus = 'B';
    target.pProgramMaster = pDailyFPCSelected;
    mainCommercialShowDetailsList?.refresh();
    updateTab();
    showTabList();
    return mainCommercialShowDetailsList;
  }

  RxList<CommercialShowOnTabModel>? markAsErrorOnClick() {
    /// BStatus == "E"
    print(exportTapeCodeSelected.toString());
    var list = mainCommercialShowDetailsList!
        .where((o) => o.bStatus.toString() == 'F')
        .toList();
    var target = list[mainSelectedIndex!];
    print("markAsErrorOnClick : $target");
    target.bStatus = 'E';
    mainCommercialShowDetailsList?.refresh();
    updateTab();
    showTabList();
    return mainCommercialShowDetailsList;
  }

  RxList<CommercialShowOnTabModel>? unMarkAsErrorOnClick() {
    /// BStatus == "B"
    print(exportTapeCodeSelected.toString());
    // var target = mainCommercialShowDetailsList!
    //     .firstWhere((item) => item.exportTapeCode == exportTapeCodeSelected);
    var list = mainCommercialShowDetailsList!
        .where((o) => o.bStatus.toString() == 'E')
        .toList();
    var target = list[mainSelectedIndex!];
    print("unMarkAsErrorOnClick : $target");
    target.bStatus = 'B';
    mainCommercialShowDetailsList?.refresh();
    updateTab();
    showTabList();
    return mainCommercialShowDetailsList;
  }

  /// Not Completed
  saveSchedulingData() {
    if (selectedLocation == null) {
      Snack.callError("Please select location");
    } else if (selectedChannel == null) {
      Snack.callError("Please select location");
    } else if (selectedDate == null) {
      Snack.callError("Please select date");
    } else {
      selectedDate = df1.parse(date_.text);
      try {
        var jsonRequest = {
          "locationCode": selectedLocation?.key.toString(),
          "channelCode": selectedChannel?.key.toString(),
          "scheduleDate": df1.format(selectedDate!),
          "lstCommercialShuffling":
              mainCommercialShowDetailsList?.map((e) => e.toJson()).toList(),
        };
        print("requestedToSaveData >>>" + jsonEncode(jsonRequest));
        Get.find<ConnectorControl>().POSTMETHOD(
            api: ApiFactory.SAVE_COMMERCIAL_DETAILS(),
            fun: (dynamic data) {
              print("Json response is>>>" + jsonEncode(data));

              print("saveSchedulingData Called");
              update(["fillerShowOnTabTable"]);
            },
            json: jsonRequest);
      } catch (e) {
        LoadingDialog.callErrorMessage1(msg: "Failed To Save Data");
      }
    }
  }

  void clear() {
    date_.text = "";
    selectedChannel = null;
    selectedLocation = null;
    commercialSpots.value = "";
    commercialDuration.value = "";

    commercialProgramList?.clear();
    mainCommercialShowDetailsList?.clear();
    showCommercialDetailsList?.clear();

    locationEnable.value = true;
    channelEnable.value = true;
    update(["initData"]);
    update(["programTable"]);
    update(["schedulingTable"]);
    update(["fpcMismatchTable"]);
    update(["misMatchTable"]);
  }

  void exit() {
    clear();
    Get.find<HomeController>().selectChild1.value = null;
    Get.delete<CommercialController>();
  }
}

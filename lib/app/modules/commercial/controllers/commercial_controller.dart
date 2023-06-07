import 'dart:convert';
import 'dart:developer';
import 'package:bms_scheduling/app/providers/extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';
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
  List<dynamic>? colorList = [
    {"eventType": "A", "foreColor": "ff000000", "backColor": "ffa9fd77"},
    {"eventType": "C", "foreColor": "ff090900", "backColor": "ffffff80"},
    {"eventType": "CL", "foreColor": "ff090900", "backColor": "ffffff80"},
    {"eventType": "F", "foreColor": "ff000000", "backColor": "ff887cfc"},
    {"eventType": "GL", "foreColor": "ff000000", "backColor": "fffe46b8"},
    {"eventType": "I", "foreColor": "ff000000", "backColor": "ff027f45"},
    {"eventType": "L", "foreColor": "ff000000", "backColor": "ff9bffcd"},
    {"eventType": "M", "foreColor": "ff000000", "backColor": "ffc6f8c0"},
    {"eventType": "N", "foreColor": "ff000000", "backColor": "ff00f000"},
    {"eventType": "O", "foreColor": "ff000000", "backColor": "ffc4e40c"},
    {"eventType": "P", "foreColor": "ff000000", "backColor": "ffc44331"},
    {"eventType": "PR", "foreColor": "ff400000", "backColor": "ffffffff"},
    {"eventType": "re", "foreColor": "ff000000", "backColor": "ff000000"},
    {"eventType": "S", "foreColor": "ff100901", "backColor": "ffff8000"},
    {"eventType": "VP", "foreColor": "ff060606", "backColor": "ffc0c0c2"},
    {"eventType": "W", "foreColor": "ff000000", "backColor": "ffa9fd77"}
  ];

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
                  ?.add(CommercialShowOnTabModel.fromJson(element, index));
            });

            showCommercialDetailsList?.value = mainCommercialShowDetailsList!
                .where((o) => o.bStatus.toString() == 'B')
                .toList();

            var cList = mainCommercialShowDetailsList!
                .where((o) =>
                    o.eventType.toString() == 'C' &&
                    o.bStatus.toString() == 'B')
                .toList();
            commercialSpots.value = cList.length.toString();
            print("commercialSpots value is : ${commercialSpots.value}");

            double intTotalDuration = 0;
            for (int i = 0; i <= cList.length - 1; i++) {
              intTotalDuration = intTotalDuration +
                  Utils.oldBMSConvertToSecondsValue(value: cList[i].duration!);
            }
            commercialDuration.value =
                Utils.convertToTimeFromDouble(value: intTotalDuration);
            print("commercialDuration value is : ${commercialDuration.value}");

            // commercialSpots.value =
            //     list['showDetails']['bindGridOutPut']['commercialSpots'] ?? "";
            // commercialDuration.value = list['showDetails']['bindGridOutPut']
            // ['commercialDuration'] ?? "";

            updateAllTabs();
            Get.back();
          },
          failed: (val) {
            Snack.callError(val.toString());
          });
    }
  }

  updateAllTabs() {
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
    updateAllTabs();
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
    updateAllTabs();
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
    updateAllTabs();
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
    updateAllTabs();
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
    updateAllTabs();
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
    updateAllTabs();
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

  Color colorSort(String eventType) {
    // int? size = colorList?.length;
    Color color = Colors.white;
    // for (int i = 0; i <= size! - 1; i++) {
    //   if (colorList![i]['eventType'] == eventType) {
    //     color= Color(int.parse('0x${colorList![i]['backColor']}'));
    //     print(colorList![i]['backColor']);
    //   }else{
    //     color = Colors.white;
    //   }
    // }

    switch (eventType) {
      case "A ":
        color = Color(int.parse('0xffa9fd77'));
        break;
      case "A":
        color = Color(int.parse('0xffa9fd77'));
        break;
      case "C ":
        color = Color(int.parse('0xffffff80'));
        break;
      case "C":
        color = Color(int.parse('0xffffff80'));
        break;
      case "CL ":
        color = Color(int.parse('0xffffff80'));
        break;
      case "CL":
        color = Color(int.parse('0xffffff80'));
        break;
      case "F ":
        color = Color(int.parse('0xff887cfc'));
        break;
      case "F":
        color = Color(int.parse('0xff887cfc'));
        break;
      case "GL ":
        color = Color(int.parse('0xfffe46b8'));
        break;
      case "GL":
        color = Color(int.parse('0xfffe46b8'));
        break;
      case "I ":
        color = Color(int.parse('0xff027f45'));
        break;
      case "I":
        color = Color(int.parse('0xff027f45'));
        break;
      case "L ":
        color = Color(int.parse('0xff9bffcd'));
        break;
      case "L":
        color = Color(int.parse('0xff9bffcd'));
        break;
      case "M ":
        color = Color(int.parse('0xffc6f8c0'));
        break;
      case "M":
        color = Color(int.parse('0xffc6f8c0'));
        break;
      case "N ":
        color = Color(int.parse('0xff00f000'));
        break;
      case "N":
        color = Color(int.parse('0xff00f000'));
        break;
      case "O ":
        color = Color(int.parse('0xffc4e40c'));
        break;
      case "O":
        color = Color(int.parse('0xffc4e40c'));
        break;
      case "P ":
        color = Color(int.parse('0xffc44331'));
        break;
      case "P":
        color = Color(int.parse('0xffc44331'));
        break;
      case "PR ":
        color = Color(int.parse('0xffffffff'));
        break;
      case "PR":
        color = Color(int.parse('0xffffffff'));
        break;
      case "re ":
        color = Color(int.parse('0xff000000'));
        break;
      case "re":
        color = Color(int.parse('0xff000000'));
        break;
      case "S ":
        color = Color(int.parse('0xffff8000'));
        break;
      case "S":
        color = Color(int.parse('0xffff8000'));
        break;
      case "VP ":
        color = Color(int.parse('0xffc0c0c2'));
        break;
      case "VP":
        color = Color(int.parse('0xffc0c0c2'));
        break;
      case "W ":
        color = Color(int.parse('0xffa9fd77'));
        break;
      case "W":
        color = Color(int.parse('0xffa9fd77'));
        break;
      default:
        Colors.white;
    }

    return color;
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

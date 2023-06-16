import 'dart:convert';

import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/LoadingDialog.dart';
import '../../../../widgets/Snack.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../controller/HomeController.dart';
import '../../../data/DropDownValue.dart';
import '../../../data/PermissionModel.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/Utils.dart';
import '../CommercialProgramModel.dart';
import '../CommercialShowOnTabModel.dart';

class CommercialController extends GetxController {
  int? selectedDDIndex;
  int leftTableSelectedIdx = 0;
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
  var commercialSpots = "".obs;
  var commercialDuration = "".obs;
  var locationFN = FocusNode();

  var locations = <DropDownValue>[].obs;
  var channels = <DropDownValue>[].obs;

  DateTime? selectedDate = DateTime.now();
  DateFormat df = DateFormat("dd/MM/yyyy");
  DateFormat df1 = DateFormat("dd-MM-yyyy");
  DateFormat df2 = DateFormat("MM-dd-yyyy");
  DateFormat dfFinal = DateFormat("yyyy-MM-ddThh:mm:ss");
  List<PermissionModel>? formPermissions;
  List<CommercialProgramModel>? commercialProgramList = [];
  var showCommercialDetailsList = <CommercialShowOnTabModel>[].obs;
  var mainCommercialShowDetailsList = <CommercialShowOnTabModel>[].obs;

  /////////////Pluto Grid////////////
  PlutoGridStateManager? gridStateManager;
  PlutoGridStateManager? fpcMisMatchStateManager;
  PlutoGridStateManager? markedAsErrorStateManager;
  PlutoGridMode selectedTabPlutoGridMode = PlutoGridMode.select;
  // PlutoGridMode selectedProgramPlutoGridMode = PlutoGridMode.selectWithOneTap;

  CommercialProgramModel? selectedProgram;
  CommercialShowOnTabModel? selectedShowOnTab;

  TextEditingController date_ = TextEditingController();
  TextEditingController refDateControl = TextEditingController(text: DateFormat("dd-MM-yyyy").format(DateTime.now()));
  String? previousTimeSelected;

  void clear() {
    leftTableSelectedIdx = 0;
    programFpcTimeSelected = null;
    previousTimeSelected = null;
    selectedProgram = null;
    selectedIndex.value = 0;
    mainSelectedIndex = null;
    date_.text = "";
    selectedChannel = null;
    selectedLocation = null;
    commercialSpots.value = "";
    commercialDuration.value = "";
    commercialProgramList?.clear();
    mainCommercialShowDetailsList.clear();
    showCommercialDetailsList.clear();
    updateAllTabs();
    update(['initialData']);

    locationFN.requestFocus();
  }

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
              channels.value = (data["locationSelect"] as List).map((e) => DropDownValue(key: e["channelCode"], value: e["channelName"])).toList();
            } else {
              LoadingDialog.callErrorMessage1(msg: "Failed To Load Initial Data");
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
          api: ApiFactory.COMMERCIAL_SHOW_FPC_SCHEDULLING_DETAILS(selectedLocation?.key ?? "", selectedChannel?.key ?? "", df1.format(selectedDate!)),
          fun: (dynamic list) {
            // print("Json response is>>>" + jsonEncode(list));
            programFpcTimeSelected = null;
            selectedProgram = null;
            selectedIndex.value = 0;
            leftTableSelectedIdx = 0;
            commercialProgramList?.clear();
            list['showDetails']["lstDailyFPC"].forEach((element) {
              commercialProgramList?.add(CommercialProgramModel.fromJson(element));
            });

            mainCommercialShowDetailsList.clear();
            showCommercialDetailsList.clear();
            list['showDetails']['lstCommercialShuffling'].asMap().forEach((index, element) {
              mainCommercialShowDetailsList.add(CommercialShowOnTabModel.fromJson(element, index));
            });

            showCommercialDetailsList.value = mainCommercialShowDetailsList.where((o) => o.bStatus.toString() == 'B').toList();

            var cList = mainCommercialShowDetailsList.where((o) => o.eventType.toString() == 'C' && o.bStatus.toString() == 'B').toList();
            commercialSpots.value = cList.length.toString();
            print("commercialSpots value is : ${commercialSpots.value}");

            double intTotalDuration = 0;
            for (int i = 0; i <= cList.length - 1; i++) {
              intTotalDuration = intTotalDuration + Utils.oldBMSConvertToSecondsValue(value: cList[i].duration!);
            }
            commercialDuration.value = Utils.convertToTimeFromDouble(value: intTotalDuration);
            // print("commercialDuration value is : ${commercialDuration.value}");
            updateAllTabs();
            Get.back();
          },
          failed: (val) {
            Get.back();
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
    showCommercialDetailsList.clear();
    if (selectedIndex.value == 1) {
      ///Filter bStatus F, calculate spot duration then calling ColorGrid filter
      showCommercialDetailsList.value = mainCommercialShowDetailsList.where((o) => o.bStatus.toString() == 'F').toList();
      showCommercialDetailsList.refresh();
    } else if (selectedIndex.value == 2) {
      ///Filter bStatus E, calculate spot duration then calling ColorGrid filter
      showCommercialDetailsList.value = mainCommercialShowDetailsList.where((o) => o.bStatus.toString() == 'E').toList();
      showCommercialDetailsList.refresh();
    } else {
      ///Filter bStatus B, calculate spot duration then calling ColorGrid filter
      showCommercialDetailsList.value = mainCommercialShowDetailsList.where((o) => o.bStatus.toString() == 'B').toList();
      showCommercialDetailsList.refresh();
    }
    updateAllTabs();
    return showCommercialDetailsList.value;
  }

  Future<dynamic> showSelectedProgramList(BuildContext context) async {
    if (selectedIndex.value == 1) {
      ///Filter F, calculate spot duration then calling ColorGrid filter
      print(programFpcTimeSelected.toString());
      showCommercialDetailsList.value =
          mainCommercialShowDetailsList.where((o) => o.fpcTime.toString() == programFpcTimeSelected && o.bStatus.toString() == 'F').toList();
      showCommercialDetailsList.refresh();
    } else if (selectedIndex.value == 2) {
      ///Filter E, calculate spot duration then calling ColorGrid filter
      print(programFpcTimeSelected.toString());
      showCommercialDetailsList.value =
          mainCommercialShowDetailsList.where((o) => o.fpcTime.toString() == programFpcTimeSelected && o.bStatus.toString() == 'E').toList();
      showCommercialDetailsList.refresh();
    } else {
      /// Filter B, calculate spot duration then calling ColorGrid filter.
      showCommercialDetailsList.value =
          mainCommercialShowDetailsList.where((o) => o.fpcTime.toString() == programFpcTimeSelected && o.bStatus.toString() == 'B').toList();
      commercialSpots.value = showCommercialDetailsList.where((o) => o.eventType == "C").toList().length.toString();
      num intTotalDuration = 0;
      for (int i = 0; i < (showCommercialDetailsList.length); i++) {
        if (showCommercialDetailsList[i].eventType == "C") {
          intTotalDuration = intTotalDuration + Utils.oldBMSConvertToSecondsValue(value: showCommercialDetailsList[i].duration ?? "");
        }
      }
      commercialDuration.value = Utils.convertToTimeFromDouble(value: intTotalDuration);
      showCommercialDetailsList.refresh();
    }
    updateAllTabs();
    return showCommercialDetailsList.value;
  }

  changeFPCOnClick() async {
    /// BStatus == "B" &&
    /// FPCTime == programFpcTimeSelected &&
    /// PProgramMaster = programProgramCodeSelected &&
    /// PDailyFPC == programProgramCodeSelected
    // var list = mainCommercialShowDetailsList.where((o) => o.bStatus.toString() == 'F').toList();
    if (fpcMisMatchStateManager?.currentRowIdx == null || fpcMisMatchStateManager?.currentRowIdx == null) {
      LoadingDialog.showErrorDialog("Please select row first");
      return;
    } else if ((fpcMisMatchStateManager!.currentSelectingRows.isEmpty)) {
      for (var i = 0; i < mainCommercialShowDetailsList.length; i++) {
        if (mainCommercialShowDetailsList[i].bStatus == "F" &&
            (showCommercialDetailsList[fpcMisMatchStateManager!.currentRowIdx!].rownumber) == mainCommercialShowDetailsList[i].rownumber) {
          mainCommercialShowDetailsList[i].bStatus = "B";
          mainCommercialShowDetailsList[i].fpcTime = programFpcTimeSelected;
          mainCommercialShowDetailsList[i].pProgramMaster = programCodeSelected;
          mainCommercialShowDetailsList[i].pDailyFPC = programCodeSelected;
        }
      }
    } else {
      for (var i = 0; i < mainCommercialShowDetailsList.length; i++) {
        if (mainCommercialShowDetailsList[i].bStatus == "F") {
          for (var element in fpcMisMatchStateManager!.currentSelectingRows) {
            if (mainCommercialShowDetailsList[i].rownumber == showCommercialDetailsList[element.sortIdx].rownumber) {
              mainCommercialShowDetailsList[i].bStatus = "B";
              mainCommercialShowDetailsList[i].fpcTime = programFpcTimeSelected;
              mainCommercialShowDetailsList[i].pProgramMaster = programCodeSelected;
              mainCommercialShowDetailsList[i].pDailyFPC = programCodeSelected;
            }
          }
        }
      }
    }
    if (previousTimeSelected != null) {
      programFpcTimeSelected = previousTimeSelected;
    }
    // mainCommercialShowDetailsList.refresh();
    await showSelectedProgramList(Get.context!);
    updateAllTabs();
  }

  misMatchOnClick() {
    /// BStatus == "B" && PProgramMaster = PDailyFPC
    // var list = mainCommercialShowDetailsList.where((o) => o.bStatus.toString() == 'F').toList();
    // var target = list[mainSelectedIndex!];
    // target.bStatus = 'B';
    // target.pProgramMaster = pDailyFPCSelected;
    LoadingDialog.recordExists("Want to change FPC of selected record(s)?", () async {
      if (fpcMisMatchStateManager?.currentRowIdx == null || fpcMisMatchStateManager?.currentRowIdx == null) {
        LoadingDialog.showErrorDialog("Please select row first");
        return;
      } else if ((fpcMisMatchStateManager!.currentSelectingRows.isEmpty)) {
        for (var i = 0; i < mainCommercialShowDetailsList.length; i++) {
          if (mainCommercialShowDetailsList[i].bStatus == "F" &&
              (showCommercialDetailsList[fpcMisMatchStateManager!.currentRowIdx!].rownumber) == mainCommercialShowDetailsList[i].rownumber) {
            mainCommercialShowDetailsList[i].bStatus = "B";
            mainCommercialShowDetailsList[i].pProgramMaster = pDailyFPCSelected;
          }
        }
      } else {
        for (var i = 0; i < mainCommercialShowDetailsList.length; i++) {
          if (mainCommercialShowDetailsList[i].bStatus == "F") {
            for (var element in fpcMisMatchStateManager!.currentSelectingRows) {
              if (mainCommercialShowDetailsList[i].rownumber == showCommercialDetailsList[element.sortIdx].rownumber) {
                mainCommercialShowDetailsList[i].bStatus = "B";
                mainCommercialShowDetailsList[i].pProgramMaster = pDailyFPCSelected;
              }
            }
          }
        }
      }
      if (previousTimeSelected != null) {
        programFpcTimeSelected = previousTimeSelected;
      }
      // mainCommercialShowDetailsList.refresh();
      await showSelectedProgramList(Get.context!);
      updateAllTabs();
      // mainCommercialShowDetailsList.refresh();
      // updateAllTabs();
      // showTabList();
      // return mainCommercialShowDetailsList;
    });
  }

  markAsErrorOnClick() {
    /// BStatus == "E"
    // print(exportTapeCodeSelected.toString());
    // var list = mainCommercialShowDetailsList.where((o) => o.bStatus.toString() == 'F').toList();
    // var target = list[mainSelectedIndex!];
    // print("markAsErrorOnClick : $target");
    // target.bStatus = 'E';
    LoadingDialog.recordExists("Want to mark as error to selected record(s)?", () {
      if (fpcMisMatchStateManager?.currentRowIdx == null || fpcMisMatchStateManager?.currentRowIdx == null) {
        LoadingDialog.showErrorDialog("Please select row first");
        return;
      } else if ((fpcMisMatchStateManager!.currentSelectingRows.isEmpty)) {
        for (var i = 0; i < mainCommercialShowDetailsList.length; i++) {
          if (mainCommercialShowDetailsList[i].bStatus == "F" &&
              (showCommercialDetailsList[fpcMisMatchStateManager!.currentRowIdx!].rownumber) == mainCommercialShowDetailsList[i].rownumber) {
            mainCommercialShowDetailsList[i].bStatus = "E";
          }
        }
      } else {
        for (var i = 0; i < mainCommercialShowDetailsList.length; i++) {
          if (mainCommercialShowDetailsList[i].bStatus == "F") {
            for (var element in fpcMisMatchStateManager!.currentSelectingRows) {
              if (mainCommercialShowDetailsList[i].rownumber == showCommercialDetailsList[element.sortIdx].rownumber) {
                mainCommercialShowDetailsList[i].bStatus = "E";
              }
            }
          }
        }
      }
      mainCommercialShowDetailsList.refresh();
      // updateAllTabs();
      showTabList();
    });
    // return mainCommercialShowDetailsList;
  }

  unMarkAsErrorOnClick() {
    /// BStatus == "B"
    // var list = mainCommercialShowDetailsList.where((o) => o.bStatus.toString() == 'E').toList();
    // var target = list[mainSelectedIndex!];
    // target.bStatus = 'B';
    // mainCommercialShowDetailsList.refresh();
    // updateAllTabs();
    // showTabList();

    LoadingDialog.recordExists("Want to un-mark selected record(s)?", () {
      if (markedAsErrorStateManager?.currentRowIdx == null || markedAsErrorStateManager?.currentRowIdx == null) {
        LoadingDialog.showErrorDialog("Please select row first");
        return;
      } else if ((markedAsErrorStateManager!.currentSelectingRows.isEmpty)) {
        for (var i = 0; i < mainCommercialShowDetailsList.length; i++) {
          if (mainCommercialShowDetailsList[i].bStatus == "E" &&
              (showCommercialDetailsList[markedAsErrorStateManager!.currentRowIdx!].rownumber) == mainCommercialShowDetailsList[i].rownumber) {
            mainCommercialShowDetailsList[i].bStatus = "B";
          }
        }
      } else {
        for (var i = 0; i < mainCommercialShowDetailsList.length; i++) {
          if (mainCommercialShowDetailsList[i].bStatus == "E") {
            for (var element in markedAsErrorStateManager!.currentSelectingRows) {
              if (mainCommercialShowDetailsList[i].rownumber == showCommercialDetailsList[element.sortIdx].rownumber) {
                mainCommercialShowDetailsList[i].bStatus = "B";
              }
            }
          }
        }
      }
      mainCommercialShowDetailsList.refresh();
      // updateAllTabs();
      showTabList();
    });
    // return mainCommercialShowDetailsList;
  }

  /// Not Completed
  saveSchedulingData() {
    if (selectedLocation == null) {
      LoadingDialog.showErrorDialog("Please select location");
    } else if (selectedChannel == null) {
      LoadingDialog.showErrorDialog("Please select location");
    } else if (selectedDate == null) {
      LoadingDialog.showErrorDialog("Please select date");
    } else if (mainCommercialShowDetailsList.where((o) => o.bStatus.toString() == 'F').toList().isNotEmpty) {
      LoadingDialog.showErrorDialog("Please clear all mismatch spots.");
    } else {
      LoadingDialog.call();
      try {
        var jsonRequest = {
          "locationCode": selectedLocation?.key.toString(),
          "channelCode": selectedChannel?.key.toString(),
          "scheduleDate": df1.format(DateFormat("dd-MM-yyyy").parse(date_.text)),
          "lstCommercialShuffling": mainCommercialShowDetailsList.map((e) => e.toJson()).toList(),
        };
        Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.SAVE_COMMERCIAL_DETAILS,
          fun: (dynamic data) {
            Get.back();
            if (data != null &&
                data is Map<String, dynamic> &&
                data['csSaveOutput'] != null &&
                data['csSaveOutput'].toString().contains("Record(s) saved successfully.")) {
              LoadingDialog.callDataSaved(msg: data['csSaveOutput'].toString());
            } else {
              LoadingDialog.showErrorDialog(data.toString());
            }
          },
          json: jsonRequest,
        );
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

  void exit() {
    clear();
    Get.find<HomeController>().selectChild1.value = null;
    Get.delete<CommercialController>();
  }
}

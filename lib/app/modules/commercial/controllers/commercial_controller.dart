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
import '../../../data/system_envirtoment.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/Utils.dart';
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
  int lastProgramSelectedIdx = 0;

  var locations = RxList<DropDownValue>();
  var channels = RxList<DropDownValue>([]);
  bool autoShuffle = true;

  DateTime? selectedDate = DateTime.now();
  DateFormat df = DateFormat("dd/MM/yyyy");
  DateFormat df1 = DateFormat("dd-MM-yyyy");
  DateFormat df2 = DateFormat("MM-dd-yyyy");
  DateFormat dfFinal = DateFormat("yyyy-MM-ddThh:mm:ss");
  PlutoGridStateManager? sm;

  List beams = [];
  List<PlutoRow> beamRows = [];
  List<PlutoRow> initRows = [];
  List<PlutoColumn> initColumn = [];
  List<PermissionModel>? formPermissions;
  List<CommercialProgramModel>? commercialProgramList = [];
  RxList<CommercialShowOnTabModel>? showCommercialDetailsList = <CommercialShowOnTabModel>[].obs;
  RxList<CommercialShowOnTabModel>? mainCommercialShowDetailsList = <CommercialShowOnTabModel>[].obs;

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
  TextEditingController refDateControl = TextEditingController(text: DateFormat("dd-MM-yyyy").format(DateTime.now()));

  @override
  void onInit() {
    super.onInit();
    getLocations();
  }

  var locationFN = FocusNode();
  void clear() {
    autoShuffle = false;
    insertAfter.value = true;
    programFpcTimeSelected = null;
    selectedProgram = null;
    selectedIndex.value = 0;
    mainSelectedIndex = null;
    date_.text = "";
    selectedChannel = null;
    selectedLocation = null;
    commercialSpots.value = "";
    commercialDuration.value = "";
    commercialProgramList?.clear();
    mainCommercialShowDetailsList?.clear();
    showCommercialDetailsList?.clear();

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
    locationFN.requestFocus();
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
    LoadingDialog.call();
    try {
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.COMMERCIAL_CHANNEL(locationCode),
          fun: (data) {
            Get.back();
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
            print("Json response is>>>" + jsonEncode(list));

            commercialProgramList?.clear();
            list['showDetails']["lstDailyFPC"].forEach((element) {
              commercialProgramList?.add(CommercialProgramModel.fromJson(element));
            });

            mainCommercialShowDetailsList?.clear();
            showCommercialDetailsList?.clear();
            list['showDetails']['lstCommercialShuffling'].asMap().forEach((index, element) {
              mainCommercialShowDetailsList?.add(CommercialShowOnTabModel.fromJson(element, index));
            });
            showCommercialDetailsList?.value = mainCommercialShowDetailsList!.where((o) => o.bStatus.toString() == 'B').toList();

            var cList = mainCommercialShowDetailsList!.where((o) => o.eventType.toString() == 'C' && o.bStatus.toString() == 'B').toList();
            commercialSpots.value = cList.length.toString();
            print("commercialSpots value is : ${commercialSpots.value}");

            double intTotalDuration = 0;
            for (int i = 0; i <= cList.length - 1; i++) {
              intTotalDuration = intTotalDuration + Utils.oldBMSConvertToSecondsValue(value: cList[i].duration!);
            }
            commercialDuration.value = Utils.convertToTimeFromDouble(value: intTotalDuration);
            print("commercialDuration value is : ${commercialDuration.value}");

            // commercialSpots.value =
            //     list['showDetails']['bindGridOutPut']['commercialSpots'] ?? "";
            // commercialDuration.value = list['showDetails']['bindGridOutPut']
            // ['commercialDuration'] ?? "";

            updateTab();
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
      /// FPC MISMATCH
      showCommercialDetailsList?.value = mainCommercialShowDetailsList!.where((o) => o.bStatus.toString() == 'F').toList();
    } else if (selectedIndex.value == 2) {
      /// MARK AS ERROR
      showCommercialDetailsList?.value = mainCommercialShowDetailsList!.where((o) => o.bStatus.toString() == 'E').toList();
    } else {
      /// SCHEDULING
      showCommercialDetailsList?.value = mainCommercialShowDetailsList!.where((o) => o.bStatus.toString() == 'B').toList();
      commercialSpots.value = showCommercialDetailsList?.value.where((element) => element.eventType == "E").toList().length.toString() ?? "";
      // commercialDuration
      double intTotalDuration = 0;
      for (int i = 0; i < (showCommercialDetailsList?.length ?? 0); i++) {
        intTotalDuration = intTotalDuration + Utils.oldBMSConvertToSecondsValue(value: showCommercialDetailsList![i].duration!);
      }
      commercialDuration.value = Utils.convertToTimeFromDouble(value: intTotalDuration);
    }
    showCommercialDetailsList?.refresh();
    updateTab();
    return showCommercialDetailsList?.value;
  }

  Future<dynamic> showSelectedProgramList(BuildContext context) async {
    if (selectedIndex.value == 1) {
      /// FPC MISMATCH
      showCommercialDetailsList?.value =
          mainCommercialShowDetailsList!.where((o) => o.fpcTime.toString() == programFpcTimeSelected && o.bStatus.toString() == 'F').toList();
    } else if (selectedIndex.value == 2) {
      /// MARK AS ERROR
      showCommercialDetailsList?.value =
          mainCommercialShowDetailsList!.where((o) => o.fpcTime.toString() == programFpcTimeSelected && o.bStatus.toString() == 'E').toList();
    } else {
      /// SCHEDULING
      showCommercialDetailsList?.value =
          mainCommercialShowDetailsList!.where((o) => o.fpcTime.toString() == programFpcTimeSelected && o.bStatus.toString() == 'B').toList();
    }
    showCommercialDetailsList?.refresh();
    print(programFpcTimeSelected.toString());
    updateTab();
    return showCommercialDetailsList?.value;
  }

  PlutoGridStateManager? fpcMisMatchSM;

  changeFPCOnClick() {
    if (fpcMisMatchSM?.currentRowIdx == null || fpcMisMatchSM?.currentRowIdx == null) {
      LoadingDialog.showErrorDialog("Please select row first");
    } else if ((fpcMisMatchSM!.currentSelectingRows.isEmpty)) {
      if (fpcMisMatchSM?.currentRowIdx == null) {
        print("got null");
      }
      for (var i = 0; i < mainCommercialShowDetailsList!.length; i++) {
        if (mainCommercialShowDetailsList![i].bStatus == "F" &&
            (showCommercialDetailsList![fpcMisMatchSM!.currentRowIdx!].rownumber) == mainCommercialShowDetailsList![i].rownumber) {
          mainCommercialShowDetailsList![i].bStatus = "B";
          mainCommercialShowDetailsList![i].fpcTime = programFpcTimeSelected;
          mainCommercialShowDetailsList![i].pProgramMaster = programCodeSelected;
          mainCommercialShowDetailsList![i].pDailyFPC = programCodeSelected;
          fpcMisMatchSM?.changeCellValue(
            fpcMisMatchSM!.getRowByIdx(fpcMisMatchSM!.currentRowIdx!)!.cells['fpcTime']!,
            programFpcTimeSelected,
            force: true,
            notify: true,
          );
          break;
        }
      }
    } else {
      for (var i = 0; i < mainCommercialShowDetailsList!.length; i++) {
        if (mainCommercialShowDetailsList![i].bStatus == "F") {
          for (var element in fpcMisMatchSM!.currentSelectingRows) {
            if (mainCommercialShowDetailsList![i].rownumber == showCommercialDetailsList![element.sortIdx].rownumber) {
              mainCommercialShowDetailsList![i].bStatus = "B";
              mainCommercialShowDetailsList![i].fpcTime = programFpcTimeSelected;
              mainCommercialShowDetailsList![i].pProgramMaster = programCodeSelected;
              mainCommercialShowDetailsList![i].pDailyFPC = programCodeSelected;
              fpcMisMatchSM?.changeCellValue(
                fpcMisMatchSM!.getRowByIdx(element.sortIdx)!.cells['fpcTime']!,
                programFpcTimeSelected,
                force: true,
                notify: true,
              );
            }
          }
        }
      }
    }

    // for (var i = 0; i < (mainCommercialShowDetailsList?.length ?? 0); i++) {
    //   if (mainCommercialShowDetailsList![i].bStatus == "F" &&
    //       (showCommercialDetailsList![mainSelectedIndex!].rownumber == mainCommercialShowDetailsList![i].rownumber)) {
    //     mainCommercialShowDetailsList?[i].bStatus = "B";
    //     mainCommercialShowDetailsList?[i].fpcTime = programFpcTimeSelected;
    //     mainCommercialShowDetailsList?[i].pProgramMaster = programCodeSelected;
    //     mainCommercialShowDetailsList?[i].pDailyFPC = programCodeSelected;
    //     break;
    //   }
    // }
    // fpcMisMatchSM?.changeCellValue(
    //   fpcMisMatchSM!.getRowByIdx(mainSelectedIndex)!.cells['fpcTime']!,
    //   programFpcTimeSelected,
    //   force: true,
    //   notify: true,
    // );
    fpcMisMatchSM?.setCurrentCell(fpcMisMatchSM?.getRowByIdx(mainSelectedIndex)?.cells['fpcTime'], mainSelectedIndex);

    /// BStatus == "B" &&
    /// FPCTime == programFpcTimeSelected &&
    /// PProgramMaster = programProgramCodeSelected &&
    /// PDailyFPC == programProgramCodeSelected
    // print(exportTapeCodeSelected.toString());
    // var list = mainCommercialShowDetailsList!.where((o) => o.bStatus.toString() == 'F').toList();
    // var target = list[mainSelectedIndex!];
    // print(mainSelectedIndex!.toString());
    // print("changeFPCOnClick : $target");
    // target.bStatus = 'B';
    // target.fpcTime = programFpcTimeSelected;
    // target.pProgramMaster = programCodeSelected;
    // target.pDailyFPC = programCodeSelected;
    // mainCommercialShowDetailsList?.refresh();
    // updateTab();
    // showTabList();

    return mainCommercialShowDetailsList;
  }

  misMatchOnClick() {
    LoadingDialog.recordExists("Want to change FPC of selected record(s)?", () async {
      if (fpcMisMatchSM?.currentRowIdx == null || fpcMisMatchSM?.currentRowIdx == null) {
        LoadingDialog.showErrorDialog("Please select row first");
      } else if ((fpcMisMatchSM!.currentSelectingRows.isEmpty)) {
        for (var i = 0; i < mainCommercialShowDetailsList!.length; i++) {
          if (mainCommercialShowDetailsList![i].bStatus == "F" &&
              (showCommercialDetailsList![fpcMisMatchSM!.currentRowIdx!].rownumber) == mainCommercialShowDetailsList![i].rownumber) {
            mainCommercialShowDetailsList![i].bStatus = "B";
            mainCommercialShowDetailsList![i].pProgramMaster = pDailyFPCSelected;
            break;
          }
        }
        fpcMisMatchSM?.removeCurrentRow();
      } else {
        for (var i = 0; i < mainCommercialShowDetailsList!.length; i++) {
          if (mainCommercialShowDetailsList![i].bStatus == "F") {
            for (var element in fpcMisMatchSM!.currentSelectingRows) {
              if (mainCommercialShowDetailsList![i].rownumber == showCommercialDetailsList![element.sortIdx].rownumber) {
                mainCommercialShowDetailsList![i].bStatus = "B";
                mainCommercialShowDetailsList![i].pProgramMaster = pDailyFPCSelected;
              }
            }
          }
        }
        fpcMisMatchSM?.removeRows((fpcMisMatchSM?.currentSelectingRows ?? []));
      }
    });

    // /// BStatus == "B" && PProgramMaster = PDailyFPC
    // print(exportTapeCodeSelected.toString());
    // // var target = mainCommercialShowDetailsList!
    // //     .firstWhere((item) => item.exportTapeCode == exportTapeCodeSelected);
    // var list = mainCommercialShowDetailsList!.where((o) => o.bStatus.toString() == 'F').toList();
    // var target = list[mainSelectedIndex!];
    // print("misMatchOnClick : $target");
    // target.bStatus = 'B';
    // target.pProgramMaster = pDailyFPCSelected;
    // mainCommercialShowDetailsList?.refresh();
    // updateTab();
    // showTabList();
  }

  markAsErrorOnClick() {
    LoadingDialog.recordExists("Want to mark as error to selected record(s)?", () {
      if (fpcMisMatchSM?.currentRowIdx == null || fpcMisMatchSM?.currentRowIdx == null) {
        LoadingDialog.showErrorDialog("Please select row first");
      } else if ((fpcMisMatchSM!.currentSelectingRows.isEmpty)) {
        for (var i = 0; i < mainCommercialShowDetailsList!.length; i++) {
          if (mainCommercialShowDetailsList![i].bStatus == "F" &&
              (showCommercialDetailsList![fpcMisMatchSM!.currentRowIdx!].rownumber) == mainCommercialShowDetailsList![i].rownumber) {
            mainCommercialShowDetailsList![i].bStatus = "E";
            break;
          }
        }
        fpcMisMatchSM?.removeCurrentRow();
      } else {
        for (var i = 0; i < mainCommercialShowDetailsList!.length; i++) {
          if (mainCommercialShowDetailsList![i].bStatus == "F") {
            for (var element in fpcMisMatchSM!.currentSelectingRows) {
              if (mainCommercialShowDetailsList![i].rownumber == showCommercialDetailsList![element.sortIdx].rownumber) {
                mainCommercialShowDetailsList![i].bStatus = "E";
              }
            }
          }
        }
        fpcMisMatchSM?.removeRows((fpcMisMatchSM?.currentSelectingRows ?? []));
      }
    });

    /// BStatus == "E"
    // print(exportTapeCodeSelected.toString());
    // var list = mainCommercialShowDetailsList!.where((o) => o.bStatus.toString() == 'F').toList();
    // var target = list[mainSelectedIndex!];
    // print("markAsErrorOnClick : $target");
    // target.bStatus = 'E';
    // mainCommercialShowDetailsList?.refresh();
    // updateTab();
    // showTabList();
    // return mainCommercialShowDetailsList;
  }

  var insertAfter = true.obs;
  PlutoGridStateManager? markedAsErrorSM;
  unMarkAsErrorOnClick() {
    LoadingDialog.recordExists("Want to un-mark selected record(s)?", () {
      if (markedAsErrorSM?.currentRowIdx == null || markedAsErrorSM?.currentRowIdx == null) {
        LoadingDialog.showErrorDialog("Please select row first");
      } else if ((markedAsErrorSM!.currentSelectingRows.isEmpty)) {
        for (var i = 0; i < mainCommercialShowDetailsList!.length; i++) {
          if (mainCommercialShowDetailsList![i].bStatus == "E" &&
              (showCommercialDetailsList![markedAsErrorSM!.currentRowIdx!].rownumber) == mainCommercialShowDetailsList![i].rownumber) {
            mainCommercialShowDetailsList![i].bStatus = "B";
            break;
          }
        }
        markedAsErrorSM?.removeCurrentRow();
      } else {
        for (var i = 0; i < mainCommercialShowDetailsList!.length; i++) {
          if (mainCommercialShowDetailsList![i].bStatus == "E") {
            for (var element in markedAsErrorSM!.currentSelectingRows) {
              if (mainCommercialShowDetailsList![i].rownumber == showCommercialDetailsList![element.sortIdx].rownumber) {
                mainCommercialShowDetailsList![i].bStatus = "B";
              }
            }
          }
        }
        markedAsErrorSM?.removeRows((markedAsErrorSM?.currentSelectingRows ?? []));
      }
    });
    // /// BStatus == "B"
    // print(exportTapeCodeSelected.toString());
    // // var target = mainCommercialShowDetailsList!
    // //     .firstWhere((item) => item.exportTapeCode == exportTapeCodeSelected);
    // var list = mainCommercialShowDetailsList!.where((o) => o.bStatus.toString() == 'E').toList();
    // var target = list[mainSelectedIndex!];
    // print("unMarkAsErrorOnClick : $target");
    // target.bStatus = 'B';
    // mainCommercialShowDetailsList?.refresh();
    // updateTab();
    // showTabList();
    // return mainCommercialShowDetailsList;
  }

  /// Not Completed
  saveSchedulingData() {
    if (selectedLocation == null) {
      Snack.callError("Please select location");
    } else if (selectedChannel == null) {
      Snack.callError("Please select location");
    } else if (mainCommercialShowDetailsList?.where((o) => o.bStatus.toString() == 'F').toList().isNotEmpty ?? true) {
      LoadingDialog.showErrorDialog("Please clear all mismatch spots.");
    } else {
      selectedDate = df1.parse(date_.text);
      try {
        var jsonRequest = {
          "locationCode": selectedLocation?.key.toString(),
          "channelCode": selectedChannel?.key.toString(),
          "scheduleDate": df1.format(selectedDate!),
          "lstCommercialShuffling": mainCommercialShowDetailsList?.map((e) => e.toJson()).toList(),
        };
        print("requestedToSaveData >>>" + jsonEncode(jsonRequest));
        Get.find<ConnectorControl>().POSTMETHOD(
            api: ApiFactory.SAVE_COMMERCIAL_DETAILS,
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

  void exit() {
    clear();
    Get.find<HomeController>().selectChild1.value = null;
    Get.delete<CommercialController>();
  }
}

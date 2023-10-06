import 'dart:convert';

import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/LoadingDialog.dart';
import '../../../../widgets/Snack.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../data/DropDownValue.dart';
import '../../../data/PermissionModel.dart';
import '../../../data/user_data_settings_model.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/Utils.dart';
import '../CommercialProgramModel.dart';
import '../CommercialShowOnTabModel.dart';

class CommercialController extends GetxController {
  /// Radio Button
  // int? tabIndex = 0;
  // int selectIndex = 0;
  int? selectedDDIndex;

  List<Map<String, double>>? userGridSetting1 = [];

  int selectedGroup = 0;
  double widthSize = 0.17;
  String? programFpcTimeSelected;
  int? mainSelectedIndex;
  String? programCodeSelected;
  String? exportTapeCodeSelected;
  String? pDailyFPCSelected;
  DropDownValue? selectedChannel;
  DropDownValue? selectedLocation;
  FocusNode insertAfterFN = FocusNode();
  var formPermissions = Rxn<PermissionModel?>();

  var selectedIndex = RxInt(0);
  RxBool isEnable = RxBool(true);
  var channelEnable = RxBool(true);
  // var locationEnable = RxBool(true);
  // var selectedChannels = RxList([]);
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
  UserDataSettings? userDataSettings;

  // List beams = [];
  // List<PlutoRow> beamRows = [];
  // List<PlutoRow> initRows = [];
  // List<PlutoColumn> initColumn = [];
  // List<PermissionModel>? formPermissions;
  List<CommercialProgramModel>? commercialProgramList = [];
  RxList<CommercialShowOnTabModel>? showCommercialDetailsList =
      <CommercialShowOnTabModel>[].obs;
  RxList<CommercialShowOnTabModel>? mainCommercialShowDetailsList =
      <CommercialShowOnTabModel>[].obs;

  /////////////Pluto Grid////////////
  // PlutoGridStateManager? stateManager;
  PlutoGridStateManager? gridStateManager;
  // PlutoGridStateManager? locChanStateManager;
  // PlutoGridStateManager? bmsReportStateManager;
  // PlutoGridMode selectedTabPlutoGridMode = PlutoGridMode.select;
  PlutoGridMode selectedProgramPlutoGridMode = PlutoGridMode.selectWithOneTap;
  late PlutoGridStateManager conflictReportStateManager;

  // List<SystemEnviroment>? channelList = [];
  // List<SystemEnviroment>? locationList = [];

  CommercialProgramModel? selectedProgram;
  CommercialShowOnTabModel? selectedShowOnTab;
  bool changeFpcTaped = false;
  bool canshowFilterList = false;

  TextEditingController date_ = TextEditingController();
  TextEditingController refDateControl = TextEditingController(
      text: DateFormat("dd-MM-yyyy").format(DateTime.now()));

  FocusNode autoShuffleFN = FocusNode();
  FocusNode saveFN = FocusNode();

  @override
  void onInit() {
    super.onInit();
    getLocations();
    fetchUserSetting1();
    autoShuffleFN.onKey = (node, event) {
      if (!event.isShiftPressed && event.isKeyPressed(LogicalKeyboardKey.tab)) {
        saveFN.requestFocus();
        return KeyEventResult.handled;
      } else {
        return KeyEventResult.ignored;
      }
    };

    saveFN.onKey = (node, event) {
      if (event.isShiftPressed && event.isKeyPressed(LogicalKeyboardKey.tab)) {
        autoShuffleFN.requestFocus();
        return KeyEventResult.handled;
      } else {
        return KeyEventResult.ignored;
      }
    };
  }

  @override
  void onReady() {
    super.onReady();
    formPermissions.value =
        Get.find<MainController>().permissionList!.lastWhere((element) {
      return element.appFormName == "frmCommercialScheduling";
    });

    print(formPermissions.toJson() ?? "null Form Permission");
  }

  var locationFN = FocusNode();
  int lastSelectedIdxSchd = 0;
  void clear() {
    lastSelectedIdxSchd = 0;
    changeFpcTaped = false;
    exportTapeCodeSelected = null;
    pDailyFPCSelected = null;
    selectedIndex.value = 0;
    isEnable.value = true;
    programCodeSelected = null;
    selectedDDIndex = null;
    lastProgramSelectedIdx = 0;
    canshowFilterList = false;
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

    // locationEnable.value = true;
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

  beforeCallDraggble(List<PlutoRow> allList, indexToMove,
      List<PlutoRow> rowMoved, Function function) {
    if (rowMoved.isNotEmpty &&
        rowMoved.first.cells['eventType']?.value.toString().trim() == 'S') {
      gridStateManager?.setCurrentCell(
          rowMoved.first.cells['eventType'], rowMoved.first.sortIdx);
      LoadingDialog.showErrorDialog("You cannot move selected segment");
    } else {
      // var tempList = <CommercialShowOnTabModel?>[];
      // for (var i = 0; i < (mainCommercialShowDetailsList?.length ?? 0); i++) {
      //   if (mainCommercialShowDetailsList?[i].bStatus == "B") {
      //     tempList.add(mainCommercialShowDetailsList?[i]);
      //   }
      // }
      // var eventType = tempList[indexToMove]?.eventType;
      // showCommercialDetailsList?[indexToMove].eventType = "S";
      // commercialProgramList?.insert(indexToMove, commercialProgramList![2]);
      // gridStateManager?.insertRows(rowMoved.first.sortIdx, rowMoved);

      function();
    }
  }

  getChannel(locationCode) {
    LoadingDialog.call();
    try {
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.COMMERCIAL_CHANNEL(locationCode),
          fun: (data) {
            Get.back();
            if (data["locationSelect"] is List) {
              selectedChannel = null;
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
    // print("Selected Channel is : ${selectedChannel?.key ?? ""}");
    if (selectedLocation == null) {
      Snack.callError("Please select Location");
    } else if (selectedChannel == null) {
      Snack.callError("Please select Channel");
    } else {
      canshowFilterList = false;
      LoadingDialog.call();
      selectedDate = df1.parse(date_.text);
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.COMMERCIAL_SHOW_FPC_SCHEDULLING_DETAILS(
              selectedLocation?.key ?? "",
              selectedChannel?.key ?? "",
              df1.format(selectedDate!)),
          fun: (dynamic list) {
            var map = {};
            map["loc"] = selectedLocation;
            map["ch"] = selectedChannel;
            map["date"] = date_.text;
            map["auto"] = autoShuffle;
            clear();
            selectedLocation = map['loc'];
            selectedChannel = map['ch'];
            date_.text = map['date'];
            autoShuffle = map['auto'];

            // print("Json response is>>>" + jsonEncode(list));
            lastSelectedIdxSchd = 0;
            selectedDDIndex = 0;
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
            // showCommercialDetailsList?.value = mainCommercialShowDetailsList!.where((o) => o.bStatus.toString() == 'B').toList();
            showTabList();
            // var cList = mainCommercialShowDetailsList!.where((o) => o.eventType.toString() == 'C' && o.bStatus.toString() == 'B').toList();
            // commercialSpots.value = cList.length.toString();
            // print("commercialSpots value is : ${commercialSpots.value}");

            // double intTotalDuration = 0;
            // for (int i = 0; i <= cList.length - 1; i++) {
            //   if ((cList[i].eventType?.trim()) == "C") {
            //     intTotalDuration = intTotalDuration + Utils.oldBMSConvertToSecondsValue(value: cList[i].duration!);
            //   }
            // }
            // commercialDuration.value = Utils.convertToTimeFromDouble(value: intTotalDuration);
            // print("commercialDuration value is : ${commercialDuration.value}");

            // commercialSpots.value =
            //     list['showDetails']['bindGridOutPut']['commercialSpots'] ?? "";
            // commercialDuration.value = list['showDetails']['bindGridOutPut']
            // ['commercialDuration'] ?? "";

            updateTab();
            Get.back();

            Future.delayed(Duration(seconds: 1)).then((value) {
              insertAfterFN.requestFocus();
            });
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

  fetchUserSetting1() async {
    userDataSettings = await Get.find<HomeController>().fetchUserSetting2();
  }

  Future<dynamic> showTabList() async {
    if (!canshowFilterList) {
      showCommercialDetailsList?.clear();
      if (selectedIndex.value == 1) {
        /// FPC MISMATCH
        showCommercialDetailsList?.value = mainCommercialShowDetailsList!
            .where((o) => o.bStatus.toString() == 'F')
            .toList();
      } else if (selectedIndex.value == 2) {
        /// MARK AS ERROR
        showCommercialDetailsList?.value = mainCommercialShowDetailsList!
            .where((o) => o.bStatus.toString() == 'E')
            .toList();
      } else {
        /// SCHEDULING
        // showCommercialDetailsList?.value = mainCommercialShowDetailsList!.where((o) => o.bStatus.toString() == 'B').toList();
        String? isItrated;
        showCommercialDetailsList?.value = [];
        for (var i = 0; i < (mainCommercialShowDetailsList?.length ?? 0); i++) {
          if (mainCommercialShowDetailsList?[i].bStatus == "B") {
            var temp = mainCommercialShowDetailsList![i];
            if (isItrated == null || isItrated != temp.fpcTime2) {
              isItrated = temp.fpcTime2;
            } else {
              temp.fpcTime2 = "";
              temp.canChangeFpc = true;
            }
            showCommercialDetailsList!.add(temp);
          }
        }
        calculateSpotAndDuration();
      }
    } else {
      showSelectedProgramList();
    }
    changeFpcTaped = false;
    // showCommercialDetailsList?.refresh();
    updateTab();
    // return showCommercialDetailsList?.value;
  }

  void calculateSpotAndDuration() {
    commercialSpots.value = showCommercialDetailsList
            ?.where((element) => element.eventType?.trim() == "C")
            .toList()
            .length
            .toString() ??
        "0";
    // commercialDuration
    double intTotalDuration = 0;
    for (int i = 0; i < (showCommercialDetailsList?.length ?? 0); i++) {
      if (showCommercialDetailsList?[i].eventType?.trim() == "C") {
        intTotalDuration = intTotalDuration +
            Utils.oldBMSConvertToSecondsValue(
                value: showCommercialDetailsList![i].duration!);
      }
    }
    commercialDuration.value =
        Utils.convertToTimeFromDouble(value: intTotalDuration);
    // commercialSpots.refresh();
    // commercialDuration.refresh();
  }

  Future<void> showSelectedProgramList() async {
    if (selectedIndex.value == 1) {
      /// FPC MISMATCH
      showCommercialDetailsList?.value = mainCommercialShowDetailsList!
          .where((o) =>
              o.fpcTime.toString() == programFpcTimeSelected &&
              o.bStatus.toString() == 'F')
          .toList();
    } else if (selectedIndex.value == 2) {
      /// MARK AS ERROR
      showCommercialDetailsList?.value = mainCommercialShowDetailsList!
          .where((o) =>
              o.fpcTime.toString() == programFpcTimeSelected &&
              o.bStatus.toString() == 'E')
          .toList();
    } else {
      /// SCHEDULING
      // showCommercialDetailsList?.value =
      //     mainCommercialShowDetailsList!.where((o) => o.fpcTime.toString() == programFpcTimeSelected && o.bStatus.toString() == 'B').toList();
      String? isItrated;
      showCommercialDetailsList?.value = [];
      for (var i = 0; i < (mainCommercialShowDetailsList?.length ?? 0); i++) {
        if (mainCommercialShowDetailsList?[i].bStatus == "B" &&
            mainCommercialShowDetailsList?[i].fpcTime ==
                programFpcTimeSelected) {
          var temp = mainCommercialShowDetailsList![i];
          if (isItrated == null || isItrated != temp.fpcTime2) {
            isItrated = temp.fpcTime2;
          } else {
            temp.fpcTime2 = "";
            temp.canChangeFpc = true;
          }
          showCommercialDetailsList!.add(temp);
        }
      }
    }
    // showCommercialDetailsList?.refresh();
    // print(programFpcTimeSelected.toString());
    // update(["programTable"]);
    update(["schedulingTable"]);
    update(["fpcMismatchTable"]);
    update(["misMatchTable"]);
    calculateSpotAndDuration();
    // return showCommercialDetailsList?.value;
  }

  PlutoGridStateManager? fpcMisMatchSM;

  changeFPCOnClick() {
    if (fpcMisMatchSM?.currentRowIdx == null ||
        fpcMisMatchSM?.currentRowIdx == null) {
      LoadingDialog.showErrorDialog("Please select row first");
    } else if ((fpcMisMatchSM!.currentSelectingRows.isEmpty)) {
      changeFpcTaped = true;
      if (fpcMisMatchSM?.currentRowIdx == null) {
        print("got null");
      }
      mainSelectedIndex = fpcMisMatchSM?.currentRowIdx ?? 0;
      for (var i = 0; i < mainCommercialShowDetailsList!.length; i++) {
        if (mainCommercialShowDetailsList![i].bStatus == "F" &&
            (showCommercialDetailsList![fpcMisMatchSM!.currentRowIdx!]
                    .rownumber) ==
                mainCommercialShowDetailsList![i].rownumber) {
          mainCommercialShowDetailsList![i].bStatus = "B";
          mainCommercialShowDetailsList![i].fpcTime = programFpcTimeSelected;
          mainCommercialShowDetailsList![i].pProgramMaster =
              programCodeSelected;
          mainCommercialShowDetailsList![i].pDailyFPC = programCodeSelected;
          fpcMisMatchSM?.changeCellValue(
            fpcMisMatchSM!
                .getRowByIdx(fpcMisMatchSM!.currentRowIdx!)!
                .cells['fpcTime']!,
            programFpcTimeSelected,
            force: true,
            notify: true,
          );
          break;
        }
      }
    } else {
      changeFpcTaped = true;
      for (var i = 0; i < mainCommercialShowDetailsList!.length; i++) {
        if (mainCommercialShowDetailsList![i].bStatus == "F") {
          for (var element in fpcMisMatchSM!.currentSelectingRows) {
            if (mainCommercialShowDetailsList![i].rownumber ==
                showCommercialDetailsList![element.sortIdx].rownumber) {
              mainCommercialShowDetailsList![i].bStatus = "B";
              mainCommercialShowDetailsList![i].fpcTime =
                  programFpcTimeSelected;
              mainCommercialShowDetailsList![i].pProgramMaster =
                  programCodeSelected;
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
    fpcMisMatchSM?.setCurrentCell(
        fpcMisMatchSM?.getRowByIdx(mainSelectedIndex)?.cells['fpcTime'],
        mainSelectedIndex);

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
    LoadingDialog.recordExists("Want to change FPC of selected record(s)?",
        () async {
      if (fpcMisMatchSM?.currentRowIdx == null ||
          fpcMisMatchSM?.currentRowIdx == null) {
        LoadingDialog.showErrorDialog("Please select row first");
      } else if ((fpcMisMatchSM!.currentSelectingRows.isEmpty)) {
        for (var i = 0; i < mainCommercialShowDetailsList!.length; i++) {
          if (mainCommercialShowDetailsList![i].bStatus == "F" &&
              (showCommercialDetailsList![fpcMisMatchSM!.currentRowIdx!]
                      .rownumber) ==
                  mainCommercialShowDetailsList![i].rownumber) {
            mainCommercialShowDetailsList![i].bStatus = "B";
            mainCommercialShowDetailsList![i].pProgramMaster =
                pDailyFPCSelected;
            break;
          }
        }
        fpcMisMatchSM?.removeCurrentRow();
      } else {
        for (var i = 0; i < mainCommercialShowDetailsList!.length; i++) {
          if (mainCommercialShowDetailsList![i].bStatus == "F") {
            for (var element in fpcMisMatchSM!.currentSelectingRows) {
              if (mainCommercialShowDetailsList![i].rownumber ==
                  showCommercialDetailsList![element.sortIdx].rownumber) {
                mainCommercialShowDetailsList![i].bStatus = "B";
                mainCommercialShowDetailsList![i].pProgramMaster =
                    pDailyFPCSelected;
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
    LoadingDialog.recordExists("Want to mark as error to selected record(s)?",
        () {
      if (fpcMisMatchSM?.currentRowIdx == null ||
          fpcMisMatchSM?.currentRowIdx == null) {
        LoadingDialog.showErrorDialog("Please select row first");
      } else if ((fpcMisMatchSM!.currentSelectingRows.isEmpty)) {
        for (var i = 0; i < mainCommercialShowDetailsList!.length; i++) {
          if (mainCommercialShowDetailsList![i].bStatus == "F" &&
              (showCommercialDetailsList![fpcMisMatchSM!.currentRowIdx!]
                      .rownumber) ==
                  mainCommercialShowDetailsList![i].rownumber) {
            mainCommercialShowDetailsList![i].bStatus = "E";
            break;
          }
        }
        fpcMisMatchSM?.removeCurrentRow();
      } else {
        for (var i = 0; i < mainCommercialShowDetailsList!.length; i++) {
          if (mainCommercialShowDetailsList![i].bStatus == "F") {
            for (var element in fpcMisMatchSM!.currentSelectingRows) {
              if (mainCommercialShowDetailsList![i].rownumber ==
                  showCommercialDetailsList![element.sortIdx].rownumber) {
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
      if (markedAsErrorSM?.currentRowIdx == null ||
          markedAsErrorSM?.currentRowIdx == null) {
        LoadingDialog.showErrorDialog("Please select row first");
      } else if ((markedAsErrorSM!.currentSelectingRows.isEmpty)) {
        for (var i = 0; i < mainCommercialShowDetailsList!.length; i++) {
          if (mainCommercialShowDetailsList![i].bStatus == "E" &&
              (showCommercialDetailsList![markedAsErrorSM!.currentRowIdx!]
                      .rownumber) ==
                  mainCommercialShowDetailsList![i].rownumber) {
            mainCommercialShowDetailsList![i].bStatus = "B";
            break;
          }
        }
        markedAsErrorSM?.removeCurrentRow();
      } else {
        for (var i = 0; i < mainCommercialShowDetailsList!.length; i++) {
          if (mainCommercialShowDetailsList![i].bStatus == "E") {
            for (var element in markedAsErrorSM!.currentSelectingRows) {
              if (mainCommercialShowDetailsList![i].rownumber ==
                  showCommercialDetailsList![element.sortIdx].rownumber) {
                mainCommercialShowDetailsList![i].bStatus = "B";
              }
            }
          }
        }
        markedAsErrorSM
            ?.removeRows((markedAsErrorSM?.currentSelectingRows ?? []));
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

  saveSchedulingData() {
    if (selectedLocation == null) {
      Snack.callError("Please select location");
    } else if (selectedChannel == null) {
      Snack.callError("Please select location");
    } else if (mainCommercialShowDetailsList
            ?.where((o) => o.bStatus.toString() == 'F')
            .toList()
            .isNotEmpty ??
        true) {
      LoadingDialog.showErrorDialog("Please clear all mismatch spots.");
    } else {
      LoadingDialog.call();
      selectedDate = df1.parse(date_.text);
      try {
        var jsonRequest = {
          "locationCode": selectedLocation?.key.toString(),
          "channelCode": selectedChannel?.key.toString(),
          "scheduleDate": df1.format(selectedDate!),
          "lstCommercialShuffling":
              mainCommercialShowDetailsList?.map((e) => e.toJson()).toList(),
        };

        Get.find<ConnectorControl>().POSTMETHOD(
            api: ApiFactory.SAVE_COMMERCIAL_DETAILS,
            fun: (dynamic data) {
              Get.back();
              if (data != null &&
                  data is Map<String, dynamic> &&
                  data['csSaveOutput'] != null) {
                LoadingDialog.callDataSaved(
                    msg: data['csSaveOutput'].toString());
              } else {
                LoadingDialog.showErrorDialog(data.toString());
              }
            },
            json: jsonRequest);
      } catch (e) {
        LoadingDialog.callErrorMessage1(msg: "Failed To Save Data");
      }
    }
  }

  Color colorSort(String eventType) {
    Color color = Colors.white;

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
        color = Colors.white;
    }
    return color;
  }

  void exit() {
    clear();
    Get.find<HomeController>().selectChild1.value = null;
    Get.delete<CommercialController>();
  }
}

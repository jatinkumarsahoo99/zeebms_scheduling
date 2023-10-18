import 'dart:convert';

import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';

import '../../../../widgets/LoadingDialog.dart';
import '../../../../widgets/Snack.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../data/system_envirtoment.dart';
import '../../../data/user_data_settings_model.dart';
import '../../../providers/ApiFactory.dart';
import '../FPCMisMatchModel.dart';
import '../FPCMisMatchProgramModel.dart';

class FpcMismatchController extends GetxController {
  // DataTableSource dataTable = FPCMismatchTable();
  // DataTableSource programTable = FPCMismatchProgramTable();
  RxList<DropDownValue>? channelList = RxList([]);
  RxList<DropDownValue>? locationList = RxList([]);
  List<FPCMisMatchModel>? dataList = [];
  List<FPCMisMatchProgramModel>? programList = [];

  DateTime now = DateTime.now();
  DateTime? selectedDate = DateTime.now();
  DateFormat df = DateFormat("dd/MM/yyyy");
  DateFormat df1 = DateFormat("dd-MM-yyyy");
  DateFormat df2 = DateFormat("dd-MMM-yyyy");
  DropDownValue? selectedChannel;
  DropDownValue? selectedLocation;
  FPCMisMatchProgramModel? selectedProgram;
  TextEditingController date_ = TextEditingController();
  int? selectIndex = 0;

  double widthSize = 0.12;
  PlutoGridStateManager? stateManager, programTable;

  SelectButton? selectButton;
  RxBool hideKeysAllowed = RxBool(false);
  FocusNode locationFocus = FocusNode();

  @override
  void onInit() {
    // fetchChannel();
    fetchLocation();
    date_.text = df1.format(now);
    super.onInit();
  }

  UserDataSettings? userDataSettings;

  @override
  void onReady() {
    super.onReady();
    fetchUserSetting1();
  }

  fetchUserSetting1() async {
    userDataSettings = await Get.find<HomeController>().fetchUserSetting2();
    update(['fpcMaster', 'programTable']);
  }

  fetchLocation() {
    Get.find<ConnectorControl>().GETMETHODCALL(
      // api: "https://jsonkeeper.com/b/PPZC",
      api: ApiFactory.FPC_MISMATCH_LOCATION,
      fun: (List list) {
        list.forEach((element) {
          locationList?.add(new DropDownValue(
              key: element["locationCode"], value: element["locationName"]));
        });
        update(["initialData"]);
      },
    );
  }

  fetchChannel() {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
      api: ApiFactory.FPC_MISMATCH_CHANNEL(
          Get.find<MainController>().user?.logincode ?? "",
          selectedLocation?.key ?? ""),
      fun: (List list) {
        Get.back();
        list.forEach((element) {
          channelList?.add(new DropDownValue(
              key: element["channelCode"], value: element["channelName"]));
        });
        locationFocus.requestFocus();
        update(["initialData"]);
      },
    );
  }

  fetchMismatch() {
    print(">>Key is>>>>>" + (selectedChannel?.key ?? ""));
    if (selectedLocation == null) {
      Snack.callError("Please select location");
    } else if (selectedChannel == null) {
      Snack.callError("Please select location");
    } else if (selectedDate == null) {
      Snack.callError("Please select date");
    } else {
      // LoadingDialog.call();
      selectButton = SelectButton.DisplayMismatch;
      update(["button_data"]);
      selectedDate = df1.parse(date_.text);
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.FPC_MISMATCH(selectedLocation?.key ?? "",
              selectedChannel?.key ?? "", df2.format(selectedDate!)),
          // api: "https://api-bms-dev.azurewebsites.net/api/FpcMismatch/BindFPCMismatchGrid/ZAZEE00001,ZAZEE00001,01-09-2022",
          fun: (List list) {
            // Get.back();
            dataList?.clear();
            list.forEach((element) {
              dataList?.add(new FPCMisMatchModel.fromJson(element));
            });
            // dataTable.notifyListeners();
            update(["fpcMaster"]);
          },
          failed: (val) {
            Snack.callError(val.toString());
          });
    }
  }

  fetchMismatchError() {
    if (selectedLocation == null) {
      Snack.callError("Please select location");
    } else if (selectedChannel == null) {
      Snack.callError("Please select location");
    } else if (selectedDate == null) {
      Snack.callError("Please select date");
    } else {
      // LoadingDialog.call();
      selectButton = SelectButton.DisplayError;
      selectedDate = df1.parse(date_.text);
      update(["button_data"]);
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.FPC_MISMATCH_ERROR(selectedLocation?.key ?? "",
              selectedChannel?.key ?? "", df2.format(selectedDate!)),
          fun: (List list) {
            // Get.back();
            dataList?.clear();
            list.forEach((element) {
              dataList?.add(new FPCMisMatchModel.fromJson(element));
            });
            // dataTable.notifyListeners();
            update(["fpcMaster"]);
          },
          failed: (val) {
            Snack.callError(val.toString());
          });
    }
  }

  fetchMismatchAll() {
    if (selectedLocation == null) {
      Snack.callError("Please select location");
    } else if (selectedChannel == null) {
      Snack.callError("Please select location");
    } else if (selectedDate == null) {
      Snack.callError("Please select date");
    } else {
      // LoadingDialog.call();
      selectButton = SelectButton.DisplayAll;
      selectedDate = df1.parse(date_.text);
      update(["button_data"]);
      Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.FPC_MISMATCH_ALL(selectedLocation?.key ?? "",
            selectedChannel?.key ?? "", df2.format(selectedDate!)),
        fun: (List list) {
          // Get.back();
          dataList?.clear();
          list.forEach((element) {
            dataList?.add(new FPCMisMatchModel.fromJson(element));
          });
          // dataTable.notifyListeners();
          update(["fpcMaster"]);
        },
      );
    }
  }

  fetchProgram() {
    if (selectedLocation == null) {
      Snack.callError("Please select location");
    } else if (selectedChannel == null) {
      Snack.callError("Please select location");
    } else if (selectedDate == "") {
      Snack.callError("Please select date");
    } else {
      LoadingDialog.call();
      selectedDate = df1.parse(date_.text);
      Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.FPC_MISMATCH_PROGRAM(selectedLocation?.key ?? "",
            selectedChannel?.key ?? "", df2.format(selectedDate!)),
        fun: (List list) {
          Get.back();
          programList?.clear();
          list.forEach((element) {
            programList?.add(FPCMisMatchProgramModel.fromJson(element));
          });
          selectedProgram = programList![0];
          // programTable.notifyListeners();
          update(["programTable"]);
        },
        failed: (val) {
          Get.back();
        },
      );
    }
  }

  saveFPCMistmatch() {
    if (selectedLocation == null) {
      Snack.callError("Please select location");
    } else if (selectedChannel == null) {
      Snack.callError("Please select channel");
    } else if ((dataList?.isEmpty)!) {
      Snack.callError("Table should not be blank");
    } else if (!(dataList?.any((element) => (element.selectItem)!))!) {
      Snack.callError("Please select row");
    } else if (selectedProgram == null) {
      Snack.callError("Please select program");
    } else {
      FPCMisMatchModel? modelData =
          dataList?.firstWhere((element) => (element.selectItem)!);

      if (modelData?.fpcTime != selectedProgram?.startTime) {
        LoadingDialog.recordExists(
            "Booked FPC Time doesn't matches with Scheduled FPC Time. Want to continue?",
            () {
          updateRecord();
        }, deleteCancel: "No", deleteTitle: "Yes");
      } else {
        updateRecord();
      }
    }
  }

  updateRecord() {
    List<FPCMisMatchModel> postMapList =
        (dataList?.where((element) => (element.selectItem == true)).toList())!;
    var postMap1 = postMapList
        .map((e) => e.toSaveJson(
            selectedLocation?.key ?? "",
            selectedChannel?.key ?? "",
            selectedProgram?.programCode ?? "",
            selectedProgram?.startTime ?? ""))
        .toList();

    var postData = {"data": postMap1};
    print("????" + jsonEncode(postData));

    LoadingDialog.call();
    Get.find<ConnectorControl>().POSTMETHOD(
      api: ApiFactory.FPC_MISMATCH_SAVE,
      json: postMap1,
      fun: (dynamic data) {
        Get.back();
        if (data.toString().toLowerCase() == "success") {
          // LoadingDialog.callDataSavedMessage("Record Saved successfully");
          LoadingDialog.callDataSaved(callback: () {
            checkDataAndFetch();
          });
        } else {
          Snack.callError("Something went wrong");
        }
      },
    );
  }

  saveMarkError() {
    if (selectedLocation == null) {
      Snack.callError("Please select location");
    } else if (selectedChannel == null) {
      Snack.callError("Please select location");
    } else if ((dataList?.isEmpty)!) {
      // Snack.callError("Spots Errors successfully.");
      Snack.callError("Table should not be blank");
    } else if (!(dataList?.any((element) => (element.selectItem)!))!) {
      Snack.callError("Please select row");
    } else {
      // var postMap = [
      //   {
      //     "locationCode": "string",
      //     "channelCode": "string",
      //     "bookingNumber": "string",
      //     "bookingDetailCode": "string"
      //   }
      // ];
      List<FPCMisMatchModel> postMapList = (dataList
          ?.where((element) => (element.selectItem == true))
          .toList())!;
      var postMap1 = postMapList
          .map((e) => e.toMarkErrorJson(
              selectedLocation?.key ?? "", selectedChannel?.key ?? ""))
          .toList();
      // var data={
      //   "moDta":postMapList.map((e) => e.toMarkErrorJson(selectedLocation?.key??"", selectedChannel?.key??"")).toList()
      // };
      // print("value data Print>>"+jsonEncode(data));

      LoadingDialog.call();
      Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.FPC_MISMATCH_MARK_ERROR,
        json: postMap1,
        fun: (dynamic value) {
          Get.back();
          if (value.toString().toLowerCase() == "success") {
            LoadingDialog.callDataSavedMessage("Spots Errors successfully.",
                callback: () {
              checkDataAndFetch();
            });
          } else {
            Snack.callError("Something went wrong");
          }
        },
      );
    }
  }

  checkDataAndFetch() {
    switch (selectButton) {
      case SelectButton.DisplayAll:
        fetchMismatchAll();
        break;
      case SelectButton.DisplayMismatch:
        fetchMismatch();
        break;
      case SelectButton.DisplayError:
        fetchMismatchError();
        break;
    }
  }

  saveUndoMarkError() {
    if (selectedLocation == null) {
      Snack.callError("Please select location");
    } else if (selectedChannel == null) {
      Snack.callError("Please select location");
    } else if ((dataList?.isEmpty)!) {
      // Snack.callError("Spots Errors Undo successfully.");
      Snack.callError("Table should not be blank");
    } else if (!(dataList?.any((element) => (element.selectItem)!))!) {
      Snack.callError("Please select row");
    } else {
      List<FPCMisMatchModel> postMapList = (dataList
          ?.where((element) => (element.selectItem == true))
          .toList())!;
      var postMap1 = postMapList
          .map((e) => e.toMarkErrorJson(
              selectedLocation?.key ?? "", selectedChannel?.key ?? ""))
          .toList();

      LoadingDialog.call();
      Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.FPC_MISMATCH_MARK_UNDO_ERROR,
        json: postMap1,
        fun: (dynamic value) {
          Get.back();
          if (value.toString().toLowerCase() == "success") {
            LoadingDialog.callDataSavedMessage(
                "Spots Errors Undo successfully.", callback: () {
              checkDataAndFetch();
            });
          } else {
            Snack.callError("Something went wrong");
          }
        },
      );
    }
  }

  fetchData() {
    stateManager?.onRowChecked;
  }

  void clear() {
    // this.refresh();
    dataList?.clear();
    programList?.clear();
    // dataTable.notifyListeners();
    update(["fpcMaster"]);
    // programTable.notifyListeners();
    update(["programTable"]);
  }

  void selectCurrentSelectFpcTime(bool select) {
    if (stateManager == null || stateManager?.currentRow == null) return;
    stateManager?.rows.forEach((element) {
      if (element.cells["fpcTime"]?.value ==
          stateManager?.currentRow?.cells["fpcTime"]?.value) {
        stateManager?.setRowChecked(element, select);
        dataList![element.sortIdx].selectItem = select;
      }
    });
    stateManager?.notifyListeners();
  }
}

enum SelectButton {
  DisplayMismatch,
  DisplayError,
  DisplayAll,
}

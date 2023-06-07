import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';

import '../../../../widgets/CustomSearchDropDown/src/selection_widget.dart';
import '../../../../widgets/LoadingDialog.dart';
import '../../../../widgets/Snack.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../data/PermissionModel.dart';
import '../../../data/system_envirtoment.dart';
import '../../../providers/ApiFactory.dart';
import '../../../data/DropDownValue.dart';
import '../SalesAuditNotTelecastModel.dart';

class SalesAuditNotTelecastReportController extends GetxController {
  var locations = RxList<DropDownValue>();
  List<SystemEnviroment>? progTypeList = [];
  List<SystemEnviroment>? totalProgTypeList = [];
  List<SystemEnviroment>? progNameList = [];
  List<int>? selectedProgTypeIndexes = [];
  List<int>? selectedProgramIndexes = [];
  List<SalesAuditNotTelecastModel>? programTapeList = [];

  TextEditingController episodeFrom_ = TextEditingController();
  TextEditingController episodeTo_ = TextEditingController();
  TextEditingController frmDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController search_ = TextEditingController();
  TextEditingController searchProgType_ = TextEditingController();

  var debouncer = Debouncer(delay: Duration(milliseconds: 1500));
  bool isSelect = false;

  ScrollController scrollController = ScrollController();
  List dataList = [];
  FocusNode progType = FocusNode();
  int? selectIndex;

  RxBool isEnable = RxBool(true);
  //input controllers
  DropDownValue? selectLocation;
  RxString selectValue=RxString("");


  @override
  void onInit() {
    fetchProgramType();
    // fetchProgram();
    progType.addListener(() {
      if (!progType.hasFocus) {
        if (searchProgType_.text == "") {
          // progTypeList=null;
          selectIndex = null;
        } else {
          selectIndex = progTypeList?.indexWhere((element) {
            print("Data>>>" +
                element.value.toString().toLowerCase() +
                "<Matched Data>" +
                searchProgType_.text.toLowerCase());
            return element.value.toString().toLowerCase() ==
                searchProgType_.text.toLowerCase();
            // return element.value.toString().toLowerCase().contains(searchProgType_.text.toLowerCase());
          });

          if (selectIndex == null || selectIndex == -1) {
            selectIndex = progTypeList?.indexWhere((element) {
              print("Data>>>" +
                  element.value.toString().toLowerCase() +
                  "<Matched Data>" +
                  searchProgType_.text.toLowerCase());
              // return element.value.toString().toLowerCase()==searchProgType_.text.toLowerCase();
              return element.value
                  .toString()
                  .toLowerCase()
                  .contains(searchProgType_.text.toLowerCase());
            });
          }
          // scrollController.
          // print("Index is>>>"+selectIndex.toString());
          _animateToIndex(selectIndex!);
        }
        // print("Program type list>>>>"+progTypeList.toString());
        update(["updateTable"]);
      }
    });
    super.onInit();
  }

  fetchProgramType() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.FPC_MISMATCH_LOCATION,
        // "https://jsonkeeper.com/b/D537"
        fun: (List list) {
          if (list != null && list.isNotEmpty) {
            progTypeList?.clear();
            totalProgTypeList?.clear();
            list.forEach((element) {
              progTypeList?.add(new SystemEnviroment(
                  key: element["programtypecode"],
                  value: element["programtypename"]));
            });
            totalProgTypeList = progTypeList;
          }
          update(["updateTable"]);
        });
  }

  fetchProgram(String value) {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.FPC_MISMATCH_LOCATION,
        // "https://jsonkeeper.com/b/D537"
        fun: (List list) {
          Get.back();
          if (list != null && list.isNotEmpty) {
            progNameList?.clear();
            list.forEach((element) {
              progNameList?.add(new SystemEnviroment(
                  key: element["programcode"], value: element["programname"]));
            });
          } else {
            progNameList?.clear();
          }
          update(["updateTable1"]);
        });
  }

  fetchGenerate() {
    if ((selectedProgTypeIndexes?.isEmpty)!) {
      Snack.callError("Please select program type");
    } else if (episodeFrom_.text == "") {
      Snack.callError("Please select episode from");
    } else if (episodeTo_.text == "") {
      Snack.callError("Please select episode to");
    } else {
      List<SystemEnviroment> selected = [];
      for (int i = 0; i < (progTypeList?.length)!; i++) {
        if ((selectedProgTypeIndexes?.contains(i))!) {
          selected.add(progTypeList![i]);
        }
      }
      LoadingDialog.call();
      var postMap = {
        "Userid": Get.find<MainController>().user?.logincode ?? "",
        "lstprogramTapeDetails": selected.map((e) => e.toTapeJson()).toList(),
        "EpFrom": episodeFrom_.text,
        "EpTo": episodeTo_.text
      };
      // print("LOG VALUE>>" + jsonEncode(postMap));
      Get.find<ConnectorControl>().POSTMETHOD(
        // api: ApiFactory.MOVIE_EVENT_CHANNEL_MASTER + (selectedLocation?.key)!+",${(selectedChannel?.key)!},${df1.format(fromDt)},${df1.format(toDt)}",
          api: ApiFactory.FPC_MISMATCH_LOCATION,
          fun: (List list) {
            Get.back();
            if (list.isNotEmpty) {
              dataList = list;
              list.forEach((element) {
                programTapeList?.add(new SalesAuditNotTelecastModel.fromJson(element));
              });
              // movieLiveEventTable.notifyListeners();
              update(["listUpdate"]);
            }
          },
          json: postMap);
    }
  }

  void _animateToIndex(int index) {
    scrollController.animateTo(
      index * 30,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
  }

  void clear() {
    // this.refresh();
    // movieEventList?.clear();
    // movieLiveEventTable.notifyListeners();
    update(["listUpdate"]);
  }

  void refresh() {
    fetchGenerate();
  }

  void save() {
    if ((selectedProgTypeIndexes?.isEmpty)!) {
      Snack.callError("Please select program type");
    } else if (episodeFrom_.text == "") {
      Snack.callError("Please select episode from");
    } else if (episodeTo_.text == "") {
      Snack.callError("Please select episode to");
    } else {
      List<SystemEnviroment> selected = [];
      for (int i = 0; i < (progTypeList?.length)!; i++) {
        if ((selectedProgTypeIndexes?.contains(i))!) {
          selected.add(progTypeList![i]);
        }
      }

      var postMap = {
        "Userid": Get.find<MainController>().user?.logincode ?? "",
        "lstprogramTapeDetails": selected.map((e) => e.toTapeJson()).toList(),
        "EpFrom": episodeFrom_.text,
        "EpTo": episodeTo_.text
      };
      print("LOG VALUE>>" + jsonEncode(postMap));
      LoadingDialog.call();
      Get.find<ConnectorControl>().POSTMETHOD(
        // api: ApiFactory.MOVIE_EVENT_CHANNEL_MASTER + (selectedLocation?.key)!+",${(selectedChannel?.key)!},${df1.format(fromDt)},${df1.format(toDt)}",
          api: ApiFactory.FPC_MISMATCH_LOCATION,
          fun: (bool isSuccess) {
            Get.back();
            if (isSuccess) {
              // LoadingDialog.callDataSaved();;
              LoadingDialog.callDataSaved(callback: () {
                Get.delete<SalesAuditNotTelecastReportController>();
                Get.find<HomeController>().clearPage1();
              });
            } else {
              Snack.callError("Something went wrong");
            }
          },
          json: postMap);
    }
  }
}

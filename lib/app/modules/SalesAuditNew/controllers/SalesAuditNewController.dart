import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/modules/RoCancellation/bindings/ro_cancellation_doc.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/FormButton.dart';
import '../../../../widgets/PlutoGrid/src/manager/pluto_grid_state_manager.dart';
import '../../../../widgets/Snack.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../data/user_data_settings_model.dart';
import '../../../providers/ApiFactory.dart';
import '../../../providers/ExportData.dart';
import '../../../providers/SharedPref.dart';
import '../../CommonDocs/controllers/common_docs_controller.dart';
import '../../CommonDocs/views/common_docs_view.dart';
import '../SalesAuditGetRetrieveModel.dart';

class SalesAuditNewController extends GetxController {
  //TODO: Implement SalesAuditNewController
  RxBool isEnable = RxBool(true);
  var isStandby = RxBool(false);
  // var showError = RxBool(false);
  // var isStandby = RxBool(false);


  final count = 0.obs;
  RxList<DropDownValue> list = RxList([]);

  RxList<DropDownValue> locationList = RxList([]);
  RxList<DropDownValue> channelList = RxList([]);
  TextEditingController scheduledController = TextEditingController();

  RxBool showError = RxBool(false);
  RxBool showCancel = RxBool(false);

  FocusNode leftFocusNode = FocusNode();
  FocusNode rightFocusNode = FocusNode();

  DropDownValue? selectedLocation;
  DropDownValue? selectedChannel;
  PlutoGridStateManager? gridStateManagerLeft;
  PlutoGridStateManager? gridStateManagerRight;
  SalesAuditGetRetrieveModel? salesAuditGetRetrieveModel = null;
  List<LstAsrunlog1> listAsrunLog1 = [];
  List<LstAsrunlog2> listAsrunLog2 = [];
  int? selectedIndex = 0;
  int? selectedRightIndex = 0;
  List<LstAsrunlog1> masterListAsrunLog1 = [];
  List<LstAsrunlog2> masterListAsrunLog2 = [];
  bool leftTblFocus = false;
  bool rightTblFocus = false;
  FocusNode locationNode = FocusNode();
  FocusNode channelNode = FocusNode();
  String f3Data = "";

  fetchPageLoadData() {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.SALESAUDIT_NEW_LOAD,
        fun: (map) {
          closeDialogIfOpen();
          if (map is Map &&
              map.containsKey("listlocations") &&
              map['listlocations'].length > 0) {
            locationList.clear();
            map['listlocations'].forEach((e) {
              locationList.add(DropDownValue.fromJsonDynamic(
                  e, "locationCode", "locationName"));
            });
          } else {
            locationList.clear();
          }
        });
  }

  fetchListOfChannel(String code) {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.SALESAUDIT_NEW_GETCHANNEL + code,
        fun: (Map map) {
          closeDialogIfOpen();
          channelList.clear();
          print(">>>>jks$map");
          if (map is Map &&
              map.containsKey("listchannels") &&
              map['listchannels'].length > 0) {
            map['listchannels'].forEach((e) {
              channelList.add(DropDownValue.fromJsonDynamic(
                  e, "channelCode", "channelName"));
            });
          }
        });
  }

  Future<bool>? showDialogForYesNo(String text) {
    Completer<bool> completer = Completer<bool>();
    LoadingDialog.recordExists(
      text,
      () {
        completer.complete(true);
        // return true;
      },
      cancel: () {
        completer.complete(false);
        // return false;
      },
    );
    return completer.future;
  }

  filterSearchAndCancel() {
    if (gridStateManagerLeft != null) {
      if (showError.value == true && showCancel.value == true) {
        gridStateManagerLeft?.setFilter((element) => true);
        gridStateManagerLeft?.notifyListeners();
      } else if (showError.value == true) {
        gridStateManagerLeft?.setFilter((element) => true);
        gridStateManagerLeft?.setFilter((e) =>
            e.cells['bookingStatus']?.value.toString().trim().toLowerCase() !=
            "c");
        gridStateManagerLeft?.notifyListeners();
      } else if (showCancel.value == true) {
        gridStateManagerLeft?.setFilter((element) => true);
        gridStateManagerLeft?.setFilter((e) =>
            e.cells['bookingStatus']?.value.toString().trim().toLowerCase() !=
            "e");
        gridStateManagerLeft?.notifyListeners();
      } else {
        gridStateManagerLeft?.setFilter((element) => true);
        gridStateManagerLeft?.setFilter((e) => (e.cells['bookingStatus']?.value
                    .toString()
                    .trim()
                    .toLowerCase() !=
                "e" &&
            e.cells['bookingStatus']?.value.toString().trim().toLowerCase() !=
                "c"));
        gridStateManagerLeft?.notifyListeners();
      }
    }
  }

  void btnMapClear_Click() {
    // tblSpots - listAsrunLog2 - leftIndex - gridStateManagerLeft
    // tblAsrun - listAsrunLog1 - rightindex - gridStateManagerRight

    if (((gridStateManagerLeft?.rows.length ?? 0) < 1) ||
        ((gridStateManagerRight?.rows.length ?? 0) < 1)) {
      return;
    } else if (gridStateManagerLeft
            ?.rows[gridStateManagerLeft?.currentRowIdx ?? 0]
            .cells['exportTapeCode']
            ?.value
            .toString()
            .trim() ==
        gridStateManagerRight?.rows[gridStateManagerRight?.currentRowIdx ?? 0]
            .cells['exportTapeCode']?.value
            .toString()
            .trim()) {
      gridStateManagerLeft?.rows[gridStateManagerLeft?.currentRowIdx ?? 0]
          .cells['telecastTime']?.value = " ";
      gridStateManagerLeft?.rows[gridStateManagerLeft?.currentRowIdx ?? 0]
          .cells['programCode']?.value = "";
      gridStateManagerLeft?.rows[gridStateManagerLeft?.currentRowIdx ?? 0]
          .cells['rownumber']?.value = " ";

      gridStateManagerRight?.rows[gridStateManagerRight?.currentRowIdx ?? 0]
          .cells['bookingNumber']?.value = " ";
      gridStateManagerRight?.rows[gridStateManagerRight?.currentRowIdx ?? 0]
          .cells['bookingDetailCode']?.value = 0;
      gridStateManagerLeft?.notifyListeners();
      gridStateManagerRight?.notifyListeners();
    } else {
      LoadingDialog.recordExists(
          "The Tapes Dont Match!\nDo you still want to clear telecast info?",
          () {
        gridStateManagerLeft?.rows[gridStateManagerLeft?.currentRowIdx ?? 0]
            .cells['telecastTime']?.value = "";
        gridStateManagerLeft?.rows[gridStateManagerLeft?.currentRowIdx ?? 0]
            .cells['programCode']?.value = "";
        gridStateManagerLeft?.rows[gridStateManagerLeft?.currentRowIdx ?? 0]
            .cells['rownumber']?.value = " ";
        gridStateManagerLeft?.notifyListeners();
      }, cancel: () {
        Get.back();
      });
    }
  }

  markError(int index) {
    // tblSpots - listAsrunLog2 - leftIndex - gridStateManagerLeft
    // tblAsrun - listAsrunLog1 - rightindex - gridStateManagerRight

    if (gridStateManagerLeft?.rows[gridStateManagerLeft?.currentRowIdx ?? 0]
            .cells['bookingStatus']?.value
            .toString()
            .trim()
            .toLowerCase() ==
        "e") {
      LoadingDialog.recordExists("Do you want to clear Error making?", () {
        gridStateManagerLeft?.rows[gridStateManagerLeft?.currentRowIdx ?? 0]
                .cells['bookingStatus']?.value =
            gridStateManagerLeft?.rows[gridStateManagerLeft?.currentRowIdx ?? 0]
                .cells['previousBookingStatus']?.value;
        gridStateManagerLeft?.rows[gridStateManagerLeft?.currentRowIdx ?? 0]
            .cells['bookingStatus']?.value = "B";
        gridStateManagerLeft?.notifyListeners();
      }, cancel: () {
        Get.back();
      });
    } else {
      if (gridStateManagerLeft?.rows[gridStateManagerLeft?.currentRowIdx ?? 0]
                  .cells['telecastTime']?.value !=
              null &&
          gridStateManagerLeft?.rows[gridStateManagerLeft?.currentRowIdx ?? 0]
                  .cells['telecastTime']?.value
                  .toString()
                  .trim() !=
              "" &&
          gridStateManagerLeft?.rows[gridStateManagerLeft?.currentRowIdx ?? 0]
                  .cells['telecastTime']?.value !=
              "null") {
        LoadingDialog.showErrorDialog(
            "Telecast Spot!\nUnable To mark as error!");
      } else {
        LoadingDialog.recordExists("Do you want to mark as Error?", () {
          gridStateManagerLeft?.rows[gridStateManagerLeft?.currentRowIdx ?? 0]
                  .cells['previousBookingStatus']?.value =
              gridStateManagerLeft
                  ?.rows[gridStateManagerLeft?.currentRowIdx ?? 0]
                  .cells['bookingStatus']
                  ?.value;
          gridStateManagerLeft?.rows[gridStateManagerLeft?.currentRowIdx ?? 0]
              .cells['bookingStatus']?.value = "E";
          gridStateManagerLeft?.rows[gridStateManagerLeft?.currentRowIdx ?? 0]
              .cells['programCode']?.value = "";
          gridStateManagerLeft?.rows[gridStateManagerLeft?.currentRowIdx ?? 0]
              .cells['rownumber']?.value = "";
          gridStateManagerLeft?.notifyListeners();
        }, cancel: () {
          Get.back();
        });
      }
    }
  }

  allBToE() {
    // tblSpots - listAsrunLog2 - leftIndex - gridStateManagerLeft
    // tblAsrun - listAsrunLog1 - rightindex - gridStateManagerRight
    for (int i = 0; i < (gridStateManagerLeft?.rows.length ?? 0); i++) {
      if (gridStateManagerLeft?.rows[i].cells['bookingStatus']?.value
              .toString()
              .trim()
              .toLowerCase() ==
          "e") {
        continue;
      } else if ((gridStateManagerLeft?.rows[i].cells['bookingStatus']?.value
                      .toString()
                      .trim()
                      .toLowerCase() ==
                  "b" ||
              gridStateManagerLeft?.rows[i].cells['bookingStatus']?.value
                      .toString()
                      .trim()
                      .toLowerCase() ==
                  "r") &&
          (gridStateManagerLeft?.rows[i].cells['telecastTime']?.value == null ||
              gridStateManagerLeft?.rows[i].cells['telecastTime']?.value
                      .toString()
                      .trim() ==
                  "")) {
        gridStateManagerLeft?.rows[i].cells['previousBookingStatus']?.value =
            gridStateManagerLeft?.rows[i].cells['bookingStatus']?.value;
        gridStateManagerLeft?.rows[i].cells['bookingStatus']?.value = "E";
        gridStateManagerLeft?.rows[i].cells['programCode']?.value = "";
        gridStateManagerLeft?.rows[i].cells['rownumber']?.value = "";
        gridStateManagerLeft?.rows[i].cells['telecastTime']?.value = "";
        gridStateManagerLeft?.rows[i].cells['remarks']?.value =
            "Not telecast Sales Audit";

        continue;
      } else {
        continue;
      }
    }
    filterSearchAndCancel();
    // gridStateManagerLeft?.notifyListeners();
  }

  unCancel(int index) {
    for (int i = 0; i < listAsrunLog2.length; i++) {
      if (i == index) {
        if (listAsrunLog2[index].telecastTime != null &&
            listAsrunLog2[index].telecastTime != "" &&
            listAsrunLog2[index].telecastTime != "null") {
          listAsrunLog2[index].bookingStatus = "C";
          update(['leftOne']);
        }
        break;
      } else {
        continue;
      }
    }
  }

  showAll() {
    if (gridStateManagerLeft != null) {
      if (showError.value == true && showCancel.value == true) {
        gridStateManagerLeft?.setFilter((element) => true);
        gridStateManagerRight?.setFilter((element) => true);
        gridStateManagerLeft?.notifyListeners();
        gridStateManagerRight?.notifyListeners();
      } else if (showError.value == true) {
        gridStateManagerLeft?.setFilter((element) => true);
        gridStateManagerLeft?.setFilter((e) =>
            e.cells['bookingStatus']?.value.toString().trim().toLowerCase() != "c");
        gridStateManagerRight?.setFilter((element) => true);
        gridStateManagerLeft?.notifyListeners();
        gridStateManagerRight?.notifyListeners();
      } else if (showCancel.value == true) {
        gridStateManagerLeft?.setFilter((element) => true);
        gridStateManagerLeft?.setFilter((e) =>
            e.cells['bookingStatus']?.value.toString().trim().toLowerCase() !=
            "e");
        gridStateManagerRight?.setFilter((element) => true);
        gridStateManagerLeft?.notifyListeners();
        gridStateManagerRight?.notifyListeners();
      } else {
        gridStateManagerLeft?.setFilter((element) => true);
        gridStateManagerLeft?.setFilter((e) => (e.cells['bookingStatus']?.value
                    .toString()
                    .trim()
                    .toLowerCase() !=
                "e" &&
            e.cells['bookingStatus']?.value.toString().trim().toLowerCase() !=
                "c"));
        gridStateManagerRight?.setFilter((element) => true);
        gridStateManagerLeft?.notifyListeners();
        gridStateManagerRight?.notifyListeners();
      }
    }
  }

  callGetRetrieve() {
    if (selectedLocation == null) {
      Snack.callError("Please select location");
    } else if (selectedChannel == null) {
      Snack.callError("Please select channel");
    } else if (scheduledController.text == null ||
        scheduledController.text == "") {
      Snack.callError("Please select scheduled date");
    } else {
      LoadingDialog.call();
      String date = Uri.encodeComponent((DateFormat("yyyy-MM-dd HH:mm").parse(
              (DateFormat("dd-MM-yyyy").parse(scheduledController.text))
                  .toString()))
          .toString());
      print(">>>>$date");

      // ((Get.find<MainController>().user != null) ? Aes.encrypt(Get.find<MainController>().user?.personnelNo ?? "") : "")

      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.SALESAUDIT_NEW_GETRETRIEVE(
              selectedLocation!.key ?? "", selectedChannel!.key ?? "", date),
          fun: (map) async {
            Get.back();

            listAsrunLog2.clear();
            listAsrunLog1.clear();
            masterListAsrunLog2.clear() ;
            masterListAsrunLog1.clear() ;
            if (map is Map &&
                map.containsKey('gettables') &&
                map['gettables'] != null) {
              // lstAsrunLog1.clear();
              // lstAsrunLog2.clear();
              print(">>>>>>>map${jsonEncode(map)}");
              salesAuditGetRetrieveModel = SalesAuditGetRetrieveModel.fromJson(
                  map as Map<String, dynamic>);
              print(">>>>>>>mapGenerate${jsonEncode(salesAuditGetRetrieveModel?.toJson())}");
              // masterListAsrunLog2.addAll(listAsrunLog2);
              // masterListAsrunLog1.addAll(listAsrunLog1);

              if (map['gettables']['lstAsrunlog1'] != null &&
                  map['gettables']['lstAsrunlog1'] != "null" &&
                  map['gettables']['lstAsrunlog1'].length > 0) {
                listAsrunLog1.addAll(salesAuditGetRetrieveModel!
                    .gettables!.lstAsrunlog1 as Iterable<LstAsrunlog1>);
                masterListAsrunLog1.addAll(listAsrunLog1) ;
              }
              if (map['gettables']['lstAsrunlog2'] != null &&
                  map['gettables']['lstAsrunlog2'] != "null" &&
                  map['gettables']['lstAsrunlog2'].length > 0) {
                listAsrunLog2.addAll(salesAuditGetRetrieveModel!
                    .gettables!.lstAsrunlog2 as Iterable<LstAsrunlog2>);
                masterListAsrunLog2.addAll(listAsrunLog2) ;
              }
              update(['leftOne', 'text', 'rightOne']);
            } else {
              salesAuditGetRetrieveModel = null;
              listAsrunLog2.clear();
              listAsrunLog1.clear();
              update(['leftOne']);
              update(['rightOne']);
              update(['text']);
            }
          });
    }
  }
  
  filerStateManagerData(stateManager){
    if(showError.value == true && showCancel.value != true){
      stateManager.setFilter((e)=>e.cells['bookingStatus']?.value.toString().trim().toLowerCase() != "c");
    }else if(showError.value != true && showCancel.value == true){
      stateManager.setFilter((e)=>e.cells['bookingStatus']?.value.toString().trim().toLowerCase() != "e");
    }else if(showError.value != true && showCancel.value != true){
      stateManager.setFilter((e)=>( e.cells['bookingStatus']?.value.toString().trim().toLowerCase() != "e" &&
          e.cells['bookingStatus']?.value.toString().trim().toLowerCase() != "c" ));
    }else{
      stateManager.setFilter((element) => true);
    }
  }

  saveData() {
    // tblSpots - listAsrunLog2 - leftIndex - gridStateManagerLeft
    // tblAsrun - listAsrunLog1 - rightindex - gridStateManagerRight

    LoadingDialog.call();
    Map<String, dynamic> postData = {
      "locationcode": selectedLocation?.key ?? "",
      "channelcode": selectedChannel?.key ?? "",
      "loggedUsercode": Get.find<MainController>().user?.logincode ?? "",
      "date": DateFormat("yyyy-MM-ddTHH:mm:ss")
          .format(DateFormat("dd-MM-yyyy").parse(scheduledController.text)),
      // "lstspots": masterListAsrunLog2.map((e) => e.toJson1()).toList(),
      "lstspots": getDataFromGrid1(gridStateManagerLeft),
      // "lstasrun": masterListAsrunLog1.map((e) => e.toJson1()).toList(),
      "lstasrun": getDataFromGrid(gridStateManagerRight),
    };

    // print(">>>>>>postData${jsonEncode(postData)}");
    Get.find<ConnectorControl>().POSTMETHOD(
      api: ApiFactory.SALESAUDIT_NEW_SAVEDATA,
      // api: "",
      json: postData,
      fun: (map) {
        Get.back();
        print(">>>>>map$map");
        if (map is Map && map.containsKey("postSalesAduit")) {
          LoadingDialog.callDataSavedMessage((map['postSalesAduit'] ?? ""),
              callback: () {
            // clearAll();
            // Get.back();
                callGetRetrieve();
          });
        } else {
          LoadingDialog.showErrorDialog((map ?? "").toString(),callback: (){
            callGetRetrieve();
          });
          // Snack.callError((map ?? "").toString());
        }
      },
    );
  }

  List<Map<String, dynamic>> getDataFromGrid(
      PlutoGridStateManager ? statemanager) {
    if(statemanager != null){
      statemanager.setFilter((element) => true);
      statemanager.notifyListeners();
      List<Map<String, dynamic>> mapList = [];

      for (var row in statemanager.rows) {
        Map<String, dynamic> rowMap = {};
        for (var key in row.cells.keys) {
          if (key.toString().trim() == "telecastTime") {
            if (row.cells[key]?.value != null &&
                (row.cells[key]?.value ?? "").toString().trim() != "") {
              // rowMap[key] = DateFormat("yyyy-MM-ddT").format(DateTime.now()) + (row.cells[key]?.value ?? "");
              rowMap[key] = row.cells[key]?.value;
            } else {
              // rowMap[key] = DateFormat("yyyy-MM-dd").format(DateTime.now()) + (row.cells[key]?.value ?? "");
              rowMap[key] = null;
            }
          }
          else if(key.toString().trim() == "telecastDate"){
            if (row.cells[key]?.value != null &&
                (row.cells[key]?.value ?? "").toString().trim() != "") {
              rowMap[key] = DateFormat('yyyy-MM-ddTHH:mm:ss').
              format(DateFormat("dd/MM/yyyy").parse(row.cells[key]?.value));
            } else {
              rowMap[key] = (row.cells[key]?.value ?? "");
            }
          }else if(key.toString().trim() == "rownumber"){
            if (row.cells[key]?.value != null &&
                (row.cells[key]?.value ?? "").toString().trim() != "") {
              rowMap[key] = int.parse(row.cells[key]?.value);
            } else {
              rowMap[key] = null;
            }
          }
          else {
            rowMap[key] = row.cells[key]?.value ?? "";
          }

        }
        mapList.add(rowMap);
      }
      return mapList;
    }else{
      return [];
    }




  }

  List<Map<String, dynamic>> getDataFromGrid1(
      PlutoGridStateManager? statemanager) {

    if(statemanager != null){
      statemanager.setFilter((element) => true);
      statemanager.notifyListeners();
      List<PlutoRow> myList = statemanager.rows;
      filerStateManagerData(statemanager);
      List<Map<String, dynamic>> mapList = [];
      // print("rows_length: "+myList.length.toString());
      // print("rows_length1: "+statemanager.filterRows.length.toString());
      for (var row in myList) {
        Map<String, dynamic> rowMap = {};
        for (var key in row.cells.keys) {
          if (key.toString().trim() == "telecastTime") {
            if (row.cells[key]?.value != null &&
                (row.cells[key]?.value ?? "").toString().trim() != "") {
              // rowMap[key] = DateFormat("yyyy-MM-ddT").format(DateTime.now()) + (row.cells[key]?.value ?? "").toString().trim();
              rowMap[key] = row.cells[key]?.value;
            } else {
              // rowMap[key] = DateFormat("yyyy-MM-dd").format(DateTime.now()) + (row.cells[key]?.value ?? "").toString().trim();
              rowMap[key] = null;
            }
          }else if(key.toString().trim() == "rownumber"){
            if (row.cells[key]?.value != null &&
                (row.cells[key]?.value ?? "").toString().trim() != "" &&  (row.cells[key]?.value ?? "").toString().trim() != "0") {
              rowMap[key] = int.parse((row.cells[key]?.value).toString());
            }else{
              rowMap[key] = null;
            }
          } else {
            rowMap[key] = row.cells[key]?.value ?? "";
          }
        }
        mapList.add(rowMap);
      }
      return mapList;
    }else{
      return [];
    }

  }

  clearAll() {
    Get.delete<SalesAuditNewController>();
    Get.find<HomeController>().clearPage1();
  }

  void doMatch(int rightIndex) {

    String Exporttapecode,
        FPCtime,
        TApeduration,
        BookingNumber,
        BookingDetailcode,
        TelecastTime;

    List<String> ros;

    String? RosStart, RosEnd, MidRosStart, MidRosEnd;

    bool IsRos;
    DateTime? RosStartParse;
    DateTime? RosEndParse;

    // tblSpots - listAsrunLog2 - leftIndex - gridStateManagerLeft
    // tblAsrun - listAsrunLog1 - rightindex - gridStateManagerRight

    Exporttapecode = gridStateManagerRight
            ?.rows[gridStateManagerRight?.currentRowIdx ?? 0]
            .cells['exportTapeCode']
            ?.value ??
        "";

    FPCtime = gridStateManagerRight
            ?.rows[gridStateManagerRight?.currentRowIdx ?? 0]
            .cells['fpctime']
            ?.value ??
        "";

    TApeduration = gridStateManagerRight
            ?.rows[gridStateManagerRight?.currentRowIdx ?? 0]
            .cells['tapeDuration']
            ?.value ??
        "";

    TelecastTime = gridStateManagerRight
            ?.rows[gridStateManagerRight?.currentRowIdx ?? 0]
            .cells['telecastTime']
            ?.value ??
        "";

    BookingNumber = gridStateManagerRight
            ?.rows[gridStateManagerRight?.currentRowIdx ?? 0]
            .cells['bookingNumber']
            ?.value ??
        "";

    BookingDetailcode = (gridStateManagerRight
                ?.rows[gridStateManagerRight?.currentRowIdx ?? 0]
                .cells['bookingDetailCode']
                ?.value ??
            "")
        .toString();

    // tblSpots - listAsrunLog2 - leftIndex - gridStateManagerLeft
    // tblAsrun - listAsrunLog1 - rightindex - gridStateManagerRight
    if (BookingNumber != "" && BookingNumber != null) {
      // leftIndex
      for (int i = 0; i < (gridStateManagerLeft?.rows.length ?? 0); i++) {
        if (((gridStateManagerLeft?.rows[i].cells['bookingNumber']?.value ??
                    "") ==
                BookingNumber) &&
            ((gridStateManagerLeft?.rows[i].cells['bookingDetailCode']?.value ??
                        "")
                    .toString()
                    .trim() ==
                BookingDetailcode.toString().trim())) {
          // gridStateManager?.setGridMode(PlutoGridMode.select) ;
          gridStateManagerLeft?.setCurrentCell(
              gridStateManagerLeft?.rows[i].cells["bookingDetailCode"], i);
          gridStateManagerLeft?.notifyListeners();
          return;
        }
      }
    }
    // tblSpots - listAsrunLog2 - leftIndex - gridStateManagerLeft
    // tblAsrun - listAsrunLog1 - rightindex - gridStateManagerRight
    for (int j = 0; j < (gridStateManagerLeft?.rows.length ?? 0); j++) {
      if ((gridStateManagerLeft?.rows[j].cells['dealTime']?.value ?? "")
              .toString()
              .trim() !=
          "") {
        IsRos = true;

        ros = (gridStateManagerLeft?.rows[j].cells['dealTime']?.value ?? "")
            .toString()
            .split("-");

        RosStart = "${ros[0]}:00";

        RosEnd = "${ros[1]}:00";

        RosStartParse = DateTime.parse("2023-01-01 ${RosStart}");
        RosEndParse = DateTime.parse("2023-01-01 ${RosEnd}");

        if (RosStartParse.compareTo(RosEndParse) > 0) {
          MidRosEnd = "23:59:59";

          MidRosStart = "00:00:00";
        } else {
          MidRosEnd = RosEnd;

          MidRosStart = RosEnd;
        }
      } else {
        IsRos = false;
      }
      // Non ROs check
      // tblSpots - listAsrunLog2 - leftIndex - gridStateManagerLeft
      // tblAsrun - listAsrunLog1 - rightindex - gridStateManagerRight

      if ((gridStateManagerLeft?.rows[j].cells['telecastTime']?.value ?? "")
                  .toString()
                  .trim() ==
              "" &&
          ((gridStateManagerLeft?.rows[j].cells['exportTapeCode']?.value ?? "")
                  .toString()
                  .trim() ==
              Exporttapecode.toString().trim()) &&
          (gridStateManagerLeft?.rows[j].cells['tapeDuration']?.value ?? "")
                  .toString()
                  .trim() ==
              TApeduration.toString().trim() &&
          DateTime.parse(
                      "2023-01-01 ${gridStateManagerLeft?.rows[j].cells['scheduleTime']?.value ?? ""}")
                  .difference(DateTime.parse("2023-01-01 $FPCtime"))
                  .inMinutes
                  .abs() <=
              4 &&
          !IsRos) {
        gridStateManagerLeft?.setCurrentCell(
            gridStateManagerLeft?.rows[j].cells["exportTapeCode"], j);
        gridStateManagerLeft?.notifyListeners();
        btnMapClick(gridStateManagerRight?.currentRowIdx,
            gridStateManagerLeft?.currentRowIdx);
        return;
      }
    }

    for (int k = 0; k < (gridStateManagerLeft?.rows.length ?? 0); k++) {
      if ((gridStateManagerLeft?.rows[k].cells['dealTime']?.value ?? "")
              .toString()
              .trim() !=
          "") {
        IsRos = true;

        ros = (gridStateManagerLeft?.rows[k].cells['dealTime']?.value ?? "")
            .toString()
            .split("-");

        RosStart = "${ros[0]}:00";

        RosEnd = "${ros[1]}:00";

        RosStartParse = DateTime.parse("2023-01-01 ${RosStart}");
        RosEndParse = DateTime.parse("2023-01-01 ${RosEnd}");

        if (RosStartParse.compareTo(RosEndParse) > 0) {
          MidRosEnd = "23:59:59";

          MidRosStart = "00:00:00";
        } else {
          MidRosEnd = RosEnd;

          MidRosStart = RosEnd;
        }
      } else {
        IsRos = false;
      }
      // DateTime.parse("2023-01-01 ${TelecastTime}")

      if ((gridStateManagerLeft?.rows[k].cells['telecastTime']?.value ?? "")
                  .toString()
                  .trim() ==
              "" &&
          (gridStateManagerLeft?.rows[k].cells['exportTapeCode']?.value ?? "")
                  .toString()
                  .trim() ==
              Exporttapecode.toString().trim() &&
          (gridStateManagerLeft?.rows[k].cells['tapeDuration']?.value ?? "")
                  .toString()
                  .trim() ==
              TApeduration.toString().trim() &&
          IsRos) {
        if ((DateTime.parse("2023-01-01 ${TelecastTime}")
                        .compareTo(RosStartParse!) >
                    0 &&
                DateTime.parse("2023-01-01 ${TelecastTime}")
                        .compareTo(DateTime.parse("2023-01-01 ${MidRosEnd}")) <
                    0) ||
            (DateTime.parse("2023-01-01 ${TelecastTime}").compareTo(
                        DateTime.parse("2023-01-01 ${MidRosStart}")) >
                    0 &&
                DateTime.parse("2023-01-01 ${TelecastTime}")
                        .compareTo(DateTime.parse("2023-01-01 ${MidRosEnd}")) <
                    0)) {
          gridStateManagerLeft?.setCurrentCell(
              gridStateManagerLeft?.rows[k].cells["exportTapeCode"], k);
          gridStateManagerLeft?.notifyListeners();
          btnMapClick(gridStateManagerRight?.currentRowIdx,
              gridStateManagerLeft?.currentRowIdx);
          return;
        }
      }
    }
  }

  void setNextRow1(String exportTapeCode) {
    // tblSpots - listAsrunLog2 - leftIndex -gridStateManager
    // tblAsrun - listAsrunLog1 - rightindex - gridStateManagerRight

    print("exportTapeCode${gridStateManagerLeft?.rows.length}");
    for (int i = 0; i < (gridStateManagerLeft?.rows.length ?? 0); i++) {
      // print(">>>>>>>>>>"+listAsrunLog2[i].exportTapeCode.toString()+exportTapeCode);
      if (gridStateManagerLeft?.rows[i].cells['exportTapeCode']?.value
                  .toString()
                  .trim() ==
              exportTapeCode &&
          (gridStateManagerLeft?.rows[i].cells['telecastTime']?.value == null ||
              ((gridStateManagerLeft?.rows[i].cells['telecastTime']?.value
                      .toString()
                      .trim()) ==
                  ""))) {
        print("searchIndex$i");
        // tblSpots.rows[dr.index].selected = true;
        gridStateManagerLeft?.setCurrentCell(
            gridStateManagerLeft?.rows[i].cells["exportTapeCode"], i);
        print(">>>>" + (gridStateManagerLeft?.currentRowIdx).toString());
        gridStateManagerLeft?.notifyListeners();
        break;
      }
    }

    for (int j = 0; j < (gridStateManagerRight?.rows.length ?? 0); j++) {
      // print(">>>>>>>>>>"+listAsrunLog1[j].exportTapeCode.toString()+exportTapeCode);
      if (gridStateManagerRight?.rows[j].cells['exportTapeCode']?.value
                  .toString()
                  .trim() ==
              exportTapeCode &&
          (gridStateManagerRight?.rows[j].cells['bookingNumber']?.value ==
                  null ||
              (gridStateManagerRight?.rows[j].cells['bookingNumber']?.value
                      .toString()
                      .trim() ==
                  ""))) {
        // tblAsrun.rows[dr1.index].selected = true;
        print("searchIndex$j");
        gridStateManagerRight?.setCurrentCell(
            gridStateManagerRight?.rows[j].cells["bookingNumber"], j);
        print(">>>>" + (gridStateManagerRight?.currentRowIdx).toString());
        gridStateManagerRight?.notifyListeners();
        break;
      }
    }
  }

  void btnAutoClick() {
    // tblSpots - listAsrunLog2 - leftIndex -gridStateManagerLeft
    // tblAsrun - listAsrunLog1 - rightindex - gridStateManagerRight
    if(gridStateManagerRight != null && gridStateManagerLeft != null){
      for (int i = 0; i < (gridStateManagerRight?.rows.length ?? 0); i++) {
        gridStateManagerRight?.setCurrentCell(
            gridStateManagerRight?.rows[i].cells["telecastTime"], i);
        gridStateManagerRight?.notifyListeners();
        doMatch(i);
      }
    }else{
      // LoadingDialog.showErrorDialog("");
    }

    // colorGrid();
  }

  closeDialogIfOpen() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  void btnMapClick(int? rightindex, int? leftIndex) {

    if(rightindex != null && leftIndex != null){
      String exporttapecode, FPCtime, TApeduration, Telecasttime;
      bool Matched = false;
      String programCode, rowNumber;
      print("jks3");
      // tblAsrun.CurrentRow.Selected = true;
      // right table

      // tblSpots - listAsrunLog2 - leftIndex -gridStateManagerLeft
      // tblAsrun - listAsrunLog1 - rightindex - gridStateManagerRight

      exporttapecode = gridStateManagerRight
          ?.rows[rightindex].cells['exportTapeCode']?.value ??
          "";
      programCode =
          gridStateManagerRight?.rows[rightindex].cells['programCode']?.value ??
              "";
      rowNumber =
          (gridStateManagerRight?.rows[rightindex].cells['rownumber']?.value ?? "").toString();
      FPCtime =
          gridStateManagerRight?.rows[rightindex].cells['fpctime']?.value ?? "";
      TApeduration =
          gridStateManagerRight?.rows[rightindex].cells['tapeDuration']?.value ??
              "";
      Telecasttime =
          gridStateManagerRight?.rows[rightindex].cells['telecastTime']?.value ??
              "";

      if (gridStateManagerRight?.rows[rightindex].cells['bookingNumber']?.value !=
          null &&
          gridStateManagerRight?.rows[rightindex].cells['bookingNumber']?.value.toString().trim() !=
              "") {
        print("jks1");
        // SetNextRow(rightindex,leftIndex);
        setNextRow1(exporttapecode);

        return;
      }
      if (gridStateManagerLeft?.rows[leftIndex].cells['telecastTime']?.value !=
          null &&
          gridStateManagerLeft?.rows[leftIndex].cells['telecastTime']?.value.toString().trim() !=
              "") {
        print("jks2");
        // SetNextRow(rightindex,leftIndex);

        setNextRow1(exporttapecode);
        return;
      }
      // tblSpots - listAsrunLog2 - leftIndex -gridStateManagerLeft
      // tblAsrun - listAsrunLog1 - rightindex - gridStateManagerRight

      if (exporttapecode.trim() ==
          gridStateManagerLeft?.rows[leftIndex].cells['exportTapeCode']?.value
              .toString()
              .trim() &&
          TApeduration.toString().trim() ==
              gridStateManagerLeft?.rows[leftIndex].cells['tapeDuration']?.value
                  .toString()
                  .trim() &&
          gridStateManagerLeft?.rows[leftIndex].cells['dealTime']?.value !=
              null &&
          gridStateManagerLeft?.rows[leftIndex].cells['dealTime']?.value != "") {
        print(">>>>>>>>>>>>inside if one");
        gridStateManagerLeft?.rows[leftIndex].cells['telecastTime']?.value =
            Telecasttime;
        gridStateManagerLeft?.rows[leftIndex].cells['programCode']?.value =
            programCode;
        gridStateManagerLeft?.rows[leftIndex].cells['rownumber']?.value =
            (rowNumber).toString();

        gridStateManagerRight?.rows[rightindex].cells['bookingNumber']?.value =
            gridStateManagerLeft?.rows[leftIndex].cells['bookingNumber']?.value;
        gridStateManagerRight
            ?.rows[rightindex].cells['bookingDetailCode']?.value =
            gridStateManagerLeft
                ?.rows[leftIndex].cells['bookingDetailCode']?.value;
        gridStateManagerRight?.rows[rightindex].cells['remark']?.value =
            (gridStateManagerLeft
                ?.rows[leftIndex].cells['bookingNumber']?.value ??
                "") +
                "-" +
                (gridStateManagerLeft
                    ?.rows[leftIndex].cells['bookingDetailCode']?.value ??
                    "")
                    .toString();
        gridStateManagerLeft?.notifyListeners();
        gridStateManagerRight?.notifyListeners();
        Matched = true;
        // update(['leftOne','rightOne']);
      }
      // tblSpots - listAsrunLog2 - leftIndex -gridStateManagerLeft
      // tblAsrun - listAsrunLog1 - rightindex - gridStateManagerRight

      if (exporttapecode.trim() ==
          gridStateManagerLeft?.rows[leftIndex].cells['exportTapeCode']?.value
              .toString()
              .trim() &&
          TApeduration.toString().trim() ==
              gridStateManagerLeft?.rows[leftIndex].cells['tapeDuration']?.value
                  .toString()
                  .trim() &&
          (gridStateManagerLeft?.rows[leftIndex].cells['dealTime']?.value !=
              null ||
              gridStateManagerLeft?.rows[leftIndex].cells['dealTime']?.value.toString().trim() !=
                  "") &&
          gridStateManagerLeft?.rows[leftIndex].cells['scheduleTime']?.value ==
              FPCtime &&
          !Matched) {
        print(">>>>>>>>>>>>inside if two");
        gridStateManagerLeft?.rows[leftIndex].cells['telecastTime']?.value =
            Telecasttime;
        gridStateManagerLeft?.rows[leftIndex].cells['programCode']?.value =
            programCode;
        gridStateManagerLeft?.rows[leftIndex].cells['rownumber']?.value =
            (rowNumber).toString();

        gridStateManagerRight?.rows[rightindex].cells['bookingNumber']?.value =
            gridStateManagerLeft?.rows[leftIndex].cells['bookingNumber']?.value;
        gridStateManagerRight
            ?.rows[rightindex].cells['bookingDetailCode']?.value =
            gridStateManagerLeft
                ?.rows[leftIndex].cells['bookingDetailCode']?.value;
        gridStateManagerRight?.rows[rightindex].cells['remark']?.value =
            (gridStateManagerLeft
                ?.rows[leftIndex].cells['bookingNumber']?.value ??
                "") +
                "-" +
                (gridStateManagerLeft
                    ?.rows[leftIndex].cells['bookingDetailCode']?.value ??
                    "")
                    .toString();
        gridStateManagerLeft?.notifyListeners();
        gridStateManagerRight?.notifyListeners();

        Matched = true;
      }

      // tblSpots - listAsrunLog2 - leftIndex -gridStateManagerLeft
      // tblAsrun - listAsrunLog1 - rightindex - gridStateManagerRight
      if (!Matched &&
          exporttapecode.trim() ==
              gridStateManagerLeft?.rows[leftIndex].cells['exportTapeCode']?.value
                  .toString()
                  .trim()) {
        print(">>>>>>>>>>>>inside if three");
        LoadingDialog.recordExists(
            "Only the Tapeid Matches!\nDo you want to force match these spots?",
                () {
              gridStateManagerLeft?.rows[leftIndex].cells['telecastTime']?.value =
                  Telecasttime;
              gridStateManagerLeft?.rows[leftIndex].cells['programCode']?.value =
                  programCode;
              gridStateManagerLeft?.rows[leftIndex].cells['rownumber']?.value =
                  (rowNumber).toString();

              gridStateManagerRight?.rows[rightindex].cells['bookingNumber']?.value =
                  gridStateManagerLeft?.rows[leftIndex].cells['bookingNumber']?.value;
              gridStateManagerRight
                  ?.rows[rightindex].cells['bookingDetailCode']?.value =
                  gridStateManagerLeft
                      ?.rows[leftIndex].cells['bookingDetailCode']?.value;
              gridStateManagerRight?.rows[rightindex].cells['remark']?.value =
                  (gridStateManagerLeft
                      ?.rows[leftIndex].cells['bookingNumber']?.value ??
                      "") +
                      "-" +
                      (gridStateManagerLeft?.rows[leftIndex]
                          .cells['bookingDetailCode']?.value ??
                          "")
                          .toString();
              gridStateManagerLeft?.notifyListeners();
              gridStateManagerRight?.notifyListeners();
            }, cancel: () {
          Get.back();
        });
      }
      setNextRow1(exporttapecode);
    }
    else{
      // LoadingDialog.showErrorDialog("It's should at least one row in both the grid");
      return;
    }


  }

  tapeBtn({int? leftIndex, int? rightIndex}) {
    // tblSpots - listAsrunLog2 - leftIndex -gridStateManagerLeft
    // tblAsrun - listAsrunLog1 - rightindex - gridStateManagerRight

    print(">>>>>>>>>>>>>leftIndex "+leftIndex.toString()+" "+rightIndex.toString());
    String? exportTapeCode;
    if(leftIndex != null){
      exportTapeCode = gridStateManagerLeft
          ?.rows[leftIndex]
          .cells['exportTapeCode']
          ?.value ??
          "";
      print(">>>>>>>>>>>exportTapeCode1"+exportTapeCode.toString());
    }
    if(rightIndex != null){
      exportTapeCode = gridStateManagerRight
          ?.rows[rightIndex]
          .cells['exportTapeCode']
          ?.value ??
          "";
      print(">>>>>>>>>>>exportTapeCode2"+exportTapeCode.toString());
    }


    print(">>>>>>>>>>>exportTapeCode"+exportTapeCode.toString());
    if (gridStateManagerLeft != null ) {
      if (showError.value == true && showCancel.value == true) {
        gridStateManagerLeft?.setFilter((element) => true);
        gridStateManagerRight?.setFilter((element) => true);

        gridStateManagerLeft?.setFilter((e) =>
            (e.cells['exportTapeCode']?.value.toString().trim() ==
                exportTapeCode.toString().trim()));

        gridStateManagerRight?.setFilter((e) =>
            (e.cells['exportTapeCode']?.value.toString().trim() ==
                exportTapeCode.toString().trim()));

        gridStateManagerLeft?.notifyListeners();
        gridStateManagerRight?.notifyListeners();
      }
      else if (showError.value == true) {
        gridStateManagerLeft?.setFilter((element) => true);
        gridStateManagerRight?.setFilter((element) => true);

        gridStateManagerLeft?.setFilter((e) =>
            (e.cells['bookingStatus']?.value.toString().trim().toLowerCase() !=
                    "c" &&
                (e.cells['exportTapeCode']?.value.toString().trim() ==
                    exportTapeCode.toString().trim())));
        gridStateManagerRight?.setFilter((e) =>
            (e.cells['exportTapeCode']?.value.toString().trim() ==
                exportTapeCode.toString().trim()));

        gridStateManagerLeft?.notifyListeners();
        gridStateManagerRight?.notifyListeners();
      }
      else if (showCancel.value == true) {
        gridStateManagerLeft?.setFilter((element) => true);
        gridStateManagerRight?.setFilter((element) => true);
        gridStateManagerLeft?.setFilter((e) =>
            (e.cells['bookingStatus']?.value.toString().trim().toLowerCase() !=
                    "e" &&
                (e.cells['exportTapeCode']?.value.toString().trim() ==
                    exportTapeCode.toString().trim())));

        gridStateManagerRight?.setFilter((e) =>
            (e.cells['exportTapeCode']?.value.toString().trim() ==
                exportTapeCode.toString().trim()));
        gridStateManagerLeft?.notifyListeners();
        gridStateManagerRight?.notifyListeners();
      }
      else {
        gridStateManagerLeft?.setFilter((element) => true);
        gridStateManagerRight?.setFilter((element) => true);
        gridStateManagerLeft?.setFilter((e) =>
            ((e.cells['bookingStatus']?.value.toString().trim().toLowerCase() !=
                        "e" &&
                    e.cells['bookingStatus']?.value
                            .toString()
                            .trim()
                            .toLowerCase() !=
                        "c") &&
                (e.cells['exportTapeCode']?.value.toString().trim() ==
                    exportTapeCode.toString().trim())));

        gridStateManagerRight?.setFilter((e) =>
            (e.cells['exportTapeCode']?.value.toString().trim() ==
                exportTapeCode.toString().trim()));
        gridStateManagerLeft?.notifyListeners();
        gridStateManagerRight?.notifyListeners();
      }
    }
  }

  List<LstAsrunlog1> masterUnMatchListAsrunLog1 = [];
  List<LstAsrunlog2> masterUnMatchListAsrunLog2 = [];

  void unMatchBtn() {
    if (gridStateManagerLeft != null) {
      if (showError.value == true && showCancel.value == true) {
        gridStateManagerLeft?.setFilter((element) => true);
        gridStateManagerRight?.setFilter((element) => true);

        gridStateManagerLeft?.setFilter((e) =>
            (e.cells['telecastTime']?.value == null || e.cells['telecastTime']?.value == "null" ||
                e.cells['telecastTime']?.value
                        .toString()
                        .toLowerCase() ==
                    ""));
        gridStateManagerRight?.setFilter((e) =>
            (e.cells['bookingNumber']?.value == null || e.cells['bookingNumber']?.value == "null" ||
                e.cells['bookingNumber']?.value
                        .toString()
                        .toLowerCase() ==
                    ""));
        gridStateManagerLeft?.notifyListeners();
        gridStateManagerRight?.notifyListeners();
      } else if (showError.value == true) {
        gridStateManagerLeft?.setFilter((element) => true);
        gridStateManagerRight?.setFilter((element) => true);
        gridStateManagerLeft?.setFilter((e) =>
            (e.cells['bookingStatus']?.value.toString().trim().toLowerCase() !=
                    "c" &&
                (e.cells['telecastTime']?.value == null || e.cells['telecastTime']?.value == "null"  ||
                    e.cells['telecastTime']?.value
                            .toString()
                            .toLowerCase() ==
                        "")));
        gridStateManagerRight?.setFilter((e) =>
            (e.cells['bookingNumber']?.value == null || e.cells['bookingNumber']?.value == "null"  ||
                e.cells['bookingNumber']?.value
                        .toString()
                        .toLowerCase() ==
                    ""));
        gridStateManagerLeft?.notifyListeners();
        gridStateManagerRight?.notifyListeners();
      } else if (showCancel.value == true) {
        gridStateManagerLeft?.setFilter((element) => true);
        gridStateManagerRight?.setFilter((element) => true);
        gridStateManagerLeft?.setFilter((e) =>
            (e.cells['bookingStatus']?.value.toString().trim().toLowerCase() !=
                    "e" &&
                (e.cells['telecastTime']?.value == null || e.cells['telecastTime']?.value == "null" ||
                    e.cells['telecastTime']?.value
                            .toString()
                            .toLowerCase() ==
                        "")));

        gridStateManagerRight?.setFilter((e) =>
            (e.cells['bookingNumber']?.value == null || e.cells['bookingNumber']?.value == "null"  ||
                e.cells['bookingNumber']?.value
                        .toString()
                        .toLowerCase() ==
                    ""));
        gridStateManagerLeft?.notifyListeners();
        gridStateManagerRight?.notifyListeners();
      } else {
        gridStateManagerLeft?.setFilter((element) => true);
        gridStateManagerRight?.setFilter((element) => true);
        gridStateManagerLeft?.setFilter((e) =>
            ((e.cells['bookingStatus']?.value.toString().trim().toLowerCase() !=
                        "e" &&
                    e.cells['bookingStatus']?.value
                            .toString()
                            .toLowerCase() !=
                        "c") &&
                (e.cells['telecastTime']?.value == null || e.cells['telecastTime']?.value == "null"  ||
                    e.cells['telecastTime']?.value
                            .toString()
                            .toLowerCase() ==
                        "")));

        gridStateManagerRight?.setFilter((e) =>
            (e.cells['bookingNumber']?.value == null ||
                e.cells['bookingNumber']?.value == "null"  ||
                e.cells['bookingNumber']?.value
                        .toString()
                        .toLowerCase() ==
                    ""));
        gridStateManagerLeft?.notifyListeners();
        gridStateManagerRight?.notifyListeners();
      }
    }
    // gridStateManagerRight?.rows.map((e) => e.toJson());
  }

  List<RoCancellationDocuments> documents = [];

  docs() async {
    String documentKey = "";
    if (selectedLocation == null || selectedChannel == null) {
      documentKey = "";
    } else {
      documentKey = "SalesAudit " +
          (selectedLocation?.key ?? "") +
          (selectedChannel?.key ?? "") +
          '0' +
          DateFormat("yyyyMMdd")
              .format(DateFormat("dd-MM-yyyy").parse(scheduledController.text));
    }

     if (documentKey == "") {
          return;
        }

    /* PlutoGridStateManager? viewDocsStateManger;
    try {
      LoadingDialog.call();
      await Get.find<ConnectorControl>().GET_METHOD_CALL_HEADER(
          api: ApiFactory.COMMON_DOCS_LOAD(documentKey),
          fun: (data) {
            if (data is Map && data.containsKey("info_GetAllDocument")) {
              documents = [];
              for (var doc in data["info_GetAllDocument"]) {
                documents.add(RoCancellationDocuments.fromJson(doc));
              }
              Get.back();
            }
          });
    } catch (e) {
      Get.back();
    }
    Get.defaultDialog(
        title: "Documents",
        content: SizedBox(
          width: Get.width / 2.5,
          height: Get.height / 2.5,
          child: Scaffold(
            body: RawKeyboardListener(
              focusNode: FocusNode(),
              onKey: (value) {
                if (value.isKeyPressed(LogicalKeyboardKey.delete)) {
                  LoadingDialog.delete(
                    "Want to delete selected row",
                        () async {
                      LoadingDialog.call();
                      await Get.find<ConnectorControl>().DELETEMETHOD(
                        api: ApiFactory.COMMON_DOCS_DELETE(documents[viewDocsStateManger!.currentRowIdx!].documentId.toString()),
                        fun: (data) {
                          Get.back();
                        },
                      );
                      Get.back();
                      docs();
                    },
                    cancel: () {},
                  );
                }
              },
              child: DataGridShowOnlyKeys(
                hideCode: true,
                hideKeys: ["documentId"],
                dateFromat: "dd-MM-yyyy HH:mm",
                mapData: documents.map((e) => e.toJson()).toList(),
                onload: (loadGrid) {
                  viewDocsStateManger = loadGrid.stateManager;
                },
                onRowDoubleTap: (row) {
                  Get.find<ConnectorControl>().GET_METHOD_CALL_HEADER(
                      api: ApiFactory.COMMON_DOCS_VIEW((documents[row.rowIdx].documentId).toString()),
                      fun: (data) {
                        if (data is Map && data.containsKey("addingDocument")) {
                          ExportData()
                              .exportFilefromByte(base64Decode(data["addingDocument"][0]["documentData"]), data["addingDocument"][0]["documentname"]);
                        }
                      });
                },
              ),
            ),
          ),
        ),
        actions: {"Add Doc": () async {}, "View Doc": () {},
          "Attach Email": () {}}.entries.map((e) =>
            FormButtonWrapper(
          btnText: e.key,
          callback: e.key == "Add Doc"
              ? () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: false);

            if (result != null && result.files.isNotEmpty) {
              LoadingDialog.call();
              await Get.find<ConnectorControl>().POSTMETHOD_FORMDATA_HEADER(
                  api: ApiFactory.COMMON_DOCS_ADD,
                  fun: (data) {
                    if (data is Map && data.containsKey("addingDocument")) {
                      for (var doc in data["addingDocument"]) {
                        documents.add(RoCancellationDocuments.fromJson(doc));
                      }
                      Get.back();
                      docs();
                    }
                  },
                  json: {
                    "documentKey": documentKey,
                    "loggedUser": Get.find<MainController>().user?.logincode ?? "",
                    "strFilePath": result.files.first.name,
                    "bytes": base64.encode(List<int>.from(result.files.first.bytes ?? []))
                  });
              Get.back();
            }
          }
              : e.key == "View Doc"
              ? () {
            Get.find<ConnectorControl>().GET_METHOD_CALL_HEADER(
                api: ApiFactory.COMMON_DOCS_VIEW((documents[viewDocsStateManger!.currentCell!.row.sortIdx].documentId).toString()),
                fun: (data) {
                  if (data is Map && data.containsKey("addingDocument")) {
                    ExportData().exportFilefromByte(
                        base64Decode(data["addingDocument"][0]["documentData"]), data["addingDocument"][0]["documentname"]);
                  }
                });
          }
              : () {},
        )).toList()
    );*/

    Get.defaultDialog(
      title: "Documents",
      content: CommonDocsView(documentKey: documentKey),
    ).then((value) {
      Get.delete<CommonDocsController>(tag: "commonDocs");
    });
  }

  @override
  void onInit() {
    leftFocusNode.addListener(() {
      if (leftFocusNode.hasFocus) {
        leftTblFocus = true;
      } else {
        leftTblFocus = false;
      }
    });
    rightFocusNode.addListener(() {
      if (rightFocusNode.hasFocus) {
        rightTblFocus = true;
      } else {
        rightTblFocus = false;
      }
    });
    super.onInit();
  }

  @override
  void onReady() {
    fetchPageLoadData();
    super.onReady();
    fetchUserSetting1();
  }

  UserDataSettings? userDataSettings;

  fetchUserSetting1() async {
    userDataSettings = await Get.find<HomeController>().fetchUserSetting2();
    update(['leftOne', 'rightOne']);
  }

  formHandler(String str) {
    if (str == "Clear") {
      clearAll();
    } else if (str == "Save") {
      saveData();
    } else if (str == "Docs") {
      docs();
    } else if (str == "Exit") {
      Get.find<HomeController>().postUserGridSetting2(listStateManager: [
        {"gridStateManagerLeft": gridStateManagerLeft},
        {"gridStateManagerRight": gridStateManagerRight},
      ]);
    }
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}

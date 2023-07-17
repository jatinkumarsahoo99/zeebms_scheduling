import 'dart:async';
import 'dart:convert';

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
import '../../../providers/ApiFactory.dart';
import '../../../providers/ExportData.dart';
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
  PlutoGridStateManager? gridStateManager;
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

  fetchPageLoadData() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.SALESAUDIT_NEW_LOAD,
        fun: ( map) {
          if (map is Map &&
              map.containsKey("listlocations") &&
              map['listlocations'].length > 0) {
            locationList.clear();
            map['listlocations'].forEach((e) {
              locationList.add(DropDownValue.fromJsonDynamic(
                  e, "locationCode", "locationName"));
            });
          }else{
            locationList.clear();
          }
        });
  }

  fetchListOfChannel(String code) {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.SALESAUDIT_NEW_GETCHANNEL + code,
        fun: (Map map) {
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

  filterSearchAndCancel(){
    if(salesAuditGetRetrieveModel != null){

      if(salesAuditGetRetrieveModel!.gettables != null &&
          salesAuditGetRetrieveModel!.gettables!.lstAsrunlog1 != null &&
          salesAuditGetRetrieveModel!.gettables!.lstAsrunlog1!.isNotEmpty  ){
        listAsrunLog2.clear();
        masterListAsrunLog2.clear();
        if(showError.value == true && showCancel.value == true){
          listAsrunLog2.addAll(salesAuditGetRetrieveModel!.gettables!.lstAsrunlog2 as Iterable<LstAsrunlog2>);
          masterListAsrunLog2.addAll(listAsrunLog2);
        }else if(showError.value == true){
          listAsrunLog2.addAll(salesAuditGetRetrieveModel!.gettables!.lstAsrunlog2!.where((element) =>
          element.bookingStatus.toString().toUpperCase() != "C").toList());
          masterListAsrunLog2.addAll(listAsrunLog2);
        }else if(showCancel.value == true){
          listAsrunLog2.addAll(salesAuditGetRetrieveModel!.gettables!.lstAsrunlog2!.where((element) =>
          element.bookingStatus.toString().toUpperCase() != "E").toList());
          masterListAsrunLog2.addAll(listAsrunLog2);
        }else{
          listAsrunLog2.addAll(salesAuditGetRetrieveModel!.gettables!.lstAsrunlog2!.where((element) =>
          element.bookingStatus.toString().toUpperCase() != "C" && element.bookingStatus.toString().toUpperCase() != "E").toList());
          masterListAsrunLog2.addAll(listAsrunLog2);
        }
        update(['leftOne']);
      }
    }else{
      listAsrunLog2.clear();
      masterListAsrunLog2.clear();
      update(['leftOne']);
    }

  }
  clearBtn(int leftIndex,int rightIndex){
       print("leftIndex$leftIndex");
       print("rightIndex$rightIndex");
       print("leftTblFocus $leftTblFocus");
       print("rightTblFocus $rightTblFocus");
       if(leftTblFocus){
         listAsrunLog2[leftIndex].telecastTime= "";
         update(['leftOne']);
       }
       if(rightTblFocus){
         listAsrunLog1[rightIndex].bookingNumber="";
         update(['rightOne']);
       }
  }
  void btnMapClear_Click() {
    // tblSpots - listAsrunLog2 - leftIndex
    // tblAsrun - listAsrunLog1 - rightindex
    int spots = gridStateManager?.currentRowIdx??0;
    int asrun = gridStateManagerRight?.currentRowIdx??0;
    // String exportTapeCode = tblSpots.rows[spots].cells["Exporttapecode"].value;
    String exportTapeCode = listAsrunLog2[spots].exportTapeCode??"";

    if (listAsrunLog2[spots].exportTapeCode == listAsrunLog1[asrun].exportTapeCode) {
      listAsrunLog1[asrun].bookingNumber = null;
      listAsrunLog1[asrun].bookingDetailCode = 0;
     /* tblSpots.rows[spots].cells["Telecasttime"].value = null;
      tblSpots.rows[spots].cells["ProgramCode"].value = "";
      tblSpots.rows[spots].cells["RowNumber"].value = null;*/

      listAsrunLog2[spots].telecastTime = null;
      listAsrunLog2[spots].programCode = "";
      listAsrunLog2[spots].rowNumber = null;
      update(['leftOne','rightOne']);
      // tblSpots.rows[spots].selected = true;
    } else {
      LoadingDialog.recordExists("The Tapes Dont Match!\nDo you still want to clear telecast info?",
              (){
                /*tblSpots.rows[spots].cells["Telecasttime"].value = "";
                tblSpots.rows[spots].cells["ProgramCode"].value = "";
                tblSpots.rows[spots].cells["RowNumber"].value = null;
                tblSpots.rows[spots].selected = true;*/
                listAsrunLog2[spots].telecastTime = "";
                listAsrunLog2[spots].programCode = "";
                listAsrunLog2[spots].rowNumber = null;
                update(['leftOne']);
              },
          cancel: (){
            Get.back();
          });


    }
  }


  markError(int index){
      for(int i=0;i<listAsrunLog2.length;i++){
        if(i == index){
          if(listAsrunLog2[index].bookingStatus  != "E"){
            listAsrunLog2[index].previousBookingStatus =  listAsrunLog2[index].bookingStatus;
            listAsrunLog2[index].bookingStatus = "E";
            listAsrunLog2[index].programCode = null;
            listAsrunLog2[index].rowNumber = null;
          }else{
            listAsrunLog2[index].bookingStatus = listAsrunLog2[index].previousBookingStatus??"B";
          }
          print("index$index");

            update(['leftOne']);

           /* Timer(Duration(seconds: 5),() {
              gridStateManager?.setCurrentCell(gridStateManager?.rows[index].cells["no"], index) ;
            },);*/

          break;
        }else{
          continue;
        }
      }
  }
  allBToE(){
    for(int i=0;i<listAsrunLog2.length;i++){
      if(listAsrunLog2[i].telecastTime == "" ||
          listAsrunLog2[i].telecastTime == null ||
          listAsrunLog2[i].telecastTime == "null" ){
          if(listAsrunLog2[i].bookingStatus == "B" ){
            listAsrunLog2[i].bookingStatus = "E";
          }else{
            continue;
          }
          update(['leftOne']);
      }else{
        continue;
      }
    }
  }

  unCancel(int index){
    for(int i=0;i<listAsrunLog2.length;i++){
      if(i == index){
        if(listAsrunLog2[index].telecastTime != null &&
            listAsrunLog2[index].telecastTime != "" &&
            listAsrunLog2[index].telecastTime != "null"
        ){
          listAsrunLog2[index].bookingStatus = "C";
          update(['leftOne']);
        }
        break;
      }else{
        continue;
      }
    }
  }



  showAll(){
    listAsrunLog2.clear();
    listAsrunLog1.clear();
    listAsrunLog2.addAll(masterListAsrunLog2);
    listAsrunLog1.addAll(masterListAsrunLog1);
    update(['leftOne']);
    update(['rightOne']);
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
              (DateFormat("dd-MM-yyyy").parse(scheduledController.text)).toString())).toString());
      print(">>>>$date");

      // ((Get.find<MainController>().user != null) ? Aes.encrypt(Get.find<MainController>().user?.personnelNo ?? "") : "")

      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.SALESAUDIT_NEW_GETRETRIEVE(
              selectedLocation!.key ?? "", selectedChannel!.key ?? "", date),
          fun: (map) {
            Get.back();
            print(">>>>>>>map${jsonEncode(map)}");
            listAsrunLog2.clear();
            listAsrunLog1.clear();
            masterListAsrunLog2.clear();
            masterListAsrunLog1.clear();
            if (map is Map && map.containsKey('gettables') && map['gettables'] != null) {
              // lstAsrunLog1.clear();
              // lstAsrunLog2.clear();
              salesAuditGetRetrieveModel = SalesAuditGetRetrieveModel.fromJson(map as Map<String,dynamic>);
              // masterListAsrunLog2.addAll(listAsrunLog2);
              // masterListAsrunLog1.addAll(listAsrunLog1);

              if(map['gettables']['lstAsrunlog1'] != null &&
                  map['gettables']['lstAsrunlog1'] != "null" && map['gettables']['lstAsrunlog1'].length >0){
                listAsrunLog1.addAll(salesAuditGetRetrieveModel!.gettables!.lstAsrunlog1 as Iterable<LstAsrunlog1>);
                masterListAsrunLog1.addAll(listAsrunLog1);
                update(['rightOne']);
              }
              if(map['gettables']['lstAsrunlog2'] != null &&
                  map['gettables']['lstAsrunlog2'] != "null" && map['gettables']['lstAsrunlog2'].length >0){

                if(showError.value == true && showCancel.value == true){
                  listAsrunLog2.addAll(salesAuditGetRetrieveModel!.gettables!.lstAsrunlog2 as Iterable<LstAsrunlog2>);
                  masterListAsrunLog2.addAll(listAsrunLog2);
                }else if(showError.value == true){
                  listAsrunLog2.addAll(salesAuditGetRetrieveModel!.gettables!.lstAsrunlog2!.where((element) =>
                  element.bookingStatus.toString().toUpperCase() != "C").toList());
                  masterListAsrunLog2.addAll(listAsrunLog2);
                }else if(showCancel.value == true){
                  listAsrunLog2.addAll(salesAuditGetRetrieveModel!.gettables!.lstAsrunlog2!.where((element) =>
                  element.bookingStatus.toString().toUpperCase() != "E").toList());
                  masterListAsrunLog2.addAll(listAsrunLog2);
                }else{
                  listAsrunLog2.addAll(salesAuditGetRetrieveModel!.gettables!.lstAsrunlog2!.where((element) =>
                  element.bookingStatus.toString().toUpperCase() != "C" && element.bookingStatus.toString().toUpperCase() != "E").toList());
                  masterListAsrunLog2.addAll(listAsrunLog2);
                }
                update(['leftOne']);
              }
              update(['text']);
            }
            else {
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

  saveData() {
    // tblSpots - listAsrunLog2 - leftIndex
    // tblAsrun - listAsrunLog1 - rightindex
    // masterListAsrunLog2.clear();
    // masterListAsrunLog1.clear();

    LoadingDialog.call();
    Map<String, dynamic> postData = {
      "locationcode":  selectedLocation!.key,
      "channelcode": selectedChannel!.key,
      "loggedUsercode":Get.find<MainController>().user?.logincode??"",
      "date": DateFormat("yyyy-MM-ddTHH:mm:ss").format( DateFormat("dd-MM-yyyy").parse(scheduledController.text)),
      "lstspots":masterListAsrunLog2.map((e) => e.toJson1()).toList(),
      "lstasrun": masterListAsrunLog1.map((e) => e.toJson1()).toList()
    };

    print(">>>>>>postData${jsonEncode(postData)}");
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.SALESAUDIT_NEW_SAVEDATA,
        json: postData,
        fun: (map) {
          Get.back();
          print(">>>>>map$map");
          if(map is Map && map.containsKey("postSalesAduit")){
            LoadingDialog.callDataSavedMessage((map['postSalesAduit']??""),
                callback: (){
              // clearAll();
                  Get.back();
            });
          }else{
            Snack.callError("Something went wrong\nPlease try After Sometime");
          }

        });
  }

  clearAll() {
    Get.delete<SalesAuditNewController>();
    Get.find<HomeController>().clearPage1();
  }

  void Domatch(int rightIndex) {

    String Exporttapecode, FPCtime, TApeduration, BookingNumber, BookingDetailcode, TelecastTime;

    List<String> ros;

    String ? RosStart, RosEnd, MidRosStart, MidRosEnd;

    bool IsRos;
    DateTime ?RosStartParse ;
    DateTime ?RosEndParse ;


    Exporttapecode = listAsrunLog1[rightIndex].exportTapeCode??"";

    FPCtime = listAsrunLog1[rightIndex].fpctime!;

    TApeduration = listAsrunLog1[rightIndex].tapeDuration.toString();

    TelecastTime = listAsrunLog1[rightIndex].telecastTime??"";


    BookingNumber = listAsrunLog1[rightIndex].bookingNumber??"";

    BookingDetailcode = listAsrunLog1[rightIndex].bookingDetailCode.toString();

    // tblSpots - listAsrunLog2 - leftIndex
    // tblAsrun - listAsrunLog1 - rightindex
    if (BookingNumber != "" && BookingNumber != null) {
      // leftIndex
      for (int i=0;i<listAsrunLog2.length;i++) {

        if (listAsrunLog2[i].bookingNumber == BookingNumber &&
            listAsrunLog2[i].bookingDetailCode == BookingDetailcode) {

          // gridStateManager?.setGridMode(PlutoGridMode.select) ;

          gridStateManager?.setCurrentCell(gridStateManager?.rows[i].cells["no"], i) ;
          // gridStateManagerRight?.rows[Dr.sortIdx].Selected = true;

          // gridStateManagerRight.FirstDisplayedScrollingRowIndex = Dr.Index;

          // Dr.Selected = true;

          return;

        }

      }

    }


    for (int j=0;j<listAsrunLog2.length;j++) {

      if (listAsrunLog2[j].dealTime != "") {

        IsRos = true;

        ros = listAsrunLog2[j].dealTime.toString().split("-");

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

      }
      else {

        IsRos = false;

      }
      // Non ROs check

      if (listAsrunLog2[j].telecastTime.toString() == "" &&
          listAsrunLog2[j].exportTapeCode == Exporttapecode &&
          listAsrunLog2[j].tapeDuration == TApeduration &&
          DateTime.parse("2023-01-01 ${listAsrunLog2[j].scheduleTime}").
          difference(DateTime.parse("2023-01-01 $FPCtime")).inMinutes.abs() <= 4 && !IsRos) {

        // tblSpots.SelectionMode = DataGridViewSelectionMode.FullRowSelect;
        //
        // tblSpots.Rows[Dr.Index].Selected = true;
        //
        // tblSpots.FirstDisplayedScrollingRowIndex = Dr.Index;
        //
        // Dr.Selected = true;
        //
        // if (ControlDwn) btnMap_Click(null, null);
        btnMap_Click(rightIndex,j);

        return;

      }

    }


    for (int k=0;k<listAsrunLog2.length;k++) {

      if (listAsrunLog2[k].dealTime != "") {

        IsRos = true;

        ros = listAsrunLog2[k].dealTime.toString().split("-");

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

      }
      else {

        IsRos = false;

      }
      // DateTime.parse("2023-01-01 ${TelecastTime}")

      if (listAsrunLog2[k].telecastTime.toString() == "" &&
          listAsrunLog2[k].exportTapeCode == Exporttapecode &&
          listAsrunLog2[k].tapeDuration == TApeduration && IsRos) {

        if (( DateTime.parse("2023-01-01 ${TelecastTime}").compareTo(RosStartParse!) > 0
            && DateTime.parse("2023-01-01 ${TelecastTime}").compareTo(DateTime.parse("2023-01-01 ${MidRosEnd}")) < 0) ||
            (DateTime.parse("2023-01-01 ${TelecastTime}").compareTo(DateTime.parse("2023-01-01 ${MidRosStart}")) > 0
                && DateTime.parse("2023-01-01 ${TelecastTime}").compareTo(DateTime.parse("2023-01-01 ${MidRosEnd}")) < 0)) {

          //tblSpots.SelectionMode = DataGridViewSelectionMode.FullRowSelect;

          // tblSpots.Rows[Dr.Index].Selected = true;
          //
          // tblSpots.FirstDisplayedScrollingRowIndex = Dr.Index;
          //
          // Dr.Selected = true;
          //
          // //tblSpots
          //
          // if (ControlDwn) btnMap_Click(null, null);
          btnMap_Click(rightIndex,k);

          return;

        }

      }

    }

  }

  SetNextRow(int rightindex,int leftIndex){
    rightindex= rightindex + 1;
    leftIndex= leftIndex + 1;
    gridStateManager?.setCurrentCell(gridStateManager?.rows[leftIndex].cells["no"],leftIndex) ;
    gridStateManagerRight?.setCurrentCell(gridStateManager?.rows[rightindex].cells["no"],rightindex) ;

    print(">>>>>${gridStateManagerRight!.currentRowIdx}");
    print(">>>>>${gridStateManager!.currentRowIdx}");

  }
  void setNextRow1(String exportTapeCode) {
    // tblSpots - listAsrunLog2 - leftIndex
    // tblAsrun - listAsrunLog1 - rightindex

    print("exportTapeCode$exportTapeCode");
    for (int i=0;i<listAsrunLog2.length;i++) {
      // print(">>>>>>>>>>"+listAsrunLog2[i].exportTapeCode.toString()+exportTapeCode);
      if (listAsrunLog2[i].exportTapeCode == exportTapeCode &&
         ( ((listAsrunLog2[i].telecastTime ?? "") == "") || listAsrunLog2[i].telecastTime == null) ) {
        print("searchIndex$i");
        // tblSpots.rows[dr.index].selected = true;
        gridStateManager?.setCurrentCell(gridStateManager?.rows[i].cells["no"],i) ;

        break;
      }
    }

    for (int j=0;j<listAsrunLog1.length;j++) {
      // print(">>>>>>>>>>"+listAsrunLog1[j].exportTapeCode.toString()+exportTapeCode);
      if (listAsrunLog1[j].exportTapeCode == exportTapeCode &&
         ( ((listAsrunLog1[j].bookingNumber ?? "") == "") || listAsrunLog1[j].bookingNumber == null) ) {
        // tblAsrun.rows[dr1.index].selected = true;
        print("searchIndex$j");
        gridStateManagerRight?.setCurrentCell(gridStateManager?.rows[j].cells["no"],j) ;
        break;
      }
    }
  }
  void btnAuto_Click() {
    for (int i=0;i<listAsrunLog1.length;i++) {
      // ControlDwn = true;
      // gridStateManagerRight.rows[dr.Index].Cells[1].Selected = true;
      // Domatch(dr.Index);
      // ControlDwn = false;
      Domatch(i);
    }
       // colorGrid();
  }



  void btnMap_Click(int rightindex,int leftIndex) {
    String exporttapecode, FPCtime, TApeduration, Telecasttime;
    bool Matched = false;
    String programCode, rowNumber;
    print("jks3");
    // tblAsrun.CurrentRow.Selected = true;
    // right table
    exporttapecode = listAsrunLog1[rightindex].exportTapeCode??"";
    programCode = listAsrunLog1[rightindex].programCode??"";
    rowNumber = (listAsrunLog1[rightindex].rownumber ??"").toString();
    FPCtime = listAsrunLog1[rightindex].fpctime??"";
    TApeduration = (listAsrunLog1[rightindex].tapeDuration??"").toString();
    Telecasttime = listAsrunLog1[rightindex].telecastTime??"";

    print(">>>>>>>>>${listAsrunLog1[rightindex].bookingNumber}");
    print(">>>>>>>>>${listAsrunLog2[leftIndex].telecastTime}");
    if (listAsrunLog1[rightindex].bookingNumber != null && listAsrunLog1[rightindex].bookingNumber != "") {
      print("jks1");
      // SetNextRow(rightindex,leftIndex);
      setNextRow1(exporttapecode);
      return;
    }
    if (listAsrunLog2[leftIndex].telecastTime != null && listAsrunLog2[leftIndex].telecastTime != "") {
      print("jks2");
      // SetNextRow(rightindex,leftIndex);
      setNextRow1(exporttapecode);
      return;
    }
   // tblSpots - listAsrunLog2 - leftIndex
   // tblAsrun - listAsrunLog1 - rightindex

    if (exporttapecode.trim() == listAsrunLog2[leftIndex].exportTapeCode.toString().trim() &&
        TApeduration == listAsrunLog2[leftIndex].tapeDuration.toString() &&
        listAsrunLog2[leftIndex].dealTime != "") {

      listAsrunLog2[leftIndex].telecastTime = Telecasttime;
      listAsrunLog2[leftIndex].programCode = programCode;
      listAsrunLog2[leftIndex].rowNumber = int.parse(rowNumber);

      listAsrunLog1[rightindex].bookingNumber = listAsrunLog2[leftIndex].bookingNumber;
      listAsrunLog1[rightindex].bookingDetailCode = listAsrunLog2[leftIndex].bookingDetailCode;
      listAsrunLog1[rightindex].remark = listAsrunLog2[leftIndex].bookingNumber??"" + "-" +
          (listAsrunLog2[leftIndex].bookingDetailCode??"").toString();

     /* tblAsrun.SelectedRows[0]["BookingDetailCode"] = tblSpots.SelectedRows[0]["BookingDetailCode"];
      tblAsrun.SelectedRows[0]["remark"] = tblSpots.SelectedRows[0]["Bookingnumber"] + "-" +
          tblSpots.SelectedRows[0]["BookingDetailCode"];*/
      Matched = true;
      update(['leftOne','rightOne']);
    }

    if (exporttapecode.trim() == listAsrunLog2[leftIndex].exportTapeCode.toString().trim() &&
        TApeduration == listAsrunLog2[leftIndex].tapeDuration.toString() &&
        listAsrunLog2[leftIndex].dealTime == "" &&
        listAsrunLog2[leftIndex].scheduleTime == FPCtime &&
        !Matched) {
      listAsrunLog2[leftIndex].telecastTime = Telecasttime;
      listAsrunLog2[leftIndex].programCode = programCode;
      listAsrunLog2[leftIndex].rowNumber = int.parse(rowNumber);

      listAsrunLog1[rightindex].bookingNumber = listAsrunLog2[leftIndex].bookingNumber;
      listAsrunLog1[rightindex].bookingDetailCode = listAsrunLog2[leftIndex].bookingDetailCode;
      listAsrunLog1[rightindex].remark =  listAsrunLog2[leftIndex].bookingNumber??"" + "-" +
          (listAsrunLog2[leftIndex].bookingDetailCode??"").toString();

     /* tblAsrun.SelectedRows[0]["BookingDetailCode"] = tblSpots.SelectedRows[0]["BookingDetailCode"];
      tblAsrun.SelectedRows[0]["remark"] = tblSpots.SelectedRows[0]["Bookingnumber"] + "-"
          + tblSpots.SelectedRows[0]["BookingDetailCode"];*/

      Matched = true;
      update(['leftOne','rightOne']);
    }

    if (!Matched && exporttapecode.trim() == listAsrunLog2[leftIndex].exportTapeCode.toString().trim()) {
      LoadingDialog.recordExists(
          "Only the Tapeid Matches!\nDo you want to force match these spots?",
              (){
                listAsrunLog2[leftIndex].telecastTime = Telecasttime;
                listAsrunLog2[leftIndex].programCode = programCode;
                listAsrunLog2[leftIndex].rowNumber = int.parse(rowNumber) ;
                listAsrunLog1[rightindex].bookingNumber = listAsrunLog2[leftIndex].bookingNumber;
                listAsrunLog1[rightindex].bookingDetailCode = listAsrunLog2[leftIndex].bookingDetailCode;
                /*listAsrunLog1[rightindex].remark = listAsrunLog2[leftIndex].bookingDetailCode;
                tblAsrun.SelectedRows[0]["BookingDetailCode"] = tblSpots.SelectedRows[0]["BookingDetailCode"];*/
                listAsrunLog1[rightindex].remark = listAsrunLog2[leftIndex].bookingNumber??"" + "-" +
                    (listAsrunLog2[leftIndex].bookingDetailCode??"").toString();
                update(['leftOne','rightOne']);
              },
          cancel: (){
            Get.back();
          });
    }



    // SetNextRow(rightindex,leftIndex);
    // colorGrid();
    setNextRow1(exporttapecode);
  }

  void btnMap_Click1(int rightindex,int leftIndex) {
    String exporttapecode, FPCtime, TApeduration, Telecasttime;
    bool Matched = false;
    String programCode, rowNumber;
    print("jks3");
    // tblAsrun.CurrentRow.Selected = true;
    // right table
    exporttapecode = listAsrunLog1[rightindex].exportTapeCode??"";
    programCode = listAsrunLog1[rightindex].programCode??"";
    rowNumber = (listAsrunLog1[rightindex].rownumber ??"").toString();
    FPCtime = listAsrunLog1[rightindex].fpctime??"";
    TApeduration = (listAsrunLog1[rightindex].tapeDuration??"").toString();
    Telecasttime = listAsrunLog1[rightindex].telecastTime??"";

    print(">>>>>>>>>${listAsrunLog1[rightindex].bookingNumber}");
    print(">>>>>>>>>${listAsrunLog2[leftIndex].telecastTime}");
    if (listAsrunLog1[rightindex].bookingNumber != null && listAsrunLog1[rightindex].bookingNumber != "") {
      print("jks1");
      // SetNextRow(rightindex,leftIndex);
      // setNextRow1(exporttapecode);
      return;
    }
    if (listAsrunLog2[leftIndex].telecastTime != null && listAsrunLog2[leftIndex].telecastTime != "") {
      print("jks2");
      // SetNextRow(rightindex,leftIndex);
      // setNextRow1(exporttapecode);
      return;
    }
    // tblSpots - listAsrunLog2 - leftIndex
    // tblAsrun - listAsrunLog1 - rightindex

    if (exporttapecode.trim() == listAsrunLog2[leftIndex].exportTapeCode.toString().trim() &&
        TApeduration == listAsrunLog2[leftIndex].tapeDuration.toString() &&
        listAsrunLog2[leftIndex].dealTime != "") {

      listAsrunLog2[leftIndex].telecastTime = Telecasttime;
      listAsrunLog2[leftIndex].programCode = programCode;
      listAsrunLog2[leftIndex].rowNumber = int.parse(rowNumber);

      listAsrunLog1[rightindex].bookingNumber = listAsrunLog2[leftIndex].bookingNumber;
      listAsrunLog1[rightindex].bookingDetailCode = listAsrunLog2[leftIndex].bookingDetailCode;
      listAsrunLog1[rightindex].remark = listAsrunLog2[leftIndex].bookingNumber??"" + "-" +
          (listAsrunLog2[leftIndex].bookingDetailCode??"").toString();

      /* tblAsrun.SelectedRows[0]["BookingDetailCode"] = tblSpots.SelectedRows[0]["BookingDetailCode"];
      tblAsrun.SelectedRows[0]["remark"] = tblSpots.SelectedRows[0]["Bookingnumber"] + "-" +
          tblSpots.SelectedRows[0]["BookingDetailCode"];*/
      Matched = true;
      update(['leftOne','rightOne']);
    }

    if (exporttapecode.trim() == listAsrunLog2[leftIndex].exportTapeCode.toString().trim() &&
        TApeduration == listAsrunLog2[leftIndex].tapeDuration.toString() &&
        listAsrunLog2[leftIndex].dealTime == "" &&
        listAsrunLog2[leftIndex].scheduleTime == FPCtime &&
        !Matched) {
      listAsrunLog2[leftIndex].telecastTime = Telecasttime;
      listAsrunLog2[leftIndex].programCode = programCode;
      listAsrunLog2[leftIndex].rowNumber = int.parse(rowNumber);

      listAsrunLog1[rightindex].bookingNumber = listAsrunLog2[leftIndex].bookingNumber;
      listAsrunLog1[rightindex].bookingDetailCode = listAsrunLog2[leftIndex].bookingDetailCode;
      listAsrunLog1[rightindex].remark =  listAsrunLog2[leftIndex].bookingNumber??"" + "-" +
          (listAsrunLog2[leftIndex].bookingDetailCode??"").toString();

      /* tblAsrun.SelectedRows[0]["BookingDetailCode"] = tblSpots.SelectedRows[0]["BookingDetailCode"];
      tblAsrun.SelectedRows[0]["remark"] = tblSpots.SelectedRows[0]["Bookingnumber"] + "-"
          + tblSpots.SelectedRows[0]["BookingDetailCode"];*/

      Matched = true;
      update(['leftOne','rightOne']);
    }

    if (!Matched && exporttapecode.trim() == listAsrunLog2[leftIndex].exportTapeCode.toString().trim()) {
      LoadingDialog.recordExists(
          "Only the Tapeid Matches!\nDo you want to force match these spots?",
              (){
            listAsrunLog2[leftIndex].telecastTime = Telecasttime;
            listAsrunLog2[leftIndex].programCode = programCode;
            listAsrunLog2[leftIndex].rowNumber = int.parse(rowNumber) ;
            listAsrunLog1[rightindex].bookingNumber = listAsrunLog2[leftIndex].bookingNumber;
            listAsrunLog1[rightindex].bookingDetailCode = listAsrunLog2[leftIndex].bookingDetailCode;
            /*listAsrunLog1[rightindex].remark = listAsrunLog2[leftIndex].bookingDetailCode;
                tblAsrun.SelectedRows[0]["BookingDetailCode"] = tblSpots.SelectedRows[0]["BookingDetailCode"];*/
            listAsrunLog1[rightindex].remark = listAsrunLog2[leftIndex].bookingNumber??"" + "-" +
                (listAsrunLog2[leftIndex].bookingDetailCode??"").toString();
            update(['leftOne','rightOne']);
          },
          cancel: (){
            Get.back();
          });
    }



    // SetNextRow(rightindex,leftIndex);
    // colorGrid();
    // setNextRow1(exporttapecode);
  }

  onDoubleTap(int leftIndex,int rightIndex){
    // masterListAsrunLog2.clear();
    // masterListAsrunLog1.clear();
    // masterListAsrunLog2.addAll(listAsrunLog2);
    // masterListAsrunLog1.addAll(listAsrunLog1);
    listAsrunLog2.clear();
    listAsrunLog1.clear();
    for(int i=0;i<masterListAsrunLog2.length;i++){
      if(masterListAsrunLog2[leftIndex].exportTapeCode == masterListAsrunLog2[i].exportTapeCode){
        listAsrunLog2.add(masterListAsrunLog2[i]);
      }
    }
    for(int i=0;i<masterListAsrunLog1.length;i++){
      if(masterListAsrunLog1[rightIndex].exportTapeCode == masterListAsrunLog1[i].exportTapeCode){
        listAsrunLog1.add(masterListAsrunLog1[i]);
      }
    }
    update(['leftOne']);
    update(['rightOne']);
  }
  List<LstAsrunlog1> masterUnMatchListAsrunLog1 = [];
  List<LstAsrunlog2> masterUnMatchListAsrunLog2 = [];
  void unMatchBtn(){
    listAsrunLog2.clear();
    listAsrunLog1.clear();
    for(int i=0;i<masterListAsrunLog2.length;i++){
      if( masterListAsrunLog2[i].telecastTime == "" ||  masterListAsrunLog2[i].telecastTime == null){
        listAsrunLog2.add(masterListAsrunLog2[i]);
      }
    }
    for(int i=0;i<masterListAsrunLog1.length;i++){
      if( masterListAsrunLog1[i].bookingNumber == "" || masterListAsrunLog1[i].bookingNumber == null){
        listAsrunLog1.add(masterListAsrunLog1[i]);
      }
    }
    update(['leftOne']);
    update(['rightOne']);

  }

  List<RoCancellationDocuments> documents = [];

  docs() async {
    String documentKey = "";
    if(selectedLocation == null || selectedChannel == null){
      documentKey = "";
    }else{
      documentKey = "SalesAudit " + (selectedLocation?.key??"") + (selectedChannel?.key??"") + '0' +DateFormat("yyyyMMdd").format( DateFormat("dd-MM-yyyy").parse(scheduledController.text)) ;
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
    print(">>>>jks>>>>>${Get.find<MainController>().user!.logincode}");
    fetchPageLoadData();
    leftFocusNode.addListener(() {
      if(leftFocusNode.hasFocus){
        leftTblFocus = true;
      }else{
        leftTblFocus = false;
      }
    });
    rightFocusNode.addListener(() {
      if(rightFocusNode.hasFocus){
        rightTblFocus = true;
      }else{
        rightTblFocus = false;
      }
    });
    super.onInit();
  }





  @override
  void onReady() {
    super.onReady();
  }
  formHandler(String str){
    if (str == "Clear") {
      clearAll();
    }else if (str == "Save") {
      saveData();
    }else if (str == "Docs") {
      docs();
    }
  }
  @override
  void onClose() {}
  void increment() => count.value++;
}

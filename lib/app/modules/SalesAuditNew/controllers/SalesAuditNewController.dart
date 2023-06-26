import 'dart:convert';

import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/PlutoGrid/src/manager/pluto_grid_state_manager.dart';
import '../../../../widgets/Snack.dart';
import '../../../controller/ConnectorControl.dart';
import '../../../controller/HomeController.dart';
import '../../../controller/MainController.dart';
import '../../../providers/ApiFactory.dart';
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

  DropDownValue? selectedLocation;
  DropDownValue? selectedChannel;
  PlutoGridStateManager? gridStateManager;
  PlutoGridStateManager? gridStateManagerRight;
  SalesAuditGetRetrieveModel? salesAuditGetRetrieveModel = null;
  List<LstAsrunlog1> listAsrunLog1 = [];
  List<LstAsrunlog2> listAsrunLog2 = [];
  int? selectedIndex = 0;
  int? selectedRightIndex = 0;

  fetchPageLoadData() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.SALESAUDIT_NEW_LOAD,
        fun: (Map map) {
          locationList.clear();
          if (map is Map &&
              map.containsKey("listlocations") &&
              map['listlocations'].length > 0) {
            map['listlocations'].forEach((e) {
              locationList.add(DropDownValue.fromJsonDynamic(
                  e, "locationCode", "locationName"));
            });
          }
        });
  }

  fetchListOfChannel(String code) {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.SALESAUDIT_NEW_GETCHANNEL + code,
        fun: (Map map) {
          channelList.clear();
          print(">>>>jks" + map.toString());
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



  filterSearchAndCancel(){
    if(salesAuditGetRetrieveModel != null){
      listAsrunLog2.clear();
      if(showError.value == true && showCancel.value == true){
        listAsrunLog2.addAll(salesAuditGetRetrieveModel!.gettables!.lstAsrunlog2 as Iterable<LstAsrunlog2>);
      }else if(showError.value == true){
        listAsrunLog2.addAll(salesAuditGetRetrieveModel!.gettables!.lstAsrunlog2!.where((element) =>
        element.bookingStatus.toString().toUpperCase() != "C").toList());
      }else if(showCancel.value == true){
        listAsrunLog2.addAll(salesAuditGetRetrieveModel!.gettables!.lstAsrunlog2!.where((element) =>
        element.bookingStatus.toString().toUpperCase() != "E").toList());
      }else{
        listAsrunLog2.addAll(salesAuditGetRetrieveModel!.gettables!.lstAsrunlog2!.where((element) =>
        element.bookingStatus.toString().toUpperCase() != "C" && element.bookingStatus.toString().toUpperCase() != "E").toList());
      }
      update(['leftOne']);
    }else{
      listAsrunLog2.clear();
      update(['leftOne']);
    }

  }

  markError(int index){
      for(int i=0;i<listAsrunLog2.length;i++){
        if(i == index){
          if(listAsrunLog2[index].bookingStatus  != "E"){
            listAsrunLog2[index].previousBookingStatus =  listAsrunLog2[index].bookingStatus;
            listAsrunLog2[index].bookingStatus = "E";
          }else{
            listAsrunLog2[index].bookingStatus = listAsrunLog2[index].previousBookingStatus;
          }
          // gridStateManager?.setCurrentCell(gridStateManager?.rows[index].cells[0], index) ;
          update(['leftOne']);
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
      print(">>>>" + date.toString());

      // ((Get.find<MainController>().user != null) ? Aes.encrypt(Get.find<MainController>().user?.personnelNo ?? "") : "")

      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.SALESAUDIT_NEW_GETRETRIEVE(
              selectedLocation!.key ?? "", selectedChannel!.key ?? "", date),
          fun: (Map<String, dynamic> map) {
            Get.back();
            print(">>>>>>>map" + jsonEncode(map).toString());
            listAsrunLog2.clear();
            listAsrunLog1.clear();
            if (map is Map && map.containsKey('gettables') && map['gettables'] != null) {
              // lstAsrunLog1.clear();
              // lstAsrunLog2.clear();
              salesAuditGetRetrieveModel = SalesAuditGetRetrieveModel.fromJson(map);

              if(map['gettables']['lstAsrunlog1'] != null &&
                  map['gettables']['lstAsrunlog1'] != "null" && map['gettables']['lstAsrunlog1'].length >0){
                listAsrunLog1.addAll(salesAuditGetRetrieveModel!.gettables!.lstAsrunlog1 as Iterable<LstAsrunlog1>);
                update(['rightOne']);
              }
              if(map['gettables']['lstAsrunlog2'] != null &&
                  map['gettables']['lstAsrunlog2'] != "null" && map['gettables']['lstAsrunlog2'].length >0){

                if(showError.value == true && showCancel.value == true){
                  listAsrunLog2.addAll(salesAuditGetRetrieveModel!.gettables!.lstAsrunlog2 as Iterable<LstAsrunlog2>);
                }else if(showError.value == true){
                  listAsrunLog2.addAll(salesAuditGetRetrieveModel!.gettables!.lstAsrunlog2!.where((element) =>
                  element.bookingStatus.toString().toUpperCase() != "C").toList());
                }else if(showCancel.value == true){
                  listAsrunLog2.addAll(salesAuditGetRetrieveModel!.gettables!.lstAsrunlog2!.where((element) =>
                  element.bookingStatus.toString().toUpperCase() != "E").toList());
                }else{
                  listAsrunLog2.addAll(salesAuditGetRetrieveModel!.gettables!.lstAsrunlog2!.where((element) =>
                  element.bookingStatus.toString().toUpperCase() != "C" && element.bookingStatus.toString().toUpperCase() != "E").toList());
                }
                update(['leftOne']);
              }
              update(['text']);
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

  saveData() {
    Map<String, dynamic> postData = {
      "locationcode":  selectedLocation!.key,
      "channelcode": selectedChannel!.key,
      "loggedUsercode": "VM9XX00001",
      "date": DateFormat("yyyy-MM-ddTHH:mm:ss").parse( DateFormat("dd-MM-yyyy").parse(scheduledController.text).toString()),
      "lstspots": [
        {
          "bookingNumber": "23033912W",
          "bookingDetailCode": 10,
          "telecastTime": null,
          "programCode": "",
          "tapeDuration": 3600,
          "bookingstatus": "B",
          "rowNumber": 0,
          "remarks": ""
        }
      ],
      "lstasrun": [
        {
          "telecasttime": null,
          "exporttapecode": "",
          "tapeduration": 0,
          "programCode": "",
          "remark": ""
        }
      ]
    };
  }

  clearAll() {
    Get.delete<SalesAuditNewController>();
    Get.find<HomeController>().clearPage1();
  }

  @override
  void onInit() {
    print(">>>>jks>>>>>" + Get.find<MainController>().user!.logincode .toString());
    fetchPageLoadData();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }
  formHandler(String str){
    if (str == "Clear") {
      clearAll();
    }
  }
  @override
  void onClose() {}
  void increment() => count.value++;
}

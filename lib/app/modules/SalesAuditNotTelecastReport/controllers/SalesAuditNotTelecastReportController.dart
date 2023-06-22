import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';
import 'package:intl/intl.dart';

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
import '../ChannelListModel.dart';
import '../SalesAuditNotTRLstChannelModel.dart';
import '../SalesAuditNotTelecastModel.dart';

class SalesAuditNotTelecastReportController extends GetxController {
  var locations = RxList<DropDownValue>();
  // var channelList = RxList<ChannelListModel>();

  List<ChannelListModel> channelList = [];
  List<ChannelListModel> channelListMaster = [];

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
  RxBool checked = RxBool(false);
  //input controllers
  DropDownValue? selectLocation;
  RxString selectValue=RxString("");
  ChannelListModel? channelListModel;
  bool chk_radnottel = false;
  bool chk_raderror = false;
  SalesAuditNotTRLstChannelModel? salesAuditNotTRLstChannelModel;
   getType(String name){
    if(name == 'Not telecasted'){
      chk_raderror=false;
      chk_radnottel = true;
    }else{
      chk_radnottel=false;
      chk_raderror =true;
    }

  }
  clearAll(){
    Get.delete<SalesAuditNotTelecastReportController>();
    Get.find<HomeController>().clearPage1();
  }

  @override
  void onInit() {
    fetchAllLoaderData();
    super.onInit();
  }
  List<Lstnottel>? listData = [];

  fetchAllLoaderData() {
    // LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.SALESAUDIT_NOT_TELECASTLOAD,
        // "https://jsonkeeper.com/b/D537"
        fun: (Map map) {
          // Get.back();
          // log(">>>>>>"+map.toString());
          if(map is Map && map.containsKey('pageload')){
            locations.clear();
            channelList.clear();
            if(map['pageload'].containsKey('lstlocation') &&
                map['pageload']['lstlocation'].length > 0 ){
                map['pageload']['lstlocation'].forEach((e){
                locations.add(DropDownValue.fromJsonDynamic(e, "locationCode", "locationName"));
              });
            }if(map['pageload'].containsKey('lstchannel') &&
                map['pageload']['lstchannel'].length > 0){
              map['pageload']['lstchannel'].forEach((e){
                channelList.add(new ChannelListModel(channelCode: e['channelCode'], channelName: e['channelName'],ischecked: false));
                channelListMaster.add(new ChannelListModel(channelCode: e['channelCode'], channelName: e['channelName'],ischecked: false));
              });
              update(['updateTable1']);
            }
          }
         
        });
  }
  search(String pattern){
    if(pattern != null && pattern != ""){
      channelList.clear();
      channelList.addAll(channelListMaster.where((element) =>
          element.channelName.toString().toLowerCase().contains(pattern.toString().toLowerCase())).toList()) ;
      update(['updateTable1']);
    }else{
      channelList.clear();
      channelList.addAll(channelListMaster);
      update(['updateTable1']);
    }


  }

  fetchGetGenerate(){
    List<ChannelListModel> channelListFilter=[];
    channelListFilter = channelList.where((element) =>
    element.ischecked == true).toList();
    if(selectLocation == null){
      Snack.callError("Please select location");
    }else if(channelListFilter.isEmpty){
      Snack.callError("Please select some channel");
    }else if(frmDate.text == null || frmDate.text == ""){
      Snack.callError("Please select from date");
    }else if(toDate.text == null || toDate.text == ""){
      Snack.callError("Please select to date");
    }else if(chk_radnottel == false && chk_raderror == false){
      Snack.callError("Please select not telecasted or Error Sports");
    }else{
      LoadingDialog.call();
      Map<String,dynamic> postData = {
        "lstChannelList": channelListFilter.map((e) => e.toJson1()).toList(),
        "locationcode": selectLocation!.key??"",
        // "channelCode": selectLocation!.key??"",
        "fromdate":DateFormat('yyyy-MM-ddTHH:mm:ss').format(
            DateFormat("dd-MM-yyyy").parse(frmDate.text)),
        "todate": DateFormat('yyyy-MM-ddTHH:mm:ss').format(
            DateFormat("dd-MM-yyyy").parse(toDate.text)),
        "chk_radnottel": chk_radnottel,
        "chk_raderror": chk_raderror
      };
      print(">>>>>postData>>>"+(postData).toString());
      Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.SALESAUDIT_NOT_TELECAST_GETGENERATE,
          json: postData,
          fun: (Map<String,dynamic> map) {
            Get.back();
            print("map>>>"+ jsonEncode(map).toString());
            if(map is Map && map.containsKey('generate')){
              listData!.clear();
              salesAuditNotTRLstChannelModel = SalesAuditNotTRLstChannelModel.fromJson(map) ;
              if(chk_radnottel){
                listData!.addAll(salesAuditNotTRLstChannelModel!.generate!.lstnottel as Iterable<Lstnottel>);
              }else{
                listData!.addAll(salesAuditNotTRLstChannelModel!.generate!.lsterror as Iterable<Lstnottel>);
              }
              update(['listUpdate']);
            }else{
              listData!.clear();
              update(['listUpdate']);
            }
          });
    }


  }




}

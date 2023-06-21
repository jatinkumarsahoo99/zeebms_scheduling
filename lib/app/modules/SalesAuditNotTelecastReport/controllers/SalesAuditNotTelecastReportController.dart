import 'dart:convert';
import 'dart:developer';

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
import '../ChannelListModel.dart';
import '../SalesAuditNotTelecastModel.dart';

class SalesAuditNotTelecastReportController extends GetxController {
  var locations = RxList<DropDownValue>();
  // var channelList = RxList<ChannelListModel>();

  List<ChannelListModel> channelList = [];

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

  bool getType(String name){
    if(name == 'Not telecasted'){
        return chk_radnottel;
    }else{
      return chk_raderror;
    }

  }

  @override
  void onInit() {
    fetchAllLoaderData();
    super.onInit();
  }


  fetchAllLoaderData() {
    // LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.SALESAUDIT_NOT_TELECASTLOAD,
        // "https://jsonkeeper.com/b/D537"
        fun: (Map map) {
          // Get.back();
          log(">>>>>>"+map.toString());
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
                channelList.add(new ChannelListModel(channelCode: e['channelCode'],
                    channelName: e['channelName'],ischecked: false));
              });
              update(['updateTable1']);
            }
          }
         
        });
  }

  fetchGetGenerate(){
    Map<String,dynamic> postData = {
      "lstchannelCheckbox": [
        {
          "channelCode": "ZAZEE00001",
          "ischecked": true
        }
      ],
      "locationcode": selectLocation!.key??"",
      "channelCode": "ZAZEE00001",
      "fromdate": "2022-01-01T00:00:00",
      "todate": "2022-01-17T00:00:00",
      "chk_radnottel": chk_radnottel,
      "chk_raderror": chk_raderror
    };
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.SALESAUDIT_NOT_TELECAST_GETGENERATE,
        json: {},
        fun: (Map map) {

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



}

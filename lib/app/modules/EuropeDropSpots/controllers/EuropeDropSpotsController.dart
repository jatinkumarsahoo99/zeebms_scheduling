import 'dart:convert';

import 'package:bms_scheduling/app/providers/Utils.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../controller/ConnectorControl.dart';
import '../../../data/DropDownValue.dart';
import '../../../providers/ApiFactory.dart';
import '../EuropeSpotModel.dart';

class EuropeDropSpotsController extends GetxController {
  //TODO: Implement EuropeDropSpotsController

  TextEditingController selectedDate = TextEditingController();
  TextEditingController selectedFrmDate = TextEditingController();
  TextEditingController selectedRemoveDate = TextEditingController();
  TextEditingController selectedToDate = TextEditingController();
  TextEditingController toNumber = TextEditingController();
  RxInt segmentedControlGroupValue = RxInt(0);

  final Map<int, Widget> myTabs = const <int, Widget>{
    0: Text("Dropped Spots"),
    1: Text("Remove Running Order"),
    2: Text("Delete Russia Commercial"),
  };
  double widthSize = 0.12;
  double widthSize1 = 0.17;

  RxList<DropDownValue> locationList = RxList([]);
  RxList<DropDownValue> loc = RxList([]);
  RxList<DropDownValue> locationCode = RxList([]);
  RxList<DropDownValue> channelList = RxList([]);
  RxList<DropDownValue> channelList1 = RxList([]);
  RxList<DropDownValue> channelList2 = RxList([]);
  RxList<DropDownValue> clientList = RxList([]);
  RxList<DropDownValue> agentList = RxList([]);

  RxList<DropDownValue> fileList = RxList([]);
  RxList<DropDownValue> fileList1 = RxList([]);

  DropDownValue? selectLocation;
  DropDownValue? selectChannel;
  DropDownValue? selectLocation_removeorder;
  DropDownValue? selectChannel_removeorder;
  DropDownValue? selectLocation_deleteRussia;
  DropDownValue? selectChannel_deleteRussia;
  DropDownValue? selectClient;
  DropDownValue? selectAgency;

  DropDownValue? selectFile;
  DropDownValue? selectFile1;
  PlutoGridStateManager? stateManager;

  EuropeSpotModel? europeSpotModel;

  @override
  void onInit() {
    getInitial();
    super.onInit();
  }

  getInitial() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.EUROPE_DROP_SPOTS_INITIAL(),
        fun: (Map map) {
          print("Location dta>>>" + jsonEncode(map));
          locationList.clear();
          loc.clear();
          locationCode.clear();
          map["location"].forEach((e) {
            locationList.add(DropDownValue.fromJsonDynamic(
                e, "locationCode", "locationName"));
          });
          map["loc"].forEach((e) {
            loc.add(DropDownValue.fromJsonDynamic(
                e, "locationCode", "locationName"));
          });
          map["locationcode"].forEach((e) {
            loc.add(DropDownValue.fromJsonDynamic(
                e, "locationCode", "locationName"));
          });
        });
  }

  getChannel(key, int val) {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.EUROPE_DROP_SPOTS_LOCATION(key),
        fun: (Map map) {
          print("Location dta>>>" + jsonEncode(map));
          switch (val) {
            case 1:
              channelList.clear();
              map["europeDrop"].forEach((e) {
                channelList.add(DropDownValue.fromJsonDynamic(
                    e, "channelCode", "channelName"));
              });
              break;
            case 2:
              channelList1.clear();
              map["europeDrop"].forEach((e) {
                channelList1.add(DropDownValue.fromJsonDynamic(
                    e, "channelCode", "channelName"));
              });
              break;
            case 3:
              channelList2.clear();
              map["europeDrop"].forEach((e) {
                channelList2.add(DropDownValue.fromJsonDynamic(
                    e, "channelCode", "channelName"));
              });
              break;
          }
        });
  }

  updateDetails(postMap) {
    LoadingDialog.call();
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.EUROPE_DROP_SPOTS_UPDATE_DETAILS(),
        json: postMap,
        fun: (map) {
          Get.back();
         if(map is Map && map.toString().contains("successfully")){
           LoadingDialog.callDataSavedMessage(
             "Spots Dropped Successfully",
           );
         }else{
           LoadingDialog.callInfoMessage(map.toString());
         }
        });
  }

  postRemoval() {
    LoadingDialog.call();
    var postMap = {
      "locationcode": selectLocation_removeorder?.key ?? "",
      "channelcode": selectChannel_removeorder?.key ?? "",
      "filename": selectFile?.key ?? ""
    };
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.EUROPE_DROP_SPOTS_POST_REMOVE_FILE(),
        json: postMap,
        fun: (map) {
          Get.back();
          if (map is Map &&
              map.containsKey("remove") &&
              map["remove"].toString().contains("successfully")) {
            LoadingDialog.callDataSavedMessage(
              map["remove"].toString(),
            );
          } else {
            LoadingDialog.callInfoMessage(map.toString());
          }
        });
  }

  getRunDate1() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.EUROPE_DROP_SPOTS_GETRUNDATE(
            selectLocation_removeorder?.key ?? "",
            selectChannel_removeorder?.key ?? "",
            Utils.dateFormatChange(
                    selectedRemoveDate.text, "dd-MM-yyyy", "yyyy-MM-dd") +
                "T00:00:00"),
        fun: (Map map) {
          fileList.clear();
          map["clientdtails"].forEach((e) {
            fileList.add(DropDownValue.fromJsonDynamic(
                e, "bookingReferenceNumber", "bookingReferenceNumber1"));
          });
        });
  }

  getClientList() {
    // LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.EUROPE_DROP_SPOTS_CHANNEL(
            selectLocation?.key ?? "", selectChannel?.key ?? ""),
        fun: (Map map) {
          // Get.back();
          // print("Location data>>>>" + jsonEncode(map));
          clientList.clear();
          map["clientdtails"].forEach((e) {
            clientList.add(
                DropDownValue.fromJsonDynamic(e, "clientcode", "clientname"));
          });
        });
  }

  getAgentList() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.EUROPE_DROP_SPOTS_CLIENT(selectLocation?.key ?? "",
            selectChannel?.key ?? "", selectClient?.key ?? ""),
        fun: (Map map) {
          agentList.clear();
          map["clientdtails"].forEach((e) {
            agentList.add(
                DropDownValue.fromJsonDynamic(e, "agencycode", "agencyname"));
          });
        });
  }

  postGenerate() {
    if (selectLocation == null) {
      LoadingDialog.callInfoMessage("Select location");
    } else if (selectChannel == null) {
      LoadingDialog.callInfoMessage("Select channel");
    } else if (selectClient == null) {
      LoadingDialog.callInfoMessage("Select client");
    } else if (selectAgency == null) {
      LoadingDialog.callInfoMessage("Select agency");
    } else {
      LoadingDialog.call();
      var postMap = {
        "locationcode": selectLocation?.key ?? "",
        "channelcode": selectChannel?.key ?? "",
        "clientcode": selectClient?.key ?? "",
        "agencycode": selectAgency?.key ?? "",
        "fromdate": Utils.dateFormatChange(
                selectedFrmDate.text, "dd-MM-yyyy", "yyyy-MM-dd") +
            "T00:00:00",
        "todate": Utils.dateFormatChange(
                selectedToDate.text, "dd-MM-yyyy", "yyyy-MM-dd") +
            "T00:00:00"
      };
      Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.EUROPE_DROP_SPOTS_GENERATE(),
          json: postMap,
          fun: (map) {
            Get.back();
            if (map is Map &&
                map.containsKey("generates") &&
                map["generates"] != null) {
              europeSpotModel =
                  EuropeSpotModel.fromJson(map as Map<String, dynamic>);
              update(["listUpdate"]);
            } else {
              LoadingDialog.callInfoMessage(map.toString());
            }
          });
    }
  }

  deleteCommercial() {
    LoadingDialog.call();
    var postMap = {
      "locationcode": selectLocation?.key ?? "",
      "channelcode": selectChannel?.key ?? "",
      "bookingnumber": toNumber.text
    };
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.EUROPE_DROP_SPOTS_DELETE(),
        json: postMap,
        fun: (map) {
          Get.back();
          if(map is Map && map.containsKey("update") && map["update"].toString().contains("successfully")){
            LoadingDialog.callDataSavedMessage(map["update"]);
          }else{
            LoadingDialog.callInfoMessage(map.toString());
          }
        });
  }

  void dropClick() {
    if (stateManager == null) {
      LoadingDialog.callInfoMessage("Table not available");
    } else {
      List<PlutoRow>? selectRows = stateManager?.checkedRows;
      if ((selectRows?.length ?? 0) > 0) {
        var postMap = {
          "lstBookingDetailsReq": selectRows?.map((e) {
            return {
              "bookingnumber": e.cells["toNumber"]?.value,
              "bookingdetailcode": int.tryParse(
                  e.cells["bookingDetailCode"]?.value.toString() ?? "0"),
            };
          }).toList(),
          "locationcode": selectLocation?.key ?? "",
          "channelcode": selectChannel?.key ?? ""
        };
        updateDetails(postMap);
      } else {
        LoadingDialog.callInfoMessage("You have not selected anything");
      }
    }
  }
}

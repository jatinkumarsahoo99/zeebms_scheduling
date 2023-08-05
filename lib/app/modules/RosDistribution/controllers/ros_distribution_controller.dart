// ignore_for_file: unused_import

import 'dart:convert';

import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/controller/MainController.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../widgets/CheckBoxWidget.dart';
import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/PlutoGrid/src/helper/pluto_move_direction.dart';
import '../../../../widgets/PlutoGrid/src/manager/pluto_grid_state_manager.dart';
import '../../../../widgets/PlutoGrid/src/pluto_grid.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../../widgets/input_fields.dart';
import '../../../../widgets/radio_row.dart';
import '../../../data/PermissionModel.dart';
import '../../../providers/Utils.dart';
import '../../../routes/app_pages.dart';
import '../../CommonSearch/views/common_search_view.dart';
import '../model/ros_show_model.dart';
import '../model/ros_cell_click_model.dart' as cellModel;

class RosDistributionController extends GetxController {
  DropDownValue? selectedLocation, selectedChannel;
  var location = <DropDownValue>[].obs, channel = <DropDownValue>[].obs;
  var date = TextEditingController();
  var locationFN = FocusNode();
  var enableControllos = true.obs;
  PlutoGridStateManager? mainGSM;
  List<PermissionModel>? formPermissions;

  var topButtons = <Map<String, dynamic>>[].obs;
  var showDataModel = ROSDistuibutionShowModel().obs;
  var tempShowDataModel = ROSDistuibutionShowModel();
  var selectedReportTab = "Client Wise".obs;
  var reportList = <dynamic>[].obs;

  var checkBoxes = [].obs;
  int mainGridIdx = 0;

  @override
  void onInit() {
    formPermissions = Utils.fetchPermissions1(Routes.ROS_DISTRIBUTION.replaceAll("/", ""));
    topButtons.value = [
      {"name": "Show", "callback": handleShowTap, "btnShowBucket": true, "isEnabled": true},
      {"name": "Empty", "callback": handleEmptyTap, "btnEmpty": true, "isEnabled": true},
      {"name": "Report", "callback": handleReportTap, "btnView": true, "isEnabled": true},
      {"name": "Allocate", "callback": handleAllocationTap, "btnAllocate": true, "isEnabled": true},
      {"name": "Un", "callback": handleUNTap, "btnUnalloacted": true, "isEnabled": true},
      {"name": "Service", "callback": handleServiceTap, "btnService": true, "isEnabled": true},
      {"name": "De Alloc", "callback": handleDeallocateTap, "btnRollback": true, "isEnabled": true},
      {"name": "FPC", "callback": handleFPCTap, "btnFPC": true, "isEnabled": true},
    ];
    checkBoxes.value = [
      {"name": "Show Open Deals", "value": false},
      {"name": "Show ROS Spots", "value": false},
      {"name": "Show Spot Buys", "value": false},
    ];
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    callInitailsAPI();
  }

  ///////////////////////// Check box on change bottom start/////////
  handleOnChangedInOpenDeals() {
    var openDealValue = (checkBoxes.value[0]['value'] as bool);
    if (openDealValue) {
      /// display only OPEN
      showDataModel.value.infoShowBucketList?.lstROSSpots?.removeWhere(
        (element) => ((element.dealTypeName?.toLowerCase() != "open")),
      );
      showDataModel.refresh();
    } else {
      showDataModel.value = ROSDistuibutionShowModel.fromJson(tempShowDataModel.toJson());
    }
  }

  handleOnChangedInROSSpots() {
    var rosSpotsValue = (checkBoxes.value[1]['value'] as bool);
    showDataModel.value = ROSDistuibutionShowModel.fromJson(tempShowDataModel.toJson());
    if (rosSpotsValue) {
      /// display only ros
      showDataModel.value.infoShowBucketList?.lstROSSpots?.removeWhere(
        (element) => ((element.sponsorTypeName?.toLowerCase() != "ros")),
      );
      showDataModel.refresh();
    }
  }

  handleOnChangedInSpotBuys() {
    var showSpotsValue = (checkBoxes.value[2]['value'] as bool);
    showDataModel.value = ROSDistuibutionShowModel.fromJson(tempShowDataModel.toJson());
    if (showSpotsValue) {
      /// display only spot boys
      showDataModel.value.infoShowBucketList?.lstROSSpots?.removeWhere(
        (element) => ((element.sponsorTypeName?.toLowerCase() != "spot buys")),
      );
      showDataModel.refresh();
    }
  }

  ///////////////////////// Check box on change bottom end/////////
  ///
  ///
  ///
  ///
  ///////////////////////////Head section button click start/////////
  handleShowTap() async {
    if (selectedLocation == null || selectedChannel == null) {
      LoadingDialog.showErrorDialog("Please select Location and Channel.");
    } else {
      LoadingDialog.call();
      await Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.RO_DISTRIBUTION_SHOW_DATA(
              selectedLocation!.key!, selectedChannel!.key!, DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy").parse(date.text))),
          fun: (resp) {
            closeDialogIfOpen();
            if (resp != null && resp is Map<String, dynamic> && resp['info_ShowBucketList'] != null) {
              enableControllos.value = false;
              mainGridIdx = 0;
              showDataModel.value = ROSDistuibutionShowModel.fromJson(resp);
              showDataModel.value.infoShowBucketList?.controlEnableTrue?.forEach((element) {
                topButtons.value = topButtons.value.map((e) {
                  if (!e.containsKey(element)) {
                    // e['isEnabled'] = false;
                  }
                  return e;
                }).toList();
              });
              update(['headRowBtn']);
              tempShowDataModel = ROSDistuibutionShowModel.fromJson(showDataModel.value.toJson());
            } else {
              LoadingDialog.showErrorDialog(resp.toString());
            }
          },
          failed: (resp) {
            closeDialogIfOpen();
            LoadingDialog.showErrorDialog(resp.toString());
          });
    }
  }

  void handleReportTap() {
    if (selectedLocation == null || selectedChannel == null) {
      LoadingDialog.showErrorDialog("Please select Location and Channel.");
      return;
    }
    reportList.clear();
    selectedReportTab.value = "Client Wise";
    Future.delayed(const Duration(seconds: 1)).then((value) {
      handleOnChangedTapInReport(selectedReportTab.value);
      return null;
    });
    showDialog(
      context: Get.context!,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: SizedBox(
            width: Get.width * 80,
            height: Get.width * 8,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(
                          () {
                            return RadioRow(
                              items: const ['Client Wise', 'Client & Brand Wise', 'Client Pivot', 'Brand Pivot', 'Zone Wise', 'Zone & Time'],
                              groupValue: selectedReportTab.value,
                              onchange: handleOnChangedTapInReport,
                            );
                          },
                        ),
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Colors.black,
                          ),
                          splashRadius: 23,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Obx(() {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: reportList.isEmpty ? BoxDecoration(border: Border.all(color: Colors.grey)) : null,
                        child: reportList.isEmpty
                            ? null
                            : DataGridFromMap(
                                mapData: reportList.value,
                                onSelected: (row) {},
                                onRowDoubleTap: (row) {
                                  showDataModel.value.infoShowBucketList?.lstROSSpots?.clear();
                                  showDataModel.value.infoShowBucketList?.lstROSSpots
                                      ?.addAll(tempShowDataModel.infoShowBucketList?.lstROSSpots?.toList() ?? []);
                                  if (selectedReportTab.value == "Zone Wise" || selectedReportTab.value == "Client Pivot") {
                                    showDataModel.value.infoShowBucketList?.lstROSSpots?.removeWhere((element) =>
                                        element.clientName.toString().trim() != reportList.value[row.rowIdx]['ClientName'].toString().trim());
                                    Get.back();
                                  } else if (selectedReportTab.value != "Client & Brand Wise" || selectedReportTab.value != "Brand Pivot") {
                                    showDataModel.value.infoShowBucketList?.lstROSSpots?.removeWhere((element) =>
                                        element.clientName.toString().trim() != reportList.value[row.rowIdx]['ClientName'].toString().trim() &&
                                        element.brandname.toString().trim() != reportList.value[row.rowIdx]['BrandName'].toString().trim());
                                    Get.back();
                                  } else if (selectedReportTab.value == "Zone Wise") {
                                    showDataModel.value.infoShowBucketList?.lstROSSpots?.removeWhere((element) =>
                                        element.allocatedSpot.toString().trim() != reportList.value[row.rowIdx]['zonename'].toString().trim());
                                  } else if (selectedReportTab.value == "Zone & Time") {
                                    showDataModel.value.infoShowBucketList?.lstROSSpots
                                        ?.removeWhere((element) => element.allocatedSpot.toString().trim() != "");
                                  }
                                  showDataModel.refresh();
                                },
                                mode: PlutoGridMode.selectWithOneTap,
                              ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void handleOnChangedTapInReport(String newVal) {
    selectedReportTab.value = newVal;
    LoadingDialog.call();
    Get.find<ConnectorControl>().POSTMETHOD(
      api: ApiFactory.RO_DISTRIBUTION_GET_RETRIVE_DATA,
      fun: (resp) {
        closeDialogIfOpen();
        if (resp != null && resp is Map<String, dynamic> && resp['info_Views'] != null) {
          if (resp['info_Views']['lstdgvAllocationReport'] != null &&
              (resp['info_Views']['lstdgvAllocationReport'] is List<dynamic>) &&
              (resp['info_Views']['lstdgvAllocationReport'] as List<dynamic>).isNotEmpty) {
            reportList.value = resp['info_Views']['lstdgvAllocationReport'];
          } else {
            LoadingDialog.showErrorDialog("No data found.");
          }
        } else {
          LoadingDialog.showErrorDialog(resp.toString());
        }
      },
      json: {
        "rbClientWise": newVal == "Client Wise",
        "rbClientBrandWise": newVal == "Client & Brand Wise",
        "rbClientPivot": newVal == "Client Pivot",
        "optBrandPivot": newVal == "Brand Pivot",
        "optZoneWise": newVal == "Zone Wise",
        "optZoneTime": newVal == "Zone & Time",
        "lstROSSpots": tempShowDataModel.infoShowBucketList?.lstROSSpots?.map((e) => e.toJson()).toList() ?? [],
      },
    );
  }

  void handleEmptyTap() {
    if (selectedChannel == null || selectedLocation == null) {
      return;
    }
    LoadingDialog.call();
    Get.find<ConnectorControl>().POSTMETHOD(
      api: ApiFactory.RO_DISTRIBUTION_GET_EMPTY_DATA,
      fun: (resp) {
        closeDialogIfOpen();
        if (resp != null && resp is Map<String, dynamic> && resp['info_GetEmptyList'] != null) {
          if (resp['info_GetEmptyList']['lstROSSpots'] != null &&
              (resp['info_GetEmptyList']['lstROSSpots'] is List<dynamic>) &&
              (resp['info_GetEmptyList']['lstROSSpots'] as List<dynamic>).isNotEmpty) {
            var tempData = ROSDistuibutionShowModel.copyWith(infoShowBucketList: showDataModel.value.infoShowBucketList);
            tempData.infoShowBucketList ??= InfoShowBucketList();
            tempData.infoShowBucketList?.lstROSSpots ??= <LstROSSpots>[];
            tempData.infoShowBucketList?.lstROSSpots?.clear();
            for (var element in resp['info_GetEmptyList']['lstROSSpots']) {
              tempData.infoShowBucketList?.lstROSSpots?.add(LstROSSpots.fromJson(element));
            }
            showDataModel.value = ROSDistuibutionShowModel.fromJson(tempData.toJson());
            tempShowDataModel = ROSDistuibutionShowModel.fromJson(tempData.toJson());
          } else {
            LoadingDialog.showErrorDialog("No data found.");
          }
        } else {
          LoadingDialog.showErrorDialog(resp.toString());
        }
      },
      json: {
        "locationCode": selectedLocation?.key,
        "channelCode": selectedChannel?.key,
        "fromDate": DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy").parse(date.text)),
        "loggedUser": Get.find<MainController>().user?.logincode,
        "allowMoveSpotbuys": false,
        "allocPercentValue": "100"
      },
    );
  }

  Color getRowColorForFPC(String val) {
    if (val == "White") {
      return Colors.white;
    } else if (val == "Red") {
      return Colors.red;
    } else if (val == "LightGreen") {
      return Colors.lightGreen;
    } else if (val == "Pink") {
      return Colors.pink;
    } else if (val == "Black") {
      return Colors.black12;
    } else {
      return Colors.white;
    }
  }

  void handleFPCTap() async {
    if (selectedLocation != null && selectedChannel != null && (showDataModel.value.infoShowBucketList?.lstFPC?.isEmpty ?? true)) {
      await handleShowTap();
    }
    var tempProgramName = "".obs, tempAlloc = "100".obs, tempFpcTime = "".obs, tempCommercialCap = "".obs, tempBookedDur = "".obs, tempBal = "".obs;
    var includeROS = true.obs, includeOpenDeal = true.obs, moveSpotbuys = false.obs;

    var tempModel = cellModel.ROSCellClickDataModel(infoGetFpcCellDoubleClick: cellModel.InfoGetFpcCellDoubleClick()).obs;
    tempModel.value.infoGetFpcCellDoubleClick?.lstFPC = [];
    var temp11 = showDataModel.value.infoShowBucketList?.lstFPC?.map((e) => e.toJson()).toList();
    var temp22 = temp11?.map((e) => cellModel.LstFPC.fromJson(e)).toList();
    tempModel.value.infoGetFpcCellDoubleClick?.lstFPC = temp22;
    int lastSelectedIdx = 0, lastSelectedIdx2nd = 0, lastSelectedIdx3rd = 0;
    bool canRender = true;
    PlutoGridStateManager? tempSM1st, tempSM2nd, tempSM3rd;
    showDialog(
        context: Get.context!,
        builder: (_) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SizedBox(
              width: _.width * 8,
              height: _.width * 8,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.end,
                      spacing: 15,
                      children: [
                        InputFields.formFieldDisable(
                          hintTxt: "Location",
                          value: selectedLocation?.value ?? "",
                          widthRatio: .12,
                        ),
                        DateWithThreeTextField(
                          title: "Date",
                          mainTextController: date,
                          widthRation: 0.12,
                          isEnable: false,
                        ),
                        Obx(() {
                          return InputFields.formFieldDisable(
                            hintTxt: "Program Name",
                            value: tempProgramName.value,
                            widthRatio: .25,
                          );
                        }),
                        // Obx(() {
                        //   return InputFields.formFieldDisable(
                        //     hintTxt: "Alloc %",
                        //     value: tempAlloc.value,
                        //     widthRatio: .07,
                        //   );
                        // }),
                        FormButton(
                          btnText: "Reload",
                          callback: () {
                            if (selectedLocation == null || selectedChannel == null) return;
                            LoadingDialog.call();
                            Get.find<ConnectorControl>().GETMETHODCALL(
                                api: ApiFactory.RO_DISTRIBUTION_SHOW_DATA(selectedLocation!.key!, selectedChannel!.key!,
                                    DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy").parse(date.text))),
                                fun: (resp) {
                                  closeDialogIfOpen();
                                  if (resp != null && resp is Map<String, dynamic> && resp['info_ShowBucketList'] != null) {
                                    enableControllos.value = false;
                                    showDataModel.value = ROSDistuibutionShowModel.fromJson(resp);
                                    showDataModel.value.infoShowBucketList?.controlEnableTrue?.forEach((element) {
                                      topButtons.value = topButtons.value.map((e) {
                                        if (!e.containsKey(element)) {
                                          // e['isEnabled'] = false;
                                        }
                                        return e;
                                      }).toList();
                                    });
                                    update(['headRowBtn']);
                                    tempShowDataModel = ROSDistuibutionShowModel.fromJson(showDataModel.value.toJson());
                                    Get.back();
                                    handleFPCTap();
                                  } else {
                                    LoadingDialog.showErrorDialog(resp.toString());
                                  }
                                },
                                failed: (resp) {
                                  closeDialogIfOpen();
                                  LoadingDialog.showErrorDialog(resp.toString());
                                });
                          },
                        ),
                        FormButton(
                          btnText: "Allocate",
                          callback: () {
                            if (selectedLocation == null || selectedChannel == null) return;
                            LoadingDialog.call();
                            Get.find<ConnectorControl>().POSTMETHOD(
                              api: ApiFactory.RO_DISTRIBUTION_GET_ALLOCATE_FPC_DATA,
                              fun: (resp) {
                                closeDialogIfOpen();
                                if (resp != null && resp is Map<String, dynamic> && resp['info_GetAllocateFPC'] != null) {
                                  tempModel.value = cellModel.ROSCellClickDataModel(
                                      infoGetFpcCellDoubleClick: cellModel.InfoGetFpcCellDoubleClick.fromJson(resp['info_GetAllocateFPC']));
                                  tempProgramName.value = tempModel.value.infoGetFpcCellDoubleClick?.programname ?? "";
                                  tempFpcTime.value = tempModel.value.infoGetFpcCellDoubleClick?.fpctime ?? "";
                                  tempCommercialCap.value = tempModel.value.infoGetFpcCellDoubleClick?.commercialCap ?? "";
                                  tempBookedDur.value = tempModel.value.infoGetFpcCellDoubleClick?.bookedduration ?? "";
                                  tempBal.value = tempModel.value.infoGetFpcCellDoubleClick?.balanceDuration ?? "";
                                } else {
                                  // tempModel.value.infoGetFpcCellDoubleClick?.lstAllocatedSpots?.clear();
                                  // tempModel.value.infoGetFpcCellDoubleClick?.lstUnallocatedSpots?.clear();
                                  LoadingDialog.showErrorDialog(resp.toString());
                                  tempModel.refresh();
                                }
                              },
                              json: {
                                "unallocatedSpotsCurrentRowIndex": lastSelectedIdx3rd,
                                "loggedUser": Get.find<MainController>().user?.logincode,
                                "allocPercentVisiable": moveSpotbuys.value,
                                "allocPercentValue": tempAlloc.value,
                                "fpcCurrentRowIndex": lastSelectedIdx,
                                "lstFPC": showDataModel.value.infoShowBucketList?.lstFPC?.map((e) => e.toJson()).toList() ?? [],
                                "lstROSSpots": showDataModel.value.infoShowBucketList?.lstROSSpots?.map((e) => e.toJson()).toList() ?? [],
                                "lstUnallocatedSpots":
                                    tempModel.value.infoGetFpcCellDoubleClick?.lstUnallocatedSpots?.map((e) => e.toJson()).toList() ?? [],
                                "fromDate": DateFormat("yyyy-MM-ddT00:00:00").format(DateFormat("dd-MM-yyyy").parse(date.text)),
                                "allowMoveSpotbuys": moveSpotbuys.value,
                                "chkMoveSpotBuys": moveSpotbuys.value,
                                "chkIncludeROS": includeROS.value,
                                "chkOpenDeal": includeOpenDeal.value,
                              },
                            );
                          },
                        ),
                        FormButton(
                          btnText: "Deallocate",
                          callback: () {
                            if (selectedLocation == null || selectedChannel == null) return;
                            LoadingDialog.call();
                            Get.find<ConnectorControl>().POSTMETHOD(
                              api: ApiFactory.RO_DISTRIBUTION_GET_DEALLOCATE_FPC_DATA,
                              fun: (resp) {
                                closeDialogIfOpen();
                                if (resp != null && resp is Map<String, dynamic> && resp['info_GetDeallocateFPC'] != null) {
                                  tempModel.value = cellModel.ROSCellClickDataModel(
                                      infoGetFpcCellDoubleClick: cellModel.InfoGetFpcCellDoubleClick.fromJson(resp['info_GetDeallocateFPC']));
                                  tempProgramName.value = tempModel.value.infoGetFpcCellDoubleClick?.programname ?? "";
                                  tempFpcTime.value = tempModel.value.infoGetFpcCellDoubleClick?.fpctime ?? "";
                                  tempCommercialCap.value = tempModel.value.infoGetFpcCellDoubleClick?.commercialCap ?? "";
                                  tempBookedDur.value = tempModel.value.infoGetFpcCellDoubleClick?.bookedduration ?? "";
                                  tempBal.value = tempModel.value.infoGetFpcCellDoubleClick?.balanceDuration ?? "";
                                } else {
                                  // tempModel.value.infoGetFpcCellDoubleClick?.lstAllocatedSpots?.clear();
                                  // tempModel.value.infoGetFpcCellDoubleClick?.lstUnallocatedSpots?.clear();
                                  LoadingDialog.showErrorDialog(resp.toString());
                                  tempModel.refresh();
                                }
                              },
                              json: {
                                "currentRowIndex": lastSelectedIdx,
                                "lstFPC": showDataModel.value.infoShowBucketList?.lstFPC?.map((e) => e.toJson()).toList(),
                                "lstROSSpots": showDataModel.value.infoShowBucketList?.lstROSSpots?.map((e) => e.toJson()).toList() ?? [],
                                "lstAllocatedSpots":
                                    tempModel.value.infoGetFpcCellDoubleClick?.lstAllocatedSpots?.map((e) => e.toJson()).toList() ?? [],
                                "fromDate": DateFormat("yyyy-MM-ddT00:00:00").format(DateFormat("dd-MM-yyyy").parse(date.text)),
                                "allowMoveSpotbuys": moveSpotbuys.value,
                                "chkMoveSpotBuys": moveSpotbuys.value,
                                "chkIncludeROS": includeROS.value,
                                "chkOpenDeal": includeOpenDeal.value,
                              },
                            );
                          },
                        ),
                        Row(),
                        InputFields.formFieldDisable(
                          hintTxt: "Channel",
                          value: selectedChannel?.value ?? "",
                          widthRatio: .12,
                        ),
                        Obx(() {
                          return InputFields.formFieldDisable(
                            hintTxt: "FPC Time",
                            value: tempFpcTime.value,
                            widthRatio: .12,
                          );
                        }),
                        Obx(() {
                          return InputFields.formFieldDisable(
                            hintTxt: "Commercial Cap",
                            value: tempCommercialCap.value,
                            widthRatio: .12,
                          );
                        }),
                        Obx(() {
                          return InputFields.formFieldDisable(
                            hintTxt: "Booked Dur",
                            value: tempBookedDur.value,
                            widthRatio: .12,
                          );
                        }),
                        Obx(() {
                          return InputFields.formFieldDisable(
                            hintTxt: "Balance",
                            value: tempBal.value,
                            widthRatio: .12,
                          );
                        }),
                        // Obx(() {
                        //   return CheckBoxWidget1(
                        //     title: "Move Spot buys",
                        //     value: moveSpotbuys.value,
                        //     onChanged: (val) {
                        //       moveSpotbuys.value = val ?? false;
                        //       Get.find<ConnectorControl>().POSTMETHOD(
                        //         api: ApiFactory.RO_DISTRIBUTION_GET_MOVE_SPOT_FILTER_FPC_DATA,
                        //         fun: (resp) {
                        //           closeDialogIfOpen();
                        //           if (resp != null && resp is Map<String, dynamic> && resp['info_GetFpcCellDoubleClick'] != null) {
                        //             // tempModel.value = cellModel.ROSCellClickDataModel.fromJson(resp);
                        //             // canRender = true;
                        //           } else {
                        //             LoadingDialog.showErrorDialog(resp.toString());
                        //             // tempModel.refresh();
                        //           }
                        //         },
                        //         json: {
                        //           "chkIncludeROS": includeROS.value,
                        //           "chkOpenDeal": includeOpenDeal.value,
                        //           "lstUnallocatedSpots":
                        //               tempModel.value.infoGetFpcCellDoubleClick?.lstUnallocatedSpots?.map((e) => e.toJson()).toList() ?? [],
                        //           "lstAllocatedSpots":
                        //               tempModel.value.infoGetFpcCellDoubleClick?.lstAllocatedSpots?.map((e) => e.toJson()).toList() ?? [],
                        //         },
                        //       );
                        //     },
                        //   );
                        // }),
                        Obx(() {
                          return CheckBoxWidget1(
                            title: "Include ROS?",
                            value: includeROS.value,
                            onChanged: (val) {
                              includeROS.value = val ?? false;
                              if (selectedLocation == null || selectedChannel == null) return;
                              LoadingDialog.call();
                              Get.find<ConnectorControl>().POSTMETHOD(
                                api: ApiFactory.RO_DISTRIBUTION_GET_INCLUDE_ROS_FILTER_FPC_DATA,
                                fun: (resp) {
                                  closeDialogIfOpen();
                                  if (resp != null && resp is Map<String, dynamic> && resp['info_GetIncludeROSFilter'] != null) {
                                    tempModel.value.infoGetFpcCellDoubleClick?.lstAllocatedSpots?.clear();
                                    tempModel.value.infoGetFpcCellDoubleClick?.lstUnallocatedSpots?.clear();
                                    if (resp['info_GetIncludeROSFilter']['lstAllocatedSpots'] != null) {
                                      for (var e in resp['info_GetIncludeROSFilter']['lstAllocatedSpots']) {
                                        tempModel.value.infoGetFpcCellDoubleClick?.lstAllocatedSpots?.add(cellModel.LstAllocatedSpots.fromJson(e));
                                      }
                                    }
                                    if (resp['info_GetIncludeROSFilter']['lstUnallocatedSpots'] != null) {
                                      for (var e in resp['info_GetIncludeROSFilter']['lstUnallocatedSpots']) {
                                        tempModel.value.infoGetFpcCellDoubleClick?.lstUnallocatedSpots
                                            ?.add(cellModel.LstUnallocatedSpots.fromJson(e));
                                      }
                                    }
                                    tempModel.refresh();
                                  } else {
                                    includeROS.value = !(val ?? false);
                                    LoadingDialog.showErrorDialog(resp.toString());
                                  }
                                },
                                json: {
                                  "chkIncludeROS": includeROS.value,
                                  "chkOpenDeal": includeOpenDeal.value,
                                  "lstUnallocatedSpots":
                                      tempModel.value.infoGetFpcCellDoubleClick?.lstUnallocatedSpots?.map((e) => e.toJson()).toList() ?? [],
                                  "lstAllocatedSpots":
                                      tempModel.value.infoGetFpcCellDoubleClick?.lstAllocatedSpots?.map((e) => e.toJson()).toList() ?? [],
                                },
                              );
                            },
                          );
                        }),
                        Obx(() {
                          return CheckBoxWidget1(
                            title: "Include OPEN Deal?",
                            value: includeOpenDeal.value,
                            onChanged: (val) {
                              includeOpenDeal.value = val ?? false;
                              if (selectedLocation == null || selectedChannel == null) return;
                              LoadingDialog.call();
                              Get.find<ConnectorControl>().POSTMETHOD(
                                api: ApiFactory.RO_DISTRIBUTION_GET_OPEN_DEAL_FILTER_FPC_DATA,
                                fun: (resp) {
                                  closeDialogIfOpen();
                                  if (resp != null && resp is Map<String, dynamic> && resp['info_OpenDealFilter'] != null) {
                                    tempModel.value.infoGetFpcCellDoubleClick?.lstAllocatedSpots?.clear();
                                    tempModel.value.infoGetFpcCellDoubleClick?.lstUnallocatedSpots?.clear();
                                    if (resp['info_OpenDealFilter']['lstAllocatedSpots'] != null) {
                                      for (var e in resp['info_OpenDealFilter']['lstAllocatedSpots']) {
                                        tempModel.value.infoGetFpcCellDoubleClick?.lstAllocatedSpots?.add(cellModel.LstAllocatedSpots.fromJson(e));
                                      }
                                    }
                                    if (resp['info_OpenDealFilter']['lstUnallocatedSpots'] != null) {
                                      for (var e in resp['info_OpenDealFilter']['lstUnallocatedSpots']) {
                                        tempModel.value.infoGetFpcCellDoubleClick?.lstUnallocatedSpots
                                            ?.add(cellModel.LstUnallocatedSpots.fromJson(e));
                                      }
                                    }
                                    tempModel.refresh();
                                  } else {
                                    includeOpenDeal.value = !(val ?? false);
                                    LoadingDialog.showErrorDialog(resp.toString());
                                  }
                                },
                                json: {
                                  "chkIncludeROS": includeROS.value,
                                  "chkOpenDeal": includeOpenDeal.value,
                                  "lstUnallocatedSpots":
                                      tempModel.value.infoGetFpcCellDoubleClick?.lstUnallocatedSpots?.map((e) => e.toJson()).toList() ?? [],
                                  "lstAllocatedSpots":
                                      tempModel.value.infoGetFpcCellDoubleClick?.lstAllocatedSpots?.map((e) => e.toJson()).toList() ?? [],
                                },
                              );
                            },
                          );
                        })
                      ],
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Obx(() {
                              return Container(
                                margin: const EdgeInsets.all(8),
                                decoration: (tempModel.value.infoGetFpcCellDoubleClick?.lstFPC?.isEmpty ?? true)
                                    ? BoxDecoration(
                                        border: Border.all(
                                        color: Colors.grey,
                                      ))
                                    : null,
                                child: (tempModel.value.infoGetFpcCellDoubleClick?.lstFPC?.isEmpty ?? true)
                                    ? null
                                    : DataGridFromMap(
                                        mapData: (tempModel.value.infoGetFpcCellDoubleClick?.lstFPC)?.map((e) => e.toJson()).toList() ?? [],
                                        formatDate: false,
                                        widthRatio: 220,
                                        exportFileName: "ROS Distribution",
                                        showonly: ['fpcTime', 'programName', 'commercialCap', 'groupCode', 'bookedDuration'],
                                        // hideCode: false,
                                        colorCallback: (row) => (row.row.cells.containsValue(tempSM1st?.currentCell))
                                            ? Colors.deepPurple.shade200
                                            : getRowColorForFPC(tempModel.value.infoGetFpcCellDoubleClick?.lstFPC?[row.rowIdx].backColor ?? ""),
                                        onRowDoubleTap: (row) {
                                          lastSelectedIdx = row.rowIdx;
                                          tempSM1st?.setCurrentCell(tempSM1st?.getRowByIdx(lastSelectedIdx)?.cells['locationcode'], lastSelectedIdx);
                                          if ((tempModel.value.infoGetFpcCellDoubleClick?.lstFPC?.isNotEmpty ?? false)) {
                                            LoadingDialog.call();
                                            Get.find<ConnectorControl>().POSTMETHOD(
                                              api: ApiFactory.RO_DISTRIBUTION_GET_FPC_DOUBLE_CLICK_DATA,
                                              fun: (resp) {
                                                closeDialogIfOpen();
                                                if (resp != null && resp is Map<String, dynamic> && resp['info_GetFpcCellDoubleClick'] != null) {
                                                  tempModel.value = cellModel.ROSCellClickDataModel.fromJson(resp);
                                                  tempProgramName.value = tempModel.value.infoGetFpcCellDoubleClick?.programname ?? "";
                                                  tempFpcTime.value = tempModel.value.infoGetFpcCellDoubleClick?.fpctime ?? "";
                                                  tempCommercialCap.value = tempModel.value.infoGetFpcCellDoubleClick?.commercialCap ?? "";
                                                  tempBookedDur.value = tempModel.value.infoGetFpcCellDoubleClick?.bookedduration ?? "";
                                                  tempBal.value = tempModel.value.infoGetFpcCellDoubleClick?.balanceDuration ?? "";
                                                } else {
                                                  tempModel.value.infoGetFpcCellDoubleClick?.lstAllocatedSpots?.clear();
                                                  tempModel.value.infoGetFpcCellDoubleClick?.lstUnallocatedSpots?.clear();
                                                  LoadingDialog.showErrorDialog(resp.toString());
                                                  tempModel.refresh();
                                                }
                                              },
                                              json: {
                                                "currentRowIndex": row.rowIdx,
                                                "lstFPC": tempModel.value.infoGetFpcCellDoubleClick?.lstFPC?.map((e) => e.toJson()).toList(),
                                                "lstROSSpots":
                                                    showDataModel.value.infoShowBucketList?.lstROSSpots?.map((e) => e.toJson()).toList() ?? [],
                                                "fromDate": DateFormat("yyyy-MM-ddT00:00:00").format(DateFormat("dd-MM-yyyy").parse(date.text)),
                                                "allowMoveSpotbuys": moveSpotbuys.value,
                                                "chkMoveSpotBuys": checkBoxes.value[2]['value'],
                                                "chkIncludeROS": checkBoxes.value[1]['value'],
                                                "chkOpenDeal": checkBoxes.value[0]['value'],
                                              },
                                            );
                                          }
                                        },
                                        onload: (sm) {
                                          tempSM1st = sm.stateManager;
                                          if ((tempModel.value.infoGetFpcCellDoubleClick?.lstFPC?.isNotEmpty ?? false) && canRender) {
                                            canRender = false;
                                            tempProgramName.value = tempModel.value.infoGetFpcCellDoubleClick?.lstFPC?[0].programName ?? "";
                                            tempFpcTime.value = tempModel.value.infoGetFpcCellDoubleClick?.lstFPC?[0].fpcTime ?? "";
                                            tempCommercialCap.value =
                                                (tempModel.value.infoGetFpcCellDoubleClick?.lstFPC?[0].commercialCap ?? 0).toString();
                                            tempBookedDur.value =
                                                (tempModel.value.infoGetFpcCellDoubleClick?.lstFPC?[0].bookedDuration ?? 0).toString();
                                          }
                                          sm.stateManager
                                              .setCurrentCell(sm.stateManager.getRowByIdx(lastSelectedIdx)?.cells['fpcTime'], lastSelectedIdx);
                                          sm.stateManager.moveCurrentCellByRowIdx(lastSelectedIdx, PlutoMoveDirection.down);
                                        },
                                        mode: PlutoGridMode.normal,
                                      ),
                              );
                            }),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Obx(() {
                                    return Container(
                                      margin: const EdgeInsets.all(8),
                                      decoration: (tempModel.value.infoGetFpcCellDoubleClick?.lstAllocatedSpots?.isEmpty ?? true)
                                          ? BoxDecoration(
                                              border: Border.all(
                                              color: Colors.grey,
                                            ))
                                          : null,
                                      child: (tempModel.value.infoGetFpcCellDoubleClick?.lstAllocatedSpots?.isEmpty ?? true)
                                          ? null
                                          : DataGridShowOnlyKeys(
                                              exportFileName: "ROS Distribution",
                                              mapData:
                                                  (tempModel.value.infoGetFpcCellDoubleClick?.lstAllocatedSpots)?.map((e) => e.toJson()).toList() ??
                                                      [],
                                              formatDate: false,
                                              widthRatio: 220,
                                              hideCode: false,
                                              colorCallback: (row) => (row.row.cells.containsValue(tempSM2nd?.currentCell))
                                                  ? Colors.deepPurple.shade200
                                                  : getRowColorForFPC(
                                                      tempModel.value.infoGetFpcCellDoubleClick?.lstAllocatedSpots?[row.rowIdx].backColor ?? ""),
                                              // mode: PlutoGridMode.selectWithOneTap,
                                              onRowDoubleTap: (p0) {
                                                lastSelectedIdx2nd = p0.rowIdx;
                                                tempSM2nd?.setCurrentCell(
                                                    tempSM2nd?.getRowByIdx(lastSelectedIdx2nd)?.cells['locationcode'], lastSelectedIdx2nd);
                                              },
                                              onload: (sm) {
                                                tempSM2nd = sm.stateManager;
                                                sm.stateManager.setCurrentCell(
                                                    sm.stateManager.getRowByIdx(lastSelectedIdx2nd)?.cells['locationcode'], lastSelectedIdx2nd);
                                              },
                                            ),
                                    );
                                  }),
                                ),
                                const SizedBox(height: 10),
                                Expanded(
                                  child: Obx(() {
                                    return Container(
                                      margin: const EdgeInsets.all(8),
                                      decoration: (tempModel.value.infoGetFpcCellDoubleClick?.lstUnallocatedSpots?.isEmpty ?? true)
                                          ? BoxDecoration(
                                              border: Border.all(
                                              color: Colors.grey,
                                            ))
                                          : null,
                                      child: (tempModel.value.infoGetFpcCellDoubleClick?.lstUnallocatedSpots?.isEmpty ?? true)
                                          ? null
                                          : DataGridShowOnlyKeys(
                                              mapData:
                                                  (tempModel.value.infoGetFpcCellDoubleClick?.lstUnallocatedSpots)?.map((e) => e.toJson()).toList() ??
                                                      [],
                                              formatDate: false,
                                              widthRatio: 220,
                                              hideCode: false,
                                              onRowDoubleTap: (p0) {
                                                lastSelectedIdx3rd = p0.rowIdx;
                                                tempSM3rd?.setCurrentCell(
                                                    tempSM3rd?.getRowByIdx(lastSelectedIdx3rd)?.cells['locationcode'], lastSelectedIdx3rd);
                                              },
                                              colorCallback: (row) => (row.row.cells.containsValue(tempSM3rd?.currentCell))
                                                  ? Colors.deepPurple.shade200
                                                  : getRowColorForFPC(
                                                      tempModel.value.infoGetFpcCellDoubleClick?.lstUnallocatedSpots?[row.rowIdx].backColor ?? ""),
                                              // mode: PlutoGridMode.selectWithOneTap,
                                              onload: (sm) {
                                                tempSM3rd = sm.stateManager;
                                                sm.stateManager.setCurrentCell(
                                                    sm.stateManager.getRowByIdx(lastSelectedIdx3rd)?.cells['locationcode'], lastSelectedIdx3rd);
                                              },
                                            ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<void> handleUNTap() async {
    if (selectedLocation == null || selectedChannel == null || (showDataModel.value.infoShowBucketList?.lstROSSpots?.isEmpty ?? true)) {
      return;
    } else {
      showDataModel.value.infoShowBucketList?.lstROSSpots?.removeWhere(
        (element) => element.allocatedSpot != null && (element.allocatedSpot?.isNotEmpty ?? false),
      );
      showDataModel.refresh();
    }
  }

  Future<void> handleServiceTap() async {
    if (selectedLocation == null || selectedChannel == null || (showDataModel.value.infoShowBucketList?.lstROSSpots?.isEmpty ?? true)) {
      return;
    } else {
      if (topButtons[5]['name'] == "Service") {
        // if (mainGSM != null) {
        //   var rrr = mainGSM?.columns[2];
        //   if (rrr != null) {
        //     mainGSM?.sortAscending(rrr);
        //   }
        //   var valuation = mainGSM?.columns[17];
        //   if (valuation != null) {
        //     mainGSM?.sortDescending(valuation);
        //   }
        // }
        topButtons[5]['name'] = "Revenue";
      } else {
        // if (mainGSM != null) {
        //   var valuation = mainGSM?.columns[17];
        //   if (valuation != null) {
        //     mainGSM?.sortDescending(valuation);
        //   }
        // }
        topButtons[5]['name'] = "Service";
      }
      update(['headRowBtn']);
      LoadingDialog.call();
      Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.RO_DISTRIBUTION_GET_SERVICE_DATA,
          fun: (resp) {
            closeDialogIfOpen();
            if (resp != null &&
                resp is Map<String, dynamic> &&
                resp['info_GetUnalloacted']['lstROSSpots'] != null &&
                resp['info_GetUnalloacted']['lstROSSpots'] is List<dynamic> &&
                (resp['info_GetUnalloacted']['lstROSSpots'] as List<dynamic>).isNotEmpty) {
              var tempData = ROSDistuibutionShowModel.copyWith(infoShowBucketList: showDataModel.value.infoShowBucketList);
              tempData.infoShowBucketList ??= InfoShowBucketList();
              tempData.infoShowBucketList?.lstROSSpots ??= <LstROSSpots>[];
              tempData.infoShowBucketList?.lstROSSpots?.clear();
              for (var element in resp['info_GetEmptyList']['lstROSSpots']) {
                tempData.infoShowBucketList?.lstROSSpots?.add(LstROSSpots.fromJson(element));
              }
              showDataModel.value = ROSDistuibutionShowModel.fromJson(tempData.toJson());
              tempShowDataModel = ROSDistuibutionShowModel.fromJson(tempData.toJson());
              showDataModel.refresh();
            } else {
              LoadingDialog.showErrorDialog(resp.toString());
            }
          },
          json: {
            "btnServiceText": topButtons[5]['name'],
            "lstROSSpots": showDataModel.value.infoShowBucketList?.lstROSSpots?.map((e) => e.toJson()).toList(),
          });
    }
  }

  Future<void> handleAllocationTap() async {
    if (selectedLocation == null || selectedChannel == null || (showDataModel.value.infoShowBucketList?.lstROSSpots?.isEmpty ?? true)) {
      return;
    } else if (mainGSM?.currentRowIdx == null) {
      LoadingDialog.showErrorDialog("Please select row");
    } else {
      var list = [];

      if (mainGSM?.currentSelectingRows.isNotEmpty ?? false) {
        for (var i = 0; i < (showDataModel.value.infoShowBucketList?.lstROSSpots?.length ?? 0); i++) {
          if ((mainGSM?.currentSelectingRows.any((element) => element.sortIdx == i) ?? false) &&
              ((showDataModel.value.infoShowBucketList?.lstROSSpots?[i].allocatedSpot?.isEmpty) ?? false)) {
            showDataModel.value.infoShowBucketList?.lstROSSpots?[i].rid = i;
            list.add(showDataModel.value.infoShowBucketList?.lstROSSpots?[i].toJson());
            // mainGridIdx = i;
          }
        }
      } else {
        if (showDataModel.value.infoShowBucketList?.lstROSSpots?[mainGSM!.currentRowIdx!].allocatedSpot?.isEmpty ?? false) {
          mainGridIdx = mainGSM!.currentRowIdx!;
          showDataModel.value.infoShowBucketList?.lstROSSpots?[mainGridIdx].rid = mainGridIdx;
          list.add(showDataModel.value.infoShowBucketList?.lstROSSpots?[mainGridIdx].toJson());
        }
      }
      if (list.isEmpty) {
        return;
      }
      LoadingDialog.call();
      Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.RO_DISTRIBUTION_GET_ALLOCATION_DATA,
        fun: (resp) {
          closeDialogIfOpen();
          if (resp != null && resp is Map<String, dynamic> && resp['info_tblROSSpots'] != null && resp['info_tblROSSpots'] is List<dynamic>) {
            for (var element in (resp['info_tblROSSpots'] as List<dynamic>)) {
              mainGridIdx = int.tryParse(element['Rid']) ?? -1;
              if (mainGridIdx != -1) {
                showDataModel.value.infoShowBucketList?.lstROSSpots?[mainGridIdx].allocatedSpot = element['AllocatedSpot'];
              }
            }
            showDataModel.refresh();
            if ((resp['info_tblROSSpots'] as List<dynamic>).isNotEmpty) {
              LoadingDialog.callDataSaved(msg: "Allocation done.");
            } else {
              LoadingDialog.showErrorDialog("Allocation failed");
            }
          } else {
            LoadingDialog.showErrorDialog(resp.toString());
          }
        },
        json: {
          // "rowIndex": mainGridIdx,
          "allocPercentVisiable": false,
          "allocationLst": list,
          // "loggedUser": Get.find<MainController>().user?.logincode,
          // "allocPercentValue": "100",
        },
      );
    }
  }

  Future<void> handleDeallocateTap() async {
    if (selectedLocation == null || selectedChannel == null || (showDataModel.value.infoShowBucketList?.lstROSSpots?.isEmpty ?? true)) {
      return;
    } else {
      LoadingDialog.call();

      Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.RO_DISTRIBUTION_GET_DEALLOCATE_DATA,
          fun: (resp) {
            closeDialogIfOpen();
            if (resp != null && resp is Map<String, dynamic> && resp['info_GetRollback'] != null) {
              LoadingDialog.callDataSaved(msg: resp['info_GetRollback']['message'][0].toString());
            } else {
              LoadingDialog.showErrorDialog(resp.toString());
            }
          },
          json: {
            "locationCode": selectedLocation?.key,
            "channelCode": selectedChannel?.key,
            "fromDate": DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy").parse(date.text)),
            "lstROSSpots": showDataModel.value.infoShowBucketList?.lstROSSpots?.map((e) => e.toJson()).toList(),
          });
    }
  }

  ////////////// Head section button click Functionality end/////////
  ///
  ///
  ///
  ///
  ///
  ///
  ////////////////////////////////////// INTIAL API START/////////////

  callInitailsAPI() {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.RO_DISTRIBUTION_GET_LOCATION,
        fun: (resp) {
          closeDialogIfOpen();
          if (resp != null && resp is Map<String, dynamic> && resp['onFormLoad'] != null) {
            location.clear();
            location.addAll((resp['onFormLoad']['lstLocationMaster'] as List<dynamic>)
                .map((e) => DropDownValue(
                      key: e['locationCode'],
                      value: e['locationName'],
                    ))
                .toList());
          } else {
            LoadingDialog.showErrorDialog(resp.toString());
          }
        },
        failed: (resp) {
          closeDialogIfOpen();
          LoadingDialog.showErrorDialog(resp.toString());
        });
  }

  ////////////////////////////////////// INTIAL API END////////////
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///
  ///////////////////////////////////// COMMON FUNCTION START////////
  closeDialogIfOpen() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  Future<List<int>> getSelectedRowsInMainGrid() async {
    List<int> selectedIdx = [];
    if (mainGSM == null) {
      return selectedIdx;
    } else if (mainGSM?.currentRowIdx == null || mainGSM?.currentRowIdx == null) {
      LoadingDialog.showErrorDialog("Please select row first");
    } else if (mainGSM!.currentSelectingRows.isEmpty) {
      selectedIdx.add(mainGSM!.currentRowIdx ?? 0);
    } else {
      selectedIdx.add(mainGSM!.currentRowIdx ?? 0);
      for (var element in mainGSM!.currentSelectingRows) {
        selectedIdx.add(element.sortIdx);
      }
    }
    selectedIdx = selectedIdx.toSet().toList();
    print("Here is the selectedIdx $selectedIdx");
    return selectedIdx;
  }

  clearAllPage() {
    mainGSM = null;
    mainGridIdx = 0;
    selectedLocation = null;
    selectedChannel = null;
    date.clear();
    // date.text = "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";
    location.refresh();
    channel.refresh();
    enableControllos.value = true;
    showDataModel.value = ROSDistuibutionShowModel();
    selectedReportTab.value = "Client Wise";
    reportList.clear();
    topButtons.value = topButtons.value.map((e) {
      e['isEnabled'] = true;
      return e;
    }).toList();

    checkBoxes.value = checkBoxes.map((element) {
      element['value'] = false;
      return element;
    }).toList();

    locationFN.requestFocus();
  }

  handleOnLocationChanged(DropDownValue? val) {
    selectedLocation = val;
    if (val != null) {
      LoadingDialog.call();
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.RO_DISTRIBUTION_GET_CHANNEL(val.key ?? ""),
          fun: (resp) {
            closeDialogIfOpen();
            if (resp != null && resp is Map<String, dynamic> && resp['channelList'] != null) {
              channel.clear();
              channel.addAll((resp['channelList'] as List<dynamic>)
                  .map((e) => DropDownValue(
                        key: e['channelCode'],
                        value: e['channelName'],
                      ))
                  .toList());
            } else {
              LoadingDialog.showErrorDialog(resp.toString());
            }
          },
          failed: (resp) {
            closeDialogIfOpen();
            LoadingDialog.showErrorDialog(resp.toString());
          });
    }
  }

  bottomFormHandler(String btnName) {
    if (btnName == "Clear") {
      clearAllPage();
    } else if (btnName == "Search") {
      Get.to(
        SearchPage(
          key: Key("ROS Distribution"),
          screenName: "ROS Distribution",
          appBarName: "ROS Distribution",
          strViewName: "BMS_view_BookingDetail",
          isAppBarReq: true,
        ),
      );
    }
  }
  ///////////////////////////////////// COMMON FUNCTION END///////////
}

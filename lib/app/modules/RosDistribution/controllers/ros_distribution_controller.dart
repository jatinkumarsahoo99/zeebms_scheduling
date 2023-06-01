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
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../../widgets/input_fields.dart';
import '../../../../widgets/radio_row.dart';
import '../model/ros_show_model.dart';
import 'package:pluto_grid/pluto_grid.dart' show PlutoGridMode, PlutoGridStateManager;

class RosDistributionController extends GetxController {
  DropDownValue? selectedLocation, selectedChannel;
  var location = <DropDownValue>[].obs, channel = <DropDownValue>[].obs;
  var date = TextEditingController();
  var locationFN = FocusNode();
  var enableControllos = true.obs;
  PlutoGridStateManager? mainGSM;

  var topButtons = <Map<String, dynamic>>[].obs;
  var showDataModel = ROSDistuibutionShowModel().obs;
  var tempShowDataModel = ROSDistuibutionShowModel();
  var selectedReportTab = "Client Wise".obs;
  var reportList = <dynamic>[].obs;

  var checkBoxes = [].obs;

  @override
  void onInit() {
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
    if (rosSpotsValue) {
      /// display only ros
      showDataModel.value.infoShowBucketList?.lstROSSpots?.removeWhere(
        (element) => ((element.sponsorTypeName?.toLowerCase() != "ros")),
      );
      showDataModel.refresh();
    } else {
      showDataModel.value = ROSDistuibutionShowModel.fromJson(tempShowDataModel.toJson());
    }
  }

  handleOnChangedInSpotBuys() {
    var showSpotsValue = (checkBoxes.value[2]['value'] as bool);
    if (showSpotsValue) {
      /// display only spot boys
      showDataModel.value.infoShowBucketList?.lstROSSpots?.removeWhere(
        (element) => ((element.sponsorTypeName?.toLowerCase() != "spot boys")),
      );
      showDataModel.refresh();
    } else {
      showDataModel.value = ROSDistuibutionShowModel.fromJson(tempShowDataModel.toJson());
    }
  }

  ///////////////////////// Check box on change bottom end/////////
  ///
  ///
  ///
  ///
  ///////////////////////////Head section button click start/////////
  void handleShowTap() {
    if (selectedLocation == null || selectedChannel == null) {
      LoadingDialog.showErrorDialog("Please select Location and Channel.");
    } else {
      LoadingDialog.call();
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.RO_DISTRIBUTION_SHOW_DATA(
              selectedLocation!.key!, selectedChannel!.key!, DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy").parse(date.text))),
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
    reportList.clear();
    selectedReportTab.value = "Client Wise";
    Future.delayed(const Duration(seconds: 2)).then((value) {
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
                              items: ['Client Wise', 'Client & Brand Wise', 'Client Pivot', 'Brand Pivot', 'Zone Wise', 'Zone & Time'],
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
                            : DataGridShowOnlyKeys(
                                mapData: reportList.value,
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
        "lstROSSpots": showDataModel.value.infoShowBucketList?.lstROSSpots?.map((e) => e.toJson()).toList() ?? [],
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
        "allocPercentValue": "0"
      },
    );
  }

  void handleFPCTap() {
    var tempProgramName = "".obs, tempAlloc = "".obs, tempFpcTime = "".obs, tempCommercialCap = "".obs, tempBookedDur = "".obs, tempBal = "".obs;
    var includeROS = true.obs, includeOpenDeal = true.obs, moveSpotbuys = false.obs;
    var tempLeftList = <LstFPC>[].obs;
    if (!(showDataModel.value.infoShowBucketList?.lstFPC?.isEmpty ?? true)) {
      tempLeftList.value = showDataModel.value.infoShowBucketList?.lstFPC ?? [];
    }
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
                    // SizedBox(height: 20),
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
                        Obx(() {
                          return InputFields.formFieldDisable(
                            hintTxt: "Alloc %",
                            value: tempAlloc.value,
                            widthRatio: .07,
                          );
                        }),
                        const FormButton(btnText: "Reload"),
                        const FormButton(btnText: "Allocate"),
                        const FormButton(btnText: "Deallocat"),
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
                        Obx(() {
                          return CheckBoxWidget1(
                            title: "Move Spot buys",
                            value: moveSpotbuys.value,
                            onChanged: (val) => moveSpotbuys.value = val ?? false,
                          );
                        }),
                        Obx(() {
                          return CheckBoxWidget1(
                            title: "Include OPEN Deal?",
                            value: includeROS.value,
                            onChanged: (val) => includeROS.value = val ?? false,
                          );
                        }),
                        Obx(() {
                          return CheckBoxWidget1(
                            title: "Include OPEN Deal?",
                            value: includeROS.value,
                            onChanged: (val) => includeROS.value = val ?? false,
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
                                decoration: (tempLeftList.isEmpty)
                                    ? BoxDecoration(
                                        border: Border.all(
                                        color: Colors.grey,
                                      ))
                                    : null,
                                child: (tempLeftList.isEmpty)
                                    ? null
                                    : DataGridShowOnlyKeys(
                                        mapData: tempLeftList.map((e) => e.toJson()).toList(),
                                        formatDate: false,
                                        widthRatio: 220,
                                        hideCode: false,
                                        // colorCallback: (row) {
                                        //   if (tempLeftList[row.rowIdx].color == "") {
                                        //   } else if (tempLeftList[row.rowIdx].color == "") {
                                        //   } else {}
                                        // },

                                        onSelected: (row) {
                                          if (tempLeftList.isNotEmpty) {
                                            tempProgramName.value = tempLeftList[row.rowIdx ?? 0].programName ?? "";
                                            tempFpcTime.value = tempLeftList[row.rowIdx ?? 0].fpcTime ?? "";
                                            tempCommercialCap.value = (tempLeftList[row.rowIdx ?? 0].commercialCap ?? 0).toString();
                                            tempBookedDur.value = (tempLeftList[row.rowIdx ?? 0].bookedDuration ?? 0).toString();
                                            LoadingDialog.call();
                                            Get.find<ConnectorControl>().POSTMETHOD(
                                              api: ApiFactory.RO_DISTRIBUTION_GET_FPC_DOUBLE_CLICK_DATA,
                                              fun: (resp) {
                                                closeDialogIfOpen();
                                              },
                                              json: {
                                                "fromDate": DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy").parse(date.text)),
                                                "allowMoveSpotbuys": moveSpotbuys.value,
                                                "chkMoveSpotBuys": checkBoxes.value[2]['value'],
                                                "chkIncludeROS": checkBoxes.value[1]['value'],
                                                "chkOpenDeal": checkBoxes.value[0]['value'],
                                                "LstAllocatedSpots ": [
                                                  tempLeftList[row.rowIdx ?? 0].toJson(),
                                                ],
                                                "LstUnallocatedSpots": []
                                              },
                                            );
                                          }
                                        },
                                        onload: (sm) {
                                          if (tempLeftList.isNotEmpty) {
                                            tempProgramName.value = tempLeftList[0].programName ?? "";
                                            tempFpcTime.value = tempLeftList[0].fpcTime ?? "";
                                            tempCommercialCap.value = (tempLeftList[0].commercialCap ?? 0).toString();
                                            tempBookedDur.value = (tempLeftList[0].bookedDuration ?? 0).toString();
                                          }
                                        },
                                        mode: PlutoGridMode.selectWithOneTap,
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
                                  child: Container(
                                    decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                                  ),
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
      // LoadingDialog.call();
      // var selectedRowsInMainGridIDX = await getSelectedRowsInMainGrid();
      // var jsonList = <dynamic>[];
      // for (var i = 0; i < selectedRowsInMainGridIDX.length; i++) {
      //   jsonList.add(showDataModel.value.infoShowBucketList?.lstROSSpots![i].toJson());
      // }
      // Get.find<ConnectorControl>().POSTMETHOD(
      //     api: ApiFactory.RO_DISTRIBUTION_GET_UN_DATA,
      //     fun: (resp) {
      //       closeDialogIfOpen();
      //       if (resp != null &&
      //           resp is Map<String, dynamic> &&
      //           resp['info_GetUnalloacted']['lstROSSpots'] != null &&
      //           resp['info_GetUnalloacted']['lstROSSpots'] is List<dynamic> &&
      //           (resp['info_GetUnalloacted']['lstROSSpots'] as List<dynamic>).isNotEmpty) {
      //         var tempList = (resp['info_GetUnalloacted']['lstROSSpots'] as List<dynamic>);
      //         for (var i = 0; i < tempList.length; i++) {
      //           showDataModel.value.infoShowBucketList?.lstROSSpots!.removeAt(i);
      //           showDataModel.value.infoShowBucketList?.lstROSSpots!.insert(i, LstROSSpots.fromJson(tempList[i]));
      //         }
      //         showDataModel.refresh();
      //       } else {
      //         LoadingDialog.showErrorDialog(resp.toString());
      //       }
      //     },
      //     json: {
      //       "lstROSSpots": jsonList,
      //     });
    }
  }

  Future<void> handleServiceTap() async {
    if (selectedLocation == null || selectedChannel == null || (showDataModel.value.infoShowBucketList?.lstROSSpots?.isEmpty ?? true)) {
      return;
    } else {
      if (topButtons[5]['name'] == "Service") {
        topButtons[5]['name'] = "Revenue";
      } else {
        topButtons[5]['name'] = "Service";
      }
      update(['headRowBtn']);
      LoadingDialog.call();
      // var selectedRowsInMainGridIDX = await getSelectedRowsInMainGrid();
      // var jsonList = <dynamic>[];
      // for (var i = 0; i < selectedRowsInMainGridIDX.length; i++) {
      //   jsonList.add(showDataModel.value.infoShowBucketList?.lstROSSpots![i].toJson());
      // }
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
    } else {
      LoadingDialog.call();
      var selectedRowsInMainGridIDX = await getSelectedRowsInMainGrid();
      var jsonList = <dynamic>[];
      for (var i = 0; i < selectedRowsInMainGridIDX.length; i++) {
        jsonList.add(showDataModel.value.infoShowBucketList?.lstROSSpots![i].toJson());
      }
      Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.RO_DISTRIBUTION_GET_DEALLOCATE_DATA,
          fun: (resp) {
            closeDialogIfOpen();
            if (resp != null &&
                resp is Map<String, dynamic> &&
                resp['info_GetUnalloacted']['lstROSSpots'] != null &&
                resp['info_GetUnalloacted']['lstROSSpots'] is List<dynamic> &&
                (resp['info_GetUnalloacted']['lstROSSpots'] as List<dynamic>).isNotEmpty) {
              var tempList = (resp['info_GetUnalloacted']['lstROSSpots'] as List<dynamic>);
              for (var i = 0; i < tempList.length; i++) {
                showDataModel.value.infoShowBucketList?.lstROSSpots!.removeAt(i);
                showDataModel.value.infoShowBucketList?.lstROSSpots!.insert(i, LstROSSpots.fromJson(tempList[i]));
              }
              showDataModel.refresh();
            } else {
              LoadingDialog.showErrorDialog(resp.toString());
            }
          },
          json: {
            "lstROSSpots": jsonList,
          });
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
    selectedLocation = null;
    selectedChannel = null;
    date.text = "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";
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
  ///////////////////////////////////// COMMON FUNCTION END///////////
}

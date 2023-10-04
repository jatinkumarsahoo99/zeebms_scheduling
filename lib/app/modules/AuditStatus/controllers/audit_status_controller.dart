import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/controller/MainController.dart';
import 'package:bms_scheduling/app/modules/AuditStatus/bindings/audi_status_eshowcancel.dart';
import 'package:bms_scheduling/app/modules/AuditStatus/bindings/audi_status_show_reshdule.dart';
import 'package:bms_scheduling/app/modules/AuditStatus/bindings/audit_status_display.dart';
import 'package:bms_scheduling/app/modules/AuditStatus/bindings/audit_status_eshowbooking.dart';
import 'package:bms_scheduling/app/modules/AuditStatus/views/audit_reschedule_view.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/dummydata.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/app/providers/extensions/string_extensions.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/PlutoGrid/src/manager/pluto_grid_state_manager.dart';
import '../../../controller/HomeController.dart';
import '../../../data/DropDownValue.dart';
import '../../../data/user_data_settings_model.dart';
import '../bindings/audit_status_cancel_deals.dart';
import '../views/audit_cancellatin_view.dart';

class AuditStatusController extends GetxController {
  //TODO: Implement AuditStatusController
  var locations = RxList<DropDownValue>([]);
  var channels = RxList<DropDownValue>([]);
  RxBool isEnable = RxBool(true);
  TextEditingController dateController = TextEditingController();
  List<String> auditTypes = [
    "Addition",
    "Cancelation",
    "Reschedule",
  ];
  RxnString currentType = RxnString();
  AuditStatusShowEbooking? showEbookingData;
  List<AuditShowECancel>? showECancelData;
  List<AuditStatusShowReschdule>? showReschduleData;
  AuditStatusCancelDeals? auditStatusCancelDeals;
  AuditStatusReschduleDisplay? auditStatusReschduleDisplay;
  PlutoGridStateManager? stateManager;

  //input controllers
  DropDownValue? selectLocation;
  DropDownValue? selectChannel;

  getLocations() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.NewBookingActivityReport_GetLoadLocation,
        fun: (Map map) {
          locations.clear();
          map["locations"].forEach((e) {
            locations.add(DropDownValue.fromJson1(e));
          });
        });
  }

  getChannels(locationCode) {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.NewBookingActivityReport_cbolocationLeave(locationCode),
        fun: (Map map) {
          channels.clear();
          map["onLeaveLocation"].forEach((e) {
            channels.add(
                DropDownValue(key: e["channelCode"], value: e["channelName"]));
          });
        });
  }

  gettypeName(type) {
    switch (type) {
      case "Addition":
        return "Additions";
      case "Cancelation":
        return "Cancellation";
      case "Reschedule":
        return "Re-Schedule";
      default:
        return "Additions";
    }
  }

  List bookingData = [];

  showBtnData() {
    LoadingDialog.call();
    if ((currentType.value ?? "").isNotEmpty) {
      Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.NewBookingActivityReport_BtnShow,
          json: {
            "locationCode": selectLocation?.key,
            "channelCode": selectChannel?.key,
            "date": dateController.text.fromdMyToyMd(),
            "loggedUser": Get.find<MainController>().user?.logincode,
            "type": gettypeName(currentType.value)
          },
          fun: (map) {
            Get.back();
            if (map is Map && map.containsKey("inFo_Show")) {
              if (map["inFo_Show"]["lstAdditions"] != null) {
                bookingData = map["inFo_Show"]["lstAdditions"];
              } else if (map["inFo_Show"]["lstReSchedule"] != null) {
                bookingData = map["inFo_Show"]["lstReSchedule"];
              } else if (map["inFo_Show"]["lstCancellation"] != null) {
                bookingData = map["inFo_Show"]["lstCancellation"];
              }
            }
            update(["gridView"]);
          });
    }
  }

  Color getColor(Map<String, dynamic> dr, int index) {
    if (dr.containsKey("verifyStatus") && dr["verifyStatus"] == "No") {
      return const Color(0xFF00FFFF);
    } else if (dr.containsKey("auditedSpots") && dr['auditedSpots'] == 0) {
      return const Color.fromRGBO(255, 150, 150, 1);
    } else if (dr["bookingno"] == "Unaudited") {
      return const Color.fromRGBO(255, 230, 230, 1);
    } else if ((dr['auditedSpots'] ?? 0) < (dr["totalspots"] ?? 0)) {
      return const Color.fromRGBO(255, 150, 150, 1);
    }
    // if (index ==
    //     bookingData.indexWhere((element) =>
    //         element.containsKey("auditedSpots") &&
    //         element.containsKey("totalspots") &&
    //         element["auditedSpots"] != element["totalspots"] &&
    //         (element["auditedSpots"] ?? 0) < (dr["totalspots"] ?? 0))) {
    //   return const Color.fromRGBO(255, 150, 150, 1);
    // }

    return Colors.white; // Return null if no color conditions are met.
  }

  showECancel(index) {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.NewBookingActivityReport_GetShowECancel,
        json: {
          "locationCode": selectLocation?.key,
          "channelCode": selectChannel?.key,
          "cancelMonth": bookingData[index]["cancelmonth"],
          "cancelNumber": bookingData[index]["cancelNumber"],
        },
        fun: (json) async {
          if (json is Map) {
            if (json['lstShowECancel'] != null) {
              showECancelData = <AuditShowECancel>[];
              json['lstShowECancel'].forEach((v) {
                showECancelData!.add(AuditShowECancel.fromJson(v));
              });
              await showCancelDeals(
                  showECancelData?.first.bookingNumber,
                  bookingData[index]["cancelmonth"],
                  bookingData[index]["cancelNumber"]);
              Get.defaultDialog(
                  title: "Audit Cancellations",
                  content: Container(
                    height: Get.height * .80,
                    width: Get.width * .80,
                    child: AuditCanellation(
                      controller: this,
                      cancelMonth: bookingData[index]["cancelmonth"],
                      cancelNumber: bookingData[index]["cancelNumber"],
                    ),
                  ));
            }
          }
        });
  }

  showCancelDeals(bookingNumber, cancelMonth, cancelNumber) async {
    await Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.NewBookingActivityReport_CancelDisplayDetails,
        json: {
          "locationCode": selectLocation?.key,
          "channelCode": selectChannel?.key,
          "bookingNumber": bookingNumber,
          "cancelMonth": cancelMonth,
          "cancelNumber": cancelNumber
        },
        fun: (json) {
          if (json is Map && json.containsKey("lstcancelDisplay")) {
            auditStatusCancelDeals =
                AuditStatusCancelDeals.fromJson(json["lstcancelDisplay"]);
          }
        });
  }

  showEReschdule(index) {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.NewBookingActivityReport_ShowEReschedule,
        json: {
          "locationCode": selectLocation?.key,
          "channelCode": selectChannel?.key,
          "rescheduleMonth": bookingData[index]["reschedulemonth"],
          "rescheduleNumber": bookingData[index]["rescheduleNumber"],
        },
        fun: (json) async {
          if (json is Map) {
            if (json['lstshowEReschedule'] != null) {
              showReschduleData = <AuditStatusShowReschdule>[];
              json['lstshowEReschedule'].forEach((v) {
                showReschduleData!.add(AuditStatusShowReschdule.fromJson(v));
              });
              await showReschduleDeals(bookingData[index]["reschedulemonth"],
                  bookingData[index]["rescheduleNumber"]);
              Get.defaultDialog(
                  title: "Audit Reschedules",
                  content: Container(
                    height: Get.height * .80,
                    width: Get.width * .80,
                    child: AuditReschdule(controller: this),
                  ));
            }
          }
        });
  }

  showReschduleDeals(rescheduleMonth, rescheduleNumber) async {
    await Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.NewBookingActivityReport_RescheduleDisplay,
        json: {
          "locationCode": selectLocation?.key,
          "channelCode": selectChannel?.key,
          "rescheduleMonth": rescheduleMonth,
          "rescheduleNumber": rescheduleNumber
        },
        fun: (json) {
          if (json is Map && json.containsKey("lstReschedule")) {
            auditStatusReschduleDisplay =
                AuditStatusReschduleDisplay.fromJson(json["lstReschedule"]);
          }
        });
  }

  showEbooking(index) {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.NewBookingActivityReport_GetShowEbooking,
        json: {
          "locationCode": selectLocation?.key,
          "channelCode": selectChannel?.key,
          "bookingMonth": bookingData[index]["bookingmonth"],
          "bookingNumber": bookingData[index]["bookingnumber"],
          "bkno": bookingData[index]["bookingnumber"]
        },
        fun: (map) {
          if (map is Map && map.containsKey("inFo_ShowEbooking")) {
            showEbookingData =
                AuditStatusShowEbooking.fromJson(map["inFo_ShowEbooking"]);
            Get.defaultDialog(
                radius: 05,
                title: "",
                confirm: FormButtonWrapper(
                  btnText: "Return",
                  callback: () {
                    Get.back();
                  },
                ),
                content: Container(
                  width: Get.width * 0.74,
                  height: Get.height * 0.70,
                  child: Column(
                    children: [
                      Wrap(
                        spacing: Get.width * 0.01,
                        runSpacing: 5,
                        children: [
                          InputFields.formField1(
                            hintTxt: "Location",
                            controller: TextEditingController(
                                text: showEbookingData?.location),
                            width: 0.175,
                          ),
                          InputFields.formField1(
                            hintTxt: "Channel",
                            controller: TextEditingController(
                                text: showEbookingData?.channel),
                            width: 0.175,
                          ),
                          InputFields.formField1(
                            hintTxt: "Booking NO",
                            controller: TextEditingController(
                                text: showEbookingData?.bkmonth),
                            width: 0.0825,
                          ),
                          InputFields.formField1(
                            hintTxt: "",
                            controller: TextEditingController(
                                text: showEbookingData?.bkno),
                            width: 0.0825,
                          ),
                          DateWithThreeTextField(
                            title: "BKDate",
                            widthRation: 0.0825,
                            mainTextController: TextEditingController(),
                          ),
                          DateWithThreeTextField(
                            title: "Eff Date",
                            widthRation: 0.0825,
                            mainTextController: TextEditingController(),
                          ),
                          InputFields.formField1(
                            hintTxt: "Client",
                            controller: TextEditingController(
                                text: showEbookingData?.client),
                            width: 0.36,
                          ),
                          InputFields.formField1(
                            hintTxt: "Agency",
                            controller: TextEditingController(
                                text: showEbookingData?.ageny),
                            width: 0.36,
                          ),
                          InputFields.formField1(
                            hintTxt: "Brand",
                            controller: TextEditingController(
                                text: showEbookingData?.brand),
                            width: 0.36,
                          ),
                          InputFields.formField1(
                            hintTxt: "Zone",
                            controller: TextEditingController(
                                text: showEbookingData?.zone),
                            width: 0.175,
                          ),
                          InputFields.formField1(
                            hintTxt: "Pay Route",
                            controller: TextEditingController(),
                            width: 0.175,
                          ),
                          InputFields.formField1(
                            hintTxt: "PayMode",
                            controller: TextEditingController(),
                            width: 0.36,
                          ),
                          InputFields.formField1(
                            hintTxt: "",
                            controller: TextEditingController(),
                            width: 0.0825,
                          ),
                          InputFields.formField1(
                            hintTxt: "",
                            controller: TextEditingController(),
                            width: 0.0825,
                          ),
                          InputFields.formField1(
                            hintTxt: "",
                            controller: TextEditingController(),
                            width: 0.0825,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Expanded(
                          child: Container(
                        width: Get.width * 0.73,
                        child: DataGridShowOnlyKeys(
                          hideCode: false,
                          dateFormatKeys: ["auditedon"],
                          mapData: showEbookingData?.lstShowEbook
                                  ?.map((e) => e.toJson())
                                  .toList() ??
                              [],
                          onRowDoubleTap: (event) {
                            showDeals(showEbookingData
                                ?.lstShowEbook?[event.rowIdx].dealno);
                          },
                        ),
                      ))
                    ],
                  ),
                ));
          }
        });
  }

  showDeals(dealNo) {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.NewBookingActivityReport_Getshowdeal,
        json: {
          "locationCode": selectLocation?.key,
          "channelCode": selectChannel?.key,
          "dealno": dealNo
        },
        fun: (value) {
          if (value is Map && value.containsKey("inFo_showdeal")) {
            Get.defaultDialog(
                radius: 05,
                title: "Deal Details",
                confirm: FormButtonWrapper(
                  btnText: "Return",
                  callback: () {
                    Get.back();
                  },
                ),
                content: Container(
                  width: Get.width * 0.60,
                  height: Get.height * 0.50,
                  child: DataGridShowOnlyKeys(
                      hideCode: false,
                      dateFormatKeys: ["auditedon"],
                      mapData: value["inFo_showdeal"]["lstshowdeal"]),
                ));
          }
        });
  }

  @override
  void onInit() {
    getLocations();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    fetchUserSetting1();
  }

  UserDataSettings? userDataSettings;

  fetchUserSetting1() async {
    userDataSettings = await Get.find<HomeController>().fetchUserSetting2();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/controller/MainController.dart';
import 'package:bms_scheduling/app/modules/AuditStatus/bindings/audit_status_eshowbooking.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/dummydata.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/app/providers/extensions/string_extensions.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../data/DropDownValue.dart';

class AuditStatusController extends GetxController {
  //TODO: Implement AuditStatusController
  var locations = RxList<DropDownValue>([]);
  var channels = RxList<DropDownValue>([]);
  RxBool isEnable = RxBool(true);
  TextEditingController dateController = TextEditingController();
  List<String> auditTypes = ["Additions", "Re-Schedule", "Cancellation"];
  RxnString currentType = RxnString();
  AuditStatusShowEbooking? showEbookingData;
  //input controllers
  DropDownValue? selectLocation;
  DropDownValue? selectChannel;

  getLocations() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.NewBookingActivityReport_GetLoadLocation,
        fun: (Map map) {
          locations.clear();
          map["location"].forEach((e) {
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
            channels.add(DropDownValue(key: e["channelCode"], value: e["channelName"]));
          });
        });
  }

  List bookingData = [];

  showBtnData() {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.NewBookingActivityReport_BtnShow,
        json: {
          "locationCode": selectLocation?.key,
          "channelCode": selectChannel?.key,
          "date": dateController.text.fromdMyToyMd(),
          "loggedUser": Get.find<MainController>().user?.logincode,
          "type": currentType.value ?? ""
        },
        fun: (map) {
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
            showEbookingData = AuditStatusShowEbooking.fromJson(map["inFo_ShowEbooking"]);
            Get.defaultDialog(
                content: Container(
              width: Get.width * 0.70,
              height: Get.height * 0.70,
              child: Column(
                children: [
                  Wrap(
                    spacing: 05,
                    children: [
                      InputFields.formField1(
                        hintTxt: "Location",
                        controller: TextEditingController(text: showEbookingData?.location),
                        width: 0.18,
                      ),
                      InputFields.formField1(
                        hintTxt: "Channel",
                        controller: TextEditingController(text: showEbookingData?.channel),
                        width: 0.18,
                      ),
                      InputFields.formField1(
                        hintTxt: "Booking NO",
                        controller: TextEditingController(text: showEbookingData?.bkmonth),
                        width: 0.12,
                      ),
                      InputFields.formField1(
                        hintTxt: "",
                        controller: TextEditingController(text: showEbookingData?.bkno),
                        width: 0.09,
                      ),
                      DateWithThreeTextField(
                        title: "BKDate",
                        widthRation: 0.09,
                        mainTextController: TextEditingController(),
                      ),
                      DateWithThreeTextField(
                        title: "Eff Date",
                        widthRation: 0.09,
                        mainTextController: TextEditingController(),
                      ),
                      InputFields.formField1(
                        hintTxt: "Client",
                        controller: TextEditingController(text: showEbookingData?.client),
                        width: 0.36,
                      ),
                      InputFields.formField1(
                        hintTxt: "Agency",
                        controller: TextEditingController(text: showEbookingData?.ageny),
                        width: 0.36,
                      ),
                      InputFields.formField1(
                        hintTxt: "Brand",
                        controller: TextEditingController(text: showEbookingData?.brand),
                        width: 0.36,
                      ),
                      InputFields.formField1(
                        hintTxt: "Zone",
                        controller: TextEditingController(text: showEbookingData?.zone),
                        width: 0.18,
                      ),
                      InputFields.formField1(
                        hintTxt: "Pay Route",
                        controller: TextEditingController(),
                        width: 0.18,
                      ),
                      InputFields.formField1(
                        hintTxt: "PayMode",
                        controller: TextEditingController(),
                        width: 0.36,
                      ),
                      InputFields.formField1(
                        hintTxt: "",
                        controller: TextEditingController(),
                        width: 0.09,
                      ),
                      InputFields.formField1(
                        hintTxt: "",
                        controller: TextEditingController(),
                        width: 0.09,
                      ),
                      InputFields.formField1(
                        hintTxt: "",
                        controller: TextEditingController(),
                        width: 0.09,
                      ),
                    ],
                  ),
                  Expanded(
                      child: Container(
                    child: DataGridShowOnlyKeys(
                      mapData: showEbookingData?.lstShowEbook?.map((e) => e.toJson()).toList() ?? [],
                      onRowDoubleTap: (event) {
                        showDeals(showEbookingData?.lstShowEbook?[event.rowIdx].dealno);
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
        api: ApiFactory.NewBookingActivityReport_GetShowEbooking,
        json: {"locationCode": selectLocation?.key, "channelCode": selectChannel?.key, "dealno": dealNo},
        fun: (value) {
          if (value is Map && value.containsKey("inFo_showdeal")) {
            Get.defaultDialog(
                content: Container(
              width: Get.width * 0.60,
              height: Get.height * 0.50,
              child: DataGridShowOnlyKeys(mapData: value["inFo_showdeal"]["lstshowdeal"]),
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
  }

  @override
  void onClose() {
    super.onClose();
  }
}

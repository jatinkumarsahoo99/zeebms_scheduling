import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/controller/MainController.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/modules/RoBooking/bindings/ro_booking_agency_leave_data.dart';
import 'package:bms_scheduling/app/modules/RoBooking/bindings/ro_booking_bkg_data.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/booking_summary_view.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/deal_view.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/make_good_spots_view.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/program_view.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/spot_not_verified_view.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/spots_view.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/verify_spots_view.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/app/providers/extensions/string_extensions.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../bindings/ro_booking_init_data.dart';

class RoBookingController extends GetxController {
  TextEditingController fpcEffectiveDateCtrl = TextEditingController(),
      bookDateCtrl = TextEditingController(),
      refNoCtrl = TextEditingController(),
      bookingMonthCtrl = TextEditingController(),
      bookingNoCtrl = TextEditingController(),
      dealTypeCtrl = TextEditingController(),
      payrouteCtrl = TextEditingController(),
      payModeCtrl = TextEditingController(),
      bookingNoTrailCtrl = TextEditingController(),
      totSpotCtrl = TextEditingController(),
      totDurCtrl = TextEditingController(),
      totAmtCtrl = TextEditingController(),
      zoneCtrl = TextEditingController(),
      maxspendCtrl = TextEditingController();
  PageController pagecontroller = PageController(keepPage: false);
  TextEditingController mgfromDateCtrl = TextEditingController(), mgtoDateCtrl = TextEditingController();
  PlutoGridStateManager? dealViewGrid;
  RoBookingAgencyLeaveData? agencyLeaveData;
  RxString currentTab = RxString("Deal");
  RoBookingInitData? roBookingInitData;
  RoBookingBkgNOLeaveData? bookingNoLeaveData;

  FocusNode bookingNoFocusNode = FocusNode();
  var spotsNotVerifiedData = RxList();

  DropDownValue? selectedLocation;
  DropDownValue? selectedChannel;
  DropDownValue? selectedClient;

  var channels = RxList<DropDownValue>();
  var clients = RxList<DropDownValue>();
  var agencies = RxList<DropDownValue>();

  //TODO: Implement RoBookingController
  Map tabs = {
    "Deal": DealView(),
    "Programs": ProgramView(),
    "Spots": SpotsView(),
    "Make Good Spots": MakeGoodSpotsView(),
    "Booking Summary": BookingSummaryView(),
    "Spots Not Verified": SpotNotVerifiedView(),
    "Verify Spots": VerifySpotsView(),
  };
  final count = 0.obs;
  @override
  void onInit() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.RO_BOOKING_INIT,
        fun: (data) {
          if (data is Map && data.containsKey("info_RoBookingLoad")) {
            roBookingInitData = RoBookingInitData.fromJson(data["info_RoBookingLoad"]);
            update(["init"]);
          }
        });
    bookingNoFocusNode.addListener(() {
      if (!bookingNoFocusNode.hasFocus && bookingNoCtrl.text.isNotEmpty) {
        onBookingNoLeave();
      }
    });
    super.onInit();
  }

  getChannel(locId) {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.RO_BOOKING_CHANNNEL(locId),
        fun: (data) {
          if (data is Map && data.containsKey("info_LeaveLocationChannelList") && data["info_LeaveLocationChannelList"] is List) {
            List<DropDownValue> _channels = [];
            for (var e in data["info_LeaveLocationChannelList"]) {
              _channels.add(DropDownValue(key: e["channelCode"], value: e["channelName"]));
            }
            channels.value = _channels;
          }
        });
  }

  effDtLeave() {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.RO_BOOKING_EFFDT_LEAVE(selectedLocation!.key!, selectedChannel!.key!, fpcEffectiveDateCtrl.text.fromdMyToyMd()),
        fun: (dataMap) {
          if (dataMap is Map && dataMap.containsKey("info_GetEffectiveDateLeave")) {
            Map data = dataMap["info_GetEffectiveDateLeave"];
            if (data.containsKey("lstClientAgency") && data["lstClientAgency"] is List) {
              List<DropDownValue> _clients = [];
              for (var e in data["lstClientAgency"]) {
                _clients.add(DropDownValue(key: e["clientcode"], value: e["clientname"]));
              }
              clients.value = _clients;
            }
            if (data.containsKey("bookingMonth")) {
              bookingMonthCtrl.text = data["bookingMonth"];
            }
          }
        });
  }

  clientLeave(clientCode) {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.RO_BOOKING_CLIENT_LEAVE(selectedLocation!.key!, selectedChannel!.key!, clientCode),
        fun: (data) {
          if (data is Map && data.containsKey("info_ClientList") && data["info_ClientList"] is List) {
            List<DropDownValue> _agencies = [];
            for (var e in data["info_ClientList"]) {
              _agencies.add(DropDownValue(key: e["agencycode"], value: e["agencyname"]));
            }
            agencies.value = _agencies;
          }
        });
  }

  agencyLeave(agencyCode) {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.RO_BOOKING_OnAgencyLeave,
        json: {
          "Locationname": selectedLocation!.value,
          "locationCode": selectedLocation!.key,
          "ChannelCode": selectedChannel!.key,
          "ChannelName": selectedChannel!.value,
          "clientCode": selectedClient!.key,
          "agencyCode": agencyCode,
          "bookingMonth": bookingMonthCtrl.text,
          "bookingnumber": bookingNoCtrl.text,
          "payroutecode": "",
          "intEditMode": 1,
          "effectiveDate": fpcEffectiveDateCtrl.text.fromdMyToyMd(),
          "loginCode": Get.find<MainController>().user?.logincode,
          "GSTPlants": ""
        },
        fun: (data) {
          if (data is Map && data.containsKey("info_AgencyLeave")) {
            agencyLeaveData = RoBookingAgencyLeaveData.fromJson(data["info_AgencyLeave"]);
          }
          // if (data is Map && data.containsKey("info_ClientList") && data["info_ClientList"] is List) {
          //   List<DropDownValue> _agencies = [];
          //   for (var e in data["info_ClientList"]) {
          //     _agencies.add(DropDownValue(key: e["agencycode"], value: e["agencyname"]));
          //   }
          //   agencies.value = _agencies;
          // }
        });
  }

  dealNoLeave(dealNo) {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.RO_BOOKING_OnLeaveDealNumber,
        json: {"locationcode": selectedLocation!.key, "channelcode": selectedChannel!.key, "dealNo": dealNo, "clientCode": selectedClient!.key},
        fun: (response) {});
  }

  getSpotsNotVerified(location, channel, month) {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.RO_BOOKING_GET_SpotsNotVerified,
        json: {
          "locationCode": location,
          "channelCode": channel,
          "bookingMonth": month,
          "loggedUser": Get.find<MainController>().user?.logincode,
        },
        fun: (response) {
          if (response is Map && response.containsKey("info_SpotsNotVerified")) {
            spotsNotVerifiedData.value = response["info_SpotsNotVerified"];
          }
        });
  }

  getDisplay() {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.RO_BOOKING_GET_DISPLAY,
        json: {
          "locationName": selectedLocation!.key,
          "channelName": selectedChannel!.key,
          "clientName": bookingNoLeaveData!.lstClientAgency!.first.clientname,
          "agencyName": bookingNoLeaveData!.lstAgency!.first.agencyname,
          "brandName": bookingNoLeaveData!.lstBrand!.first.brandname,
          "fromDate": mgfromDateCtrl.text.fromdMyToyMd(),
          "toDate": mgtoDateCtrl.text.fromdMyToyMd(),
          "eBookingMonth": bookingMonthCtrl.text,
          "eBookingNumber": bookingNoCtrl.text,
        },
        fun: (response) {});
  }

  onBookingNoLeave() {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.RO_BOOKING_BOOKING_NO_LEAVE,
        json: {
          "locationcode": selectedLocation!.key,
          "channelcode": selectedChannel!.key,
          "bookingMonth": bookingMonthCtrl.text,
          "bookingnumber": bookingNoCtrl.text,
          "formname": "frmROBooking"
        },
        fun: (value) {
          if (value is Map && value.containsKey("info_LeaveBookingNumber")) {
            bookingNoLeaveData = RoBookingBkgNOLeaveData.fromJson(value["info_LeaveBookingNumber"]);
            selectedClient = DropDownValue(
                key: bookingNoLeaveData!.lstClientAgency!.first.clientcode, value: bookingNoLeaveData!.lstClientAgency!.first.clientname);
            update(["init"]);
            refNoCtrl.text = bookingNoLeaveData!.bookingReferenceNumber ?? "";
            bookingNoTrailCtrl.text = bookingNoLeaveData!.zone ?? "";
            dealTypeCtrl.text = bookingNoLeaveData!.dealType ?? "";
            payModeCtrl.text = bookingNoLeaveData!.payMode ?? "";
            payrouteCtrl.text = bookingNoLeaveData!.payrouteName ?? "";
            totSpotCtrl.text = bookingNoLeaveData!.totalSpots ?? "";
            totDurCtrl.text = bookingNoLeaveData!.totalDuration ?? "";
            totAmtCtrl.text = bookingNoLeaveData!.totalAmount ?? "";
            zoneCtrl.text = bookingNoLeaveData!.zonename ?? "";
            maxspendCtrl.text = bookingNoLeaveData!.maxSpend ?? "";
            update(["dealGrid"]);
          }
        });
  }

  dealdoubleclick(colId, rowId) {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.RO_BOOKING_DEAL_DOUBLE_CLICK,
        json: {
          "locationCode": selectedLocation!.key,
          "channelCode": selectedChannel!.key,
          "brandCode": bookingNoLeaveData!.brandcode,
          "zone": bookingNoLeaveData!.zone,
          "executiveCode": bookingNoLeaveData!.executiveCode,
          "payroute": bookingNoLeaveData!.payrouteName,
          "dealNo": bookingNoLeaveData!.dealno,
          "revenueType": bookingNoLeaveData!.revenueType,
          "effectiveDate": bookingNoLeaveData!.bookingEffectiveDate,
          "zoneCode": bookingNoLeaveData!.zonecode,
          "tapeId": "",
          "duration": bookingNoLeaveData!.totalDuration,
          "dgvDealDetail_RowIndex": rowId,
          "dgvDealDetail_ColumnIndex": colId,
          "previousBookedAmount": bookingNoLeaveData!.previousBookedAmount,
          "previousValAmount": bookingNoLeaveData!.previousValAmount,
          "lstdgvDealDetails": bookingNoLeaveData!.lstdgvDealDetails!.map((e) => e.toJson()).toList(),
          "lstSpots": bookingNoLeaveData!.lstSpots!.map((e) => e.toJson()).toList(),
        },
        fun: (value) {});
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

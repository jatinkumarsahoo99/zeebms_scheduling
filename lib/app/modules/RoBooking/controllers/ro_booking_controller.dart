import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/booking_summary_view.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/deal_view.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/make_good_spots_view.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/program_view.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/spot_not_verified_view.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/spots_view.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/verify_spots_view.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/app/providers/extensions/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../bindings/ro_booking_init_data.dart';

class RoBookingController extends GetxController {
  TextEditingController fpcEffectiveDateCtrl = TextEditingController(),
      bookDateCtrl = TextEditingController(),
      refNoCtrl = TextEditingController(),
      bookingMonthCtrl = TextEditingController(),
      bookingNoCtrl = TextEditingController(),
      bookingNoTrailCtrl = TextEditingController(),
      totSpotCtrl = TextEditingController(),
      totDurCtrl = TextEditingController(),
      totAmtCtrl = TextEditingController(),
      zoneCtrl = TextEditingController(),
      maxspendCtrl = TextEditingController();
  PageController controller = PageController();
  RxString currentTab = RxString("Deal");
  RoBookingInitData? roBookingInitData;

  DropDownValue? selectedLocation;
  DropDownValue? selectedChannel;
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

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

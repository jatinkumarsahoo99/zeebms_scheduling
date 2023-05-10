import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controller/ConnectorControl.dart';
import '../../../data/DropDownValue.dart';

class RoCancellationController extends GetxController {
  //TODO: Implement RoCancellationController

  DateFormat df2 = DateFormat("yyyy-MM-dd");
  RxList<DropDownValue> locations = <DropDownValue>[].obs;
  RxList<DropDownValue> channels = <DropDownValue>[].obs;
  TextEditingController cancelDatectrl = TextEditingController();
  DropDownValue? selectedLocation;
  DropDownValue? selectedChannel;
  TextEditingController effDatectrl = TextEditingController();
  TextEditingController refNumberctrl = TextEditingController();

  TextEditingController bookingNumberctrl = TextEditingController();

  TextEditingController cancelNumberctrl = TextEditingController();

  TextEditingController cancelMonthctrl = TextEditingController();
  TextEditingController clientctrl = TextEditingController();
  TextEditingController agencyctrl = TextEditingController();
  TextEditingController brandctrl = TextEditingController();
  FocusNode bookingNumberFocus = FocusNode();
  FocusNode cancelNumberFocus = FocusNode();

  @override
  void onInit() {
    getLocation();
    bookingNumberFocus.addListener(() {
      if (!bookingNumberFocus.hasFocus) {
        onBookingNoLeave(bookingNumberctrl.text);
      }
    });
    super.onInit();
  }

  getLocation() {
    try {
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.RO_CANCELLATION_LOCATION,
          fun: (data) {
            if (data is List) {
              locations.value = data
                  .map((e) => DropDownValue(
                      key: e["locationCode"], value: e["locationName"]))
                  .toList();
            } else {
              LoadingDialog.callErrorMessage1(
                  msg: "Failed To Load Initial Data");
            }
          });
    } catch (e) {
      LoadingDialog.callErrorMessage1(msg: "Failed To Load Initial Data");
    }
  }

  getChannel(locationCode) {
    try {
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.RO_CANCELLATION_CHANNNEL(locationCode),
          fun: (data) {
            if (data is List) {
              channels.value = data
                  .map((e) => DropDownValue(
                      key: e["channelCode"], value: e["channelName"]))
                  .toList();
            } else {
              LoadingDialog.callErrorMessage1(
                  msg: "Failed To Load Initial Data");
            }
          });
    } catch (e) {
      LoadingDialog.callErrorMessage1(msg: "Failed To Load Initial Data");
    }
  }

  onBookingNoLeave(bookingNo) {
    print("ON BOOKING NUMBER LEAVE CALLED>>>");
    try {
      Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.RO_CANCELLATION_BOOKINGNO_LEAVE,
          json: {
            "locationCode": selectedLocation!.key,
            "channelCode": selectedChannel!.key,
            "bookingNo": bookingNo,
            "cancelMonth": 0,
            "cancelNumber": 0
          },
          fun: (data) {
            print(data);
          });
    } catch (e) {
      LoadingDialog.callErrorMessage1(msg: "Failed To Load  Data");
    }

    print("ON BOOKING NUMBER LEAVE END>>>");
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

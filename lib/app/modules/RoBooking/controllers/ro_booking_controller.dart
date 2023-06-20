import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/controller/MainController.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/modules/RoBooking/bindings/ro_booking_agency_leave_data.dart';
import 'package:bms_scheduling/app/modules/RoBooking/bindings/ro_booking_bkg_data.dart';
import 'package:bms_scheduling/app/modules/RoBooking/bindings/ro_booking_deal_click.dart';
import 'package:bms_scheduling/app/modules/RoBooking/bindings/ro_booking_tape_search_data.dart';
import 'package:bms_scheduling/app/modules/RoBooking/bindings/ro_dealno_leave.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/booking_summary_view.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/deal_view.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/make_good_spots_view.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/program_view.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/spot_not_verified_view.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/spots_view.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/verify_spots_view.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/app/providers/extensions/string_extensions.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
  RxnString currentTab = RxnString();
  RoBookingInitData? roBookingInitData;
  RoBookingBkgNOLeaveData? bookingNoLeaveData;
  RoBookingDealNoLeave? dealNoLeaveData;
  RoBookingDealDblClick? dealDblClickData;
  RoBookingTapeSearchData? bookingTapeSearchData;

  FocusNode bookingNoFocusNode = FocusNode();
  var spotsNotVerifiedData = RxList();

  DropDownValue? selectedLocation;
  DropDownValue? selectedChannel;
  DropDownValue? selectedClient;
  DropDownValue? selectedAgnecy;
  DropDownValue? selectedDeal;
  DropDownValue? selectedSeg;
  DropDownValue? selectedPremid;
  DropDownValue? selectedTapeID;
  DropDownValue? selectedPosition;
  DropDownValue? selectedExecutive;
  DropDownValue? selectedBreak;
  DropDownValue? selectedGST;

  var channels = RxList<DropDownValue>();
  var clients = RxList<DropDownValue>();
  var agencies = RxList<DropDownValue>();
  List tapeIds = [];

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
    if (selectedLocation != null && selectedChannel != null) {
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
            selectedAgnecy = agencies.value.first;
            update(["init"]);
          }
        });
  }

  brandLeave(brandCode) {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.RO_BOOKING_BRAND_LEAVE,
        json: {
          "dealNo": selectedDeal?.key,
          "clientcode": selectedClient?.key,
          "effectivedate": fpcEffectiveDateCtrl.text.fromdMyToyMd(),
          "agencycode": selectedAgnecy?.key,
          "brandcode": brandCode,
          "locationCode": selectedLocation?.key,
          "channelCode": selectedChannel?.key,
          "brandCode": brandCode,
          "activityMonth": bookingMonthCtrl.text,
          "accountCode": bookingNoLeaveData?.accountCode ?? "",
          "subRevenueTypeCode": dealNoLeaveData?.strRevenueTypeCode,
          "revenueType": dealNoLeaveData?.strRevenueTypeCode
        },
        fun: (value) {});
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
            selectedDeal = DropDownValue(
              key: agencyLeaveData?.lstDealNumber?.first.dealNumber ?? "",
              value: agencyLeaveData?.lstDealNumber?.first.dealNumber ?? "",
            );
            selectedExecutive = DropDownValue(
                key: agencyLeaveData?.excutiveDetails?.first.personnelCode ?? "", value: agencyLeaveData?.excutiveDetails?.first.personnelname);
            update(["init"]);
            Get.defaultDialog(
                title: "GST Plant",
                content: SizedBox(
                  height: Get.height / 4,
                  width: Get.width / 4,
                  child: Column(
                    children: [
                      DropDownField.formDropDown1WidthMap(
                        agencyLeaveData?.lstGstPlants?.map((e) => DropDownValue(key: e.plantid?.toString(), value: e.column1)).toList(),
                        (value) => {},
                        "Rev Type",
                        0.11,
                        selected: selectedGST,
                      )
                    ],
                  ),
                ));
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

  getSegment() {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.RO_BOOKING_GetSegment,
        json: {
          "locationCode": selectedLocation!.key,
          "channelCode": selectedClient!.key,
          "telecastDate": "2023-03-01",
          "telecastTime": "",
          "programCode": "00:10:00"
        },
        fun: (data) {
          if (data is Map && data.containsKey("info_AgencyLeave")) {
            agencyLeaveData = RoBookingAgencyLeaveData.fromJson(data["info_AgencyLeave"]);
            selectedDeal = DropDownValue(
              key: agencyLeaveData?.lstDealNumber?.first.dealNumber ?? "",
              value: agencyLeaveData?.lstDealNumber?.first.dealNumber ?? "",
            );
            update(["init"]);
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

  setVerify() {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.RO_BOOKING_GetSetVerify,
        json: {
          "locationName": selectedLocation!.value,
          "channelName": selectedChannel!.value,
          "bookingMonth": bookingMonthCtrl.text,
          "bookingNumber": bookingNoCtrl.text,
          "loginName": Get.find<MainController>().user?.loginName,
          "locationCode": selectedLocation!.key,
          "channelCode": selectedChannel!.key,
          "loggedUser": Get.find<MainController>().user?.logincode,
        },
        fun: (response) {});
  }

  tapIdLeave(selectedvalue) {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.RO_BOOKING_cboTapeIdLeave,
        json: {"cboTapeIdSelectedValue": selectedvalue, "lstTapeDetails": [], "rate": dealDblClickData?.rate},
        fun: (response) {
          if (response is Map && response.containsKey("info_SearchTapeId")) {
            bookingTapeSearchData = RoBookingTapeSearchData.fromJson(response["info_SearchTapeId"]);
            update(["programView"]);
          }
        });
  }

  tapeIdSearch(exportCode) {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.RO_BOOKING_SearchTapeIdLeave(exportCode),
        fun: (response) {
          // if (response is Map && response.containsKey("info_SearchTapeId")) {
          //   bookingTapeSearchData = RoBookingTapeSearchData.fromJson(response["info_SearchTapeId"]);
          //   update(["programView"]);
          // }
        });
  }

  dealNoLeave() {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.RO_BOOKING_OnLeaveDealNumber,
        json: {
          "locationcode": selectedLocation!.key,
          "channelcode": selectedChannel!.key,
          "dealNo": selectedDeal!.key,
          "clientCode": selectedClient!.key
        },
        fun: (response) {
          if (response is Map && response.containsKey("info_LeaveDealNumber")) {
            dealNoLeaveData = RoBookingDealNoLeave.fromJson(response["info_LeaveDealNumber"]);

            update(["init"]);
          }
        });
  }

  // void addToSpotsGrid(List<Map<String, dynamic>> dgvPrograms, List<Map<String, dynamic>> dtSpotsData, List<Map<String, dynamic>> dtDealDetails,
  //     List<Map<String, dynamic>> dgvSpots,rowIdx) {
  //   String strProgramName, strTelecastDate, strProgramCode;
  //   String strStartTime, strEndTime;
  //   int intSpots, intTotalBookedSpots = 0;

  //   for (int i = 0; i < dgvPrograms.length; i++) {
  //     if (int.parse(dgvPrograms[i]["bookedspots"].toString()) > 0) {
  //       strProgramName = dgvPrograms[i]["programname"].toString();
  //       strTelecastDate = dgvPrograms[i]["telecastdate"].toString();
  //       strStartTime = dgvPrograms[i]["starttime"].toString();
  //       strEndTime = dgvPrograms[i]["endtime"].toString();
  //       intSpots = int.parse(dgvPrograms[i]["bookedspots"].toString());
  //       intTotalBookedSpots += intSpots;
  //       strProgramCode = dgvPrograms[i]["programcode"].toString();

  //       dtSpotsData.add({
  //         "ProgramName": strProgramName,
  //         "TelecastDate": strTelecastDate,
  //         "StartTime": strStartTime.toString(),
  //         "EndTime": strEndTime,
  //         "Spots": intSpots,
  //         "TapeId": selectedTapeID!.key,
  //         "SegNo": selectedSeg!.key,
  //         "Duration": (bookingTapeSearchData?.lstSearchTapeId?.first.commercialDuration??1) * intSpots,
  //         "PreMid": selectedPremid!.key,
  //         "BreakNo": selectedBreak!.key,
  //         "PositionNo": selectedPosition!.key,
  //         "Total": 1,
  //         "TotalSpots": 1* intSpots,
  //         "DealNo": selectedDeal!.key,
  //         "DealRowNo": rowIdx,
  //         "EmptyField": "",
  //         "Field": "0-0",
  //         "Caption": bookingTapeSearchData?.lstSearchTapeId?.first.commercialCaption,
  //         "ProgramCode": strProgramCode,
  //         "PreMidValue": selectedPremid!.value,
  //         "PositionNoValue": selectedPosition!.value
  //       });
  //     }
  //   }
  //   dtSpotsData;

  //   // Updating Deal Grid and DT
  //   for (int i = 0; i < dtDealDetails.length; i++) {
  //     if (int.parse(dtDealDetails[i]["recordnumber"]) == rowIdx &&
  //         dtDealDetails[i]["locationname"] == selectedLocation!.value &&
  //         dtDealDetails[i]["channelname"] == selectedChannel!.value &&
  //         dtDealDetails[i]["dealnumber"] == selectedDeal!.key) {
  //       if (bookingNoLeaveData?.accountCode != "I000100010" && bookingNoLeaveData?.accountCode != "I000100005" && bookingNoLeaveData?.accountCode != "I000100004" && bookingNoLeaveData?.accountCode != "I000100013") {
  //         dtDealDetails[0][i]["bookedseconds"] =
  //             int.parse(dtDealDetails[0][i]["bookedseconds"]) + (bookingTapeSearchData?.lstSearchTapeId?.first.commercialDuration??1 * intTotalBookedSpots);
  //       } else if (bookingNoLeaveData?.accountCode == "I000100010" && int.parse(intSubRevenueTypeCode) == 9) {
  //         dtDealDetails[i]["bookedseconds"] =
  //             int.parse(dtDealDetails[i]["bookedseconds"]) + (int.parse(txtDuration.Text) * intTotalBookedSpots);
  //       } else {
  //         dtDealDetails[i]["bookedseconds"] = int.parse(dtDealDetails[i]["bookedseconds"]) + intTotalBookedSpots;
  //       }

  //       dtDealDetails[i]["balanceseconds"] = int.parse(dtDealDetails[i]["seconds"]) - int.parse(dtDealDetails[i]["bookedseconds"]);
  //       // BalanceSeconds = dtDealDetails[i]["balanceseconds"];
  //       // dtDealDetails[0].acceptChanges();
  //       // dgvDealDetail[0] = dtDealDetails;
  //       // hideDealGridCols();
  //       break;
  //     }
  //   }
  //   hideRows(dgvDealDetail);

  //   // Set Booked Spots Column to 0
  //   for (int i = 0; i < dgvPrograms.length; i++) {
  //     dgvPrograms[i]["bookedspots"] = 0;
  //   }
  // }

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
            selectedAgnecy =
                DropDownValue(key: bookingNoLeaveData!.lstAgency!.first.agencycode, value: bookingNoLeaveData!.lstAgency!.first.agencyname);
            selectedDeal =
                DropDownValue(key: bookingNoLeaveData!.lstDealNumber!.first.dealNumber, value: bookingNoLeaveData!.lstDealNumber!.first.dealNumber);
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
          "dgvDealDetail_RowIndex": rowId,
          "dgvDealDetail_ColumnIndex": colId,
          "previousBookedAmount": bookingNoLeaveData?.previousBookedAmount,
          "previousValAmount": bookingNoLeaveData?.previousValAmount,
          "channelCode": bookingNoLeaveData?.channelcode,
          "lstdgvDealDetails": bookingNoLeaveData?.lstdgvDealDetails?.map((e) => e.toJson()).toList(),
          "lstSpots": bookingNoLeaveData?.lstSpots?.map((e) => e.toJson()).toList(),
          "brandCode": bookingNoLeaveData?.brandcode,
          "zone": bookingNoLeaveData?.zone,
          "executiveCode": bookingNoLeaveData?.executiveCode,
          "payroute": bookingNoLeaveData?.payrouteName,
          "dealNo": bookingNoLeaveData?.dealno,
          "locationCode": bookingNoLeaveData?.locationCode,
          "revenueType": bookingNoLeaveData?.revenueType,
          "effectiveDate": DateFormat("dd-MM-yyyy").format(DateFormat("dd/MM/yyyy").parse(bookingNoLeaveData?.bookingEffectiveDate ?? "")),
          "zoneCode": bookingNoLeaveData?.zonecode,
          "tapeId": "",
          "duration": bookingNoLeaveData?.totalDuration,
          "intEditMode": bookingNoLeaveData?.intEditMode,
          "brandRequest": {
            "dealNo": bookingNoLeaveData?.dealno,
            "clientcode": bookingNoLeaveData?.clientcode,
            "effectivedate": DateFormat("dd-MM-yyyy").format(DateFormat("dd/MM/yyyy").parse(bookingNoLeaveData?.bookingEffectiveDate ?? "")),
            "agencycode": bookingNoLeaveData?.agencycode,
            "brandcode": bookingNoLeaveData?.brandcode,
            "locationCode": bookingNoLeaveData?.locationCode,
            "channelCode": bookingNoLeaveData?.channelcode,
            "activityMonth": bookingMonthCtrl.text,
            "accountCode": bookingNoLeaveData?.accountCode,
            "subRevenueTypeCode": bookingNoLeaveData?.revenueType,
            "revenueType": bookingNoLeaveData?.revenueType
          }
        },

        //  {
        //   "locationCode": selectedLocation!.key,
        //   "channelCode": selectedChannel!.key,
        //   "brandCode": bookingNoLeaveData!.brandcode,
        //   "zone": bookingNoLeaveData!.zone,
        //   "executiveCode": bookingNoLeaveData!.executiveCode,
        //   "payroute": bookingNoLeaveData!.payrouteName,
        //   "dealNo": bookingNoLeaveData!.dealno,
        //   "revenueType": bookingNoLeaveData!.revenueType,
        //   "effectiveDate": bookingNoLeaveData!.bookingEffectiveDate,
        //   "zoneCode": bookingNoLeaveData!.zonecode,
        //   "tapeId": "",
        //   "duration": bookingNoLeaveData!.totalDuration,
        //   "dgvDealDetail_RowIndex": rowId,
        //   "dgvDealDetail_ColumnIndex": colId,
        //   "previousBookedAmount": bookingNoLeaveData!.previousBookedAmount,
        //   "previousValAmount": bookingNoLeaveData!.previousValAmount,
        //   "lstdgvDealDetails": bookingNoLeaveData!.lstdgvDealDetails!.map((e) => e.toJson()).toList(),
        //   "lstSpots": bookingNoLeaveData!.lstSpots!.map((e) => e.toJson()).toList(),
        // },
        fun: (value) async {
          if (value is Map && value.containsKey("info_dgvDealDetailCellDouble") && value["info_dgvDealDetailCellDouble"]["message"] == null) {
            dealDblClickData = RoBookingDealDblClick.fromJson(value["info_dgvDealDetailCellDouble"]);
            var _selectedPostion = roBookingInitData?.lstPosition
                ?.firstWhere((element) => element.column1?.toLowerCase() == dealDblClickData?.positionNo!.toLowerCase());
            selectedPosition = DropDownValue(key: _selectedPostion?.positioncode ?? "", value: _selectedPostion?.column1 ?? "");
            var _selectedPredMid = roBookingInitData?.lstspotpositiontype
                ?.firstWhere((element) => element.spotPositionTypeName?.toLowerCase() == dealDblClickData?.preMid!.toLowerCase());
            selectedPremid = DropDownValue(key: _selectedPredMid?.spotPositionTypeCode ?? "", value: _selectedPredMid?.spotPositionTypeName ?? "");

            selectedBreak = DropDownValue(key: dealDblClickData?.breakNo.toString() ?? "", value: dealDblClickData?.breakNo.toString() ?? "");
            await getTapeID();

            pagecontroller.jumpToPage(1);
            currentTab.value = "Programs";
          }
          if (value is Map && value.containsKey("info_dgvDealDetailCellDouble") && value["info_dgvDealDetailCellDouble"]["message"] != null) {
            LoadingDialog.callErrorMessage1(msg: value["info_dgvDealDetailCellDouble"]["message"]);
          }
        });
  }

  getTapeID() async {
    await Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.RO_BOOKING_cboTapeIdFocusLost,
        json: {
          "brandCode": bookingNoLeaveData?.brandcode ?? "",
          "strAccountCode": bookingNoLeaveData?.accountCode,
          "locationCode": selectedLocation?.key ?? "",
          "channelCode": selectedChannel?.key,
          "intSubRevenueTypeCode": "0"
        },
        fun: (value) {
          if (value is Map &&
              value.containsKey("info_GetTapeLost") &&
              value["info_GetTapeLost"].containsKey("lstTape") &&
              value["info_GetTapeLost"]["lstTape"] is List) {
            tapeIds = value["info_GetTapeLost"]["lstTape"];
          }
        });
  }

  @override
  void onReady() {
    currentTab.value = "Deal";
    update(["pageView"]);
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

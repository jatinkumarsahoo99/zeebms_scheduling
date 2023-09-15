import 'dart:convert';

import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/controller/MainController.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/modules/RoBooking/bindings/ro_booking_add_spot_data.dart';
import 'package:bms_scheduling/app/modules/RoBooking/bindings/ro_booking_agency_leave_data.dart';
import 'package:bms_scheduling/app/modules/RoBooking/bindings/ro_booking_bkg_data.dart';
import 'package:bms_scheduling/app/modules/RoBooking/bindings/ro_booking_brand_leave.dart';
import 'package:bms_scheduling/app/modules/RoBooking/bindings/ro_booking_deal_click.dart';
import 'package:bms_scheduling/app/modules/RoBooking/bindings/ro_booking_spot_not_verified.dart';
import 'package:bms_scheduling/app/modules/RoBooking/bindings/ro_booking_spot_view_click.dart';
import 'package:bms_scheduling/app/modules/RoBooking/bindings/ro_booking_tape_leave_data.dart';
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
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:bms_scheduling/widgets/keepalive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controller/HomeController.dart';
import '../../../data/user_data_settings_model.dart';
import '../../../providers/SizeDefine.dart';
import '../bindings/ro_booking_init_data.dart';
import '../bindings/ro_booking_save_check.dart';

class RoBookingController extends GetxController {
  UserDataSettings? userDataSettings;

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
      tapeIDCtrl = TextEditingController(),
      dealFromCtrl = TextEditingController(),
      dealToCtrl = TextEditingController(),
      zoneCtrl = TextEditingController(),
      gstNoCtrl = TextEditingController(),
      maxspendCtrl = TextEditingController();
  PageController pagecontroller = PageController(keepPage: true);
  TextEditingController mgfromDateCtrl = TextEditingController(),
      mgtoDateCtrl = TextEditingController(),
      pgkillDateCtrl = TextEditingController();

  PlutoGridStateManager? dealViewGrid;

  PlutoGridStateManager? programViewGrid;
  PlutoGridStateManager? spotViewGrid;
  PlutoGridStateManager? spotVerifyGrid;
  PlutoGridStateManager? bookingSummaryGrid;

  RoBookingAgencyLeaveData? agencyLeaveData;
  RxnString currentTab = RxnString();
  RoBookingInitData? roBookingInitData;
  RoBookingBkgNOLeaveData? bookingNoLeaveData;
  RoBookingDealNoLeave? dealNoLeaveData;
  RoBookingDealDblClick? dealDblClickData;
  RoBookingTapeSearchData? bookingTapeSearchData;
  RoBookingTapeLeave? bookingTapeLeaveData;
  RoBookingBrandLeave? bookingBrandLeaveData;
  RoBookingAddSpotData? addSpotData;

  FocusNode bookingNoFocusNode = FocusNode(), locationFN = FocusNode();
  // var spotsNotVerifiedData = RxList();
  SpotsNotVerifiedClickData? spotsNotVerifiedClickData;
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
  DropDownValue? selectedBrand;
  DropDownValue? selectedBreak;
  DropDownValue? selectedSecEvent;
  DropDownValue? selectedTriggerAt;
  DropDownValue? selectedPdc;

  String? dealProgramCode;
  String? dealStartTime;
  String? dealTelecastDate;
  var bookingsummaryDefault = RxBool(false);

  RoBookingSaveCheckTapeId? savecheckData;
  bool showGstPopUp = true;
  int editMode = 0;

  int? bookingNoLeaveDealCurrentRow;
  String? bookingNoLeaveDealCurrentColumn;

  int? dealNoLeaveCurrentRow;
  String? dealNoLeaveDealCurrentColumn;

  DropDownValue? selectedGST;
  RxList<SpotsNotVerified> spotsNotVerified = RxList<SpotsNotVerified>([]);
  var channels = RxList<DropDownValue>();
  var clients = RxList<DropDownValue>();
  var agencies = RxList<DropDownValue>();
  RxList tapeIds = RxList([]);
  RxList makeGoodData = RxList([]);
  RxBool makeGoodSelectAll = RxBool(false);
  PlutoGridStateManager? makeGoodGrid;
  PlutoGridStateManager? spotNotVerifiedGrid;

  FocusNode bookingNoFocus = FocusNode(),
      dealNoFocus = FocusNode(),
      clientFocus = FocusNode(),
      agencyFocus = FocusNode(),
      brandFocus = FocusNode(),
      tapeIdFocus = FocusNode(),
      tapeIddropdownFocus = FocusNode(),
      refrenceFocus = FocusNode();

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
    clientFocus = FocusNode(
      onKeyEvent: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.tab) {
          if (selectedClient != null) {
            clientLeave(selectedClient?.key);
            return KeyEventResult.ignored;
          }
        }

        return KeyEventResult.ignored;
      },
    );
    agencyFocus = FocusNode(
      onKeyEvent: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.tab) {
          if (selectedAgnecy != null) {
            agencyLeave(selectedAgnecy?.key);
            return KeyEventResult.ignored;
          }
        }

        return KeyEventResult.ignored;
      },
    );
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.RO_BOOKING_INIT,
        fun: (data) {
          if (data is Map && data.containsKey("info_RoBookingLoad")) {
            roBookingInitData =
                RoBookingInitData.fromJson(data["info_RoBookingLoad"]);
            update(["init"]);
          }
        });
    bookingNoFocus.addListener(() {
      if (!bookingNoFocusNode.hasFocus && bookingNoCtrl.text.isNotEmpty) {
        onBookingNoLeave();
      }
    });
    refrenceFocus.addListener(() {
      if (!refrenceFocus.hasFocus && refNoCtrl.text.isEmpty) {
        LoadingDialog.callErrorMessage1(
            msg: "Reference No cannot be left blank.",
            barrierDismissible: false,
            callback: () {
              refrenceFocus.requestFocus();
            });
      }
    });
    tapeIdFocus.addListener(() async {
      if (!tapeIdFocus.hasFocus) {
        getTapeID(tapeIDCtrl.text);
      }
    });

    super.onInit();
  }

  getChannel(locId) {
    LoadingDialog.call();
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.RO_BOOKING_CHANNNEL(locId),
        fun: (data) {
          Get.back();
          if (data is Map &&
              data.containsKey("info_LeaveLocationChannelList") &&
              data["info_LeaveLocationChannelList"] is List) {
            List<DropDownValue> _channels = [];
            for (var e in data["info_LeaveLocationChannelList"]) {
              _channels.add(DropDownValue(
                  key: e["channelCode"], value: e["channelName"]));
            }
            channels.value = _channels;
          }
        });
  }

  effDtLeave() {
    if (selectedLocation != null && selectedChannel != null) {
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.RO_BOOKING_EFFDT_LEAVE(selectedLocation!.key!,
              selectedChannel!.key!, fpcEffectiveDateCtrl.text.fromdMyToyMd()),
          fun: (dataMap) {
            if (dataMap is Map &&
                dataMap.containsKey("info_GetEffectiveDateLeave")) {
              Map data = dataMap["info_GetEffectiveDateLeave"];
              if (data.containsKey("lstClientAgency") &&
                  data["lstClientAgency"] is List) {
                List<DropDownValue> _clients = [];
                for (var e in data["lstClientAgency"]) {
                  _clients.add(DropDownValue(
                      key: e["clientcode"], value: e["clientname"]));
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
        api: ApiFactory.RO_BOOKING_CLIENT_LEAVE(
            selectedLocation!.key!, selectedChannel!.key!, clientCode),
        fun: (data) {
          if (data is Map &&
              data.containsKey("info_ClientList") &&
              data["info_ClientList"] is List) {
            List<DropDownValue> _agencies = [];
            for (var e in data["info_ClientList"]) {
              _agencies.add(
                  DropDownValue(key: e["agencycode"], value: e["agencyname"]));
            }
            agencies.value = _agencies;
            selectedAgnecy = agencies.value.first;
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
        fun: (value) {
          if (value is Map && value.containsKey("info_GetBrand")) {
            bookingBrandLeaveData =
                RoBookingBrandLeave.fromJson(value["info_GetBrand"]);
          }
        });
  }

  addSpot() async {
    LoadingDialog.call();
    if (programViewGrid?.isEditing ?? false) {
      programViewGrid?.moveCurrentCell(PlutoMoveDirection.right, force: true);
      await Future.delayed(Duration(seconds: 2));
    }

    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.RO_BOOKING_AddSpot,
        fun: (value) {
          Get.back();
          if (value is Map && value.containsKey("info_OnAddSpots")) {
            addSpotData =
                RoBookingAddSpotData.fromJson(value["info_OnAddSpots"]);
            if (addSpotData?.message != null) {
              for (var msg in addSpotData?.message ?? []) {
                LoadingDialog.callErrorMessage1(msg: msg);
              }
            } else {
              totSpotCtrl.text = (addSpotData?.totalSpots ?? "").toString();
              totDurCtrl.text = (addSpotData?.totalDuration ?? "").toString();
              totAmtCtrl.text = (addSpotData?.totalAmount ?? "").toString();
              bookingNoLeaveData?.lstdgvDealDetails =
                  addSpotData?.lstdgvDealDetails;
              dealNoLeaveData?.lstdgvDealDetails =
                  addSpotData?.lstdgvDealDetails;
              pagecontroller.jumpToPage(0);
              currentTab.value = "Deal";
            }
            update(["init"]);
          }
        },
        json: {
          "cboTapeId_SelectedValue": selectedTapeID?.key,
          "cboSegNo_SelectedText": selectedSeg?.key,
          "txtDuration_SelectedText": bookingTapeLeaveData?.duration,
          "cboPreMid_SelectedValue": selectedPremid?.key,
          "cboPositionNo_SelectedValue": selectedPosition?.key,
          "strAccountCode": dealDblClickData?.strAccountCode,
          "lstdgvProgram": bookingTapeLeaveData?.lstdgvProgram
                  ?.map((e) => e.toJson())
                  .toList() ??
              [],
          "dealType": dealNoLeaveData?.dealType,
          "intSubRevenueTypeCode": dealDblClickData?.intSubRevenueTypeCode,
          "locationCode": selectedLocation?.key,
          "balanceSeconds": dealDblClickData?.balanceSeconds ?? 0,
          "channelCode": selectedChannel?.key,
          "intSeconds": dealDblClickData?.intSeconds ?? 0,
          "brandCode": selectedBrand?.key,
          "caption": bookingTapeLeaveData?.caption,
          "revenueType": bookingTapeLeaveData?.tapeRevenue,
          "lstdgvDealDetails": dealNoLeaveData?.lstdgvDealDetails
              ?.map((e) => e.toJson())
              .toList(),
          "intBookingCount": 0,
          "dblOldBookingAmount": bookingNoLeaveData?.dblOldBookingAmount ?? 0,
          "lstSpots":
              bookingNoLeaveData?.lstSpots?.map((e) => e.toJson()).toList() ??
                  [],
          "intEditMode": bookingNoLeaveData?.intEditMode ?? 0,
          "intDealRowNo": dealDblClickData?.intDealRowNo,
          "cboBreakNo_text": selectedBreak?.key,
          "txtTotal_text":
              dealDblClickData?.total ?? bookingTapeLeaveData?.total,
          "cboDealNo_selectedValue": selectedDeal?.key,
          "locationName": selectedLocation?.value,
          "channelName": selectedChannel?.value
        });
  }

  agencyLeave(agencyCode) {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.RO_BOOKING_OnAgencyLeave,
        json: {
          "Locationname": selectedLocation?.value,
          "locationCode": selectedLocation?.key,
          "ChannelCode": selectedChannel?.key,
          "ChannelName": selectedChannel?.value,
          "clientCode": selectedClient?.key,
          "agencyCode": agencyCode,
          "bookingMonth": bookingMonthCtrl.text,
          "bookingnumber": bookingNoCtrl.text,
          "payroutecode": "",
          "intEditMode": 0,
          "effectiveDate": fpcEffectiveDateCtrl.text.fromdMyToyMd(),
          "loginCode": Get.find<MainController>().user?.logincode,
          "GSTPlants": ""
        },
        fun: (data) {
          print("Working");
          if (data is Map<String, dynamic> &&
              data.containsKey("info_AgencyLeave")) {
            agencyLeaveData = RoBookingAgencyLeaveData.fromJson(
                data["info_AgencyLeave"] as Map<String, dynamic>);
            // selectedDeal = DropDownValue(
            //   key: agencyLeaveData?.lstDealNumber?.first.dealNumber ?? "",
            //   value: agencyLeaveData?.lstDealNumber?.first.dealNumber ?? "",
            // );

            zoneCtrl.text = agencyLeaveData?.zoneName ?? "";
            payrouteCtrl.text = agencyLeaveData?.payroute ?? "";
            bookingNoCtrl.text = agencyLeaveData?.bookingNumber ?? "";
            bookingNoTrailCtrl.text = agencyLeaveData?.zone ?? "";
            selectedGST = DropDownValue(
                key: (agencyLeaveData?.lstGstPlants?.first.plantid ?? "")
                    .toString(),
                value: agencyLeaveData?.lstGstPlants?.first.column1 ?? "");

            selectedExecutive = DropDownValue(
                key:
                    agencyLeaveData?.excutiveDetails?.first.personnelCode ?? "",
                value: agencyLeaveData?.excutiveDetails?.first.personnelname);
            update(["init"]);
            gstNoCtrl.text = agencyLeaveData?.gstRegNo ?? "";
            // Get.defaultDialog(
            //     radius: 05,
            //     title: "GST Plant",
            //     confirm: FormButtonWrapper(
            //       btnText: "Done",
            //       callback: () {
            //         Get.back();
            //       },
            //     ),
            //     content: SizedBox(
            //       height: Get.height / 4,
            //       width: Get.width / 4,
            //       child: Column(
            //         children: [
            //           DropDownField.formDropDown1WidthMap(
            //             agencyLeaveData?.lstGstPlants
            //                     ?.map((e) => DropDownValue(
            //                         key: e.plantid?.toString(),
            //                         value: e.column1))
            //                     .toList() ??
            //                 [],
            //             (value) => {selectedGST = value},
            //             "GST Plant",
            //             0.20,
            //             selected: selectedGST,
            //           ),
            //           InputFields.formField1(
            //             hintTxt: "GST Reg#",
            //             controller: gstNoCtrl,
            //             width: 0.20,
            //           )
            //         ],
            //       ),
            //     ));
            // agencyFocus.requestFocus();
            if (showGstPopUp) {
              showGstPopUp = false;
              Get.defaultDialog(
                  radius: 05,
                  title: "GST Plant",
                  confirm: FormButtonWrapper(
                    btnText: "Done",
                    callback: () {
                      Get.back();
                    },
                  ),
                  content: SizedBox(
                    height: Get.height / 4,
                    width: Get.width / 4,
                    child: Column(
                      children: [
                        DropDownField.formDropDown1WidthMap(
                          agencyLeaveData?.lstGstPlants
                                  ?.map((e) => DropDownValue(
                                      key: e.plantid?.toString(),
                                      value: e.column1))
                                  .toList() ??
                              [],
                          (value) => {selectedGST = value},
                          "GST Plant",
                          0.20,
                          selected: selectedGST,
                          autoFocus: true,
                        ),
                        InputFields.formField1(
                          hintTxt: "GST Reg#",
                          controller: gstNoCtrl,
                          width: 0.20,
                        )
                      ],
                    ),
                  ));
            }
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

  refreshPDC() {
    Get.find<ConnectorControl>().POSTMETHOD(
      api: ApiFactory.RO_BOOKING_RefreshPDC,
      json: {
        "clientCode": selectedClient?.key,
        "agencyCode": selectedAgnecy?.key,
        "editMode": 0,
        "locationCode": selectedLocation?.key,
        "channelCode": selectedChannel?.key
      },
      fun: (json) {
        if (json is Map && json.containsKey("info_RefreshPDC")) {
          if (json["info_RefreshPDC"]['lstPDCModel'] != null) {
            agencyLeaveData?.lstPdcList = <LstPdcList>[];
            json["info_RefreshPDC"]['lstPDCModel'].forEach((v) {
              agencyLeaveData?.lstPdcList!.add(LstPdcList.fromJson(v));
            });
          }
        }
      },
    );
  }

  getSegment(index) {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.RO_BOOKING_GetSegment,
        json: {
          "locationCode": selectedLocation!.key,
          "channelCode": selectedClient!.key,
          "telecastDate": dealDblClickData?.lstProgram?[index].telecastdate,
          "telecastTime": dealDblClickData?.lstProgram?[index].startTime,
          "programCode": dealDblClickData?.lstProgram?[index].programcode,
        },
        fun: (data) {
          // if (data is Map && data.containsKey("info_AgencyLeave")) {
          //   agencyLeaveData = RoBookingAgencyLeaveData.fromJson(data["info_AgencyLeave"]);
          //   selectedDeal = DropDownValue(
          //     key: agencyLeaveData?.lstDealNumber?.first.dealNumber ?? "",
          //     value: agencyLeaveData?.lstDealNumber?.first.dealNumber ?? "",
          //   );
          //   update(["init"]);
          // }
          // if (data is Map && data.containsKey("info_ClientList") && data["info_ClientList"] is List) {
          //   List<DropDownValue> _agencies = [];
          //   for (var e in data["info_ClientList"]) {
          //     _agencies.add(DropDownValue(key: e["agencycode"], value: e["agencyname"]));
          //   }
          //   agencies.value = _agencies;
          // }
        });
  }

  getClient() {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.RO_BOOKING_GetSegment,
        json: {
          "locationCode": selectedLocation!.key,
          "channelCode": selectedClient!.key,
          "telecastDate": dealTelecastDate,
          "telecastTime": dealStartTime,
          "programCode": dealProgramCode
        },
        fun: (data) {});
  }

  setVerify() {
    if ((spotsNotVerifiedClickData?.lstdgvVerifySpot ?? []).isNotEmpty) {
      Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.RO_BOOKING_GetSetVerify,
          json: {
            "locationName": selectedLocation!.value,
            "channelName": selectedChannel!.value,
            "bookingMonth": bookingMonthCtrl.text,
            "bookingNumber": bookingNoCtrl.text,
            "loginName": Get.find<MainController>().user?.logincode,
            "locationCode": selectedLocation!.key,
            "channelCode": selectedChannel!.key,
            "loggedUser": Get.find<MainController>().user?.logincode,
            "lstdgvVerifySpot": spotsNotVerifiedClickData?.lstdgvVerifySpot,
          },
          fun: (response) {
            if (response is Map && response.containsKey("info_SetVerify")) {
              spotsNotVerifiedClickData = null;
              if (response["info_SetVerify"]["message"] != null) {
                if (response["info_SetVerify"]["message"]
                    .toString()
                    .toLowerCase()
                    .contains("verification status updated")) {
                  LoadingDialog.callDataSaved(
                      msg: response["info_SetVerify"]["message"]);
                } else {
                  LoadingDialog.callErrorMessage1(
                      msg: response["info_SetVerify"]["message"]);
                }
              }

              if (response["info_SetVerify"]['lstSpotsNotVerified'] != null) {
                spotsNotVerified.value = <SpotsNotVerified>[];
                response["info_SetVerify"]['lstSpotsNotVerified'].forEach((v) {
                  spotsNotVerified.add(SpotsNotVerified.fromJson(v));
                });
              }
              pagecontroller.jumpToPage(5);
              currentTab.value = "Spots Not Verified";
            }
          });
    } else {
      LoadingDialog.callInfoMessage("No Spot To Verify");
    }
  }

  tapIdLeave(selectedvalue) {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.RO_BOOKING_cboTapeIdLeave,
        json: {
          "cboTapeIdSelectedValue": selectedvalue,
          "lstTapeDetails": dealDblClickData?.brandResponse?.lstTapeDetails
                  ?.map((e) => e.toJson())
                  .toList() ??
              [],
          "lstdgvProgram":
              dealDblClickData?.lstProgram?.map((e) => e.toJson()).toList() ??
                  [],
          "lstTapeCampaign": dealDblClickData?.brandResponse?.lstTapeCampaign
                  ?.map((e) => e.toJson())
                  .toList() ??
              [],
          "intCountBased": dealDblClickData?.intCountBased,
          "intBaseDuration": dealDblClickData?.intBaseDuration,
          "rate": dealDblClickData?.rate
        },
        fun: (response) {
          if (response is Map && response.containsKey("info_LeaveTapedId")) {
            bookingTapeLeaveData =
                RoBookingTapeLeave.fromJson(response["info_LeaveTapedId"]);
            selectedSeg = DropDownValue(
                key: bookingTapeLeaveData?.cboSegNo,
                value: bookingTapeLeaveData?.cboSegNo);
            pgkillDateCtrl.text = DateFormat("dd-MM-yyyy").format(
                DateFormat("MM/dd/yyyy")
                    .parse(bookingTapeLeaveData!.dtpKillDate!.split(" ")[0]));
            update(["init"]);
            update(["programView"]);
            tapeIddropdownFocus.requestFocus();
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
        fun: (response) async {
          if (response is Map && response.containsKey("info_LeaveDealNumber")) {
            dealNoLeaveData =
                RoBookingDealNoLeave.fromJson(response["info_LeaveDealNumber"]);
            payModeCtrl.text = dealNoLeaveData?.payMode ?? "";
            dealTypeCtrl.text = dealNoLeaveData?.dealType ?? "";
            maxspendCtrl.text = dealNoLeaveData?.maxSpend ?? 0.toString();
            selectedBrand = DropDownValue(
                key: dealNoLeaveData?.lstBrand?.first.brandcode ?? "",
                value: dealNoLeaveData?.lstBrand?.first.brandname ?? "");
            dealToCtrl.text = DateFormat("dd-MM-yyyy").format(
                DateFormat("MM/dd/yyyy")
                    .parse(dealNoLeaveData?.dealtoDate?.split(" ")[0] ?? ""));
            dealFromCtrl.text = DateFormat("dd-MM-yyyy").format(
                DateFormat("MM/dd/yyyy")
                    .parse(dealNoLeaveData?.dealFromDate?.split(" ")[0] ?? ""));
            update(["init", "dealGrid"]);
            for (var element in (dealNoLeaveData?.message ?? <String>[])) {
              await Get.defaultDialog(
                title: "",
                barrierDismissible: true,
                titleStyle: TextStyle(fontSize: 1),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      CupertinoIcons.info,
                      color: Colors.black,
                      size: 55,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      element,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeDefine.popupTxtSize),
                    )
                  ],
                ),
                radius: 10,
                confirm: DailogCloseButton(
                  autoFocus: true,
                  callback: () {
                    Get.back();
                  },
                  btnText: "OK",
                ),
                contentPadding: EdgeInsets.only(
                    left: SizeDefine.popupMarginHorizontal,
                    right: SizeDefine.popupMarginHorizontal,
                    bottom: 16),
              );
            }
          }
        });
  }

  save() {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.RO_BOOKING_OnSaveData,
        json: {
          "chkGSTValidate": true,
          "lstdgvSpots": addSpotData?.lstSpots
                  ?.map((e) => e.toJson())
                  .toList() ??
              bookingNoLeaveData?.lstSpots?.map((e) => e.toJson()).toList() ??
              [],
          "lstDealDetails": dealNoLeaveData?.lstdgvDealDetails
                  ?.map((e) => e.toJson())
                  .toList() ??
              bookingNoLeaveData?.lstdgvDealDetails
                  ?.map((e) => e.toJson())
                  .toList() ??
              [],
          "lstdgvMakeGood": makeGoodData.value,
          "locationCode": selectedLocation?.key,
          "channelCode": selectedChannel?.key,
          "bookingMonth": bookingMonthCtrl.text,
          "bookingNumber": bookingNoCtrl.text,
          "bookingDate": bookDateCtrl.text.fromdMyToyMd(),
          "effectiveDate": fpcEffectiveDateCtrl.text.fromdMyToyMd(),
          "referenceNumber": refNoCtrl.text,
          "clientCode": selectedClient?.key,
          "agencyCode": selectedAgnecy?.key,
          "brandCode": selectedBrand?.key,
          "payroute":
              agencyLeaveData?.payroute ?? bookingNoLeaveData?.payrouteName,
          "totalDuration": (bookingNoLeaveData?.totalDuration ??
                  addSpotData?.totalDuration ??
                  0)
              .toString(),
          "totalAmount":
              (bookingNoLeaveData?.totalAmount ?? addSpotData?.totalAmount ?? 0)
                  .toString(),
          "executive": selectedExecutive?.value,
          "zoneCode": agencyLeaveData?.zoneCode ?? bookingNoLeaveData?.zonecode,
          "dealNo": selectedDeal?.key,
          "pdcNumber": selectedPdc?.key ?? "",
          "loggedUser": Get.find<MainController>().user?.logincode,
          "intEditMode": bookingNoLeaveData?.intEditMode ?? editMode,
          "gstPlants": agencyLeaveData?.gstPlants ??
              bookingNoLeaveData?.gstPlants ??
              selectedGST?.key,
          "gstRegN": agencyLeaveData?.gstRegNo ??
              bookingNoLeaveData?.gstRegNo ??
              gstNoCtrl.text,
          "secondaryEvents":
              selectedSecEvent?.key ?? bookingNoLeaveData?.secondaryEventId,
          "triggerAt": selectedTriggerAt?.key ?? bookingNoLeaveData?.triggerId,
          "previousBookedAmount": num.tryParse(
                  dealNoLeaveData?.previousBookedAmount ??
                      bookingNoLeaveData?.previousBookedAmount ??
                      "") ??
              0,
          "previousValAmount": num.tryParse(
                  dealNoLeaveData?.previousValAmount ??
                      bookingNoLeaveData?.previousValAmount ??
                      "") ??
              0,
          "dblOldBookingAmount": addSpotData?.dblOldBookingAmount ??
              bookingNoLeaveData?.dblOldBookingAmount,
          "revenueType": dealNoLeaveData?.strRevenueTypeCode ??
              bookingNoLeaveData?.revenueType,
          "maxSpend": dealNoLeaveData?.maxSpend ?? bookingNoLeaveData?.maxSpend,
          "intPDCReqd": selectedPdc == null ? 1 : 0,
          "pdc": selectedPdc?.key,
          "strAccountCode": dealDblClickData?.strAccountCode
        },
        fun: (response) async {
          if (response is Map && response.containsKey("info_OnSave")) {
            editMode = 1;
            for (var element in response["info_OnSave"]["message"]) {
              await Get.defaultDialog(
                title: "",
                barrierDismissible: true,
                titleStyle: TextStyle(fontSize: 1),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      CupertinoIcons.info,
                      color: Colors.black,
                      size: 55,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      element.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeDefine.popupTxtSize),
                    )
                  ],
                ),
                radius: 10,
                confirm: DailogCloseButton(
                  autoFocus: true,
                  callback: () {
                    Get.back();
                    if (response["info_OnSave"]["bookingNumber"] != null) {
                      onBookingNoLeave(
                          bookingNumber: response["info_OnSave"]
                              ["bookingNumber"]);
                    }
                  },
                  btnText: "OK",
                ),
                contentPadding: EdgeInsets.only(
                    left: SizeDefine.popupMarginHorizontal,
                    right: SizeDefine.popupMarginHorizontal,
                    bottom: 16),
              );
            }
            // for (var msg in response["info_OnSave"]["message"]) {
            //   LoadingDialog.callDataSavedMessage(msg, barrierDismissible: false,
            //       callback: () {
            //     onBookingNoLeave(
            //         bookingNumber: response["info_OnSave"]["bookingNumber"]);
            //   });
            // }
          } else if (response is String) {
            LoadingDialog.callErrorMessage1(msg: response);
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
  spotnotverifiedclick(index) {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.RO_BOOKING_SPOT_DBL_CLICK,
        json: {
          "locationCode": selectedLocation?.key,
          "locationName": selectedLocation?.value,
          "channelCode": selectedChannel?.key,
          "channelName": selectedChannel?.value,
          "loggedUser": Get.find<MainController>().user?.logincode,
          "rowIndex": index,
          "lstdgvSpotsNotVerified":
              spotsNotVerified.value.map((e) => e.toJson()).toList()
        },
        fun: (response) {
          if (response is Map &&
              response.containsKey("info_SpotsNotVerified_CellDoubleClick")) {
            // spotsNotVerifiedData.value = response["info_SpotsNotVerified"];

            spotsNotVerifiedClickData = SpotsNotVerifiedClickData.fromJson(
                response["info_SpotsNotVerified_CellDoubleClick"]);

            bookingNoLeaveData = spotsNotVerifiedClickData?.lstDisplayResponse;

            selectedClient = DropDownValue(
                key: bookingNoLeaveData!.lstClientAgency!.first.clientcode,
                value: bookingNoLeaveData!.lstClientAgency!.first.clientname);
            selectedAgnecy = DropDownValue(
                key: bookingNoLeaveData!.lstAgency!.first.agencycode,
                value: bookingNoLeaveData!.lstAgency!.first.agencyname);
            selectedDeal = DropDownValue(
                key: bookingNoLeaveData!.lstDealNumber!.first.dealNumber,
                value: bookingNoLeaveData!.lstDealNumber!.first.dealNumber);
            bookingMonthCtrl.text =
                (spotsNotVerifiedClickData?.bookingMonth ?? "").toString();
            bookingNoCtrl.text =
                (spotsNotVerifiedClickData?.bookingNumber ?? "").toString();

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
            update(["dealGrid", "init"]);
            pagecontroller.jumpToPage(6);
            currentTab.value = "Verify Spots";
          }
        });
  }

  // getSpotsNotVerified(location, channel, month) {
  //   Get.find<ConnectorControl>().POSTMETHOD(
  //       api: ApiFactory.RO_BOOKING_GET_SpotsNotVerified,
  //       json: {
  //         "locationCode": location,
  //         "channelCode": channel,
  //         "bookingMonth": month,
  //         "loggedUser": Get.find<MainController>().user?.logincode,
  //       },
  //       fun: (response) {
  //         if (response is Map &&
  //             response.containsKey("info_SpotsNotVerified")) {
  //           // spotsNotVerifiedData.value = response["info_SpotsNotVerified"];
  //         }
  //       });
  // }

  getDisplay() {
    if (selectedLocation == null && selectedChannel == null) {
      LoadingDialog.callErrorMessage1(
          msg: "Location and channel is must to select.", callback: () {});
    } else {
      Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.RO_BOOKING_GET_DISPLAY,
          json: {
            "locationName": selectedLocation?.value,
            "channelName": selectedChannel?.value,
            "clientName": selectedClient?.value ??
                bookingNoLeaveData!.lstClientAgency!.first.clientname,
            "agencyName": selectedAgnecy?.value ??
                bookingNoLeaveData!.lstAgency!.first.agencyname,
            "brandName": selectedBrand?.value ??
                bookingNoLeaveData!.lstBrand!.first.brandname,
            "fromDate": mgfromDateCtrl.text.fromdMyToyMd(),
            "toDate": mgtoDateCtrl.text.fromdMyToyMd(),
            "eBookingMonth": bookingMonthCtrl.text,
            "eBookingNumber": bookingNoCtrl.text,
          },
          fun: (response) {
            if (response is Map && response.containsKey("info_GetDisplay")) {
              makeGoodData.value = response["info_GetDisplay"]["lstMakeGood"];
            }
          });
    }
  }

  importMark(PlatformFile fileData) {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.RO_BOOKING_ImportAndMark,
        json: {
          "file": base64.encode(fileData.bytes as List<int>),
          "lstdgvMakeGood": makeGoodData.value
        },
        fun: (response) {
          if (response is Map && response.containsKey("info_GetDisplay")) {
            makeGoodData.value = response["info_GetDisplay"]["lstMakeGood"];
          }
        });
  }

  pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowedExtensions: ["xlsx", "xlsm", "xls", "xlsb", "xltx"],
        type: FileType.custom);

    if (result != null && result.files.single != null) {
      importMark(result.files.first);
    } else {
      // User canceled the pic5ker
    }
  }

  onBookingNoLeave({String? bookingNumber}) {
    if (bookingMonthCtrl.text.isEmpty) {
      return;
    }
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.RO_BOOKING_BOOKING_NO_LEAVE,
        json: {
          "locationcode": selectedLocation!.key,
          "channelcode": selectedChannel!.key,
          "bookingMonth": bookingMonthCtrl.text,
          "bookingnumber": bookingNumber ?? bookingNoCtrl.text,
          "formname": "frmROBooking"
        },
        fun: (value) {
          if (value is Map && value.containsKey("info_LeaveBookingNumber")) {
            bookingNoLeaveDealCurrentColumn = "";
            bookingNoLeaveDealCurrentRow = null;
            bookingNoLeaveData = RoBookingBkgNOLeaveData.fromJson(
                value["info_LeaveBookingNumber"]);
            selectedClient = DropDownValue(
                key: bookingNoLeaveData!.lstClientAgency!.first.clientcode,
                value: bookingNoLeaveData!.lstClientAgency!.first.clientname);
            selectedAgnecy = DropDownValue(
                key: bookingNoLeaveData!.lstAgency!.first.agencycode,
                value: bookingNoLeaveData!.lstAgency!.first.agencyname);
            selectedBrand = DropDownValue(
                key: bookingNoLeaveData!.lstBrand!.first.brandcode,
                value: bookingNoLeaveData!.lstBrand!.first.brandname);
            selectedDeal = DropDownValue(
                key: bookingNoLeaveData!.lstDealNumber!.first.dealNumber,
                value: bookingNoLeaveData!.lstDealNumber!.first.dealNumber);
            selectedExecutive = DropDownValue(
                key: bookingNoLeaveData!.executiveCode,
                value: roBookingInitData?.lstExecutives
                        ?.firstWhereOrNull((element) =>
                            element.personnelCode ==
                            bookingNoLeaveData!.executiveCode)
                        ?.personnelName ??
                    "");
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
            dealToCtrl.text = DateFormat("dd-MM-yyyy").format(
                DateFormat("MM/dd/yyyy").parse(
                    bookingNoLeaveData?.dealtoDate?.split(" ")[0] ?? ""));
            dealFromCtrl.text = DateFormat("dd-MM-yyyy").format(
                DateFormat("MM/dd/yyyy").parse(
                    bookingNoLeaveData?.dealFromDate?.split(" ")[0] ?? ""));

            update(["dealGrid"]);
            for (var element in (bookingNoLeaveData?.message ?? <String>[])) {
              Get.defaultDialog(
                title: "",
                barrierDismissible: true,
                titleStyle: TextStyle(fontSize: 1),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      CupertinoIcons.info,
                      color: Colors.black,
                      size: 55,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      element.toString(),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: SizeDefine.popupTxtSize),
                    )
                  ],
                ),
                radius: 10,
                confirm: DailogCloseButton(
                  autoFocus: true,
                  callback: () {
                    Get.back();
                  },
                  btnText: "OK",
                ),
                contentPadding: EdgeInsets.only(
                    left: SizeDefine.popupMarginHorizontal,
                    right: SizeDefine.popupMarginHorizontal,
                    bottom: 16),
              );
            }
          }
        });
  }

  dealdoubleclick(colId, rowId) {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.RO_BOOKING_DEAL_DOUBLE_CLICK,
        json: {
          "dgvDealDetail_RowIndex": rowId,
          "dgvDealDetail_ColumnIndex": colId,
          "previousBookedAmount": bookingNoLeaveData?.previousBookedAmount ??
              dealNoLeaveData?.previousBookedAmount ??
              "",
          "previousValAmount": bookingNoLeaveData?.previousValAmount ??
              dealNoLeaveData?.previousValAmount ??
              "",
          "channelCode":
              bookingNoLeaveData?.channelcode ?? selectedChannel!.key ?? "",
          "lstdgvDealDetails": (bookingNoLeaveData?.lstdgvDealDetails ??
                      dealNoLeaveData?.lstdgvDealDetails)
                  ?.map((e) => e.toJson())
                  .toList() ??
              [],
          "lstSpots":
              bookingNoLeaveData?.lstSpots?.map((e) => e.toJson()).toList() ??
                  [],
          "brandCode": bookingNoLeaveData?.brandcode ?? selectedBrand?.key,
          "zone": bookingNoLeaveData?.zone ?? agencyLeaveData?.zone ?? "",
          "executiveCode": bookingNoLeaveData?.executiveCode ??
              agencyLeaveData?.selectedExcutiveCode,
          "payroute":
              bookingNoLeaveData?.payrouteName ?? agencyLeaveData?.payroute,
          "dealNo": bookingNoLeaveData?.dealno ?? selectedDeal?.key,
          "locationCode":
              bookingNoLeaveData?.locationCode ?? selectedLocation!.key,
          "revenueType": bookingNoLeaveData?.revenueType,
          "effectiveDate": DateFormat("yyyy-MM-dd").format(DateFormat(
                  bookingNoLeaveData?.bookingEffectiveDate == null
                      ? "dd-MM-yyyy"
                      : "dd/MM/yyyy")
              .parse(bookingNoLeaveData?.bookingEffectiveDate ??
                  fpcEffectiveDateCtrl.text)),
          "zoneCode": bookingNoLeaveData?.zonecode ?? agencyLeaveData?.zoneCode,
          "tapeId": "",
          "duration": bookingNoLeaveData?.totalDuration,
          "intEditMode": bookingNoLeaveData?.intEditMode ?? 0,
          "clientCode": selectedClient?.key,
          "agencyCode": selectedAgnecy?.key,
          "activityMonth": bookingMonthCtrl.text
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
          if (value is Map &&
              value.containsKey("info_dgvDealDetailCellDouble") &&
              value["info_dgvDealDetailCellDouble"]["message"] == null) {
            dealDblClickData = RoBookingDealDblClick.fromJson(
                value["info_dgvDealDetailCellDouble"]);
            if (dealDblClickData?.positionNo != null) {
              var _selectedPostion = roBookingInitData?.lstPosition?.firstWhere(
                  (element) =>
                      element.column1?.toLowerCase() ==
                      dealDblClickData?.positionNo!.toLowerCase());
              selectedPosition = DropDownValue(
                  key: _selectedPostion?.positioncode ?? "",
                  value: _selectedPostion?.column1 ?? "");
            }
            if (dealDblClickData?.preMid != null) {
              var _selectedPredMid = roBookingInitData?.lstspotpositiontype
                  ?.firstWhere((element) =>
                      element.spotPositionTypeName?.toLowerCase() ==
                      dealDblClickData?.preMid!.toLowerCase());
              selectedPremid = DropDownValue(
                  key: _selectedPredMid?.spotPositionTypeCode ?? "",
                  value: _selectedPredMid?.spotPositionTypeName ?? "");
            }
            selectedBreak = DropDownValue(
                key: dealDblClickData?.breakNo.toString() ?? "",
                value: dealDblClickData?.breakNo.toString() ?? "");

            pagecontroller.jumpToPage(1);
            currentTab.value = "Programs";
          }
          if (value is Map &&
              value.containsKey("info_dgvDealDetailCellDouble") &&
              value["info_dgvDealDetailCellDouble"]["message"] != null) {
            LoadingDialog.callErrorMessage1(
                msg: value["info_dgvDealDetailCellDouble"]["message"]);
          }
          if (value is String) {
            LoadingDialog.callErrorMessage1(msg: value);
          }
        });
  }

  getTapeID(searchContain) async {
    await Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.RO_BOOKING_cboTapeIdFocusLost,
        json: {
          "brandCode": bookingNoLeaveData?.brandcode ?? selectedBrand?.key,
          "strAccountCode": bookingNoLeaveData?.accountCode ??
              dealDblClickData?.strAccountCode,
          "locationCode": selectedLocation?.key ?? "",
          "channelCode": selectedChannel?.key,
          "intSubRevenueTypeCode": "0",
          "searchContain": searchContain
        },
        fun: (value) {
          if (value is Map &&
              value.containsKey("info_GetTapeLost") &&
              value["info_GetTapeLost"].containsKey("lstTape") &&
              value["info_GetTapeLost"]["lstTape"] is List) {
            tapeIds.value = value["info_GetTapeLost"]["lstTape"];
          }
        });
  }

  getSpotNotVerified(String locationCode, String channelCode,
      String bookingMonth, String loggedUser) {
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.RO_BOOKING_GetSpotNotVerified(
            locationCode, channelCode, bookingMonth, loggedUser),
        fun: (json) {
          if (json is Map && json.containsKey("info_SpotsNotVerified")) {
            if (json['info_SpotsNotVerified'] != null) {
              spotsNotVerified.value = <SpotsNotVerified>[];
              json['info_SpotsNotVerified'].forEach((v) {
                spotsNotVerified.add(SpotsNotVerified.fromJson(v));
              });
            }
          }
        });
  }

  savePDC(list) async {
    await Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.RO_BOOKING_SaveClientPdc,
        json: {
          "clientCode": selectedClient?.key ?? "",
          "activityPeriod": bookingMonthCtrl.text,
          "modifiedBy": Get.find<MainController>().user?.logincode,
          "agencyCode": selectedAgnecy?.key ?? "",
          "lstClientPDC": list
        },
        fun: (value) {
          if (value is Map && value.containsKey("info_SaveClientPDCForm")) {
            LoadingDialog.callDataSaved(
                msg: value["info_SaveClientPDCForm"]["message"]);
          } else {
            LoadingDialog.callErrorMessage1(msg: value);
          }
        });
  }

  saveCheck() {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.RO_BOOKING_OnSave_Check,
        json: {
          "chkSummaryType": addSpotData?.lstSpots?.isNotEmpty,
          "lstdgvSpots": addSpotData?.lstSpots
                  ?.map((e) => e.toJson())
                  .toList() ??
              bookingNoLeaveData?.lstSpots?.map((e) => e.toJson()).toList() ??
              [],
          "brandName": selectedBrand?.key
        },
        fun: (response) {
          if (response is Map &&
              response.containsKey("info_OnSaveCheckTapeId")) {
            savecheckData = RoBookingSaveCheckTapeId.fromJson(
                response["info_OnSaveCheckTapeId"]);
            pagecontroller.jumpToPage(4);
            currentTab.value = "Booking Summary";

            LoadingDialog.modify(savecheckData?.message ?? "", () {
              save();
            }, () {
              Get.back();
            }, deleteTitle: "Yes", cancelTitle: "No");
          } else if (response is String) {
            LoadingDialog.callErrorMessage1(msg: response);
          }
        });
  }

  @override
  void onReady() {
    currentTab.value = "Deal";
    update(["pageView"]);
    super.onReady();
    fetchUserSetting1();
  }

  fetchUserSetting1() async {
    userDataSettings = await Get.find<HomeController>().fetchUserSetting2();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/dummydata.dart';
import 'package:bms_scheduling/app/modules/RoReschedule/bindings/ro_booking_leave_data.dart';
import 'package:bms_scheduling/app/modules/RoReschedule/bindings/ro_init_data.dart';
import 'package:bms_scheduling/app/modules/RoReschedule/bindings/ro_re_dgview_double_click.dart';
import 'package:bms_scheduling/app/modules/RoReschedule/bindings/ro_re_schedule_leave_dart.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

import '../../../data/DropDownValue.dart';

class RoRescheduleController extends GetxController {
  RxList<DropDownValue> locations = <DropDownValue>[].obs;
  RxList<DropDownValue> channels = <DropDownValue>[].obs;
  TextEditingController cancelDatectrl = TextEditingController();
  DropDownValue? selectedLocation;
  DropDownValue? selectedChannel;
  var enableFields = RxBool(true);
  TextEditingController tonumberCtrl = TextEditingController(),
      agencyCtrl = TextEditingController(),
      clientCtrl = TextEditingController(),
      referenceCtrl = TextEditingController(),
      refDateCtrl = TextEditingController(),
      effDateCtrl = TextEditingController(),
      tapeIdCheckCaption = TextEditingController(),
      tapeIdCheckSegNo = TextEditingController(),
      tapeIdCheckDuaration = TextEditingController(),
      bkDateCtrl = TextEditingController(),
      branCtrl = TextEditingController(),
      delnoCtrl = TextEditingController(),
      bookingMonthCtrl = TextEditingController(),
      reSchedNoCtrl = TextEditingController(),
      payrouteCtrl = TextEditingController(),
      zoneCtrl = TextEditingController();
  ReschedulngInitData? reschedulngInitData;
  var changeTapeId = RxBool(false);
  RoRescheduleBookingNumberLeaveData? rescheduleBookingNumberLeaveData;
  RORescheduleOnLeaveSchedulingNoData? roRescheduleOnLeaveSchedulingNoData;
  FocusNode toNumberFocus = FocusNode();
  FocusNode reScheduleFocus = FocusNode();
  DropDownValue? modifySelectedTapeCode;
  TextEditingController changeTapeIdSeg = TextEditingController(),
      changeTapeIdDur = TextEditingController(),
      chnageTapeIdCap = TextEditingController();
  PlutoGridStateManager? plutoGridStateManager;
  @override
  void onInit() {
    loadinitData().then((value) {
      print("init done");
      print(value);
      toNumberFocus.addListener(() {
        if (!toNumberFocus.hasFocus && tonumberCtrl.text.isNotEmpty) {
          fetchToData();
        }
      });
      reScheduleFocus.addListener(() {
        if (!reScheduleFocus.hasFocus && reSchedNoCtrl.text.isNotEmpty) {
          onScheduleLeaveData();
        }
      });
    });

    super.onInit();
  }

  loadinitData() async {
    locations.value = [];
    try {
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.RO_RESCHEDULE_INIT,
          fun: (data) {
            if ((data as Map).containsKey("onLoad_Reschedulng") && data["onLoad_Reschedulng"]["lstlocationMaters"] is List) {
              reschedulngInitData = ReschedulngInitData.fromJson(data["onLoad_Reschedulng"]);
              update(["initData"]);
              // for (var e in data["onLoad_Reschedulng"]["lstlocationMaters"]) {
              //   locations.add(DropDownValue(key: e["locationCod   e"], value: e["locationName"]));
              // }
              // locations.refresh();
            } else {
              LoadingDialog.callErrorMessage1(msg: "Failed To Load Initial Data");
            }
          });
    } catch (e) {
      LoadingDialog.callErrorMessage1(msg: "Failed To Load Initial Data");
    }
    return "Done";
  }

  getChannel(locationCode) {
    channels.value = [];
    try {
      Get.find<ConnectorControl>().GETMETHODCALL(
          api: ApiFactory.RO_RESCHEDULE_CHANNNEL(locationCode),
          fun: (data) {
            if ((data as Map).containsKey("info_LeaveLocation") && data["info_LeaveLocation"] is List) {
              for (var e in data["info_LeaveLocation"]) {
                channels.add(DropDownValue(key: e["channelcode"], value: e["channelName"]));
              }
              channels.refresh();
              // channels.value = data["lstChannel"]
              //     .map((e) => DropDownValue(
              //         key: e["channelcode"], value: e["channelName"]))
              //     .toList();
            } else {
              LoadingDialog.callErrorMessage1(msg: "Failed To Load Initial Data");
            }
          });
    } catch (e) {
      LoadingDialog.callErrorMessage1(msg: "Failed To Load Initial Data");
    }
  }

  fetchToData() {
    print("ON BOOKING NUMBER LEAVE CALLED>>>");
    try {
      Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.RO_RESCHEDULE_BOOKINGNO_LEAVE,
          json: {"locationCode": selectedLocation!.key, "channelCode": selectedChannel!.key, "bookingNumber": tonumberCtrl.text, "backDated": 1},
          fun: (data) {
            if (data is Map<String, dynamic> && data.containsKey("info_LeaveBookingNumber")) {
              rescheduleBookingNumberLeaveData = RoRescheduleBookingNumberLeaveData.fromJson(data);
              agencyCtrl.text = rescheduleBookingNumberLeaveData!.infoLeaveBookingNumber!.agencyname!;
              clientCtrl.text = rescheduleBookingNumberLeaveData!.infoLeaveBookingNumber!.clientname!;
              delnoCtrl.text = rescheduleBookingNumberLeaveData!.infoLeaveBookingNumber!.dealno!;
              branCtrl.text = rescheduleBookingNumberLeaveData!.infoLeaveBookingNumber!.brandname!;
              payrouteCtrl.text = rescheduleBookingNumberLeaveData!.infoLeaveBookingNumber!.payRouteName!;
              zoneCtrl.text = rescheduleBookingNumberLeaveData!.infoLeaveBookingNumber!.zoneName!;
              bookingMonthCtrl.text = rescheduleBookingNumberLeaveData!.infoLeaveBookingNumber!.bookingMonth!;
              effDateCtrl.text =
                  DateFormat("dd-MM-yyyy").format(DateTime.parse(rescheduleBookingNumberLeaveData!.infoLeaveBookingNumber!.bookingEffectiveDate!));
              // enableFields.value = false;
              update(["dgvGrid"]);
              // branCtrl.text = rescheduleBookingNumberLeaveData!.infoLeaveBookingNumber!.brandname!;
              // branCtrl.text = rescheduleBookingNumberLeaveData!.infoLeaveBookingNumber!.brandname!;
            }
          });
    } catch (e) {
      LoadingDialog.callErrorMessage1(msg: "Failed To Load  Data");
    }

    print("ON BOOKING NUMBER LEAVE END>>>");
  }

  onScheduleLeaveData() {
    print("ON BOOKING NUMBER LEAVE CALLED>>>");
    try {
      Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.RO_RESCHEDULE_SCHEDULENO_LEAVE,
          json: {
            "locationCode": selectedLocation!.key,
            "channelCode": selectedChannel!.key,
            "rescheduleMonth": bookingMonthCtrl.text,
            "rescheduleNumber": reSchedNoCtrl.text
          },
          fun: (data) {
            try {
              if (data is Map<String, dynamic> && data.containsKey("info_OnLeaveSchedulingNo")) {
                roRescheduleOnLeaveSchedulingNoData = RORescheduleOnLeaveSchedulingNoData.fromJson(data["info_OnLeaveSchedulingNo"]);
                agencyCtrl.text = roRescheduleOnLeaveSchedulingNoData!.agencyname!;
                clientCtrl.text = roRescheduleOnLeaveSchedulingNoData!.clientname!;
                delnoCtrl.text = roRescheduleOnLeaveSchedulingNoData!.dealno!;
                branCtrl.text = roRescheduleOnLeaveSchedulingNoData!.brandname!;
                tonumberCtrl.text = roRescheduleOnLeaveSchedulingNoData!.bookingNumber!;
                payrouteCtrl.text = roRescheduleOnLeaveSchedulingNoData!.payRouteName!;
                zoneCtrl.text = roRescheduleOnLeaveSchedulingNoData!.zoneName!;
                rescheduleBookingNumberLeaveData = RoRescheduleBookingNumberLeaveData(
                    infoLeaveBookingNumber: InfoLeaveBookingNumber(
                        lstcmbTapeID: roRescheduleOnLeaveSchedulingNoData!.lstcmbTapeID,
                        agencyname: roRescheduleOnLeaveSchedulingNoData!.agencyname,
                        dealno: roRescheduleOnLeaveSchedulingNoData!.dealno,
                        bookingEffectiveDate: roRescheduleOnLeaveSchedulingNoData!.bookingEffectiveDate,
                        bookingMonth: roRescheduleOnLeaveSchedulingNoData!.bookingMonth,
                        bookingNumber: roRescheduleOnLeaveSchedulingNoData!.bookingNumber,
                        brandname: roRescheduleOnLeaveSchedulingNoData!.brandname,
                        clientname: roRescheduleOnLeaveSchedulingNoData!.brandname,
                        lstcmbBulkTape: roRescheduleOnLeaveSchedulingNoData!.lstcmbBulkTape,
                        payRouteName: roRescheduleOnLeaveSchedulingNoData!.payRouteName,
                        zoneCode: roRescheduleOnLeaveSchedulingNoData!.zoneCode,
                        zoneName: roRescheduleOnLeaveSchedulingNoData!.zoneName,
                        lstDgvRO: roRescheduleOnLeaveSchedulingNoData!.lstDgvRO,
                        lstdgvUpdated: roRescheduleOnLeaveSchedulingNoData!.lstdgvUpdated));
                bookingMonthCtrl.text = roRescheduleOnLeaveSchedulingNoData!.bookingMonth!;
                effDateCtrl.text = DateFormat("dd-MM-yyyy").format(DateTime.parse(roRescheduleOnLeaveSchedulingNoData!.bookingEffectiveDate!));
                // enableFields.value = false;
                update(["dgvGrid", "updatedgvGrid"]);
                // branCtrl.text = rescheduleBookingNumberLeaveData!.infoLeaveBookingNumber!.brandname!;
                // branCtrl.text = rescheduleBookingNumberLeaveData!.infoLeaveBookingNumber!.brandname!;
              }
            } catch (e) {
              LoadingDialog.callErrorMessage1(msg: "Failed To Load Cancellation Data");
            }
          });
    } catch (e) {
      LoadingDialog.callErrorMessage1(msg: "Failed To Load  Data");
    }

    print("ON BOOKING NUMBER LEAVE END>>>");
  }

  dgvGridnRowDoubleTap(index) {
    print("ON ROW DOUBLE TAP CALLED>>>");
    try {
      InfoLeaveBookingNumber data = rescheduleBookingNumberLeaveData!.infoLeaveBookingNumber!;
      Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.RO_RESCHEDULE_DGVGRID_DOUBLECLICK,
          json: {
            "locationCode": selectedLocation!.key!,
            "channelCode": selectedChannel!.key!,
            "BookingNumber": tonumberCtrl.text,
            "BackDated": true,
            "effectivedate": DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy").parse(effDateCtrl.text)),
            "dealNumber": data.dealno,
            "recordNumber": data.lstDgvRO![index]["recordnumber"],
            "zoneCode": data.zoneCode,
            "chkTapeID": changeTapeId.value,
            "lstDgvRow": [data.lstDgvRO![index]]
          },
          fun: (data) {
            if (data is Map<String, dynamic> && data.containsKey("info_OnClickdgvViewRo")) {
              RORescheduleDGviewDoubleClickData viewDoubleClickData = RORescheduleDGviewDoubleClickData.fromJson(data);
              try {
                Get.defaultDialog(
                    content: Container(
                  height: Get.height / 1.5,
                  width: Get.width * .70,
                  child: Row(
                    children: [
                      Container(
                        width: Get.width * 0.30,
                        child: Wrap(
                          spacing: Get.width * .01,
                          runSpacing: 3,
                          children: [
                            DropDownField.formDropDown1WidthMap(
                                [],
                                (data) {},
                                selected: DropDownValue(key: viewDoubleClickData.tapeID, value: viewDoubleClickData.tapeID),
                                "Tape ID",
                                0.12),
                            InputFields.formField1(
                                focusNode: toNumberFocus,
                                isEnable: enableFields.value,
                                hintTxt: "Seg",
                                controller: TextEditingController(text: viewDoubleClickData.segment),
                                width: 0.05),
                            InputFields.formField1(
                                focusNode: toNumberFocus,
                                isEnable: enableFields.value,
                                hintTxt: "Dur",
                                controller: TextEditingController(text: viewDoubleClickData.duration),
                                width: 0.05),
                            InputFields.formField1(
                                focusNode: toNumberFocus,
                                isEnable: enableFields.value,
                                hintTxt: "Caption",
                                controller: TextEditingController(text: viewDoubleClickData.caption),
                                width: 0.24),
                            InputFields.formField1(
                                focusNode: toNumberFocus,
                                isEnable: enableFields.value,
                                hintTxt: "Rev Type",
                                controller: TextEditingController(text: viewDoubleClickData.ravType),
                                width: 0.115),
                            InputFields.formField1(
                                focusNode: toNumberFocus,
                                isEnable: enableFields.value,
                                hintTxt: "Language",
                                controller: TextEditingController(text: viewDoubleClickData.language),
                                width: 0.115),
                            InputFields.formField1(
                                focusNode: toNumberFocus,
                                isEnable: enableFields.value,
                                hintTxt: "Pre/Mid",
                                controller: TextEditingController(text: viewDoubleClickData.preMid),
                                width: 0.24),
                            InputFields.formField1(
                                focusNode: toNumberFocus,
                                isEnable: enableFields.value,
                                hintTxt: "Position",
                                controller: TextEditingController(text: viewDoubleClickData.position),
                                width: 0.14),
                            InputFields.formField1(
                                focusNode: toNumberFocus,
                                isEnable: enableFields.value,
                                hintTxt: "Break",
                                controller: TextEditingController(text: "1"),
                                width: 0.09),
                            InputFields.formField1(
                                focusNode: toNumberFocus,
                                isEnable: enableFields.value,
                                hintTxt: "Program",
                                controller: TextEditingController(text: viewDoubleClickData.oriProg),
                                width: 0.24),
                            DateWithThreeTextField(
                                title: "Sch Date",
                                isEnable: enableFields.value,
                                onFocusChange: (date) {},
                                widthRation: 0.12,
                                mainTextController: TextEditingController(
                                    text: DateFormat("dd-MM-yyyy").format(DateFormat("MM/dd/yyyy HH:mm:ss").parse(viewDoubleClickData.schDate!)))),
                            InputFields.formField1(
                                focusNode: toNumberFocus,
                                isEnable: enableFields.value,
                                hintTxt: "Time",
                                controller: TextEditingController(text: viewDoubleClickData.schTime),
                                width: 0.11),
                            InputFields.formField1(
                                focusNode: toNumberFocus,
                                isEnable: enableFields.value,
                                hintTxt: "TapeID",
                                controller: TextEditingController(text: viewDoubleClickData.tapeID),
                                width: 0.12),
                            DateWithThreeTextField(
                                title: "Kill Dt",
                                isEnable: enableFields.value,
                                onFocusChange: (date) {},
                                widthRation: 0.11,
                                mainTextController: TextEditingController(
                                    text: DateFormat("dd-MM-yyyy").format(DateFormat("MM/dd/yyyy HH:mm:ss").parse(viewDoubleClickData.killDate!)))),
                            InputFields.formField1(
                                focusNode: toNumberFocus, isEnable: enableFields.value, hintTxt: "Cmp Prod", controller: tonumberCtrl, width: 0.115),
                            InputFields.formField1(
                                focusNode: toNumberFocus, isEnable: enableFields.value, hintTxt: "", controller: tonumberCtrl, width: 0.115),
                            FormButtonWrapper(
                              btnText: "Add Spots",
                              callback: () {
                                addSpot(viewDoubleClickData.toJson());
                              },
                            ),
                            FormButtonWrapper(btnText: "Back "),
                          ],
                        ),
                      ),
                      Expanded(
                          child: Container(
                        child: DataGridShowOnlyKeys(
                          mapData: dummyProgram,
                          formatDate: false,
                        ),
                      ))
                    ],
                  ),
                ));
              } catch (e) {
                LoadingDialog.callErrorMessage1(msg: "Failed To Load Cancellation Data");
              }
            }
          });
    } catch (e) {
      LoadingDialog.callErrorMessage1(msg: "Failed To Load  Data");
    }

    print("ON ROW DPUBLE TAP END>>>");
  }

  onChangeTapeIDClick() {
    var tapeId =
        rescheduleBookingNumberLeaveData!.infoLeaveBookingNumber!.lstDgvRO![plutoGridStateManager!.currentCell!.row.sortIdx]["exportTapeCode"];
    print(rescheduleBookingNumberLeaveData!.infoLeaveBookingNumber!.lstDgvRO![plutoGridStateManager!.currentCell!.row.sortIdx]);
    print(tapeId);
    Get.find<ConnectorControl>().GETMETHODCALL(
        api: ApiFactory.RO_RESCHEDULE_SELECTED_INDEX_CHNAGE_TAPEID(tapeId),
        fun: (data) {
          print(data);
        });
  }

  modify() {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.RO_RESCHEDULE_MODIFY,
        json: {
          "exportTapeCode": modifySelectedTapeCode!.key!,
          "segmentNumber": "1",
          "lstDgvRO": [rescheduleBookingNumberLeaveData!.infoLeaveBookingNumber!.lstDgvRO![plutoGridStateManager!.currentCell!.row.sortIdx]]
        },
        fun: (data) {});
  }

  addSpot(data) {
    Get.find<ConnectorControl>().POSTMETHOD(api: ApiFactory.RO_RESCHEDULE_ADDSPOT, json: data, fun: (data) {});
  }
}

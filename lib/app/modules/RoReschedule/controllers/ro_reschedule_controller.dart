import 'dart:convert';

import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/controller/MainController.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/dummydata.dart';
import 'package:bms_scheduling/app/modules/RoCancellation/bindings/ro_cancellation_doc.dart';
import 'package:bms_scheduling/app/modules/RoReschedule/bindings/ro_booking_leave_data.dart';
import 'package:bms_scheduling/app/modules/RoReschedule/bindings/ro_init_data.dart';
import 'package:bms_scheduling/app/modules/RoReschedule/bindings/ro_re_dgview_double_click.dart';
import 'package:bms_scheduling/app/modules/RoReschedule/bindings/ro_re_schedule_leave_dart.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/app/providers/ExportData.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';

import '../../../data/DropDownValue.dart';
import '../../CommonDocs/controllers/common_docs_controller.dart';
import '../../CommonDocs/views/common_docs_view.dart';

class RoRescheduleController extends GetxController {
  RxList<DropDownValue> locations = <DropDownValue>[].obs;
  RxList<DropDownValue> channels = <DropDownValue>[].obs;
  TextEditingController cancelDatectrl = TextEditingController();
  DropDownValue? selectedLocation;
  DropDownValue? selectedChannel;
  var enableFields = RxBool(true);
  List<RoCancellationDocuments> documents = [];
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
  // RoRescheduleBookingNumberLeaveData? rescheduleBookingNumberLeaveData;
  RORescheduleOnLeaveData? roRescheduleOnLeaveData;
  FocusNode toNumberFocus = FocusNode();
  FocusNode reScheduleFocus = FocusNode();
  DropDownValue? modifySelectedTapeCode;
  TextEditingController changeTapeIdSeg = TextEditingController(),
      changeTapeIdDur = TextEditingController(),
      chnageTapeIdCap = TextEditingController();
  PlutoGridStateManager? plutoGridStateManager;
  PlutoGridStateManager? updatedplutoGridStateManager;
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
            if (data is Map && data.containsKey("info_LeaveBookingNumber")) {
              print("Parsing Data");
              roRescheduleOnLeaveData = RORescheduleOnLeaveData.fromJson(data["info_LeaveBookingNumber"]);

              agencyCtrl.text = roRescheduleOnLeaveData!.agencyname!;
              clientCtrl.text = roRescheduleOnLeaveData!.clientname!;
              delnoCtrl.text = roRescheduleOnLeaveData!.dealno!;
              branCtrl.text = roRescheduleOnLeaveData!.brandname!;
              payrouteCtrl.text = roRescheduleOnLeaveData!.payRouteName!;
              zoneCtrl.text = roRescheduleOnLeaveData!.zoneName!;
              bookingMonthCtrl.text = roRescheduleOnLeaveData!.bookingMonth!;
              effDateCtrl.text = DateFormat("dd-MM-yyyy").format(DateTime.parse(roRescheduleOnLeaveData!.bookingEffectiveDate!));
              enableFields.value = false;
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
            if (data is Map<String, dynamic> && data.containsKey("info_OnLeaveSchedulingNo")) {
              roRescheduleOnLeaveData = RORescheduleOnLeaveData.fromJson(data["info_OnLeaveSchedulingNo"]);
              agencyCtrl.text = roRescheduleOnLeaveData!.agencyname!;
              clientCtrl.text = roRescheduleOnLeaveData!.clientname!;
              delnoCtrl.text = roRescheduleOnLeaveData!.dealno!;
              branCtrl.text = roRescheduleOnLeaveData!.brandname!;
              tonumberCtrl.text = roRescheduleOnLeaveData!.bookingNumber!;
              payrouteCtrl.text = roRescheduleOnLeaveData!.payRouteName!;
              zoneCtrl.text = roRescheduleOnLeaveData!.zoneName!;

              bookingMonthCtrl.text = roRescheduleOnLeaveData!.bookingMonth!;
              effDateCtrl.text = DateFormat("dd-MM-yyyy").format(DateTime.parse(roRescheduleOnLeaveData!.bookingEffectiveDate!));
              // enableFields.value = false;
              update(["dgvGrid", "updatedgvGrid"]);
              // branCtrl.text = rescheduleBookingNumberLeaveData!.infoLeaveBookingNumber!.brandname!;
              // branCtrl.text = rescheduleBookingNumberLeaveData!.infoLeaveBookingNumber!.brandname!;
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
      LoadingDialog.call();
      Get.find<ConnectorControl>().POSTMETHOD(
          api: ApiFactory.RO_RESCHEDULE_DGVGRID_DOUBLECLICK,
          json: {
            "locationCode": selectedLocation!.key!,
            "channelCode": selectedChannel!.key!,
            "BookingNumber": tonumberCtrl.text,
            "BackDated": true,
            "effectivedate": DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy").parse(effDateCtrl.text)),
            "dealNumber": roRescheduleOnLeaveData!.dealno,
            "recordNumber": roRescheduleOnLeaveData!.lstDgvRO![index].recordnumber,
            "zoneCode": roRescheduleOnLeaveData!.zoneCode,
            "chkTapeID": changeTapeId.value,
            "lstDgvRow": [roRescheduleOnLeaveData!.lstDgvRO![index].toJson()],
            "lstTapeDetails": roRescheduleOnLeaveData!.lstTapeDetails!.map((e) => e.toJson()).toList()
          },
          fun: (data) {
            Get.back();
            if (data is Map<String, dynamic> && data.containsKey("info_OnClickdgvViewRo")) {
              RORescheduleDGviewDoubleClickData viewDoubleClickData = RORescheduleDGviewDoubleClickData.fromJson(data["info_OnClickdgvViewRo"]);
              PlutoGridStateManager? addSpotGridManager;
              try {
                Get.defaultDialog(
                    content: Container(
                  height: Get.height / 1.3,
                  width: Get.width * .70,
                  child: Row(
                    children: [
                      Container(
                        width: Get.width * 0.26,
                        child: Wrap(
                          spacing: Get.width * .01,
                          runSpacing: 3,
                          children: [
                            DropDownField.formDropDown1WidthMap(
                                [],
                                (data) {},
                                selected: DropDownValue(key: viewDoubleClickData.tapeID, value: viewDoubleClickData.tapeID),
                                "Tape ID",
                                isEnable: false,
                                0.12),
                            InputFields.formField1(
                                isEnable: false, hintTxt: "Seg", controller: TextEditingController(text: viewDoubleClickData.segment), width: 0.05),
                            InputFields.formField1(
                                isEnable: false, hintTxt: "Dur", controller: TextEditingController(text: viewDoubleClickData.duration), width: 0.05),
                            InputFields.formField1(
                                focusNode: toNumberFocus,
                                isEnable: false,
                                hintTxt: "Caption",
                                controller: TextEditingController(text: viewDoubleClickData.caption),
                                width: 0.24),
                            InputFields.formField1(
                                isEnable: false,
                                hintTxt: "Rev Type",
                                controller: TextEditingController(text: viewDoubleClickData.ravType),
                                width: 0.115),
                            InputFields.formField1(
                                isEnable: false,
                                hintTxt: "Language",
                                controller: TextEditingController(text: viewDoubleClickData.language),
                                width: 0.115),
                            InputFields.formField1(
                                isEnable: false,
                                hintTxt: "Pre/Mid",
                                controller: TextEditingController(text: viewDoubleClickData.preMid),
                                width: 0.24),
                            InputFields.formField1(
                                isEnable: false,
                                hintTxt: "Position",
                                controller: TextEditingController(text: viewDoubleClickData.position),
                                width: 0.14),
                            DropDownField.formDropDown1WidthMap(
                                List.generate(10, (index) => DropDownValue(value: (index + 1).toString(), key: (index + 1).toString())),
                                (data) {},
                                selected: DropDownValue(key: "1", value: "1"),
                                "Break",
                                0.09),
                            InputFields.formField1(
                                isEnable: false,
                                hintTxt: "Program",
                                controller: TextEditingController(text: viewDoubleClickData.oriProg),
                                width: 0.24),
                            DateWithThreeTextField(
                                title: "Sch Date",
                                isEnable: false,
                                onFocusChange: (date) {},
                                widthRation: 0.12,
                                mainTextController: TextEditingController(
                                    text: DateFormat("dd-MM-yyyy").format(DateFormat("MM/dd/yyyy HH:mm:ss").parse(viewDoubleClickData.schDate!)))),
                            InputFields.formField1(
                                isEnable: false, hintTxt: "Time", controller: TextEditingController(text: viewDoubleClickData.schTime), width: 0.11),
                            InputFields.formField1(
                                isEnable: false, hintTxt: "TapeID", controller: TextEditingController(text: viewDoubleClickData.tapeID), width: 0.12),
                            DateWithThreeTextField(
                                title: "Kill Dt",
                                isEnable: false,
                                onFocusChange: (date) {},
                                widthRation: 0.11,
                                mainTextController: TextEditingController(
                                    text: DateFormat("dd-MM-yyyy").format(DateFormat("MM/dd/yyyy HH:mm:ss").parse(viewDoubleClickData.killDate!)))),
                            InputFields.formField1(
                                isEnable: false,
                                hintTxt: "Cmp Prod",
                                controller: TextEditingController(
                                    text:
                                        DateFormat("dd-MM-yyyy").format(DateFormat("MM/dd/yyyy HH:mm:ss").parse(viewDoubleClickData.campStartDate!))),
                                width: 0.115),
                            InputFields.formField1(
                                isEnable: false,
                                hintTxt: "",
                                controller: TextEditingController(
                                    text: DateFormat("dd-MM-yyyy").format(DateFormat("MM/dd/yyyy HH:mm:ss").parse(viewDoubleClickData.campEndDate!))),
                                width: 0.115),
                            FormButtonWrapper(
                              btnText: "Add Spots",
                              callback: () {
                                addSpot(viewDoubleClickData);
                              },
                            ),
                            FormButtonWrapper(
                              btnText: "Back",
                              callback: () {
                                Get.back();
                              },
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                          child: Container(
                        child: DataGridShowOnlyKeys(
                          onload: (load) {
                            addSpotGridManager = load.stateManager;
                          },
                          editKeys: ["bookedSpots"],
                          onEdit: (editEvent) {
                            for (var i = 0; i < viewDoubleClickData.lstDetTable!.length; i++) {
                              viewDoubleClickData.lstDetTable![i].bookedSpots = 0;
                            }
                            viewDoubleClickData.lstDetTable![editEvent.rowIdx].bookedSpots = int.tryParse(editEvent.value) ?? 0;

                            for (var element in addSpotGridManager!.rows) {
                              addSpotGridManager!
                                  .changeCellValue(element.cells["bookedSpots"]!, "0", force: true, notify: false, callOnChangedEvent: false);
                            }
                            addSpotGridManager!.changeCellValue(editEvent.row.cells["bookedSpots"]!, int.tryParse(editEvent.value) ?? "0",
                                callOnChangedEvent: false, force: true);
                          },
                          onRowDoubleTap: (rowdblclick) {
                            addSpotGridManager!.setCurrentCell(rowdblclick.cell, rowdblclick.rowIdx);

                            for (var i = 0; i < viewDoubleClickData.lstDetTable!.length; i++) {
                              viewDoubleClickData.lstDetTable![i].bookedSpots = 0;
                            }
                            viewDoubleClickData.lstDetTable![rowdblclick.rowIdx].bookedSpots = 1;

                            for (var element in addSpotGridManager!.rows) {
                              addSpotGridManager!
                                  .changeCellValue(element.cells["bookedSpots"]!, "0", force: true, notify: false, callOnChangedEvent: false);
                            }
                            addSpotGridManager!.changeCellValue(rowdblclick.row.cells["bookedSpots"]!, "1", callOnChangedEvent: false, force: true);
                          },
                          mapData: viewDoubleClickData.lstDetTable!.map((e) => e.toJson()).toList(),
                          formatDate: true,
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
    var tapeId = roRescheduleOnLeaveData!.lstDgvRO![plutoGridStateManager!.currentCell!.row.sortIdx].exportTapeCode;

    print(tapeId);
    Get.find<ConnectorControl>().POSTMETHOD_FORMDATA(
        api: ApiFactory.RO_RESCHEDULE_SELECTED_INDEX_CHNAGE_TAPEID,
        json: {"TapeID": tapeId, "lstTapeDetails": roRescheduleOnLeaveData!.lstTapeDetails!.map((e) => e.toJson()).toList()},
        fun: (data) {
          if (data is Map && data.containsKey("info_SelectedIndexChanged_TapeID")) {
            var tapeData = data["info_SelectedIndexChanged_TapeID"];
            chnageTapeIdCap.text = tapeData["commercialCaption"];
            if (roRescheduleOnLeaveData?.lstcmbTapeID != null && roRescheduleOnLeaveData!.lstcmbTapeID!.isNotEmpty) {
              modifySelectedTapeCode = DropDownValue(
                  key: roRescheduleOnLeaveData?.lstcmbTapeID![0].exporttapecode, value: roRescheduleOnLeaveData?.lstcmbTapeID![0].exporttapecode);
            }
            changeTapeIdSeg.text = roRescheduleOnLeaveData!.lstDgvRO![plutoGridStateManager!.currentCell!.row.sortIdx].segmentNumber.toString();
            changeTapeIdDur.text = roRescheduleOnLeaveData!.lstDgvRO![plutoGridStateManager!.currentCell!.row.sortIdx].tapeDuration.toString();
            changeTapeId.value = !changeTapeId.value;
          }
        });
  }

  modify() {
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.RO_RESCHEDULE_MODIFY,
        json: {
          "exportTapeCode": modifySelectedTapeCode!.value!,
          "segmentNumber": roRescheduleOnLeaveData!.lstDgvRO![plutoGridStateManager!.currentCell!.row.sortIdx].segmentNumber.toString(),
          "lstTable": roRescheduleOnLeaveData!.lstTable!.map((e) => e.toJson()).toList(),
          "lstUpdateTable": roRescheduleOnLeaveData!.lstUpdateTable!.map((e) => e.toJson()).toList(),
          "lstDgvRO": [roRescheduleOnLeaveData!.lstDgvRO![plutoGridStateManager!.currentCell!.row.sortIdx].toJson()]
        },
        fun: (data) {
          if (data is Map && data.containsKey("info_Modify")) {
            print("Parsing lstDgvRO");
            if (data["info_Modify"] is Map && data["info_Modify"].containsKey("lstDgvRO") && (data["info_Modify"]["lstDgvRO"] is List)) {
              roRescheduleOnLeaveData!.lstDgvRO = (data["info_Modify"]["lstDgvRO"] as List).map((e) => LstDgvRO.fromJson(e)).toList();
            }
            print("Parsing lstTable");
            if (data["info_Modify"] is Map && data["info_Modify"].containsKey("lstTable") && (data["info_Modify"]["lstTable"] is List)) {
              roRescheduleOnLeaveData!.lstTable = (data["info_Modify"]["lstTable"] as List).map((e) => LstTable.fromJson(e)).toList();
            }
            print("Parsing lstUpdateTable");
            if (data["info_Modify"] is Map && data["info_Modify"].containsKey("lstUpdateTable") && (data["info_Modify"]["lstUpdateTable"] is List)) {
              roRescheduleOnLeaveData!.lstUpdateTable =
                  (data["info_Modify"]["lstUpdateTable"] as List).map((e) => LstUpdateTable.fromJson(e)).toList();
            }
            print("Parsing lstdgvUpdated");

            if (data["info_Modify"] is Map && data["info_Modify"].containsKey("lstdgvUpdated") && (data["info_Modify"]["lstdgvUpdated"] is List)) {
              roRescheduleOnLeaveData!.lstdgvUpdated = (data["info_Modify"]["lstdgvUpdated"] as List).map((e) => LstdgvUpdated.fromJson(e)).toList();
            }
            update(["dgvGrid", "updatedgvGrid"]);
            if (data["info_Modify"].containsKey("message") && data["info_Modify"]["message"] != null) {
              LoadingDialog.callInfoMessage(data["info_Modify"]["message"]);
            }
          }
        });
  }

  closeModify() {
    changeTapeId.value = false;
    changeTapeIdSeg.text = "";
    changeTapeIdDur.text = "";
    modifySelectedTapeCode = null;
  }

  addSpot(RORescheduleDGviewDoubleClickData data) {
    var json = {
      "breakNo": roRescheduleOnLeaveData!.lstDgvRO![plutoGridStateManager!.currentCell!.row.sortIdx].breaknumber.toString(),
      "midPre": reschedulngInitData?.lstspotPositionTypeMasters
              ?.firstWhere((element) => element.spotPositionTypeName == data.preMid)
              .spotPositionTypeCode ??
          "",
      "positionCode": roRescheduleOnLeaveData!.lstDgvRO![plutoGridStateManager!.currentCell!.row.sortIdx].positionCode,
      "chkTapeID": changeTapeId.value,
      "exportTapeCode_OriTapeID": data.oriTapeID,
      "exportTapeCode_TapeID": data.tapeID,
      "tapeDuration": data.duration,
      "bookingDetailCode": roRescheduleOnLeaveData!.lstDgvRO![plutoGridStateManager!.currentCell!.row.sortIdx].bookingDetailCode.toString(),
      "recordnumber": roRescheduleOnLeaveData!.lstDgvRO![plutoGridStateManager!.currentCell!.row.sortIdx].recordnumber.toString(),
      "segmentNumber": data.segment,
      "breaknumber": roRescheduleOnLeaveData!.lstDgvRO![plutoGridStateManager!.currentCell!.row.sortIdx].breaknumber.toString(),
      "spotPositionTypeName": roRescheduleOnLeaveData!.lstDgvRO![plutoGridStateManager!.currentCell!.row.sortIdx].spotPositionTypeName,
      "positionName": roRescheduleOnLeaveData!.lstDgvRO![plutoGridStateManager!.currentCell!.row.sortIdx].positionName,
      "lstTable": roRescheduleOnLeaveData?.lstTable?.map((e) => e.toJson()).toList(),
      "lstUpdateTable": roRescheduleOnLeaveData?.lstUpdateTable?.map((e) => e.toJson()).toList(),
      "lstDetTable": data.lstDetTable!.map((e) => e.toJson()).toList(),
    };
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.RO_RESCHEDULE_ADDSPOT,
        json: json,
        fun: (data) {
          if (data is Map && data.containsKey("info_AddSpots")) {
            if (data["info_AddSpots"].containsKey("addspot") && data["info_AddSpots"]["addspot"]) {
              print("Parsing lstDgvRO");
              if (data["info_AddSpots"] is Map && data["info_AddSpots"].containsKey("lstDgvRO") && (data["info_AddSpots"]["lstDgvRO"] is List)) {
                roRescheduleOnLeaveData!.lstDgvRO = (data["info_AddSpots"]["lstDgvRO"] as List).map((e) => LstDgvRO.fromJson(e)).toList();
              }
              print("Parsing lstTable");
              if (data["info_AddSpots"] is Map && data["info_AddSpots"].containsKey("lstTable") && (data["info_AddSpots"]["lstTable"] is List)) {
                roRescheduleOnLeaveData!.lstTable = (data["info_AddSpots"]["lstTable"] as List).map((e) => LstTable.fromJson(e)).toList();
              }
              print("Parsing lstUpdateTable");
              if (data["info_AddSpots"] is Map &&
                  data["info_AddSpots"].containsKey("lstUpdateTable") &&
                  (data["info_AddSpots"]["lstUpdateTable"] is List)) {
                roRescheduleOnLeaveData!.lstUpdateTable =
                    (data["info_AddSpots"]["lstUpdateTable"] as List).map((e) => LstUpdateTable.fromJson(e)).toList();
              }
              print("Parsing lstdgvUpdated");

              if (data["info_AddSpots"] is Map &&
                  data["info_AddSpots"].containsKey("lstdgvUpdated") &&
                  (data["info_AddSpots"]["lstdgvUpdated"] is List)) {
                roRescheduleOnLeaveData!.lstdgvUpdated =
                    (data["info_AddSpots"]["lstdgvUpdated"] as List).map((e) => LstdgvUpdated.fromJson(e)).toList();
              }
              update(["dgvGrid", "updatedgvGrid"]);
              Get.back();
            }

            if (data["info_AddSpots"].containsKey("message") && data["info_AddSpots"]["message"] != null) {
              LoadingDialog.callInfoMessage(data["info_AddSpots"]["message"]);
            }
          }
        });
  }

  docs() async {
    Get.defaultDialog(
      title: "Documents",
      content:
          CommonDocsView(documentKey: "ROReschedule ${selectedLocation!.key}${selectedChannel!.key}${bookingMonthCtrl.text}${reSchedNoCtrl.text}"),
    ).then((value) {
      Get.delete<CommonDocsController>(tag: "commonDocs");
    });
    // PlutoGridStateManager? viewDocsStateManger;
    // try {
    //   LoadingDialog.call();
    //   await Get.find<ConnectorControl>().GETMETHODCALL(
    //       api: ApiFactory.RO_CANCELLATION_LOAD_DOC(
    //           "ROReschedule ${selectedLocation!.key}${selectedChannel!.key}${bookingMonthCtrl.text}${reSchedNoCtrl.text}"),
    //       fun: (data) {
    //         if (data is Map && data.containsKey("info_GetAllDocument")) {
    //           documents = [];
    //           for (var doc in data["info_GetAllDocument"]) {
    //             documents.add(RoCancellationDocuments.fromJson(doc));
    //           }
    //           Get.back();
    //         }
    //       });
    // } catch (e) {
    //   Get.back();
    // }

    // Get.defaultDialog(
    //     title: "Documents",
    //     content: Container(
    //       width: Get.width / 2.5,
    //       height: Get.height / 2.5,
    //       child: DataGridShowOnlyKeys(
    //         mapData: documents.map((e) => e.toJson()).toList(),
    //         onload: (loadGrid) {
    //           viewDocsStateManger = loadGrid.stateManager;
    //         },
    //       ),
    //     ),
    //     actions: {"Add Doc": () async {}, "View Doc": () {}, "Attach Email": () {}}
    //         .entries
    //         .map((e) => FormButtonWrapper(
    //               btnText: e.key,
    //               callback: e.key == "Add Doc"
    //                   ? () async {
    //                       FilePickerResult? result = await FilePicker.platform.pickFiles();

    //                       if (result != null && result.files.single != null) {
    //                         LoadingDialog.call();
    //                         await Get.find<ConnectorControl>().POSTMETHOD(
    //                             api: ApiFactory.RO_CANCELLATION_ADD_DOC,
    //                             fun: (data) {
    //                               if (data is Map && data.containsKey("addingDocument")) {
    //                                 for (var doc in data["addingDocument"]) {
    //                                   documents.add(RoCancellationDocuments.fromJson(doc));
    //                                 }
    //                                 Get.back();
    //                                 docs();
    //                               }
    //                             },
    //                             json: {
    //                               "documentKey":
    //                                   "ROReschedule ${selectedLocation!.key}${selectedChannel!.key}${bookingMonthCtrl.text}${reSchedNoCtrl.text}",
    //                               "strFilePath": result.files.first.name,
    //                               "bytes": base64.encode(List<int>.from(result.files.first.bytes ?? []))
    //                             });
    //                         Get.back();
    //                       }
    //                     }
    //                   : e.key == "View Doc"
    //                       ? () {
    //                           Get.find<ConnectorControl>().GETMETHODCALL(
    //                               api: ApiFactory.RO_CANCELLATION_VIEW_DOC(documents[viewDocsStateManger!.currentCell!.row.sortIdx].documentId),
    //                               fun: (data) {
    //                                 if (data is Map && data.containsKey("addingDocument")) {
    //                                   ExportData().exportFilefromByte(
    //                                       base64Decode(data["addingDocument"][0]["documentData"]), data["addingDocument"][0]["documentname"]);
    //                                 }
    //                               });
    //                         }
    //                       : () {},
    //             ))
    //         .toList());
  }

  save() {
    List lstdgvUpdated = [];
    for (var element in roRescheduleOnLeaveData!.lstdgvUpdated!) {
      element.scheduleTime = DateFormat("yyyy-MM-ddTHH:mm:ss").format(DateFormat("HH:mm:ss").parse(element.scheduleTime!));
      var map = element.toJson();

      lstdgvUpdated.add(map);
    }
    Get.find<ConnectorControl>().POSTMETHOD(
        api: ApiFactory.RO_RESCHEDULE_SAVE,
        json: {
          "locationCode": selectedLocation!.key!,
          "channelCode": selectedChannel!.key!,
          "rescheduleMonth": bookingMonthCtrl.text,
          "rescheduleNumber": int.tryParse("reSchedNoCtrl.text") ?? 0,
          "rescheduleDate": DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy").parse(refDateCtrl.text)),
          "bookingEffectiveDate": DateFormat("yyyy-MM-dd").format(DateFormat("dd-MM-yyyy").parse(effDateCtrl.text)),
          "rescheduleReferenceNumber": referenceCtrl.text,
          "clientCode": roRescheduleOnLeaveData!.clientname!,
          "agencyCode": agencyCtrl.text,
          "brandCode": branCtrl.text,
          "rescheduleDuration": 0,
          "rescheduleAmount": 0,
          "executiveCode": roRescheduleOnLeaveData!.bookingNumber!,
          "modifiedBy": Get.find<MainController>().user?.logincode ?? "",
          "dealno": roRescheduleOnLeaveData!.dealno,
          "bookingnumber": roRescheduleOnLeaveData!.bookingNumber!,
          "edit": 0,
          "LstdgvUpdated": lstdgvUpdated
        },
        fun: (data) {
          print(data);
        });
  }
}

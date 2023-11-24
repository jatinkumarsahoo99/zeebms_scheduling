// import 'package:bms_scheduling/widgets/cutom_dropdown.dart';
import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/modules/RoBooking/controllers/ro_booking_controller.dart';
import 'package:bms_scheduling/app/modules/RoBooking/views/dummydata.dart';
import 'package:bms_scheduling/app/providers/SizeDefine.dart';
import 'package:bms_scheduling/app/providers/extensions/string_extensions.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';

import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../data/DropDownValue.dart';
import '../../../data/user_data_settings_model.dart';
import '../../../providers/ApiFactory.dart';

class SpotsView extends GetView<RoBookingController> {
  const SpotsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: Container(
          child: controller.bookingNoLeaveData != null ||
                  controller.addSpotData != null
              ? DataGridShowOnlyKeys(
                  keysWidths: (controller.userDataSettings?.userSetting
                      ?.firstWhere(
                          (element) => element.controlName == "spotViewGrid",
                          orElse: () => UserSetting())
                      .userSettings),
                  onload: (loadEvent) {
                    controller.spotViewGrid = loadEvent.stateManager;
                  },
                  mapData: controller.addSpotData?.lstSpots
                          ?.map((e) => e.toJson())
                          .toList() ??
                      controller.bookingNoLeaveData?.lstSpots
                          ?.map((e) => e.toJson())
                          .toList() ??
                      [],
                  formatDate: true)
              : Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.0, color: Colors.grey)),
                ),
        )),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Wrap(
              spacing: 5,
              children: [
                DropDownField.formDropDown1WidthMap(
                  controller.agencyLeaveData?.lstPdcList
                          ?.map((e) => DropDownValue(
                              key: e.chequeId.toString(),
                              value: e.chequeNo.toString()))
                          .toList() ??
                      [],
                  (value) {
                    controller.selectedPdc = value;
                  },
                  "PDC",
                  0.12,
                  showMenuInbottom: false,
                  // dialogHeight: 80,
                  selected: controller.selectedPdc,
                ),
                InputFields.formField1(
                    hintTxt: "Amt",
                    isEnable: false,
                    controller: TextEditingController(
                        text: (controller
                                    .agencyLeaveData?.lstPdcList?.isNotEmpty ??
                                false)
                            ? (controller.agencyLeaveData?.lstPdcList?.first
                                        .chequeAmount ??
                                    "")
                                .toString()
                            : "")),
                InputFields.formField1(
                    hintTxt: "Bank",
                    width: 0.24,
                    isEnable: false,
                    controller: TextEditingController(
                        text: (controller
                                    .agencyLeaveData?.lstPdcList?.isNotEmpty ??
                                false)
                            ? (controller.agencyLeaveData?.lstPdcList?.first
                                        .bankName ??
                                    "")
                                .toString()
                            : "")),
                InputFields.formField1(
                    hintTxt: "Bal Amt",
                    isEnable: false,
                    controller: TextEditingController(
                        text: (controller
                                    .agencyLeaveData?.lstPdcList?.isNotEmpty ??
                                false)
                            ? (controller.agencyLeaveData?.lstPdcList?.first
                                        .chequeAmount ??
                                    "")
                                .toString()
                            : "")),
              ],
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.end,
              spacing: 5,
              children: [
                FormButtonWrapper(
                  btnText: "Refresh PDC",
                  iconDataM: Icons.refresh_rounded,
                  callback: () {
                    controller.refreshPDC();
                  },
                ),
                FormButtonWrapper(
                  iconDataM: Icons.delete_outline_rounded,
                  btnText: "Del Spot Row",
                  callback: () {
                    if (controller.spotViewGrid?.currentRow != null) {
                      print(controller
                          .spotViewGrid?.currentRow?.cells['toNo']?.value);
                      if (controller.spotViewGrid?.currentRow?.cells['toNo']
                                  ?.value ==
                              null ||
                          (controller.spotViewGrid?.currentRow?.cells['toNo']
                                      ?.value ??
                                  "") ==
                              "" ||
                          controller.spotViewGrid?.currentRow?.cells['toNo']
                                  ?.value ==
                              "0") {
                        LoadingDialog.modify("Want to delete row?", () {
                          //yess
                          if (controller.addSpotData != null &&
                              controller.addSpotData?.lstSpots != null) {
                            print(1);
                            controller.addSpotData?.lstSpots?.removeAt(
                                controller.spotViewGrid!.currentRowIdx!);
                          } else if (controller.bookingNoLeaveData != null &&
                              controller.bookingNoLeaveData?.lstSpots != null) {
                            print(2);
                            controller.bookingNoLeaveData?.lstSpots?.removeAt(
                                controller.spotViewGrid!.currentRowIdx!);
                            var spot = int.parse(controller.totSpotCtrl.text) -
                                int.parse(controller.spotViewGrid?.currentRow
                                    ?.cells['spots']?.value);
                            controller.totSpotCtrl.text = spot.toString();

                            var dur = int.parse(controller.totDurCtrl.text) -
                                int.parse(controller.spotViewGrid?.currentRow
                                    ?.cells['tapeDuration']?.value);
                            controller.totDurCtrl.text = dur.toString();

                            var amt = double.parse(controller.totAmtCtrl.text) -
                                double.parse(controller.spotViewGrid?.currentRow
                                    ?.cells['spotAmount']?.value);
                            controller.totAmtCtrl.text = amt.toString();
                            for (var i = 0;
                                i <
                                    controller.bookingNoLeaveData!
                                        .lstdgvDealDetails!.length;
                                i++) {
                              var data = controller
                                  .bookingNoLeaveData!.lstdgvDealDetails![i];

                              if (data.recordnumber.toString() ==
                                      controller.spotViewGrid?.currentRow
                                          ?.cells['dealrownumber']?.value
                                          .toString() &&
                                  controller.selectedChannel?.value ==
                                      data.channelname &&
                                  controller.selectedLocation?.value ==
                                      data.locationname &&
                                  controller.selectedDeal?.value ==
                                      data.dealNumber) {
                                if (data.seconds != 0) {
                                  if (controller.bookingNoLeaveData?.accountCode != 'I000100010' &&
                                      controller.bookingNoLeaveData
                                              ?.accountCode !=
                                          'I000100005' &&
                                      controller.bookingNoLeaveData
                                              ?.accountCode !=
                                          'I000100004') {
                                    data.bookedSeconds = data.bookedSeconds ??
                                        0 -
                                            (num.tryParse(controller
                                                        .spotViewGrid
                                                        ?.currentRow
                                                        ?.cells['tapeDuration']
                                                        ?.value
                                                        .toString() ??
                                                    "0") ??
                                                0);
                                    data.balanceSeconds = data.seconds ??
                                        0 - (data.bookedSeconds ?? 0);
                                    controller.bookingNoLeaveData!
                                        .lstdgvDealDetails![i] = data;
                                  } else if (controller.bookingNoLeaveData
                                              ?.accountCode !=
                                          'I000100010' &&
                                      data.subrevenuetypecode == 9) {
                                    data.bookedSeconds = data.bookedSeconds ??
                                        0 -
                                            (num.tryParse(controller
                                                        .spotViewGrid
                                                        ?.currentRow
                                                        ?.cells['tapeDuration']
                                                        ?.value
                                                        .toString() ??
                                                    "0") ??
                                                0);
                                    data.balanceSeconds = data.seconds ??
                                        0 - (data.bookedSeconds ?? 0);
                                    controller.bookingNoLeaveData!
                                        .lstdgvDealDetails![i] = data;
                                  } else {
                                    data.bookedSeconds = data.bookedSeconds ??
                                        0 -
                                            (num.tryParse(controller
                                                        .spotViewGrid
                                                        ?.currentRow
                                                        ?.cells['tapeDuration']
                                                        ?.value
                                                        .toString() ??
                                                    "0") ??
                                                0);
                                    data.balanceSeconds = data.seconds ??
                                        0 - (data.bookedSeconds ?? 0);
                                    controller.bookingNoLeaveData!
                                        .lstdgvDealDetails![i] = data;
                                  }
                                }
                              }
                            }
                          }
                          controller.spotViewGrid?.removeRows(
                              [controller.spotViewGrid!.currentRow!]);
                        }, () {
                          //no
                          Get.back();
                        });
                      } else {
                        LoadingDialog.showErrorDialog(
                            "Spot is already audited cannot remove the row.");
                      }
                    }
                  },
                ),
                FormButtonWrapper(
                  btnText: "PDC Cheques",
                  iconDataM: Icons.wallet_rounded,
                  callback: () async {
                    await Get.find<ConnectorControl>().POSTMETHOD(
                        api: ApiFactory.RO_BOOKING_GetClientPDC,
                        json: {
                          "locationName": controller.selectedLocation?.value,
                          "channelName": controller.selectedChannel?.value,
                          "clientName": controller.selectedClient?.value,
                          "agencyName": controller.selectedAgnecy?.value,
                          "activityPeriod": controller.bookingMonthCtrl.text
                        },
                        fun: (value) {
                          Map data = {};
                          if (value is Map &&
                              value.containsKey("info_OnLoadClientPDC")) {
                            data = value["info_OnLoadClientPDC"];
                          }
                          TextEditingController chequeNoCtrl =
                                  TextEditingController(),
                              chqDateCtrl = TextEditingController(),
                              chequeAmtCtrl = TextEditingController(),
                              bankCtrl = TextEditingController(),
                              chequeRecByCtrl = TextEditingController(),
                              chequeRecOnCtrl = TextEditingController(),
                              remarkCtrl = TextEditingController();
                          var listdata = RxList([]);

                          Get.defaultDialog(
                              title: "Client PDC",
                              content: SizedBox(
                                height: Get.height * 0.80,
                                width: Get.width * .60,
                                child: Column(
                                  children: [
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.end,
                                      spacing: Get.width * 0.01,
                                      runSpacing: 05,
                                      children: [
                                        InputFields.formField1(
                                            isEnable: false,
                                            hintTxt: "Location",
                                            width: 0.18,
                                            controller: TextEditingController(
                                                text: data["locationName"])),
                                        InputFields.formField1(
                                            isEnable: false,
                                            hintTxt: "Channel",
                                            width: 0.18,
                                            controller: TextEditingController(
                                                text: data["channelName"])),
                                        InputFields.formField1(
                                            isEnable: false,
                                            hintTxt: "Client",
                                            width: 0.18,
                                            controller: TextEditingController(
                                                text: data["clientName"])),
                                        InputFields.formField1(
                                            isEnable: false,
                                            hintTxt: "Agency",
                                            width: 0.18,
                                            controller: TextEditingController(
                                                text: data["agencyName"])),
                                        InputFields.formField1(
                                            isEnable: false,
                                            hintTxt: "Activity Period",
                                            width: 0.18,
                                            controller: TextEditingController(
                                                text: data["activityPeriod"])),
                                        Text(
                                          "[YYYYMM]",
                                          style: TextStyle(
                                              fontSize: SizeDefine.labelSize1),
                                        )
                                      ],
                                    ),
                                    Divider(
                                      thickness: 1,
                                    ),
                                    Wrap(
                                      spacing: Get.width * 0.01,
                                      runSpacing: 05,
                                      crossAxisAlignment:
                                          WrapCrossAlignment.end,
                                      children: [
                                        InputFields.formField1(
                                            hintTxt: "Cheque No",
                                            width: 0.083,
                                            controller: chequeNoCtrl),
                                        DateWithThreeTextField(
                                          title: "Chq Dt",
                                          widthRation: 0.084,
                                          mainTextController: chqDateCtrl,
                                          isEnable:
                                              controller.bookingNoLeaveData ==
                                                  null,
                                        ),
                                        InputFields.numbers(
                                            hintTxt: "Chq Amt",
                                            width: 0.083,
                                            controller: chequeAmtCtrl),
                                        InputFields.formField1(
                                            hintTxt: "Bank",
                                            width: 0.27,
                                            controller: bankCtrl),
                                        InputFields.formField1(
                                            hintTxt: "Chq Recd By",
                                            width: 0.27,
                                            controller: chequeRecByCtrl),
                                        DateWithThreeTextField(
                                          title: "Recd On",
                                          widthRation: 0.27,
                                          mainTextController: chequeRecOnCtrl,
                                          isEnable:
                                              controller.bookingNoLeaveData ==
                                                  null,
                                        ),
                                        InputFields.formField1(
                                            hintTxt: "Remarks",
                                            width: 0.27,
                                            controller: remarkCtrl),
                                        FormButtonWrapper(
                                          btnText: "Add",
                                          callback: () {
                                            var listMap = {
                                              "chqNo": chequeNoCtrl.text,
                                              "chqDate": chqDateCtrl.text
                                                  .fromdMyToyMd(),
                                              "chqAmount": double.parse(
                                                  chequeAmtCtrl.text),
                                              "bankName": bankCtrl.text,
                                              "chequeReceivedBy":
                                                  chequeRecByCtrl.text,
                                              "chequeReceivedOn":
                                                  chequeRecOnCtrl.text
                                                      .fromdMyToyMd(),
                                              "remarks": remarkCtrl.text,
                                              "chequeId": null,
                                              "rowNo": listdata.length + 1
                                            };
                                            if (listdata.contains(listMap)) {
                                              LoadingDialog.callErrorMessage1(
                                                  msg:
                                                      "Duplicate Cheque. cannot add");
                                            } else {
                                              listdata.add(listMap);
                                              listdata.refresh();
                                            }
                                          },
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Expanded(
                                      child: Container(
                                          color: Colors.grey[100],
                                          child: Obx(() => DataGridShowOnlyKeys(
                                              mapData: listdata.value))),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        FormButtonWrapper(
                                          btnText: "Save",
                                          callback: () async {
                                            await controller
                                                .savePDC(listdata.value);
                                            chequeNoCtrl.text = "";
                                            chqDateCtrl.text = "";
                                            chequeAmtCtrl.text = "";
                                            bankCtrl.text = "";
                                            chequeRecByCtrl.text = "";
                                            chequeRecOnCtrl.text = "";
                                            remarkCtrl.text = "";
                                            listdata.clear();
                                            listdata.refresh();
                                          },
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        FormButtonWrapper(
                                          btnText: "Clear",
                                          callback: () {
                                            chequeNoCtrl.text = "";
                                            chqDateCtrl.text = "";
                                            chequeAmtCtrl.text = "";
                                            bankCtrl.text = "";
                                            chequeRecByCtrl.text = "";
                                            chequeRecOnCtrl.text = "";
                                            remarkCtrl.text = "";
                                            listdata.clear();
                                            listdata.refresh();
                                          },
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ));
                        });
                  },
                ),
              ],
            )
          ],
        )
      ],
    );
  }
}

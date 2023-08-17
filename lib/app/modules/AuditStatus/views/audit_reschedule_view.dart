import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/modules/AuditStatus/bindings/audi_status_show_reshdule.dart';
import 'package:bms_scheduling/app/modules/AuditStatus/bindings/audit_status_cancel_deals.dart';
import 'package:bms_scheduling/app/modules/AuditStatus/controllers/audit_status_controller.dart';
import 'package:bms_scheduling/app/providers/extensions/string_extensions.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:bms_scheduling/widgets/PlutoGrid/pluto_grid.dart';

import '../../../controller/HomeController.dart';
import '../bindings/audi_status_eshowcancel.dart';

class AuditReschdule extends StatelessWidget {
  // AuditCanellation({super.key, required this.cancelNumber, required this.cancelMonth});
  // final int cancelNumber;
  // final int cancelMonth;
  const AuditReschdule({super.key, required this.controller});
  final AuditStatusController controller;

  @override
  Widget build(BuildContext context) {
    AuditStatusShowReschdule data = controller.showReschduleData!.first;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            margin: EdgeInsets.all(8),
            // decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            child: Container(
              width: Get.width,
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                alignment: WrapAlignment.start,
                spacing: Get.width * 0.01,
                runSpacing: 5,
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  DropDownField.formDropDown1WidthMap(controller.locations.value, (value) {
                    // controller.selectedLocation = value;
                    // controller.getChannel(value.key);
                  }, "Location", 0.24, isEnable: true, selected: DropDownValue(key: data.locationCode, value: data.locationName)),
                  DropDownField.formDropDown1WidthMap(controller.channels.value, (value) {
                    // controller.selectedChannel = value;
                  }, "Channel", 0.24, isEnable: true, selected: DropDownValue(key: data.channelCode, value: data.channelName)),
                  SizedBox(
                      width: Get.width * 0.24,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DateWithThreeTextField(
                              widthRation: 0.115,
                              title: "FPC Eff. Dt.",
                              mainTextController: TextEditingController(text: data.bookingEffectiveDate?.fromyMdTodMy())),
                          DateWithThreeTextField(
                              widthRation: 0.115,
                              title: "Resch Dt.",
                              onFocusChange: (value) {},
                              mainTextController: TextEditingController(text: data.rescheduledate?.fromyMdTodMy())),
                        ],
                      )),
                  InputFields.formField1(hintTxt: "Ref No", width: 0.24, controller: TextEditingController(text: data.rescheduleReferenceNumber)),
                  Container(
                    width: Get.width * 0.24,
                    child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      DateWithThreeTextField(
                          widthRation: 0.115,
                          title: "Ref Date",
                          onFocusChange: (value) {},
                          mainTextController: TextEditingController(text: data.bookingEffectiveDate?.split("T")[0].fromyMdTodMy())),
                      InputFields.formField1(
                          hintTxt: "Booking No", width: 0.115, isEnable: false, controller: TextEditingController(text: data.bookingNumber)),
                    ]),
                  ),
                  InputFields.formField1(hintTxt: "Deal No", isEnable: false, width: 0.24, controller: TextEditingController(text: data.dealNo)),
                  SizedBox(
                      width: Get.width * 0.24,
                      child: Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.start, children: [
                        InputFields.formField1(
                            isEnable: false,
                            width: 0.14,
                            hintTxt: "Reschedule No",
                            controller: TextEditingController(text: data.rescheduleMonth.toString())),
                        InputFields.formField1(
                            isEnable: false, width: 0.09, hintTxt: "", controller: TextEditingController(text: data.rescheduleNumber.toString())),
                      ])),
                  DropDownField.formDropDown1WidthMap([], (value) {
                    // controller.selectedChannel = value;
                  }, "Client", 0.24, isEnable: false, selected: DropDownValue(key: data.clientCode, value: data.clientName)),
                  DropDownField.formDropDown1WidthMap([], (value) {
                    // controller.selectedChannel = value;
                  }, "Agency", 0.24, isEnable: false, selected: DropDownValue(key: data.agencyCode, value: data.agencyName)),
                  DropDownField.formDropDown1WidthMap([DropDownValue(key: data.brandCode, value: data.brandName)], (value) {
                    // controller.selectedChannel = value;
                  }, "Brand", 0.24, selected: DropDownValue(key: data.brandCode, value: data.brandName)),
                  InkWell(
                    onTap: () {},
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_box_outline_blank_outlined),
                        Text("Select All"),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [Text("Reschedule Details"), Text("Booking Details")],
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: BorderDirectional(
                    start: BorderSide(color: Colors.grey[400]!),
                    end: BorderSide(color: Colors.grey[400]!),
                    top: BorderSide.none,
                    bottom: BorderSide(color: Colors.grey[400]!),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: Get.width * .38,
                    child: GetBuilder<AuditStatusController>(
                        init: controller,
                        id: "cancelData",
                        builder: (cancelDatactrl) {
                          return Container(
                            child: DataGridShowOnlyKeys(
                                onRowChecked: (rowcheckEvent) {},
                                hideCode: false,
                                exportFileName: "Audit Reschedule",
                                dateFormatKeys: ["auditedon"],
                                hideKeys: ["channelcode", "locationcode", "dealRowNumber"],
                                rowCheckColor: Colors.white,
                                onload: (loadEvent) {},
                                colorCallback: (rowEvent) {
                                  if (controller.auditStatusReschduleDisplay?.lstReshedule?[rowEvent.rowIdx].audited == null) {
                                    return Color(0xFF96FF96);
                                  } else if ((controller.auditStatusReschduleDisplay?.lstReshedule?[rowEvent.rowIdx].audited ?? 0) <
                                      (controller.auditStatusReschduleDisplay?.lstReshedule?[rowEvent.rowIdx].totalspots ?? 0)) {
                                    return Color(0xFFFF9696);
                                  }

                                  return Colors.white;
                                },
                                checkRow: true,
                                checkRowKey: "auditStatus",
                                hideCheckKeysValue: true,
                                actionIcon: Icons.check_box_outlined,
                                mapData: controller.auditStatusReschduleDisplay?.lstReshedule?.map((e) => e.toJson()).toList() ?? []),
                          );
                        }),
                  ),
                  SizedBox(
                    width: Get.width * .38,
                    child: GetBuilder<AuditStatusController>(
                        init: controller,
                        id: "cancelData",
                        builder: (cancelDatactrl) {
                          return Container(
                            child: DataGridShowOnlyKeys(
                                onRowChecked: (rowcheckEvent) {},
                                hideCode: false,
                                exportFileName: "Audit Cancellation",
                                hideKeys: ["channelcode", "locationcode", "dealRowNumber"],
                                rowCheckColor: Colors.white,
                                formatDate: false,
                                dateFormatKeys: ["auditedon"],
                                onload: (loadEvent) {},
                                hideCheckKeysValue: true,
                                actionIconKey: {"audited": Icons.check_box_rounded, "requested": Icons.check_box_rounded},
                                actionIcon: Icons.check_box_outlined,
                                mapData: controller.auditStatusReschduleDisplay?.lstBooking?.map((e) => e.toJson()).toList() ?? []),
                          );
                        }),
                  ),
                ],
              ),
            ),
          )),
          GetBuilder<HomeController>(
            id: "buttons",
            init: Get.find<HomeController>(),
            builder: (btncontroller) {
              return Container(
                height: 40,
                child: ButtonBar(
                  alignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var btn in btncontroller.buttons!)
                      FormButtonWrapper(
                        isEnabled: false,
                        btnText: btn["name"],
                        callback: null,
                      )
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

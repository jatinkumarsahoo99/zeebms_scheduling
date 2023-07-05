import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/modules/AuditStatus/controllers/audit_status_controller.dart';
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

class AuditCanellation extends StatelessWidget {
  AuditCanellation(
      {super.key, required this.cancelNumber, required this.cancelMonth});
  final int cancelNumber;
  final int cancelMonth;

  AuditStatusController controller = Get.find<AuditStatusController>();

  @override
  Widget build(BuildContext context) {
    AuditShowECancel data = controller.showECancelData!.first;
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
                  DropDownField.formDropDown1WidthMap(
                      controller.locations.value, (value) {
                    // controller.selectedLocation = value;
                    // controller.getChannel(value.key);
                  }, "Location", 0.24,
                      isEnable: false,
                      selected: DropDownValue(
                          key: data.locationCode, value: data.locationName)),
                  DropDownField.formDropDown1WidthMap(controller.channels.value,
                      (value) {
                    // controller.selectedChannel = value;
                  }, "Channel", 0.24,
                      isEnable: false,
                      selected: DropDownValue(
                          key: data.channelCode, value: data.channelName)),
                  SizedBox(
                      width: Get.width * 0.24,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DateWithThreeTextField(
                              widthRation: 0.115,
                              isEnable: false,
                              title: "Cancel Date",
                              mainTextController: TextEditingController(
                                  text: data.referenceDate)),
                          DateWithThreeTextField(
                              widthRation: 0.115,
                              isEnable: false,
                              title: "Eff. Date",
                              onFocusChange: (value) {},
                              mainTextController: TextEditingController(
                                  text: data.bookingEffectiveDate)),
                        ],
                      )),
                  InputFields.formField1(
                      hintTxt: "Reference",
                      width: 0.24,
                      isEnable: false,
                      controller:
                          TextEditingController(text: data.referenceNumber)),
                  InputFields.formField1(
                      hintTxt: "Booking No",
                      width: 0.24,
                      isEnable: false,
                      controller:
                          TextEditingController(text: data.bookingNumber)),
                  SizedBox(
                      width: Get.width * 0.24,
                      child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InputFields.formField1(
                                isEnable: false,
                                width: 0.10,
                                hintTxt: "Cancel No",
                                controller: TextEditingController(
                                    text: cancelMonth.toString())),
                            InputFields.formField1(
                                isEnable: false,
                                width: 0.14,
                                hintTxt: "",
                                controller: TextEditingController(
                                    text: cancelNumber.toString())),
                          ])),
                  InputFields.formField1(
                      width: 0.24,
                      isEnable: false,
                      hintTxt: "Client",
                      controller: TextEditingController(text: data.clientName)),
                  InputFields.formField1(
                      width: 0.24,
                      isEnable: false,
                      hintTxt: "Agency",
                      controller: TextEditingController(text: data.agencyName)),
                  InputFields.formField1(
                      width: 0.24,
                      isEnable: false,
                      hintTxt: "Brand",
                      controller: TextEditingController(text: data.brandName)),
                  InkWell(
                    onTap: () {},
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(true
                            ? Icons.check_box_outlined
                            : Icons.check_box_outline_blank_outlined),
                        Text("Select All Spots"),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Container(
              width: Get.width,
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: BorderDirectional(
                      start: BorderSide(color: Colors.grey[400]!),
                      end: BorderSide(color: Colors.grey[400]!),
                      top: BorderSide(color: Colors.grey[400]!),
                      bottom: BorderSide.none)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Total Spots: ${"--"}"),
                  Text("Total Duration: ${"--"}"),
                  Text("Total Amount: ${"--"}"),
                  Text("Total Val. Amount: ${"--"}"),
                ],
              ),
            ),
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
                children: [
                  GetBuilder<AuditStatusController>(
                      init: controller,
                      id: "cancelData",
                      builder: (cancelDatactrl) {
                        return Container(
                          width: Get.width * .70,
                          child: DataGridShowOnlyKeys(
                              onRowChecked: (rowcheckEvent) {},
                              hideCode: false,
                              hideKeys: ["channelcode", "locationcode"],
                              rowCheckColor: Colors.white,
                              onload: (loadEvent) {},
                              hideCheckKeysValue: true,
                              actionIconKey: {
                                "audited": Icons.check_box_rounded,
                                "requested": Icons.check_box_rounded
                              },
                              actionIcon: Icons.check_box_outlined,
                              mapData: controller
                                      .auditStatusCancelDeals?.displayRes
                                      ?.map((e) => e.toJson())
                                      .toList() ??
                                  []),
                        );
                      }),
                  SizedBox(
                    width: 3,
                  ),
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        FormButtonWrapper(
                          width: Get.width * 0.07,
                          btnText: "Import",
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        FormButtonWrapper(
                          width: Get.width * 0.07,
                          btnText: "OK",
                        ),
                      ],
                    ),
                  )
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

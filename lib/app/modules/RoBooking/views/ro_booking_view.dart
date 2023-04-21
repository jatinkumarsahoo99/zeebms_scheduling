import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/ro_booking_controller.dart';
import 'deal_view.dart';

class RoBookingView extends GetView<RoBookingController> {
  const RoBookingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[50],
        body: Column(
          children: [
            Row(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: Get.width * .83,
                      child: Wrap(
                        runSpacing: 5.0,
                        spacing: 5.0,
                        crossAxisAlignment: WrapCrossAlignment.end,
                        alignment: WrapAlignment.start,
                        children: [
                          DropDownField.formDropDown1WidthMap(
                              [], (value) => {}, "Location", 0.12),
                          DropDownField.formDropDown1WidthMap(
                              [], (value) => {}, "Channel", 0.12),
                          DateWithThreeTextField(
                              title: "FPC Eff. Dt.",
                              widthRation: 0.09,
                              mainTextController:
                                  controller.fpcEffectiveDateCtrl),
                          DateWithThreeTextField(
                              title: "Booking Date",
                              widthRation: 0.09,
                              mainTextController: controller.bookDateCtrl),
                          InputFields.formField1(
                              hintTxt: "Ref No",
                              controller: controller.refNoCtrl),
                          DateWithThreeTextField(
                              title: "Ref Date",
                              mainTextController:
                                  controller.fpcEffectiveDateCtrl),
                          DropDownField.formDropDown1WidthMap(
                              [], (value) => {}, "Rev Type", 0.12),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InputFields.formField1(
                                  hintTxt: "Booking No",
                                  width: 0.06,
                                  controller: controller.refNoCtrl),
                              InputFields.formField1(
                                  hintTxt: "",
                                  controller: controller.refNoCtrl,
                                  width: 0.03),
                              InputFields.formField1(
                                hintTxt: "",
                                controller: controller.refNoCtrl,
                                width: 0.06,
                              ),
                            ],
                          ),
                          DropDownField.formDropDown1WidthMap(
                              [], (value) => {}, "Client", 0.24),
                          DropDownField.formDropDown1WidthMap(
                              [], (value) => {}, "Deal", 0.12),
                          DropDownField.formDropDown1WidthMap(
                              [], (value) => {}, "Deal Type", 0.12,
                              isEnable: false),
                          DropDownField.formDropDown1WidthMap(
                              [], (value) => {}, "Agency", 0.24),
                          DropDownField.formDropDown1WidthMap(
                              [], (value) => {}, "Pay route", 0.12),
                          DropDownField.formDropDown1WidthMap(
                              [], (value) => {}, "Pay route", 0.12,
                              isEnable: false),
                          DropDownField.formDropDown1WidthMap(
                              [], (value) => {}, "Brand", 0.24),
                          ElevatedButton(
                              onPressed: () {}, child: Text("Search Tape")),
                          DropDownField.formDropDown1WidthMap(
                              [], (value) => {}, "Pay Mode", 0.12,
                              isEnable: false),
                          Wrap(
                            runAlignment: WrapAlignment.spaceBetween,
                            alignment: WrapAlignment.spaceEvenly,
                            runSpacing: 10,
                            spacing: 10,
                            children: [
                              DropDownField.formDropDown1WidthMap(
                                  [], (value) => {}, "Executive", 0.24,
                                  isEnable: false),
                              InputFields.formField1(
                                  hintTxt: "Tot Spots",
                                  controller: controller.refNoCtrl,
                                  width: 0.06),
                              InputFields.formField1(
                                  hintTxt: "Tot Dur",
                                  controller: controller.refNoCtrl,
                                  width: 0.06),
                              InputFields.formField1(
                                  hintTxt: "Tot Amt",
                                  controller: controller.refNoCtrl,
                                  width: 0.06),
                              InputFields.formField1(
                                  hintTxt: "Zone",
                                  controller: controller.refNoCtrl,
                                  width: 0.06),
                              InputFields.formField1(
                                  hintTxt: "Max Spend",
                                  controller: controller.refNoCtrl,
                                  width: 0.06),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 3,
                      direction: Axis.vertical,
                      children: [
                        InputFields.formField1(
                            hintTxt: "Prev. V Amt",
                            controller: controller.refNoCtrl,
                            width: 0.06),
                        InputFields.formField1(
                            hintTxt: "Prev. B Amt",
                            controller: controller.refNoCtrl,
                            width: 0.06),
                        InputFields.formField1(
                            showTitle: false,
                            hintTxt: "",
                            controller: controller.refNoCtrl,
                            width: 0.06),
                        DropDownField.formDropDown1WidthMap(
                            [], (value) => {}, "Sec Event", 0.12,
                            isEnable: false),
                        DropDownField.formDropDown1WidthMap(
                            [], (value) => {}, "Trigger At", 0.12,
                            isEnable: false),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Obx(
              () => CupertinoSlidingSegmentedControl(
                  groupValue: controller.currentTab.value,
                  children: controller.tabs.map((key, value) => MapEntry(
                      key,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          key,
                          style: TextStyle(color: CupertinoColors.black),
                        ),
                      ))),
                  onValueChanged: (value) {
                    controller.currentTab.value = value;
                    controller.controller.jumpToPage(controller.tabs.entries
                        .map((e) => e.key)
                        .toList()
                        .indexOf(value));
                  }),
            ),
            SizedBox(
              height: 5,
            ),
            Card(
              child: SizedBox(
                height: Get.height / 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: PageView.builder(
                      controller: controller.controller,
                      itemBuilder: (context, int) {
                        return controller
                            .tabs[controller.tabs.keys.toList()[int]];
                      }),
                ),
              ),
            ),
            Container(
              color: Colors.red,
              height: 50,
            )
          ],
        ));
  }
}

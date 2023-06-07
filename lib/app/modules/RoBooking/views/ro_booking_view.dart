import 'package:bms_scheduling/app/controller/HomeController.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
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
    return GetBuilder<RoBookingController>(
        init: controller,
        id: "init",
        builder: (controller) {
          if (controller.roBookingInitData == null) {
            return Center(child: CircularProgressIndicator());
          }
          return Scaffold(
              backgroundColor: Colors.grey[50],
              body: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: Get.width * .84,
                            child: Wrap(
                              runSpacing: 5.0,
                              spacing: Get.width * .01,
                              crossAxisAlignment: WrapCrossAlignment.end,
                              alignment: WrapAlignment.start,
                              children: [
                                DropDownField.formDropDown1WidthMap(
                                    controller.roBookingInitData!.lstLocation!
                                        .map((e) => DropDownValue(key: e.locationCode, value: e.locationName))
                                        .toList(), (value) {
                                  controller.selectedLocation = value;
                                  controller.getChannel(value.key);
                                }, "Location", 0.11),
                                Obx(
                                  () => DropDownField.formDropDown1WidthMap(controller.channels.value, (value) {
                                    controller.selectedChannel = value;
                                  }, "Channel", 0.23),
                                ),
                                DateWithThreeTextField(
                                  title: "FPC Eff. Dt.",
                                  widthRation: 0.11,
                                  mainTextController: controller.fpcEffectiveDateCtrl,
                                  onFocusChange: (date) {
                                    controller.effDtLeave();
                                  },
                                ),
                                DateWithThreeTextField(title: "Booking Date", widthRation: 0.11, mainTextController: controller.bookDateCtrl),
                                InputFields.formField1(
                                  hintTxt: "Ref No",
                                  controller: controller.refNoCtrl,
                                  width: 0.11,
                                ),
                                DateWithThreeTextField(title: "Ref Date", widthRation: 0.11, mainTextController: controller.fpcEffectiveDateCtrl),
                                DropDownField.formDropDown1WidthMap([], (value) => {}, "Rev Type", 0.11),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InputFields.formField1(hintTxt: "Booking No", width: 0.09, controller: controller.bookingMonthCtrl),
                                    InputFields.formField1(hintTxt: "", controller: controller.bookingNoCtrl, width: 0.06),
                                    InputFields.formField1(
                                      hintTxt: "",
                                      controller: controller.bookingNoTrailCtrl,
                                      width: 0.08,
                                    ),
                                  ],
                                ),
                                Obx(
                                  () => DropDownField.formDropDown1WidthMap(controller.clients.value, (value) {
                                    controller.clientLeave(value.key);
                                  }, "Client", 0.23),
                                ),
                                DropDownField.formDropDown1WidthMap([], (value) => {}, "Deal", 0.11),
                                DropDownField.formDropDown1WidthMap([], (value) => {}, "Deal Type", 0.11, isEnable: false),
                                Obx(
                                  () => DropDownField.formDropDown1WidthMap(controller.agencies.value, (value) => {}, "Agency", 0.23),
                                ),
                                DropDownField.formDropDown1WidthMap([], (value) => {}, "Pay route", 0.11),
                                DropDownField.formDropDown1WidthMap([], (value) => {}, "Brand", 0.23),
                                SizedBox(
                                  width: Get.width * 0.11,
                                  child: ElevatedButton(onPressed: () {}, child: Text("Search Tape")),
                                ),
                                DropDownField.formDropDown1WidthMap([], (value) => {}, "Pay Mode", 0.11, isEnable: false),
                                Wrap(
                                  runAlignment: WrapAlignment.spaceBetween,
                                  alignment: WrapAlignment.spaceEvenly,
                                  runSpacing: 5.0,
                                  spacing: Get.width * .01,
                                  children: [
                                    DropDownField.formDropDown1WidthMap([], (value) => {}, "Executive", 0.23, isEnable: false),
                                    InputFields.formField1(hintTxt: "Tot Spots", controller: controller.totSpotCtrl, width: 0.11),
                                    InputFields.formField1(hintTxt: "Tot Dur", controller: controller.totDurCtrl, width: 0.11),
                                    InputFields.formField1(hintTxt: "Tot Amt", controller: controller.totAmtCtrl, width: 0.11),
                                    InputFields.formField1(hintTxt: "Zone", controller: controller.zoneCtrl, width: 0.11),
                                    InputFields.formField1(hintTxt: "Max Spend", controller: controller.maxspendCtrl, width: 0.11),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: Get.width * 0.14,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Wrap(
                              spacing: 3,
                              runSpacing: 5.0,
                              children: [
                                InputFields.formField1(hintTxt: "Prev. V Amt", controller: controller.refNoCtrl, width: 0.06),
                                InputFields.formField1(hintTxt: "Prev. B Amt", controller: controller.refNoCtrl, width: 0.06),
                                InputFields.formField1(hintTxt: "", controller: controller.refNoCtrl, width: 0.06),
                                DropDownField.formDropDown1WidthMap([], (value) => {}, "Sec Event", 0.12, isEnable: false),
                                DropDownField.formDropDown1WidthMap([], (value) => {}, "Trigger At", 0.12, isEnable: false),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
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
                          controller.controller.jumpToPage(controller.tabs.entries.map((e) => e.key).toList().indexOf(value));
                        }),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                      child: Container(
                          child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PageView.builder(
                          itemCount: controller.tabs.length,
                          physics: NeverScrollableScrollPhysics(),
                          controller: controller.controller,
                          itemBuilder: (context, int) {
                            return controller.tabs[controller.tabs.keys.toList()[int]];
                          }),
                    ),
                  ))),
                  GetBuilder<HomeController>(
                      id: "buttons",
                      init: Get.find<HomeController>(),
                      builder: (btncontroller) {
                        /* PermissionModel formPermissions = Get.find<MainController>()
                      .permissionList!
                      .lastWhere((element) {
                    return element.appFormName == "frmSegmentsDetails";
                  });*/

                        return btncontroller.buttons == null
                            ? Container()
                            : Card(
                                margin: EdgeInsets.fromLTRB(4, 4, 4, 0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                                ),
                                child: Container(
                                  width: Get.width,
                                  padding: const EdgeInsets.all(8.0),
                                  child: Wrap(
                                    spacing: 10,
                                    // buttonHeight: 20,
                                    alignment: WrapAlignment.start,
                                    // mainAxisSize: MainAxisSize.max,
                                    // pa
                                    children: [
                                      for (var btn in btncontroller.buttons!)
                                        btn["name"] == "Save"
                                            ? FormButtonWrapper(
                                                btnText: btn["name"],
                                                // isEnabled: btn['isDisabled'],
                                                callback: () {},
                                              )
                                            : btn["name"] == "Clear"
                                                ? FormButtonWrapper(
                                                    btnText: btn["name"],

                                                    // isEnabled: btn['isDisabled'],
                                                    callback: () {
                                                      btncontroller.clearPage1();
                                                    },
                                                  )
                                                : FormButtonWrapper(
                                                    btnText: btn["name"],
                                                    // isEnabled: btn['isDisabled'],
                                                    callback: null,
                                                  ),
                                    ],
                                  ),
                                ),
                              );
                      }),
                ],
              ));
        });
  }
}

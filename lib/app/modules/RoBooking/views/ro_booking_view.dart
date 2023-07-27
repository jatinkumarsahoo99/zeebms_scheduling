import 'package:bms_scheduling/app/controller/ConnectorControl.dart';
import 'package:bms_scheduling/app/controller/HomeController.dart';
import 'package:bms_scheduling/app/data/DropDownValue.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/DateTime/DateWithThreeTextField.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../CommonDocs/controllers/common_docs_controller.dart';
import '../../CommonDocs/views/common_docs_view.dart';
import '../controllers/ro_booking_controller.dart';
import 'deal_view.dart';

class RoBookingView extends StatelessWidget {
  RoBookingView({Key? key}) : super(key: key);
  var controller = Get.put<RoBookingController>(
    RoBookingController(),
  );

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
                            child: FocusTraversalGroup(
                              policy: OrderedTraversalPolicy(),
                              child: Wrap(
                                runSpacing: 5.0,
                                spacing: Get.width * .01,
                                crossAxisAlignment: WrapCrossAlignment.end,
                                alignment: WrapAlignment.start,
                                children: [
                                  FocusTraversalOrder(
                                    order: NumericFocusOrder(1),
                                    child: DropDownField.formDropDown1WidthMap(
                                      controller.roBookingInitData!.lstLocation!
                                          .map((e) => DropDownValue(key: e.locationCode, value: e.locationName))
                                          .toList(),
                                      (value) {
                                        controller.selectedLocation = value;
                                        controller.getChannel(value.key);
                                      },
                                      "Location",
                                      0.11,
                                      selected: controller.selectedLocation,
                                      isEnable: controller.bookingNoLeaveData == null,
                                    ),
                                  ),
                                  FocusTraversalOrder(
                                    order: NumericFocusOrder(2),
                                    child: Obx(
                                      () => DropDownField.formDropDown1WidthMap(
                                        controller.channels.value,
                                        (value) {
                                          controller.selectedChannel = value;
                                        },
                                        "Channel",
                                        0.23,
                                        selected: controller.selectedChannel,
                                        isEnable: controller.bookingNoLeaveData == null,
                                      ),
                                    ),
                                  ),
                                  FocusTraversalOrder(
                                    order: NumericFocusOrder(3),
                                    child: DateWithThreeTextField(
                                      title: "FPC Eff. Dt.",
                                      isEnable: controller.bookingNoLeaveData == null,
                                      widthRation: 0.11,
                                      mainTextController: controller.fpcEffectiveDateCtrl,
                                      onFocusChange: (date) {
                                        controller.effDtLeave();
                                      },
                                    ),
                                  ),
                                  FocusTraversalOrder(
                                    order: NumericFocusOrder(4),
                                    child: DateWithThreeTextField(
                                      title: "Booking Date",
                                      widthRation: 0.11,
                                      mainTextController: controller.bookDateCtrl,
                                      isEnable: controller.bookingNoLeaveData == null,
                                    ),
                                  ),
                                  FocusTraversalOrder(
                                    order: NumericFocusOrder(6),
                                    child: InputFields.formField1(
                                      focusNode: controller.refrenceFocus,
                                      hintTxt: "Ref No",
                                      controller: controller.refNoCtrl,
                                      width: 0.11,
                                      isEnable: controller.bookingNoLeaveData == null,
                                    ),
                                  ),
                                  FocusTraversalOrder(
                                    order: NumericFocusOrder(13),
                                    child: DateWithThreeTextField(
                                      title: "",
                                      widthRation: 0.11,
                                      mainTextController: controller.fpcEffectiveDateCtrl,
                                      isEnable: controller.bookingNoLeaveData == null,
                                    ),
                                  ),
                                  DropDownField.formDropDown1WidthMap([], (value) => {}, "Rev Type", 0.11,
                                      isEnable: controller.bookingNoLeaveData == null && controller.agencyLeaveData == null,
                                      selected: controller.bookingNoLeaveData != null
                                          ? DropDownValue(
                                              key: controller.bookingNoLeaveData!.revenueType ?? controller.dealNoLeaveData?.strRevenueTypeCode ?? "",
                                              value: controller.bookingNoLeaveData!.revenueType ?? "")
                                          : null),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InputFields.formField1(
                                        hintTxt: "Booking No",
                                        width: 0.09,
                                        controller: controller.bookingMonthCtrl,
                                        isEnable: false,
                                      ),
                                      FocusTraversalOrder(
                                        order: NumericFocusOrder(5),
                                        child: InputFields.formField1(
                                            hintTxt: "", controller: controller.bookingNoCtrl, focusNode: controller.bookingNoFocus, width: 0.06),
                                      ),
                                      InputFields.formField1(
                                        hintTxt: "",
                                        controller: controller.bookingNoTrailCtrl,
                                        width: 0.08,
                                        isEnable: controller.bookingNoLeaveData == null && controller.agencyLeaveData == null,
                                      ),
                                    ],
                                  ),
                                  FocusTraversalOrder(
                                    order: NumericFocusOrder(7),
                                    child: Obx(
                                      () => DropDownField.formDropDown1WidthMap(
                                        controller.bookingNoLeaveData != null
                                            ? controller.bookingNoLeaveData?.lstClientAgency
                                                    ?.map((e) => DropDownValue(value: e.clientname, key: e.clientcode))
                                                    .toList() ??
                                                []
                                            : controller.clients.value,
                                        (value) {
                                          controller.selectedClient = value;
                                          controller.clientLeave(value.key);
                                        },
                                        "Client",
                                        0.23,
                                        inkWellFocusNode: controller.clientFocus,
                                        selected: controller.selectedClient,
                                        isEnable: controller.bookingNoLeaveData == null,
                                      ),
                                    ),
                                  ),
                                  FocusTraversalOrder(
                                    order: NumericFocusOrder(9),
                                    child: DropDownField.formDropDown1WidthMap(
                                        controller.agencyLeaveData?.lstDealNumber
                                                ?.map((e) => DropDownValue(
                                                      key: e.dealNumber,
                                                      value: e.dealNumber,
                                                    ))
                                                .toList() ??
                                            [], (value) {
                                      controller.selectedDeal = value;

                                      controller.dealNoLeave();
                                    }, "Deal No", 0.11,
                                        inkWellFocusNode: controller.dealNoFocus,
                                        isEnable: controller.bookingNoLeaveData == null,
                                        selected: controller.selectedDeal),
                                  ),
                                  InputFields.formField1(
                                    hintTxt: "Deal Type",
                                    isEnable: controller.bookingNoLeaveData == null && controller.agencyLeaveData == null,
                                    controller: TextEditingController(
                                        text: controller.bookingNoLeaveData?.dealType ?? controller.dealNoLeaveData?.dealType ?? ""),
                                    onchanged: (value) {},
                                    width: 0.11,
                                  ),
                                  FocusTraversalOrder(
                                    order: NumericFocusOrder(8),
                                    child: Obx(
                                      () => DropDownField.formDropDown1WidthMap(
                                          controller.agencies.value, (value) => {controller.agencyLeave(value.key)}, "Agency", 0.23,
                                          isEnable: controller.bookingNoLeaveData == null,
                                          inkWellFocusNode: controller.agencyFocus,
                                          selected: controller.selectedAgnecy),
                                    ),
                                  ),
                                  InputFields.formField1(
                                    hintTxt: "Pay route",
                                    isEnable: controller.bookingNoLeaveData == null && controller.agencyLeaveData == null,
                                    controller: controller.payrouteCtrl,
                                    onchanged: (value) {},
                                    width: 0.11,
                                  ),

                                  FocusTraversalOrder(
                                    order: NumericFocusOrder(10),
                                    child: DropDownField.formDropDown1WidthMap(
                                        controller.dealNoLeaveData?.lstBrand
                                                ?.map((e) => DropDownValue(key: e.brandcode, value: e.brandname))
                                                .toList() ??
                                            [],
                                        (value) => {
                                              controller.selectedBrand = value,
                                              controller.brandLeave(
                                                value.key,
                                              )
                                            },
                                        "Brand",
                                        0.23,
                                        inkWellFocusNode: controller.brandFocus,
                                        isEnable: controller.bookingNoLeaveData == null,
                                        selected: controller.selectedBrand),
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.11,
                                    child: FormButtonWrapper(
                                        btnText: "Search Tape",
                                        iconDataM: Icons.search_rounded,
                                        callback: () {
                                          var data = Rxn<List>();
                                          FocusNode tapeIdFocus = FocusNode();
                                          TextEditingController tapeIdCtrl = TextEditingController();

                                          tapeIdFocus.addListener(() {
                                            if (!tapeIdFocus.hasFocus && tapeIdCtrl.text.isNotEmpty) {
                                              Get.find<ConnectorControl>().GETMETHODCALL(
                                                api: ApiFactory.RO_BOOKING_BOOKING_SEARCH_TAPE_ID(tapeIdCtrl.text),
                                                fun: (apidata) {
                                                  if (apidata is Map && apidata.containsKey("searchTapeId") && apidata["searchTapeId"] is Map) {
                                                    data.value = apidata["searchTapeId"]["lstSearchTapeId"];
                                                  }
                                                },
                                              );
                                            }
                                          });

                                          Get.defaultDialog(
                                            radius: 05,
                                            title: "",
                                            content: Container(
                                              width: Get.width * 0.60,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      SizedBox(),
                                                      InputFields.formField1(
                                                        hintTxt: "Tape ID",
                                                        focusNode: tapeIdFocus,
                                                        controller: tapeIdCtrl,
                                                        width: 0.11,
                                                      ),
                                                      FormButtonWrapper(
                                                        btnText: "Back To Booking",
                                                        callback: () {
                                                          Get.back();
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                  Container(
                                                      height: Get.height * 0.30,
                                                      padding: EdgeInsets.only(top: 4),
                                                      child: Obx(() => data.value == null
                                                          ? Container(
                                                              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
                                                            )
                                                          : DataGridShowOnlyKeys(
                                                              mapData: data.value!,
                                                              formatDate: false,
                                                            )))
                                                ],
                                              ),
                                            ),
                                          );
                                        }),
                                  ),

                                  InputFields.formField1(
                                    hintTxt: "Pay Mode",
                                    isEnable: controller.bookingNoLeaveData == null && controller.agencyLeaveData == null,
                                    controller: controller.payModeCtrl,
                                    onchanged: (value) {},
                                    width: 0.11,
                                  ),
                                  // DropDownField.formDropDown1WidthMap([], (value) => {}, "Pay Mode", 0.11,
                                  //     isEnable: controller.bookingNoLeaveData == null,
                                  //     selected: controller.bookingNoLeaveData != null
                                  //         ? DropDownValue(
                                  //             key: controller.bookingNoLeaveData!.payMode ?? "", value: controller.bookingNoLeaveData!.payMode ?? "")
                                  //         : null),
                                  Wrap(
                                    runAlignment: WrapAlignment.spaceBetween,
                                    alignment: WrapAlignment.spaceEvenly,
                                    runSpacing: 5.0,
                                    spacing: Get.width * .01,
                                    children: [
                                      DropDownField.formDropDown1WidthMap(
                                          (controller.roBookingInitData?.lstExecutives
                                                  ?.map((e) => DropDownValue(key: e.personnelCode, value: e.personnelName))
                                                  .toList()) ??
                                              [],
                                          (value) => {},
                                          "Executive",
                                          0.23,
                                          isEnable: controller.bookingNoLeaveData == null,
                                          selected: controller.selectedExecutive),
                                      InputFields.formField1(
                                        hintTxt: "Tot Spots",
                                        controller: controller.totSpotCtrl,
                                        width: 0.11,
                                        isEnable: controller.bookingNoLeaveData == null && controller.agencyLeaveData == null,
                                      ),
                                      InputFields.formField1(
                                        hintTxt: "Tot Dur",
                                        controller: controller.totDurCtrl,
                                        width: 0.11,
                                        isEnable: controller.bookingNoLeaveData == null && controller.agencyLeaveData == null,
                                      ),
                                      InputFields.formField1(
                                        hintTxt: "Tot Amt",
                                        controller: controller.totAmtCtrl,
                                        width: 0.11,
                                        isEnable: controller.bookingNoLeaveData == null && controller.agencyLeaveData == null,
                                      ),
                                      InputFields.formField1(
                                        hintTxt: "Zone",
                                        controller: controller.zoneCtrl,
                                        width: 0.11,
                                        isEnable: controller.bookingNoLeaveData == null && controller.agencyLeaveData == null,
                                      ),
                                      InputFields.formField1(
                                        hintTxt: "Max Spend",
                                        controller: controller.maxspendCtrl,
                                        width: 0.11,
                                        isEnable: controller.bookingNoLeaveData == null && controller.agencyLeaveData == null,
                                      ),
                                    ],
                                  )
                                ],
                              ),
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
                                InputFields.formField1(
                                    isEnable: false,
                                    hintTxt: "Prev. V Amt",
                                    controller: TextEditingController(
                                        text:
                                            controller.bookingNoLeaveData?.previousValAmount ?? controller.dealNoLeaveData?.previousValAmount ?? ""),
                                    width: 0.06),
                                InputFields.formField1(
                                    isEnable: false,
                                    hintTxt: "Prev. B Amt",
                                    controller: TextEditingController(
                                        text: controller.bookingNoLeaveData?.previousValAmount ??
                                            controller.dealNoLeaveData?.previousBookedAmount ??
                                            ""),
                                    width: 0.06),
                                InputFields.formField1(
                                    isEnable: false,
                                    hintTxt: "",
                                    controller: TextEditingController(
                                        text: controller.bookingNoLeaveData?.payroutecode ?? controller.agencyLeaveData?.payRouteCode ?? ""),
                                    width: 0.06),
                                DropDownField.formDropDown1WidthMap(
                                  controller.roBookingInitData?.lstsecondaryevents
                                          ?.map((e) => DropDownValue(key: (e.secondaryeventid ?? "").toString(), value: e.secondaryevent))
                                          .toList() ??
                                      [],
                                  (value) {},
                                  "Sec Event",
                                  0.12,
                                  isEnable: controller.bookingNoLeaveData == null,
                                ),
                                DropDownField.formDropDown1WidthMap(
                                  controller.roBookingInitData?.lstSecondaryEventTrigger
                                          ?.map((e) => DropDownValue(key: (e.secondaryeventid ?? "").toString(), value: e.secondaryevent))
                                          .toList() ??
                                      [],
                                  (value) => {},
                                  "Trigger At",
                                  0.12,
                                  isEnable: controller.bookingNoLeaveData == null,
                                ),
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
                          controller.pagecontroller.jumpToPage(controller.tabs.entries.map((e) => e.key).toList().indexOf(value));
                        }),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Expanded(
                      child: Container(
                          child: Card(
                    child: GetBuilder<RoBookingController>(
                        id: "pageView",
                        builder: (controller) => controller.currentTab.value == null
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: PageView.builder(
                                    itemCount: controller.tabs.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    controller: controller.pagecontroller,
                                    itemBuilder: (context, int) {
                                      return controller.tabs[controller.tabs.keys.toList()[int]];
                                    }),
                              )),
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
                                        btn["name"] == "Docs"
                                            ? FormButtonWrapper(
                                                btnText: btn["name"],
                                                // isEnabled: btn['isDisabled'],
                                                callback: () {
                                                  Get.defaultDialog(
                                                    title: "Documents",
                                                    content: CommonDocsView(
                                                        documentKey:
                                                            "RObooking${controller.selectedLocation!.key}${controller.selectedChannel!.key}${controller.bookingMonthCtrl.text}${controller.bookingNoCtrl.text}"),
                                                  ).then((value) {
                                                    Get.delete<CommonDocsController>(tag: "commonDocs");
                                                  });
                                                },
                                              )
                                            : btn["name"] == "Save"
                                                ? FormButtonWrapper(
                                                    btnText: btn["name"],
                                                    // isEnabled: btn['isDisabled'],
                                                    callback: () {
                                                      controller.saveCheck();
                                                    },
                                                  )
                                                : btn["name"] == "Clear"
                                                    ? FormButtonWrapper(
                                                        btnText: btn["name"],

                                                        // isEnabled: btn['isDisabled'],
                                                        callback: () {
                                                          Get.delete<RoBookingController>();
                                                          Get.find<HomeController>().clearPage1();
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

  btnHanlder(btn) {
    switch (btn["name"]) {
      case "Docs":
        return FormButtonWrapper(
          btnText: btn["name"],
          // isEnabled: btn['isDisabled'],
          callback: () {
            Get.defaultDialog(
              title: "Documents",
              content: CommonDocsView(
                documentKey:
                    "RObooking${controller.selectedLocation!.key}${controller.selectedChannel!.key}${controller.bookingMonthCtrl.text}${controller.bookingNoCtrl.text}",
              ),
            ).then((value) {
              Get.delete<CommonDocsController>(tag: "commonDocs");
            });
          },
        );
      case "Save":
        return FormButtonWrapper(
          btnText: btn["name"],
          // isEnabled: btn['isDisabled'],
          callback: () {
            controller.saveCheck();
          },
        );
      case "Clear":
        return FormButtonWrapper(
          btnText: btn["name"],
          // isEnabled: btn['isDisabled'],
          callback: () {
            Get.delete<RoBookingController>();
            Get.find<HomeController>().clearPage1();
          },
        );
      default:
        return FormButtonWrapper(
          btnText: btn["name"],
          // isEnabled: btn['isDisabled'],
          callback: null,
        );
    }
  }
}

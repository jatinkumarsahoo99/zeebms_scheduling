import 'package:bms_scheduling/app/controller/HomeController.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/secondary_event_template_master_controller.dart';

class SecondaryEventTemplateMasterView extends GetView<SecondaryEventTemplateMasterController> {
  const SecondaryEventTemplateMasterView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        children: [
          Card(
            child: Container(
              width: Get.width,
              padding: const EdgeInsets.all(4.0),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.end,
                spacing: Get.width * 0.01,
                children: [
                  Obx(
                    () => DropDownField.formDropDown1WidthMap(controller.locations.value, (value) {
                      controller.selectedLocation = value;
                      controller.getChannel(value.key);
                    }, "Location", 0.18, selected: controller.selectedLocation),
                  ),
                  Obx(
                    () => DropDownField.formDropDown1WidthMap(controller.channels.value, (value) {
                      controller.selectedChannel = value;
                    }, "Channel", 0.18, selected: controller.selectedChannel),
                  ),
                  Obx(
                    () => DropDownField.formDropDownSearchAPI2(
                      GlobalKey(), Get.context!,
                      title: "Program",
                      url: ApiFactory.SecondaryEventTemplateMasterProgSearch,
                      parseKeyForKey: "ProgramCode",
                      parseKeyForValue: "ProgramName",
                      onchanged: (data) {
                        controller.selectedProgram.value = data;
                      },
                      selectedValue: controller.selectedProgram.value,

                      width: Get.width * 0.36,
                      // padding: const EdgeInsets.only()
                    ),
                  ),
                  FormButtonWrapper(
                    btnText: "...",
                    callback: () {
                      controller.getProgramPick();
                      // Get.defaultDialog(
                      //   title: "Documents",
                      //   content: CommonDocsView(
                      //       documentKey:
                      //           "RObooking${controller.selectedLocation!.key}${controller.selectedChannel!.key}${controller.bookingMonthCtrl.text}${controller.bookingNoCtrl.text}"),
                      // ).then((value) {
                      //   Get.delete<CommonDocsController>(tag: "commonDocs");
                      // });
                    },
                  ),
                  FormButtonWrapper(
                    btnText: "Copy From",
                    callback: () {
                      // Get.defaultDialog(
                      //   title: "Documents",
                      //   content: CommonDocsView(
                      //       documentKey:
                      //           "RObooking${controller.selectedLocation!.key}${controller.selectedChannel!.key}${controller.bookingMonthCtrl.text}${controller.bookingNoCtrl.text}"),
                      // ).then((value) {
                      //   Get.delete<CommonDocsController>(tag: "commonDocs");
                      // });
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      clipBehavior: Clip.hardEdge,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        child: DataGridShowOnlyKeys(mapData: []),
                      ),
                    ),
                  ),
                  Container(
                    width: Get.width * 0.45,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Wrap(
                              spacing: Get.width * 0.01,
                              crossAxisAlignment: WrapCrossAlignment.end,
                              runSpacing: 10,
                              children: [
                                DropDownField.formDropDown1WidthMap([], (value) => {}, "Event", 0.175),
                                InputFields.formField1(
                                  hintTxt: "TX Caption",
                                  controller: TextEditingController(),
                                  width: 0.175,
                                ),
                                InputFields.formField1(
                                  hintTxt: "TX Id",
                                  controller: TextEditingController(),
                                  width: 0.36,
                                ),
                                Row(
                                  children: ["First Segment", "Last Segment", "All Segments", "Pre Event", "Post Event", "My"]
                                      .map((e) => Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [Icon(Icons.check_box_outlined), Text(e)],
                                          ))
                                      .toList(),
                                ),
                                FormButtonWrapper(
                                  btnText: "Search",
                                  callback: () {
                                    // Get.defaultDialog(
                                    //   title: "Documents",
                                    //   content: CommonDocsView(
                                    //       documentKey:
                                    //           "RObooking${controller.selectedLocation!.key}${controller.selectedChannel!.key}${controller.bookingMonthCtrl.text}${controller.bookingNoCtrl.text}"),
                                    // ).then((value) {
                                    //   Get.delete<CommonDocsController>(tag: "commonDocs");
                                    // });
                                  },
                                ),
                                FormButtonWrapper(
                                  btnText: "Add",
                                  callback: () {
                                    // Get.defaultDialog(
                                    //   title: "Documents",
                                    //   content: CommonDocsView(
                                    //       documentKey:
                                    //           "RObooking${controller.selectedLocation!.key}${controller.selectedChannel!.key}${controller.bookingMonthCtrl.text}${controller.bookingNoCtrl.text}"),
                                    // ).then((value) {
                                    //   Get.delete<CommonDocsController>(tag: "commonDocs");
                                    // });
                                  },
                                ),
                                InputFields.formField1(
                                  hintTxt: "TX Id",
                                  isEnable: false,
                                  controller: TextEditingController(text: "00:00:00:00"),
                                ),
                              ],
                            ),
                            Container(
                                child: DataGridShowOnlyKeys(
                              mapData: [],
                            ))
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
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
                                FormButtonWrapper(
                                  btnText: btn["name"],
                                  // isEnabled: btn['isDisabled'],
                                  callback: () {
                                    // Get.defaultDialog(
                                    //   title: "Documents",
                                    //   content: CommonDocsView(
                                    //       documentKey:
                                    //           "RObooking${controller.selectedLocation!.key}${controller.selectedChannel!.key}${controller.bookingMonthCtrl.text}${controller.bookingNoCtrl.text}"),
                                    // ).then((value) {
                                    //   Get.delete<CommonDocsController>(tag: "commonDocs");
                                    // });
                                  },
                                ),
                            ],
                          ),
                        ),
                      );
              })
        ],
      ),
    );
  }
}

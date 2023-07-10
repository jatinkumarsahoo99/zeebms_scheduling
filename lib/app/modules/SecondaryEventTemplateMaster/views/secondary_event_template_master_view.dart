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
      body: Column(
        children: [
          Card(
            child: SizedBox(
              width: Get.width,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  spacing: Get.width * 0.01,
                  children: [
                    DropDownField.formDropDown1WidthMap([], (value) => {}, "Sponser Type", 0.18),
                    DropDownField.formDropDown1WidthMap([], (value) => {}, "Sponser Type", 0.18),
                    DropDownField.formDropDownSearchAPI2(
                      GlobalKey(), Get.context!,
                      title: "Program",
                      url: ApiFactory.AsrunImport_GetAsrunProgramList,
                      parseKeyForKey: "programCode",
                      parseKeyForValue: "programName",
                      onchanged: (data) {},

                      width: Get.width * 0.36,
                      // padding: const EdgeInsets.only()
                    ),
                    FormButtonWrapper(
                      btnText: "...",
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
          ),
          Row(
            children: [
              Container(
                width: Get.width / 2,
              ),
              Container(
                width: Get.width / 2,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Wrap(
                          spacing: Get.width * 0.01,
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
                            Wrap(
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
                              controller: TextEditingController(),
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
          )
        ],
      ),
    );
  }
}

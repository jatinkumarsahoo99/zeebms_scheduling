import 'package:bms_scheduling/app/controller/HomeController.dart';
import 'package:bms_scheduling/app/modules/SecondaryEventTemplateMaster/bindings/secondary_event_template_master_programs.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/app/providers/SizeDefine.dart';
import 'package:bms_scheduling/app/providers/Utils.dart';
import 'package:bms_scheduling/widgets/DataGridMultiCheckBox.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';
import 'package:bms_scheduling/app/providers/DataGridMenu.dart';
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
              child: Obx(
                () => Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  spacing: Get.width * 0.01,
                  children: [
                    Obx(
                      () => DropDownField.formDropDown1WidthMap(controller.locations.value, (value) {
                        controller.selectedLocation = value;
                        controller.getChannel(value.key);
                      }, "Location", 0.18, isEnable: controller.enableFields.value, selected: controller.selectedLocation),
                    ),
                    Obx(
                      () => DropDownField.formDropDown1WidthMap(controller.channels.value, (value) {
                        controller.selectedChannel = value;
                      }, "Channel", 0.18, isEnable: controller.enableFields.value, selected: controller.selectedChannel),
                    ),
                    Obx(
                      () => DropDownField.formDropDownSearchAPI2(
                        GlobalKey(), Get.context!,
                        title: "Program",
                        isEnable: controller.enableFields.value,
                        url: ApiFactory.SecondaryEventTemplateMasterProgSearch,
                        parseKeyForKey: "ProgramCode",
                        parseKeyForValue: "ProgramName",
                        onchanged: (data) {
                          controller.selectedProgram.value = data;
                          controller.getProgramLeave();
                        },
                        selectedValue: controller.selectedProgram.value,

                        width: Get.width * 0.36,
                        // padding: const EdgeInsets.only()
                      ),
                    ),
                    FormButtonWrapper(
                      btnText: "...",
                      isEnabled: controller.enableFields.value,
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
                        child: GetBuilder<SecondaryEventTemplateMasterController>(
                            id: "gridData",
                            builder: (controller) => DataGridMultiCheckBox(
                                  extraList: [
                                    SecondaryShowDialogModel("Delete", () {
                                      if (controller.programGrid?.currentRowIdx != null) {
                                        controller.gridPrograms.removeAt(controller.programGrid!.currentRowIdx!);
                                        controller.calculateRowNo();
                                        controller.update(["gridData"]);
                                      }
                                    }),
                                    SecondaryShowDialogModel("Copy", () {
                                      if (controller.programGrid?.currentRowIdx != null) {
                                        controller.copiedProgram = controller.gridPrograms[controller.programGrid!.currentRowIdx!];
                                      }
                                    }),
                                    SecondaryShowDialogModel("Cut", () {
                                      if (controller.programGrid?.currentRowIdx != null) {
                                        controller.copiedProgram = controller.gridPrograms[controller.programGrid!.currentRowIdx!];
                                      }
                                    }),
                                    SecondaryShowDialogModel("Paste", () {
                                      if (controller.programGrid?.currentRowIdx != null && controller.copiedProgram != null) {
                                        controller.gridPrograms.insert(controller.programGrid!.currentRowIdx!, controller.copiedProgram!);
                                        controller.calculateRowNo();
                                        controller.update(["gridData"]);
                                      }
                                    })
                                  ],
                                  onload: (event) {
                                    controller.programGrid = event.stateManager;
                                  },
                                  mapData: controller.gridPrograms.map((e) => e.toJson()).toList(),
                                  checkBoxes: ["firstSegment", "lastSegment", "allSegments", "preEvent", "postEvent"],
                                  onCheckBoxPress: (key, rowId) {
                                    switch (key) {
                                      case "firstSegment":
                                        controller.gridPrograms[rowId].firstSegment = !(controller.gridPrograms[rowId].firstSegment ?? false);
                                        break;
                                      case "lastSegment":
                                        controller.gridPrograms[rowId].lastSegment = !(controller.gridPrograms[rowId].lastSegment ?? false);
                                        break;
                                      case "allSegments":
                                        controller.gridPrograms[rowId].allSegments = !(controller.gridPrograms[rowId].allSegments ?? false);
                                        break;
                                      case "preEvent":
                                        controller.gridPrograms[rowId].preEvent = !(controller.gridPrograms[rowId].preEvent ?? false);
                                        break;
                                      case "postEvent":
                                        controller.gridPrograms[rowId].postEvent = !(controller.gridPrograms[rowId].postEvent ?? false);
                                        break;

                                      default:
                                    }
                                    controller.update(["gridData"]);
                                  },
                                )),
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
                                Obx(
                                  () => DropDownField.formDropDown1WidthMap(
                                      controller.events.value, (value) => {controller.selectedEvent = value}, "Event", 0.175,
                                      selected: controller.selectedEvent),
                                ),
                                InputFields.formField1(
                                  hintTxt: "TX Caption",
                                  controller: controller.txCaption,
                                  width: 0.175,
                                ),
                                InputFields.formField1(
                                  hintTxt: "TX Id",
                                  controller: controller.txID,
                                  focusNode: controller.txIdFocusNode,
                                  width: 0.36,
                                ),
                                Row(
                                  children: controller.checkBoxes.value.entries
                                      .map((e) => Obx(() => Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Checkbox(
                                                  value: controller.checkBoxes[e.key],
                                                  onChanged: (value) {
                                                    controller.checkBoxes[e.key] = value ?? false;
                                                    controller.checkBoxes.refresh();
                                                  }),
                                              Text(e.key, style: TextStyle(fontSize: SizeDefine.labelSize1 + 1))
                                            ],
                                          )))
                                      .toList(),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Obx(() => Checkbox(
                                        value: controller.mine.value,
                                        onChanged: (value) {
                                          controller.mine.value = value ?? false;
                                        })),
                                    Text("My")
                                  ],
                                ),
                                FormButtonWrapper(
                                  btnText: "Search",
                                  callback: () {
                                    controller.postFastSearch();
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
                                    if (controller.searchGrid?.currentRowIdx != null) {
                                      var checkboxes = controller.checkBoxes.value;

                                      controller.gridPrograms.insert(
                                          controller.programGrid?.currentRowIdx ?? controller.gridPrograms.length,
                                          SecondaryEventTemplateMasterProgram.convertSecondaryEventTemplateProgramGridDataToMasterProgram(
                                              controller.searchPrograms[controller.searchGrid!.currentRowIdx!],
                                              checkboxes["First Segment"] ?? false,
                                              checkboxes["Last Segment"] ?? false,
                                              checkboxes["All Segments"] ?? false,
                                              checkboxes["Pre Event"] ?? false,
                                              checkboxes["Post Event"] ?? false));
                                      controller.calculateRowNo();
                                      controller.update(["gridData"]);
                                    }
                                  },
                                ),
                                InputFields.formField1(
                                  hintTxt: "TX Id",
                                  isEnable: false,
                                  controller: TextEditingController(text: "00:00:00:00"),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Expanded(
                              child: Container(
                                  child: GetBuilder<SecondaryEventTemplateMasterController>(
                                      id: "searchGrid",
                                      init: controller,
                                      builder: (searchcontroller) {
                                        return DataGridShowOnlyKeys(
                                          onload: (event) {
                                            controller.searchGrid = event.stateManager;
                                          },
                                          onRowDoubleTap: (rowDoubleTapEvent) {
                                            var checkboxes = controller.checkBoxes.value;
                                            searchcontroller.gridPrograms.insert(
                                                controller.programGrid?.currentRowIdx ?? 0,
                                                SecondaryEventTemplateMasterProgram.convertSecondaryEventTemplateProgramGridDataToMasterProgram(
                                                    controller.searchPrograms[rowDoubleTapEvent.rowIdx],
                                                    checkboxes["First Segment"] ?? false,
                                                    checkboxes["Last Segment"] ?? false,
                                                    checkboxes["All Segments"] ?? false,
                                                    checkboxes["Pre Event"] ?? false,
                                                    checkboxes["Post Event"] ?? false));
                                            controller.calculateRowNo();
                                            controller.update(["gridData"]);
                                          },
                                          mapData: searchcontroller.searchPrograms.map((e) => e.toJson()).toList(),
                                        );
                                      })),
                            )
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
                                    ((Utils.btnAccessHandler(btn['name'], controller.formPermissions!) == null))
                                        ? null
                                        : () => btnHandler(btn['name']);
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

  btnHandler(btnName) {
    switch (btnName) {
      case "Save":
        controller.save();
        break;
      default:
    }
  }
}

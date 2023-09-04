import 'dart:math';

import 'package:bms_scheduling/app/controller/HomeController.dart';
import 'package:bms_scheduling/app/modules/CommonSearch/views/common_search_view.dart';
import 'package:bms_scheduling/app/modules/SecondaryEventTemplateMaster/bindings/secondary_event_template_master_color.dart';
import 'package:bms_scheduling/app/modules/SecondaryEventTemplateMaster/bindings/secondary_event_template_master_programs.dart';
import 'package:bms_scheduling/app/providers/ApiFactory.dart';
import 'package:bms_scheduling/app/providers/SizeDefine.dart';
import 'package:bms_scheduling/app/providers/Utils.dart';
import 'package:bms_scheduling/app/providers/extensions/device_size.dart';
import 'package:bms_scheduling/widgets/CheckBoxWidget.dart';
import 'package:bms_scheduling/widgets/DataGridMultiCheckBox.dart';
import 'package:bms_scheduling/widgets/DataGridShowOnly.dart';
import 'package:bms_scheduling/widgets/FormButton.dart';
import 'package:bms_scheduling/widgets/LoadingDialog.dart';
import 'package:bms_scheduling/widgets/dropdown.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';
import 'package:bms_scheduling/app/providers/DataGridMenu.dart';
import 'package:get/get.dart';

import '../controllers/secondary_event_template_master_controller.dart';

class SecondaryEventTemplateMasterView extends StatelessWidget {
  SecondaryEventTemplateMasterView({Key? key}) : super(key: key);
  final controller = Get.put<SecondaryEventTemplateMasterController>(
      SecondaryEventTemplateMasterController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SizedBox(
        width: context.devicewidth,
        height: context.deviceheight,
        child: Column(
          children: [
            Container(
              width: Get.width,
              padding: const EdgeInsets.all(8.0),
              child: Obx(
                () => Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  spacing: 13,
                  runSpacing: 10,
                  children: [
                    Obx(
                      () => DropDownField.formDropDown1WidthMap(
                        controller.locations.value,
                        (value) {
                          controller.selectedLocation = value;
                          controller.getChannel(value.key);
                        },
                        "Location",
                        0.24,
                        isEnable: controller.enableFields.value,
                        selected: controller.selectedLocation,
                        autoFocus: true,
                        inkWellFocusNode: controller.locFocusNode,
                      ),
                    ),
                    Obx(
                      () => DropDownField.formDropDown1WidthMap(
                        controller.channels.value,
                        (value) {
                          controller.selectedChannel = value;
                        },
                        "Channel",
                        0.24,
                        isEnable: controller.enableFields.value,
                        selected: controller.selectedChannel,
                      ),
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

                        width: context.devicewidth * 0.24,
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: GetBuilder<SecondaryEventTemplateMasterController>(
                          id: "gridData",
                          builder: (controller) => DataGridMultiCheckBox(
                                extraList: [
                                  SecondaryShowDialogModel("Delete", () {
                                    if (controller.programGrid?.currentRowIdx !=
                                        null) {
                                      controller.gridPrograms.removeAt(
                                          controller
                                              .programGrid!.currentRowIdx!);
                                      controller.calculateRowNo();
                                      controller.update(["gridData"]);
                                    }
                                  }),
                                  SecondaryShowDialogModel("Copy", () {
                                    if (controller.programGrid?.currentRowIdx !=
                                        null) {
                                      controller.copiedProgram =
                                          controller.gridPrograms[controller
                                              .programGrid!.currentRowIdx!];
                                    }
                                  }),
                                  SecondaryShowDialogModel("Cut", () {
                                    if (controller.programGrid?.currentRowIdx !=
                                        null) {
                                      controller.copiedProgram =
                                          controller.gridPrograms[controller
                                              .programGrid!.currentRowIdx!];
                                    }
                                  }),
                                  SecondaryShowDialogModel("Paste", () {
                                    if (controller.programGrid?.currentRowIdx !=
                                            null &&
                                        controller.copiedProgram != null) {
                                      controller.gridPrograms.insert(
                                          controller
                                              .programGrid!.currentRowIdx!,
                                          controller.copiedProgram!);
                                      controller.calculateRowNo();
                                      controller.update(["gridData"]);
                                    }
                                  })
                                ],
                                onload: (event) {
                                  controller.programGrid = event.stateManager;
                                },
                                mapData: controller.gridPrograms
                                    .map((e) => e.toJson())
                                    .toList(),
                                checkBoxes: [
                                  "firstSegment",
                                  "lastSegment",
                                  "allSegments",
                                  "preEvent",
                                  "postEvent"
                                ],
                                colorCallback: (event) {
                                  SecondaryTemplateEventColors? _color =
                                      controller.colors.firstWhereOrNull(
                                          (element) =>
                                              element.eventType
                                                  ?.toLowerCase()
                                                  .trim() ==
                                              controller
                                                  .gridPrograms[
                                                      event.row.sortIdx]
                                                  .eventType
                                                  ?.toLowerCase()
                                                  .trim());
                                  if (controller.gridPrograms[event.row.sortIdx]
                                              .eventType !=
                                          null &&
                                      _color != null) {
                                    return Color(
                                        int.parse("0x${_color.backColor}"));
                                  }
                                  return Colors.white;
                                },
                                onCheckBoxPress: (key, rowId) {
                                  switch (key) {
                                    case "firstSegment":
                                      controller.gridPrograms[rowId]
                                          .firstSegment = !(controller
                                              .gridPrograms[rowId]
                                              .firstSegment ??
                                          false);
                                      break;
                                    case "lastSegment":
                                      controller.gridPrograms[rowId]
                                          .lastSegment = !(controller
                                              .gridPrograms[rowId]
                                              .lastSegment ??
                                          false);
                                      break;
                                    case "allSegments":
                                      controller.gridPrograms[rowId]
                                          .allSegments = !(controller
                                              .gridPrograms[rowId]
                                              .allSegments ??
                                          false);
                                      break;
                                    case "preEvent":
                                      controller.gridPrograms[rowId].preEvent =
                                          !(controller.gridPrograms[rowId]
                                                  .preEvent ??
                                              false);
                                      break;
                                    case "postEvent":
                                      controller.gridPrograms[rowId].postEvent =
                                          !(controller.gridPrograms[rowId]
                                                  .postEvent ??
                                              false);
                                      break;

                                    default:
                                  }
                                  controller.update(["gridData"]);
                                },
                              )),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      // width: Get.width * 0.45,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Wrap(
                            spacing: 15,
                            // runAlignment: WrapAlignment.spaceBetween,
                            alignment: WrapAlignment.spaceBetween,
                            runSpacing: 10,
                            children: [
                              Obx(
                                () => DropDownField.formDropDown1WidthMap(
                                    controller.events.value,
                                    (value) =>
                                        {controller.selectedEvent = value},
                                    "Event",
                                    .24,
                                    selected: controller.selectedEvent),
                              ),
                              InputFields.formField1(
                                hintTxt: "TX Caption",
                                controller: controller.txCaption,
                                width: .24,
                              ),
                              InputFields.formField1(
                                hintTxt: "TX Id",
                                controller: controller.txID,
                                focusNode: controller.txIdFocusNode,
                                width: .5,
                              ),
                              Row(
                                children: controller.checkBoxes.value.entries
                                    .map((e) => Obx(() => Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Checkbox(
                                                value: controller
                                                    .checkBoxes[e.key],
                                                onChanged: (value) {
                                                  controller.checkBoxes[e.key] =
                                                      value ?? false;
                                                  controller.checkBoxes
                                                      .refresh();
                                                }),
                                            Text(e.key,
                                                style: TextStyle(
                                                    fontSize:
                                                        SizeDefine.labelSize1 +
                                                            1))
                                          ],
                                        )))
                                    .toList(),
                              ),
                              // Row(
                              //   mainAxisSize: MainAxisSize.min,
                              //   children: [
                              //     Obx(() => Checkbox(
                              //         value: controller.mine.value,
                              //         onChanged: (value) {
                              //           controller.mine.value = value ?? false;
                              //         })),
                              //     Text("My")
                              //   ],
                              // ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    children: [
                                      Obx(() {
                                        return CheckBoxWidget1(
                                          title: "My",
                                          horizontalPadding: 0,
                                          value: controller.mine.value,
                                          onChanged: (value) {
                                            controller.mine.value =
                                                value ?? false;
                                          },
                                        );
                                      }),
                                      const SizedBox(width: 10),
                                      FormButtonWrapper(
                                        btnText: "Search",
                                        callback: () {
                                          if (controller.txID.text.isEmpty) {
                                            LoadingDialog.modify(
                                                "Do you want to search all events?",
                                                () {
                                              controller.postFastSearch();
                                            }, () {},
                                                deleteTitle: "YES",
                                                cancelTitle: "NO");
                                          } else {
                                            controller.postFastSearch();
                                          }

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
                                      const SizedBox(width: 10),
                                      FormButtonWrapper(
                                        btnText: "Add",
                                        callback: () {
                                          if (controller
                                                  .searchGrid?.currentRowIdx !=
                                              null) {
                                            var checkboxes =
                                                controller.checkBoxes.value;

                                            controller.gridPrograms.insert(
                                                controller.programGrid
                                                        ?.currentRowIdx ??
                                                    controller
                                                        .gridPrograms.length,
                                                SecondaryEventTemplateMasterProgram
                                                    .convertSecondaryEventTemplateProgramGridDataToMasterProgram(
                                                        controller
                                                                .searchPrograms[
                                                            controller.searchGrid!
                                                                .currentRowIdx!],
                                                        checkboxes["First Segment"] ??
                                                            false,
                                                        checkboxes[
                                                                "Last Segment"] ??
                                                            false,
                                                        checkboxes["All Segments"] ??
                                                            false,
                                                        checkboxes[
                                                                "Pre Event"] ??
                                                            false,
                                                        checkboxes[
                                                                "Post Event"] ??
                                                            false));
                                            controller.calculateRowNo();
                                            controller.update(["gridData"]);
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  InputFields.formField1(
                                    hintTxt: "TX Id",
                                    isEnable: false,
                                    controller: TextEditingController(
                                        text: "00:00:00:00"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Expanded(
                            child: GetBuilder<
                                    SecondaryEventTemplateMasterController>(
                                id: "searchGrid",
                                init: controller,
                                builder: (searchcontroller) {
                                  return DataGridShowOnlyKeys(
                                    onload: (event) {
                                      controller.searchGrid =
                                          event.stateManager;
                                    },
                                    onRowDoubleTap: (rowDoubleTapEvent) {
                                      var checkboxes =
                                          controller.checkBoxes.value;
                                      searchcontroller.gridPrograms.insert(
                                          controller
                                                  .programGrid?.currentRowIdx ??
                                              0,
                                          SecondaryEventTemplateMasterProgram
                                              .convertSecondaryEventTemplateProgramGridDataToMasterProgram(
                                                  controller.searchPrograms[
                                                      rowDoubleTapEvent.rowIdx],
                                                  checkboxes["First Segment"] ??
                                                      false,
                                                  checkboxes["Last Segment"] ??
                                                      false,
                                                  checkboxes["All Segments"] ??
                                                      false,
                                                  checkboxes["Pre Event"] ??
                                                      false,
                                                  checkboxes["Post Event"] ??
                                                      false));
                                      controller.calculateRowNo();
                                      controller.update(["gridData"]);
                                    },
                                    mapData: searchcontroller.searchPrograms
                                        .map((e) => e.toJson())
                                        .toList(),
                                  );
                                }),
                          )
                        ],
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
                      : Container(
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
                                    btnHandler(btn['name']);
                                  },
                                ),
                            ],
                          ),
                        );
                })
          ],
        ),
      ),
    );
  }

  btnHandler(btnName) {
    switch (btnName) {
      case "Save":
        controller.save();
        break;
      case "Clear":
        Get.delete<SecondaryEventTemplateMasterController>();
        Get.find<HomeController>().clearPage1();
        break;
      case "Search":
        Get.to(
          const SearchPage(
            key: Key("Secondary Event Template Master"),
            screenName: "Secondary Event Template Master",
            appBarName: "Secondary Event Template Master",
            strViewName: "vTesting",
            isAppBarReq: true,
          ),
        );
        break;
      default:
    }
  }
}

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
import 'package:bms_scheduling/widgets/gridFromMap.dart';
import 'package:bms_scheduling/widgets/input_fields.dart';
import 'package:flutter/material.dart';
import 'package:bms_scheduling/app/providers/DataGridMenu.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../widgets/PlutoGrid/src/manager/pluto_grid_state_manager.dart';
import '../../../../widgets/PlutoGrid/src/model/pluto_row.dart';
import '../../../data/user_data_settings_model.dart';
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
              child: Wrap(
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
                      inkwellFocus: controller.programFocusNode,
                      width: context.devicewidth * 0.24,
                      // padding: const EdgeInsets.only()
                    ),
                  ),
                  Obx(() {
                    return FormButtonWrapper(
                      btnText: "...",
                      isEnabled: controller.enableFields.value,
                      callback: () {
                        controller.getProgramPick();
                      },
                    );
                  }),
                  FormButtonWrapper(
                    btnText: "Copy From",
                    callback: () {
                      Get.defaultDialog(
                          title: "Copy",
                          content: DropDownField.formDropDownSearchAPI2(
                            GlobalKey(),
                            context,
                            title: "Program",
                            isEnable: true,
                            url: ApiFactory
                                .SecondaryEventTemplateMasterProgSearch,
                            parseKeyForKey: "ProgramCode",
                            parseKeyForValue: "ProgramName",
                            onchanged: (data) {
                              controller.selectedProgram.value = data;
                            },
                            dialogHeight: 150,
                            autoFocus: true,
                            selectedValue: controller.selectedProgram.value,
                            inkwellFocus: controller.programFocusNode,
                          ),
                          cancel: FormButton(
                            btnText: "Copy",
                            callback: () {
                              controller.getProgramLeave();
                              Get.back();
                            },
                            showIcon: false,
                          ));
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: GetBuilder(
                          id: "gridData",
                          init: controller,
                          builder: (context) {
                            return Container(
                              decoration: controller.gridPrograms.isEmpty
                                  ? BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                    )
                                  : null,
                              child: controller.gridPrograms.isEmpty
                                  ? null
                                  : DataGridFromMap3(
                                      hideCode: false,
                                      // focusNode: controller.programFN
                                      //   ..onKeyEvent = (node, event) {
                                      //     if (event.logicalKey ==
                                      //             LogicalKeyboardKey.delete &&
                                      //         controller
                                      //             .gridPrograms.isNotEmpty &&
                                      //         controller.programGrid != null) {
                                      //       print("Heyy");
                                      //       for (var element in (controller
                                      //               .programGrid
                                      //               ?.currentSelectingRows ??
                                      //           <PlutoRow>[])) {
                                      //         controller
                                      //             .gridPrograms[element.sortIdx]
                                      //             .offSet = -1;
                                      //       }
                                      //       controller.gridPrograms.removeWhere(
                                      //           (element) =>
                                      //               element.offSet == -1);
                                      //       controller.programGrid?.removeRows(
                                      //           controller.programGrid
                                      //                   ?.currentSelectingRows ??
                                      //               []);
                                      //       return KeyEventResult.handled;
                                      //     }
                                      //     return KeyEventResult.ignored;
                                      //   },
                                      keyBoardButtonPressed: () {
                                        if (controller
                                                .gridPrograms.isNotEmpty &&
                                            controller.programGrid != null) {
                                          for (var element in (controller
                                                  .programGrid
                                                  ?.currentSelectingRows ??
                                              <PlutoRow>[])) {
                                            controller
                                                .gridPrograms[element.sortIdx]
                                                .offSet = -1;
                                          }
                                          controller.gridPrograms.removeWhere(
                                              (element) =>
                                                  element.offSet == -1);
                                          controller.update(['gridData']);
                                        }
                                      },
                                      witdthSpecificColumn: (controller
                                          .userDataSettings?.userSetting
                                          ?.firstWhere(
                                              (element) =>
                                                  element.controlName ==
                                                  "programGrid",
                                              orElse: () => UserSetting())
                                          .userSettings),
                                      logicalKeyboardKey:
                                          LogicalKeyboardKey.delete,
                                      mapData: controller.gridPrograms
                                          .map((e) => e.toJson(fromSave: false))
                                          .toList(),
                                      secondaryExtraDialogList: [
                                        SecondaryShowDialogModel("Delete", () {
                                          if (controller
                                                  .programGrid?.currentRowIdx !=
                                              null) {
                                            controller.gridPrograms.removeAt(
                                                controller.programGrid!
                                                    .currentRowIdx!);
                                            controller.calculateRowNo();
                                            controller.update(["gridData"]);
                                          }
                                        }),
                                        SecondaryShowDialogModel("Copy", () {
                                          if (controller
                                                  .programGrid?.currentRowIdx !=
                                              null) {
                                            controller.copiedProgram =
                                                controller.gridPrograms[
                                                    controller.programGrid!
                                                        .currentRowIdx!];
                                          }
                                        }),
                                        SecondaryShowDialogModel("Cut", () {
                                          if (controller
                                                  .programGrid?.currentRowIdx !=
                                              null) {
                                            controller.copiedProgram =
                                                controller.gridPrograms[
                                                    controller.programGrid!
                                                        .currentRowIdx!];
                                          }
                                        }),
                                        SecondaryShowDialogModel("Paste", () {
                                          if (controller.programGrid
                                                      ?.currentRowIdx !=
                                                  null &&
                                              controller.copiedProgram !=
                                                  null) {
                                            controller.gridPrograms.insert(
                                                controller.programGrid!
                                                    .currentRowIdx!,
                                                controller.copiedProgram!);
                                            controller.calculateRowNo();
                                            controller.update(["gridData"]);
                                          }
                                        })
                                      ],
                                      checkBoxColumnKey: [
                                        "firstSegment",
                                        "lastSegment",
                                        "allSegments",
                                        "preEvent",
                                        "postEvent"
                                      ],
                                      checkBoxStrComparison: 'true',
                                      uncheckCheckBoxStr: 'false',
                                      colorCallback: (event) {
                                        if (event.row.cells.containsValue(
                                            controller
                                                .programGrid?.currentCell)) {
                                          return Colors.deepPurple.shade200;
                                        } else {
                                          SecondaryTemplateEventColors? _color =
                                              controller.colors
                                                  .firstWhereOrNull((element) =>
                                                      element.eventType
                                                          ?.toLowerCase()
                                                          .trim() ==
                                                      controller
                                                          .gridPrograms[
                                                              event.row.sortIdx]
                                                          .eventType
                                                          ?.toLowerCase()
                                                          .trim());
                                          if (controller
                                                      .gridPrograms[
                                                          event.row.sortIdx]
                                                      .eventType !=
                                                  null &&
                                              _color != null) {
                                            return Color(int.parse(
                                                "0x${_color.backColor}"));
                                          } else {
                                            return Colors.white;
                                          }
                                        }
                                      },
                                      onload: (event) {
                                        controller.programGrid =
                                            event.stateManager;
                                        event.stateManager.setSelectingMode(
                                            PlutoGridSelectingMode.row);
                                      },
                                      actionOnPress: (position, isSpaceCalled) {
                                        // print(position.rowIdx);
                                        if (isSpaceCalled) {
                                          if (position.columnIdx == 1) {
                                            controller.programGrid!
                                                .changeCellValue(
                                              controller.programGrid!
                                                  .getRowByIdx(position.rowIdx)!
                                                  .cells['firstSegment']!,
                                              (!(controller
                                                          .gridPrograms[
                                                              position.rowIdx!]
                                                          .firstSegment ??
                                                      false))
                                                  .toString(),
                                              callOnChangedEvent: true,
                                              force: true,
                                              notify: true,
                                            );
                                          } else if (position.columnIdx == 2) {
                                            controller.programGrid!
                                                .changeCellValue(
                                              controller.programGrid!
                                                  .getRowByIdx(position.rowIdx)!
                                                  .cells['lastSegment']!,
                                              (!(controller
                                                          .gridPrograms[
                                                              position.rowIdx!]
                                                          .lastSegment ??
                                                      false))
                                                  .toString(),
                                              callOnChangedEvent: true,
                                              force: true,
                                              notify: true,
                                            );
                                          } else if (position.columnIdx == 3) {
                                            controller.programGrid!
                                                .changeCellValue(
                                              controller.programGrid!
                                                  .getRowByIdx(position.rowIdx)!
                                                  .cells['allSegments']!,
                                              (!(controller
                                                          .gridPrograms[
                                                              position.rowIdx!]
                                                          .allSegments ??
                                                      false))
                                                  .toString(),
                                              callOnChangedEvent: true,
                                              force: true,
                                              notify: true,
                                            );
                                          } else if (position.columnIdx == 4) {
                                            controller.programGrid!
                                                .changeCellValue(
                                              controller.programGrid!
                                                  .getRowByIdx(position.rowIdx)!
                                                  .cells['preEvent']!,
                                              (!(controller
                                                          .gridPrograms[
                                                              position.rowIdx!]
                                                          .preEvent ??
                                                      false))
                                                  .toString(),
                                              callOnChangedEvent: true,
                                              force: true,
                                              notify: true,
                                            );
                                          } else if (position.columnIdx == 5) {
                                            controller.programGrid!
                                                .changeCellValue(
                                              controller.programGrid!
                                                  .getRowByIdx(position.rowIdx)!
                                                  .cells['postEvent']!,
                                              (!(controller
                                                          .gridPrograms[
                                                              position.rowIdx!]
                                                          .postEvent ??
                                                      false))
                                                  .toString(),
                                              callOnChangedEvent: true,
                                              force: true,
                                              notify: true,
                                            );
                                          }
                                        }
                                      },
                                      columnAutoResize: false,
                                      actionIconKey: [
                                        "firstSegment",
                                        "lastSegment",
                                        "allSegments",
                                        "preEvent",
                                        "postEvent"
                                      ],
                                      onEdit: (event) {
                                        // print(event.columnIdx);
                                        if (event.columnIdx == 1) {
                                          controller.gridPrograms[event.rowIdx]
                                              .firstSegment = event.value
                                                  .toString()
                                                  .toLowerCase() ==
                                              "true";
                                        } else if (event.columnIdx == 2) {
                                          controller.gridPrograms[event.rowIdx]
                                              .lastSegment = event.value
                                                  .toString()
                                                  .toLowerCase() ==
                                              "true";
                                        } else if (event.columnIdx == 3) {
                                          controller.gridPrograms[event.rowIdx]
                                              .allSegments = event.value
                                                  .toString()
                                                  .toLowerCase() ==
                                              "true";
                                        } else if (event.columnIdx == 4) {
                                          controller.gridPrograms[event.rowIdx]
                                              .preEvent = event.value
                                                  .toString()
                                                  .toLowerCase() ==
                                              "true";
                                        } else if (event.columnIdx == 5) {
                                          controller.gridPrograms[event.rowIdx]
                                              .postEvent = event.value
                                                  .toString()
                                                  .toLowerCase() ==
                                              "true";
                                        }
                                      },
                                    ),
                            );
                          }),
                    ),
                    // Expanded(
                    //   child: GetBuilder<SecondaryEventTemplateMasterController>(
                    //     id: "gridData",
                    //     builder: (controller) => DataGridMultiCheckBox(
                    //       extraList: [
                    //         SecondaryShowDialogModel("Delete", () {
                    //           if (controller.programGrid?.currentRowIdx !=
                    //               null) {
                    //             controller.gridPrograms.removeAt(
                    //                 controller.programGrid!.currentRowIdx!);
                    //             controller.calculateRowNo();
                    //             controller.update(["gridData"]);
                    //           }
                    //         }),
                    //         SecondaryShowDialogModel("Copy", () {
                    //           if (controller.programGrid?.currentRowIdx !=
                    //               null) {
                    //             controller.copiedProgram =
                    //                 controller.gridPrograms[
                    //                     controller.programGrid!.currentRowIdx!];
                    //           }
                    //         }),
                    //         SecondaryShowDialogModel("Cut", () {
                    //           if (controller.programGrid?.currentRowIdx !=
                    //               null) {
                    //             controller.copiedProgram =
                    //                 controller.gridPrograms[
                    //                     controller.programGrid!.currentRowIdx!];
                    //           }
                    //         }),
                    //         SecondaryShowDialogModel("Paste", () {
                    //           if (controller.programGrid?.currentRowIdx !=
                    //                   null &&
                    //               controller.copiedProgram != null) {
                    //             controller.gridPrograms.insert(
                    //                 controller.programGrid!.currentRowIdx!,
                    //                 controller.copiedProgram!);
                    //             controller.calculateRowNo();
                    //             controller.update(["gridData"]);
                    //           }
                    //         })
                    //       ],
                    //       onload: (event) {
                    //         controller.programGrid = event.stateManager;
                    //       },
                    //       hideCode: false,
                    //       mapData: controller.gridPrograms
                    //           .map((e) => e.toJson())
                    //           .toList(),
                    //       checkBoxes: [
                    //         "firstSegment",
                    //         "lastSegment",
                    //         "allSegments",
                    //         "preEvent",
                    //         "postEvent"
                    //       ],
                    //       colorCallback: (event) {
                    //         SecondaryTemplateEventColors? _color =
                    //             controller.colors.firstWhereOrNull((element) =>
                    //                 element.eventType?.toLowerCase().trim() ==
                    //                 controller.gridPrograms[event.row.sortIdx]
                    //                     .eventType
                    //                     ?.toLowerCase()
                    //                     .trim());
                    //         if (controller.gridPrograms[event.row.sortIdx]
                    //                     .eventType !=
                    //                 null &&
                    //             _color != null) {
                    //           return Color(int.parse("0x${_color.backColor}"));
                    //         }
                    //         return Colors.white;
                    //       },
                    //       onCheckBoxPress: (key, rowId) {
                    //         switch (key) {
                    //           case "firstSegment":
                    //             controller.gridPrograms[rowId].firstSegment =
                    //                 !(controller
                    //                         .gridPrograms[rowId].firstSegment ??
                    //                     false);
                    //             break;
                    //           case "lastSegment":
                    //             controller.gridPrograms[rowId].lastSegment =
                    //                 !(controller
                    //                         .gridPrograms[rowId].lastSegment ??
                    //                     false);
                    //             break;
                    //           case "allSegments":
                    //             controller.gridPrograms[rowId].allSegments =
                    //                 !(controller
                    //                         .gridPrograms[rowId].allSegments ??
                    //                     false);
                    //             break;
                    //           case "preEvent":
                    //             controller.gridPrograms[rowId].preEvent =
                    //                 !(controller.gridPrograms[rowId].preEvent ??
                    //                     false);
                    //             break;
                    //           case "postEvent":
                    //             controller.gridPrograms[rowId].postEvent =
                    //                 !(controller
                    //                         .gridPrograms[rowId].postEvent ??
                    //                     false);
                    //             break;

                    //           default:
                    //         }
                    //         controller.update(["gridData"]);
                    //       },
                    //     ),
                    //   ),
                    // ),
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
                                            CheckBoxWidget1(
                                              title: e.key,
                                              isEnable: ((e.key ==
                                                              "First Segment" ||
                                                          e.key ==
                                                              "Last Segment") &&
                                                      (controller.checkBoxes[
                                                              'All Segments']
                                                          as bool))
                                                  ? false
                                                  : true,
                                              value: controller
                                                  .checkBoxes[e.key] as bool,
                                              onChanged: (value) {
                                                controller.checkBoxes[e.key] =
                                                    value ?? false;
                                                if (e.key == "All Segments") {
                                                  if (controller
                                                          .checkBoxes[e.key]
                                                      as bool) {
                                                    controller.checkBoxes[
                                                        "First Segment"] = true;
                                                    controller.checkBoxes[
                                                        "Last Segment"] = true;
                                                  } else {
                                                    controller.checkBoxes[
                                                            "First Segment"] =
                                                        false;
                                                    controller.checkBoxes[
                                                        "Last Segment"] = false;
                                                  }
                                                }
                                                controller.checkBoxes.refresh();
                                              },
                                            ),
                                            // if (e.key == 'All Segments') ...{
                                            //   const Spacer(),
                                            // }
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
                                          if (controller.searchGrid == null) {
                                            return;
                                          }
                                          var checkboxes =
                                              controller.checkBoxes.value;
                                          if (controller.searchGrid
                                                      ?.currentSelectingRows ==
                                                  null ||
                                              (controller
                                                      .searchGrid
                                                      ?.currentSelectingRows
                                                      .isEmpty ??
                                                  true)) {
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
                                          } else {
                                            for (var element in (controller
                                                    .searchGrid
                                                    ?.currentSelectingRows ??
                                                <PlutoRow>[])) {
                                              controller.gridPrograms.insert(
                                                  controller.programGrid
                                                          ?.currentRowIdx ??
                                                      controller
                                                          .gridPrograms.length,
                                                  SecondaryEventTemplateMasterProgram
                                                      .convertSecondaryEventTemplateProgramGridDataToMasterProgram(
                                                          controller.searchPrograms[
                                                              element.sortIdx],
                                                          checkboxes[
                                                                  "First Segment"] ??
                                                              false,
                                                          checkboxes[
                                                                  "Last Segment"] ??
                                                              false,
                                                          checkboxes[
                                                                  "All Segments"] ??
                                                              false,
                                                          checkboxes[
                                                                  "Pre Event"] ??
                                                              false,
                                                          checkboxes[
                                                                  "Post Event"] ??
                                                              false));
                                            }
                                          }
                                          // if (controller
                                          //         .searchGrid?.currentRowIdx !=
                                          //     null) {

                                          //   controller.calculateRowNo();
                                          //   controller.update(["gridData"]);
                                          // }
                                          controller.calculateRowNo();
                                          controller.update(["gridData"]);
                                        },
                                      ),
                                    ],
                                  ),
                                  InputFields.formField1(
                                    hintTxt: "",
                                    isEnable: false,
                                    controller: controller.durationCtr,
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
                                    keysWidths: (controller
                                        .userDataSettings?.userSetting
                                        ?.firstWhere(
                                            (element) =>
                                                element.controlName ==
                                                "searchGrid",
                                            orElse: () => UserSetting())
                                        .userSettings),
                                    onload: (event) {
                                      controller.searchGrid =
                                          event.stateManager;

                                      event.stateManager.setSelectingMode(
                                          PlutoGridSelectingMode.row);

                                      controller.searchGrid?.setCurrentCell(
                                          event.stateManager.firstCell, 0);
                                      controller.durationCtr.text =
                                          Utils.convertToTimeFromDouble(
                                              value: searchcontroller
                                                      .searchPrograms[0]
                                                      .duration ??
                                                  0);
                                    },
                                    onRowDoubleTap: (rowDoubleTapEvent) {
                                      controller.searchGrid?.setCurrentCell(
                                          rowDoubleTapEvent
                                              .row.cells['eventtype'],
                                          rowDoubleTapEvent.rowIdx);
                                      controller.durationCtr.text =
                                          Utils.convertToTimeFromDouble(
                                              value: searchcontroller
                                                      .searchPrograms[
                                                          rowDoubleTapEvent
                                                              .rowIdx]
                                                      .duration ??
                                                  0);
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

                                      // controller.calculateRowNo();
                                      controller.update(["gridData"]);
                                    },
                                    hideCode: false,
                                    hideKeys: ['languagename'],
                                    colorCallback: (row) => ((row.row.cells
                                            .containsValue(controller
                                                .searchGrid?.currentCell))
                                        ? Colors.deepPurple.shade200
                                        : Colors.white),
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
                                  callback: (btn["name"] == "Refresh" ||
                                          btn["name"] == "Delete")
                                      ? null
                                      : () {
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
      case "Exit":
        Get.find<HomeController>().postUserGridSetting2(listStateManager: [
          {"searchGrid": controller.searchGrid},
          {"programGrid": controller.programGrid},
        ]);
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

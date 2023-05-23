import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../../widgets/input_fields.dart';
import '../../../controller/HomeController.dart';
import '../../filler/controllers/filler_controller.dart';
import '../controllers/event_secondary_controller.dart';

class EventSecondaryView extends GetView<EventSecondaryController> {
  EventSecondaryView({Key? key}) : super(key: key);

  late PlutoGridStateManager stateManager;
  var formName = 'Scheduling Promo';

  void handleOnRowChecked(PlutoGridOnRowCheckedEvent event) {}
  EventSecondaryController controllerX = Get.put(EventSecondaryController());
  //FillerController controllerX = Get.put(FillerController());

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final h = MediaQuery.of(context).size.height;

    return GetBuilder<FillerController>(
        init: FillerController(),
        id: "initData",
        builder: (controller) {
          FocusNode _channelsFocus = FocusNode();
          return Scaffold(
            body: FocusTraversalGroup(
              policy: OrderedTraversalPolicy(),
              child: SizedBox(
                height: double.maxFinite,
                width: double.maxFinite,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          /// Event & EventCaption Table
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: GetBuilder<EventSecondaryController>(
                                      id: "initialData",
                                      builder: (control) {
                                        return Row(
                                          children: [
                                            Obx(
                                                  () => DropDownField.formDropDown1WidthMap(
                                                  controller.locations.value, (value) {
                                                controller.selectedLocation = value;
                                                controller.getChannel(value.key);
                                              }, "Location", 0.15),
                                            ),
                                            const SizedBox(width: 10),
                                            Obx(() {
                                              return DropDownField
                                                  .formDropDown1Width(
                                                Get.context!,
                                                controllerX.channelList ?? [],
                                                    (value) {
                                                  controllerX
                                                      .selectedChannel =
                                                      value;
                                                },
                                                "Channel",
                                                controllerX.widthSize + 0.02,
                                                paddingLeft: 5,
                                                searchReq: true,
                                                isEnable: control
                                                    .channelEnable.value,
                                                selected: controllerX
                                                    .selectedChannelEnv,
                                                dialogHeight: Get.height * .7,
                                              );
                                            }),
                                            const SizedBox(width: 10),
                                            DateWithThreeTextField(
                                              title: "From Date",
                                              mainTextController:
                                              controllerX.date_,
                                              widthRation: 0.13,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, top: 17.0),
                                              child: FormButton(
                                                btnText: "Show Details",
                                                callback: () {},
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 17.0),
                                              child: FormButton(
                                                btnText: "Get Previous",
                                                callback: () {},
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    //flex: 1,
                                    child: GetBuilder<FillerController>(
                                        init: FillerController(),
                                        id: "eventTable",
                                        builder: (controller) {
                                          if (controller
                                              .conflictReport.isEmpty ||
                                              controller.beams.isEmpty) {
                                            return Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                eventTable(context),
                                              ],
                                            );
                                          } else {
                                            return Container();
                                          }
                                        }),
                                  ),
                                  Expanded(
                                    //flex: 1,
                                    child: GetBuilder<FillerController>(
                                        init: FillerController(),
                                        id: "eventCaptionTable",
                                        builder: (controller) {
                                          if (controller
                                              .conflictReport.isEmpty ||
                                              controller.beams.isEmpty) {
                                            return Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                eventCaptionTable(context),
                                              ],
                                            );
                                          } else {
                                            return Container();
                                          }
                                        }),
                                  ),
                                  const SizedBox(height:5),
                                  const Text(
                                      "Time Band : 00:00:00"),
                                  const SizedBox(height:10),
                                  const Text(
                                      "Program : PrgName"),
                                  const SizedBox(height:5),
                                ],
                              ),
                            ),
                          ),
                          /// Caption Table
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 15, 0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.only(top: 5.0),
                                          child: InputFields.formField1Width(
                                              widthRatio: .15,
                                              paddingLeft: 5,
                                              hintTxt: "Sec. Caption",
                                              controller: controllerX.tapeId_,
                                              maxLen: 10),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.only(top: 5.0),
                                          child: InputFields.formField1Width(
                                              widthRatio: (Get.width * 0.2) / 2 + 7,
                                              paddingLeft: 5,
                                              isEnable: false,
                                              hintTxt: "",
                                              controller: controllerX.segDur_,
                                              maxLen: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.only(top: 7.0),
                                          child: InputFields.formField1Width(
                                              widthRatio:(Get.width * 0.2) / 2 + 7 ,
                                              paddingLeft: 5,
                                              hintTxt: "Secondary Id",
                                              controller: controllerX.tapeId_,
                                              maxLen: 10),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 8.0, top: 8.0),
                                        child: Row(children: [
                                          Radio(
                                            value: 0,
                                            groupValue:
                                            controllerX.selectedAfter,
                                            onChanged: (int? value) {},
                                          ),
                                          const Text('My')
                                        ]),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, bottom: 5.0, top: 5.0),
                                        child: FormButton(
                                          btnText: "Search",
                                          callback: () {},
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, bottom: 5.0, top: 5.0),
                                        child: FormButton(
                                          btnText: "Add",
                                          callback: () {},
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, bottom: 5.0, top: 5.0),
                                        child: FormButton(
                                          btnText: "Add FPC",
                                          callback: () {},
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, bottom: 5.0, top: 5.0),
                                        child: FormButton(
                                          btnText: "Delete All",
                                          callback: () {},
                                        ),
                                      ),
                                    ],
                                  ),
                                  captionTable(context),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 8.0, top: 8.0),
                                        child: Row(
                                            children: [
                                          Radio(
                                            value: 0,
                                            groupValue:
                                            controllerX.selectedAfter,
                                            onChanged: (int? value) {},
                                          ),
                                          const Text('All')
                                        ]),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 8.0, top: 8.0),
                                        child: Row(
                                            children: [
                                              Radio(
                                                value: 0,
                                                groupValue:
                                                controllerX.selectedAfter,
                                                onChanged: (int? value) {},
                                              ),
                                              const Text('Odd')
                                            ]),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 8.0, top: 8.0),
                                        child: Row(
                                            children: [
                                              Radio(
                                                value: 0,
                                                groupValue:
                                                controllerX.selectedAfter,
                                                onChanged: (int? value) {},
                                              ),
                                              const Text('Even')
                                            ]),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GetBuilder<HomeController>(
                        id: "buttons",
                        init: Get.find<HomeController>(),
                        builder: (btcontroller) {
                          if (btcontroller.buttons != null) {
                            return ButtonBar(
                              alignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                for (var btn in btcontroller.buttons!)
                                //if (Utils.btnAccessHandler(btn['name'], controller.formPermissions!) != null)
                                  FormButtonWrapper(
                                    btnText: btn["name"],
                                    callback: () => controller.formHandler(
                                      btn['name'],
                                    ),
                                  )
                              ],
                            );
                          }
                          return Container();
                        }),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget eventTable(context) {
    return GetBuilder<FillerController>(
        id: "fillerTable",
        // init: CreateBreakPatternController(),
        builder: (controller) {
          if (controllerX.eventList != null &&
              (controllerX.eventList?.isNotEmpty)!) {
            // final key = GlobalKey();
            return Expanded(
              child: DataGridFromMap(
                mapData:
                (controllerX.eventList?.map((e) => e.toJson()).toList())!,
                widthRatio: (Get.width * 0.2) / 2 + 7,
                // mode: PlutoGridMode.select,
                onSelected: (plutoGrid) {
                  controllerX.selectedEvent =
                  controllerX.eventList![plutoGrid.rowIdx!];
                  print(jsonEncode(controllerX.selectedEvent?.toJson()));
                },
              ),
            );
          } else {
            return Expanded(
              child: Card(
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0), // if you need this
                  side: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: Container(
                  //height: Get.height - (4 * kToolbarHeight),
                ),
              ),
            );
          }
        });
  }

  Widget eventCaptionTable(context) {
    return GetBuilder<FillerController>(
        id: "fillerSegmentTable",
        // init: CreateBreakPatternController(),
        builder: (controller) {
          if (controllerX.secondaryEventProgramList != null &&
              (controllerX.secondaryEventProgramList?.isNotEmpty)!) {
            // final key = GlobalKey();
            return Expanded(
              // height: 400,
              child: DataGridFromMap(
                mapData: (controllerX.secondaryEventProgramList
                    ?.map((e) => e.toJson())
                    .toList())!,
                widthRatio: (Get.width * 0.2) / 2 + 7,
                // mode: PlutoGridMode.select,
                onSelected: (plutoGrid) {
                  controllerX.selectedSecondaryEventProgram =
                  controllerX.secondaryEventProgramList![plutoGrid.rowIdx!];
                  print(
                      jsonEncode(controllerX.selectedSecondaryEventProgram?.toJson()));
                },
              ),
            );
          } else {
            return Expanded(
              child: Card(
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0), // if you need this
                  side: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                child: Container(
                  //height: Get.height - (4 * kToolbarHeight),
                ),
              ),
            );
          }
        });
  }

  Widget captionTable(context) {
    return GetBuilder<EventSecondaryController>(
        id: "captionTable",
        // init: CreateBreakPatternController(),
        builder: (controller) {
          // if (controllerX.fillerDailyFpcList != null &&
          //     (controllerX.fillerDailyFpcList?.isNotEmpty)!) {
          //   // final key = GlobalKey();
          //   return Expanded(
          //     // height: 400,
          //     child: DataGridFromMap(
          //       mapData:
          //       (controllerX.fillerDailyFpcList?.map((e) => e.toJson()).toList())!,
          //       widthRatio: (Get.width * 0.2) / 2 + 7,
          //       // mode: PlutoGridMode.select,
          //       onSelected: (plutoGrid) {
          //         controllerX.selectedDailyFPC =
          //         controllerX.fillerDailyFpcList![plutoGrid.rowIdx!];
          //         print(jsonEncode(controllerX.selectedDailyFPC?.toJson()));
          //       },
          //     ),
          //   );
          // } else {
          // return Expanded(
          //     child: Card(
          //       clipBehavior: Clip.hardEdge,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(0), // if you need this
          //         side: BorderSide(
          //           color: Colors.grey.shade300,
          //           width: 1,
          //         ),
          //       ),
          //       child: Container(
          //         height: Get.height - (4 * kToolbarHeight),
          //       ),
          //     ),
          //   );
          // }

          return Expanded(
            child: Card(
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0), // if you need this
                side: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
              child: Container(
                height: Get.height - (4 * kToolbarHeight),
              ),
            ),
          );
        });
  }

}

import 'dart:convert';
import 'package:bms_scheduling/app/modules/filler/FillerDailyFPCModel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluto_grid/pluto_grid.dart';
import '../../../../widgets/DateTime/DateWithThreeTextField.dart';
import '../../../../widgets/FormButton.dart';
import '../../../../widgets/cutom_dropdown.dart';
import '../../../../widgets/dropdown.dart';
import '../../../../widgets/gridFromMap.dart';
import '../../../../widgets/input_fields.dart';
import '../../../controller/HomeController.dart';
import '../../../providers/ApiFactory.dart';
import '../controllers/filler_controller.dart';

class FillerView extends GetView<FillerController> {
  FillerView({Key? key}) : super(key: key);

  late PlutoGridStateManager stateManager;
  var formName = 'Scheduling Filler';

  void handleOnRowChecked(PlutoGridOnRowCheckedEvent event) {}
  FillerController controllerX = Get.put(FillerController());

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
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: SizedBox(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GetBuilder<FillerController>(
                        id: "initialData",
                        builder: (control) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 18.0, top: 10),
                            child: Row(
                              children: [
                                // Obx(
                                //   () => DropDownField.formDropDown1WidthMap(
                                //     controllerX.locations.value,
                                //     (value) {
                                //       controllerX.selectLocation = value;
                                //       // controllerX.selectedLocationId.text = value.key!;
                                //       // controllerX.selectedLocationName.text = value.value!;
                                //       controllerX.getChannel;
                                //     },
                                //     "Location",
                                //     0.12,
                                //     isEnable: controllerX.isEnable.value,
                                //     selected: controllerX.selectLocation,
                                //     autoFocus: true,
                                //     dialogWidth: 330,
                                //     dialogHeight: Get.height * .7,
                                //   ),
                                // ),

                                Obx(
                                  () => DropDownField.formDropDown1WidthMap(
                                      controller.locations.value, (value) {
                                    controller.selectedLocation = value;
                                    controller.getChannel(value.key);
                                  }, "Location", 0.15),
                                ),
                                const SizedBox(width: 15),
                                Obx(
                                  () => DropDownField.formDropDown1WidthMap(
                                    controller.channels.value,
                                    (value) {
                                      controller.selectedChannel = value;
                                    },
                                    "Channel",
                                    0.15,
                                    dialogHeight: Get.height * .7,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Obx(
                                  () => DateWithThreeTextField(
                                    title: "From Date",
                                    splitType: "-",
                                    widthRation: controllerX.widthSize,
                                    isEnable: controller.isEnable.value,
                                    onFocusChange: (data) {
                                      print('Selected Date $data');
                                      controllerX.fetchFPCDetails();
                                    },
                                    mainTextController: controllerX.date_,
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 17.0),
                                  child: FormButton(
                                    btnText: "Import Excel",
                                    callback: () {
                                      controllerX.pickFile();
                                      //  controllerX.fetchFPCDetails();
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 17.0),
                                  child: FormButton(
                                    btnText: "Import Fillers",
                                    callback: () {
                                      Get.defaultDialog(
                                          title: "Import Fillers",
                                          content: Column(
                                            children: [

                                              Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Row(
                                                  children: [
                                                    Obx(
                                                      () => DropDownField
                                                          .formDropDown1WidthMap(
                                                              controller.importLocations
                                                                  .value,
                                                              (value) {
                                                        controller
                                                                .selectedImportLocation =
                                                            value;
                                                        controller.getChannel(
                                                            value.key);
                                                      }, "Location", 0.15),
                                                    ),
                                                    const SizedBox(width: 15),
                                                    Obx(
                                                      () => DropDownField
                                                          .formDropDown1WidthMap(
                                                        controller.importChannels.value,
                                                        (value) {
                                                          controller
                                                                  .selectedImportChannel =
                                                              value;
                                                        },
                                                        "Channel",
                                                        0.15,
                                                        dialogHeight:
                                                            Get.height * .7,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              const SizedBox(height: 10),

                                              Padding(
                                                padding: EdgeInsets.all(10),
                                                child: Row(
                                                  children: [
                                                    Obx(
                                                      () =>
                                                          DateWithThreeTextField(
                                                        title: "From Date",
                                                        splitType: "-",
                                                        widthRation: 0.15,
                                                        isEnable: controller
                                                            .isEnable.value,
                                                        onFocusChange: (data) {
                                                          // print('Selected Date $data');
                                                          // controllerX.fetchFPCDetails();
                                                        },
                                                        mainTextController:
                                                            controllerX
                                                                .fillerFromDate_,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 15),
                                                    Obx(
                                                      () =>
                                                          DateWithThreeTextField(
                                                        title: "To Date",
                                                        splitType: "-",
                                                        widthRation: 0.15,
                                                        isEnable: controller
                                                            .isEnable.value,
                                                        onFocusChange: (data) {
                                                          // print('Selected Date $data');
                                                          // controllerX.fetchFPCDetails();
                                                        },
                                                        mainTextController:
                                                            controllerX
                                                                .fillerToDate_,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              const SizedBox(height: 15),

                                              Row(
                                                children: [
                                                  InputFields.formFieldNumberMask(
                                                      hintTxt: "From Time",
                                                      controller: controllerX.fromTime_,
                                                      widthRatio: 0.15,
                                                      isEnable: true,
                                                      onEditComplete: (val) {
                                                        // control.getCaption();
                                                      }
                                                    // paddingLeft: 0,
                                                  ),
                                                  const SizedBox(width: 6),
                                                  InputFields.formFieldNumberMask(
                                                      hintTxt: "To Time",
                                                      controller: controllerX.toTime_,
                                                      widthRatio: 0.15,
                                                      isEnable: true,
                                                      onEditComplete: (val) {
                                                        // control.getCaption();
                                                      }
                                                    // paddingLeft: 0,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          cancel: Padding(
                                            padding: const EdgeInsets.fromLTRB(0,0,10,10),
                                            child: FormButtonWrapper(
                                                btnText: "Exit",
                                                callback: () {
                                                  // if (_client != null) {
                                                  //   controller.updateClientData(
                                                  //       tapEvent, _client!);
                                                  // }
                                                }),
                                          ),
                                          confirm: Padding(
                                            padding: const EdgeInsets.fromLTRB(10,0,0,10),
                                            child: FormButtonWrapper(
                                                btnText: "Import",
                                                callback: () {
                                                  controllerX.getFillerValuesByImportFillersWithTapeCode(controllerX.tapeId_.text);
                                                  // controller.clearClientData(
                                                  //     tapEvent, _client!);
                                                }),
                                          )
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 15, 7, 0),
                          child: GetBuilder<FillerController>(
                              init: FillerController(),
                              id: "fillerFPCTable",
                              builder: (controller) {
                                if (controller.conflictReport.isEmpty ||
                                    controller.beams.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: fillerDailyFPCTable(context),
                                  );
                                } else {
                                  return Container();
                                }
                              }),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(15, 15, 7, 0),
                          child: GetBuilder<FillerController>(
                              init: FillerController(),
                              id: "fillerSegment",
                              builder: (controller) {
                                if (controller.conflictReport.isEmpty ||
                                    controller.beams.isEmpty) {
                                  return SizedBox(
                                    //width: w * 0.65,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(5.0),
                                              child: Obx(
                                                () => DropDownField
                                                    .formDropDownSearchAPI2(
                                                  GlobalKey(), context,
                                                  title: "Filler Caption",
                                                  //autoFocus: true,
                                                  //url: '',
                                                  url:
                                                      ApiFactory.FILLER_CAPTION,
                                                  parseKeyForKey: "fillerCode",
                                                  parseKeyForValue:
                                                      "fillerCaption",
                                                  onchanged: (data) {
                                                    // controllerX
                                                    //     .candoFocusOnCaptionGrid =
                                                    // false;
                                                    // // print("Hey Test>>>" + data.toString());
                                                    // // //controllerX.selectProgram = DropDownValue(key: data["programCode"].toString(),value: data["programName"]);
                                                    // controllerX.selectCaption = data;
                                                    // controllerX.isSearchFromCaption =
                                                    // true;
                                                    // // // controllerX.selectProgram1 = data;
                                                    // // // stuck ==>1
                                                    print(
                                                        '>> Selected Caption : ${data.key.toString()}');
                                                    controllerX
                                                        .getFillerValuesByFillerCode(
                                                            data.key
                                                                .toString());
                                                  },
                                                  selectedValue: controllerX
                                                      .selectCaption.value,
                                                  width: w * 0.45,
                                                  // padding: const EdgeInsets.only()
                                                ),
                                              ),
                                            ),

                                            /// TAPE ID eg: PCHF24572
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0),
                                              child:
                                                  InputFields.formField1Width(
                                                      widthRatio: 0.12,
                                                      paddingLeft: 5,
                                                      hintTxt: "Tape ID",
                                                      controller:
                                                          controllerX.tapeId_,
                                                      isEnable: true,
                                                      onChange: (value) {
                                                        print(
                                                            '>> selected Tape id : ${value.toString()}');
                                                        controllerX
                                                            .getFillerValuesByTapeCode(
                                                                value
                                                                    .toString());
                                                      },
                                                      maxLen: 10),
                                            ),

                                            /// SEG NO
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0),
                                              child:
                                                  InputFields.formField1Width(
                                                      widthRatio: 0.10,
                                                      paddingLeft: 5,
                                                      hintTxt: "Seg No",
                                                      controller:
                                                          controllerX.segNo_,
                                                      isEnable: false,
                                                      maxLen: 10),
                                            ),

                                            /// SEG DUR
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0),
                                              child:
                                                  InputFields.formField1Width(
                                                      widthRatio: 0.10,
                                                      paddingLeft: 5,
                                                      hintTxt: "Seg Dur",
                                                      controller:
                                                          controllerX.segDur_,
                                                      isEnable: false,
                                                      maxLen: 10),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            /// TOTAL FILLER
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0, bottom: 5.0),
                                              child:
                                                  InputFields.formField1Width(
                                                      widthRatio: 0.12,
                                                      paddingLeft: 5,
                                                      hintTxt: "Total Filler",
                                                      controller: controllerX
                                                          .totalFiller,
                                                      maxLen: 10),
                                            ),

                                            /// TOTAL FILLER DUR
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 5.0, bottom: 5.0),
                                              child:
                                                  InputFields.formField1Width(
                                                      widthRatio: 0.12,
                                                      paddingLeft: 5,
                                                      hintTxt:
                                                          "Total Filler Dur",
                                                      controller: controllerX
                                                          .totalFillerDur,
                                                      maxLen: 10),
                                            ),

                                            /// INSERT AFTER
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 15.0),
                                              child: Row(children: [
                                                Radio(
                                                  value: 0,
                                                  groupValue:
                                                      controllerX.selectedAfter,
                                                  onChanged: (int? value) {},
                                                ),
                                                Text('Insert After')
                                              ]),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),

                                            /// ADD BUTTON
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15.0),
                                              child: FormButton(
                                                btnText: "Add",
                                                callback: () {},
                                              ),
                                            ),
                                          ],
                                        ),
                                        fillerSegmentTable(context),
                                      ],
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              }),
                        ),
                      ),
                      GetBuilder<HomeController>(
                          id: "buttons",
                          init: Get.find<HomeController>(),
                          builder: (btcontroller) {
                            if (btcontroller.buttons != null) {
                              return Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                ),
                                child: ButtonBar(
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
                                ),
                              );
                            }
                            return Container();
                          }),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget fillerDailyFPCTable(context) {
    return GetBuilder<FillerController>(
        id: "fillerFPCTable",
        // init: CreateBreakPatternController(),
        builder: (controller) {
          if (controllerX.fillerDailyFpcList != null &&
              (controllerX.fillerDailyFpcList?.isNotEmpty)!) {
            // final key = GlobalKey();
            return DataGridFromMap(
              showSrNo: true,
              mapData: (controllerX.fillerDailyFpcList
                  ?.map((e) => e.toJson())
                  .toList())!,
              showonly: [
                "programCode",
                "endTime",
                "programName",
                "epsNo",
                "tapeID",
                "episodeCaption"
              ],
              widthRatio: (Get.width * 0.2) / 2 + 7,
              mode: PlutoGridMode.selectWithOneTap,
              onSelected: (plutoGrid) {
                // controllerX.selectedFiller =
                //     controllerX.fillerDailyFpcList![plutoGrid.rowIdx!];
                print(jsonEncode(controllerX.fillerDailyFpcList!));
                //programCode, exportTapeCode, episodeNumber, originalRepeatCode, locationCode, channelCode, startTime, date
                controllerX.fetchSegmentDetails(
                    controllerX.fillerDailyFpcList![plutoGrid.rowIdx!]);
              },
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
                  height: Get.height - (4 * kToolbarHeight),
                ),
              ),
            );
          }
        });
  }

  Widget fillerSegmentTable(context) {
    return GetBuilder<FillerController>(
        id: "fillerSegmentTable",
        // init: CreateBreakPatternController(),
        builder: (controller) {
          if (controllerX.fillerSegmentList != null &&
              (controllerX.fillerSegmentList?.isNotEmpty)!) {
            // final key = GlobalKey();
            return Expanded(
              // height: 400,
              child: DataGridFromMap(
                mapData: (controllerX.fillerSegmentList
                    ?.map((e) => e.toJson())
                    .toList())!,
                widthRatio: (Get.width * 0.2) / 2 + 7,
                // mode: PlutoGridMode.select,
                onSelected: (plutoGrid) {
                  controllerX.selectedSegment =
                      controllerX.fillerSegmentList![plutoGrid.rowIdx!];
                  print(jsonEncode(controllerX.selectedSegment?.toJson()));
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
                  height: Get.height - (4 * kToolbarHeight),
                ),
              ),
            );
          }
        });
  }
}
